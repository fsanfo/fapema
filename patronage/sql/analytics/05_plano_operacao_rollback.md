# Plano de Operacao e Rollback — patronage_analytics

## 1. Implantacao inicial (deploy do zero)

Ordem obrigatoria (idempotente — pode ser reexecutada com seguranca em caso de duvida sobre o que ja rodou):

```sql
SOURCE 01_schema_setup.sql;
SOURCE 02_controle_auditoria.sql;
SOURCE 03_landing.sql;
SOURCE 04_dimensoes.sql;
SOURCE 05_fatos.sql;
SOURCE 06_pontes_excecoes.sql;
SOURCE 07_procedures_landing.sql;
SOURCE 08_procedures_dimensoes.sql;
SOURCE 09_procedures_fatos.sql;
SOURCE 10_procedures_reconciliacao.sql;
SOURCE 11_procedures_dq.sql;
SOURCE 13_orquestracao_d1.sql;
SOURCE 14_materializadas.sql;
SOURCE 15_views_paineis.sql;

-- Uma vez: povoar a dimensao de tempo (ajustar horizonte conforme necessario)
CALL sp_povoar_dim_tempo('2015-01-01', '2030-12-31');

-- Habilitar o scheduler global ANTES de rodar o script de eventos
SET GLOBAL event_scheduler = ON;
SOURCE 16_events_agendamento.sql;

-- Adicionar ao my.cnf para sobreviver a reinicializacoes:
--   [mysqld]
--   event_scheduler = ON
```

Apos o deploy, rodar a **primeira carga em modo `full`** manualmente (nao esperar o Event agendado), para popular a base inicial:
```sql
CALL sp_executar_carga_d1('full');
CALL sp_refresh_marts_d1();
```
A partir do dia seguinte, os Events assumem a execucao em modo `incremental`.

Configurar tambem o client SIGEF (`12_client_sigef.py`) como cron/systemd timer as 05:00, com as variaveis de ambiente descritas em `02_blueprint_fase2_etl.md`, secao 4.3.

## 2. Reprocessamento de um lote com problema

Cada execucao de `sp_executar_carga_d1` e isolada em um `id_lote`. Se um lote falhar ou terminar `concluido_com_erro`:

1. Diagnosticar a causa:
   ```sql
   SELECT * FROM ctl_lote_carga WHERE id_lote = <N>;
   SELECT * FROM ctl_log_execucao WHERE id_lote = <N> AND nivel IN ('warning','error');
   SELECT * FROM exc_qualidade_dados WHERE id_lote_carga = <N>;
   ```
2. Corrigir a causa raiz (dado de origem, permissao, espaco em disco, etc.) — **nunca** editar diretamente as tabelas fato/dimensao para "consertar" um numero; a correcao deve vir de uma nova execucao da procedure correspondente, preservando o rastro do lote anterior.
3. Reexecutar com seguranca (idempotente):
   ```sql
   CALL sp_executar_carga_d1('incremental');
   ```
   Ou, para forcar reprocessamento completo de um dominio especifico (ex.: apos correcao de um bug de mapeamento), chamar a procedure individual em modo `full`:
   ```sql
   CALL sp_lnd_carga_termo_parcelas_pagas(<novo_id_lote>, 'full');
   ```

## 3. Reprocessamento da reconciliacao para uma competencia especifica

Util quando uma ponte (`ponte_edital_sigef_subacao` ou `ponte_proponente_credor_sigef`) e validada/corrigida manualmente pela curadoria e a competencia precisa ser recalculada:
```sql
CALL sp_reconciliar_sigef_patronage(<id_lote_atual_ou_novo>, 202607); -- exemplo: julho/2026
CALL sp_refresh_mv_reconciliacao_atual();
```
Isso gera uma NOVA linha em `fato_reconciliacao_sigef_patronage` (preserva o historico anterior — ver decisao de design em `02_blueprint_fase2_etl.md`, secao 3.1) e atualiza o snapshot atual.

## 4. Validacao de uma ponte de curadoria antes de usar em producao

