#!/usr/bin/env python3
"""
patronage_analytics | Script 12 - Client de integracao com a API SIGEF
Fase 2: ETL / Reconciliacao

PROPOSITO
---------
Popular as tabelas de Landing lnd_sigef_* (script 03) a partir da API SIGEF,
dentro da janela D+1 (05h-07h). O MySQL 8 nao faz chamadas HTTP nativamente
(sem UDFs de terceiros), entao esta etapa roda FORA do banco, como um job
Python agendado (cron/systemd timer/Airflow/etc.) que:

    1) autentica na API SIGEF
    2) pagina os endpoints priorizados (ordembancaria, ordemcronologica,
       credor, execucaofinanceiranl)
    3) grava o payload em lnd_sigef_* via INSERT ... ON DUPLICATE KEY UPDATE
       (idempotente, chave natural definida no script 03)
    4) registra o lote em ctl_lote_carga e o log em ctl_log_execucao,
       exatamente como as procedures de carga da Landing Patronage (script 07)

PENDENCIAS EXPLICITAS (a confirmar com a equipe responsavel pela integracao
SIGEF antes de produtizar este script):
    - Mecanismo de autenticacao real (endpoint, formato do token, tempo de
      expiracao). O layout abaixo assume OAuth2 client-credentials, que e o
      padrao mais comum em APIs de governo, mas isso NAO foi confirmado nos
      artefatos de entrada (sigef_api.json nao traz o endpoint de auth).
    - Paginacao real (parametro de pagina/tamanho de pagina e formato de
      resposta) - assumido "page"/"per_page" com resposta {"data": [...],
      "next_page": ...}; ajustar conforme o contrato real da API.
    - Filtro incremental real por data (assumido parametro "data_inicio"/
      "data_fim"); o mapeamento disponivel nao detalha se a API aceita filtro
      de data ou se e necessario paginar o dataset completo a cada execucao.
    - Ordem de volume: ordemcronologica e descrita no mapeamento como
      "acesso restrito" - confirmar permissao de uso antes de habilitar.

Este script e a base de partida; a integracao real exige o documento de
especificacao de autenticacao do SIGEF (nao incluido nos artefatos de
entrada desta rodada).
"""

import os
import sys
import json
import time
import logging
import datetime as dt
from dataclasses import dataclass, field
from typing import Iterator

import requests          # pip install requests
import mysql.connector   # pip install mysql-connector-python

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)
log = logging.getLogger("sigef_client")


# ============================================================================
# Configuracao (ler de variaveis de ambiente - nunca hardcodar credenciais)
# ============================================================================
@dataclass
class ConfigSigef:
    base_url: str = os.environ.get("SIGEF_BASE_URL", "https://api.sigef.exemplo.gov.br")
    auth_url: str = os.environ.get("SIGEF_AUTH_URL", "https://api.sigef.exemplo.gov.br/oauth/token")
    client_id: str = os.environ.get("SIGEF_CLIENT_ID", "")
    client_secret: str = os.environ.get("SIGEF_CLIENT_SECRET", "")
    timeout_s: int = int(os.environ.get("SIGEF_TIMEOUT_S", "30"))
    max_tentativas: int = int(os.environ.get("SIGEF_MAX_RETRIES", "5"))
    backoff_base_s: float = float(os.environ.get("SIGEF_BACKOFF_BASE_S", "2.0"))
    page_size: int = int(os.environ.get("SIGEF_PAGE_SIZE", "200"))


@dataclass
class ConfigMySQL:
    host: str = os.environ.get("MYSQL_HOST", "127.0.0.1")
    port: int = int(os.environ.get("MYSQL_PORT", "3306"))
    user: str = os.environ.get("MYSQL_USER", "patronage_etl")
    password: str = os.environ.get("MYSQL_PASSWORD", "")
    database: str = os.environ.get("MYSQL_DATABASE", "patronage_analytics")


