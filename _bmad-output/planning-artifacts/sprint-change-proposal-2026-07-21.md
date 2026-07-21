---
date: 2026-07-21
type: sprint-change-proposal
prepared-by: bmad-correct-course
status: aprovado-para-implementacao
scope-classification: major
---

# Sprint Change Proposal — Reescopo do Ciclo 1 (Painéis + Fronteira de Entrega)

## 1. Resumo do Problema (Issue Summary)

Em 2026-07-21, antes da execução do checkpoint de homologação formal dos 4 painéis mandatários (pendente desde 2026-07-17, único bloqueio do Implementation Readiness Report classificado como `NEEDS WORK`), o patrocinador/PO trouxe uma mudança de direção com dois eixos:

1. **Redução de escopo de painéis**: o ciclo 1 deixa de mirar os 4 painéis mandatários (Operacional, Gerencial, Conciliação, Executivo) e passa a mirar **apenas 2**: **Conciliação (prioridade principal)** e **Executivo (prioridade secundária)**. Operacional e Gerencial não são descartados — ficam para um ciclo futuro.
2. **Mudança de fronteira de entrega**: este time deixa de ser responsável pela implementação da UI. A entrega passa a terminar no **Data Warehouse / camada semântica** que dá suporte ao Patronage. A equipe que já mantém o Patronage assume a definição e implementação da UI (Laravel). Os mockups V2 passam a servir como **contrato de referência de segmentadores, filtros e desagregações** — não mais como especificação de tela a ser implementada por este time.

**Origem**: decisão estratégica do patrocinador/PO, registrada em conversa direta com o usuário em 2026-07-21 (não é uma falha técnica descoberta em implementação). Documentada em `change-trigger-reescopo-paineis-2026-07-21.md`.

**Evidência de impacto imediato**: torna obsoleto, no formato atual, o pacote de homologação de 4 painéis (`checkpoint-homologacao-paineis-fase-1-2026-07-17.md` e `-executivo.md`), que era o único item pendente para o pacote de planejamento sair de `NEEDS WORK`.

## 2. Análise de Impacto

### 2.1 Impacto em Épicos

- **Epic 1 (Base Analítica Confiável e Conciliação Financeira)** — sem impacto. FR1–FR4 são camada de dados pura, independente de quem implementa a UI.
- **Epic 2 (Painéis Institucionais)** — impacto direto, requer redefinição:
  - Stories 2.1 (design system/shell) e 2.2 (acessibilidade/responsividade) deixam de ser "implementar front-end" e passam a ser "empacotar/documentar contrato de referência para o Patronage".
  - Stories 2.3 (Operacional) e 2.4 (Gerencial) saem do ciclo 1, adiadas para ciclo futuro (conteúdo preservado).
  - Stories 2.5 (Conciliação) e 2.6 (Executivo) permanecem no ciclo 1, reescopadas de "entregar painel" para "entregar contrato de dados/views".
  - Story 2.7 (checklist de homologação) muda critério de aceite de "painel implementado aprovado" para "contrato de dados/views aprovado pelo negócio e pela equipe do Patronage".
  - Prioridade dentro do épico: Conciliação > Executivo; Operacional/Gerencial explicitamente adiados, não descartados.
- Nenhum épico novo é necessário — a mudança cabe como reescopo do Epic 2.

### 2.2 Conflitos e Impacto em Artefatos

