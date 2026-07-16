# Criterios de Aceite e Consultas de Validacao por Painel

Todas as consultas abaixo foram executadas de fato neste ambiente contra os
dados de teste sinteticos (1 edital, 1 chamada, 1 processo, 1 convenio, 1
pagamento, 1 ordem bancaria SIGEF) — os resultados de exemplo refletem esse
cenario minimo e servem como modelo para os testes reais com a base
completa do `patronage`.

## 1. Painel Operacional de Chamadas e Editais

**Criterios de aceite:**
- Toda chamada com `edital_chamadas.publicada = 1` deve aparecer em `vw_painel_operacional_chamadas`.
- `qtd_dias_ciclo` deve ser igual a `DATEDIFF(dt_fim, dt_inicio)` (validar contra a origem).
- `qtd_processos_recebidos` deve bater com a contagem direta em `patronage.processos`.

**Consultas de validacao:**
```sql
-- (a) Toda chamada publicada esta representada no fato?
SELECT COUNT(*) AS chamadas_publicadas_patronage
FROM patronage.edital_chamadas WHERE publicada = 1;

SELECT COUNT(*) AS chamadas_no_fato
FROM fato_chamada_ciclo fcc JOIN dim_situacao s ON s.sk_situacao = fcc.sk_situacao_publicacao
WHERE s.codigo_origem = '1';
-- os dois numeros devem ser iguais

-- (b) Conferencia de volume de processos por chamada (exemplo testado)
SELECT * FROM vw_painel_operacional_chamadas WHERE id_chamada_origem = 444;
-- esperado: qtd_processos_recebidos=1, qtd_dias_ciclo=31, situacao_publicacao='Publicada'
```

## 2. Painel Gerencial de Convenios e Execucao

**Criterios de aceite:**
- Todo convenio com planejamento em `convenio_planejamentos` deve ter ao menos uma linha em `fato_convenio_execucao`.
- `pct_execucao_planejado` > 150% deve ser tratavel como alerta operacional (execucao muito acima do planejado no mes — investigar rateio).
- `flag_atraso_prestacao = 1` deve corresponder exatamente aos convenios com `prestacao_final < CURDATE()` e sem relatorio final.

**Consultas de validacao:**
```sql
-- (a) Cobertura: todo financeiro de convenio esta representado?
SELECT COUNT(DISTINCT financeiro_id) FROM patronage.convenio_planejamentos;
SELECT COUNT(*) FROM fato_convenio_execucao;

-- (b) Conferencia de execucao (exemplo testado)
SELECT * FROM vw_painel_gerencial_convenios WHERE id_convenio_origem = 1;
-- esperado: valor_planejado=1000.00, valor_executado=12000.00 (soma custeio+capital do
-- convenio_financeiro associado), pct_execucao_planejado=1200.0 -- ALERTA: validar regra
-- de rateio com a area financeira (ver pendencia registrada em 02_blueprint_fase2_etl.md, 3.2)

-- (c) Convenios em atraso de prestacao de contas
SELECT * FROM vw_painel_gerencial_convenios WHERE flag_atraso_prestacao = 1;
```

## 3. Painel de Conciliacao SIGEF x Patronage

**Criterios de aceite:**
- `vw_painel_conciliacao_atual` deve ter exatamente 1 linha por `(edital, proponente, competencia)` — nunca duplicada (checar unicidade).
- Todo registro com `flag_divergencia = 1` E ponte confiavel deve estar em `vw_painel_conciliacao_atual`, nao em `vw_painel_conciliacao_excecoes`.
- Todo registro sem ponte confiavel deve estar em `vw_painel_conciliacao_excecoes`, nunca silenciosamente ausente dos dois.

