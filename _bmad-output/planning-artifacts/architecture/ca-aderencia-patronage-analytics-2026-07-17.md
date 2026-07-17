# Verificacao de Aderencia para CA - patronage analytics

Data: 2026-07-17
Status geral: Aderente com ressalvas
Escopo analisado: patronage/sql/analytics (Fases 1 a 3)

## Conclusao executiva

Os artefatos ja implementam o nucleo de arquitetura esperado para CA:
- camadas landing -> curated -> marts/views
- modelo dimensional e reconciliacao SIGEF x Patronage
- orquestracao, DQ, materializadas, views, eventos e rollback

Aprovacao para CA com ressalvas, condicionada a decisoes de negocio e governanca abaixo.

## Riscos e ajustes necessarios

### 1) Governanca LGPD antes de producao
Severidade: alta
Risco: exposicao de identificadores pessoais (CPF e dados pessoais) em dimensoes e views sem mascaramento.
Ajuste recomendado:
- mascarar CPF nas views de consumo geral
- limitar campos pessoais em dim_usuario ao minimo necessario
- definir dono de decisao (DPO/area juridica) e politica de retencao de payload_raw

### 2) Regras de negocio pendentes que impactam KPI
Severidade: alta
Risco: metricas com classificacao potencialmente incorreta.
Ajuste recomendado:
- validar codigos de situacao de processos/termos com negocio
- validar regra de rateio de convenio_execucao com area financeira
- promover essas decisoes para tabela de parametrizacao de negocio em vez de hardcode

### 3) Integracao SIGEF com contrato de API incompleto
Severidade: media
Risco: falha operacional na carga externa por autenticacao/paginacao/filtros nao confirmados.
Ajuste recomendado:
- homologar contrato real de auth, paginacao e filtros incrementais
- adicionar teste de contrato e fallback operacional documentado

Atualizacao 2026-07-17 (pos protocolo FAPEMA):
- pendencia humana de acesso/credencial SIGEF considerada encerrada (protocolo realizado e user/pass recebidos)
- remanescente passa a ser atividade tecnica de homologacao operacional (smoke test, validacao de payload e ajuste fino de integracao)

### 4) Curadoria de pontes como dependencia operacional
Severidade: media
Risco: reconciliacao incompleta enquanto ponte edital-subacao permanecer com confiabilidade baixa.
Ajuste recomendado:
- formalizar SLA e responsavel por curadoria
- criar alerta operacional diario para pendencias de ponte

## Recomendacoes de mudanca (ordem sugerida)

1. Implementar versoes mascaradas das views de consumo (ou substituir colunas sensiveis diretamente nas vw_ atuais).
2. Criar tabela de parametros de negocio para mapeamento de status e regras de rateio.
3. Congelar contrato SIGEF e atualizar 12_client_sigef.py com o padrao oficial.
4. Definir runbook de curadoria de pontes com SLA e responsavel funcional.

## Complemento arquitetural para FR5 e FR6

### Objetivo

Fechar explicitamente a arquitetura da camada web que entregara os quatro paineis mandatarios e o checklist de homologacao no ecossistema Laravel, preservando o contrato de UX aprovado nos mockups V2.

### Decisao arquitetural

- A entrega final dos paineis deve ocorrer no ecossistema Laravel existente, sem duplicar uma aplicacao front-end separada para a fase 1.
- O Laravel deve atuar como camada de composicao web, autorizacao, roteamento e entrega de assets/componentes, enquanto a camada analytics permanece responsavel pela verdade dos dados em marts/views e tabelas de apoio.
- Os mockups V2 funcionam como contrato visual e funcional; a implementacao final pode trocar HTML estatico por templates/componentes Laravel, desde que preserve o shell, a navegacao, a semantica visual e os estados de homologacao descritos no artefato de UX.

### Modelo de entrega web

- Rotas Laravel dedicadas para os cinco destinos de UX: visao geral, painel operacional, painel gerencial, painel de conciliacao, painel executivo e checklist.
- Layout base compartilhado para sidebar, breadcrumb, meta pills e estrutura principal de conteudo.
- Assets compartilhados para tokens visuais, estados semanticos, tipografia, acessibilidade e responsividade.
- Componentes reaproveitaveis para hero, KPI cards, chips de filtro, tabelas analiticas, badges de status e bloco de resumo de homologacao.

### Contrato entre UI e camada analitica

- O front-end Laravel nao deve calcular KPI critico em tela; os indicadores devem chegar prontos ou quase prontos da camada curated/marts, com regra de negocio centralizada no analytics.
- Cada painel deve consumir datasets derivados de views/materializadas com rastreabilidade minima de periodo, lote, status e regra de calculo.
- O painel de conciliacao deve receber, alem dos agregados, o status operacional do ultimo lote para distinguir resultado consolidado de resultado parcial, falho ou dependente de fonte externa.
- O checklist de homologacao deve persistir decisoes, observacoes, responsavel e prazo em estrutura rastreavel fora do HTML estatico, preferencialmente em tabela de aplicacao ou artefato operacional versionado.

