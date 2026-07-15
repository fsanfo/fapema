# Modelo Dimensional — patronage_analytics (Fase 1)

Convenção: `sk_*` = surrogate key (técnica, interna). `id_..._origem` = chave natural no `patronage` (lineage). FK sempre aponta para `sk_*` da dimensão.

## 1. Dimensões

### dim_tempo
Grão: 1 linha por data corrida. Não role-playing (compartilhada por todos os fatos via qualquer FK de data).

| Campo | Origem/Regra |
|---|---|
| dt_referencia (PK) | Data calendário, gerada por procedure de povoamento (Fase 2), cobrindo desde a menor data observada em `editais.created_at` até +2 anos. |
| ano, trimestre, semestre, mes, nome_mes, dia, dia_semana, nome_dia_semana, semana_ano, flag_dia_util | Derivados de `dt_referencia`. |
| ano_mes (YYYYMM) | Chave de agregação mensal usada pelos fatos de granularidade mensal. |

Justificativa: PRD exige periodicidades mensal/trimestral/semestral/anual (FR-2) — todas derivadas desta única dimensão conformada.

### dim_edital
Grão: 1 linha por versão vigente de edital (SCD Tipo 1 nesta fase — histórico de alterações não é mantido, apenas o estado mais recente).

| Campo | Origem |
|---|---|
| sk_edital (PK) | Técnica |
| id_edital_origem | `editais.id` |
| nome, ano, numero, tipo (1-bolsa/2-auxílio), caracteristica, personalidade_juridica, uso, quota, edital_pai_id | `editais.*` |
| sk_modalidade (FK) | via `editais.modalidade_id` → `dim_modalidade` |
| sk_setor (FK) | via `editais.setor_id` → `dim_setor` |
| dt_criacao_origem, dt_atualizacao_origem | `editais.created_at/updated_at` |
| flag_ativo | Regra: `editais.acesso_restrito = 0` (proxy documentado; sujeito a validação funcional) |

### dim_chamada
Grão: 1 linha por `edital_chamadas.id`.

| Campo | Origem |
|---|---|
| sk_chamada (PK), id_chamada_origem | `edital_chamadas.id` |
| sk_edital (FK) | `edital_chamadas.edital_id` |
| numero, grupo, nome | `edital_chamadas.*` |
| dt_inicio_sk, dt_fim_sk (FK dim_tempo) | `edital_chamadas.inicio/fim` |
| flag_publicada | `edital_chamadas.publicada` |
| dt_recurso_inicio_sk, dt_recurso_fim_sk | `edital_chamadas.recurso_inicio/fim` |

### dim_modalidade
Grão: 1 linha por `modalidades.id`. Campos: sigla, nome, tipo (bolsa/auxílio), status, sub_programa_id.

### dim_setor
Grão: 1 linha por `setores.id`. Campos: nome, email, flag_responsavel_edital.

### dim_instituicao
Grão: 1 linha por `instituicoes.id`. Campos: sigla, nome, cnpj (dado institucional, não pessoal — sem pendência LGPD), modalidade (pública/privada), tipo, ativo.

### dim_usuario (role-playing: proponente / orientador / supervisor / gestor / ator de evento)
Grão: 1 linha por `users.id`.

| Campo | Origem | Observação LGPD |
|---|---|---|
| sk_usuario (PK), id_user_origem | `users.id` | — |
| nome, social_name | `users.name/social_name` | Dado pessoal — pendente política de mascaramento |
| tipo_documento, documento | `users.tipo_documento/documento` | **CPF em texto claro — item 1 de `ctl_lgpd_pendencias`** |
| email | `users.email` | Pendente política |
| membro_comite | `users.*` | — |
| data_nascimento, sexo, etnia, deficiencia_fisica, nacionalidade, nome_pai, nome_mae, telefone, celular1, celular2, banco_id, agencia, conta | `user_infos.*` | Dados sensíveis — pendente política |
| flag_ativo | `users.deleted_at IS NULL` | — |

