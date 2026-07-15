---
title: PRD - FAPEMA Patronage Analytics
status: final
created: 2026-07-08
updated: 2026-07-13
---

# PRD: FAPEMA Patronage Analytics

## 0. Objetivo do Documento

Este PRD descreve requisitos funcionais e nao funcionais para a fase 1 da camada de analytics do ecossistema Patronage. O documento orienta as proximas etapas de UX, arquitetura e decomposicao em epicos/historias, preservando consistencia de vocabulario e escopo.

## 1. Visao

A FAPEMA precisa de uma camada analitica institucional para transformar dados operacionais do Patronage e retornos financeiros do SIGEF em informacao confiavel para decisao operacional, gerencial e executiva. A fase 1 concentra-se em fundacao: padronizacao de metricas, pipeline ETL, modelo analitico inicial, conciliacao financeira entre sistemas e interfaces para consumo com baixo esforco cognitivo.

A solucao deve operar no contexto atual da instituicao: stack Laravel 12, MySQL 8.0.34, infraestrutura on-premises e requisitos de privacidade LGPD. A proposta privilegia entrega incremental com utilidade imediata e base tecnica para evolucoes futuras.

## 2. Usuario-Alvo

### 2.1 Jobs To Be Done

- Consolidar indicadores de editais, chamadas, convenios e atividades sem depender de consultas ad hoc ao banco transacional.
- Acompanhar desempenho e qualidade operacional com granularidade mensal, trimestral, semestral e anual.
- Conciliar pagamentos e eventos financeiros de bolsas e auxilios entre Patronage e SIGEF com rastreabilidade por edital e proponente.
- Tomar decisoes institucionais baseadas em dados comparaveis e rastreaveis.

### 2.2 Nao Usuarios (v1)

- Publico externo sem perfil institucional autorizado.
- Consumidores de analises preditivas avancadas (fora de escopo da fase 1).

### 2.3 Jornadas-Chave

- UJ-1. Gestor operacional acompanha execucao de chamadas por periodo e status para identificar gargalos.
- UJ-2. Lideranca C-Level consulta painel consolidado de indicadores para decisoes estrategicas de fomento, orcamento e risco institucional.
- UJ-3. Equipe tecnica valida qualidade de dados de cargas ETL e rastreia inconsistencias.
- UJ-4. Analista financeiro concilia pagamentos e saldos entre Patronage e SIGEF usando a chave composta edital + CPF do proponente.

## 3. Glossario

- Patronage: Plataforma da FAPEMA para gestao de bolsas e auxilios.
- Camada Landing: Camada de aterrissagem de dados brutos para processamento analitico.
- Camada Curated: Camada tratada e padronizada para consumo analitico.
- Star Schema: Modelo dimensional com fatos e dimensoes conformadas.
- KPI: Indicador-chave de desempenho com regra de calculo explicita.

## 4. Features

### 4.1 Inventario e Modelagem de Dados

Descricao: Consolidar entendimento do dicionario de dados das fontes Patronage e SIGEF e definir modelo dimensional inicial para consumo analitico e conciliacao. Realiza UJ-1, UJ-3 e UJ-4.

#### FR-1: Inventariar entidades e relacionamentos prioritarios

Equipe de dados pode mapear tabelas, endpoints e relacoes relevantes para a fase 1 a partir da documentacao existente na pasta patronage e do mapeamento da API SIGEF. Realiza UJ-3 e UJ-4.

Consequencias (testaveis):
- Existe catalogo de entidades prioritarias aprovado pelo PO e TI.
- Cada entidade prioritaria possui origem, periodicidade e dono funcional definidos.
- A regra de correlacao entre Patronage e SIGEF pela chave composta ID do edital + CPF do proponente esta documentada e aprovada funcionalmente.

#### FR-2: Definir Star Schema inicial

Equipe de dados pode estruturar fatos e dimensoes conformadas para indicadores prioritarios e conciliacao financeira entre sistemas. Realiza UJ-1, UJ-2 e UJ-4.

Consequencias (testaveis):
- Existe documento de modelagem com fatos e dimensoes da fase 1.
- Cada fato possui granularidade temporal definida (mensal, trimestral, semestral, anual).
- O modelo analitico contempla atributo ou ponte de reconciliacao para a chave composta edital + CPF nos fatos financeiros prioritarios.

### 4.2 Pipeline ETL e Curadoria

Descricao: Implementar pipeline de cargas para alimentar camada Curated com qualidade, rastreabilidade e conciliacao entre Patronage e SIGEF. Realiza UJ-3 e UJ-4.

#### FR-3: Executar cargas ETL para camada Curated

Equipe tecnica pode executar cargas recorrentes de dados Patronage e SIGEF para camada Curated com frequencia diaria (D+1). Realiza UJ-3 e UJ-4.

Consequencias (testaveis):
- Cargas ETL possuem logs de execucao, origem do lote e contagem de registros processados.
- Dados Curated ficam disponiveis para consumo analitico no prazo acordado.

