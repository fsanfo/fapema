# Verificacao de Aderencia para CA - patronage analytics

Data: 2026-07-17
Status geral: Aderente com ressalvas
Escopo analisado: patronage/sql/analytics (Fases 1 a 3)

## Conclusao executiva

Os artefatos ja implementam o nucleo de arquitetura esperado para CA:
- camadas landing -> curated -> marts/views
- modelo dimensional e reconciliacao SIGEF x Patronage
- orquestracao, DQ, materializadas, views, eventos e rollback

Aprovacao para CA com ressalvas, condicionada a decisoes de negocio e governanca abaixo.

## Riscos e ajustes necessarios

### 1) Governanca LGPD antes de producao
Severidade: alta
Risco: exposicao de identificadores pessoais (CPF e dados pessoais) em dimensoes e views sem mascaramento.
Ajuste recomendado:
- mascarar CPF nas views de consumo geral
- limitar campos pessoais em dim_usuario ao minimo necessario
- definir dono de decisao (DPO/area juridica) e politica de retencao de payload_raw

### 2) Regras de negocio pendentes que impactam KPI
Severidade: alta
Risco: metricas com classificacao potencialmente incorreta.
Ajuste recomendado:
- validar codigos de situacao de processos/termos com negocio
- validar regra de rateio de convenio_execucao com area financeira
- promover essas decisoes para tabela de parametrizacao de negocio em vez de hardcode

### 3) Integracao SIGEF com contrato de API incompleto
Severidade: media
Risco: falha operacional na carga externa por autenticacao/paginacao/filtros nao confirmados.
Ajuste recomendado:
- homologar contrato real de auth, paginacao e filtros incrementais
- adicionar teste de contrato e fallback operacional documentado

Atualizacao 2026-07-17 (pos protocolo FAPEMA):
- pendencia humana de acesso/credencial SIGEF considerada encerrada (protocolo realizado e user/pass recebidos)
- remanescente passa a ser atividade tecnica de homologacao operacional (smoke test, validacao de payload e ajuste fino de integracao)

### 4) Curadoria de pontes como dependencia operacional
Severidade: media
Risco: reconciliacao incompleta enquanto ponte edital-subacao permanecer com confiabilidade baixa.
Ajuste recomendado:
- formalizar SLA e responsavel por curadoria
- criar alerta operacional diario para pendencias de ponte

## Recomendacoes de mudanca (ordem sugerida)

1. Implementar versoes mascaradas das views de consumo (ou substituir colunas sensiveis diretamente nas vw_ atuais).
2. Criar tabela de parametros de negocio para mapeamento de status e regras de rateio.
3. Congelar contrato SIGEF e atualizar 12_client_sigef.py com o padrao oficial.
4. Definir runbook de curadoria de pontes com SLA e responsavel funcional.

## Solucoes inferidas por melhores praticas (executar por padrao)

### LGPD e minimizacao de dados
- Adotar mascaramento parcial de CPF em todas as views de consumo geral (mostrar apenas trechos minimos para identificacao visual).
- Manter dado completo somente em camada restrita por role (auditoria/financeiro), sem exposicao em views abertas.
- Aplicar minimizacao: retirar da camada analitica campos pessoais nao usados por KPI.
- Definir retencao padrao para payload_raw SIGEF (ex.: 12 meses online + historico frio com acesso controlado).

### Regras de negocio e estabilidade de KPI
- Externalizar mapeamentos de status para tabela de parametros versionada (sem hardcode em procedure).
- Externalizar regra de rateio de convenio para tabela de estrategia por vigencia (ex.: proporcional, integral, customizada).
- Introduzir trilha de mudanca de parametro (quem alterou, quando, justificativa) para auditoria.

### Integracao SIGEF
- Implementar retries com backoff exponencial + jitter, timeout por endpoint e circuit breaker simples por janela.
- Persistir checkpoint incremental por endpoint (ultima pagina/data/offset) para retomada segura.
- Criar validacao de contrato (schema basico de payload) antes de inserir em landing.
- Definir fallback operacional: em falha SIGEF, carga Patronage segue, reconciliacao marca dependencia externa.

### Operacao e observabilidade
- Padronizar alertas diarios: lote com erro, regra bloqueante DQ, ponte pendente acima de SLA.
- Definir SLO inicial: carga concluida ate 07:00 e refresh de marts ate 08:00.
- Publicar runbook unico de incidentes com passos de diagnostico e reprocessamento.

## Itens que exigem definicao humana (nao inferir automaticamente)

1. Dono formal da decisao LGPD (DPO/juridico) e nivel de mascaramento aceito por perfil.
2. Regra oficial de negocio para codigos de situacao de processo/termo.
3. Regra financeira oficial de rateio em convenio_execucao.
4. Responsavel funcional e SLA de curadoria de ponte edital-subacao.

## Criterio pratico de aceite para avancar ao CE

Avancar para CE com os itens inferidos como baseline tecnico e abrir historias de decisao para os cinco itens humanos, com prazo e responsavel nomeado.

## Decisao para workflow BMad

- CA: considerado concluido tecnicamente com ressalvas.
- Proximo passo recomendado: CE (Create Epics and Stories), incluindo historias especificas para:
  - governanca LGPD
  - parametrizacao de regras de negocio
  - robustez da integracao SIGEF
  - operacao de curadoria de pontes
