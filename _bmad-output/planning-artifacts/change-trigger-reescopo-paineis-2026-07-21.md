---
date: 2026-07-21
type: change-trigger-brief
prepared-for: bmad-correct-course
status: pronto-para-execucao
---

# Change Trigger Brief — Reescopo do Ciclo 1 (Painéis + Fronteira de Entrega)

> Cole este documento (ou aponte para ele) quando o `bmad-correct-course` perguntar:
> **"What specific issue or change has been identified that requires navigation?"**

## 1. Issue Summary

Houve uma mudança de foco no ciclo 1 do projeto fapema, decidida em 2026-07-21, com dois eixos:

1. **Redução de escopo de painéis**: o ciclo 1 deixa de mirar os 4 painéis mandatários (Operacional, Gerencial, Conciliação, Executivo) e passa a mirar **apenas 2**: **Conciliação (prioridade principal)** e **Executivo (prioridade secundária)**. Operacional e Gerencial não são descartados — ficam para um ciclo futuro.
2. **Mudança de fronteira de entrega**: o time deste projeto deixa de ser responsável pela implementação da UI. A entrega agora **para no Data Warehouse / camada semântica** que dá suporte ao Patronage. A **equipe que já mantém o Patronage assume a definição e implementação da UI** (front-end em Laravel). Os painéis/mockups atuais (V2) passam a servir como **referência de segmentadores, filtros e desagregações** — um contrato de dados para o time de dev consumir — e não mais como especificação de tela a ser implementada por nós.

## 2. Contexto / Onde isso foi descoberto

- No Implementation Readiness Report de 2026-07-17, o pacote estava classificado como `NEEDS WORK`, com o único bloqueio pendente sendo a homologação formal dos 4 painéis (`checkpoint-homologacao-paineis-fase-1-2026-07-17.md`, ata ainda em branco).
- Antes dessa homologação ocorrer, o patrocinador/PO trouxe a mudança de direção acima (registrada em conversa com o usuário em 2026-07-21), que torna o pacote de homologação de 4 painéis obsoleto no formato atual.

## 3. Documentos de entrada (todos localizáveis por auto-discovery do CC)

- PRD: `_bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md` (+ addendum, reconcile-sigef-update, review-rubric, review-sigef-update, validation-report)
- Épicos: `_bmad-output/planning-artifacts/epics.md`
- Arquitetura: `_bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md`
- UX: `_bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md`
- Readiness report anterior: `_bmad-output/planning-artifacts/implementation-readiness-report-2026-07-17.md`
- Pacote de homologação anterior (hoje obsoleto no escopo de 4 painéis): `_bmad-output/planning-artifacts/checkpoint-homologacao-paineis-fase-1-2026-07-17.md` e `-executivo.md`

## 4. Impacto esperado por artefato (ponto de partida para a checklist do CC)

### PRD
- FR5 (painéis) e FR6 (protótipo HTML) precisam ser reescritos: escopo cai de 4 para 2 painéis no ciclo 1; FR6 muda de "prototipar UI para implementação definitiva" para "usar mockups como referência de contrato de dados (filtros/segmentadores/desagregações) para o time do Patronage".
- Revisar critérios de sucesso do MVP: "entrega" deixa de ser "painel implementado em Laravel" e passa a ser "views/contratos do DW homologados e documentados para consumo".
- Escopo explícito de fronteira de responsabilidade (nosso time vs. time Patronage) precisa ser declarado, hoje não existe essa distinção no PRD.

### Arquitetura (`ca-aderencia-patronage-analytics`)
- O documento cobre hoje entrega de UI em Laravel (shell compartilhado, contrato UI↔camada analítica, observabilidade de front). Essa parte deixa de ser nosso escopo.
- Precisa ficar explícito onde termina nossa responsabilidade: camada semântica / views de consumo do DW, contrato de dados (schema, segmentadores, filtros, granularidade) exposto para a equipe do Patronage consumir.
- Avaliar se algum requisito de performance/refresh parcial pensado para UI ainda se aplica ao contrato de dados exposto (ex.: SLA de consulta das views).

### UX Design (`ux-design-fapema-2026-07-17`)
- Muda de natureza: de "spec de implementação de UI" para "referência de segmentadores, filtros e desagregações" a ser consumida pelo time de dev do Patronage.
- Foco deve migrar para os 2 painéis (Conciliação, Executivo); Operacional e Gerencial deixam de ser prioritários neste artefato por ora.
- Avaliar se cabe manter o documento como está (rotulado como referência) ou se precisa de uma seção nova explicitando essa mudança de papel.

### Épicos e Stories (`epics.md`)
- Epic 2 precisa reescopar: stories 2.3–2.6 (painéis operacional, gerencial, conciliação, executivo) — priorizar/expandir Conciliação e Executivo, e mover/adiar Operacional e Gerencial para backlog futuro.
- Story de homologação (2.7) muda de critério: deixa de validar "painel implementado" e passa a validar "views/contrato de dados homologado para consumo do time de front".
- Verificar se alguma story hoje descreve entrega de UI/Laravel diretamente — precisa ser reescrita para descrever entrega de contrato/DW.

### Gate de homologação
- O pacote `checkpoint-homologacao-paineis-fase-1-2026-07-17.md` (e a versão executiva) precisa ser refeito: apenas 2 painéis (Conciliação, Executivo), critérios de aceite mudam de "tela aprovada" para "contrato de dados/views aprovado pelos aprovadores de negócio e pela equipe do Patronage".

## 5. Modo sugerido

- **Incremental** — recomendado, dado que o impacto toca 4 artefatos diferentes e há decisões de fronteira (o que fica documentado como responsabilidade nossa vs. equipe Patronage) que merecem revisão item a item.

## 6. Classificação de escopo esperada

- Provável **Major**: muda fronteira de arquitetura e MVP scope, não é só reorganização de backlog. Esperar handoff para PM/Architect (John/Winston) na Section 5 do Sprint Change Proposal.