### dim_convenio
Grão: 1 linha por `convenios.id`. Campos: numero, ano, nome, tipo (municipal/estadual/federal/internacional), assinatura, vigencia_inicial, vigencia_final, sk_gestor (FK dim_usuario).

### dim_situacao
Grão: 1 linha por combinação (dominio_origem, codigo_origem) — dimensão conformada genérica para os múltiplos domínios de status do Patronage que não têm tabela de apoio própria (`processos.situacao`, `termo_parcelas_pagas.situacao_pagamento`, `edital_chamadas.publicada`, `termos.status`).

| Campo | Origem |
|---|---|
| sk_situacao (PK) | Técnica |
| dominio_origem | Ex.: `'processo'`, `'pagamento'`, `'chamada_publicacao'`, `'termo'` |
| codigo_origem | Valor bruto da coluna de origem |
| descricao | Extraída do COMMENT do DDL (ex.: "1 - pago, 2 - pago parcialmente, 3 - não pago") |

Justificativa: no schema `patronage`, esses domínios são `tinyint`/`enum` sem tabela de apoio — a dimensão conformada evita espalhar `CASE WHEN` pelos fatos e views.

### dim_fonte_pagadora
Grão: 1 linha por `fonte_pagadoras.id`. Campos: nome, numero, natureza (governo/convênio), tipo (custeio/capital).

### dim_subacao
Grão: 1 linha por `subacoes.id`. Campos: nome, numero, ativa, acao_id (→ `acoes`). Usada como lado Patronage da ponte com o SIGEF.

## 2. Tabelas Ponte

### ponte_edital_sigef_subacao
Grão: 1 linha por vínculo vigente entre edital e subação/processo SIGEF.

| Campo | Descrição |
|---|---|
| sk_ponte (PK) | Técnica |
| sk_edital (FK dim_edital) | Lado Patronage |
| sk_subacao (FK dim_subacao, nullable) | Lado Patronage, se mapeado via `subacoes` |
| nuprocesso_sigef | Número de processo no SIGEF, quando o vínculo é direto por processo (não por subação) |
| dt_vigencia_inicio, dt_vigencia_fim | Vigência do de-para |
| responsavel_funcional | Nome/matrícula de quem validou o vínculo (conforme mitigação do addendum técnico, seção 5) |
| confiabilidade | `'alta'`, `'media'`, `'baixa'` |
| flag_ativo | — |

### ponte_proponente_credor_sigef
Grão: 1 linha por vínculo vigente entre proponente Patronage e credor SIGEF.

| Campo | Descrição |
|---|---|
| sk_ponte (PK) | Técnica |
| sk_usuario (FK dim_usuario) | Lado Patronage |
| cpf_cnpj | Documento usado no batimento (mesmo valor de `dim_usuario.documento`, mantido aqui para desacoplar a ponte de mudanças cadastrais) |
| cdcredor_sigef | `cdcredor` do SIGEF |
| dt_vigencia_inicio, dt_vigencia_fim | — |
| confiabilidade | `'alta'`, `'media'`, `'baixa'` |
| flag_ativo | — |

## 3. Fatos

### fato_chamada_ciclo
Grão: 1 linha por `edital_chamadas.id`. Fato de instantâneo (accumulating snapshot) para tempo de ciclo.

| Métrica/FK | Origem/Cálculo |
|---|---|
| sk_chamada, sk_edital, sk_modalidade, sk_setor (FKs) | via `dim_chamada`/`dim_edital` |
| sk_dt_abertura, sk_dt_fechamento (FK dim_tempo) | `edital_chamadas.inicio/fim` |
| qtd_dias_ciclo | `DATEDIFF(fim, inicio)` |
| qtd_processos_recebidos | `COUNT(processos.id)` por `edital_chamada_id` |
| qtd_processos_aprovados / qtd_processos_reprovados | `COUNT(...)` por `processos.situacao` via `dim_situacao` |
| qtd_erros_step | `COUNT` a partir de `erro_steps_chamada` com algum flag `erro* = 1` |
| sk_situacao_publicacao (FK dim_situacao) | `edital_chamadas.publicada` |

