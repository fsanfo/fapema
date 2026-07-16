-- ============================================================================
-- patronage_analytics | Script 11 - Qualidade de Dados (DQ)
-- Fase 2: ETL / Reconciliacao
--
-- Convencao obrigatoria de `sql_validacao`: uma consulta que retorna, em uma
-- unica coluna chamada `chave`, a chave natural de cada registro que VIOLA a
-- regra (0 linhas = regra satisfeita). sp_executar_regras_dq usa essa
-- convencao para popular ctl_dq_resultado e exc_qualidade_dados.
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- Catalogo de regras (seed inicial - ampliar conforme regras de negocio
-- adicionais forem confirmadas com a area funcional)
-- ----------------------------------------------------------------------------
INSERT INTO ctl_dq_regra (codigo, dominio, descricao, severidade, sql_validacao)
VALUES
('EDT001', 'editais', 'Edital sem modalidade associada', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_editais WHERE modalidade_id IS NULL'),

('EDT002', 'editais', 'Edital sem setor associado', 'alerta',
 'SELECT id_origem AS chave FROM lnd_patronage_editais WHERE setor_id IS NULL'),

('CHM001', 'editais', 'Chamada publicada com data de fim anterior a data de inicio', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_edital_chamadas WHERE publicada = 1 AND fim < inicio'),

('PRC001', 'processos', 'Processo com data de assinatura anterior ao envio', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_processos WHERE data_assinatura IS NOT NULL AND envio IS NOT NULL AND data_assinatura < envio'),

('PRC002', 'processos', 'Processo com valor concedido negativo', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_processos WHERE valor_concedido < 0'),

('USR001', 'identidade', 'Usuario com documento (CPF/CNPJ) nulo ou vazio', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_users WHERE documento IS NULL OR TRIM(documento) = ""'),

('USR002', 'identidade', 'Usuario com documento em formato de tamanho invalido (esperado 11 ou 14 digitos)', 'alerta',
 'SELECT id_origem AS chave FROM lnd_patronage_users WHERE documento IS NOT NULL AND LENGTH(REGEXP_REPLACE(documento, "[^0-9]", "")) NOT IN (11,14)'),

('FIN001', 'financeiro', 'Parcela paga com valor_pago negativo', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_termo_parcelas_pagas WHERE valor_pago < 0'),

('FIN002', 'financeiro', 'Parcela paga com valor_pago 50% maior que o valor da parcela (possivel erro de digitacao)', 'alerta',
 'SELECT tpp.id_origem AS chave FROM lnd_patronage_termo_parcelas_pagas tpp JOIN lnd_patronage_termo_parcelas tp ON tp.id_origem = tpp.termo_parcela_id WHERE tpp.valor_pago > tp.valor * 1.5'),

('FIN003', 'financeiro', 'Parcela paga sem ordem bancaria preenchida', 'alerta',
 'SELECT id_origem AS chave FROM lnd_patronage_termo_parcelas_pagas WHERE situacao_pagamento = ''1'' AND (ordem_bancaria IS NULL OR TRIM(ordem_bancaria) = '''')'),

('CNV001', 'convenios', 'Convenio com vigencia final anterior a vigencia inicial', 'bloqueante',
 'SELECT id_origem AS chave FROM lnd_patronage_convenios WHERE vigencia_final IS NOT NULL AND vigencia_inicial IS NOT NULL AND vigencia_final < vigencia_inicial'),

('REC001', 'reconciliacao', 'Divergencia de valor entre Patronage e SIGEF acima de R$ 0,01 no lote', 'alerta',
 'SELECT sk_fato AS chave FROM fato_reconciliacao_sigef_patronage WHERE ABS(diferenca_valor) > 0.01'),

('PON001', 'reconciliacao', 'Ponte edital-subacao ainda pendente de validacao por responsavel funcional', 'alerta',
 'SELECT sk_ponte AS chave FROM ponte_edital_sigef_subacao WHERE responsavel_funcional = ''(PENDENTE_VALIDACAO_CURADORIA)'' AND flag_ativo = 1')

ON DUPLICATE KEY UPDATE
    dominio = VALUES(dominio), descricao = VALUES(descricao), severidade = VALUES(severidade),
    sql_validacao = VALUES(sql_validacao);

-- ----------------------------------------------------------------------------
-- sp_executar_regras_dq: executa todas as regras ativas via SQL dinamico,
-- grava o resultado agregado em ctl_dq_resultado e detalha as violacoes em
-- exc_qualidade_dados.
-- ----------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_executar_regras_dq`$$
CREATE PROCEDURE `sp_executar_regras_dq` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    DECLARE v_done INT DEFAULT 0;
    DECLARE v_id_regra INT UNSIGNED;
    DECLARE v_codigo VARCHAR(40);
    DECLARE v_dominio VARCHAR(60);
    DECLARE v_sql TEXT;
    DECLARE v_severidade VARCHAR(20);
    DECLARE v_qtd BIGINT UNSIGNED;
    DECLARE cur CURSOR FOR
        SELECT id_regra, codigo, dominio, sql_validacao, severidade FROM ctl_dq_regra WHERE ativo = 1;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;

    DROP TEMPORARY TABLE IF EXISTS tmp_dq_violacoes;
    CREATE TEMPORARY TABLE tmp_dq_violacoes (chave_registro VARCHAR(120));

    OPEN cur;
    loop_regras: LOOP
        FETCH cur INTO v_id_regra, v_codigo, v_dominio, v_sql, v_severidade;
        IF v_done THEN LEAVE loop_regras; END IF;

        TRUNCATE tmp_dq_violacoes;

        SET @sql_dinamico = CONCAT(
            'INSERT INTO tmp_dq_violacoes (chave_registro) SELECT CAST(chave AS CHAR) FROM (',
            v_sql, ') AS regra_', v_id_regra
        );
        PREPARE stmt_dq FROM @sql_dinamico;
        EXECUTE stmt_dq;
        DEALLOCATE PREPARE stmt_dq;

        SELECT COUNT(*) INTO v_qtd FROM tmp_dq_violacoes;

        INSERT INTO ctl_dq_resultado (id_regra, id_lote, qtd_violacoes, aprovado, detalhe)
        VALUES (v_id_regra, p_id_lote, v_qtd, IF(v_qtd = 0, 1, 0),
                CONCAT('Regra ', v_codigo, ' (', v_severidade, ') - dominio ', v_dominio));

        IF v_qtd > 0 THEN
            INSERT INTO exc_qualidade_dados (id_lote_carga, id_regra, tabela_afetada, chave_registro, descricao_erro)
            SELECT p_id_lote, v_id_regra, v_dominio, chave_registro,
                   CONCAT('Violacao da regra ', v_codigo, ' (severidade: ', v_severidade, ')')
            FROM tmp_dq_violacoes;

            INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
            VALUES (p_id_lote, CONCAT('dq_', v_codigo),
                    IF(v_severidade = 'bloqueante', 'error', 'warning'),
                    CONCAT(v_qtd, ' violacoes encontradas para a regra ', v_codigo));
        END IF;
    END LOOP;
    CLOSE cur;

    DROP TEMPORARY TABLE IF EXISTS tmp_dq_violacoes;
END$$

DELIMITER ;
