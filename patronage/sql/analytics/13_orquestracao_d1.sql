-- ============================================================================
-- patronage_analytics | Script 13 - Orquestracao Mestra do Lote D+1
-- Fase 2: ETL / Reconciliacao
--
-- sp_executar_carga_d1 e o ponto de entrada UNICO do processamento diario.
-- Deve ser chamada por um MySQL Event (Fase 3) agendado dentro da janela
-- 05:00-07:00, APOS o client SIGEF (script 12) ja ter rodado e carregado
-- lnd_sigef_* (o client roda fora do MySQL, tipicamente via cron as 05:00,
-- com folga para a procedure comecar aproximadamente as 05:15).
--
-- Ordem de execucao (respeitando dependencias do modelo):
--   1) Landing Patronage (script 07) - incremental por dominio
--   2) Dimensoes (script 08)
--   3) Fatos (script 09) - inclui fato_financeiro_sigef, que depende da
--      Landing SIGEF ja carregada pelo client externo
--   4) Pontes (script 10) - bootstrap/sugestao (idempotente, so acrescenta
--      vinculos novos; vinculos existentes nao sao sobrescritos)
--   5) Reconciliacao (script 10) - por competencia (mes corrente e anterior,
--      para cobrir pagamentos lancados com atraso)
--   6) Qualidade de dados (script 11)
--
-- Cada etapa e isolada em um bloco de tratamento de erro proprio: uma falha
-- em uma etapa e registrada e interrompe o lote (marca como
-- 'concluido_com_erro' ou 'falhou'), mas nao deixa o banco em estado
-- parcialmente inconsistente graças a idempotencia de cada procedure
-- individual (podem ser re-executadas com seguranca no dia seguinte ou
-- manualmente apos correcao).
-- ============================================================================

