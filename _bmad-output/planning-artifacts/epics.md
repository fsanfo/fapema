---
stepsCompleted:
  - step-01-validate-prerequisites
  - step-02-design-epics
  - step-03-create-stories
  - step-04-final-validation
inputDocuments:
  - _bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md
  - _bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md
  - _bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md
  - patronage/docs/html/mockups/v2/index.html
  - patronage/docs/html/mockups/v2/dashboard.css
  - patronage/docs/html/mockups/v2/painel-operacional-chamadas-editais.html
  - patronage/docs/html/mockups/v2/painel-gerencial-convenios-execucao.html
  - patronage/docs/html/mockups/v2/painel-conciliacao-sigef-patronage.html
  - patronage/docs/html/mockups/v2/painel-executivo-kpis.html
  - patronage/docs/html/mockups/v2/checklist-homologacao.html
---

# fapema - Epic Breakdown

## Overview

This document provides the complete epic and story breakdown for fapema, decomposing the requirements from the PRD, UX Design if it exists, and Architecture requirements into implementable stories.

## Requirements Inventory

### Functional Requirements

FR1: Inventariar entidades e relacionamentos prioritarios de Patronage e SIGEF, com origem, periodicidade, dono funcional e regra de correlacao por chave composta ID edital + CPF do proponente.
FR2: Definir Star Schema inicial com fatos e dimensoes conformadas para indicadores prioritarios e conciliacao financeira, incluindo granularidade mensal, trimestral, semestral e anual.
FR3: Executar cargas ETL recorrentes (D+1) para camada Curated com logs de execucao, origem de lote e contagem de registros processados.
FR4: Validar qualidade de dados por lote (integridade, completude, consistencia e batimento financeiro), classificar divergencias e tratar excecoes de mapeamento.
FR5: Entregar contrato de dados homologado (views/marts na camada semantica do DW) para os paineis prioritarios do ciclo 1 - Conciliacao (prioridade principal) e Executivo (prioridade secundaria) - para consumo da equipe do Patronage na implementacao da UI Laravel.
FR6: Manter os mockups HTML V2 como contrato de referencia de segmentadores, filtros e desagregacoes para a equipe do Patronage, responsavel pela definicao e implementacao da UI definitiva.

### NonFunctional Requirements

NFR1: Conformidade LGPD obrigatoria, incluindo minimizacao de dados pessoais e mascaramento/pseudonimizacao conforme politicas institucionais vigentes.
NFR2: Operacao em infraestrutura on-premises da instituicao, aderente ao contexto tecnico atual.
NFR3: Compatibilidade com stack atual (Laravel 12 para consumo e MySQL 8.0.34 para persistencia analitica).
NFR4: Janela operacional ETL D+1: inicio as 05:00, conclusao de carga ate 07:00 e disponibilizacao curada ate 08:00.
NFR5: Desempenho de consulta dos paineis com navegacao fluida por filtros sem recarregamento inconsistente.
NFR6: Qualidade de dados rastreavel por trilha de auditoria de lotes (status, horario, volume processado, rejeicoes e divergencias).
NFR7: Confiabilidade dos indicadores com divergencia maxima de 1% em relacao a camada Curated para criterios homologatorios aplicaveis.
NFR8: Seguranca e controle de acesso para impedir exposicao de dados a usuarios nao autorizados.
NFR9: Observabilidade operacional com alertas para falha de lote, regra bloqueante de qualidade e pendencias de ponte acima de SLA.
NFR10: Resiliencia da integracao SIGEF com retries, timeout por endpoint, checkpoint incremental e fallback operacional documentado.
NFR11: Governanca de regras de negocio e KPI por parametrizacao versionada e trilha de mudancas auditavel.
NFR12: Usabilidade executiva: leitura de KPIs institucionais prioritarios em ate 5 minutos em walkthrough de homologacao.

### Additional Requirements

