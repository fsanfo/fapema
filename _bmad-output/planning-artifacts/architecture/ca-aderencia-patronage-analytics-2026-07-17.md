# Verificacao de Aderencia para CA - patronage analytics

Data: 2026-07-17
Status geral: Aderente com ressalvas
Escopo analisado: patronage/sql/analytics (Fases 1 a 3)

Atualizacao 2026-07-21: bloco "Complemento arquitetural para FR5 e FR6" reescrito para refletir o reescopo do Ciclo 1 (2 paineis prioritarios, fronteira de entrega termina na camada semantica do DW, UI fica com a equipe do Patronage). Ver `sprint-change-proposal-2026-07-21.md` Secao 4.2. Restante do documento (LGPD, regras de negocio, integracao SIGEF, curadoria de pontes) permanece sem alteracao.

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

## Complemento arquitetural para FR5 e FR6 (contrato de dados para consumo do Patronage)

> **Reescopo 2026-07-21**: bloco reescrito por decisao do patrocinador/PO — ver `change-trigger-reescopo-paineis-2026-07-21.md` e `sprint-change-proposal-2026-07-21.md` (Secao 4.2). A versao anterior (entrega de camada web em Laravel, 4 paineis) fica preservada no historico do git; este bloco e a versao vigente.

### Objetivo

Fechar explicitamente a arquitetura da camada semantica do Data Warehouse que expoe o contrato de dados para os dois paineis prioritarios do ciclo 1 (Conciliacao e Executivo), a ser consumido pela equipe que ja mantem o Patronage na implementacao da UI em Laravel.

### Decisao arquitetural

- A responsabilidade deste time termina nas views/marts de consumo da camada semantica; nao ha entrega de camada web, rotas ou componentes Laravel por este time.
- A equipe do Patronage e responsavel pela definicao e implementacao da UI final em Laravel, consumindo o contrato de dados exposto por este projeto.
- Os mockups V2 funcionam como contrato de referencia de segmentadores, filtros e desagregacoes para a equipe do Patronage; nao sao mais especificacao de tela a ser implementada por este time.

### Modelo de contrato de dados exposto

- Views/marts dedicadas para os dois paineis prioritarios do ciclo 1: Conciliacao e Executivo.
- Schema documentado por view: colunas, granularidade, segmentadores principais/secundarios e regra de calculo de cada indicador (ver "Schema formal das views expostas" abaixo).
- Nomenclatura e versionamento de views estaveis o suficiente para consumo externo, com trilha de mudanca quando o contrato evoluir.
- Paineis Operacional e Gerencial: contrato de dados nao priorizado neste ciclo; retomar a partir das views ja mapeadas (`vw_painel_operacional_*`, `vw_painel_gerencial_convenios`) quando o ciclo futuro for iniciado.

### Schema formal das views expostas

As views abaixo ja estao implementadas em `patronage/sql/analytics/15_views_paineis.sql` (camada "presentation" do blueprint, script 00) e sao ratificadas aqui como o contrato formal de dados do ciclo 1 — nenhuma coluna nova foi inferida, a lista reflete o `SELECT` real de cada view.

**Conciliacao SIGEF x Patronage**

| View | Fonte | Colunas | Uso |
|---|---|---|---|
| `vw_painel_conciliacao_atual` | `mv_reconciliacao_atual` (materializada, ja resolve "ultimo lote por chave") | `id_edital_origem`, `edital`, `documento_proponente`, `nome_proponente`, `ano_mes_competencia`, `valor_patronage`, `valor_sigef`, `diferenca_valor`, `status_patronage`, `status_sigef`, `flag_divergencia`, `tipo_divergencia`, `id_lote_carga_origem`, `dt_atualizacao` | Consumo principal do painel (estado atual) |
| `vw_painel_conciliacao_historico` | `fato_reconciliacao_sigef_patronage` (preserva todas as execucoes) | `id_edital_origem`, `edital`, `documento_proponente`, `nome_proponente`, `ano_mes_competencia`, `valor_patronage`, `valor_sigef`, `diferenca_valor`, `status_patronage`, `status_sigef`, `flag_divergencia`, `tipo_divergencia`, `id_lote_carga`, `data_lote`, `dt_conciliacao` | Auditoria / drill-down por lote |
| `vw_painel_conciliacao_excecoes` | `exc_reconciliacao_sigef_patronage` | `id_excecao`, `tipo_excecao`, `edital`, `documento_proponente`, `nome_proponente`, `ano_mes_competencia`, `valor_patronage`, `valor_sigef`, `status_patronage`, `status_sigef`, `status_tratativa`, `responsavel_curadoria`, `dt_identificacao`, `dt_tratativa`, `dias_em_aberto` | Fila de curadoria (FR-4) |
| `vw_painel_conciliacao_idade_divergencias` | `exc_reconciliacao_sigef_patronage` (agregada) | `faixa_idade`, `qtd_casos`, `valor_total` | Indicador de velocidade de resolucao |

**Executivo (KPIs institucionais)**