- **PRD**: FR5, FR6, seção 6.3 (4→2 painéis mandatários), SM-4 e pendência 8.5 precisam de reescrita. Falta seção explícita de fronteira de responsabilidade (nosso time vs. equipe Patronage), hoje inexistente. MVP continua alcançável, mas com escopo e "linha de chegada" redefinidos.
- **Arquitetura** (`ca-aderencia-patronage-analytics`): bloco "Complemento arquitetural para FR5 e FR6" assumia entrega de camada web em Laravel (rotas, shell, observabilidade de front). Sai do escopo deste time; precisa reescrita para deixar explícito que a responsabilidade termina na camada semântica/views, com contrato de dados exposto (schema, segmentadores, filtros, granularidade, SLA de consulta) para a equipe do Patronage consumir.
- **UX Design**: muda de natureza — de "spec de implementação" para "referência de contrato de segmentadores/filtros/desagregações". Foco migra para os 2 painéis priorizados (Operacional/Gerencial continuam documentados, mas fora de prioridade).
- **Pacote de homologação**: os dois arquivos de 2026-07-17 ficam obsoletos no formato de 4 painéis/tela aprovada.
- **Implementation Readiness Report** (2026-07-17): fica desatualizado como consequência natural — nova rodada de readiness deve ocorrer após os artefatos serem corrigidos (não é uma edição a fazer agora, é próximo passo).
- Nenhum artefato de deployment/IaC/CI-CD identificado no projeto (fase de planejamento, sem impacto adicional).

### 2.3 Impacto Técnico

Nenhum código ou dado de produção é afetado — o time nunca começou a implementar UI (o gate de homologação dos 4 painéis era justamente o bloqueio antes disso), e a Epic 1 (base analítica/ETL/conciliação) não muda. O impacto é inteiramente de planejamento e fronteira de responsabilidade.

## 3. Caminho Recomendado (Recommended Approach)

**Avaliação das opções:**

- **Opção 1 — Ajuste Direto**: viável. Nenhum trabalho de UI foi implementado para reverter; ajustar PRD, arquitetura, UX, épicos e pacote de homologação diretamente é possível. Esforço: Médio. Risco: Baixo-Médio (risco principal é alinhamento de fronteira com o time do Patronage, não técnico).
- **Opção 2 — Rollback**: não viável/não aplicável. Não há trabalho de painéis/UI concluído para reverter.
- **Opção 3 — Revisão de MVP**: necessária, não opcional. O MVP original definia "entrega" como painel implementado em Laravel; isso deixou de ser verdade.

**Caminho selecionado: Híbrido (Opção 1 + Opção 3)** — ajuste direto dos artefatos de planejamento, incorporando a redefinição de MVP e de fronteira de responsabilidade na mesma rodada de edição, sem necessidade de rollback.

**Justificativa**: a mudança é de natureza estratégica/fronteira de arquitetura, não uma correção técnica pontual — mas como nada foi implementado ainda na área afetada, o ajuste pode ser feito diretamente nos artefatos de planejamento sem custo de reversão. A classificação como Major reflete a mudança de escopo de MVP e de arquitetura, garantindo revisão formal por PM/Architect antes do handoff para o time do Patronage.

## 4. Propostas de Mudança Detalhadas (Detailed Change Proposals)

### 4.1 PRD (`_bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md`)

**Edição 1 — FR-5**

OLD:
```
#### FR-5: Entregar paineis iniciais com filtros principais

Usuario institucional pode consultar paineis com segmentadores principais e secundarios definidos pela governanca analitica, incluindo visoes de conciliacao financeira e executivo C-Level. Realiza UJ-1, UJ-2 e UJ-4.

Consequencias (testaveis):
- Paineis exibem indicadores aprovados no catalogo de KPI.
- Segmentadores principais e secundarios estao implementados conforme definicao funcional.
- Cada painel mandatorio possui aprovador definido e criterio de homologacao formalizado antes da liberacao da fase 1.
```

NEW:
```
#### FR-5: Entregar contrato de dados homologado para os paineis prioritarios do ciclo 1

Equipe de dados entrega, na camada semantica do Data Warehouse, views/contratos de dados com os segmentadores principais e secundarios definidos pela governanca analitica para os dois paineis prioritarios do ciclo 1: Conciliacao (prioridade principal) e Executivo (prioridade secundaria). A equipe do Patronage consome esse contrato para implementar a UI em Laravel. Realiza UJ-2 e UJ-4.

Consequencias (testaveis):
- Views/contratos de dados expoem os indicadores aprovados no catalogo de KPI para os paineis de Conciliacao e Executivo.
- Segmentadores principais e secundarios estao implementados na camada semantica conforme definicao funcional.
- Cada painel prioritario possui aprovador definido e criterio de homologacao formalizado sobre o contrato de dados (nao sobre tela implementada) antes da liberacao da fase 1.
- Paineis Operacional e Gerencial ficam fora do ciclo 1, mantidos como escopo para ciclo futuro.
```