#### FR-4: Validar qualidade de dados da carga

Equipe tecnica pode aplicar regras de validacao de integridade, completude, consistencia e batimento financeiro apos cada carga. Realiza UJ-3 e UJ-4.

Consequencias (testaveis):
- Existe checklist de qualidade executado por lote.
- Inconsistencias criticas geram alerta para tratativa antes da publicacao do dado.
- Batimentos entre Patronage e SIGEF usam a chave composta edital + CPF e classificam divergencias por ausencia, valor e status de pagamento.
- Registros sem correspondencia confiavel entre edital Patronage e subacao ou processo SIGEF sao enviados para fila de excecao e nao entram no consolidado executivo ate curadoria funcional.

### 4.3 Consumo Analitico e Interfaces

Descricao: Disponibilizar visualizacoes e filtros para perfis operacional, gerencial, financeiro e C-Level com foco em entendimento rapido e rastreabilidade. Realiza UJ-1, UJ-2 e UJ-4.

#### FR-5: Entregar paineis iniciais com filtros principais

Usuario institucional pode consultar paineis com segmentadores principais e secundarios definidos pela governanca analitica, incluindo visoes de conciliacao financeira e executivo C-Level. Realiza UJ-1, UJ-2 e UJ-4.

Consequencias (testaveis):
- Paineis exibem indicadores aprovados no catalogo de KPI.
- Segmentadores principais e secundarios estao implementados conforme definicao funcional.
- Cada painel mandatorio possui aprovador definido e criterio de homologacao formalizado antes da liberacao da fase 1.

#### FR-6: Prototipar interfaces em HTML para validacao

Equipe de produto pode revisar mockups HTML antes da implementacao definitiva no ecossistema Laravel. Realiza UJ-2.

Consequencias (testaveis):
- Cada painel prioritario possui mockup HTML validado pelo aprovador designado para o painel.
- Feedbacks de usabilidade sao registrados e refletidos na versao implementada.

## 5. Nao Objetivos

- Reescrever o sistema transacional Patronage.
- Implementar machine learning ou analitica prescritiva em larga escala na fase 1.
- Substituir todos os relatorios legados sem migracao incremental.

## 6. Escopo de MVP

### 6.1 Em Escopo

- Modelo Star Schema inicial para dominios prioritarios.
- Pipeline ETL inicial com camada Landing e Curated.
- Integracao funcional com SIGEF para saldos, pagamentos e conciliacao financeira de bolsas e auxilios.
- Catalogo inicial de KPIs operacionais, gerenciais, qualidade e performance.
- Mockups HTML e paineis iniciais para perfis operacional, gerencial, financeiro e C-Level.

### 6.2 Fora de Escopo do MVP

- Integracoes complexas nao essenciais para os KPIs da fase 1, exceto o recorte funcional Patronage + SIGEF definido neste PRD.
- Ferramenta proprietaria de BI sem justificativa tecnica e financeira.
- Funcionalidades analiticas avancadas fora da necessidade imediata.

### 6.3 Paineis Mandatorios para Homologacao da Fase 1

#### Painel Operacional de Chamadas e Editais

Publico principal: gestores operacionais.

Aprovador de homologacao: gerencia responsavel por chamadas e editais.

Escopo minimo: volume por periodo, status/publicacao, tempo medio de ciclo e principais gargalos por segmentador.

Criterios de homologacao:
- Permite filtros por periodo, edital, status e area sem recarregamento inconsistente.
- Exibe volume, status e tempo medio de ciclo com divergencia maxima de 1% em relacao a camada Curated.
- Evidencia gargalos por segmentador principal definido pela governanca analitica.

#### Painel Gerencial de Convenios e Execucao

Publico principal: gestores gerenciais.

Aprovador de homologacao: gerencia responsavel por convenios e prestacao de contas.

Escopo minimo: quantidade por tipo, vigencia, situacao de relatorios e aderencia a prazos de prestacao.

Criterios de homologacao:
- Exibe carteira de convenios por tipo e vigencia com cobertura integral do recorte da fase 1.
- Destaca situacao de relatorios e desvios de prazo com regra de cor documentada.
- Permite rastrear cada indicador ate sua regra de calculo e origem analitica.

#### Painel de Conciliacao SIGEF x Patronage

Publico principal: financeiro institucional e controle interno.

Aprovador de homologacao: lideranca financeira institucional e controle interno.

Escopo minimo: pagamentos de bolsas e auxilios conciliados entre Patronage e SIGEF, divergencias por status, valor e ausencia de correspondencia.

Criterios de homologacao:
- Executa batimento usando a chave composta ID do edital + CPF do proponente nos fatos financeiros priorizados.
- Classifica divergencias por ausencia no SIGEF, ausencia no Patronage e diferenca de valor ou status.
- Apresenta trilha de auditoria por lote D+1 com data de carga e quantidade de registros conciliados.

#### Painel Executivo C-Level de KPIs Institucionais