# ============================================================================
# Autenticacao
# ============================================================================
class SigefAuth:
    """Gerencia o token de acesso, renovando automaticamente antes de expirar.

    ASSUNCAO: fluxo OAuth2 client_credentials. Ajustar conforme confirmacao
    da equipe de integracao SIGEF.
    """

    def __init__(self, cfg: ConfigSigef):
        self.cfg = cfg
        self._token: str | None = None
        self._expira_em: dt.datetime | None = None

    def token(self) -> str:
        if self._token is None or dt.datetime.now() >= self._expira_em:
            self._autenticar()
        return self._token

    def _autenticar(self):
        log.info("Autenticando na API SIGEF...")
        resp = requests.post(
            self.cfg.auth_url,
            data={
                "grant_type": "client_credentials",
                "client_id": self.cfg.client_id,
                "client_secret": self.cfg.client_secret,
            },
            timeout=self.cfg.timeout_s,
        )
        resp.raise_for_status()
        payload = resp.json()
        self._token = payload["access_token"]
        expira_em_segundos = payload.get("expires_in", 3600)
        # renova com folga de 60s antes do vencimento real
        self._expira_em = dt.datetime.now() + dt.timedelta(seconds=expira_em_segundos - 60)
        log.info("Autenticado. Token valido por ~%s segundos.", expira_em_segundos)


# ============================================================================
# Cliente HTTP com paginacao e retry/backoff exponencial
# ============================================================================
class SigefClient:
    def __init__(self, cfg: ConfigSigef, auth: SigefAuth):
        self.cfg = cfg
        self.auth = auth
        self.session = requests.Session()

    def _get_com_retry(self, url: str, params: dict) -> dict:
        ultima_excecao = None
        for tentativa in range(1, self.cfg.max_tentativas + 1):
            try:
                headers = {"Authorization": f"Bearer {self.auth.token()}"}
                resp = self.session.get(url, params=params, headers=headers, timeout=self.cfg.timeout_s)
                if resp.status_code == 401:
                    # token expirado/invalido - forca reautenticacao e tenta de novo
                    log.warning("HTTP 401 - forcando reautenticacao (tentativa %s)", tentativa)
                    self.auth._autenticar()
                    continue
                resp.raise_for_status()
                return resp.json()
            except (requests.ConnectionError, requests.Timeout, requests.HTTPError) as exc:
                ultima_excecao = exc
                espera = self.cfg.backoff_base_s * (2 ** (tentativa - 1))
                log.warning("Falha na chamada (tentativa %s/%s): %s - aguardando %.1fs",
                            tentativa, self.cfg.max_tentativas, exc, espera)
                time.sleep(espera)
        raise RuntimeError(f"Falha apos {self.cfg.max_tentativas} tentativas em {url}") from ultima_excecao

    def paginar(self, endpoint: str, params_extra: dict) -> Iterator[dict]:
        """Gera registros de um endpoint, paginando ate esgotar os resultados.

        ASSUNCAO de contrato de paginacao - ajustar aos nomes reais de campo
        retornados pela API SIGEF quando confirmados.
        """
        pagina = 1
        while True:
            params = {"page": pagina, "per_page": self.cfg.page_size, **params_extra}
            url = f"{self.cfg.base_url.rstrip('/')}/{endpoint.strip('/')}/"
            corpo = self._get_com_retry(url, params)
            registros = corpo.get("data", [])
            if not registros:
                break
            for registro in registros:
                yield registro
            if not corpo.get("next_page"):
                break
            pagina += 1


