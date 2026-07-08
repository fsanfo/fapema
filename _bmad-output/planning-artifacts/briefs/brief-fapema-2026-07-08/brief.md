---
title: FAPEMA Patronage Analytics
status: draft
created: 2026-07-08
updated: 2026-07-08
---

# Product Brief: FAPEMA Patronage Analytics

## Resumo Executivo

O projeto FAPEMA Patronage Analytics cria a primeira camada analitica do ecossistema Patronage para transformar dados operacionais em informacao acionavel para niveis operacional, gerencial e C-Level. O foco inicial e estruturar um pipeline de dados confiavel a partir do dicionario de dados existente no MySQL 8.0.34, com modelagem orientada a Star Schema e consumo final por interfaces incorporaveis ao ambiente Laravel 12.

Na fase 1, a proposta e estabelecer os fundamentos: inventario de fontes, padronizacao de metricas, definicao de fatos e dimensoes, ETL inicial e disponibilidade de indicadores com granularidade mensal, trimestral, semestral e anual. O resultado esperado e reduzir o tempo de resposta para perguntas de gestao, elevar a qualidade dos dados para tomada de decisao e oferecer visibilidade estruturada sobre editais, chamadas, convenios, atividades e execucao de processos.

O projeto ja nasce com requisitos criticos de conformidade e operacao: adequacao a LGPD, execucao em infraestrutura on-premises e capacidade de evolucao controlada para casos de uso mais avancados. A estrategia privilegia uma entrega incremental, priorizando valor de negocio cedo, sem bloquear evolucoes futuras de arquitetura.

## Problema

Atualmente, o conhecimento operacional do Patronage esta majoritariamente no banco transacional e na leitura manual da estrutura de tabelas e relacionamentos. Isso cria alta dependencia tecnica para responder perguntas de negocio, dificulta comparacoes historicas recorrentes e aumenta o esforco para analises gerenciais.

Sem uma camada analitica dedicada, ha risco de:

- Multiplicidade de interpretacoes para os mesmos indicadores.
- Elevado tempo para consolidar relatorios periodicos.
- Dificuldade de rastrear qualidade e consistencia dos dados ao longo do tempo.
- Baixa ergonomia para decisores que nao atuam diretamente no banco de dados.

## Solucao

Implementar uma camada de analytics com tres componentes principais:

1. Engenharia de dados e curadoria:
- Mapeamento do dicionario de dados existente na pasta patronage.
- Estruturacao de pipeline ETL para camadas Landing e Curated (com opcao de evoluir para Medalhao quando justificar custo-beneficio).
- Padronizacao de regras de negocio para KPIs operacionais, gerenciais, qualidade e performance.

2. Modelo analitico:
- Definicao de modelo Star Schema, com tabelas fato reutilizando dimensoes conformadas.
- Definicao de dimensoes principais para filtros centrais e secundarias para exploracao complementar.
- Suporte a periodicidades mensal, trimestral, semestral e anual.

3. Consumo e experiencia:
- Prototipacao de interfaces em HTML para validacao com Product Owner e time tecnico.
- Diretrizes de storytelling e visualizacao para reduzir esforco cognitivo de perfis operacionais e executivos.
- Integracao com ambiente PHP/Laravel existente por estrategia de embed ou composicao nativa.

## O Que Torna a Solucao Diferente

- Alinhamento ao contexto real da instituicao: on-premises, stack atual e governanca publica.
- Estrategia orientada a decisao: nao apenas dashboards, mas camada semantica de indicadores padronizados.
- Visao de curto e longo prazo: entrega inicial enxuta com base para escala em governanca e inteligencia analitica.
- Construcao com trilha de auditabilidade tecnica desde o inicio, reduzindo retrabalho em fases futuras.

## Publico-Alvo

- Publico primario:
- Gestores operacionais e administrativos que precisam acompanhar execucao de editais, chamadas, atividades e convenios.
- Liderancas institucionais (C-Level, gabinete, presidencia) que demandam visao consolidada para decisao estrategica.

- Publico secundario:
- Equipe tecnica de TI e dados responsavel por sustentacao, evolucao e governanca da plataforma.
- Product Owner e equipe de desenvolvimento que validarao interfaces e jornadas analiticas.

## Criterios de Sucesso

- Disponibilizar versao inicial de camada analitica com fatos e dimensoes prioritarios da fase 1.
- Definir e publicar catalogo inicial de KPIs com regra de calculo documentada.
- Reduzir tempo de obtencao de relatorios gerenciais recorrentes [ASSUNCAO: meta inicial de reducao de pelo menos 50%, a confirmar].
- Garantir aderencia a requisitos de privacidade e minimizacao de dados pessoais em ativos analiticos.
- Obter aceite formal do PO para mockups HTML e utilidade dos paineis iniciais.

## Escopo

Em escopo (fase 1):

- Levantamento e entendimento do dicionario de dados existente.
- Definicao do modelo analitico inicial (Star Schema) e periodicidades oficiais.
- Implementacao inicial de ETL para alimentar camada Curated.
- Entrega de prototipos HTML das interfaces analiticas prioritarias.
- Documentacao funcional e tecnica dos principais artefatos analiticos.

Fora de escopo (fase 1):

- Reescrita do sistema transacional Laravel.
- Implantacao de plataforma externa proprietaria de BI sem validacao de aderencia e custo.
- Predicao avancada, machine learning e analitica prescritiva em larga escala.
- Substituicao completa dos relatorios legados antes da validacao incremental.

## Visao de Evolucao

Com a camada inicial estabilizada, o projeto evolui para uma plataforma analitica institucional com governanca de metricas, monitoramento de qualidade de dados e amplificacao de casos de uso de inteligencia de negocio. A medio prazo, a expectativa e consolidar um ecossistema orientado a evidencias para apoio continuo a politicas de fomento cientifico e tecnologico no Estado do Maranhao.

## Base de Evidencias Utilizada

- Definicoes iniciais do projeto: docs/project_definitions.md.
- Documentacao tecnica de dicionario de dados na pasta patronage/docs/markdown/mysql.
- Exemplos de entidades e dominios relevantes identificados: editais, edital_chamadas, users, convenios, atividades e activity_log.

## Assuncoes e Pontos em Aberto

- [ASSUNCAO] O volume historico de dados permite cargas ETL em janelas noturnas sem impacto operacional relevante.
- [ASSUNCAO] A equipe de TI autoriza criacao e manutencao de schema analitico dedicado no ambiente de testes e, futuramente, producao.
- [ASSUNCAO] O consumo analitico inicial sera realizado por visualizacoes embutidas no ecossistema Laravel, sem dependencia obrigatoria de ferramenta externa.
- [ASSUNCAO] Ha disponibilidade de responsavel de negocio para homologacao periodica de definicoes de KPI.

Perguntas para validacao com TI e stakeholders:

- Qual a volumetria atual (linhas por principais tabelas e crescimento mensal)?
- Qual a janela de carga aceitavel e frequencia minima desejada (D+1, intra-diaria, semanal)?
- Quais politicas de mascaramento/anonimizacao deverao ser obrigatorias por dominio de dado?
- Ha preferencia tecnica formal para orquestracao ETL (SQL nativo, jobs, Python, outra)?