Publico principal: presidencia, diretorias e alta gestao.

Aprovador de homologacao: patrocinador executivo do programa de analytics.

Escopo minimo: visao consolidada com tendencias mensais, trimestrais, semestrais e anuais, comparativos, alertas de desvios relevantes e sinalizacao executiva de conciliacao financeira. O painel deve contemplar, no minimo, os seguintes KPIs: orcamento executado versus previsto, tempo medio de ciclo das chamadas prioritarias, volume de convenios vigentes e adimplentes, taxa de divergencia SIGEF x Patronage e quantidade de alertas criticos ativos.

Criterios de homologacao:
- Resume os KPIs institucionais prioritarios em uma unica visao com walkthrough executivo concluido em ate 5 minutos por pelo menos um representante da presidencia ou diretoria patrocinadora.
- Destaca variacoes relevantes, alertas e riscos com semaforizacao aprovada pelo patrocinador executivo.
- Consolida pelo menos um indicador de execucao financeira oriundo da integracao SIGEF no recorte da fase 1.

### 6.4 Baseline de Volumetria (resolucao parcial da questao 8.1)

Fonte: patronage/docs/markdown/definicoes/volumetria.md (schema patronage, MySQL 8).

Maiores tabelas por tamanho total (MB):
- activity_log: 338633 linhas, 176.36 MB (dados 124.67 MB, indices 51.69 MB).
- logs: 147355 linhas, 84.16 MB (dados 67.61 MB, indices 16.55 MB).
- pulse_entries: 355401 linhas, 83.78 MB (dados 20.55 MB, indices 63.23 MB).
- failed_jobs: 1668 linhas, 47.75 MB (dados 47.52 MB, indices 0.23 MB).
- processos: 30024 linhas, 31.73 MB (dados 17.55 MB, indices 14.19 MB).

Implicacoes para a fase 1:
- Priorizar extracao incremental e monitoramento de carga para activity_log, logs e pulse_entries.
- Separar claramente eventos tecnicos/telemetria de fatos de negocio no desenho dimensional.
- Antecipar estrategia de particionamento e retencao para tabelas de maior volume no desenho da arquitetura.

## 7. Metricas de Sucesso

Primarias:
- SM-1: Tempo medio para gerar relatorio gerencial recorrente reduzido em 50% em relacao ao baseline atual. Valida FR-3 e FR-5.
- SM-2: Percentual de KPIs prioritarios com regra de calculo documentada e homologada >= 90%. Valida FR-1, FR-2 e FR-5.
- SM-4: Os quatro paineis mandatarios da secao 6.3 sao homologados pelos aprovadores designados antes da liberacao da fase 1. Valida FR-5 e FR-6.

Secundarias:
- SM-3: Taxa de aceite de mockups dos paineis prioritarios pelo PO >= 80% na primeira rodada. Valida FR-6.

Contra-metricas:
- SM-C1: Nao aumentar tempo de carga ETL acima da janela operacional permitida.
- SM-C2: Nao elevar incidencias de exposicao de dados pessoais em artefatos analiticos.

## 8. Pendencias e Status

1. Crescimento mensal das principais tabelas
	- Status: Resolvido.
	- Resposta consolidada: crescimento mensal estimado entre 5% e 7%.

2. Janela operacional para cargas ETL diarias (D+1)
	- Status: Resolvido.
	- Resposta consolidada: janela de 2 horas, inicio as 5h e conclusao prevista ate 7h, com dados atualizados e curados disponiveis ate 8h.

3. Regras obrigatorias de mascaramento e pseudonimizacao LGPD por dominio
	- Status: Resolvido.
	- Resposta consolidada: adotar as regras LGPD ja vigentes e aplicadas no Patronage em producao.

4. Estrategia preferencial de orquestracao ETL
	- Status: Resolvido.
	- Resposta consolidada: uso de jobs para automacao dos dados do SIGEF via API com gravacao em MySQL on-premise; demais artefatos acessados via SQL em schema dedicado para analytics e BI. O batimento funcional de pagamentos usa a chave composta ID do edital + CPF do proponente.

5. Aprovacao dos quatro paineis mandatarios da secao 6.3
	- Status: Parcialmente resolvido.
	- Situacao atual: criterios de homologacao e aprovadores por painel definidos no PRD; permanece pendente a execucao formal do aceite dos aprovadores designados.
	- Owner: PO, gerencia de chamadas e editais, gerencia de convenios, lideranca financeira, controle interno e patrocinador executivo.
	- Revalidar em: checkpoint imediatamente anterior ao inicio da implementacao definitiva no ecossistema Laravel.

## 9. Indice de Assumptions

- [ASSUMPTION] A correlacao entre ID do edital no Patronage e os campos de negocio equivalentes no SIGEF permanecera estavel para os fatos financeiros priorizados da fase 1.
- [ASSUMPTION] A homologacao formal dos quatro paineis mandatarios ocorrera com dados D+1 e disponibilidade dos aprovadores designados.
