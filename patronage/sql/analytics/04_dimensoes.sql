-- ============================================================================
-- patronage_analytics | Script 04 - Dimensoes Conformadas
-- Fase 1: Modelagem e Schema Base
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- dim_tempo
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_tempo` (
    `dt_referencia`     DATE NOT NULL,
    `ano`               SMALLINT UNSIGNED NOT NULL,
    `trimestre`         TINYINT UNSIGNED NOT NULL,
    `semestre`          TINYINT UNSIGNED NOT NULL,
    `mes`               TINYINT UNSIGNED NOT NULL,
    `nome_mes`          VARCHAR(20) NOT NULL,
    `dia`               TINYINT UNSIGNED NOT NULL,
    `dia_semana`        TINYINT UNSIGNED NOT NULL COMMENT '1=domingo .. 7=sabado',
    `nome_dia_semana`   VARCHAR(20) NOT NULL,
    `semana_ano`        TINYINT UNSIGNED NOT NULL,
    `ano_mes`           INT UNSIGNED NOT NULL COMMENT 'Formato YYYYMM, chave de agregacao mensal',
    `flag_dia_util`     TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`dt_referencia`),
    KEY `ix_dim_tempo_ano_mes` (`ano_mes`),
    KEY `ix_dim_tempo_ano` (`ano`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao de tempo conformada - povoada por procedure na Fase 2';

-- ----------------------------------------------------------------------------
-- dim_modalidade
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_modalidade` (
    `sk_modalidade`   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_modalidade_origem` INT UNSIGNED NOT NULL,
    `sigla`           VARCHAR(30) NULL,
    `nome`            VARCHAR(100) NULL,
    `tipo`            VARCHAR(2) NULL COMMENT '1-bolsa; 2-auxilio',
    `status`          TINYINT NULL,
    `sub_programa_id` INT UNSIGNED NULL,
    `dt_carga`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_modalidade`),
    UNIQUE KEY `uq_dim_modalidade_origem` (`id_modalidade_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada - modalidades de bolsa/auxilio';

-- ----------------------------------------------------------------------------
-- dim_setor
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_setor` (
    `sk_setor`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_setor_origem` INT UNSIGNED NOT NULL,
    `nome`            VARCHAR(30) NULL,
    `email`           VARCHAR(100) NULL,
    `flag_responsavel_edital` TINYINT(1) NULL,
    `dt_carga`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_setor`),
    UNIQUE KEY `uq_dim_setor_origem` (`id_setor_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada - setores institucionais';

-- ----------------------------------------------------------------------------
-- dim_instituicao
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_instituicao` (
    `sk_instituicao`       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_instituicao_origem` INT UNSIGNED NOT NULL,
    `sigla`                VARCHAR(20) NULL,
    `nome`                 VARCHAR(150) NULL,
    `cnpj`                 VARCHAR(14) NULL COMMENT 'Dado institucional (CNPJ), nao pessoal',
    `flag_ativo`           TINYINT(1) NULL,
    `modalidade`           TINYINT NULL COMMENT '0-publica; 1-privada',
    `tipo`                 TINYINT NULL COMMENT '0-empresa; 1-instituicao de ensino',
    `dt_carga`             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_instituicao`),
    UNIQUE KEY `uq_dim_instituicao_origem` (`id_instituicao_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada - instituicoes vinculadas a proponentes/convenios';

-- ----------------------------------------------------------------------------
-- dim_usuario (role-playing: proponente / orientador / supervisor / gestor / ator)
-- CPF e dados sensiveis em texto claro por decisao registrada em
-- ctl_lgpd_pendencias (ver script 02 e blueprint 00).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_usuario` (
    `sk_usuario`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_user_origem`    BIGINT UNSIGNED NOT NULL,
    `nome`              VARCHAR(150) NULL,
    `social_name`       VARCHAR(100) NULL,
    `tipo_documento`    VARCHAR(1) NULL COMMENT '1=CPF, 2=passaporte',
    `documento`         VARCHAR(30) NULL COMMENT 'PENDENTE mascaramento LGPD - ctl_lgpd_pendencias',
    `email`             VARCHAR(100) NULL,
    `membro_comite`     VARCHAR(1) NULL,
    `data_nascimento`   DATE NULL,
    `sexo`              VARCHAR(1) NULL,
    `etnia`             VARCHAR(20) NULL,
    `deficiencia_fisica` VARCHAR(20) NULL,
    `nacionalidade`     VARCHAR(255) NULL,
    `telefone`          VARCHAR(255) NULL,
    `celular1`          VARCHAR(255) NULL,
    `banco_id`          INT UNSIGNED NULL,
    `agencia`           VARCHAR(255) NULL,
    `conta`             VARCHAR(255) NULL,
    `flag_ativo`        TINYINT(1) NOT NULL DEFAULT 1,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_usuario`),
    UNIQUE KEY `uq_dim_usuario_origem` (`id_user_origem`),
    KEY `ix_dim_usuario_documento` (`documento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada de pessoas (role-playing: proponente/orientador/supervisor/gestor/ator)';

-- ----------------------------------------------------------------------------
-- dim_edital
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_edital` (
    `sk_edital`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_edital_origem`  INT UNSIGNED NOT NULL,
    `nome`              VARCHAR(255) NULL,
    `ano`               VARCHAR(4) NULL,
    `numero`            INT NULL,
    `tipo`              VARCHAR(2) NULL COMMENT '1-bolsa; 2-auxilio',
    `caracteristica`    VARCHAR(2) NULL,
    `personalidade_juridica` VARCHAR(1) NULL,
    `uso`               TINYINT NULL,
    `quota`             TINYINT NULL,
    `sk_modalidade`     BIGINT UNSIGNED NULL,
    `sk_setor`          BIGINT UNSIGNED NULL,
    `edital_pai_id_origem` INT UNSIGNED NULL,
    `flag_ativo`        TINYINT(1) NOT NULL DEFAULT 1,
    `dt_criacao_origem` TIMESTAMP NULL,
    `dt_atualizacao_origem` TIMESTAMP NULL,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_edital`),
    UNIQUE KEY `uq_dim_edital_origem` (`id_edital_origem`),
    KEY `ix_dim_edital_modalidade` (`sk_modalidade`),
    KEY `ix_dim_edital_setor` (`sk_setor`),
    CONSTRAINT `fk_dim_edital_modalidade` FOREIGN KEY (`sk_modalidade`) REFERENCES `dim_modalidade` (`sk_modalidade`),
    CONSTRAINT `fk_dim_edital_setor` FOREIGN KEY (`sk_setor`) REFERENCES `dim_setor` (`sk_setor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao de editais (SCD Tipo 1 nesta fase)';

-- ----------------------------------------------------------------------------
-- dim_chamada
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_chamada` (
    `sk_chamada`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_chamada_origem`  INT UNSIGNED NOT NULL,
    `sk_edital`          BIGINT UNSIGNED NOT NULL,
    `numero`             INT UNSIGNED NULL,
    `grupo`              INT NULL,
    `nome`               VARCHAR(255) NULL,
    `dt_inicio`          DATE NULL,
    `dt_fim`             DATE NULL,
    `flag_publicada`     TINYINT(1) NULL,
    `dt_recurso_inicio`  DATE NULL,
    `dt_recurso_fim`     DATE NULL,
    `dt_carga`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_chamada`),
    UNIQUE KEY `uq_dim_chamada_origem` (`id_chamada_origem`),
    KEY `ix_dim_chamada_edital` (`sk_edital`),
    CONSTRAINT `fk_dim_chamada_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao de chamadas de edital';

-- ----------------------------------------------------------------------------
-- dim_convenio
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_convenio` (
    `sk_convenio`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_convenio_origem` INT UNSIGNED NOT NULL,
    `numero`             VARCHAR(20) NULL,
    `ano`                INT NULL,
    `nome`               VARCHAR(100) NULL,
    `tipo`               VARCHAR(2) NULL COMMENT '1-municipal;2-estadual;3-federal;4-internacional',
    `dt_assinatura`      DATE NULL,
    `dt_vigencia_inicial` DATE NULL,
    `dt_vigencia_final`  DATE NULL,
    `dt_relatorio_parcial` DATE NULL,
    `dt_relatorio_final` DATE NULL,
    `dt_prestacao_inicial` DATE NULL,
    `dt_prestacao_final` DATE NULL,
    `sk_gestor`          BIGINT UNSIGNED NULL,
    `dt_carga`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_convenio`),
    UNIQUE KEY `uq_dim_convenio_origem` (`id_convenio_origem`),
    KEY `ix_dim_convenio_gestor` (`sk_gestor`),
    CONSTRAINT `fk_dim_convenio_gestor` FOREIGN KEY (`sk_gestor`) REFERENCES `dim_usuario` (`sk_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao de convenios institucionais';

-- ----------------------------------------------------------------------------
-- dim_situacao (dimensao conformada generica de status)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_situacao` (
    `sk_situacao`     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `dominio_origem`  VARCHAR(60) NOT NULL COMMENT "Ex.: 'processo','pagamento','chamada_publicacao','termo'",
    `codigo_origem`   VARCHAR(10) NOT NULL,
    `descricao`       VARCHAR(255) NOT NULL,
    PRIMARY KEY (`sk_situacao`),
    UNIQUE KEY `uq_dim_situacao_dominio_codigo` (`dominio_origem`, `codigo_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada de status/situacao para dominios sem tabela de apoio no patronage';

-- ----------------------------------------------------------------------------
-- dim_fonte_pagadora
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_fonte_pagadora` (
    `sk_fonte`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_fonte_origem`  INT UNSIGNED NOT NULL,
    `nome`             VARCHAR(80) NULL,
    `numero`           BIGINT NULL,
    `natureza`         INT NULL COMMENT '0-governo do estado; 1-convenio',
    `tipo`             INT NULL COMMENT '0-custeio; 1-capital',
    `dt_carga`         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fonte`),
    UNIQUE KEY `uq_dim_fonte_origem` (`id_fonte_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada de fontes pagadoras';

-- ----------------------------------------------------------------------------
-- dim_subacao (lado Patronage do vinculo com o SIGEF)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `dim_subacao` (
    `sk_subacao`        BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_subacao_origem` INT UNSIGNED NOT NULL,
    `nome`              VARCHAR(255) NULL,
    `numero`            VARCHAR(255) NULL,
    `flag_ativa`        TINYINT(1) NULL,
    `acao_id_origem`    INT UNSIGNED NULL,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_subacao`),
    UNIQUE KEY `uq_dim_subacao_origem` (`id_subacao_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Dimensao conformada de subacoes orcamentarias (patronage.subacoes)';
