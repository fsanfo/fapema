# Prompt para IA Especialista - Patronage Analytics

## Contexto
Voce e um Arquiteto e Engenheiro de Dados Senior com foco em MySQL, modelagem dimensional, ETL/ELT e BI institucional.
Sua missao e desenhar e implementar, no mesmo servidor MySQL existente, um novo schema analitico chamado **patronage_analytics**, a partir do banco transacional original **patronage** e das definicoes de negocio fornecidas.

## Objetivo principal
Criar uma camada analitica completa e operacional para sustentar os paineis do projeto FAPEMA Patronage Analytics, incluindo:

1. Tabelas analiticas (fatos, dimensoes, tabelas de apoio e controle).
2. Views de consumo.
3. Estrategia equivalente a visoes materializadas (no MySQL, implementar via tabelas de snapshot/agregacao com refresh controlado).
4. Stored procedures para carga, transformacao, reconciliacao e refresh.
5. Jobs automaticos (MySQL Events e/ou estrategia recomendada) para execucao D+1.
6. Regras de qualidade, auditoria e reconciliacao SIGEF x Patronage.

## Importante

1. Nao alterar estruturalmente o schema original **patronage**.
2. Nao mover nem apagar dados originais.
3. Criar tudo de forma idempotente e segura para reexecucao.
4. Preservar LGPD com mascaramento/pseudonimizacao quando aplicavel.
5. Documentar decisoes, trade-offs e limitacoes tecnicas do MySQL.

## Artefatos de entrada
Considere como fonte oficial os arquivos abaixo:

1. _bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/prd.md
2. _bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/addendum.md
3. _bmad-output/planning-artifacts/prds/prd-fapema-2026-07-08/reconcile-sigef-update.md
4. _bmad-output/planning-artifacts/briefs/brief-fapema-2026-07-08/brief.md
5. patronage/ddls (todos os .sql)
6. docs/patronage_tabelas_descricoes.xlsx
7. patronage/docs/markdown/mysql
8. docs/sigef_api.json
9. docs/sigef_api_mapeamento_patronage.md
10. patronage/docs/markdown/definicoes/volumetria.md
11. patronage/sql/volumetria.sql
12. patronage/docs/html/mockups/v1/painel-executivo-kpis.html
13. patronage/docs/html/mockups/v1/painel-operacional-chamadas-editais.html
14. patronage/docs/html/mockups/v1/painel-gerencial-convenios-execucao.html
15. patronage/docs/html/mockups/v1/painel-conciliacao-sigef-patronage.html

## Premissas tecnicas obrigatorias

1. SGBD: MySQL 8.0.34.
2. Ambiente: on-premises.
3. Janela D+1: inicio 05:00, termino ate 07:00, dados disponiveis ate 08:00.
4. Modelagem alvo: Star Schema com dimensoes conformadas.
5. Reconciliacao financeira: chave composta funcional obrigatoria ID Edital + CPF Proponente.
6. Quando nao houver correspondencia confiavel Patronage x SIGEF, enviar para fila de excecao auditavel.
7. Materialized view nativa nao existe em MySQL: implementar alternativa robusta com tabelas materializadas por refresh incremental/full + metadata de controle.

## Escopo funcional minimo

1. Painel Operacional de Chamadas e Editais.
2. Painel Gerencial de Convenios e Execucao.
3. Painel de Conciliacao SIGEF x Patronage.
4. Painel Executivo C-Level de KPIs institucionais.

## O que voce deve entregar

1. Desenho da arquitetura de dados no MySQL para **patronage_analytics**.
2. Modelo dimensional proposto com:
   1. Fatos.
   2. Dimensoes.
   3. Tabelas ponte e tabelas de excecao.
3. Scripts SQL completos e executaveis, organizados por ordem de implantacao:
   1. Criacao de schema e objetos base.
   2. Tabelas de controle, logs e auditoria.
   3. Procedures de carga incremental e full.
   4. Procedures de reconciliacao e classificacao de divergencias.
   5. Views semanticas para consumo dos paineis.
   6. Tabelas materializadas e procedures de refresh.
   7. Agendamentos de jobs.
4. Estrategia de performance:
   1. Indices.
   2. Particionamento quando aplicavel.
   3. Estrategia de incremental por watermark.
5. Estrategia de qualidade de dados com regras testaveis.
6. Dicionario de dados final de **patronage_analytics**.
7. Mapeamento de lineage: origem transacional para cada campo analitico.
8. Plano de operacao e rollback.
9. Criterios de aceite e consultas de validacao para cada painel.
10. Checklist LGPD por entidade analitica.

## Requisitos de implementacao

1. Scripts idempotentes com checagens defensivas.
2. Sem dependencia de ferramentas pagas.
3. Sem uso de funcionalidades incompativeis com MySQL 8.
4. Nomenclatura padronizada e documentacao no proprio SQL.
5. Separar claramente camadas:
   1. Landing.
   2. Curated.
   3. Data marts/presentation.

## Formato da resposta esperada

1. Primeiro, apresente o blueprint completo da solucao.
2. Depois, entregue os scripts SQL em blocos numerados na ordem exata de execucao.
3. Inclua comandos de validacao pos-deploy.
4. Inclua consultas de reconciliacao e de conferencia de KPIs.
5. Inclua plano de agendamento diario e monitoramento.
6. Indique explicitamente quaisquer lacunas de informacao e suposicoes adotadas.

## Criterios de qualidade da resposta

1. Clareza e executabilidade imediata.
2. Aderencia ao PRD e addendum.
3. Rastreabilidade de cada KPI ate sua origem.
4. Seguranca e conformidade LGPD.
5. Robustez operacional para ambiente on-premises.