Rationale: reflete a redução de 4→2 painéis e a mudança de entrega de "tela" para "contrato de dados".

---

**Edição 2 — FR-6**

OLD:
```
#### FR-6: Prototipar interfaces em HTML para validacao

Equipe de produto pode revisar mockups HTML antes da implementacao definitiva no ecossistema Laravel. Realiza UJ-2.

Consequencias (testaveis):
- Cada painel prioritario possui mockup HTML validado pelo aprovador designado para o painel.
- Feedbacks de usabilidade sao registrados e refletidos na versao implementada.
```

NEW:
```
#### FR-6: Usar mockups HTML como contrato de referencia para o time do Patronage

Equipe de produto mantem os mockups HTML V2 como referencia de segmentadores, filtros e desagregacoes para a equipe do Patronage, responsavel pela definicao e implementacao da UI final em Laravel. Este time nao implementa a UI definitiva. Realiza UJ-2.

Consequencias (testaveis):
- Cada painel prioritario do ciclo 1 (Conciliacao, Executivo) possui mockup HTML validado como contrato de referencia pelo aprovador designado.
- Feedbacks de usabilidade e ajustes de contrato de dados sao registrados e comunicados a equipe do Patronage antes da implementacao da UI.
```

Rationale: muda o papel do mockup de "spec de UI a implementar por nós" para "contrato de referência consumido por terceiros".

---

**Edição 3 — Seção 6.1 (Em Escopo)**

OLD:
```
- Mockups HTML e paineis iniciais para perfis operacional, gerencial, financeiro e C-Level.
```

NEW:
```
- Mockups HTML V2 como contrato de referencia de segmentadores e filtros para os paineis prioritarios do ciclo 1 (Conciliacao, Executivo).
- Views/contrato de dados do Data Warehouse homologadas para consumo da equipe do Patronage.
```

---

**Edição 4 — Seção 6.2 (Fora de Escopo do MVP)** — adicionar:
```
- Implementacao da UI definitiva dos paineis (responsabilidade da equipe do Patronage).
- Paineis Operacional e Gerencial no ciclo 1 (adiados para ciclo futuro, nao descartados).
```

---

**Edição 5 — Seção 6.3** — renomear para "Paineis Prioritarios para Homologacao do Ciclo 1", manter apenas as subseções de Conciliação e Executivo (texto original preservado), mover Operacional/Gerencial para um "Apêndice A — Painéis adiados para ciclo futuro" (texto original preservado integralmente). Adicionar nova subseção logo após o título:

```
### Fronteira de Responsabilidade

A entrega deste time termina na camada semantica do Data Warehouse (views/contratos de dados homologados). A definicao e implementacao da UI, incluindo o ecossistema Laravel, e responsabilidade da equipe que ja mantem o Patronage. Os mockups V2 funcionam como contrato de segmentadores, filtros e desagregacoes para essa equipe consumir — nao como especificacao de tela a ser implementada por este time.
```

---

**Edição 6 — SM-4**

OLD: `SM-4: Os quatro paineis mandatarios da secao 6.3 sao homologados pelos aprovadores designados antes da liberacao da fase 1. Valida FR-5 e FR-6.`

NEW: `SM-4: Os dois paineis prioritarios da secao 6.3 (Conciliacao e Executivo) tem seu contrato de dados/views homologado pelos aprovadores designados e pela equipe do Patronage antes da liberacao da fase 1. Valida FR-5 e FR-6.`

