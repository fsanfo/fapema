# Checkpoint Executivo de Homologacao - Contrato de Dados Ciclo 1

**Data sugerida:** ___/___/2026
**Duracao sugerida:** 30 a 40 minutos
**Objetivo:** sair da reuniao com decisao clara por painel prioritario: `aprovado`, `ressalvas`, `reprovado` ou `pendente`, e autorizacao (ou nao) do handoff do contrato de dados para a equipe do Patronage.

> Pauta reduzida a partir do reescopo do ciclo 1 de 2026-07-21 (2 paineis em vez de 4). Ver `sprint-change-proposal-2026-07-21.md`, Secao 4.5.

## Quem precisa estar presente

- Product Owner
- Lideranca financeira e controle interno
- Patrocinador executivo
- Representante tecnico de dados ou analytics
- Representante da equipe do Patronage

## Materiais da reuniao

- [checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21.md](/c:/Users/fabiano.fonseca/git/fapema/_bmad-output/planning-artifacts/checkpoint-homologacao-contrato-dados-ciclo1-2026-07-21.md)
- [prd.md](/c:/Users/fabiano.fonseca/git/fapema/_bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md)
- [ux-design-fapema-2026-07-17.md](/c:/Users/fabiano.fonseca/git/fapema/_bmad-output/planning-artifacts/ux-design/ux-design-fapema-2026-07-17.md)
- [ca-aderencia-patronage-analytics-2026-07-17.md](/c:/Users/fabiano.fonseca/git/fapema/_bmad-output/planning-artifacts/architecture/ca-aderencia-patronage-analytics-2026-07-17.md)
- [epics.md](/c:/Users/fabiano.fonseca/git/fapema/_bmad-output/planning-artifacts/epics.md) (Stories 2.1, 2.2, 2.5, 2.6, 2.7)
- [checklist-homologacao.html](/c:/Users/fabiano.fonseca/git/fapema/patronage/docs/html/mockups/v2/checklist-homologacao.html)
- Schema/documentacao das views de Conciliacao e Executivo (a anexar pela equipe de dados)

## Regra executiva de decisao

- `Aprovado`: segue sem bloqueio.
- `Ressalvas`: segue com ajuste pontual, responsavel e prazo definidos.
- `Reprovado`: nao segue; precisa revisao antes de novo aceite.
- `Pendente`: faltou informacao ou decisor; permanece bloqueado.

Se qualquer painel terminar como `reprovado` ou `pendente`, o aceite global do ciclo permanece bloqueado e o handoff para o Patronage nao ocorre.

## Roteiro da reuniao

### 1. Abertura - 5 min

- Relembrar que o objetivo nao e redesenhar escopo.
- Confirmar que a decisao e sobre a aderencia do contrato de dados/views (nao da tela) ao PRD e ao contrato de UX de referencia.
- Apresentar a equipe do Patronage e seu papel na implementacao da UI final.

### 2. Painel de Conciliacao - 12 min

**Aprovador:** lideranca financeira e controle interno

Perguntas de decisao:

1. O batimento por edital + CPF esta corretamente representado no schema da view?
2. A classificacao de divergencias atende a leitura do financeiro e do controle interno?
3. A trilha de auditoria por lote D+1 e a sinalizacao de status parcial/falho estao claras?
4. A equipe do Patronage confirma que o contrato de dados e suficiente para implementar a UI?

Saida esperada:

- Decisao do painel
- Ajustes pontuais, se houver

### 3. Painel Executivo - 12 min

**Aprovador:** patrocinador executivo

Perguntas de decisao:

1. Os KPIs minimos obrigatorios estao presentes no schema da view executiva?
2. A leitura executiva em ate 5 minutos e plausivel com o payload precomputado?
3. A sinalizacao de risco e conciliacao financeira esta adequada para decisao?
4. A equipe do Patronage confirma que o contrato de dados e suficiente para implementar a UI?

Saida esperada:

- Decisao do painel
- Ajustes pontuais, se houver

### 4. Fechamento - 6 min

- Consolidar decisao por painel.
- Nomear responsavel e prazo para cada ressalva ou pendencia.
- Confirmar uma das duas saidas:

1. `Aceite global aprovado - handoff do contrato de dados autorizado para a equipe do Patronage`
2. `Aceite global bloqueado ate correcao`

## Ata minima da reuniao

Preencher ao final:

- Conciliacao: ___
- Executivo: ___
- Aceite global: ___
- Handoff para o Patronage autorizado: ___
- Responsaveis por ajustes: ___
- Prazos acordados: ___

## Criterio de sucesso

A reuniao foi bem-sucedida se terminar com decisao registrada para os dois paineis prioritarios e, quando houver ressalvas, com dono e prazo definidos.
