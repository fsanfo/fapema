-- ============================================================================
-- patronage_analytics | Script 09 - Procedures de Povoamento dos Fatos
-- Fase 2: ETL / Reconciliacao
--
-- Pre-requisito: dimensoes ja carregadas (script 08). Todas idempotentes via
-- ON DUPLICATE KEY UPDATE contra a chave natural/unique de cada fato.
-- ============================================================================

USE `patronage_analytics`;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_chamada_ciclo
--
-- [ASSUNCAO DE NEGOCIO - PENDENTE DE CONFIRMACAO] Os codigos 2 (aprovado) e 3
-- (reprovado) usados abaixo para qtd_processos_aprovados/reprovados NAO tem
-- enum documentado no DDL de origem (processos.situacao so documenta o
-- codigo 0 = "nao enviado" - ver GAP do xlsx de descricoes vazio, Fase 1).
-- Adotados por inferencia a partir do PRD/mockups ate confirmacao funcional;
-- ver tambem dim_situacao, dominio 'processo', que mantem os demais codigos
-- com rotulo de pendencia para nao mascarar o gap na camada semantica.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_chamada_ciclo`$$
CREATE PROCEDURE `sp_carga_fato_chamada_ciclo` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_chamada_ciclo (
        sk_chamada, sk_edital, sk_modalidade, sk_setor, dt_abertura, dt_fechamento,
        qtd_dias_ciclo, qtd_processos_recebidos, qtd_processos_aprovados,
        qtd_processos_reprovados, qtd_erros_step, sk_situacao_publicacao, id_lote_carga
    )
    SELECT
        dc.sk_chamada, dc.sk_edital, de.sk_modalidade, de.sk_setor,
        dc.dt_inicio, dc.dt_fim, DATEDIFF(dc.dt_fim, dc.dt_inicio),
        (SELECT COUNT(*) FROM lnd_patronage_processos p WHERE p.edital_chamada_id = c.id_origem),
        (SELECT COUNT(*) FROM lnd_patronage_processos p WHERE p.edital_chamada_id = c.id_origem AND p.situacao IN (2)),
        (SELECT COUNT(*) FROM lnd_patronage_processos p WHERE p.edital_chamada_id = c.id_origem AND p.situacao IN (3)),
        (SELECT COUNT(*) FROM lnd_patronage_erro_steps_chamada er WHERE er.edital_chamada_id = c.id_origem
            AND (er.erro_anexos=1 OR er.erro_documentacoes=1 OR er.erro_dados_contratacao=1
                 OR er.erro_termo_outorga=1 OR er.erro_termo_aditivo_valor=1
                 OR er.erro_termo_aditivo_prazo=1 OR er.erro_termo_apostilamento=1
                 OR er.erro_termo_aditivo=1)),
        ds.sk_situacao,
        p_id_lote
    FROM lnd_patronage_edital_chamadas c
    JOIN dim_chamada dc ON dc.id_chamada_origem = c.id_origem
    JOIN dim_edital de ON de.sk_edital = dc.sk_edital
    LEFT JOIN dim_situacao ds ON ds.dominio_origem = 'chamada_publicacao' AND ds.codigo_origem = c.publicada
    ON DUPLICATE KEY UPDATE
        sk_edital = VALUES(sk_edital), sk_modalidade = VALUES(sk_modalidade), sk_setor = VALUES(sk_setor),
        dt_abertura = VALUES(dt_abertura), dt_fechamento = VALUES(dt_fechamento),
        qtd_dias_ciclo = VALUES(qtd_dias_ciclo), qtd_processos_recebidos = VALUES(qtd_processos_recebidos),
        qtd_processos_aprovados = VALUES(qtd_processos_aprovados),
        qtd_processos_reprovados = VALUES(qtd_processos_reprovados),
        qtd_erros_step = VALUES(qtd_erros_step), sk_situacao_publicacao = VALUES(sk_situacao_publicacao),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_chamada_ciclo', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_processo_atividade
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_processo_atividade`$$
CREATE PROCEDURE `sp_carga_fato_processo_atividade` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_processo_atividade (
        id_processo_origem, sk_edital, sk_chamada, sk_instituicao, sk_area_origem,
        sk_proponente, sk_orientador, sk_supervisor, dt_envio, dt_assinatura,
        qtd_dias_ate_assinatura, valor_concedido, sk_situacao, step_atual, id_lote_carga
    )
    SELECT
        p.id_origem, dc.sk_edital, dc.sk_chamada, di.sk_instituicao, p.area_id,
        dp.sk_usuario, dor.sk_usuario, dsup.sk_usuario,
        DATE(p.envio), DATE(p.data_assinatura),
        DATEDIFF(p.data_assinatura, p.envio), p.valor_concedido,
        dsit.sk_situacao, p.step, p_id_lote
    FROM lnd_patronage_processos p
    JOIN dim_chamada dc ON dc.id_chamada_origem = p.edital_chamada_id
    LEFT JOIN dim_instituicao di ON di.id_instituicao_origem = p.instituicao_id
    LEFT JOIN dim_usuario dp ON dp.id_user_origem = p.user_id
    LEFT JOIN dim_usuario dor ON dor.id_user_origem = p.orientador_id
    LEFT JOIN dim_usuario dsup ON dsup.id_user_origem = p.supervisor_id
    LEFT JOIN dim_situacao dsit ON dsit.dominio_origem = 'processo' AND dsit.codigo_origem = p.situacao
    ON DUPLICATE KEY UPDATE
        sk_edital = VALUES(sk_edital), sk_chamada = VALUES(sk_chamada), sk_instituicao = VALUES(sk_instituicao),
        sk_area_origem = VALUES(sk_area_origem), sk_proponente = VALUES(sk_proponente),
        sk_orientador = VALUES(sk_orientador), sk_supervisor = VALUES(sk_supervisor),
        dt_envio = VALUES(dt_envio), dt_assinatura = VALUES(dt_assinatura),
        qtd_dias_ate_assinatura = VALUES(qtd_dias_ate_assinatura), valor_concedido = VALUES(valor_concedido),
        sk_situacao = VALUES(sk_situacao), step_atual = VALUES(step_atual),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_processo_atividade', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_convenio_execucao
