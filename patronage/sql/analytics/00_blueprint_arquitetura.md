# Blueprint de Arquitetura — patronage_analytics (Fase 1: Modelagem e Schema Base)

## 1. Objetivo desta fase

Estabelecer o schema analítico `patronage_analytics` no mesmo servidor MySQL 8.0.34 do schema transacional `patronage`, com:

- Camadas de dados (Landing, Curated/Dimensional).
- Modelo dimensional (Star Schema) para os 4 domínios do escopo mínimo da fase 1.
- Tabelas de controle, auditoria, watermark e qualidade de dados.
- Tabelas de ponte e exceção para a reconciliação SIGEF x Patronage.

**Fora desta fase** (entram nas fases seguintes, já combinadas com você): procedures de carga/transformação, procedures de reconciliação, script/pseudo-código do client SIGEF, views semânticas, tabelas materializadas (snapshot), MySQL Events, dicionário de dados final completo, checklist LGPD detalhado e plano de rollback.

## 2. Decisões registradas nesta rodada

| Tema | Decisão |
|---|---|
| Mascaramento LGPD | **Não aplicado nesta fase.** Documentado como pendência formal (ver `ctl_lgpd_pendencias` no script de controle). Campos sensíveis (CPF/documento, dados bancários, filiação, endereço, deficiência, etnia) trafegam em texto claro no schema analítico por decisão explícita do solicitante, até definição de política. |
| Ingestão SIGEF | Landing tables desenhadas nesta fase para receber o payload da API. O client/pseudo-código de integração fica para a Fase 2 (ETL), pois depende das procedures de carga. |
| Formato de entrega | Faseado. Esta é a Fase 1. |

## 3. Camadas de dados

```
patronage (schema transacional, somente leitura, nunca alterado)
        │
        │  INSERT...SELECT incremental (mesma instância MySQL, sem mover/apagar dados originais)
        ▼
patronage_analytics.lnd_*  (Landing — cópia rasa das entidades priorizadas, mais watermark)
        │
        │  procedures de transformação/curadoria (Fase 2)
        ▼
patronage_analytics.dim_* / fato_* / ponte_* / exc_*  (Curated — modelo dimensional)
        │
        │  procedures de agregação/refresh (Fase 3)
        ▼
patronage_analytics.mv_*  (Data Marts / Presentation — snapshots equivalentes a "materialized views")
        │
        ▼
patronage_analytics.vw_*  (Views semânticas de consumo pelos 4 painéis)
```

Justificativa da divisão Landing → Curated → Marts (e não apenas 2 camadas): a instrução de "não alterar nem mover dados originais" combinada com a necessidade de trilha de auditoria por lote (FR-3/FR-4 do PRD) exige um ponto de captura imutável e datado (Landing) antes de qualquer transformação, para permitir reprocessamento e auditoria sem tocar no `patronage`.

## 4. Fontes e prioridade de captura (Fase 1 cobre os domínios abaixo)

| Domínio | Tabelas de origem no `patronage` | Painel(is) que consome |
|---|---|---|
| Editais e Chamadas | `editais`, `edital_chamadas`, `edital_chamada_faixas`, `descricao_faixas`, `edital_dados_financeiro`, `modalidades`, `setores`, `erro_steps_chamada` | Operacional |
| Processos/Atividades | `processos`, `historico_processo_status`, `areas`, `sub_areas`, `instituicoes`, `polos` | Operacional, Executivo |
| Convênios | `convenios`, `convenio_financeiro`, `convenio_planejamentos`, `convenio_aditivos`, `convenio_aditivo_financeiros`, `convenio_instituicao` | Gerencial, Executivo |
| Financeiro Patronage (pagamentos) | `termos`, `termo_parcelas`, `termo_parcelas_pagas`, `subacoes`, `acoes`, `fonte_pagadoras`, `natureza_despesas` | Conciliação, Executivo |
| Pessoas/Identidade | `users`, `user_infos`, `gestores` | Todos (dimensão conformada) |
| Eventos operacionais (telemetria) | `activity_log` | Operacional (qualidade/auditoria) — **agregado diário**, não replicado linha a linha |
| SIGEF (externo) | `/sigef/ordembancaria/`, `/sigef/ordemcronologica/`, `/sigef/credor/`, `/sigef/execucaofinanceiranl/` | Conciliação, Executivo |

Volumetria confirma que `activity_log`, `logs` e `pulse_entries` são as maiores tabelas do schema (176MB, 84MB, 84MB respectivamente) e são telemetria técnica — o desenho evita replicá-las linha a linha na camada curated, usando agregação diária na Landing→Curated (detalhado no fato `fato_eventos_operacionais_diario`, Fase 1) e mantendo o raw apenas na Landing com retenção curta.

## 5. Caminho de junção para a chave de reconciliação (Edital + CPF)

```
users.documento (CPF)
   ← processos.user_id
   ← termos.processo_id
   ← termo_parcelas.termo_id
   ← termo_parcelas_pagas.termo_parcela_id   (pagamento realizado, valor_pago, situacao_pagamento)

processos.edital_chamada_id → edital_chamadas.edital_id → editais.id  (ID Edital)
```

No lado SIGEF (conforme `sigef_api_mapeamento_patronage.md`): `cdsubacao`/`nuprocesso` (equivalente a Edital) + `cdcredor` (equivalente a CPF/CNPJ do proponente) em `/sigef/ordembancaria/`.

