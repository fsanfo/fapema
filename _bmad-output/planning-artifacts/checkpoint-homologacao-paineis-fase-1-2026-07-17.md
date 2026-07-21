# Checkpoint de Homologacao dos Paineis da Fase 1

> **Obsoleto a partir de 2026-07-21** — este checkpoint foi substituido por `checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21.md` apos reescopo do ciclo 1 (ver `change-trigger-reescopo-paineis-2026-07-21.md`). Mantido como registro historico e como fonte dos criterios originais de Operacional e Gerencial para retomada em ciclo futuro.

**Data de preparo:** 2026-07-17
**Status do checkpoint:** pronto para execucao
**Objetivo:** conduzir o aceite formal dos quatro paineis mandatarios do PRD antes da implementacao definitiva no ecossistema Laravel.

## Regra de decisao global

- Cada criterio deve receber uma decisao: `aprovado`, `ressalvas`, `reprovado` ou `pendente`.
- Um painel so pode ser considerado homologado quando todos os seus criterios estiverem `aprovado`, ou quando houver apenas `ressalvas` com responsavel e prazo definidos e sem bloquear a compreensao do painel.
- Se qualquer criterio ficar `reprovado` ou `pendente`, o painel permanece bloqueado para aceite final.
- O aceite global da fase 1 exige os quatro paineis homologados.

## Evidencias obrigatorias da rodada

- PRD: `_bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md`
- UX textual: `_bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md`
- Arquitetura: `_bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md`
- Mockups V2: `patronage/docs/html/mockups/v2/index.html`
- Checklist navegavel: `patronage/docs/html/mockups/v2/checklist-homologacao.html`
- Pauta curta para conducao executiva: `_bmad-output/planning-artifacts/checkpoint-homologacao-paineis-fase-1-2026-07-17-executivo.md`

## Participantes esperados

- Product Owner
- Stakeholders funcionais de cada painel
- Lider de dados ou representante tecnico de analytics
- Patrocinador executivo, quando aplicavel

## Pauta objetiva da reuniao

1. Revalidar escopo e criterio de aceite do painel.
2. Navegar no mockup V2 correspondente.
3. Confirmar aderencia ao PRD e ao contrato de UX.
4. Registrar decisao por criterio.
5. Definir responsavel e prazo para cada ressalva ou pendencia.
6. Fechar decisao por painel e decisao global da rodada.

## Painel 01 - Operacional de Chamadas e Editais

**Aprovador principal:** gerencia responsavel por chamadas e editais
**Publico principal:** gestores operacionais
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| Filtros por periodo, edital, status e area sem recarregamento inconsistente | Filtro completo com segmentador de edital incluído no mockup V2 | Gerência de chamadas e editais | Pendente | Validar nomenclatura final dos editais |  |  |
| Volume, status e tempo medio de ciclo com divergencia maxima de 1% em relacao a Curated | Cards e gráficos de volume, status e ciclo presentes | Coordenação operacional + PO | Pendente | Confirmar regra de cálculo com operação |  |  |
| Gargalos por segmentador principal definido pela governanca analitica | Tabela de gargalos por área com semaforização | SH da operação + PO | Pendente | Checar segmentador principal oficial |  |  |

**Decisão do painel:** pendente

## Painel 02 - Gerencial de Convenios e Execucao

**Aprovador principal:** gerencia responsavel por convenios e prestacao de contas
**Publico principal:** gestores gerenciais
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| Carteira por tipo e vigencia com cobertura integral do recorte da fase 1 | Seções de quantidade por tipo e linha do tempo de vigência | Gerência de convênios | Pendente | Confirmar recortes da fase 1 |  |  |
| Situação de relatorios e desvios de prazo com regra de cor documentada | Rosca de relatórios e tabela de aderência com semáforo | Controle de prestação de contas | Pendente | Revisar faixas de semaforização |  |  |
| Rastreabilidade de cada indicador ate sua regra de calculo e origem analitica | Seção de rastreabilidade incluída no mockup V2 | Líder de dados + PO | Pendente | Validar nomes finais das tabelas curated |  |  |

**Decisão do painel:** pendente

## Painel 03 - Conciliacao SIGEF x Patronage

**Aprovador principal:** lideranca financeira institucional e controle interno
**Publico principal:** financeiro institucional e controle interno
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| Batimento usando chave composta ID do edital + CPF do proponente | Regra explicitada em filtros e narrativa do painel | Liderança financeira institucional | Pendente | Confirmar tratamento de exceções |  |  |
| Classificação de divergencias por ausencia no SIGEF, ausencia no Patronage e diferenca de valor ou status | Separação por ausência, valor e status no mockup V2 | Controle interno | Pendente | Validar taxonomia com controle interno |  |  |
| Trilha de auditoria por lote D+1 com data de carga e quantidade conciliada | Seção com data de carga e volume conciliado por lote | Financeiro + equipe de dados | Pendente | Confirmar formato de lote oficial |  |  |

**Decisão do painel:** pendente

## Painel 04 - Executivo C-Level de KPIs Institucionais

**Aprovador principal:** patrocinador executivo do programa de analytics
**Publico principal:** presidencia, diretorias e alta gestao
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| KPIs mínimos institucionais exigidos no PRD | Cards revisados para orçamento, ciclo, convênios, divergência e alertas críticos | PO + patrocinador executivo | Pendente | Conferir definição de meta por KPI |  |  |
| Tendencias mensal, trimestral, semestral e anual com leitura executiva em ate 5 minutos | Filtro de período inclui mensal e demais granularidades | PO + diretoria patrocinadora | Pendente | Definir padrão de abertura inicial |  |  |
| Sinalização executiva da conciliacao financeira com semaforizacao aprovada | Seção com semáforo e limites aprovados | Patrocinador executivo + controle interno | Pendente | Revisar limites de risco com diretoria |  |  |

**Decisão do painel:** pendente

## Encaminhamentos obrigatorios da rodada

| Tópico | Responsável | Prazo | Status |
| --- | --- | --- | --- |
| Consolidar feedback SH/PO nos mockups V2 e no contrato textual de UX | Equipe de produto + dados |  | Pendente |
| Registrar aceite formal por painel | Aprovadores designados |  | Pendente |
| Liberar transição para implementação ou devolver com pendências | PO + patrocinador executivo |  | Pendente |

## Resultado consolidado

- Painel Operacional: pendente
- Painel Gerencial: pendente
- Painel de Conciliacao: pendente
- Painel Executivo: pendente
- Aceite global da fase 1: bloqueado ate conclusao da homologacao formal

## Criterio de fechamento do checkpoint

Este checkpoint pode ser considerado concluido quando:

1. Todos os quatro paineis tiverem decisao registrada.
2. Toda ressalva ou pendencia tiver responsavel e prazo.
3. O PO e os aprovadores designados confirmarem o aceite final ou o retorno com correcoes.