- Nao foi identificado no documento de arquitetura um starter template de projeto para greenfield; assumir continuidade sobre base existente.
- Implementar mascaramento parcial de CPF em views de consumo geral e restringir dados completos por perfil/role.
- Limitar atributos pessoais em dimensoes analiticas (ex.: dim_usuario) ao minimo necessario para KPI.
- Definir e aplicar politica de retencao para payload_raw do SIGEF com acesso controlado.
- Externalizar mapeamentos de status e regras de rateio em tabelas de parametros versionadas (evitar hardcode).
- Manter trilha de alteracoes de parametros (quem alterou, quando, justificativa) para auditoria.
- Homologar contrato tecnico SIGEF (autenticacao, paginacao, filtros incrementais) e adicionar teste de contrato.
- Implementar estrategia de resiliencia na integracao SIGEF: retry com backoff+jitter, timeout, checkpoint de retomada e fallback.
- Formalizar runbook operacional unico para incidentes, diagnostico e reprocessamento.
- Definir SLO operacional inicial: carga ate 07:00 e refresh de marts ate 08:00.
- Definir SLA e responsavel funcional para curadoria da ponte edital-subacao/processo.
- Criar alerta diario para pendencias de curadoria da ponte acima do SLA.
- As historias 1.5 a 1.8 cobrem governanca LGPD, parametrizacao de regras de negocio, robustez da integracao SIGEF e operacao de curadoria de pontes.
- Registrar como dependencias humanas de decisao: dono formal LGPD, regra oficial de status, regra oficial de rateio, dono/SLA da curadoria.
- [Reescopo 2026-07-21] Fronteira de responsabilidade: a entrega deste time termina na camada semantica do DW (views/contratos de dados homologados); a equipe do Patronage assume a definicao e implementacao da UI Laravel a partir dos mockups V2 como contrato de referencia.
- Definir SLA de consulta das views de Conciliacao e Executivo junto com a equipe do Patronage, ja que a experiencia final de filtro sem recarregamento depende da performance da camada exposta.
- Executar teste de carga com volumetria real (centenas de milhares de registros) como pre-requisito do handoff formal, com atencao a `fato_eventos_operacionais_diario` e as procedures de reconciliacao.
- Um painel do dia so deve ser tratado como confiavel pela UI do Patronage quando `ctl_lote_carga` do dominio `orquestracao_d1` para a data de referencia estiver `concluido` ou `concluido_com_erro`.
- Views criticas devem registrar versao do lote/timestamp de atualizacao e explicitar o motivo quando o dado estiver bloqueado por regra de qualidade ou dependencia externa (nao apenas omitir o dado).
- Sinalizacao de erro de carregamento e log tecnico de falha de UI passam a ser responsabilidade da equipe do Patronage.
- Paineis Operacional e Gerencial: contrato de dados nao priorizado neste ciclo; views ja mapeadas (`vw_painel_operacional_*`, `vw_painel_gerencial_convenios`) ficam disponiveis para retomada em ciclo futuro.

### UX Design Requirements

UX-DR1: Consolidar os design tokens de marca e interface em CSS compartilhado (cores institucionais, estados semanticos, tipografia, raios, sombras e espacamentos) e eliminar divergencia entre paginas.
UX-DR2: Implementar shell de navegacao consistente em todos os paineis com sidebar fixa, indice de navegacao entre telas, breadcrumb contextual e metadata pills de status.
UX-DR3: Garantir acessibilidade base em todas as telas com `lang` pt-BR, skip link funcional, foco visivel com alto contraste e navegacao completa por teclado.
UX-DR4: Implementar padrao de filtros por chips com estados `default/hover/active`, separadores visuais e feedback claro da combinacao de filtros aplicada.
UX-DR5: Padronizar componentes de visualizacao executiva (hero, metric-card, card-head, legendas e tabelas) com semantica visual coerente para operacao, gerencia, conciliacao e C-Level.
UX-DR6: Implementar componente de checklist de homologacao com decisoes por item (`aprovado`, `ressalvas`, `reprovado`, `pendente`) e resumo agregado atualizado automaticamente.
UX-DR7: Aplicar sistema de estados semanticos reutilizavel (sucesso, alerta, risco, informacao) em botoes, chips, badges e tabelas, evitando dependencia exclusiva de cor.
UX-DR8: Garantir responsividade das telas V2 para desktop e mobile com quebras previstas (ex.: grids de resumo e distribuicao de colunas), mantendo legibilidade e acao principal acessivel.
UX-DR9: Estruturar padrao de tabelas de dados com cabecalhos claros, largura minima controlada, rolagem horizontal segura e hierarquia visual para leitura rapida.
UX-DR10: Preservar direcao de linguagem visual editorial definida nos mockups V2 (papel quente, vidro, acento terracota, League Spartan + Poppins), evitando regressao para UI generica.
UX-DR11: [Reescopo 2026-07-21] Priorizar consistencia de rotulagem e navegacao cruzada entre os paineis prioritarios do ciclo 1 (Conciliacao, Executivo) e o checklist; Operacional e Gerencial permanecem documentados como referencia, mas fora do ciclo 1.
UX-DR12: [Reescopo 2026-07-21] Documentar (nao implementar) os criterios de homologacao por painel como contrato verificavel - filtros obrigatorios, KPIs minimos, regras de semaforizacao e trilha de evidencias - a ser comunicado formalmente a equipe do Patronage.
UX-DR13: [Novo 2026-07-21] A validacao final de aderencia da UI implementada pelo Patronage ao contrato de referencia (shell, tokens, foco/skip-link, responsividade, sinalizacao de status parcial, rotulagem) e responsabilidade dessa equipe; este time entrega apenas a referencia documentada.

