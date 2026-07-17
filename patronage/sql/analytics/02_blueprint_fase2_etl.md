# Blueprint — Fase 2: ETL / Reconciliacao — patronage_analytics

## 1. O que esta fase entrega

| Script | Conteudo |
|---|---|
| `sql/07_procedures_landing.sql` | 24 procedures `sp_lnd_carga_*` (Patronage -> Landing), incremental por watermark ou full |
| `sql/08_procedures_dimensoes.sql` | `sp_povoar_dim_tempo` + 10 procedures de carga de dimensao + `sp_carga_dimensoes` (orquestradora) |
| `sql/09_procedures_fatos.sql` | 6 procedures de carga de fato + `sp_carga_fatos` (orquestradora) |
| `sql/10_procedures_reconciliacao.sql` | Bootstrap/sugestao das pontes + `sp_reconciliar_sigef_patronage` |
| `sql/11_procedures_dq.sql` | 13 regras de qualidade de dados (catalogo `ctl_dq_regra`) + `sp_executar_regras_dq` |
| `sql/12_client_sigef.py` | Client Python de integracao com a API SIGEF (roda fora do MySQL) |
| `sql/13_orquestracao_d1.sql` | `sp_executar_carga_d1` — ponto de entrada unico do processamento diario |

Todos os objetos foram **executados de fato** contra um MySQL/MariaDB real neste ambiente, com um schema `patronage` de teste (dados sinteticos minimos) simulando a origem — não apenas revisados por leitura. Isso incluiu: carga full, carga incremental (idempotencia sem duplicar), captura de alteracao real (`UPDATE` em `users` refletido no proximo incremental), reconciliacao SIGEF x Patronage com pontes, execucao das regras de DQ, e um teste negativo forcando falha para validar o tratamento de erro da orquestracao mestra.

## 2. Correcoes aplicadas a artefatos da Fase 1 durante a implementacao

Construir e testar de fato o ETL revelou 2 gaps reais no desenho da Fase 1, corrigidos diretamente em `sql/03_landing.sql` (portanto, se voce ja tinha baixado os arquivos da Fase 1, use as versoes atualizadas anexadas nesta entrega):

1. **Faltava a tabela de landing `lnd_patronage_convenio_instituicao`.** Sem ela, nao havia como ligar `convenio_financeiro` (que referencia `convenio_instituicao_id`) ao `convenio_id`, e a Fase 1 nao havia previsto essa tabela intermediaria. Adicionada, com sua procedure de carga correspondente.
2. **As tabelas `lnd_sigef_*` nao tinham chave natural unica.** Isso impedia upsert idempotente pelo client de integracao (script 12). Adicionadas UNIQUE KEYs: `numero_ordem_bancaria` (ordembancaria), `cdcredor` (credor), `numero_nl` (execucaofinanceiranl), e uma chave composta aproximada `(cpf_cnpj, data_pagamento, valor_pago)` para `ordemcronologica` (esse endpoint nao expõe um identificador proprio nos artefatos de mapeamento disponiveis — ver pendencia abaixo).
3. **[Corrigido durante a validacao da Fase 3] `sp_reconciliar_sigef_patronage` inseria o mesmo registro tanto no consolidado (`fato_reconciliacao_sigef_patronage`, como `ausencia_sigef`) quanto na fila de excecao.** O teste de ponta a ponta da Fase 3 (que reconstroi o pipeline do zero a cada rodada) expos esse double-counting: quando a ponte edital-subacao ou proponente-credor nao era confiavel, o valor aparecia contabilizado nos dois lugares ao mesmo tempo, inflando qualquer soma feita "consolidado + excecao". Corrigido para que o consolidado **so** receba registros com ponte confiavel em ambos os lados — sem ponte confiavel, o registro vai **exclusivamente** para `exc_reconciliacao_sigef_patronage`, conforme a regra original do FR-4 (que ja estava documentada no comentario da procedure, mas nao implementada corretamente). Revalidado com os dois cenarios (sem ponte / com ponte curada manualmente) — ver `06_criterios_aceite_validacao.md`, secao 3.

## 3. Decisoes de design que merecem sua atencao

### 3.0. Regra de governanca para continuidade (inferir x decidir)

Para acelerar execucao, adotamos a seguinte diretriz:

- Solucoes tecnicas de baixo risco e alinhadas a boas praticas podem ser inferidas e implementadas como baseline.
- Itens de politica institucional, regra financeira oficial ou classificacao funcional final devem ficar explicitamente marcados para decisao humana.