Atende ao Painel Operacional: "volume por período, status/publicação, tempo médio de ciclo e principais gargalos".

### fato_processo_atividade
Grão: 1 linha por `processos.id`.

| Métrica/FK | Origem/Cálculo |
|---|---|
| id_processo_origem, sk_edital, sk_chamada, sk_instituicao, sk_area | via FKs de `processos` |
| sk_proponente (FK dim_usuario, role=proponente) | `processos.user_id` |
| sk_orientador, sk_supervisor (FK dim_usuario) | `processos.orientador_id/supervisor_id` |
| sk_dt_envio, sk_dt_assinatura (FK dim_tempo) | `processos.envio/data_assinatura` |
| qtd_dias_ate_assinatura | `DATEDIFF(data_assinatura, envio)` |
| valor_concedido | `processos.valor_concedido` |
| sk_situacao (FK dim_situacao, domínio='processo') | `processos.situacao` |
| step_atual | `processos.step` |

### fato_convenio_execucao
Grão: 1 linha por (convênio x mês de competência).

| Métrica/FK | Origem/Cálculo |
|---|---|
| sk_convenio (FK) | `convenios.id` |
| sk_tempo_competencia (FK dim_tempo, usar dia 1 do mês) | `convenio_planejamentos.mes/ano` |
| valor_planejado | `convenio_planejamentos.valor` |
| valor_executado | Somatório de despesas do período (`convenio_financeiro.despesa_corrente_custeio + despesa_corrente_capital`, rateado/associado ao mês na Fase 2 — regra de rateio a validar com negócio) |
| valor_aditivado | `convenio_aditivo_financeiros.valor` do período |
| sk_situacao_relatorio (FK dim_situacao) | Derivado de `convenios.relatorio/relatorio_parcial/relatorio_final` vs. data atual |
| dias_atraso_prestacao | `DATEDIFF(CURDATE(), prestacao_final)` quando aplicável e não entregue |

Atende ao Painel Gerencial: "quantidade por tipo, vigência, situação de relatórios e aderência a prazos".

### fato_financeiro_patronage
Grão: 1 linha por parcela paga (`termo_parcelas_pagas.id`).

| Métrica/FK | Origem |
|---|---|
| id_termo_parcela_paga_origem | `termo_parcelas_pagas.id` |
| sk_edital (FK, via `processos.edital_chamada_id → edital_chamadas.edital_id`) | Caminho de junção da seção 5 do blueprint |
| sk_proponente (FK dim_usuario) | via `processos.user_id` |
| sk_subacao (FK dim_subacao) | `termo_parcelas_pagas.subacao_id` |
| sk_fonte_pagadora (FK) | `termo_parcelas_pagas.fonte_id` |
| sk_tempo_vencimento (FK dim_tempo) | `termo_parcelas.mes_vencimento/ano_vencimento` |
| sk_tempo_pagamento (FK dim_tempo, nullable) | `termo_parcelas_pagas.data_pagamento` |
| valor_parcela | `termo_parcelas.valor` |
| valor_pago | `termo_parcelas_pagas.valor_pago` |
| sk_situacao_pagamento (FK dim_situacao, domínio='pagamento') | `termo_parcelas_pagas.situacao_pagamento` |
| ordem_bancaria, nota_empenho | `termo_parcelas_pagas.*` — chave de cruzamento textual auxiliar com `fato_financeiro_sigef` |
| flag_inserido_via_api | `termo_parcelas_pagas.inserido_via_api` |

Este é o fato "lado Patronage" da reconciliação.

### fato_financeiro_sigef
Grão: 1 linha por Ordem Bancária SIGEF (`/sigef/ordembancaria/`).

