-- ============================================================================
-- patronage_analytics | Script 02 - Controle, Auditoria, Watermark e DQ
-- Fase 1: Modelagem e Schema Base
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- ctl_lote_carga: controle mestre de cada execucao de carga (D+1)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_lote_carga` (
    `id_lote`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `dominio`          VARCHAR(60)  NOT NULL COMMENT 'Ex.: editais, convenios, financeiro_patronage, sigef_ordembancaria, eventos_operacionais',
    `camada`           ENUM('landing','curated','marts') NOT NULL,
    `data_referencia`  DATE NOT NULL COMMENT 'Data D do batch (janela D+1)',
    `dt_inicio`        DATETIME NOT NULL,
    `dt_fim`           DATETIME NULL DEFAULT NULL,
    `status`           ENUM('iniciado','concluido','concluido_com_erro','falhou') NOT NULL DEFAULT 'iniciado',
    `qtd_lida`         BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_inserida`     BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_atualizada`   BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_rejeitada`    BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `usuario_execucao` VARCHAR(100) NULL DEFAULT NULL,
    `observacao`       TEXT NULL DEFAULT NULL,
    PRIMARY KEY (`id_lote`),
    KEY `ix_ctl_lote_dominio_data` (`dominio`, `data_referencia`),
    KEY `ix_ctl_lote_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Controle mestre de execucao de cargas D+1 por dominio e camada';

-- ----------------------------------------------------------------------------
-- ctl_watermark: controle de extracao incremental por dominio/origem
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_watermark` (
    `dominio`               VARCHAR(60) NOT NULL,
    `tabela_origem`         VARCHAR(120) NOT NULL,
    `coluna_watermark`      VARCHAR(60) NOT NULL COMMENT 'Ex.: updated_at, created_at, id',
    `ultimo_valor_watermark` VARCHAR(60) NOT NULL DEFAULT '1970-01-01 00:00:00',
    `dt_atualizacao`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`dominio`, `tabela_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Watermark de extracao incremental para carga Landing';

-- ----------------------------------------------------------------------------
-- ctl_log_execucao: log detalhado por etapa dentro de um lote
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_log_execucao` (
    `id_log`     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_lote`    BIGINT UNSIGNED NOT NULL,
    `etapa`      VARCHAR(120) NOT NULL,
    `nivel`      ENUM('info','warning','error') NOT NULL DEFAULT 'info',
    `mensagem`   TEXT NOT NULL,
    `dt_evento`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_log`),
    KEY `ix_ctl_log_lote` (`id_lote`),
    KEY `ix_ctl_log_nivel` (`nivel`),
    CONSTRAINT `fk_ctl_log_lote` FOREIGN KEY (`id_lote`) REFERENCES `ctl_lote_carga` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Log de execucao por etapa de cada lote de carga';

-- ----------------------------------------------------------------------------
-- ctl_dq_regra: catalogo de regras de qualidade de dados testaveis
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_dq_regra` (
    `id_regra`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `codigo`         VARCHAR(40) NOT NULL,
    `dominio`        VARCHAR(60) NOT NULL,
    `descricao`      VARCHAR(255) NOT NULL,
    `severidade`     ENUM('bloqueante','alerta') NOT NULL DEFAULT 'alerta',
    `sql_validacao`  TEXT NOT NULL COMMENT 'Consulta que deve retornar 0 linhas quando a regra e satisfeita',
    `ativo`          TINYINT(1) NOT NULL DEFAULT 1,
    `dt_criacao`     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_regra`),
    UNIQUE KEY `uq_ctl_dq_regra_codigo` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catalogo de regras de qualidade de dados (preenchido na Fase 2)';

-- ----------------------------------------------------------------------------
-- ctl_dq_resultado: resultado de execucao de cada regra por lote
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_dq_resultado` (
    `id_resultado`   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_regra`       INT UNSIGNED NOT NULL,
    `id_lote`        BIGINT UNSIGNED NOT NULL,
    `qtd_violacoes`  BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `aprovado`       TINYINT(1) NOT NULL DEFAULT 1,
    `dt_execucao`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `detalhe`        TEXT NULL DEFAULT NULL,
    PRIMARY KEY (`id_resultado`),
    KEY `ix_ctl_dq_resultado_regra` (`id_regra`),
    KEY `ix_ctl_dq_resultado_lote` (`id_lote`),
    CONSTRAINT `fk_ctl_dq_resultado_regra` FOREIGN KEY (`id_regra`) REFERENCES `ctl_dq_regra` (`id_regra`),
    CONSTRAINT `fk_ctl_dq_resultado_lote` FOREIGN KEY (`id_lote`) REFERENCES `ctl_lote_carga` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Resultado de execucao das regras de qualidade de dados por lote';