# ============================================================================
# Persistencia (Landing) - upsert idempotente + controle de lote/log
# ============================================================================
class LandingWriter:
    def __init__(self, cfg: ConfigMySQL):
        self.cfg = cfg
        self.conn = mysql.connector.connect(
            host=cfg.host, port=cfg.port, user=cfg.user,
            password=cfg.password, database=cfg.database,
        )

    def abrir_lote(self, dominio: str) -> int:
        cur = self.conn.cursor()
        cur.execute(
            """INSERT INTO ctl_lote_carga (dominio, camada, data_referencia, dt_inicio, status)
               VALUES (%s, 'landing', CURDATE(), NOW(), 'iniciado')""",
            (dominio,),
        )
        self.conn.commit()
        id_lote = cur.lastrowid
        cur.close()
        return id_lote

    def fechar_lote(self, id_lote: int, status: str, qtd_lida: int, qtd_inserida: int, qtd_rejeitada: int):
        cur = self.conn.cursor()
        cur.execute(
            """UPDATE ctl_lote_carga
               SET status=%s, dt_fim=NOW(), qtd_lida=%s, qtd_inserida=%s, qtd_rejeitada=%s
               WHERE id_lote=%s""",
            (status, qtd_lida, qtd_inserida, qtd_rejeitada, id_lote),
        )
        self.conn.commit()
        cur.close()

    def log(self, id_lote: int, etapa: str, nivel: str, mensagem: str):
        cur = self.conn.cursor()
        cur.execute(
            """INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem) VALUES (%s,%s,%s,%s)""",
            (id_lote, etapa, nivel, mensagem),
        )
        self.conn.commit()
        cur.close()

    def upsert_ordembancaria(self, id_lote: int, registros: list[dict]) -> int:
        sql = """
            INSERT INTO lnd_sigef_ordembancaria
                (numero_ordem_bancaria, cdsubacao, nuprocesso, dtpagamento, dttransacao,
                 vltotal, domicilio_origem, domicilio_destino, cdcredor, nmcredor,
                 cdsituacaoordembancaria, payload_raw, id_lote_carga)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            ON DUPLICATE KEY UPDATE
                cdsubacao=VALUES(cdsubacao), nuprocesso=VALUES(nuprocesso),
                dtpagamento=VALUES(dtpagamento), dttransacao=VALUES(dttransacao),
                vltotal=VALUES(vltotal), domicilio_origem=VALUES(domicilio_origem),
                domicilio_destino=VALUES(domicilio_destino), cdcredor=VALUES(cdcredor),
                nmcredor=VALUES(nmcredor), cdsituacaoordembancaria=VALUES(cdsituacaoordembancaria),
                payload_raw=VALUES(payload_raw), id_lote_carga=VALUES(id_lote_carga),
                dt_carga=CURRENT_TIMESTAMP
        """
        linhas = [
            (
                r.get("numeroOrdemBancaria"), r.get("cdSubacao"), r.get("nuProcesso"),
                r.get("dtPagamento"), r.get("dtTransacao"), r.get("vlTotal"),
                r.get("domicilioOrigem"), r.get("domicilioDestino"), r.get("cdCredor"),
                r.get("nmCredor"), r.get("cdSituacaoOrdemBancaria"),
                json.dumps(r, ensure_ascii=False), id_lote,
            )
            for r in registros
        ]
        return self._executemany(sql, linhas)

    def upsert_credor(self, id_lote: int, registros: list[dict]) -> int:
        sql = """
            INSERT INTO lnd_sigef_credor (cdcredor, cpf_cnpj, nome_credor, payload_raw, id_lote_carga)
            VALUES (%s,%s,%s,%s,%s)
            ON DUPLICATE KEY UPDATE
                cpf_cnpj=VALUES(cpf_cnpj), nome_credor=VALUES(nome_credor),
                payload_raw=VALUES(payload_raw), id_lote_carga=VALUES(id_lote_carga),
                dt_carga=CURRENT_TIMESTAMP
        """
        linhas = [
            (r.get("cdCredor"), r.get("cpfCnpj"), r.get("nomeCredor"),
             json.dumps(r, ensure_ascii=False), id_lote)
            for r in registros
        ]
        return self._executemany(sql, linhas)

    def upsert_ordemcronologica(self, id_lote: int, registros: list[dict]) -> int:
        sql = """
            INSERT INTO lnd_sigef_ordemcronologica (cpf_cnpj, valor_pago, data_pagamento, payload_raw, id_lote_carga)
            VALUES (%s,%s,%s,%s,%s)
            ON DUPLICATE KEY UPDATE
                payload_raw=VALUES(payload_raw), id_lote_carga=VALUES(id_lote_carga),
                dt_carga=CURRENT_TIMESTAMP
        """
        linhas = [
            (r.get("cpfCnpj"), r.get("valorPago"), r.get("dataPagamento"),
             json.dumps(r, ensure_ascii=False), id_lote)
            for r in registros
        ]
        return self._executemany(sql, linhas)

    def upsert_execucaofinanceiranl(self, id_lote: int, registros: list[dict]) -> int:
        sql = """
            INSERT INTO lnd_sigef_execucaofinanceiranl (numero_nl, cdsubacao, valor_nl, valor_pago, payload_raw, id_lote_carga)
            VALUES (%s,%s,%s,%s,%s,%s)
            ON DUPLICATE KEY UPDATE
                cdsubacao=VALUES(cdsubacao), valor_nl=VALUES(valor_nl), valor_pago=VALUES(valor_pago),
                payload_raw=VALUES(payload_raw), id_lote_carga=VALUES(id_lote_carga),
                dt_carga=CURRENT_TIMESTAMP
        """
        linhas = [
            (r.get("numeroNl"), r.get("cdSubacao"), r.get("valorNl"), r.get("valorPago"),
             json.dumps(r, ensure_ascii=False), id_lote)
            for r in registros
        ]
        return self._executemany(sql, linhas)

    def _executemany(self, sql: str, linhas: list[tuple]) -> int:
        if not linhas:
            return 0
        cur = self.conn.cursor()
        cur.executemany(sql, linhas)
        self.conn.commit()
        qtd = cur.rowcount
        cur.close()
        return qtd

    def close(self):
        self.conn.close()