| Campo | Origem |
|---|---|
| id_ordem_bancaria_origem | Chave do payload SIGEF |
| sk_subacao_sigef (nullable) | Resolvido via `ponte_edital_sigef_subacao` na Fase 2 |
| cdcredor, cpf_cnpj_credor | Payload SIGEF |
| sk_dt_pagamento, sk_dt_transacao (FK dim_tempo) | `dtpagamento`, `dttransacao` |
| valor_total | `vltotal` |
| domicilio_origem, domicilio_destino | Payload |
| cd_situacao_ordem_bancaria | `cdsituacaoordembancaria` |
| id_lote_carga (FK ctl_lote_carga) | Rastreabilidade do lote D+1 |

### fato_reconciliacao_sigef_patronage
Grão: 1 linha por (Edital + CPF + competência) batida em um lote — fato central do Painel de Conciliação.

| Campo | Origem/Cálculo |
|---|---|
| sk_edital, sk_proponente (FK) | Chave de negócio (Edital + CPF) |
| sk_tempo_competencia (FK dim_tempo) | Mês de referência do batimento |
| valor_patronage | Agregado de `fato_financeiro_patronage` no período |
| valor_sigef | Agregado de `fato_financeiro_sigef` no período, resolvido via pontes |
| diferenca_valor | `valor_patronage - valor_sigef` |
| status_patronage, status_sigef | Situação em cada lado |
| flag_divergencia | `1` se `diferenca_valor <> 0` ou status incompatíveis ou ausência em um dos lados |
| tipo_divergencia | `'ausencia_sigef'`, `'ausencia_patronage'`, `'diferenca_valor'`, `'diferenca_status'`, `'ok'` |
| id_lote_carga (FK) | Trilha de auditoria por lote D+1, conforme critério de homologação do painel |

Casos sem correspondência confiável (baixa confiabilidade na ponte ou ausência total) **não** entram consolidados aqui — vão para `exc_reconciliacao_sigef_patronage` (ver script 06), conforme regra obrigatória do PRD (FR-4).

### fato_eventos_operacionais_diario
Grão: 1 linha por (dia x log_name x event x subject_type) — agregação diária de `activity_log`, não replicação linha a linha.

| Campo | Origem/Cálculo |
|---|---|
| sk_dt_evento (FK dim_tempo) | `DATE(activity_log.created_at)` |
| log_name, event, subject_type | `activity_log.*` |
| qtd_eventos | `COUNT(*)` |
| qtd_atores_distintos | `COUNT(DISTINCT causer_id)` |
| id_lote_carga (FK) | — |

Suporta auditoria/qualidade operacional (FR-3/FR-4) sem herdar o custo de volume de `activity_log` (338k+ linhas e crescendo 5–7%/mês, conforme volumetria).

## 4. Rastreabilidade (lineage) — resumo

| Fato/Dimensão | Origem direta (patronage) | Origem indireta |
|---|---|---|
| dim_edital | editais | modalidades, setores |
| dim_chamada | edital_chamadas | editais |
| dim_usuario | users | user_infos, bancos |
| dim_convenio | convenios | gestores |
| dim_situacao | (múltiplas colunas enum/tinyint) | processos, termo_parcelas_pagas, edital_chamadas, termos |
| fato_chamada_ciclo | edital_chamadas | processos, erro_steps_chamada |
| fato_processo_atividade | processos | edital_chamadas, instituicoes, areas |
| fato_convenio_execucao | convenio_planejamentos, convenio_financeiro | convenios, convenio_aditivo_financeiros |
| fato_financeiro_patronage | termo_parcelas_pagas | termo_parcelas, termos, processos, edital_chamadas, editais |
| fato_financeiro_sigef | API SIGEF `/sigef/ordembancaria/` | — |
| fato_reconciliacao_sigef_patronage | fato_financeiro_patronage, fato_financeiro_sigef | ponte_edital_sigef_subacao, ponte_proponente_credor_sigef |
| fato_eventos_operacionais_diario | activity_log | — |

O lineage completo campo a campo (dicionário de dados final) será entregue na Fase 3, após a estabilização das procedures de carga (Fase 2), para refletir eventuais ajustes de regra descobertos na implementação.