### FR Coverage Map

FR1: Epic 1 - Inventario e mapeamento de entidades e relacionamentos prioritarios Patronage/SIGEF.
FR2: Epic 1 - Definicao do Star Schema inicial com fatos, dimensoes e granularidades oficiais.
FR3: Epic 1 - Pipeline ETL D+1 com rastreabilidade de lotes e checkpoints de processamento.
FR4: Epic 1 - Qualidade de dados, batimento financeiro e tratamento de excecoes de reconciliacao.
FR5: Epic 2 - Entrega do contrato de dados/views dos paineis prioritarios (Conciliacao, Executivo) com filtros, KPIs e criterios de homologacao sobre o contrato de dados.
FR6: Epic 2 - Mockups V2 mantidos como contrato de referencia para a equipe do Patronage, com fluxo formal de homologacao com SH/PO sobre o contrato de dados.

## Epic List

### Epic 1: Base Analitica Confiavel e Conciliacao Financeira
Entregar uma base analitica confiavel para equipes tecnica e financeira, com dados modelados, curados e conciliados entre Patronage e SIGEF, permitindo rastreabilidade operacional e confianca nos indicadores.
**FRs covered:** FR1, FR2, FR3, FR4

### Epic 2: Contrato de Dados para Painéis Prioritários e Homologação
Entregar contrato de dados/views homologadas para os painéis de Conciliação (prioridade principal) e Executivo (prioridade secundária), para consumo da equipe do Patronage na implementação da UI, com critérios de homologação formal sobre o contrato de dados.
**FRs covered:** FR5, FR6

## Epic 1: Base Analitica Confiavel e Conciliacao Financeira

Consolidar fundamentos de dados para analytics institucional e conciliacao SIGEF x Patronage com qualidade, governanca e operacao auditavel.

### Story 1.1: Catalogar entidades prioritarias e regras de correlacao

As a equipe tecnica de dados,
I want consolidar o catalogo de entidades prioritarias e a regra de correlacao edital + CPF,
So that o time tenha base unica e validada para modelagem e conciliacao.

**Acceptance Criteria:**

**Given** as fontes Patronage e SIGEF disponiveis
**When** o inventario de entidades e relacionamentos prioritarios for executado
**Then** um catalogo versionado com origem, periodicidade e dono funcional de cada entidade deve ser publicado
**And** a regra de correlacao por ID de edital + CPF do proponente deve estar documentada e aprovada funcionalmente.

### Story 1.2: Definir modelo dimensional inicial da fase 1

As a analista de dados,
I want definir o Star Schema inicial com fatos e dimensoes conformadas,
So that os indicadores e paineis tenham base analitica consistente por periodicidade oficial.

**Acceptance Criteria:**

**Given** o catalogo de entidades aprovado
**When** o modelo dimensional for especificado
**Then** os fatos e dimensoes da fase 1 devem ser definidos com granularidade mensal, trimestral, semestral e anual
**And** os fatos financeiros devem prever atributo ou ponte para reconciliacao por edital + CPF.

### Story 1.3: Implementar carga ETL D+1 com checkpoint e rastreabilidade

As a engenheiro de dados,
I want executar cargas D+1 para camada Curated com controle de lote,
So that os dados fiquem disponiveis no prazo operacional e com retomada segura em caso de falha.

**Acceptance Criteria:**

**Given** rotinas ETL configuradas para Patronage e SIGEF
**When** uma carga diaria for executada
**Then** logs de execucao com lote, horario e volume processado devem ser persistidos
**And** checkpoints incrementais por endpoint/fonte devem permitir retomada sem perda de consistencia
**And** quando uma fonte externa falhar durante a janela D+1, o lote deve ser marcado com status parcial, gerar alerta operacional e preservar ponto de reprocessamento sem bloquear indevidamente a carga das fontes saudaveis.

### Story 1.4: Aplicar validacoes de qualidade e batimento financeiro

As a time de qualidade de dados,
I want validar integridade, completude, consistencia e reconciliacao por lote,
So that inconsistencias criticas nao avancem para consumo executivo.

**Acceptance Criteria:**