-- Regra de rateio (ASSUNCAO - Fase 1, secao 8, item 2): a despesa executada de
-- convenio_financeiro (por convenio_instituicao) e associada ao mes do
-- planejamento (convenio_planejamentos) via financeiro_id, sem rateio
-- proporcional entre meses - valor_executado replica o total do financeiro no
-- mes em que ele aparece planejado. Sujeito a validacao funcional.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_convenio_execucao`$$
CREATE PROCEDURE `sp_carga_fato_convenio_execucao` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_convenio_execucao (
        sk_convenio, ano_mes_competencia, valor_planejado, valor_executado,
        valor_aditivado, sk_situacao_relatorio, dias_atraso_prestacao, id_lote_carga
    )
    SELECT
        dcv.sk_convenio,
        pl.ano * 100 + pl.mes AS ano_mes_competencia,
        SUM(pl.valor) AS valor_planejado,
        COALESCE(SUM(cf.despesa_corrente_custeio + cf.despesa_corrente_capital), 0) AS valor_executado,
        COALESCE((
            SELECT SUM(af.valor)
            FROM lnd_patronage_convenio_aditivo_financeiros af
            JOIN lnd_patronage_convenio_aditivos ca ON ca.id_origem = af.convenio_aditivo_id
            WHERE ca.convenio_id = c.id_origem
              AND YEAR(ca.assinatura) * 100 + MONTH(ca.assinatura) = (pl.ano * 100 + pl.mes)
        ), 0) AS valor_aditivado,
        dsit.sk_situacao,
        CASE
            WHEN c.prestacao_final IS NOT NULL AND c.prestacao_final < CURDATE() AND c.relatorio_final IS NULL
                THEN DATEDIFF(CURDATE(), c.prestacao_final)
            ELSE NULL
        END AS dias_atraso_prestacao,
        p_id_lote
    FROM lnd_patronage_convenio_planejamentos pl
    JOIN lnd_patronage_convenio_financeiro cf ON cf.id_origem = pl.financeiro_id
    JOIN lnd_patronage_convenio_instituicao ci ON ci.id_origem = cf.convenio_instituicao_id
    JOIN lnd_patronage_convenios c ON c.id_origem = ci.convenio_id
    JOIN dim_convenio dcv ON dcv.id_convenio_origem = c.id_origem
    LEFT JOIN dim_situacao dsit ON dsit.dominio_origem = 'convenio_relatorio'
        AND dsit.codigo_origem = IF(c.relatorio_final IS NOT NULL, '1', '0')
    GROUP BY dcv.sk_convenio, pl.ano, pl.mes, dsit.sk_situacao, c.prestacao_final, c.relatorio_final, c.id_origem
    ON DUPLICATE KEY UPDATE
        valor_planejado = VALUES(valor_planejado), valor_executado = VALUES(valor_executado),
        valor_aditivado = VALUES(valor_aditivado), sk_situacao_relatorio = VALUES(sk_situacao_relatorio),
        dias_atraso_prestacao = VALUES(dias_atraso_prestacao),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_convenio_execucao', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_financeiro_patronage
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_financeiro_patronage`$$
CREATE PROCEDURE `sp_carga_fato_financeiro_patronage` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_financeiro_patronage (
        id_termo_parcela_paga_origem, sk_edital, sk_proponente, sk_subacao, sk_fonte_pagadora,
        ano_mes_vencimento, dt_pagamento, valor_parcela, valor_pago, sk_situacao_pagamento,
        ordem_bancaria, nota_empenho, flag_inserido_via_api, id_lote_carga
    )
    SELECT
        tpp.id_origem, dc.sk_edital, du.sk_usuario, dsa.sk_subacao, dfp.sk_fonte,
        tp.ano_vencimento * 100 + tp.mes_vencimento, tpp.data_pagamento,
        tp.valor, tpp.valor_pago, dsit.sk_situacao,
        tpp.ordem_bancaria, tpp.nota_empenho, tpp.inserido_via_api, p_id_lote
    FROM lnd_patronage_termo_parcelas_pagas tpp
    JOIN lnd_patronage_termo_parcelas tp ON tp.id_origem = tpp.termo_parcela_id
    JOIN lnd_patronage_termos t ON t.id_origem = tp.termo_id
    JOIN lnd_patronage_processos p ON p.id_origem = t.processo_id
    JOIN dim_chamada dc ON dc.id_chamada_origem = p.edital_chamada_id
    LEFT JOIN dim_usuario du ON du.id_user_origem = p.user_id
    LEFT JOIN dim_subacao dsa ON dsa.id_subacao_origem = tpp.subacao_id
    LEFT JOIN dim_fonte_pagadora dfp ON dfp.id_fonte_origem = tpp.fonte_id
    LEFT JOIN dim_situacao dsit ON dsit.dominio_origem = 'pagamento' AND dsit.codigo_origem = tpp.situacao_pagamento
    ON DUPLICATE KEY UPDATE
        sk_edital = VALUES(sk_edital), sk_proponente = VALUES(sk_proponente), sk_subacao = VALUES(sk_subacao),
        sk_fonte_pagadora = VALUES(sk_fonte_pagadora), ano_mes_vencimento = VALUES(ano_mes_vencimento),
        dt_pagamento = VALUES(dt_pagamento), valor_parcela = VALUES(valor_parcela),
        valor_pago = VALUES(valor_pago), sk_situacao_pagamento = VALUES(sk_situacao_pagamento),
        ordem_bancaria = VALUES(ordem_bancaria), nota_empenho = VALUES(nota_empenho),
        flag_inserido_via_api = VALUES(flag_inserido_via_api),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_financeiro_patronage', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_financeiro_sigef: carrega a partir da Landing SIGEF
