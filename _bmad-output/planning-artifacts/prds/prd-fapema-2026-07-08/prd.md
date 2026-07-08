---
title: PRD - FAPEMA Patronage Analytics
status: draft
created: 2026-07-08
updated: 2026-07-08
---

# PRD: FAPEMA Patronage Analytics

## 0. Objetivo do Documento

Este PRD descreve requisitos funcionais e nao funcionais para a fase 1 da camada de analytics do ecossistema Patronage. O documento orienta as proximas etapas de UX, arquitetura e decomposicao em epicos/historias, preservando consistencia de vocabulario e escopo.

## 1. Visao

A FAPEMA precisa de uma camada analitica institucional para transformar dados operacionais do Patronage em informacao confiavel para decisao operacional, gerencial e executiva. A fase 1 concentra-se em fundacao: padronizacao de metricas, pipeline ETL, modelo analitico inicial e interfaces para consumo com baixo esforco cognitivo.

A solucao deve operar no contexto atual da instituicao: stack Laravel 12, MySQL 8.0.34, infraestrutura on-premises e requisitos de privacidade LGPD. A proposta privilegia entrega incremental com utilidade imediata e base tecnica para evolucoes futuras.

## 2. Usuario-Alvo

### 2.1 Jobs To Be Done

- Consolidar indicadores de editais, chamadas, convenios e atividades sem depender de consultas ad hoc ao banco transacional.
- Acompanhar desempenho e qualidade operacional com granularidade mensal, trimestral, semestral e anual.
- Tomar decisoes institucionais baseadas em dados comparaveis e rastreaveis.

### 2.2 Nao Usuarios (v1)

- Publico externo sem perfil institucional autorizado.
- Consumidores de analises preditivas avancadas (fora de escopo da fase 1).

### 2.3 Jornadas-Chave

- UJ-1. Gestor operacional acompanha execucao de chamadas por periodo e status para identificar gargalos.
- UJ-2. Lideranca executiva consulta painel consolidado de indicadores para decisoes estrategicas de fomento.
- UJ-3. Equipe tecnica valida qualidade de dados de cargas ETL e rastreia inconsistencias.

## 3. Glossario

- Patronage: Plataforma da FAPEMA para gestao de bolsas e auxilios.
- Camada Landing: Camada de aterrissagem de dados brutos para processamento analitico.
- Camada Curated: Camada tratada e padronizada para consumo analitico.
- Star Schema: Modelo dimensional com fatos e dimensoes conformadas.
- KPI: Indicador-chave de desempenho com regra de calculo explicita.

## 4. Features

### 4.1 Inventario e Modelagem de Dados

Descricao: Consolidar entendimento do dicionario de dados e definir modelo dimensional inicial para consumo analitico. Realiza UJ-1 e UJ-3.

#### FR-1: Inventariar entidades e relacionamentos prioritarios

Equipe de dados pode mapear tabelas e relacoes relevantes para a fase 1 a partir da documentacao existente na pasta patronage. Realiza UJ-3.

Consequencias (testaveis):
- Existe catalogo de entidades prioritarias aprovado pelo PO e TI.
- Cada entidade prioritaria possui origem, periodicidade e dono funcional definidos.

#### FR-2: Definir Star Schema inicial

Equipe de dados pode estruturar fatos e dimensoes conformadas para indicadores prioritarios. Realiza UJ-1 e UJ-2.

Consequencias (testaveis):
- Existe documento de modelagem com fatos e dimensoes da fase 1.
- Cada fato possui granularidade temporal definida (mensal, trimestral, semestral, anual).

### 4.2 Pipeline ETL e Curadoria

Descricao: Implementar pipeline de cargas para alimentar camada Curated com qualidade e rastreabilidade. Realiza UJ-3.

#### FR-3: Executar cargas ETL para camada Curated

Equipe tecnica pode executar cargas recorrentes de dados para camada Curated com frequencia diaria (D+1). Realiza UJ-3.

Consequencias (testaveis):
- Cargas ETL possuem logs de execucao e contagem de registros processados.
- Dados Curated ficam disponiveis para consumo analitico no prazo acordado.