---

**Edição 7 — Pendência 8.5**

OLD:
```
5. Aprovacao dos quatro paineis mandatorios da secao 6.3
	- Status: Parcialmente resolvido.
	- Situacao atual: criterios de homologacao e aprovadores por painel definidos no PRD; permanece pendente a execucao formal do aceite dos aprovadores designados.
	- Owner: PO, gerencia de chamadas e editais, gerencia de convenios, lideranca financeira, controle interno e patrocinador executivo.
	- Revalidar em: checkpoint imediatamente anterior ao inicio da implementacao definitiva no ecossistema Laravel.
```

NEW:
```
5. Aprovacao dos dois paineis prioritarios da secao 6.3 (Conciliacao e Executivo)
	- Status: Parcialmente resolvido.
	- Situacao atual: criterios de homologacao e aprovadores por painel redefinidos para contrato de dados/views (nao mais tela implementada); permanece pendente a execucao formal do aceite dos aprovadores designados e da equipe do Patronage.
	- Owner: PO, lideranca financeira, controle interno e patrocinador executivo.
	- Revalidar em: checkpoint imediatamente anterior ao handoff do contrato de dados para a equipe do Patronage.
```

**Status: aprovado por Fabiano em modo incremental.**

### 4.2 Arquitetura (`_bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md`)

Substituição integral do bloco "Complemento arquitetural para FR5 e FR6" (linhas 59–121):

OLD (resumo): título "Complemento arquitetural para FR5 e FR6"; seções "Objetivo" (fechar arquitetura da camada web Laravel), "Decisão arquitetural" (entrega final no Laravel existente), "Modelo de entrega web" (rotas Laravel para 5 destinos), "Contrato entre UI e camada analítica", "Requisitos técnicos derivados do contrato de UX" (shell/navegação, acessibilidade, responsividade, performance percebida), "Estratégia de dados para consumo web" (4 painéis), "Observabilidade da camada web", "Gate de implementação" (condicionado à homologação dos 4 painéis).