**Consultas de validacao:**
```sql
-- (a) Checar duplicidade (deve retornar 0 linhas)
SELECT sk_edital, sk_proponente, ano_mes_competencia, COUNT(*)
FROM mv_reconciliacao_atual
GROUP BY sk_edital, sk_proponente, ano_mes_competencia
HAVING COUNT(*) > 1;

-- (b) Conferencia de cobertura: soma de Patronage no periodo == soma refletida na
-- reconciliacao (considerando tambem a fila de excecao, que nao entra no consolidado)
SELECT SUM(valor_pago) FROM fato_financeiro_patronage WHERE ano_mes_vencimento = 202602;
SELECT SUM(valor_patronage) FROM mv_reconciliacao_atual WHERE ano_mes_competencia = 202602
UNION ALL
SELECT SUM(valor_patronage) FROM exc_reconciliacao_sigef_patronage WHERE ano_mes_competencia = 202602;
-- a soma das duas linhas do segundo bloco deve bater com o primeiro numero

-- (c) Exemplo testado: caso sem ponte edital-subacao validada cai corretamente na excecao
SELECT * FROM vw_painel_conciliacao_excecoes WHERE ano_mes_competencia = 202602;
-- esperado: 1 linha, tipo_excecao='chave_ambigua_ponte', status_tratativa='pendente'

-- (d) Indicador de idade das divergencias (ganho de valor - ver decisao acordada)
SELECT * FROM vw_painel_conciliacao_idade_divergencias;
```

## 4. Painel Executivo C-Level de KPIs Institucionais

**Criterios de aceite:**
- `vw_painel_executivo_kpis_mensal` deve ter, no maximo, 1 linha por `ano_mes`.
- `vw_painel_executivo_comparativo_anual` deve ser a soma/media exata dos meses do respectivo ano (conferir manualmente ao menos uma vez por trimestre).
- `pct_aprovacao` deve estar sempre entre 0 e 100 (ou NULL quando nao ha processos recebidos no mes).

**Consultas de validacao:**
```sql
-- (a) Unicidade por ano_mes
SELECT ano_mes, COUNT(*) FROM mv_kpi_executivo_mensal GROUP BY ano_mes HAVING COUNT(*) > 1;

-- (b) Conferencia do comparativo anual contra a soma manual dos meses (exemplo testado)
SELECT * FROM vw_painel_executivo_comparativo_anual WHERE ano = 2026;
SELECT SUM(qtd_editais_publicados), SUM(qtd_convenios_firmados), SUM(valor_investimento_total)
FROM vw_painel_executivo_kpis_mensal WHERE ano = 2026;
-- os totais devem ser identicos

-- (c) Consistencia de faixa do percentual de aprovacao
SELECT * FROM vw_painel_executivo_kpis_mensal WHERE pct_aprovacao NOT BETWEEN 0 AND 100;
-- deve retornar 0 linhas
```

## 5. Criterios de aceite transversais (qualquer painel)
- Nenhuma view deve expor `sk_*` (chaves tecnicas) como coluna principal — sempre resolvidas para nome/descricao (ja implementado em todas as 9 views).
- Toda consulta de um painel deve responder em menos de 2 segundos com o volume real do `patronage` (a validar em ambiente de homologacao com dados de producao — os testes aqui foram feitos com volume sintetico minimo, nao substituem teste de carga real).
- `ctl_lote_carga` do dia deve estar `concluido` ou `concluido_com_erro` (nunca `iniciado` residual) antes de considerar os paineis do dia como confiaveis:
  ```sql
  SELECT * FROM ctl_lote_carga WHERE data_referencia = CURDATE() AND dominio = 'orquestracao_d1';
  ```

## 6. Pendencia de teste de carga (fora do escopo desta rodada)
Os testes acima validam **corretude funcional** com dados sinteticos. Um
teste de **volume/performance** com a volumetria real do `patronage`
(centenas de milhares de processos/pagamentos, conforme `volumetria.md`) e
recomendado antes de produtizar — em especial para `fato_eventos_operacionais_diario`
e as procedures de reconciliacao, que fazem agregacoes com `GROUP BY` e
`ROW_NUMBER()` que se beneficiam de indices adicionais dependendo do volume
real observado.
