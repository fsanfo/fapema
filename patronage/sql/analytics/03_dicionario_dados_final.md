# Dicionario de Dados Final — patronage_analytics

Este documento e o indice mestre de todos os objetos do schema. Para o
detalhamento campo a campo de **dimensoes e fatos** (grao, regra de calculo,
lineage), a fonte autoritativa continua sendo `01_modelo_dimensional.md`
(Fase 1) — este documento nao duplica aquele conteudo, apenas o referencia.
Aqui voce encontra: (1) o inventario completo de todos os objetos do schema,
(2) o dicionario campo a campo dos objetos **novos da Fase 3** (materializadas
e views, que ainda nao tinham documentacao), e (3) o inventario de procedures.

## 1. Inventario completo de objetos

### 1.1. Landing (`lnd_*`) — 21 tabelas Patronage + 4 SIGEF
Cópia rasa das entidades priorizadas do `patronage` (colunas com sufixo
`_origem` preservam a chave/data de origem) e do payload SIGEF (coluna
`payload_raw` JSON preserva o retorno bruto da API para auditoria). Ver
`00_blueprint_arquitetura.md`, secao 4, para a lista completa e a
correspondencia com as tabelas de origem.

### 1.2. Controle e auditoria (`ctl_*`) — 7 tabelas
| Tabela | Proposito |
|---|---|
| `ctl_lote_carga` | Controle mestre de cada execucao de carga (status, contagens, janela D+1) |
| `ctl_watermark` | Ultimo valor processado por dominio/tabela de origem (extracao incremental) |
| `ctl_log_execucao` | Log detalhado por etapa dentro de um lote |
| `ctl_dq_regra` | Catalogo de regras de qualidade de dados testaveis |
| `ctl_dq_resultado` | Resultado de execucao de cada regra por lote |
| `ctl_mv_refresh` | Controle de refresh das tabelas materializadas |
| `ctl_lgpd_pendencias` | Registro formal das pendencias de mascaramento LGPD |

### 1.3. Dimensoes (`dim_*`) — 11 tabelas
`dim_tempo`, `dim_edital`, `dim_chamada`, `dim_modalidade`, `dim_setor`,
`dim_instituicao`, `dim_usuario`, `dim_convenio`, `dim_situacao`,
`dim_fonte_pagadora`, `dim_subacao`. Detalhamento completo: `01_modelo_dimensional.md`, secao 1.

### 1.4. Fatos (`fato_*`) — 7 tabelas
`fato_chamada_ciclo`, `fato_processo_atividade`, `fato_convenio_execucao`,
`fato_financeiro_patronage`, `fato_financeiro_sigef`,
`fato_reconciliacao_sigef_patronage`, `fato_eventos_operacionais_diario`.
Detalhamento completo: `01_modelo_dimensional.md`, secao 3.

### 1.5. Pontes e excecoes (`ponte_*`, `exc_*`) — 4 tabelas
`ponte_edital_sigef_subacao`, `ponte_proponente_credor_sigef`,
`exc_reconciliacao_sigef_patronage`, `exc_qualidade_dados`.
Detalhamento completo: `01_modelo_dimensional.md`, secao 2.

### 1.6. Materializadas (`mv_*`) — 2 tabelas — **NOVO na Fase 3**, dicionario abaixo (secao 2)

### 1.7. Views semanticas (`vw_*`) — 9 views — **NOVO na Fase 3**, dicionario abaixo (secao 3)

## 2. Dicionario campo a campo — Materializadas

### mv_reconciliacao_atual
Snapshot do ultimo lote de reconciliacao processado, por chave
`(sk_edital, sk_proponente, ano_mes_competencia)`. Refresh: `sp_refresh_mv_reconciliacao_atual()`, full, chamada apos cada lote D+1.

| Campo | Tipo | Descricao |
|---|---|---|
| sk_edital, sk_proponente, ano_mes_competencia | PK composta | Chave de negocio da reconciliacao |
| valor_patronage, valor_sigef, diferenca_valor | DECIMAL | Valores do ultimo lote conhecido |
| status_patronage, status_sigef | VARCHAR | Situacao de pagamento em cada lado |
| flag_divergencia, tipo_divergencia | — | Classificacao do ultimo resultado |
| id_lote_carga_origem | BIGINT | Rastreabilidade: de qual lote veio este snapshot |
| dt_atualizacao | DATETIME | Quando este snapshot foi calculado |

