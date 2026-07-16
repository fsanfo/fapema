-- ============================================================================
-- patronage_analytics | Script 15 - Views Semanticas de Consumo dos Paineis
-- Fase 3: Views, Materializadas, Agendamento e Documentacao Final
--
-- Pre-requisito: scripts 01-14 ja executados (schema, fatos/dimensoes e
-- materializadas). As views abaixo sao a camada "presentation" (ver
-- blueprint 00, secao 3) - e o que as ferramentas de BI/paineis devem
-- consultar diretamente, nunca as tabelas fato/dimensao cruas.
-- ============================================================================

USE `patronage_analytics`;

-- ============================================================================
-- PAINEL OPERACIONAL DE CHAMADAS E EDITAIS
-- ============================================================================

CREATE OR REPLACE VIEW `vw_painel_operacional_chamadas` AS
SELECT
    e.id_edital_origem, e.nome AS edital, e.ano AS ano_edital,
    m.sigla AS modalidade, s.nome AS setor,
    c.id_chamada_origem, c.nome AS chamada, c.numero AS numero_chamada,
    c.dt_inicio, c.dt_fim,
    fcc.qtd_dias_ciclo,
    fcc.qtd_processos_recebidos, fcc.qtd_processos_aprovados, fcc.qtd_processos_reprovados,
    fcc.qtd_erros_step,
    sit.descricao AS situacao_publicacao,
    fcc.dt_carga AS dt_ultima_atualizacao
FROM fato_chamada_ciclo fcc
JOIN dim_chamada c ON c.sk_chamada = fcc.sk_chamada
JOIN dim_edital e ON e.sk_edital = fcc.sk_edital
LEFT JOIN dim_modalidade m ON m.sk_modalidade = fcc.sk_modalidade
LEFT JOIN dim_setor s ON s.sk_setor = fcc.sk_setor
LEFT JOIN dim_situacao sit ON sit.sk_situacao = fcc.sk_situacao_publicacao;

CREATE OR REPLACE VIEW `vw_painel_operacional_processos` AS
SELECT
    fpa.id_processo_origem, e.nome AS edital, c.nome AS chamada,
    inst.sigla AS instituicao, prop.documento AS documento_proponente,
    prop.nome AS nome_proponente, orient.nome AS nome_orientador,
    fpa.dt_envio, fpa.dt_assinatura, fpa.qtd_dias_ate_assinatura,
    fpa.valor_concedido, sit.descricao AS situacao_processo, fpa.step_atual
FROM fato_processo_atividade fpa
JOIN dim_chamada c ON c.sk_chamada = fpa.sk_chamada
LEFT JOIN dim_edital e ON e.sk_edital = fpa.sk_edital
LEFT JOIN dim_instituicao inst ON inst.sk_instituicao = fpa.sk_instituicao
LEFT JOIN dim_usuario prop ON prop.sk_usuario = fpa.sk_proponente
LEFT JOIN dim_usuario orient ON orient.sk_usuario = fpa.sk_orientador
LEFT JOIN dim_situacao sit ON sit.sk_situacao = fpa.sk_situacao;

-- ============================================================================
-- PAINEL GERENCIAL DE CONVENIOS E EXECUCAO
-- ============================================================================

CREATE OR REPLACE VIEW `vw_painel_gerencial_convenios` AS
SELECT
    cv.id_convenio_origem, cv.numero AS numero_convenio, cv.nome AS convenio,
    cv.tipo AS tipo_convenio, cv.dt_assinatura, cv.dt_vigencia_inicial, cv.dt_vigencia_final,
    fce.ano_mes_competencia,
    fce.valor_planejado, fce.valor_executado, fce.valor_aditivado,
    ROUND(IF(fce.valor_planejado > 0, fce.valor_executado / fce.valor_planejado * 100, NULL), 1)
        AS pct_execucao_planejado,
    sit.descricao AS situacao_relatorio,
    fce.dias_atraso_prestacao,
    IF(fce.dias_atraso_prestacao > 0, 1, 0) AS flag_atraso_prestacao
FROM fato_convenio_execucao fce
JOIN dim_convenio cv ON cv.sk_convenio = fce.sk_convenio
LEFT JOIN dim_situacao sit ON sit.sk_situacao = fce.sk_situacao_relatorio;

-- ============================================================================
-- PAINEL DE CONCILIACAO SIGEF x PATRONAGE
-- ============================================================================

-- Estado ATUAL (consumo principal do painel) - baseado na materializada
-- mv_reconciliacao_atual (script 14), que ja resolve "ultimo lote por chave".
CREATE OR REPLACE VIEW `vw_painel_conciliacao_atual` AS
SELECT
    e.id_edital_origem, e.nome AS edital,
    prop.documento AS documento_proponente, prop.nome AS nome_proponente,
    m.ano_mes_competencia,
    m.valor_patronage, m.valor_sigef, m.diferenca_valor,
    m.status_patronage, m.status_sigef,
    m.flag_divergencia, m.tipo_divergencia,
    m.id_lote_carga_origem, m.dt_atualizacao