Baseline inferido por boas praticas (aplicar por padrao):
- mascaramento nas views de consumo geral e segregacao de acesso por perfil
- parametrizacao de regras de status e rateio em tabelas de configuracao versionadas
- resiliencia de integracao SIGEF (retry com backoff, checkpoint incremental, validacao minima de contrato)
- monitoramento operacional com alertas de lote, DQ bloqueante e pendencia de curadoria

Decisoes humanas obrigatorias (nao inferir automaticamente):
- dono da decisao LGPD e nivel de mascaramento por perfil
- regra oficial de negocio para codigos de situacao
- regra oficial de rateio financeiro de convenios
- responsavel e SLA de curadoria de pontes

Atualizacao 2026-07-17 (protocolo SIGEF):
- item de acesso/credencial da API SIGEF encerrado (FAPEMA com user/pass recebidos)
- pendencias restantes de SIGEF passam a ser tecnicas: homologar fluxo real de auth/paginacao/filtros com teste de ponta a ponta

### 3.1. `fato_reconciliacao_sigef_patronage` mantem historico por lote (nao e "estado atual")
A chave unica da tabela e `(sk_edital, sk_proponente, ano_mes_competencia, id_lote_carga)` — ou seja, **cada execucao diaria gera uma nova linha** para a mesma competencia, em vez de sobrescrever a anterior. Isso foi mantido deliberadamente (nao e um bug) porque:
- Atende ao requisito de trilha de auditoria por lote (FR-3/FR-4 do PRD): da para responder "o que a reconciliacao dizia no lote de tal dia".
- Documentos institucionais de conciliacao financeira tipicamente precisam desse historico para auditoria externa (TCE, CGU, etc.).

**Implicacao para a Fase 3:** as views semanticas do Painel de Conciliacao devem filtrar sempre o **ultimo lote por competencia** (`MAX(id_lote_carga)` ou `ROW_NUMBER()` particionado por `sk_edital, sk_proponente, ano_mes_competencia`), nao o `SUM`/`COUNT` bruto da tabela. Vou implementar isso explicitamente nas views da Fase 3 — sinalizando aqui para você validar se esse comportamento (historico completo) e realmente o que a instituicao quer, ou se prefere que eu troque para "so o estado mais recente" (mais simples, mas perde o historico).

### 3.2. Regra de rateio do `fato_convenio_execucao` (assuncao ja sinalizada na Fase 1, agora implementada)
`valor_executado` usa o total de `convenio_financeiro` (despesa custeio + capital) associado ao mes do `convenio_planejamentos` correspondente, **sem rateio proporcional** entre meses quando ha mais de um planejamento mensal para o mesmo `convenio_financeiro`. Testado e funcional, mas a regra de rateio real (se houver) precisa ser confirmada com a area financeira.

### 3.3. Vinculo `edital_dados_financeiro.sub_acao` -> `subacoes.id`
Nao ha FK declarada no DDL de origem entre esses campos (mais um reflexo do xlsx de descricoes vazio). A procedure `sp_sugerir_ponte_edital_subacao` assume que `sub_acao` referencia `subacoes.id` numericamente, e por isso **toda ponte sugerida nasce com `confiabilidade='baixa'` e `responsavel_funcional` marcado como pendente** — precisa de curadoria manual antes de entrar com confianca alta/media na reconciliacao. Isso é o comportamento pretendido (nunca reconciliar automaticamente sem validação humana nesse ponto), não uma limitação a corrigir.

### 3.4. Codigos de `processos.situacao` e `termos.status`
Continuam sem enum de negocio confirmado (ver Fase 1). Usei os codigos `2`/`3` como proxy de "aprovado"/"reprovado" em `fato_chamada_ciclo` **apenas como estimativa inicial**, documentada explicitamente no codigo (`sql/09_procedures_fatos.sql`) e aqui. Precisa de confirmacao funcional — os demais codigos ficam com rotulo `(pendente de definicao de negocio - codigo X)` em `dim_situacao`, propositalmente visivel nos paineis para nao mascarar o gap.

## 4. Como operar

### 4.1. Ordem de setup (uma vez)
```sql
-- Schema e objetos (Fase 1, ja rodado)
SOURCE 01_schema_setup.sql;
SOURCE 02_controle_auditoria.sql;
SOURCE 03_landing.sql;         -- versao atualizada nesta entrega
SOURCE 04_dimensoes.sql;
SOURCE 05_fatos.sql;
SOURCE 06_pontes_excecoes.sql;

-- Procedures (Fase 2)
SOURCE 07_procedures_landing.sql;
SOURCE 08_procedures_dimensoes.sql;
SOURCE 09_procedures_fatos.sql;
SOURCE 10_procedures_reconciliacao.sql;
SOURCE 11_procedures_dq.sql;
SOURCE 13_orquestracao_d1.sql;

-- Povoamento inicial da dimensao de tempo (uma vez; estender no futuro conforme necessario)
CALL sp_povoar_dim_tempo('2020-01-01', '2028-12-31');
```

