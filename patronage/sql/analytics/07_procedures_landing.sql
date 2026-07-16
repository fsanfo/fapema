-- ============================================================================
-- patronage_analytics | Script 07 - Procedures de Carga da Landing (Patronage)
-- Fase 2: ETL / Reconciliacao
--
-- Cada procedure segue o mesmo padrao:
--   1) resolve o watermark (incremental) ou usa epoch (full)
--   2) INSERT...SELECT de patronage.<tabela> para lnd_patronage_<tabela>,
--      com ON DUPLICATE KEY UPDATE (idempotente)
--   3) atualiza ctl_watermark com o maior valor de origem processado
--   4) grava ctl_log_execucao com a quantidade de linhas afetadas
--
-- Tabelas sem coluna updated_at usam watermark por id (extracao incremental
-- por chave crescente, tipico de tabelas de log/detalhe append-only).
-- Pressupoe que o schema `patronage` esteja acessivel na mesma instancia MySQL.
-- ============================================================================

USE `patronage_analytics`;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_editais`$$
CREATE PROCEDURE `sp_lnd_carga_editais` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'editais' AND tabela_origem = 'patronage.editais';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_editais`
        (`id_origem`, `nome`, `ano`, `numero`, `tipo`, `caracteristica`, `personalidade_juridica`, `uso`, `quota`, `modalidade_id`, `setor_id`, `user_responsavel`, `edital_pai_id`, `acesso_restrito`, `created_at_origem`, `updated_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`nome`, src.`ano`, src.`numero`, src.`tipo`, src.`caracteristica`, src.`personalidade_juridica`, src.`uso`, src.`quota`, src.`modalidade_id`, src.`setor_id`, src.`user_responsavel`, src.`edital_pai_id`, src.`acesso_restrito`, src.`created_at`, src.`updated_at`, p_id_lote
    FROM `patronage`.`editais` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `nome` = VALUES(`nome`),
        `ano` = VALUES(`ano`),
        `numero` = VALUES(`numero`),
        `tipo` = VALUES(`tipo`),
        `caracteristica` = VALUES(`caracteristica`),
        `personalidade_juridica` = VALUES(`personalidade_juridica`),
        `uso` = VALUES(`uso`),
        `quota` = VALUES(`quota`),
        `modalidade_id` = VALUES(`modalidade_id`),
        `setor_id` = VALUES(`setor_id`),
        `user_responsavel` = VALUES(`user_responsavel`),
        `edital_pai_id` = VALUES(`edital_pai_id`),
        `acesso_restrito` = VALUES(`acesso_restrito`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `updated_at_origem` = VALUES(`updated_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`editais` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('editais', 'patronage.editais', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_editais', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_modalidades`$$
CREATE PROCEDURE `sp_lnd_carga_modalidades` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'modalidades' AND tabela_origem = 'patronage.modalidades';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_modalidades`
        (`id_origem`, `sigla`, `nome`, `tipo`, `status`, `sub_programa_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`sigla`, src.`nome`, src.`tipo`, src.`status`, src.`sub_programa_id`, p_id_lote
    FROM `patronage`.`modalidades` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `sigla` = VALUES(`sigla`),
        `nome` = VALUES(`nome`),
        `tipo` = VALUES(`tipo`),
        `status` = VALUES(`status`),
        `sub_programa_id` = VALUES(`sub_programa_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`modalidades` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('modalidades', 'patronage.modalidades', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_modalidades', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_setores`$$
CREATE PROCEDURE `sp_lnd_carga_setores` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'setores' AND tabela_origem = 'patronage.setores';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_setores`
        (`id_origem`, `nome`, `email`, `edital`, `id_lote_carga`)
    SELECT
        src.`id`, src.`nome`, src.`email`, src.`edital`, p_id_lote
    FROM `patronage`.`setores` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `nome` = VALUES(`nome`),
        `email` = VALUES(`email`),
        `edital` = VALUES(`edital`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`setores` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('setores', 'patronage.setores', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_setores', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_edital_chamadas`$$
CREATE PROCEDURE `sp_lnd_carga_edital_chamadas` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'editais' AND tabela_origem = 'patronage.edital_chamadas';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_edital_chamadas`
        (`id_origem`, `edital_id`, `numero`, `grupo`, `nome`, `inicio`, `fim`, `publicada`, `parecer_pesquisador`, `recurso_inicio`, `recurso_fim`, `deleted_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`edital_id`, src.`numero`, src.`grupo`, src.`nome`, src.`inicio`, src.`fim`, src.`publicada`, src.`parecer_pesquisador`, src.`recurso_inicio`, src.`recurso_fim`, src.`deleted_at`, p_id_lote
    FROM `patronage`.`edital_chamadas` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `edital_id` = VALUES(`edital_id`),
        `numero` = VALUES(`numero`),
        `grupo` = VALUES(`grupo`),
        `nome` = VALUES(`nome`),
        `inicio` = VALUES(`inicio`),
        `fim` = VALUES(`fim`),
        `publicada` = VALUES(`publicada`),
        `parecer_pesquisador` = VALUES(`parecer_pesquisador`),
        `recurso_inicio` = VALUES(`recurso_inicio`),
        `recurso_fim` = VALUES(`recurso_fim`),
        `deleted_at_origem` = VALUES(`deleted_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`edital_chamadas` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('editais', 'patronage.edital_chamadas', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_edital_chamadas', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_edital_chamada_faixas`$$
CREATE PROCEDURE `sp_lnd_carga_edital_chamada_faixas` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'editais' AND tabela_origem = 'patronage.edital_chamada_faixas';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_edital_chamada_faixas`
        (`id_origem`, `valor`, `contigenciamento`, `edital_chamada_id`, `descricao_faixa_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`valor`, src.`contigenciamento`, src.`edital_chamada_id`, src.`descricao_faixa_id`, p_id_lote
    FROM `patronage`.`edital_chamada_faixas` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `valor` = VALUES(`valor`),
        `contigenciamento` = VALUES(`contigenciamento`),
        `edital_chamada_id` = VALUES(`edital_chamada_id`),
        `descricao_faixa_id` = VALUES(`descricao_faixa_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`edital_chamada_faixas` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('editais', 'patronage.edital_chamada_faixas', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_edital_chamada_faixas', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_edital_dados_financeiro`$$
CREATE PROCEDURE `sp_lnd_carga_edital_dados_financeiro` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'editais' AND tabela_origem = 'patronage.edital_dados_financeiro';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_edital_dados_financeiro`
        (`id_origem`, `valor_edital`, `sub_acao`, `fonte`, `convenio_id`, `edital_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`valor_edital`, src.`sub_acao`, src.`fonte`, src.`convenio_id`, src.`edital_id`, p_id_lote
    FROM `patronage`.`edital_dados_financeiro` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `valor_edital` = VALUES(`valor_edital`),
        `sub_acao` = VALUES(`sub_acao`),
        `fonte` = VALUES(`fonte`),
        `convenio_id` = VALUES(`convenio_id`),
        `edital_id` = VALUES(`edital_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`edital_dados_financeiro` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('editais', 'patronage.edital_dados_financeiro', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_edital_dados_financeiro', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_erro_steps_chamada`$$
CREATE PROCEDURE `sp_lnd_carga_erro_steps_chamada` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'editais' AND tabela_origem = 'patronage.erro_steps_chamada';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_erro_steps_chamada`
        (`id_origem`, `edital_chamada_id`, `erro_anexos`, `erro_documentacoes`, `erro_dados_contratacao`, `erro_termo_outorga`, `erro_termo_aditivo_valor`, `erro_termo_aditivo_prazo`, `erro_termo_apostilamento`, `erro_termo_aditivo`, `id_lote_carga`)
    SELECT
        src.`id`, src.`edital_chamada_id`, src.`erro_anexos`, src.`erro_documentacoes`, src.`erro_dados_contratacao`, src.`erro_termo_outorga`, src.`erro_termo_aditivo_valor`, src.`erro_termo_aditivo_prazo`, src.`erro_termo_apostilamento`, src.`erro_termo_aditivo`, p_id_lote
    FROM `patronage`.`erro_steps_chamada` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `edital_chamada_id` = VALUES(`edital_chamada_id`),
        `erro_anexos` = VALUES(`erro_anexos`),
        `erro_documentacoes` = VALUES(`erro_documentacoes`),
        `erro_dados_contratacao` = VALUES(`erro_dados_contratacao`),
        `erro_termo_outorga` = VALUES(`erro_termo_outorga`),
        `erro_termo_aditivo_valor` = VALUES(`erro_termo_aditivo_valor`),
        `erro_termo_aditivo_prazo` = VALUES(`erro_termo_aditivo_prazo`),
        `erro_termo_apostilamento` = VALUES(`erro_termo_apostilamento`),
        `erro_termo_aditivo` = VALUES(`erro_termo_aditivo`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`erro_steps_chamada` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('editais', 'patronage.erro_steps_chamada', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_erro_steps_chamada', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_processos`$$
CREATE PROCEDURE `sp_lnd_carga_processos` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'processos' AND tabela_origem = 'patronage.processos';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_processos`
        (`id_origem`, `sigla`, `situacao`, `user_id`, `edital_chamada_id`, `edital_chamada_faixa_id`, `orientador_id`, `supervisor_id`, `area_id`, `sub_area_id`, `envio`, `valor_concedido`, `instituicao_id`, `polo_id`, `step`, `data_assinatura`, `created_at_origem`, `updated_at_origem`, `deleted_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`sigla`, src.`situacao`, src.`user_id`, src.`edital_chamada_id`, src.`edital_chamada_faixa_id`, src.`orientador_id`, src.`supervisor_id`, src.`area_id`, src.`sub_area_id`, src.`envio`, src.`valor_concedido`, src.`instituicao_id`, src.`polo_id`, src.`step`, src.`data_assinatura`, src.`created_at`, src.`updated_at`, src.`deleted_at`, p_id_lote
    FROM `patronage`.`processos` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `sigla` = VALUES(`sigla`),
        `situacao` = VALUES(`situacao`),
        `user_id` = VALUES(`user_id`),
        `edital_chamada_id` = VALUES(`edital_chamada_id`),
        `edital_chamada_faixa_id` = VALUES(`edital_chamada_faixa_id`),
        `orientador_id` = VALUES(`orientador_id`),
        `supervisor_id` = VALUES(`supervisor_id`),
        `area_id` = VALUES(`area_id`),
        `sub_area_id` = VALUES(`sub_area_id`),
        `envio` = VALUES(`envio`),
        `valor_concedido` = VALUES(`valor_concedido`),
        `instituicao_id` = VALUES(`instituicao_id`),
        `polo_id` = VALUES(`polo_id`),
        `step` = VALUES(`step`),
        `data_assinatura` = VALUES(`data_assinatura`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `updated_at_origem` = VALUES(`updated_at_origem`),
        `deleted_at_origem` = VALUES(`deleted_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`processos` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('processos', 'patronage.processos', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_processos', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_historico_processo_status`$$
CREATE PROCEDURE `sp_lnd_carga_historico_processo_status` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'processos' AND tabela_origem = 'patronage.historico_processo_status';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_historico_processo_status`
        (`id_origem`, `processo_id`, `status_anterior`, `status_atual`, `user_id`, `created_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`processo_id`, src.`status_anterior`, src.`status_atual`, src.`user_id`, src.`created_at`, p_id_lote
    FROM `patronage`.`historico_processo_status` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `processo_id` = VALUES(`processo_id`),
        `status_anterior` = VALUES(`status_anterior`),
        `status_atual` = VALUES(`status_atual`),
        `user_id` = VALUES(`user_id`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`historico_processo_status` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('processos', 'patronage.historico_processo_status', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_historico_processo_status', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_instituicoes`$$
CREATE PROCEDURE `sp_lnd_carga_instituicoes` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'instituicoes' AND tabela_origem = 'patronage.instituicoes';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_instituicoes`
        (`id_origem`, `sigla`, `nome`, `cnpj`, `ativo`, `situacao`, `modalidade`, `tipo`, `id_lote_carga`)
    SELECT
        src.`id`, src.`sigla`, src.`nome`, src.`cnpj`, src.`ativo`, src.`situacao`, src.`modalidade`, src.`tipo`, p_id_lote
    FROM `patronage`.`instituicoes` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `sigla` = VALUES(`sigla`),
        `nome` = VALUES(`nome`),
        `cnpj` = VALUES(`cnpj`),
        `ativo` = VALUES(`ativo`),
        `situacao` = VALUES(`situacao`),
        `modalidade` = VALUES(`modalidade`),
        `tipo` = VALUES(`tipo`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`instituicoes` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('instituicoes', 'patronage.instituicoes', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_instituicoes', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenios`$$
CREATE PROCEDURE `sp_lnd_carga_convenios` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenios';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_convenios`
        (`id_origem`, `numero`, `ano`, `nome`, `tipo`, `assinatura`, `vigencia_inicial`, `vigencia_final`, `relatorio`, `relatorio_parcial`, `relatorio_final`, `prestacao_inicial`, `prestacao_final`, `gestor_id`, `created_at_origem`, `updated_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`numero`, src.`ano`, src.`nome`, src.`tipo`, src.`assinatura`, src.`vigencia_inicial`, src.`vigencia_final`, src.`relatorio`, src.`relatorio_parcial`, src.`relatorio_final`, src.`prestacao_inicial`, src.`prestacao_final`, src.`gestor_id`, src.`created_at`, src.`updated_at`, p_id_lote
    FROM `patronage`.`convenios` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `numero` = VALUES(`numero`),
        `ano` = VALUES(`ano`),
        `nome` = VALUES(`nome`),
        `tipo` = VALUES(`tipo`),
        `assinatura` = VALUES(`assinatura`),
        `vigencia_inicial` = VALUES(`vigencia_inicial`),
        `vigencia_final` = VALUES(`vigencia_final`),
        `relatorio` = VALUES(`relatorio`),
        `relatorio_parcial` = VALUES(`relatorio_parcial`),
        `relatorio_final` = VALUES(`relatorio_final`),
        `prestacao_inicial` = VALUES(`prestacao_inicial`),
        `prestacao_final` = VALUES(`prestacao_final`),
        `gestor_id` = VALUES(`gestor_id`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `updated_at_origem` = VALUES(`updated_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenios` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenios', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenios', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenio_instituicao`$$
CREATE PROCEDURE `sp_lnd_carga_convenio_instituicao` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenio_instituicao';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_convenio_instituicao`
        (`id_origem`, `convenio_id`, `instituicao_id`, `tipo`, `id_lote_carga`)
    SELECT
        src.`id`, src.`convenio_id`, src.`instituicao_id`, src.`tipo`, p_id_lote
    FROM `patronage`.`convenio_instituicao` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `convenio_id` = VALUES(`convenio_id`),
        `instituicao_id` = VALUES(`instituicao_id`),
        `tipo` = VALUES(`tipo`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenio_instituicao` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenio_instituicao', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenio_instituicao', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenio_financeiro`$$
CREATE PROCEDURE `sp_lnd_carga_convenio_financeiro` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenio_financeiro';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_convenio_financeiro`
        (`id_origem`, `despesa_corrente_custeio`, `despesa_corrente_capital`, `convenio_instituicao_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`despesa_corrente_custeio`, src.`despesa_corrente_capital`, src.`convenio_instituicao_id`, p_id_lote
    FROM `patronage`.`convenio_financeiro` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `despesa_corrente_custeio` = VALUES(`despesa_corrente_custeio`),
        `despesa_corrente_capital` = VALUES(`despesa_corrente_capital`),
        `convenio_instituicao_id` = VALUES(`convenio_instituicao_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenio_financeiro` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenio_financeiro', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenio_financeiro', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenio_planejamentos`$$
CREATE PROCEDURE `sp_lnd_carga_convenio_planejamentos` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenio_planejamentos';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_convenio_planejamentos`
        (`id_origem`, `mes`, `ano`, `valor`, `financeiro_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`mes`, src.`ano`, src.`valor`, src.`financeiro_id`, p_id_lote
    FROM `patronage`.`convenio_planejamentos` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `mes` = VALUES(`mes`),
        `ano` = VALUES(`ano`),
        `valor` = VALUES(`valor`),
        `financeiro_id` = VALUES(`financeiro_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenio_planejamentos` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenio_planejamentos', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenio_planejamentos', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenio_aditivos`$$
CREATE PROCEDURE `sp_lnd_carga_convenio_aditivos` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenio_aditivos';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_convenio_aditivos`
        (`id_origem`, `tipo`, `ano`, `numero`, `assinatura`, `prorrogacao`, `convenio_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`tipo`, src.`ano`, src.`numero`, src.`assinatura`, src.`prorrogacao`, src.`convenio_id`, p_id_lote
    FROM `patronage`.`convenio_aditivos` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `tipo` = VALUES(`tipo`),
        `ano` = VALUES(`ano`),
        `numero` = VALUES(`numero`),
        `assinatura` = VALUES(`assinatura`),
        `prorrogacao` = VALUES(`prorrogacao`),
        `convenio_id` = VALUES(`convenio_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenio_aditivos` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenio_aditivos', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenio_aditivos', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_convenio_aditivo_financeiros`$$
CREATE PROCEDURE `sp_lnd_carga_convenio_aditivo_financeiros` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'convenios' AND tabela_origem = 'patronage.convenio_aditivo_financeiros';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_convenio_aditivo_financeiros`
        (`id_origem`, `convenio_aditivo_id`, `convenio_financeiro_id`, `valor`, `id_lote_carga`)
    SELECT
        src.`id`, src.`convenio_aditivo_id`, src.`convenio_financeiro_id`, src.`valor`, p_id_lote
    FROM `patronage`.`convenio_aditivo_financeiros` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `convenio_aditivo_id` = VALUES(`convenio_aditivo_id`),
        `convenio_financeiro_id` = VALUES(`convenio_financeiro_id`),
        `valor` = VALUES(`valor`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`convenio_aditivo_financeiros` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('convenios', 'patronage.convenio_aditivo_financeiros', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_convenio_aditivo_financeiros', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_subacoes`$$
CREATE PROCEDURE `sp_lnd_carga_subacoes` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'financeiro' AND tabela_origem = 'patronage.subacoes';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_subacoes`
        (`id_origem`, `nome`, `numero`, `ativa`, `acao_id`, `id_lote_carga`)
    SELECT
        src.`id`, src.`nome`, src.`numero`, src.`ativa`, src.`acao_id`, p_id_lote
    FROM `patronage`.`subacoes` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `nome` = VALUES(`nome`),
        `numero` = VALUES(`numero`),
        `ativa` = VALUES(`ativa`),
        `acao_id` = VALUES(`acao_id`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`subacoes` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('financeiro', 'patronage.subacoes', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_subacoes', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_fonte_pagadoras`$$
CREATE PROCEDURE `sp_lnd_carga_fonte_pagadoras` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'financeiro' AND tabela_origem = 'patronage.fonte_pagadoras';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_fonte_pagadoras`
        (`id_origem`, `nome`, `numero`, `natureza`, `tipo`, `id_lote_carga`)
    SELECT
        src.`id`, src.`nome`, src.`numero`, src.`natureza`, src.`tipo`, p_id_lote
    FROM `patronage`.`fonte_pagadoras` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `nome` = VALUES(`nome`),
        `numero` = VALUES(`numero`),
        `natureza` = VALUES(`natureza`),
        `tipo` = VALUES(`tipo`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`fonte_pagadoras` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('financeiro', 'patronage.fonte_pagadoras', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_fonte_pagadoras', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_termos`$$
CREATE PROCEDURE `sp_lnd_carga_termos` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'financeiro' AND tabela_origem = 'patronage.termos';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_termos`
        (`id_origem`, `vigencia_inicial`, `vigencia_final`, `valor`, `numero`, `ano`, `status`, `tipo`, `processo_id`, `data_assinatura`, `created_at_origem`, `deleted_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`vigencia_inicial`, src.`vigencia_final`, src.`valor`, src.`numero`, src.`ano`, src.`status`, src.`tipo`, src.`processo_id`, src.`data_assinatura`, src.`created_at`, src.`deleted_at`, p_id_lote
    FROM `patronage`.`termos` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `vigencia_inicial` = VALUES(`vigencia_inicial`),
        `vigencia_final` = VALUES(`vigencia_final`),
        `valor` = VALUES(`valor`),
        `numero` = VALUES(`numero`),
        `ano` = VALUES(`ano`),
        `status` = VALUES(`status`),
        `tipo` = VALUES(`tipo`),
        `processo_id` = VALUES(`processo_id`),
        `data_assinatura` = VALUES(`data_assinatura`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `deleted_at_origem` = VALUES(`deleted_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`termos` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('financeiro', 'patronage.termos', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_termos', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_termo_parcelas`$$
CREATE PROCEDURE `sp_lnd_carga_termo_parcelas` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT COALESCE(ultimo_valor_watermark,'0') INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'financeiro' AND tabela_origem = 'patronage.termo_parcelas';
        IF v_watermark IS NULL THEN SET v_watermark = '0'; END IF;
    ELSE
        SET v_watermark = '0';
    END IF;

    INSERT INTO `lnd_patronage_termo_parcelas`
        (`id_origem`, `termo_id`, `mes_vencimento`, `ano_vencimento`, `valor`, `id_lote_carga`)
    SELECT
        src.`id`, src.`termo_id`, src.`mes_vencimento`, src.`ano_vencimento`, src.`valor`, p_id_lote
    FROM `patronage`.`termo_parcelas` src
    WHERE p_modo = 'full' OR src.`id` > CAST(v_watermark AS UNSIGNED)
    ON DUPLICATE KEY UPDATE
        `termo_id` = VALUES(`termo_id`),
        `mes_vencimento` = VALUES(`mes_vencimento`),
        `ano_vencimento` = VALUES(`ano_vencimento`),
        `valor` = VALUES(`valor`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`id`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`termo_parcelas` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('financeiro', 'patronage.termo_parcelas', 'id', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_termo_parcelas', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_termo_parcelas_pagas`$$
CREATE PROCEDURE `sp_lnd_carga_termo_parcelas_pagas` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'financeiro' AND tabela_origem = 'patronage.termo_parcelas_pagas';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_termo_parcelas_pagas`
        (`id_origem`, `termo_parcela_id`, `data_pagamento`, `ordem_bancaria`, `nota_empenho`, `situacao_pagamento`, `valor_pago`, `user_id`, `subacao_id`, `fonte_id`, `natureza_despesa_id`, `inserido_via_api`, `id_lote_carga`)
    SELECT
        src.`id`, src.`termo_parcela_id`, src.`data_pagamento`, src.`ordem_bancaria`, src.`nota_empenho`, src.`situacao_pagamento`, src.`valor_pago`, src.`user_id`, src.`subacao_id`, src.`fonte_id`, src.`natureza_despesa_id`, src.`inserido_via_api`, p_id_lote
    FROM `patronage`.`termo_parcelas_pagas` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `termo_parcela_id` = VALUES(`termo_parcela_id`),
        `data_pagamento` = VALUES(`data_pagamento`),
        `ordem_bancaria` = VALUES(`ordem_bancaria`),
        `nota_empenho` = VALUES(`nota_empenho`),
        `situacao_pagamento` = VALUES(`situacao_pagamento`),
        `valor_pago` = VALUES(`valor_pago`),
        `user_id` = VALUES(`user_id`),
        `subacao_id` = VALUES(`subacao_id`),
        `fonte_id` = VALUES(`fonte_id`),
        `natureza_despesa_id` = VALUES(`natureza_despesa_id`),
        `inserido_via_api` = VALUES(`inserido_via_api`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`termo_parcelas_pagas` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('financeiro', 'patronage.termo_parcelas_pagas', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_termo_parcelas_pagas', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_users`$$
CREATE PROCEDURE `sp_lnd_carga_users` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'identidade' AND tabela_origem = 'patronage.users';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_users`
        (`id_origem`, `name`, `social_name`, `tipo_documento`, `documento`, `email`, `membro_comite`, `created_at_origem`, `updated_at_origem`, `deleted_at_origem`, `id_lote_carga`)
    SELECT
        src.`id`, src.`name`, src.`social_name`, src.`tipo_documento`, src.`documento`, src.`email`, src.`membro_comite`, src.`created_at`, src.`updated_at`, src.`deleted_at`, p_id_lote
    FROM `patronage`.`users` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `name` = VALUES(`name`),
        `social_name` = VALUES(`social_name`),
        `tipo_documento` = VALUES(`tipo_documento`),
        `documento` = VALUES(`documento`),
        `email` = VALUES(`email`),
        `membro_comite` = VALUES(`membro_comite`),
        `created_at_origem` = VALUES(`created_at_origem`),
        `updated_at_origem` = VALUES(`updated_at_origem`),
        `deleted_at_origem` = VALUES(`deleted_at_origem`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`users` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('identidade', 'patronage.users', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_users', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_user_infos`$$
CREATE PROCEDURE `sp_lnd_carga_user_infos` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'identidade' AND tabela_origem = 'patronage.user_infos';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_user_infos`
        (`id_origem`, `user_id`, `data_nascimento`, `sexo`, `nacionalidade`, `etnia`, `deficiencia_fisica`, `nome_pai`, `nome_mae`, `telefone`, `celular1`, `celular2`, `banco_id`, `agencia`, `conta`, `id_lote_carga`)
    SELECT
        src.`id`, src.`user_id`, src.`data_nascimento`, src.`sexo`, src.`nacionalidade`, src.`etnia`, src.`deficiencia_fisica`, src.`nome_pai`, src.`nome_mae`, src.`telefone`, src.`celular1`, src.`celular2`, src.`banco_id`, src.`agencia`, src.`conta`, p_id_lote
    FROM `patronage`.`user_infos` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `user_id` = VALUES(`user_id`),
        `data_nascimento` = VALUES(`data_nascimento`),
        `sexo` = VALUES(`sexo`),
        `nacionalidade` = VALUES(`nacionalidade`),
        `etnia` = VALUES(`etnia`),
        `deficiencia_fisica` = VALUES(`deficiencia_fisica`),
        `nome_pai` = VALUES(`nome_pai`),
        `nome_mae` = VALUES(`nome_mae`),
        `telefone` = VALUES(`telefone`),
        `celular1` = VALUES(`celular1`),
        `celular2` = VALUES(`celular2`),
        `banco_id` = VALUES(`banco_id`),
        `agencia` = VALUES(`agencia`),
        `conta` = VALUES(`conta`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`user_infos` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('identidade', 'patronage.user_infos', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_user_infos', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

DROP PROCEDURE IF EXISTS `sp_lnd_carga_gestores`$$
CREATE PROCEDURE `sp_lnd_carga_gestores` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark VARCHAR(30) DEFAULT '1970-01-01 00:00:00';
    DECLARE v_novo_watermark VARCHAR(30);
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'identidade' AND tabela_origem = 'patronage.gestores';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01 00:00:00'; END IF;
    END IF;

    INSERT INTO `lnd_patronage_gestores`
        (`id_origem`, `inicio`, `fim`, `status`, `user_id`, `tipo`, `id_lote_carga`)
    SELECT
        src.`id`, src.`inicio`, src.`fim`, src.`status`, src.`user_id`, src.`tipo`, p_id_lote
    FROM `patronage`.`gestores` src
    WHERE p_modo = 'full' OR src.`updated_at` > v_watermark
    ON DUPLICATE KEY UPDATE
        `inicio` = VALUES(`inicio`),
        `fim` = VALUES(`fim`),
        `status` = VALUES(`status`),
        `user_id` = VALUES(`user_id`),
        `tipo` = VALUES(`tipo`),
        `id_lote_carga` = VALUES(`id_lote_carga`),
        `dt_carga` = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    SELECT CAST(COALESCE(MAX(src.`updated_at`), v_watermark) AS CHAR) INTO v_novo_watermark FROM `patronage`.`gestores` src;

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    VALUES ('identidade', 'patronage.gestores', 'updated_at', v_novo_watermark)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_gestores', 'info', CONCAT('Linhas afetadas (insert/update): ', v_qtd));
END$$

-- ----------------------------------------------------------------------------
-- sp_lnd_carga_activity_log_diario: carga agregada diaria (nao replica linha a
-- linha - ver blueprint 00, secao 8, item 4). Reprocessa desde o ultimo dia
-- agregado (inclusive) para cobrir o dia potencialmente incompleto do lote
-- anterior; ON DUPLICATE KEY UPDATE evita contagem duplicada.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_lnd_carga_activity_log_diario`$$
CREATE PROCEDURE `sp_lnd_carga_activity_log_diario` (IN p_id_lote BIGINT UNSIGNED, IN p_modo ENUM('incremental','full'))
BEGIN
    DECLARE v_watermark DATE DEFAULT '1970-01-01';
    DECLARE v_qtd BIGINT DEFAULT 0;

    IF p_modo = 'incremental' THEN
        SELECT ultimo_valor_watermark INTO v_watermark
        FROM ctl_watermark WHERE dominio = 'eventos_operacionais' AND tabela_origem = 'patronage.activity_log';
        IF v_watermark IS NULL THEN SET v_watermark = '1970-01-01'; END IF;
    END IF;

    INSERT INTO lnd_patronage_activity_log_diario
        (dt_evento, log_name, event, subject_type, qtd_eventos, qtd_atores_distintos, id_lote_carga)
    SELECT
        DATE(src.created_at) AS dt_evento,
        COALESCE(src.log_name, '(nao_informado)'),
        COALESCE(src.event, '(nao_informado)'),
        COALESCE(src.subject_type, '(nao_informado)'),
        COUNT(*),
        COUNT(DISTINCT src.causer_id),
        p_id_lote
    FROM `patronage`.`activity_log` src
    WHERE p_modo = 'full' OR DATE(src.created_at) >= v_watermark
    GROUP BY DATE(src.created_at), COALESCE(src.log_name,'(nao_informado)'),
             COALESCE(src.event,'(nao_informado)'), COALESCE(src.subject_type,'(nao_informado)')
    ON DUPLICATE KEY UPDATE
        qtd_eventos = VALUES(qtd_eventos),
        qtd_atores_distintos = VALUES(qtd_atores_distintos),
        id_lote_carga = VALUES(id_lote_carga),
        dt_carga = CURRENT_TIMESTAMP;

    SET v_qtd = ROW_COUNT();

    INSERT INTO ctl_watermark (dominio, tabela_origem, coluna_watermark, ultimo_valor_watermark)
    SELECT 'eventos_operacionais', 'patronage.activity_log', 'dt_evento',
           CAST(COALESCE((SELECT MAX(DATE(created_at)) FROM `patronage`.`activity_log`), v_watermark) AS CHAR)
    ON DUPLICATE KEY UPDATE ultimo_valor_watermark = VALUES(ultimo_valor_watermark);

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_lnd_carga_activity_log_diario', 'info', CONCAT('Linhas de agregado diario afetadas: ', v_qtd));
END$$

DELIMITER ;