### Requisitos tecnicos derivados do contrato de UX

#### Shell e navegacao
- Preservar sidebar fixa com destaque de tela ativa e navegacao cruzada entre os quatro paineis e o checklist.
- Preservar breadcrumb contextual e meta pills de status por tela.

#### Acessibilidade
- Manter `lang` pt-BR, skip link funcional, foco visivel e navegacao completa por teclado.
- Garantir que semaforizacao e badges nao dependam exclusivamente de cor para comunicar estado.

#### Responsividade
- Preservar leitura em desktop e mobile sem esconder filtros obrigatorios, acao principal ou contexto institucional.
- Tratar tabelas densas com estrategia segura de largura minima, quebra de layout e rolagem horizontal quando necessario.

#### Performance percebida
- Filtros devem responder sem recarregamento inconsistente; isso pode ser atendido por refresh parcial, query assíncrona ou composicao incremental, desde que a interacao nao pareca uma troca de pagina quebrada.
- O painel executivo deve sustentar walkthrough de leitura em ate 5 minutos, o que implica prioridade a consultas agregadas, payload enxuto e hierarquia visual clara.

### Estrategia de dados para consumo web

- Painel operacional e gerencial: consumir agregados de marts/views com filtros por periodo, edital, status, area, tipo e vigencia.
- Painel de conciliacao: consumir dataset reconciliado com classificacao de divergencia, referencia de lote D+1, data de carga, quantidade conciliada e flag de dependencia externa.
- Painel executivo: consumir visao agregada de KPIs institucionais com tendencias e semaforizacao precomputadas sempre que possivel.
- Checklist: consumir definicao dos criterios homologatorios e persistir o resultado da rodada de aceite por item e por painel.

### Observabilidade da camada web

- Erros de carregamento de painel, falha de consulta e estado de lote parcial devem produzir sinalizacao clara ao usuario e log tecnico para diagnostico.
- Quando o dado exibido estiver bloqueado por regra de qualidade ou dependencia externa, a UI deve explicitar o motivo e evitar leitura enganosa de consolidado.
- A camada web deve registrar versao do lote ou timestamp de atualizacao exibida ao usuario em cada painel critico.

### Gate de implementacao

- A implementacao de FR5 e FR6 pode prosseguir com esta arquitetura como baseline.
- O aceite final para producao permanece condicionado a homologacao formal dos quatro paineis pelos aprovadores definidos no PRD.
- Qualquer divergencia entre mockup homologado e tela Laravel deve ser reconciliada no artefato de UX antes do aceite final.

## Solucoes inferidas por melhores praticas (executar por padrao)

### LGPD e minimizacao de dados
- Adotar mascaramento parcial de CPF em todas as views de consumo geral (mostrar apenas trechos minimos para identificacao visual).
- Manter dado completo somente em camada restrita por role (auditoria/financeiro), sem exposicao em views abertas.
- Aplicar minimizacao: retirar da camada analitica campos pessoais nao usados por KPI.
- Definir retencao padrao para payload_raw SIGEF (ex.: 12 meses online + historico frio com acesso controlado).

### Regras de negocio e estabilidade de KPI
- Externalizar mapeamentos de status para tabela de parametros versionada (sem hardcode em procedure).
- Externalizar regra de rateio de convenio para tabela de estrategia por vigencia (ex.: proporcional, integral, customizada).
- Introduzir trilha de mudanca de parametro (quem alterou, quando, justificativa) para auditoria.

### Integracao SIGEF
- Implementar retries com backoff exponencial + jitter, timeout por endpoint e circuit breaker simples por janela.
- Persistir checkpoint incremental por endpoint (ultima pagina/data/offset) para retomada segura.
- Criar validacao de contrato (schema basico de payload) antes de inserir em landing.
- Definir fallback operacional: em falha SIGEF, carga Patronage segue, reconciliacao marca dependencia externa.

### Operacao e observabilidade
- Padronizar alertas diarios: lote com erro, regra bloqueante DQ, ponte pendente acima de SLA.
- Definir SLO inicial: carga concluida ate 07:00 e refresh de marts ate 08:00.
- Publicar runbook unico de incidentes com passos de diagnostico e reprocessamento.

## Itens que exigem definicao humana (nao inferir automaticamente)

1. Dono formal da decisao LGPD (DPO/juridico) e nivel de mascaramento aceito por perfil.
2. Regra oficial de negocio para codigos de situacao de processo/termo.
3. Regra financeira oficial de rateio em convenio_execucao.
4. Responsavel funcional e SLA de curadoria de ponte edital-subacao.

## Criterio pratico de aceite para avancar ao CE

Avancar para CE com os itens inferidos como baseline tecnico e abrir historias de decisao para os cinco itens humanos, com prazo e responsavel nomeado.

## Decisao para workflow BMad

- CA: considerado concluido tecnicamente com ressalvas.
- Proximo passo recomendado: CE (Create Epics and Stories), incluindo historias especificas para:
  - governanca LGPD
  - parametrizacao de regras de negocio
  - robustez da integracao SIGEF
  - operacao de curadoria de pontes