**Given** um lote ETL concluido
**When** as regras de data quality e batimento financeiro forem executadas
**Then** divergencias devem ser classificadas por ausencia, valor e status
**And** registros sem correspondencia confiavel devem ser enviados para fila de excecao auditavel antes da publicacao
**And** qualquer regra bloqueante de qualidade deve impedir publicacao executiva do lote ate reprocessamento ou aceite funcional formal da excecao.

### Story 1.5: Implementar controles LGPD e minimizacao na camada analitica

As a responsavel por governanca de dados,
I want aplicar mascaramento e minimizacao de dados pessoais em artefatos analiticos,
So that a plataforma atenda requisitos LGPD sem comprometer analise institucional.

**Acceptance Criteria:**

**Given** views e dimensoes de consumo analitico com dados pessoais
**When** os controles de privacidade forem aplicados
**Then** CPF e atributos pessoais sensiveis devem ser mascarados ou removidos nas views de consumo geral
**And** o acesso ao dado completo deve ficar restrito por perfil autorizado com politica de retencao definida para payload_raw.

### Story 1.6: Parametrizar regras de negocio e governanca de KPI

As a gestor tecnico da operacao analytics,
I want externalizar regras de negocio e mapeamentos criticos em parametros versionados,
So that os KPIs permaneçam consistentes e auditaveis sem dependencia de hardcode.

**Acceptance Criteria:**

**Given** regras de status/rateio e processos operacionais da conciliacao
**When** a camada de parametrizacao for implantada
**Then** mapeamentos e regras devem ser externalizados em tabelas versionadas com trilha de mudanca
**And** cada alteracao deve registrar autor, data, justificativa e vigencia da regra
**And** o consumo analitico deve ler apenas regras publicadas e aprovadas para a fase ativa.

### Story 1.7: Estabelecer observabilidade, SLO e runbook operacional

As a gestor tecnico da operacao analytics,
I want monitorar lotes, pendencias de curadoria e incidentes com runbook unico,
So that a operacao trate falhas dentro do SLO e com diagnostico repetivel.

**Acceptance Criteria:**

**Given** cargas ETL, regras de qualidade e curadoria de pontes em execucao
**When** ocorrer falha de lote, regra bloqueante ou pendencia acima do SLA
**Then** alertas diarios devem notificar responsavel tecnico e funcional com contexto minimo para acao
**And** o SLO operacional de carga ate 07:00 e refresh ate 08:00 deve estar monitorado em painel ou relatorio recorrente
**And** um runbook versionado deve descrever diagnostico, reprocessamento, escalonamento e criterio de encerramento do incidente.

### Story 1.8: Homologar contrato SIGEF e fallback operacional

As a responsavel pela integracao SIGEF,
I want validar contrato tecnico e comportamento de fallback da carga externa,
So that a reconciliacao financeira opere com resiliencia e previsibilidade.

**Acceptance Criteria:**

**Given** endpoints SIGEF priorizados para a fase 1
**When** autenticacao, paginacao, filtros incrementais e schema basico de payload forem exercitados
**Then** deve existir teste de contrato versionado cobrindo o padrao oficial de integracao
**And** retries com backoff, timeout e checkpoint incremental devem permitir retomada segura sem duplicacao indevida
**And** em indisponibilidade SIGEF a carga Patronage deve poder seguir, marcando a reconciliacao como dependencia externa e acionando fallback operacional documentado.

## Epic 2: Contrato de Dados para Painéis Prioritários e Homologação

Entregar contrato de dados/views homologadas para os painéis de Conciliação (prioridade principal) e Executivo (prioridade secundária), para consumo da equipe do Patronage na implementação da UI, com critérios de homologação formal sobre o contrato de dados.

### Story 2.1: Empacotar contrato de design system e shell de navegacao para o Patronage

As a equipe de produto,
I want empacotar e formalizar o contrato de design system (tokens, shell de navegacao, componentes) presente nos mockups V2,
So that a equipe do Patronage tenha uma referencia unica e completa para implementar a UI sem ambiguidade.

**Acceptance Criteria:**

**Given** os mockups V2 e o contrato UX disponiveis
**When** o pacote de referencia for formalizado
**Then** tokens de design, tipografia, componentes base e shell de navegacao devem estar documentados e referenciaveis em um unico artefato
**And** o pacote deve ser entregue e comunicado formalmente a equipe do Patronage como contrato de referencia, nao como implementacao deste time.

### Story 2.2: Documentar requisitos de acessibilidade e responsividade como contrato de referencia

As a equipe de produto,
I want documentar explicitamente os requisitos de acessibilidade e responsividade observados nos mockups V2,
So that a equipe do Patronage tenha criterios claros e verificaveis para nao regredir a experiencia homologada ao implementar a UI final.

**Acceptance Criteria:**

