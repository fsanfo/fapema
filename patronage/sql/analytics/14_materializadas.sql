-- ============================================================================
-- patronage_analytics | Script 14 - Tabelas Materializadas (Snapshot) e Refresh
-- Fase 3: Views, Materializadas, Agendamento e Documentacao Final
--
-- MySQL 8 nao tem materialized view nativa (premissa tecnica obrigatoria -
-- ver 00_blueprint_arquitetura.md). Estrategia adotada: tabelas de
-- snapshot/agregacao, com refresh controlado via ctl_mv_refresh (criada na
-- Fase 1) e procedures dedicadas, chamadas apos o lote D+1 (script 16).
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- mv_reconciliacao_atual: "estado atual" da reconciliacao SIGEF x Patronage -
-- somente o ULTIMO lote processado por (edital, proponente, competencia).
-- fato_reconciliacao_sigef_patronage (Fase 2) continua guardando o historico
-- completo por lote, para auditoria/trilha - ver decisao registrada em
-- 02_blueprint_fase2_etl.md, secao 3.1. Esta tabela existe para que o Painel
-- de Conciliacao e o Painel Executivo consultem o estado atual sem logica de
-- janela (ROW_NUMBER) a cada consulta.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mv_reconciliacao_atual` (
    `sk_edital`              BIGINT UNSIGNED NOT NULL,
    `sk_proponente`          BIGINT UNSIGNED NOT NULL,
    `ano_mes_competencia`    INT UNSIGNED NOT NULL,
    `valor_patronage`        DECIMAL(14,2) NOT NULL DEFAULT 0,
    `valor_sigef`            DECIMAL(14,2) NOT NULL DEFAULT 0,
    `diferenca_valor`        DECIMAL(14,2) NOT NULL DEFAULT 0,
    `status_patronage`       VARCHAR(30) NULL,
    `status_sigef`           VARCHAR(30) NULL,
    `flag_divergencia`       TINYINT(1) NOT NULL DEFAULT 0,
    `tipo_divergencia`       VARCHAR(30) NOT NULL DEFAULT 'ok',
    `id_lote_carga_origem`   BIGINT UNSIGNED NOT NULL COMMENT 'Lote de onde veio este snapshot - rastreabilidade',
    `dt_atualizacao`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_edital`, `sk_proponente`, `ano_mes_competencia`),
    KEY `ix_mv_reconc_competencia` (`ano_mes_competencia`),
    KEY `ix_mv_reconc_divergencia` (`flag_divergencia`, `tipo_divergencia`),
    CONSTRAINT `fk_mv_reconc_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_mv_reconc_proponente` FOREIGN KEY (`sk_proponente`) REFERENCES `dim_usuario` (`sk_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Snapshot do ultimo lote de reconciliacao por chave - consumo direto dos paineis';

-- ----------------------------------------------------------------------------
-- mv_kpi_executivo_mensal: agregado mensal para o Painel Executivo C-Level
-- (comparativo ano a ano e tendencia multitemporal - ver mockup
-- painel-executivo-kpis.html). Refresh full por mes (recalcula do zero cada
-- ano_mes solicitado, barato dado o volume institucional).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mv_kpi_executivo_mensal` (
    `ano_mes`                       INT UNSIGNED NOT NULL,
    `qtd_editais_publicados`        INT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_convenios_firmados`        INT UNSIGNED NOT NULL DEFAULT 0,
    `valor_investimento_total`      DECIMAL(16,2) NOT NULL DEFAULT 0,
    `tempo_medio_ciclo_chamadas`    DECIMAL(6,1) NULL,
    `qtd_divergencias_abertas`      INT UNSIGNED NOT NULL DEFAULT 0,
    `valor_divergencias_abertas`    DECIMAL(14,2) NOT NULL DEFAULT 0,
    `qtd_processos_recebidos`       INT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_processos_aprovados`       INT UNSIGNED NOT NULL DEFAULT 0,
    `dt_atualizacao`                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`ano_mes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Agregado mensal para o Painel Executivo C-Level';

-- ----------------------------------------------------------------------------
-- ctl_mv_refresh ja existe desde a Fase 1 (script 02) - usada abaixo para
-- registrar cada execucao de refresh.
-- ----------------------------------------------------------------------------

DELIMITER $$

-- ----------------------------------------------------------------------------
-- sp_refresh_mv_reconciliacao_atual: recalcula o snapshot "estado atual" a
-- partir do historico completo em fato_reconciliacao_sigef_patronage,
-- mantendo sempre o registro do MAIOR id_lote_carga por chave.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_refresh_mv_reconciliacao_atual`$$
CREATE PROCEDURE `sp_refresh_mv_reconciliacao_atual` ()
BEGIN
    DECLARE v_inicio DATETIME DEFAULT NOW();
    DECLARE v_linhas INT UNSIGNED;

    REPLACE INTO mv_reconciliacao_atual
        (sk_edital, sk_proponente, ano_mes_competencia, valor_patronage, valor_sigef,
         diferenca_valor, status_patronage, status_sigef, flag_divergencia, tipo_divergencia,
         id_lote_carga_origem)
    SELECT
        sk_edital, sk_proponente, ano_mes_competencia, valor_patronage, valor_sigef,
        diferenca_valor, status_patronage, status_sigef, flag_divergencia, tipo_divergencia,
        id_lote_carga
    FROM (
        SELECT f.*,
               ROW_NUMBER() OVER (
                   PARTITION BY sk_edital, sk_proponente, ano_mes_competencia
                   ORDER BY id_lote_carga DESC
               ) AS rn
        FROM fato_reconciliacao_sigef_patronage f
    ) ultimo
    WHERE rn = 1;

    SET v_linhas = ROW_COUNT();

    INSERT INTO ctl_mv_refresh (nome_objeto, tipo_refresh, ultima_execucao, status, duracao_segundos, linhas_afetadas)
    VALUES ('mv_reconciliacao_atual', 'full', NOW(), 'ok', TIMESTAMPDIFF(SECOND, v_inicio, NOW()), v_linhas)
    ON DUPLICATE KEY UPDATE
        ultima_execucao = VALUES(ultima_execucao), status = VALUES(status),
        duracao_segundos = VALUES(duracao_segundos), linhas_afetadas = VALUES(linhas_afetadas);
END$$

-- ----------------------------------------------------------------------------
-- sp_refresh_mv_kpi_executivo_mensal: recalcula o agregado de UM ano_mes.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_refresh_mv_kpi_executivo_mensal`$$
CREATE PROCEDURE `sp_refresh_mv_kpi_executivo_mensal` (IN p_ano_mes INT UNSIGNED)
BEGIN
    DECLARE v_inicio DATETIME DEFAULT NOW();

    REPLACE INTO mv_kpi_executivo_mensal
        (ano_mes, qtd_editais_publicados, qtd_convenios_firmados, valor_investimento_total,
         tempo_medio_ciclo_chamadas, qtd_divergencias_abertas, valor_divergencias_abertas,
         qtd_processos_recebidos, qtd_processos_aprovados)
    SELECT
        p_ano_mes,
        (SELECT COUNT(DISTINCT dc.sk_edital)
           FROM dim_chamada dc
           WHERE dc.flag_publicada = 1
             AND YEAR(dc.dt_inicio) * 100 + MONTH(dc.dt_inicio) = p_ano_mes),
        (SELECT COUNT(*) FROM dim_convenio dcv
           WHERE dcv.dt_assinatura IS NOT NULL
             AND YEAR(dcv.dt_assinatura) * 100 + MONTH(dcv.dt_assinatura) = p_ano_mes),
        (SELECT COALESCE(SUM(valor_pago), 0) FROM fato_financeiro_patronage
           WHERE ano_mes_vencimento = p_ano_mes),
        (SELECT AVG(qtd_dias_ciclo) FROM fato_chamada_ciclo fcc
           WHERE fcc.dt_fechamento IS NOT NULL
             AND YEAR(fcc.dt_fechamento) * 100 + MONTH(fcc.dt_fechamento) = p_ano_mes),
        (SELECT COUNT(*) FROM exc_reconciliacao_sigef_patronage
           WHERE ano_mes_competencia = p_ano_mes AND status_tratativa IN ('pendente','em_analise')),
        (SELECT COALESCE(SUM(valor_patronage), 0) FROM exc_reconciliacao_sigef_patronage
           WHERE ano_mes_competencia = p_ano_mes AND status_tratativa IN ('pendente','em_analise')),
        (SELECT COALESCE(SUM(qtd_processos_recebidos), 0) FROM fato_chamada_ciclo fcc
           WHERE fcc.dt_abertura IS NOT NULL
             AND YEAR(fcc.dt_abertura) * 100 + MONTH(fcc.dt_abertura) = p_ano_mes),
        (SELECT COALESCE(SUM(qtd_processos_aprovados), 0) FROM fato_chamada_ciclo fcc
           WHERE fcc.dt_abertura IS NOT NULL
             AND YEAR(fcc.dt_abertura) * 100 + MONTH(fcc.dt_abertura) = p_ano_mes);

    INSERT INTO ctl_mv_refresh (nome_objeto, tipo_refresh, ultima_execucao, status, duracao_segundos, linhas_afetadas)
    VALUES (CONCAT('mv_kpi_executivo_mensal:', p_ano_mes), 'full', NOW(), 'ok', TIMESTAMPDIFF(SECOND, v_inicio, NOW()), 1)
    ON DUPLICATE KEY UPDATE
        ultima_execucao = VALUES(ultima_execucao), status = VALUES(status),
        duracao_segundos = VALUES(duracao_segundos), linhas_afetadas = VALUES(linhas_afetadas);
END$$

-- ----------------------------------------------------------------------------
-- sp_refresh_marts_d1: orquestra o refresh de todas as materializadas.
-- Chamada apos sp_executar_carga_d1 (script 13) - ver agendamento no script 16.
-- Recalcula o mes corrente e o anterior (mesma janela de seguranca usada na
-- reconciliacao, Fase 2) para cobrir lancamentos tardios.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_refresh_marts_d1`$$
CREATE PROCEDURE `sp_refresh_marts_d1` ()
BEGIN
    DECLARE v_ano_mes_atual INT UNSIGNED;
    DECLARE v_ano_mes_anterior INT UNSIGNED;

    SET v_ano_mes_atual = YEAR(CURDATE()) * 100 + MONTH(CURDATE());
    SET v_ano_mes_anterior = YEAR(CURDATE() - INTERVAL 1 MONTH) * 100 + MONTH(CURDATE() - INTERVAL 1 MONTH);

    CALL sp_refresh_mv_reconciliacao_atual();
    CALL sp_refresh_mv_kpi_executivo_mensal(v_ano_mes_anterior);
    CALL sp_refresh_mv_kpi_executivo_mensal(v_ano_mes_atual);
END$$

DELIMITER ;
