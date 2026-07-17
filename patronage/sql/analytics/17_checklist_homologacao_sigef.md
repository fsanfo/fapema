# Checklist Tecnico de Homologacao SIGEF — uso continuo durante desenvolvimento

Data base: 2026-07-17
Escopo: validar integracao SIGEF no fluxo do patronage_analytics sem bloquear desenvolvimento incremental.

## Objetivo

Padronizar o teste da integracao SIGEF em ciclos curtos, com evidencias objetivas para:
- detectar regressao cedo
- garantir idempotencia e consistencia de carga
- separar falha de credencial/infra de falha de regra de negocio

## Como usar no dia a dia

- Daily smoke (obrigatorio): itens P0 e P1 antes de merge.
- Semana de integracao: executar P2 e P3 completos.
- Gate de release: todos os itens P0-P3 aprovados.

## P0 — Pre-flight de ambiente (bloqueante)

- [ ] Variaveis de ambiente preenchidas no runner de homologacao:
  - SIGEF_BASE_URL
  - SIGEF_AUTH_URL
  - SIGEF_CLIENT_ID
  - SIGEF_CLIENT_SECRET
  - MYSQL_HOST
  - MYSQL_PORT
  - MYSQL_USER
  - MYSQL_PASSWORD
  - MYSQL_DATABASE
- [ ] Segredo nao versionado em arquivo do repositorio.
- [ ] Conectividade HTTPS ao host SIGEF validada no ambiente de execucao.
- [ ] Conectividade MySQL validada para schema patronage_analytics.
- [ ] Permissao de INSERT/UPDATE nas tabelas lnd_sigef_* confirmada.

Critério de aceite P0:
- ambiente apto sem erro de credencial, DNS ou permissao.

## P1 — Smoke tecnico rapido (obrigatorio no desenvolvimento)

- [ ] Autenticacao retorna token valido.
- [ ] Cada endpoint prioritario responde com sucesso:
  - ordembancaria
  - ordemcronologica
  - credor
  - execucaofinanceiranl
- [ ] Carga de 1 lote curta executa sem excecao fatal.
- [ ] Pelo menos 1 linha inserida/atualizada em alguma lnd_sigef_*.
- [ ] ctl_log_execucao registra inicio/fim da execucao.

Critério de aceite P1:
- pipeline SIGEF executa de ponta a ponta no modo smoke.

## P2 — Consistencia e idempotencia (semanal)

- [ ] Reexecutar o mesmo intervalo de dados duas vezes.
- [ ] Confirmar ausencia de duplicacao logica nas lnd_sigef_*.
- [ ] Confirmar que upsert atualiza registros alterados sem multiplicar linhas.
- [ ] Validar checkpoint incremental: nova execucao busca apenas delta.
- [ ] Confirmar que payload_raw permanece rastreavel para auditoria tecnica.

Consultas de verificacao recomendadas:

1) Volumetria por tabela landing SIGEF antes/depois de reexecucao
2) Busca de duplicidade pela chave natural definida em cada tabela
3) Verificacao de logs por id_lote e etapa

Critério de aceite P2:
- segunda execucao do mesmo recorte nao inflaciona contagem.

## P3 — Resiliencia e degradacao controlada (semanal)

- [ ] Simular timeout/rede intermitente e validar retry com backoff.
- [ ] Simular falha de endpoint unico e validar isolamento de erro.
- [ ] Confirmar fallback operacional:
  - carga Patronage continua
  - reconciliacao sinaliza dependencia externa
- [ ] Confirmar mensagens de erro acionaveis no log (sem erro generico).
- [ ] Confirmar retomada limpa apos incidente sem retrabalho manual pesado.

Critério de aceite P3:
- falhas externas nao quebram irreversivelmente o fluxo diario.

## P4 — Qualidade de dados e contrato (a cada mudanca de API)

- [ ] Validar campos obrigatorios minimos por endpoint.
- [ ] Detectar mudanca de schema de payload antes de persistir.
- [ ] Conferir parsing de valores monetarios e datas.
- [ ] Conferir normalizacao de identificadores para reconciliacao.
- [ ] Atualizar mapeamento e testes quando o provedor alterar contrato.

Critério de aceite P4:
- nenhuma quebra silenciosa de contrato passa despercebida.

## Evidencias minimas por execucao

Registrar em anexo de homologacao:
- data/hora da execucao
- ambiente (dev/hml)
- hash do commit
- resultado por bloco P0-P4
- id_lote gerado
- consultas de conferência com resultado resumido
- incidentes encontrados e acao corretiva

## Definicao de pronto para o time (durante desenvolvimento)

Uma branch com alteracao na integracao SIGEF pode ser considerada pronta para revisao quando:
- P0 e P1 aprovados
- sem regressao de idempotencia no recorte testado
- logs com diagnostico suficiente para suporte
- evidencia anexada no PR

## Definicao de pronto para release

- P0, P1, P2 e P3 aprovados
- P4 aprovado para versao de contrato em vigor
- sem bloqueio aberto de seguranca/credencial
- runbook atualizado com aprendizados da rodada