| View | Fonte | Colunas | Uso |
|---|---|---|---|
| `vw_painel_executivo_kpis_mensal` | `mv_kpi_executivo_mensal` | `ano_mes`, `ano`, `mes`, `qtd_editais_publicados`, `qtd_convenios_firmados`, `valor_investimento_total`, `tempo_medio_ciclo_chamadas`, `qtd_divergencias_abertas`, `valor_divergencias_abertas`, `qtd_processos_recebidos`, `qtd_processos_aprovados`, `pct_aprovacao`, `dt_atualizacao` | Serie mensal (tendencia multitemporal) |
| `vw_painel_executivo_comparativo_anual` | Agregada a partir da view mensal acima | `ano`, `qtd_editais_publicados_ano`, `qtd_convenios_firmados_ano`, `valor_investimento_total_ano`, `tempo_medio_ciclo_chamadas_ano`, `qtd_processos_recebidos_ano`, `qtd_processos_aprovados_ano` | Comparativo ano a ano |

Convencao ja aplicada nas 9 views existentes e vinculante para qualquer nova view do contrato: nenhuma `sk_*` (chave tecnica) exposta como coluna principal, sempre resolvida para nome/descricao via dimensao.

### Contrato entre views e camada de consumo (Patronage)

- As views nao devem exigir que a UI calcule KPI critico; os indicadores devem chegar prontos ou quase prontos, com regra de negocio centralizada no analytics.
- Cada view deve expor rastreabilidade minima de periodo, lote, status e regra de calculo.
- A view de conciliacao deve expor, alem dos agregados, o status operacional do ultimo lote para distinguir resultado consolidado de resultado parcial, falho ou dependente de fonte externa.
- Decisoes de homologacao (aprovado/ressalvas/reprovado/pendente) por criterio e por painel podem continuar sendo persistidas em estrutura rastreavel a ser definida junto com a equipe do Patronage; este time garante apenas a origem dos dados usados nessa decisao.

### Requisitos de UX preservados como referencia para o time do Patronage

Os itens abaixo pertencem ao artefato de UX e a implementacao da UI; sao listados aqui apenas como referencia de contrato a comunicar a equipe do Patronage, sem serem requisito arquitetural deste time: shell e navegacao (sidebar, breadcrumb, meta pills), acessibilidade (`lang` pt-BR, skip link, foco visivel, navegacao por teclado), responsividade (desktop/mobile, tabelas densas) e comportamento de filtro sem recarregamento inconsistente.

### SLA de consulta do contrato de dados

- Target ratificado a partir do criterio de aceite ja definido em `06_criterios_aceite_validacao.md` (Secao 5, criterios transversais): toda consulta as views do contrato deve responder em **menos de 2 segundos** com o volume real do `patronage`.
- Status de validacao: os testes existentes cobrem apenas volume sintetico minimo; um teste de carga com a volumetria real (centenas de milhares de processos/pagamentos, conforme `volumetria.md`) e pendente antes de producao — em especial para `fato_eventos_operacionais_diario` e as procedures de reconciliacao (`GROUP BY`/`ROW_NUMBER()`), que se beneficiam de indices adicionais dependendo do volume observado. Este teste de carga e pre-requisito do handoff formal para o Patronage, nao apenas recomendacao.
- Frescor do dado: o contrato segue a orquestracao D+1 ja implementada (`13_orquestracao_d1.sql`). Um painel do dia so deve ser tratado como confiavel pela UI do Patronage quando `ctl_lote_carga` do dominio `orquestracao_d1` para `data_referencia = CURDATE()` estiver `concluido` ou `concluido_com_erro` (nunca `iniciado` residual) — mesmo criterio ja usado nos testes de aceite internos.
- O painel executivo deve poder sustentar walkthrough de leitura em ate 5 minutos; isso reforca a prioridade por consultas agregadas e payload enxuto nas views expostas (ja refletido no schema acima: series pre-agregadas mensal/anual, sem necessidade de agregacao em tela).

### Estrategia de dados para consumo do Patronage

- View de conciliacao: dataset reconciliado com classificacao de divergencia, referencia de lote D+1, data de carga, quantidade conciliada e flag de dependencia externa.
- View executiva: visao agregada de KPIs institucionais com tendencias e semaforizacao precomputadas sempre que possivel.

### Observabilidade da camada de dados exposta

- Cada view critica deve registrar versao do lote ou timestamp de atualizacao para exibicao pela UI do Patronage.
- Quando o dado exposto estiver bloqueado por regra de qualidade ou dependencia externa, a view deve explicitar o motivo (nao apenas omitir o dado), para que a UI evite leitura enganosa de consolidado.
- Sinalizacao de erro de carregamento e log tecnico de falha de UI passam a ser responsabilidade da equipe do Patronage.

### Gate de implementacao

- A implementacao de FR5 e FR6 pode prosseguir com esta arquitetura como baseline.
- O aceite final do contrato de dados permanece condicionado a homologacao formal dos dois paineis prioritarios (Conciliacao, Executivo) pelos aprovadores definidos no PRD e pela equipe do Patronage, e ao teste de carga com volume real descrito acima.
- Qualquer divergencia entre mockup de referencia e contrato de dados exposto deve ser reconciliada no artefato de UX antes do aceite final.

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