FROM mv_reconciliacao_atual m
JOIN dim_edital e ON e.sk_edital = m.sk_edital
JOIN dim_usuario prop ON prop.sk_usuario = m.sk_proponente;

-- Historico completo por lote (drill-down/auditoria) - baseado na tabela
-- fato_reconciliacao_sigef_patronage (Fase 2), que preserva TODAS as
-- execucoes, nao so a mais recente. Uso: auditoria, "o que dizia no dia X".
CREATE OR REPLACE VIEW `vw_painel_conciliacao_historico` AS
SELECT
    e.id_edital_origem, e.nome AS edital,
    prop.documento AS documento_proponente, prop.nome AS nome_proponente,
    r.ano_mes_competencia, r.valor_patronage, r.valor_sigef, r.diferenca_valor,
    r.status_patronage, r.status_sigef, r.flag_divergencia, r.tipo_divergencia,
    r.id_lote_carga, lc.data_referencia AS data_lote, r.dt_conciliacao
FROM fato_reconciliacao_sigef_patronage r
JOIN dim_edital e ON e.sk_edital = r.sk_edital
JOIN dim_usuario prop ON prop.sk_usuario = r.sk_proponente
LEFT JOIN ctl_lote_carga lc ON lc.id_lote = r.id_lote_carga;

-- Fila de curadoria (casos sem correspondencia confiavel - FR-4 do PRD)
CREATE OR REPLACE VIEW `vw_painel_conciliacao_excecoes` AS
SELECT
    x.id_excecao, x.tipo_excecao,
    e.nome AS edital, prop.documento AS documento_proponente, prop.nome AS nome_proponente,
    x.ano_mes_competencia, x.valor_patronage, x.valor_sigef,
    x.status_patronage, x.status_sigef,
    x.status_tratativa, x.responsavel_curadoria,
    x.dt_identificacao, x.dt_tratativa,
    DATEDIFF(CURDATE(), x.dt_identificacao) AS dias_em_aberto
FROM exc_reconciliacao_sigef_patronage x
LEFT JOIN dim_edital e ON e.sk_edital = x.sk_edital
LEFT JOIN dim_usuario prop ON prop.sk_usuario = x.sk_proponente;

-- Indicador de velocidade de resolucao (idade das divergencias em aberto,
-- em faixas) - ganho de valor discutido com o solicitante: mostra se o
-- processo de reconciliacao esta funcionando, nao so o saldo atual.
CREATE OR REPLACE VIEW `vw_painel_conciliacao_idade_divergencias` AS
SELECT
    CASE
        WHEN DATEDIFF(CURDATE(), dt_identificacao) <= 7 THEN '0-7 dias'
        WHEN DATEDIFF(CURDATE(), dt_identificacao) <= 15 THEN '8-15 dias'
        WHEN DATEDIFF(CURDATE(), dt_identificacao) <= 30 THEN '16-30 dias'
        ELSE 'acima de 30 dias'
    END AS faixa_idade,
    COUNT(*) AS qtd_casos,
    SUM(COALESCE(valor_patronage, 0)) AS valor_total
FROM exc_reconciliacao_sigef_patronage
WHERE status_tratativa IN ('pendente', 'em_analise')
GROUP BY faixa_idade;

-- ============================================================================
-- PAINEL EXECUTIVO C-LEVEL DE KPIS INSTITUCIONAIS
-- ============================================================================

-- Serie mensal (tendencia multitemporal - ver mockup painel-executivo-kpis.html)
CREATE OR REPLACE VIEW `vw_painel_executivo_kpis_mensal` AS
SELECT
    ano_mes, FLOOR(ano_mes / 100) AS ano, MOD(ano_mes, 100) AS mes,
    qtd_editais_publicados, qtd_convenios_firmados, valor_investimento_total,
    tempo_medio_ciclo_chamadas, qtd_divergencias_abertas, valor_divergencias_abertas,
    qtd_processos_recebidos, qtd_processos_aprovados,
    ROUND(IF(qtd_processos_recebidos > 0, qtd_processos_aprovados / qtd_processos_recebidos * 100, NULL), 1)
        AS pct_aprovacao,
    dt_atualizacao
FROM mv_kpi_executivo_mensal;

-- Comparativo ano a ano (agregado a partir da serie mensal acima)
CREATE OR REPLACE VIEW `vw_painel_executivo_comparativo_anual` AS
SELECT
    ano,
    SUM(qtd_editais_publicados) AS qtd_editais_publicados_ano,
    SUM(qtd_convenios_firmados) AS qtd_convenios_firmados_ano,
    SUM(valor_investimento_total) AS valor_investimento_total_ano,
    ROUND(AVG(tempo_medio_ciclo_chamadas), 1) AS tempo_medio_ciclo_chamadas_ano,
    SUM(qtd_processos_recebidos) AS qtd_processos_recebidos_ano,
    SUM(qtd_processos_aprovados) AS qtd_processos_aprovados_ano
FROM vw_painel_executivo_kpis_mensal
GROUP BY ano;