NEW:
```
## Complemento arquitetural para FR5 e FR6 (contrato de dados para consumo do Patronage)

### Objetivo

Fechar explicitamente a arquitetura da camada semantica do Data Warehouse que expoe o contrato de dados para os dois paineis prioritarios do ciclo 1 (Conciliacao e Executivo), a ser consumido pela equipe que ja mantem o Patronage na implementacao da UI em Laravel.

### Decisao arquitetural

- A responsabilidade deste time termina nas views/marts de consumo da camada semantica; nao ha entrega de camada web, rotas ou componentes Laravel por este time.
- A equipe do Patronage e responsavel pela definicao e implementacao da UI final em Laravel, consumindo o contrato de dados exposto por este projeto.
- Os mockups V2 funcionam como contrato de referencia de segmentadores, filtros e desagregacoes para a equipe do Patronage; nao sao mais especificacao de tela a ser implementada por este time.

### Modelo de contrato de dados exposto

- Views/marts dedicadas para os dois paineis prioritarios do ciclo 1: Conciliacao e Executivo.
- Schema documentado por view: colunas, granularidade, segmentadores principais/secundarios e regra de calculo de cada indicador.
- Nomenclatura e versionamento de views estaveis o suficiente para consumo externo, com trilha de mudanca quando o contrato evoluir.
- Paineis Operacional e Gerencial: contrato de dados nao priorizado neste ciclo; retomar a partir das views ja mapeadas quando o ciclo futuro for iniciado.

### Contrato entre views e camada de consumo (Patronage)

- As views nao devem exigir que a UI calcule KPI critico; os indicadores devem chegar prontos ou quase prontos, com regra de negocio centralizada no analytics.
- Cada view deve expor rastreabilidade minima de periodo, lote, status e regra de calculo.
- A view de conciliacao deve expor, alem dos agregados, o status operacional do ultimo lote para distinguir resultado consolidado de resultado parcial, falho ou dependente de fonte externa.
- Decisoes de homologacao (aprovado/ressalvas/reprovado/pendente) por criterio e por painel podem continuar sendo persistidas em estrutura rastreavel a ser definida junto com a equipe do Patronage; este time garante apenas a origem dos dados usados nessa decisao.

### Requisitos de UX preservados como referencia para o time do Patronage

Os itens abaixo pertencem ao artefato de UX e a implementacao da UI; sao listados aqui apenas como referencia de contrato a comunicar a equipe do Patronage, sem serem requisito arquitetural deste time: shell e navegacao (sidebar, breadcrumb, meta pills), acessibilidade (`lang` pt-BR, skip link, foco visivel, navegacao por teclado), responsividade (desktop/mobile, tabelas densas) e comportamento de filtro sem recarregamento inconsistente.

### SLA de consulta do contrato de dados

- As views/marts de Conciliacao e Executivo devem responder dentro de um SLA de consulta compativel com uso interativo (a definir com o time do Patronage), ja que a experiencia final de filtro sem recarregamento depende da performance da camada exposta por este projeto.
- O painel executivo deve poder sustentar walkthrough de leitura em ate 5 minutos; isso reforca a prioridade por consultas agregadas e payload enxuto nas views expostas.

### Estrategia de dados para consumo do Patronage

- View de conciliacao: dataset reconciliado com classificacao de divergencia, referencia de lote D+1, data de carga, quantidade conciliada e flag de dependencia externa.
- View executiva: visao agregada de KPIs institucionais com tendencias e semaforizacao precomputadas sempre que possivel.

### Observabilidade da camada de dados exposta

- Cada view critica deve registrar versao do lote ou timestamp de atualizacao para exibicao pela UI do Patronage.
- Quando o dado exposto estiver bloqueado por regra de qualidade ou dependencia externa, a view deve explicitar o motivo (nao apenas omitir o dado), para que a UI evite leitura enganosa de consolidado.
- Sinalizacao de erro de carregamento e log tecnico de falha de UI passam a ser responsabilidade da equipe do Patronage.

### Gate de implementacao

- A implementacao de FR5 e FR6 pode prosseguir com esta arquitetura como baseline.
- O aceite final do contrato de dados permanece condicionado a homologacao formal dos dois paineis prioritarios (Conciliacao, Executivo) pelos aprovadores definidos no PRD e pela equipe do Patronage.
- Qualquer divergencia entre mockup de referencia e contrato de dados exposto deve ser reconciliada no artefato de UX antes do aceite final.
```

Rationale: preserva a estrutura e o rigor técnico do documento original, move a fronteira de "entrega de UI Laravel" para "entrega de contrato de dados", reduz o escopo imediato de 4 para 2 painéis, mantendo os dois adiados como nota de retomada futura.

**Status: aprovado por Fabiano em modo incremental.**

### 4.3 UX Design (`_bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md`)

**Edição 1 — "Objetivo do artefato"**

OLD:
```
Consolidar em texto o contrato de UX implicito nos mockups V2 para que PRD, epicos, arquitetura e implementacao Laravel tenham uma referencia rastreavel unica. Este documento nao substitui os mockups HTML; ele descreve as decisoes de experiencia, estrutura e homologacao ja representadas neles.
```

NEW:
```
Consolidar em texto o contrato de UX implicito nos mockups V2 para que PRD, epicos, arquitetura e a equipe do Patronage tenham uma referencia rastreavel unica de segmentadores, filtros e desagregacoes. Este documento nao substitui os mockups HTML; ele descreve as decisoes de experiencia, estrutura e homologacao ja representadas neles. A partir do reescopo de 2026-07-21, este time nao implementa mais a UI definitiva — o documento passa a ser consumido pela equipe do Patronage como contrato de referencia, priorizando os paineis de Conciliacao e Executivo no ciclo 1.
```

---

