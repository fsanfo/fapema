---
story_id: 1.1
story_key: 1-1-catalogar-entidades-prioritarias-e-regras-de-correlacao
epic: 1
title: Catalogar entidades prioritarias e regras de correlacao
status: in-progress
owner: equipe-tecnica-dados
updated_at: 2026-07-22
---

# Story 1.1 - Catalogar entidades prioritarias e regras de correlacao

## User Story

As a equipe tecnica de dados,
I want consolidar o catalogo de entidades prioritarias e a regra de correlacao edital + CPF,
So that o time tenha base unica e validada para modelagem e conciliacao.

## Acceptance Criteria

- AC1: Given as fontes Patronage e SIGEF disponiveis, When o inventario de entidades e relacionamentos prioritarios for executado, Then um catalogo versionado com origem, periodicidade e dono funcional de cada entidade deve ser publicado.
- AC2: Given as fontes Patronage e SIGEF disponiveis, When o inventario for concluido, Then a regra de correlacao por ID de edital + CPF do proponente deve estar documentada e aprovada funcionalmente.

## Escopo de Execucao

- Inventariar entidades e relacionamentos de Patronage e SIGEF que alimentam indicadores do ciclo 1.
- Consolidar metadados minimos: origem, periodicidade, dono funcional, chave tecnica e observacoes de qualidade.
- Formalizar regra de correlacao edital + CPF para conciliacao.

## Tarefas Tecnicas

- T1: Levantar entidades candidatas nas fontes de dados Patronage e SIGEF. [concluida]
- T2: Classificar entidades por prioridade de negocio para ciclo 1. [concluida]
- T3: Preencher catalogo versionado com os metadados obrigatorios. [concluida]
- T4: Documentar regra de correlacao edital + CPF e pontos de excecao conhecidos. [concluida]
- T5: Submeter para aprovacao funcional (PO/gestao responsavel). [pendente]

## Evidencias Esperadas

- E1: Catalogo versionado de entidades prioritarias em `_bmad-output/implementation-artifacts/catalogo-entidades-ciclo1-2026-07-22.md`.
- E2: Documento da regra de correlacao edital + CPF em `_bmad-output/implementation-artifacts/regra-correlacao-edital-cpf-2026-07-22.md`.
- E3: Registro de aprovacao funcional de E1 e E2 com decisao e data.

## Riscos e Mitigacoes

- R1: Ambiguidade em campos de correlacao entre fontes.
  - Mitigacao: registrar hipoteses e excecoes explicitamente no catalogo.
- R2: Ausencia de especialista de dados para detalhamento adicional.
  - Mitigacao: seguir baseline aprovado pela gestao e registrar risco residual.

## Definicao de Pronto (DoD)

- AC1 atendido com evidencia E1.
- AC2 atendido com evidencia E2.
- Story pronta para transicao para review.

## Progresso Atual

- AC1: em validacao funcional (artefato tecnico concluido).
- AC2: em validacao funcional (artefato tecnico concluido).
- Bloqueio atual: aprovacao funcional de E1 e E2 (T5).