#### FR-4: Validar qualidade de dados da carga

Equipe tecnica pode aplicar regras de validacao de integridade, completude e consistencia apos cada carga. Realiza UJ-3.

Consequencias (testaveis):
- Existe checklist de qualidade executado por lote.
- Inconsistencias criticas geram alerta para tratativa antes da publicacao do dado.

### 4.3 Consumo Analitico e Interfaces

Descricao: Disponibilizar visualizacoes e filtros para perfis operacional e executivo com foco em entendimento rapido. Realiza UJ-1 e UJ-2.

#### FR-5: Entregar paineis iniciais com filtros principais

Usuario institucional pode consultar paineis com segmentadores principais e secundarios definidos pela governanca analitica. Realiza UJ-1 e UJ-2.

Consequencias (testaveis):
- Paineis exibem indicadores aprovados no catalogo de KPI.
- Segmentadores principais e secundarios estao implementados conforme definicao funcional.

#### FR-6: Prototipar interfaces em HTML para validacao

Equipe de produto pode revisar mockups HTML antes da implementacao definitiva no ecossistema Laravel. Realiza UJ-2.

Consequencias (testaveis):
- Cada painel prioritario possui mockup HTML validado pelo PO.
- Feedbacks de usabilidade sao registrados e refletidos na versao implementada.

## 5. Nao Objetivos

- Reescrever o sistema transacional Patronage.
- Implementar machine learning ou analitica prescritiva em larga escala na fase 1.
- Substituir todos os relatorios legados sem migracao incremental.

## 6. Escopo de MVP

### 6.1 Em Escopo

- Modelo Star Schema inicial para dominos prioritarios.
- Pipeline ETL inicial com camada Landing e Curated.
- Catalogo inicial de KPIs operacionais, gerenciais, qualidade e performance.
- Mockups HTML e paineis iniciais para perfis operacional e executivo.

### 6.2 Fora de Escopo do MVP

- Integracoes complexas nao essenciais para os KPIs da fase 1.
- Ferramenta proprietaria de BI sem justificativa tecnica e financeira.
- Funcionalidades analiticas avancadas fora da necessidade imediata.

### 6.3 Paineis Mandatorios para Homologacao da Fase 1

- Painel Operacional de Chamadas e Editais: volume por periodo, status/publicacao, tempo medio de ciclo e principais gargalos por segmentador.
- Painel Gerencial de Convenios e Execucao: quantidade por tipo, vigencia, situacao de relatorios e aderencia a prazos de prestacao.
- Painel Executivo de KPIs Institucionais: visao consolidada com tendencias mensais/trimestrais/semestrais/anuais, comparativos e alertas de desvios relevantes.

## 7. Metricas de Sucesso

Primarias:
- SM-1: Tempo medio para gerar relatorio gerencial recorrente reduzido em 50% em relacao ao baseline atual. Valida FR-3 e FR-5.
- SM-2: Percentual de KPIs prioritarios com regra de calculo documentada e homologada >= 90%. Valida FR-1, FR-2 e FR-5.

Secundarias:
- SM-3: Taxa de aceite de mockups dos paineis prioritarios pelo PO >= 80% na primeira rodada. Valida FR-6.

Contra-metricas:
- SM-C1: Nao aumentar tempo de carga ETL acima da janela operacional permitida.
- SM-C2: Nao elevar incidencias de exposicao de dados pessoais em artefatos analiticos.

## 8. Questoes em Aberto

1. Qual a volumetria atual e crescimento mensal das principais tabelas?
2. Qual a janela operacional exata para execucao das cargas ETL diarias (D+1)?
3. Quais regras obrigatorias de mascaramento e pseudonimizacao LGPD por dominio?
4. Qual estrategia preferencial de orquestracao ETL (SQL nativo, jobs, Python, outra)?
5. Os tres paineis mandatarios propostos em 6.3 estao aprovados sem ajustes?

## 9. Indice de Assumptions

- [ASSUMPTION] A janela operacional diaria disponivel sera suficiente para concluir ETL, validacoes de qualidade e publicacao no prazo acordado.