**Edição 2 — "Escopo de UX coberto"** — adicionar após a lista das 5 telas:
```
Prioridade do ciclo 1: `painel-conciliacao-sigef-patronage.html` (principal) e `painel-executivo-kpis.html` (secundaria). Os paineis operacional e gerencial permanecem documentados neste artefato como referencia, mas ficam fora do ciclo 1 e adiados para ciclo futuro.
```

---

**Edição 3 — Seção "Críticos para implementação Laravel"** (linhas 188–197)

NEW:
```
## Criticos para a equipe do Patronage considerar na implementacao

Para evitar divergencia entre mockup de referencia e tela final implementada pela equipe do Patronage, a implementacao deve preservar explicitamente:

- o shell compartilhado de navegacao;
- os tokens de marca e estados semanticos;
- o comportamento de foco, `skip-link` e navegacao por teclado;
- a responsividade da malha principal, cards e tabelas;
- a sinalizacao de status parcial ou bloqueante em conciliacao e homologacao;
- a consistencia de rotulagem entre os paineis priorizados (Conciliacao, Executivo) e o checklist.

Esta secao e uma recomendacao a ser comunicada a equipe do Patronage; a validacao final de aderencia e responsabilidade dela.
```

---

**Edição 4 — "Decisão para fluxo BMad"** (fechamento do documento)

OLD:
```
Este artefato substitui o registro resumido anterior como referencia textual de UX para o projeto. O CU permanece concluido, agora com especificacao suficiente para rastreabilidade de implementacao e nova rodada de readiness.
```

NEW:
```
Este artefato substitui o registro resumido anterior como referencia textual de UX para o projeto. O CU permanece concluido. A partir do reescopo de 2026-07-21, o documento deixa de ser especificacao de implementacao deste time e passa a ser contrato de referencia para a equipe do Patronage, com prioridade nos paineis de Conciliacao e Executivo.
```

**Status: aprovado por Fabiano em modo incremental.**

### 4.4 Épicos (`_bmad-output/planning-artifacts/epics.md`)

**Edição 1 — FR Coverage Map (FR5, FR6)**

OLD:
```
FR5: Epic 2 - Entrega dos paineis mandatarios com filtros, KPIs e criterios de homologacao.
FR6: Epic 2 - Prototipos HTML validados e fluxo formal de homologacao com SH/PO.
```

NEW:
```
FR5: Epic 2 - Entrega do contrato de dados/views dos paineis prioritarios (Conciliacao, Executivo) com filtros, KPIs e criterios de homologacao sobre o contrato de dados.
FR6: Epic 2 - Mockups V2 mantidos como contrato de referencia para a equipe do Patronage, com fluxo formal de homologacao com SH/PO sobre o contrato de dados.
```

---

**Edição 2 — Título e descrição do Epic 2** (nas duas ocorrências: lista resumida e cabeçalho completo)

Renomear para **"Epic 2: Contrato de Dados para Painéis Prioritários e Homologação"**, descrição: "Entregar contrato de dados/views homologadas para os painéis de Conciliação (prioridade principal) e Executivo (prioridade secundária), para consumo da equipe do Patronage na implementação da UI, com critérios de homologação formal sobre o contrato de dados."

---

**Edição 3 — Story 2.1**

NEW:
```
### Story 2.1: Empacotar contrato de design system e shell de navegacao para o Patronage

As a equipe de produto,
I want empacotar e formalizar o contrato de design system (tokens, shell de navegacao, componentes) presente nos mockups V2,
So that a equipe do Patronage tenha uma referencia unica e completa para implementar a UI sem ambiguidade.

**Acceptance Criteria:**

**Given** os mockups V2 e o contrato UX disponiveis
**When** o pacote de referencia for formalizado
**Then** tokens de design, tipografia, componentes base e shell de navegacao devem estar documentados e referenciaveis em um unico artefato
**And** o pacote deve ser entregue e comunicado formalmente a equipe do Patronage como contrato de referencia, nao como implementacao deste time.
```

---

