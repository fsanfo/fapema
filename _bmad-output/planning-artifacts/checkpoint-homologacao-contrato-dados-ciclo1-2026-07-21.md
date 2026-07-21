# Checkpoint de Homologacao do Contrato de Dados - Ciclo 1

**Data de preparo:** 2026-07-21
**Status do checkpoint:** pronto para execucao
**Objetivo:** conduzir o aceite formal do contrato de dados/views dos dois paineis prioritarios do ciclo 1 - Conciliacao (prioridade principal) e Executivo (prioridade secundaria) - antes do handoff para a equipe do Patronage, responsavel pela implementacao da UI final em Laravel.

> Este checkpoint substitui `checkpoint-homologacao-paineis-fase-1-2026-07-17.md` apos o reescopo do ciclo 1 (ver `change-trigger-reescopo-paineis-2026-07-21.md` e `sprint-change-proposal-2026-07-21.md`, Secao 4.5). Os paineis Operacional e Gerencial nao fazem parte desta rodada; os criterios originais permanecem preservados no checkpoint de 2026-07-17 para retomada em ciclo futuro.

## Regra de decisao global

- Cada criterio deve receber uma decisao: `aprovado`, `ressalvas`, `reprovado` ou `pendente`.
- Um painel so pode ser considerado homologado quando todos os seus criterios estiverem `aprovado`, ou quando houver apenas `ressalvas` com responsavel e prazo definidos e sem bloquear a compreensao do contrato de dados.
- Se qualquer criterio ficar `reprovado` ou `pendente`, o painel permanece bloqueado para aceite final.
- O aceite global do ciclo 1 exige os dois paineis prioritarios homologados.

## Evidencias obrigatorias da rodada

- PRD: `_bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md`
- UX textual (contrato de referencia): `_bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md`
- Arquitetura (contrato de dados para consumo do Patronage): `_bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md`
- Epicos e historias: `_bmad-output/planning-artifacts/epics.md` (Stories 2.1, 2.2, 2.5, 2.6, 2.7)
- Mockups V2 (contrato de referencia de segmentadores/filtros): `patronage/docs/html/mockups/v2/index.html`
- Checklist navegavel: `patronage/docs/html/mockups/v2/checklist-homologacao.html`
- Pauta curta para conducao executiva: `_bmad-output/planning-artifacts/checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21-executivo.md`
- Schema/documentacao das views/marts de Conciliacao e Executivo (a anexar pela equipe de dados antes da rodada)

## Participantes esperados

- Product Owner
- Lideranca financeira institucional e controle interno (aprovador de Conciliacao)
- Patrocinador executivo do programa de analytics (aprovador de Executivo)
- Lider de dados ou representante tecnico de analytics
- Representante da equipe do Patronage (novo participante a partir do reescopo)

## Pauta objetiva da reuniao

1. Revalidar escopo e criterio de aceite do painel sobre o contrato de dados/views (nao sobre tela implementada).
2. Revisar schema/documentacao da view e, como referencia complementar, o mockup V2 correspondente.
3. Confirmar aderencia ao PRD e ao contrato de UX (como referencia).
4. Confirmar com a equipe do Patronage que o contrato de dados e suficiente para implementar a UI sem informacao faltante.
5. Registrar decisao por criterio.
6. Definir responsavel e prazo para cada ressalva ou pendencia.
7. Fechar decisao por painel e decisao global da rodada, incluindo autorizacao de handoff do contrato de dados para o Patronage.

## Painel 01 - Conciliacao SIGEF x Patronage (prioridade principal)

**Aprovador principal:** lideranca financeira institucional e controle interno
**Publico principal:** financeiro institucional e controle interno
**Story de referencia:** Story 2.5 (`epics.md`)
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| Batimento usando chave composta ID do edital + CPF do proponente | Regra explicitada no schema/documentacao da view | Liderança financeira institucional |  |  |  |  |
| Classificação de divergencias por ausencia no SIGEF, ausencia no Patronage e diferenca de valor ou status | Colunas de classificacao documentadas na view | Controle interno |  |  |  |  |
| Trilha de auditoria por lote D+1 com data de carga e quantidade conciliada | Colunas de lote/data/quantidade documentadas na view | Financeiro + equipe de dados |  |  |  |  |
| Sinalizacao de restricao quando o lote estiver parcial, falho ou dependente de fonte externa | Flag/coluna de status operacional do lote documentada na view | Financeiro + equipe de dados |  |  |  |  |
| Contrato de dados suficiente para a equipe do Patronage implementar a UI sem informacao faltante | Confirmacao formal da equipe do Patronage apos revisao do schema | Equipe do Patronage |  |  |  |  |

**Decisão do painel:** pendente

## Painel 02 - Executivo C-Level de KPIs Institucionais (prioridade secundaria)

**Aprovador principal:** patrocinador executivo do programa de analytics
**Publico principal:** presidencia, diretorias e alta gestao
**Story de referencia:** Story 2.6 (`epics.md`)
**Status da rodada:** pendente

| Critério | Evidência esperada | Responsável de validação | Decisão | Observações | Responsável por ação | Prazo |
| --- | --- | --- | --- | --- | --- | --- |
| KPIs mínimos institucionais exigidos no PRD (orcamento, ciclo, convenios, divergencia SIGEF x Patronage, alertas criticos) | Colunas/agregados documentados na view executiva | PO + patrocinador executivo |  |  |  |  |
| Tendencias mensal, trimestral, semestral e anual precomputadas o suficiente para leitura executiva em ate 5 minutos | Granularidade e payload da view documentados | PO + diretoria patrocinadora |  |  |  |  |
| Sinalização executiva da conciliacao financeira com semaforizacao aprovada | Regra de semaforizacao documentada na view | Patrocinador executivo + controle interno |  |  |  |  |
| Contrato de dados suficiente para a equipe do Patronage implementar a UI sem informacao faltante | Confirmacao formal da equipe do Patronage apos revisao do schema | Equipe do Patronage |  |  |  |  |

**Decisão do painel:** pendente

## Paineis adiados para ciclo futuro

Os paineis Operacional (chamadas e editais) e Gerencial (convenios e execucao) nao fazem parte desta rodada de homologacao. Os criterios originais permanecem preservados em `checkpoint-homologacao-paineis-fase-1-2026-07-17.md` para retomada quando o ciclo futuro for iniciado.

## Encaminhamentos obrigatorios da rodada

| Tópico | Responsável | Prazo | Status |
| --- | --- | --- | --- |
| Consolidar schema/documentacao das views de Conciliacao e Executivo | Equipe de dados |  | Pendente |
| Registrar aceite formal por painel | Aprovadores designados + equipe do Patronage |  | Pendente |
| Comunicar formalmente a equipe do Patronage sobre a nova fronteira de responsabilidade | PO |  | Pendente |
| Liberar handoff do contrato de dados para o Patronage ou devolver com pendencias | PO + patrocinador executivo |  | Pendente |

## Resultado consolidado

- Painel de Conciliacao: pendente
- Painel Executivo: pendente
- Aceite global do ciclo 1: bloqueado ate conclusao da homologacao formal

## Criterio de fechamento do checkpoint

Este checkpoint pode ser considerado concluido quando:

1. Ambos os paineis prioritarios tiverem decisao registrada.
2. Toda ressalva ou pendencia tiver responsavel e prazo.
3. A equipe do Patronage confirmar que o contrato de dados e suficiente para implementacao da UI.
4. O PO e os aprovadores designados confirmarem o aceite final ou o retorno com correcoes.