Como não existe de-para direto e estável entre `editais.id` e `cdsubacao`/`nuprocesso` do SIGEF, nem entre `users.documento` e `cdcredor`, o modelo usa duas tabelas de ponte versionadas com responsável funcional e vigência (`ponte_edital_sigef_subacao`, `ponte_proponente_credor_sigef` — detalhadas no documento de modelo dimensional). Registros sem correspondência confiável caem em `exc_reconciliacao_sigef_patronage`, conforme FR-4 do PRD.

## 6. Convenção de nomenclatura

| Prefixo | Camada/Papel | Exemplo |
|---|---|---|
| `lnd_` | Landing (Patronage ou SIGEF) | `lnd_patronage_editais`, `lnd_sigef_ordembancaria` |
| `dim_` | Dimensão conformada | `dim_edital`, `dim_usuario` |
| `fato_` | Fato | `fato_chamada_ciclo` |
| `ponte_` | Tabela ponte (bridge) | `ponte_edital_sigef_subacao` |
| `exc_` | Fila de exceção auditável | `exc_reconciliacao_sigef_patronage` |
| `ctl_` | Controle, auditoria, watermark, DQ | `ctl_lote_carga` |
| `mv_` | Snapshot/agregação (equivalente a materialized view) — Fase 3 | `mv_kpi_executivo_mensal` |
| `vw_` | View semântica de consumo — Fase 3 | `vw_painel_operacional_chamadas` |

Todas as tabelas usam `sk_*` (surrogate key, `bigint unsigned AUTO_INCREMENT`) como chave técnica interna e preservam o `id` de origem em coluna `id_..._origem` para lineage e idempotência de carga (chave natural usada em `INSERT ... ON DUPLICATE KEY UPDATE` nas procedures da Fase 2).

## 7. Premissas técnicas aplicadas

- MySQL 8.0.34, `ENGINE=InnoDB`, `CHARSET=utf8mb4`, `COLLATE=utf8mb4_unicode_ci` (mesmo padrão do `patronage`).
- Todos os scripts são idempotentes: `CREATE SCHEMA IF NOT EXISTS`, `CREATE TABLE IF NOT EXISTS`. Alterações futuras de estrutura deverão ser feitas via scripts de migração incremental versionados (não incluídos nesta fase).
- Não há dependência de ferramentas pagas nem de recursos não suportados no MySQL 8 Community (sem materialized views nativas, sem `CREATE OR REPLACE FUNCTION` com recursos de versões superiores).
- Particionamento: previsto para a Fase 3, aplicado a `lnd_patronage_activity_log` e ao fato `fato_eventos_operacionais_diario` (por mês), já antecipado no desenho de colunas desta fase (coluna de partição `dt_evento`/`dt_carga` sempre presente e indexada).

## 8. Lacunas e suposições explícitas desta fase

1. **[GAP] Dicionário de negócio oficial vazio.** O arquivo `docs/patronage_tabelas_descricoes.xlsx` está com as 179 linhas no texto-modelo "Digite a descrição aqui" — nenhuma descrição de negócio foi efetivamente preenchida. As regras de negócio usadas neste desenho vêm dos comentários de coluna do DDL, do PRD/addendum e dos mockups HTML. O dicionário de dados final (Fase 3) marcará como "inferido" todo campo sem fonte de negócio explícita.
2. **[ASSUMPTION] Granularidade do fato de convênio** é mensal (mês de competência), pois `convenio_planejamentos` já é mensal e o painel gerencial pede "vigência" e "prestação de contas" — não há necessidade de granularidade diária.
3. **[ASSUMPTION] `dim_usuario` é uma dimensão conformada única** (role-playing dimension), reaproveitada como proponente, orientador, supervisor, gestor e ator de eventos, evitando duplicar a tabela `users`/`user_infos` em múltiplas dimensões. As views semânticas da Fase 3 farão os aliases de papel.
4. **[ASSUMPTION] `fato_eventos_operacionais_diario`** é pré-agregado (dia x módulo x tipo de evento) para não replicar as ~339 mil linhas/mês de `activity_log` na camada curated; o detalhe fino fica disponível na Landing por uma janela de retenção a definir na Fase 3.
5. **[PENDÊNCIA LGPD]** Nenhum mascaramento é aplicado nesta fase. Ver `ctl_lgpd_pendencias` para o registro formal do risco, conforme decisão do solicitante.
6. **[PENDÊNCIA]** Endpoints SIGEF de menor prioridade (`contas`, `razao`, `contacontabil`, `guiarecebimento`) não têm landing table nesta fase — apenas os 4 endpoints de maior relevância para conciliação (`ordembancaria`, `ordemcronologica`, `credor`, `execucaofinanceiranl`) foram modelados, conforme addendum técnico.

## 9. Ordem de execução dos scripts desta fase

1. `sql/01_schema_setup.sql` — criação do schema e convenções.
2. `sql/02_controle_auditoria.sql` — tabelas de controle, watermark, log, DQ e pendências LGPD.
3. `sql/03_landing.sql` — tabelas de landing (Patronage e SIGEF).
4. `sql/04_dimensoes.sql` — dimensões conformadas.
5. `sql/05_fatos.sql` — tabelas fato.
6. `sql/06_pontes_excecoes.sql` — tabelas ponte e fila de exceção.

Todos os scripts podem ser reexecutados sem erro (idempotentes) e não populam dados — populamento é responsabilidade das procedures da Fase 2.