**Given** os mockups V2 dos paineis prioritarios (Conciliacao, Executivo)
**When** o contrato de acessibilidade e responsividade for formalizado
**Then** `lang` pt-BR, skip link funcional, foco visivel e navegacao completa por teclado devem estar descritos em checklist rastreavel entregue a equipe do Patronage
**And** os breakpoints principais e o tratamento de estados semanticos sem dependencia exclusiva de cor devem estar documentados como criterio de aceite para a implementacao externa.

### Story 2.3: Entregar painel operacional de chamadas e editais

**[ADIADA PARA CICLO FUTURO — fora do ciclo 1 a partir de 2026-07-21. Conteudo abaixo preservado sem alteracao para retomada posterior.]**

As a gestor operacional,
I want acompanhar volume, status, ciclo e gargalos por filtros oficiais,
So that eu identifique rapidamente desvios e priorize acoes corretivas.

**Acceptance Criteria:**

**Given** dados curados e criterios homologatorios definidos
**When** eu acessar o painel operacional
**Then** filtros por periodo, edital, status e area devem funcionar sem recarregamento inconsistente
**And** indicadores de volume, status, tempo medio e gargalos por segmentador devem ser exibidos com divergencia maxima de 1% frente a Curated.

### Story 2.4: Entregar painel gerencial de convenios e execucao

**[ADIADA PARA CICLO FUTURO — fora do ciclo 1 a partir de 2026-07-21. Conteudo abaixo preservado sem alteracao para retomada posterior.]**

As a gestor gerencial,
I want visualizar carteira de convenios, vigencia e aderencia de relatorios,
So that eu acompanhe risco de prazo e conformidade da execucao.

**Acceptance Criteria:**

**Given** regras de calculo e semaforizacao homologadas
**When** eu consultar o painel gerencial
**Then** a carteira por tipo e vigencia deve cobrir integralmente o recorte da fase 1
**And** desvios de prazo e status de relatorios devem ser apresentados com rastreabilidade ate a origem analitica.

### Story 2.5: Entregar contrato de dados/views de conciliacao SIGEF x Patronage

As a equipe de dados,
I want expor uma view/contrato de dados de conciliacao com divergencias e trilha de auditoria por lote,
So that a equipe do Patronage implemente o painel de conciliacao consumindo dados prontos e confiaveis, e o analista financeiro trate excecoes com rastreabilidade.

**Acceptance Criteria:**

**Given** batimento financeiro por edital + CPF executado na camada analitica
**When** a view/contrato de conciliacao for consumido
**Then** divergencias devem estar classificadas por ausencia no SIGEF, ausencia no Patronage e diferenca de valor/status
**And** cada resultado deve expor referencia de lote D+1 com data de carga e quantidade conciliada
**And** quando o ultimo lote estiver parcial, falho ou dependente de fonte externa, a view deve sinalizar a restricao para que a UI do Patronage impeca interpretacao de reconciliacao como consolidada.

### Story 2.6: Entregar contrato de dados/views executivas com KPIs institucionais

As a equipe de dados,
I want expor uma view/contrato de dados com os KPIs executivos consolidados,
So that a equipe do Patronage implemente o painel executivo e a lideranca tome decisoes estrategicas em poucos minutos com base em dados confiaveis.

**Acceptance Criteria:**

**Given** os KPIs executivos definidos para a fase 1
**When** a view/contrato executivo for consumido
**Then** devem estar disponiveis tendencias, comparativos, alertas e semaforizacao precomputados para orcamento, ciclo, convenios, divergencia SIGEF x Patronage e alertas criticos
**And** o payload exposto deve ser enxuto o suficiente para sustentar um walkthrough executivo concluivel em ate 5 minutos na UI final.

### Story 2.7: Operacionalizar checklist de homologacao e aceite formal do contrato de dados

As a Product Owner,
I want registrar decisoes de homologacao por criterio e por painel sobre o contrato de dados exposto,
So that o aceite formal do ciclo 1 seja auditavel, acionavel e compartilhado com a equipe do Patronage.

**Acceptance Criteria:**

**Given** o contrato de dados dos dois paineis prioritarios (Conciliacao, Executivo) disponibilizado
**When** a reuniao de homologacao com SH/PO e a equipe do Patronage ocorrer
**Then** cada criterio deve permitir decisao explicita (aprovado, ressalvas, reprovado, pendente) com consolidacao de resumo da rodada
**And** pendencias devem ser vinculadas a responsavel e prazo para fechamento do aceite formal
**And** qualquer painel com criterio `reprovado` ou `pendente` deve impedir fechamento do aceite geral sem plano de acao registrado e nova data de revisao.