### mv_kpi_executivo_mensal
Agregado mensal para o Painel Executivo C-Level. Refresh: `sp_refresh_mv_kpi_executivo_mensal(ano_mes)`, full por mes, chamada para o mes corrente e o anterior a cada lote D+1.

| Campo | Descricao / Calculo |
|---|---|
| ano_mes (PK) | Formato YYYYMM |
| qtd_editais_publicados | Editais distintos com ao menos uma chamada publicada com `dt_inicio` no mes |
| qtd_convenios_firmados | Convenios com `dt_assinatura` no mes |
| valor_investimento_total | Soma de `valor_pago` (fato_financeiro_patronage) no mes de vencimento |
| tempo_medio_ciclo_chamadas | Media de `qtd_dias_ciclo` das chamadas fechadas no mes |
| qtd_divergencias_abertas | Excecoes de reconciliacao pendentes/em analise na competencia |
| valor_divergencias_abertas | Valor Patronage associado as divergencias acima |
| qtd_processos_recebidos, qtd_processos_aprovados | Somados a partir de `fato_chamada_ciclo` por mes de abertura |

## 3. Dicionario campo a campo — Views Semanticas

| View | Painel | Base | Uso |
|---|---|---|---|
| `vw_painel_operacional_chamadas` | Operacional | fato_chamada_ciclo + dims | Volume, ciclo, gargalos por chamada |
| `vw_painel_operacional_processos` | Operacional | fato_processo_atividade + dims | Drill-down por processo/proponente |
| `vw_painel_gerencial_convenios` | Gerencial | fato_convenio_execucao + dim_convenio | Execucao financeira e prazos de convenio |
| `vw_painel_conciliacao_atual` | Conciliacao | mv_reconciliacao_atual | Estado ATUAL da conciliacao (consumo principal) |
| `vw_painel_conciliacao_historico` | Conciliacao | fato_reconciliacao_sigef_patronage | Auditoria/trilha completa por lote |
| `vw_painel_conciliacao_excecoes` | Conciliacao | exc_reconciliacao_sigef_patronage | Fila de curadoria (sem correspondencia confiavel) |
| `vw_painel_conciliacao_idade_divergencias` | Conciliacao | exc_reconciliacao_sigef_patronage | Indicador de velocidade de resolucao (faixas de idade) |
| `vw_painel_executivo_kpis_mensal` | Executivo | mv_kpi_executivo_mensal | Serie mensal (tendencia multitemporal) |
| `vw_painel_executivo_comparativo_anual` | Executivo | vw_painel_executivo_kpis_mensal | Comparativo ano a ano |

Colunas de cada view: ver `sql/15_views_paineis.sql` (comentado inline) — todas usam nomes de coluna autoexplicativos e ja resolvidos para exibicao direta (nomes de edital/proponente/situacao em vez de chaves tecnicas).

## 4. Inventario de Procedures

| Procedure | Camada | Chamada por |
|---|---|---|
| `sp_lnd_carga_*` (24x) | Landing | `sp_executar_carga_d1` |
| `sp_povoar_dim_tempo` | Dimensao | Setup manual (uma vez / extensao de horizonte) |
| `sp_carga_dim_*` (10x) + `sp_carga_dimensoes` | Dimensao | `sp_executar_carga_d1` |
| `sp_carga_fato_*` (6x) + `sp_carga_fatos` | Fato | `sp_executar_carga_d1` |
| `sp_bootstrap_ponte_proponente_credor_sigef` | Ponte | `sp_executar_carga_d1` |
| `sp_sugerir_ponte_edital_subacao` | Ponte | `sp_executar_carga_d1` |
| `sp_reconciliar_sigef_patronage` | Reconciliacao | `sp_executar_carga_d1` (mes atual + anterior) |
| `sp_executar_regras_dq` | Qualidade | `sp_executar_carga_d1` |
| `sp_executar_carga_d1` | Orquestracao | `ev_carga_d1` (Event, diario 05:20) |
| `sp_refresh_mv_reconciliacao_atual` | Materializada | `sp_refresh_marts_d1` |
| `sp_refresh_mv_kpi_executivo_mensal` | Materializada | `sp_refresh_marts_d1` |
| `sp_refresh_marts_d1` | Orquestracao | `ev_refresh_marts_d1` (Event, diario 06:30) |

Todas as procedures de carga sao idempotentes (testado neste ambiente com execucao repetida sem duplicacao — ver `02_blueprint_fase2_etl.md`, secao 6).