USE `patronage_analytics`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_executar_carga_d1`$$
CREATE PROCEDURE `sp_executar_carga_d1` (IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_id_lote BIGINT UNSIGNED;
    DECLARE v_ano_mes_atual INT UNSIGNED;
    DECLARE v_ano_mes_anterior INT UNSIGNED;
    DECLARE v_erro_mensagem TEXT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_erro_mensagem = MESSAGE_TEXT;
        UPDATE ctl_lote_carga SET status = 'falhou', dt_fim = NOW() WHERE id_lote = v_id_lote;
        INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
        VALUES (v_id_lote, 'sp_executar_carga_d1', 'error', COALESCE(v_erro_mensagem, 'Erro nao especificado'));
        RESIGNAL;
    END;

    SET v_ano_mes_atual = YEAR(CURDATE()) * 100 + MONTH(CURDATE());
    SET v_ano_mes_anterior = YEAR(CURDATE() - INTERVAL 1 MONTH) * 100 + MONTH(CURDATE() - INTERVAL 1 MONTH);

    INSERT INTO ctl_lote_carga (dominio, camada, data_referencia, dt_inicio, status)
    VALUES ('orquestracao_d1', 'landing', CURDATE(), NOW(), 'iniciado');
    SET v_id_lote = LAST_INSERT_ID();

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'inicio', 'info', CONCAT('Iniciando carga D+1, modo=', p_modo));

    -- ------------------------------------------------------------------
    -- ETAPA 1: Landing Patronage
    -- ------------------------------------------------------------------
    CALL sp_lnd_carga_editais(v_id_lote, p_modo);
    CALL sp_lnd_carga_modalidades(v_id_lote, p_modo);
    CALL sp_lnd_carga_setores(v_id_lote, p_modo);
    CALL sp_lnd_carga_edital_chamadas(v_id_lote, p_modo);
    CALL sp_lnd_carga_edital_chamada_faixas(v_id_lote, p_modo);
    CALL sp_lnd_carga_edital_dados_financeiro(v_id_lote, p_modo);
    CALL sp_lnd_carga_erro_steps_chamada(v_id_lote, p_modo);
    CALL sp_lnd_carga_instituicoes(v_id_lote, p_modo);
    CALL sp_lnd_carga_processos(v_id_lote, p_modo);
    CALL sp_lnd_carga_historico_processo_status(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenios(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenio_instituicao(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenio_financeiro(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenio_planejamentos(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenio_aditivos(v_id_lote, p_modo);
    CALL sp_lnd_carga_convenio_aditivo_financeiros(v_id_lote, p_modo);
    CALL sp_lnd_carga_subacoes(v_id_lote, p_modo);
    CALL sp_lnd_carga_fonte_pagadoras(v_id_lote, p_modo);
    CALL sp_lnd_carga_termos(v_id_lote, p_modo);
    CALL sp_lnd_carga_termo_parcelas(v_id_lote, p_modo);
    CALL sp_lnd_carga_termo_parcelas_pagas(v_id_lote, p_modo);
    CALL sp_lnd_carga_users(v_id_lote, p_modo);
    CALL sp_lnd_carga_user_infos(v_id_lote, p_modo);
    CALL sp_lnd_carga_gestores(v_id_lote, p_modo);
    CALL sp_lnd_carga_activity_log_diario(v_id_lote, p_modo);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_1_landing', 'info', 'Landing Patronage concluida');

    -- ------------------------------------------------------------------
    -- ETAPA 2: Dimensoes
    -- ------------------------------------------------------------------
    CALL sp_carga_dimensoes(v_id_lote);
    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_2_dimensoes', 'info', 'Dimensoes concluidas');

    -- ------------------------------------------------------------------
    -- ETAPA 3: Fatos
    -- ------------------------------------------------------------------
    CALL sp_carga_fatos(v_id_lote);
    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_3_fatos', 'info', 'Fatos concluidos');

    -- ------------------------------------------------------------------
    -- ETAPA 4: Pontes (idempotente - so acrescenta vinculos novos)
    -- ------------------------------------------------------------------
    CALL sp_bootstrap_ponte_proponente_credor_sigef();
    CALL sp_sugerir_ponte_edital_subacao();
    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_4_pontes', 'info', 'Pontes atualizadas');

    -- ------------------------------------------------------------------
    -- ETAPA 5: Reconciliacao (mes corrente + anterior, para cobrir
    -- pagamentos lancados com atraso em qualquer um dos dois sistemas)
    -- ------------------------------------------------------------------
    CALL sp_reconciliar_sigef_patronage(v_id_lote, v_ano_mes_anterior);
    CALL sp_reconciliar_sigef_patronage(v_id_lote, v_ano_mes_atual);
    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_5_reconciliacao', 'info',
            CONCAT('Competencias processadas: ', v_ano_mes_anterior, ' e ', v_ano_mes_atual));

    -- ------------------------------------------------------------------
    -- ETAPA 6: Qualidade de dados
    -- ------------------------------------------------------------------
    CALL sp_executar_regras_dq(v_id_lote);
    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (v_id_lote, 'etapa_6_qualidade_dados', 'info', 'Regras de DQ executadas');

    -- ------------------------------------------------------------------
    -- Fechamento do lote: 'concluido_com_erro' se alguma regra BLOQUEANTE
    -- reprovou nesta execucao; 'concluido' caso contrario.
    -- ------------------------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM ctl_dq_resultado res
        JOIN ctl_dq_regra rg ON rg.id_regra = res.id_regra
        WHERE res.id_lote = v_id_lote AND rg.severidade = 'bloqueante' AND res.aprovado = 0
    ) THEN
        UPDATE ctl_lote_carga SET status = 'concluido_com_erro', dt_fim = NOW() WHERE id_lote = v_id_lote;
        INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
        VALUES (v_id_lote, 'fim', 'warning', 'Lote concluido COM violacoes bloqueantes de DQ - revisar exc_qualidade_dados');
    ELSE
        UPDATE ctl_lote_carga SET status = 'concluido', dt_fim = NOW() WHERE id_lote = v_id_lote;
        INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
        VALUES (v_id_lote, 'fim', 'info', 'Lote concluido com sucesso');
    END IF;

    SELECT v_id_lote AS id_lote, 'PROCESSAMENTO D+1 FINALIZADO' AS resultado;
END$$

DELIMITER ;