-- ----------------------------------------------------------------------------
-- ctl_mv_refresh: controle de refresh das tabelas materializadas (Fase 3)
-- Criada nesta fase para fechar o desenho do modelo de controle.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_mv_refresh` (
    `nome_objeto`       VARCHAR(120) NOT NULL,
    `tipo_refresh`      ENUM('full','incremental') NOT NULL,
    `ultima_execucao`   DATETIME NULL DEFAULT NULL,
    `status`             ENUM('ok','falhou','nunca_executado') NOT NULL DEFAULT 'nunca_executado',
    `duracao_segundos`  INT UNSIGNED NULL DEFAULT NULL,
    `linhas_afetadas`   BIGINT UNSIGNED NULL DEFAULT NULL,
    PRIMARY KEY (`nome_objeto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Controle de refresh das tabelas materializadas/snapshot (populado na Fase 3)';

-- ----------------------------------------------------------------------------
-- ctl_lgpd_pendencias: registro formal do risco de nao mascaramento (decisao
-- explicita do solicitante nesta rodada - ver 00_blueprint_arquitetura.md)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ctl_lgpd_pendencias` (
    `id_pendencia`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `dominio`            VARCHAR(60) NOT NULL,
    `tabela_analitica`   VARCHAR(120) NOT NULL,
    `campo`              VARCHAR(120) NOT NULL,
    `classificacao_dado` ENUM('identificador_direto','dado_sensivel','dado_financeiro','dado_institucional') NOT NULL,
    `descricao_risco`    TEXT NOT NULL,
    `status`             ENUM('pendente','em_definicao','tratado','aceito_como_risco') NOT NULL DEFAULT 'pendente',
    `dt_identificacao`   DATE NOT NULL,
    `responsavel_decisao` VARCHAR(100) NULL DEFAULT NULL COMMENT 'A preencher quando a governanca formalizar o dono da decisao',
    PRIMARY KEY (`id_pendencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Registro formal de pendencias de mascaramento/pseudonimizacao LGPD';

-- Populamento inicial da pendencia (documentacao do risco aceito nesta fase)
INSERT INTO `ctl_lgpd_pendencias`
    (`dominio`, `tabela_analitica`, `campo`, `classificacao_dado`, `descricao_risco`, `status`, `dt_identificacao`)
SELECT * FROM (SELECT
    'identidade' AS dominio, 'dim_usuario' AS tabela_analitica, 'documento' AS campo,
    'identificador_direto' AS classificacao_dado,
    'CPF/passaporte replicado em texto claro na camada analitica por decisao do solicitante. Sem mascaramento, pseudonimizacao ou tabela vault nesta fase. Risco: exposicao de identificador direto em ambiente de BI com base de usuarios mais ampla que o transacional.' AS descricao_risco,
    'aceito_como_risco' AS status, CURDATE() AS dt_identificacao
UNION ALL SELECT
    'identidade', 'dim_usuario', 'nome/social_name', 'dado_sensivel',
    'Nome completo replicado sem mascaramento.', 'aceito_como_risco', CURDATE()
UNION ALL SELECT
    'identidade', 'dim_usuario', 'data_nascimento, sexo, etnia, deficiencia_fisica, nome_pai, nome_mae, telefone, celular1, celular2',
    'dado_sensivel',
    'Dados pessoais sensiveis (LGPD Art. 5, II) de user_infos replicados sem mascaramento.', 'aceito_como_risco', CURDATE()
UNION ALL SELECT
    'identidade', 'dim_usuario', 'banco_id, agencia, conta', 'dado_financeiro',
    'Dados bancarios pessoais replicados sem mascaramento.', 'aceito_como_risco', CURDATE()
UNION ALL SELECT
    'reconciliacao', 'ponte_proponente_credor_sigef', 'cpf_cnpj', 'identificador_direto',
    'CPF/CNPJ replicado em texto claro na tabela ponte de reconciliacao SIGEF.', 'aceito_como_risco', CURDATE()
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM `ctl_lgpd_pendencias` LIMIT 1);