# ============================================================================
# Orquestracao de uma execucao completa (chamada pelo agendador do lote D+1)
# ============================================================================
ENDPOINTS = {
    "ordembancaria": "upsert_ordembancaria",
    "credor": "upsert_credor",
    "ordemcronologica": "upsert_ordemcronologica",
    "execucaofinanceiranl": "upsert_execucaofinanceiranl",
}


def executar_carga_sigef(data_inicio: str, data_fim: str) -> None:
    cfg_sigef = ConfigSigef()
    cfg_mysql = ConfigMySQL()
    auth = SigefAuth(cfg_sigef)
    client = SigefClient(cfg_sigef, auth)
    writer = LandingWriter(cfg_mysql)

    for endpoint, metodo_upsert in ENDPOINTS.items():
        id_lote = writer.abrir_lote(f"sigef_{endpoint}")
        qtd_lida = qtd_inserida = qtd_rejeitada = 0
        try:
            log.info("Iniciando carga do endpoint /%s/ (lote %s)", endpoint, id_lote)
            lote_registros: list[dict] = []
            for registro in client.paginar(endpoint, {"data_inicio": data_inicio, "data_fim": data_fim}):
                lote_registros.append(registro)
                qtd_lida += 1
                if len(lote_registros) >= 500:
                    qtd_inserida += getattr(writer, metodo_upsert)(id_lote, lote_registros)
                    lote_registros = []
            if lote_registros:
                qtd_inserida += getattr(writer, metodo_upsert)(id_lote, lote_registros)

            writer.fechar_lote(id_lote, "concluido", qtd_lida, qtd_inserida, qtd_rejeitada)
            writer.log(id_lote, f"sigef_client_{endpoint}", "info",
                       f"Lidos: {qtd_lida}, upsert: {qtd_inserida}")
            log.info("Endpoint /%s/ concluido: %s lidos, %s upsert", endpoint, qtd_lida, qtd_inserida)

        except Exception as exc:  # noqa: BLE001 - lote deve fechar mesmo em erro
            log.exception("Falha na carga do endpoint /%s/", endpoint)
            writer.fechar_lote(id_lote, "falhou", qtd_lida, qtd_inserida, qtd_lida - qtd_inserida)
            writer.log(id_lote, f"sigef_client_{endpoint}", "error", str(exc))
            # decisao de design: uma falha em um endpoint NAO interrompe os
            # demais - cada endpoint tem seu proprio lote/rastreabilidade.
            continue

    writer.close()


if __name__ == "__main__":
    # Uso tipico dentro da janela D+1 (05h-07h): carrega o dia anterior.
    ontem = (dt.date.today() - dt.timedelta(days=1)).isoformat()
    hoje = dt.date.today().isoformat()
    data_inicio = sys.argv[1] if len(sys.argv) > 1 else ontem
    data_fim = sys.argv[2] if len(sys.argv) > 2 else hoje
    log.info("Executando carga SIGEF para o periodo %s a %s", data_inicio, data_fim)
    executar_carga_sigef(data_inicio, data_fim)