Toda ponte sugerida automaticamente nasce com `confiabilidade='baixa'` e
`responsavel_funcional='(PENDENTE_VALIDACAO_CURADORIA)'`. Fluxo de validacao manual:
```sql
UPDATE ponte_edital_sigef_subacao
SET confiabilidade = 'alta', responsavel_funcional = 'Nome do responsavel - matricula'
WHERE sk_ponte = <N>;
```
So depois disso a ponte passa a ser considerada em `sp_reconciliar_sigef_patronage` (que filtra `confiabilidade IN ('alta','media')`).

## 5. Rollback de schema (desfazer uma fase inteira)

Como todos os scripts sao aditivos e idempotentes, o rollback mais seguro e
**por camada**, na ordem inversa da dependencia:

```sql
-- Desfazer Fase 3
DROP EVENT IF EXISTS ev_carga_d1;
DROP EVENT IF EXISTS ev_refresh_marts_d1;
DROP VIEW IF EXISTS vw_painel_operacional_chamadas, vw_painel_operacional_processos,
    vw_painel_gerencial_convenios, vw_painel_conciliacao_atual, vw_painel_conciliacao_historico,
    vw_painel_conciliacao_excecoes, vw_painel_conciliacao_idade_divergencias,
    vw_painel_executivo_kpis_mensal, vw_painel_executivo_comparativo_anual;
DROP TABLE IF EXISTS mv_reconciliacao_atual, mv_kpi_executivo_mensal;

-- Desfazer Fase 2 (procedures - nao apaga dados)
DROP PROCEDURE IF EXISTS sp_executar_carga_d1, sp_refresh_marts_d1, sp_refresh_mv_reconciliacao_atual,
    sp_refresh_mv_kpi_executivo_mensal, sp_executar_regras_dq, sp_reconciliar_sigef_patronage,
    sp_bootstrap_ponte_proponente_credor_sigef, sp_sugerir_ponte_edital_subacao;
-- (demais sp_lnd_carga_*, sp_carga_dim_*, sp_carga_fato_* seguem o mesmo padrao)

-- Desfazer Fase 1 (CUIDADO: apaga todos os dados analiticos, nao o schema patronage original)
DROP SCHEMA IF EXISTS patronage_analytics;
```

**O schema `patronage` (transacional/origem) nunca e alterado por nenhum
script desta solucao** — o rollback mais radical (`DROP SCHEMA
patronage_analytics`) e sempre seguro em relacao ao sistema de origem, e o
schema analitico pode ser reconstruido do zero a qualquer momento a partir
dos scripts 01-16 mais uma carga `full`.

## 6. Backup recomendado antes de mudancas estruturais
```bash
mysqldump --routines --events --single-transaction patronage_analytics > backup_patronage_analytics_$(date +%Y%m%d).sql
```
`--routines --events` e essencial aqui, pois a maior parte do valor desta
solucao esta nas procedures e eventos, nao so nos dados.

## 7. Sinais de alerta operacional (monitorar diariamente)
```sql
-- Lotes com erro nas ultimas 24h
SELECT * FROM ctl_lote_carga WHERE status IN ('falhou','concluido_com_erro') AND dt_inicio >= NOW() - INTERVAL 1 DAY;

-- Violacoes de DQ bloqueantes ainda pendentes
SELECT rg.codigo, COUNT(*) FROM exc_qualidade_dados x
JOIN ctl_dq_regra rg ON rg.id_regra = x.id_regra
WHERE rg.severidade = 'bloqueante' AND x.status_tratativa = 'pendente'
GROUP BY rg.codigo;

-- Pontes ainda pendentes de curadoria (bloqueiam reconciliacao confiavel)
SELECT COUNT(*) FROM ponte_edital_sigef_subacao WHERE confiabilidade = 'baixa' AND flag_ativo = 1;

-- Ultima execucao dos Events
SELECT event_name, last_executed FROM information_schema.events WHERE event_schema = 'patronage_analytics';
```