**Edição 4 — Story 2.2**

NEW:
```
### Story 2.2: Documentar requisitos de acessibilidade e responsividade como contrato de referencia

As a equipe de produto,
I want documentar explicitamente os requisitos de acessibilidade e responsividade observados nos mockups V2,
So that a equipe do Patronage tenha criterios claros e verificaveis para nao regredir a experiencia homologada ao implementar a UI final.

**Acceptance Criteria:**

**Given** os mockups V2 dos paineis prioritarios (Conciliacao, Executivo)
**When** o contrato de acessibilidade e responsividade for formalizado
**Then** `lang` pt-BR, skip link funcional, foco visivel e navegacao completa por teclado devem estar descritos em checklist rastreavel entregue a equipe do Patronage
**And** os breakpoints principais e o tratamento de estados semanticos sem dependencia exclusiva de cor devem estar documentados como criterio de aceite para a implementacao externa.
```

---

**Edições 5 e 6 — Stories 2.3 (Operacional) e 2.4 (Gerencial)** — inserir logo abaixo do título de cada story:
```
**[ADIADA PARA CICLO FUTURO — fora do ciclo 1 a partir de 2026-07-21. Conteudo abaixo preservado sem alteracao para retomada posterior.]**
```
(resto do texto de cada story permanece intocado)

---

**Edição 7 — Story 2.5**

NEW:
```
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
```

---

**Edição 8 — Story 2.6**

NEW:
```
### Story 2.6: Entregar contrato de dados/views executivas com KPIs institucionais

As a equipe de dados,
I want expor uma view/contrato de dados com os KPIs executivos consolidados,
So that a equipe do Patronage implemente o painel executivo e a lideranca tome decisoes estrategicas em poucos minutos com base em dados confiaveis.

**Acceptance Criteria:**

**Given** os KPIs executivos definidos para a fase 1
**When** a view/contrato executivo for consumido
**Then** devem estar disponiveis tendencias, comparativos, alertas e semaforizacao precomputados para orcamento, ciclo, convenios, divergencia SIGEF x Patronage e alertas criticos
**And** o payload exposto deve ser enxuto o suficiente para sustentar um walkthrough executivo concluivel em ate 5 minutos na UI final.
```

---

**Edição 9 — Story 2.7**

NEW:
```
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
```

Epic 1 (Stories 1.1–1.8) permanece sem alteração.

**Status: aprovado por Fabiano em modo incremental.**

### 4.5 Pacote de Homologação

**Abordagem**: criar dois novos arquivos datados de 2026-07-21, que substituem (supersede) os de 2026-07-17. Os arquivos originais são preservados como registro histórico e fonte dos critérios originais de Operacional/Gerencial, com nota de obsolescência no topo.

**Novo arquivo 1:** `checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21.md`
- Objetivo muda de "aceite formal dos 4 painéis" para "aceite formal do contrato de dados/views dos 2 painéis prioritários (Conciliação, Executivo), antes do handoff para a equipe do Patronage".
- Apenas 2 painéis nas tabelas de critério (Conciliação primeiro, Executivo segundo); critérios reescritos de "evidência no mockup" para "evidência no schema/documentação da view/contrato de dados".
- Novo critério adicional em cada painel: "Contrato de dados suficiente para a equipe do Patronage implementar a UI sem informação faltante", validado pela própria equipe do Patronage (adicionada como participante da rodada).
- Nova seção "Painéis adiados para ciclo futuro" apontando para o checkpoint de 2026-07-17.
- Mesma regra de decisão global (aprovado/ressalvas/reprovado/pendente) e mesmo critério de fechamento, ajustados de "quatro painéis" para "dois painéis prioritários".

**Novo arquivo 2:** `checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21-executivo.md` (pauta de condução)
- Reunião reduzida de ~45–60min (4 painéis) para ~30–40min (2 painéis).
- Participantes: remove gerências de chamadas/editais e convênios; adiciona representante da equipe do Patronage.
- Roteiro com apenas 2 blocos de painel (Conciliação, Executivo); pergunta de fechamento autoriza explicitamente "handoff do contrato de dados para a equipe do Patronage" como parte do aceite global aprovado.