### 4.2. Execucao diaria (janela D+1, 05h-07h)
```
05:00  -> cron/agendador externo executa: python3 12_client_sigef.py
              (carrega lnd_sigef_* do dia anterior; ~10-15 min esperado)
05:20  -> CALL sp_executar_carga_d1('incremental');
              (Landing Patronage -> Dimensoes -> Fatos -> Pontes -> Reconciliacao -> DQ)
07:00  -> painel disponivel para consumo (apos views da Fase 3)
```//
A automatizacao real desse agendamento (MySQL Events e/ou cron) entra na Fase 3, junto com as views. `sp_executar_carga_d1` ja esta pronta para ser chamada por um Event.

### 4.3. Variaveis de ambiente do client SIGEF (`12_client_sigef.py`)
```
SIGEF_BASE_URL, SIGEF_AUTH_URL, SIGEF_CLIENT_ID, SIGEF_CLIENT_SECRET
MYSQL_HOST, MYSQL_PORT, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE
```
**Atualizacao operacional:** com protocolo aprovado e credenciais (user/pass) recebidas pela FAPEMA, a pendencia de acesso foi encerrada. Proximo passo e homologar tecnicamente auth/paginacao/filtros no ambiente alvo e ajustar o client conforme o comportamento real da API.

## 5. Regras de qualidade de dados implementadas (13 regras ativas)

| Codigo | Severidade | Regra |
|---|---|---|
| EDT001 | bloqueante | Edital sem modalidade |
| EDT002 | alerta | Edital sem setor |
| CHM001 | bloqueante | Chamada publicada com fim antes do inicio |
| PRC001 | bloqueante | Processo assinado antes de enviado |
| PRC002 | bloqueante | Valor concedido negativo |
| USR001 | bloqueante | CPF/CNPJ nulo ou vazio |
| USR002 | alerta | CPF/CNPJ com tamanho invalido (nao 11 nem 14 digitos) |
| FIN001 | bloqueante | Valor pago negativo |
| FIN002 | alerta | Valor pago 50% maior que o valor da parcela |
| FIN003 | alerta | Pagamento "pago" sem ordem bancaria |
| CNV001 | bloqueante | Convenio com vigencia final antes da inicial |
| REC001 | alerta | Divergencia de valor SIGEF x Patronage acima de R$ 0,01 |
| PON001 | alerta | Ponte edital-subacao ainda pendente de curadoria |

Um lote com qualquer regra **bloqueante** reprovada fecha como `concluido_com_erro` (nao `falhou`) — os dados sao carregados, mas o lote fica sinalizado para revisão em `exc_qualidade_dados`. Novas regras podem ser adicionadas via `INSERT INTO ctl_dq_regra` a qualquer momento, sem alterar a procedure.

## 6. Testes realizados nesta rodada
- Carga **full** dos 24 dominios de Landing a partir de um `patronage` de teste.
- Carga **incremental** repetida (watermark) sem duplicar linhas.
- Captura de uma alteracao real simulada (`UPDATE users`) refletida corretamente no incremental seguinte.
- Pipeline completo Landing -> Dimensoes -> Fatos, com conferencia manual dos valores calculados (dias de ciclo, valores financeiros, aderencia de datas).
- Bootstrap de pontes (proponente-credor automatico; edital-subacao sugerido com curadoria pendente).
- Reconciliacao gerando corretamente `ausencia_sigef`/`ausencia_patronage`/`diferenca_valor` e alimentando a fila de excecao quando a ponte nao e confiavel.
- Execucao das 13 regras de DQ, incluindo uma violacao real detectada (REC001).
- Client SIGEF testado com chamadas de rede mockadas, validando upsert idempotente contra o banco real.
- **Teste negativo:** falha forcada no meio da orquestracao (`sp_executar_carga_d1`) confirmando que o `EXIT HANDLER` marca o lote como `falhou`, grava a mensagem de erro exata em `ctl_log_execucao` e propaga o erro ao chamador (`RESIGNAL`).

## 7. O que falta para a Fase 3 (ja combinada)
- Views semanticas para os 4 paineis (`vw_*`), incluindo a logica de "ultimo lote por competencia" mencionada na secao 3.1.
- Tabelas materializadas/snapshot (`mv_*`) e procedures de refresh incremental/full.
- MySQL Events para agendamento automatico de `sp_executar_carga_d1`.
- Dicionario de dados final consolidado (Fases 1+2+3).
- Checklist LGPD por entidade analitica.
- Plano de rollback e criterios de aceite/queries de validacao por painel.