-- (populada pelo client de integracao - script 12)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_financeiro_sigef`$$
CREATE PROCEDURE `sp_carga_fato_financeiro_sigef` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_financeiro_sigef (
        id_ordem_bancaria_origem, sk_subacao, cdcredor, cpf_cnpj_credor, dt_pagamento,
        dt_transacao, valor_total, domicilio_origem, domicilio_destino,
        cd_situacao_ordem_bancaria, id_lote_carga
    )
    SELECT
        ob.numero_ordem_bancaria, dsa.sk_subacao, ob.cdcredor, ob.cdcredor, ob.dtpagamento,
        ob.dttransacao, ob.vltotal, ob.domicilio_origem, ob.domicilio_destino,
        ob.cdsituacaoordembancaria, p_id_lote
    FROM lnd_sigef_ordembancaria ob
    LEFT JOIN dim_subacao dsa ON dsa.id_subacao_origem = (
        SELECT s.id_origem FROM lnd_patronage_subacoes s WHERE s.numero = ob.cdsubacao LIMIT 1
    )
    WHERE ob.numero_ordem_bancaria IS NOT NULL
    ON DUPLICATE KEY UPDATE
        sk_subacao = VALUES(sk_subacao), cdcredor = VALUES(cdcredor), cpf_cnpj_credor = VALUES(cpf_cnpj_credor),
        dt_pagamento = VALUES(dt_pagamento), dt_transacao = VALUES(dt_transacao),
        valor_total = VALUES(valor_total), domicilio_origem = VALUES(domicilio_origem),
        domicilio_destino = VALUES(domicilio_destino),
        cd_situacao_ordem_bancaria = VALUES(cd_situacao_ordem_bancaria),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_financeiro_sigef', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fato_eventos_operacionais_diario: copia direta do agregado ja
-- calculado na Landing (script 07)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fato_eventos_operacionais_diario`$$
CREATE PROCEDURE `sp_carga_fato_eventos_operacionais_diario` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    INSERT INTO fato_eventos_operacionais_diario (
        dt_evento, log_name, event, subject_type, qtd_eventos, qtd_atores_distintos, id_lote_carga
    )
    SELECT dt_evento, log_name, event, subject_type, qtd_eventos, qtd_atores_distintos, p_id_lote
    FROM lnd_patronage_activity_log_diario
    ON DUPLICATE KEY UPDATE
        qtd_eventos = VALUES(qtd_eventos), qtd_atores_distintos = VALUES(qtd_atores_distintos),
        id_lote_carga = VALUES(id_lote_carga), dt_carga = CURRENT_TIMESTAMP;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_fato_eventos_operacionais_diario', 'info', CONCAT('Linhas afetadas: ', ROW_COUNT()));
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_fatos: orquestra a carga de todos os fatos (chamada pela
-- orquestracao mestra do script 13, apos sp_carga_dimensoes)
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_fatos`$$
CREATE PROCEDURE `sp_carga_fatos` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    CALL sp_carga_fato_chamada_ciclo(p_id_lote);
    CALL sp_carga_fato_processo_atividade(p_id_lote);
    CALL sp_carga_fato_convenio_execucao(p_id_lote);
    CALL sp_carga_fato_financeiro_patronage(p_id_lote);
    CALL sp_carga_fato_financeiro_sigef(p_id_lote);
    CALL sp_carga_fato_eventos_operacionais_diario(p_id_lote);
END$$

DELIMITER ;