**Nos dois arquivos de 2026-07-17**, adicionar no topo:
```
> **Obsoleto a partir de 2026-07-21** — este checkpoint foi substituido por `checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21.md` apos reescopo do ciclo 1 (ver `change-trigger-reescopo-paineis-2026-07-21.md`). Mantido como registro historico e como fonte dos criterios originais de Operacional e Gerencial para retomada em ciclo futuro.
```

**Status: aprovado por Fabiano em modo incremental.**

## 5. Impacto no MVP do PRD e Plano de Ação de Alto Nível

**MVP afetado?** Sim. A definição de "entrega" muda de "painel implementado em Laravel homologado" para "views/contrato de dados do DW homologados para consumo do time do Patronage". O escopo de painéis do ciclo 1 cai de 4 para 2. Nenhum requisito de dados (FR1–FR4) muda.

**Plano de ação de alto nível:**

1. Aplicar as edições aprovadas nesta proposta ao PRD, arquitetura, UX design e épicos (Seção 4.1–4.4).
2. Criar os dois novos arquivos do pacote de homologação e marcar os de 2026-07-17 como obsoletos (Seção 4.5).
3. Comunicar formalmente a equipe do Patronage sobre a nova fronteira de responsabilidade e o contrato de dados que será exposto.
4. Executar o novo checkpoint de homologação (2 painéis, contrato de dados) com os aprovadores e a equipe do Patronage.
5. Rodar nova avaliação de Implementation Readiness após os artefatos atualizados, para confirmar que o pacote sai de `NEEDS WORK`.
6. Ao final do ciclo 1, reavaliar quando retomar Operacional e Gerencial em ciclo futuro, reaproveitando os critérios preservados no checkpoint de 2026-07-17.

**Dependências e sequenciamento**: os passos 1–2 (edição de artefatos) devem ocorrer antes do passo 3 (comunicação ao Patronage), que por sua vez precede o passo 4 (nova rodada de homologação). O passo 5 é o gate final antes de liberar a implementação.

## 6. Plano de Handoff (Implementation Handoff)

**Classificação de escopo: Major** — a mudança altera fronteira de arquitetura e critério de "pronto" do MVP, não é reorganização de backlog.

**Rotas de handoff:**

- **Product Manager (John)**: validar e aplicar formalmente as edições de PRD (Seção 4.1) — FR5, FR6, seção 6.3, SM-4, pendência 8.5, nova seção de fronteira de responsabilidade.
- **Solution Architect (Winston)**: validar e aplicar a reescrita do bloco arquitetural (Seção 4.2), incluindo a definição do SLA de consulta do contrato de dados e o schema formal das views de Conciliação e Executivo.
- **UX Designer (Sally)**: aplicar as edições no artefato de UX (Seção 4.3) e apoiar a comunicação do contrato de referência para a equipe do Patronage.
- **Product Owner / Developer**: aplicar as edições nos épicos (Seção 4.4) e criar os novos arquivos do pacote de homologação (Seção 4.5).
- **Product Owner**: conduzir a comunicação formal com a equipe do Patronage sobre a nova fronteira e agendar o novo checkpoint de homologação.

**Critérios de sucesso:**

- PRD, arquitetura, UX e épicos atualizados conforme as edições aprovadas nesta proposta.
- Pacote de homologação de 2 painéis criado e pacote de 4 painéis marcado como obsoleto (preservado).
- Equipe do Patronage formalmente ciente da nova fronteira de responsabilidade e do contrato de dados a ser exposto.
- Novo checkpoint de homologação agendado com todos os aprovadores e a equipe do Patronage.
- Nova rodada de Implementation Readiness executada após as edições, confirmando saída do status `NEEDS WORK`.
