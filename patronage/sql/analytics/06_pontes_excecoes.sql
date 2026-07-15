-- ============================================================================
-- patronage_analytics | Script 06 - Tabelas Ponte e Fila de Excecao
-- Fase 1: Modelagem e Schema Base
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- ponte_edital_sigef_subacao: de-para versionado Edital <-> Subacao/Processo
-- SIGEF, com responsavel funcional (mitigacao de risco do addendum tecnico).
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ponte_edital_sigef_subacao` (
    `sk_ponte`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sk_edital`            BIGINT UNSIGNED NOT NULL,
    `sk_subacao`           BIGINT UNSIGNED NULL,
    `nuprocesso_sigef`     VARCHAR(30) NULL COMMENT 'Preenchido quando o vinculo e por numero de processo, nao por subacao',
    `dt_vigencia_inicio`   DATE NOT NULL,
    `dt_vigencia_fim`      DATE NULL,
    `responsavel_funcional` VARCHAR(150) NOT NULL COMMENT 'Nome/matricula de quem validou o vinculo',
    `confiabilidade`       ENUM('alta','media','baixa') NOT NULL DEFAULT 'media',
    `flag_ativo`           TINYINT(1) NOT NULL DEFAULT 1,
    `dt_criacao`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `dt_atualizacao`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_ponte`),
    KEY `ix_pesc_edital` (`sk_edital`),
    KEY `ix_pesc_subacao` (`sk_subacao`),
    KEY `ix_pesc_nuprocesso` (`nuprocesso_sigef`),
    CONSTRAINT `fk_pesc_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_pesc_subacao` FOREIGN KEY (`sk_subacao`) REFERENCES `dim_subacao` (`sk_subacao`),
    CONSTRAINT `chk_pesc_vinculo` CHECK (`sk_subacao` IS NOT NULL OR `nuprocesso_sigef` IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='De-para versionado Edital (Patronage) <-> Subacao/Processo (SIGEF)';

-- ----------------------------------------------------------------------------
-- ponte_proponente_credor_sigef: de-para versionado CPF <-> cdcredor
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `ponte_proponente_credor_sigef` (
    `sk_ponte`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sk_usuario`          BIGINT UNSIGNED NOT NULL,
    `cpf_cnpj`            VARCHAR(30) NOT NULL COMMENT 'PENDENTE mascaramento LGPD - ctl_lgpd_pendencias',
    `cdcredor_sigef`      VARCHAR(30) NOT NULL,
    `dt_vigencia_inicio`  DATE NOT NULL,
    `dt_vigencia_fim`     DATE NULL,
    `confiabilidade`      ENUM('alta','media','baixa') NOT NULL DEFAULT 'media',
    `flag_ativo`          TINYINT(1) NOT NULL DEFAULT 1,
    `dt_criacao`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `dt_atualizacao`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_ponte`),
    KEY `ix_ppcs_usuario` (`sk_usuario`),
    KEY `ix_ppcs_cpf` (`cpf_cnpj`),
    KEY `ix_ppcs_cdcredor` (`cdcredor_sigef`),
    CONSTRAINT `fk_ppcs_usuario` FOREIGN KEY (`sk_usuario`) REFERENCES `dim_usuario` (`sk_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='De-para versionado Proponente (Patronage) <-> Credor (SIGEF)';

-- ----------------------------------------------------------------------------
-- exc_reconciliacao_sigef_patronage: fila de excecao auditavel (FR-4 do PRD).
-- Registros aqui NAO entram no consolidado executivo ate curadoria funcional.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `exc_reconciliacao_sigef_patronage` (
    `id_excecao`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_lote_carga`           BIGINT UNSIGNED NOT NULL,
    `tipo_excecao`            ENUM(
                                  'sem_correspondencia_sigef',
                                  'sem_correspondencia_patronage',
                                  'divergencia_valor',
                                  'divergencia_status',
                                  'chave_ambigua_ponte'
                              ) NOT NULL,
    `sk_edital`               BIGINT UNSIGNED NULL,
    `sk_proponente`           BIGINT UNSIGNED NULL,
    `ano_mes_competencia`     INT UNSIGNED NULL,
    `valor_patronage`         DECIMAL(14,2) NULL,
    `valor_sigef`             DECIMAL(14,2) NULL,
    `status_patronage`        VARCHAR(30) NULL,
    `status_sigef`            VARCHAR(30) NULL,
    `dt_identificacao`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status_tratativa`        ENUM('pendente','em_analise','resolvida','rejeitada') NOT NULL DEFAULT 'pendente',
    `responsavel_curadoria`   VARCHAR(150) NULL,
    `dt_tratativa`            DATETIME NULL,
    `observacao`              TEXT NULL,
    PRIMARY KEY (`id_excecao`),
    KEY `ix_excr_lote` (`id_lote_carga`),
    KEY `ix_excr_status` (`status_tratativa`),
    KEY `ix_excr_tipo` (`tipo_excecao`),
    CONSTRAINT `fk_excr_lote` FOREIGN KEY (`id_lote_carga`) REFERENCES `ctl_lote_carga` (`id_lote`),
    CONSTRAINT `fk_excr_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_excr_proponente` FOREIGN KEY (`sk_proponente`) REFERENCES `dim_usuario` (`sk_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fila de excecao auditavel de reconciliacao SIGEF x Patronage - curadoria funcional obrigatoria antes do consolidado executivo';

-- ----------------------------------------------------------------------------
-- exc_qualidade_dados: fila de excecao generica de qualidade de dados (DQ)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `exc_qualidade_dados` (
    `id_excecao`         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_lote_carga`      BIGINT UNSIGNED NOT NULL,
    `id_regra`           INT UNSIGNED NOT NULL,
    `tabela_afetada`     VARCHAR(120) NOT NULL,
    `chave_registro`     VARCHAR(120) NOT NULL,
    `descricao_erro`     TEXT NULL,
    `dt_identificacao`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `status_tratativa`   ENUM('pendente','em_analise','resolvida','rejeitada') NOT NULL DEFAULT 'pendente',
    PRIMARY KEY (`id_excecao`),
    KEY `ix_excdq_lote` (`id_lote_carga`),
    KEY `ix_excdq_regra` (`id_regra`),
    CONSTRAINT `fk_excdq_lote` FOREIGN KEY (`id_lote_carga`) REFERENCES `ctl_lote_carga` (`id_lote`),
    CONSTRAINT `fk_excdq_regra` FOREIGN KEY (`id_regra`) REFERENCES `ctl_dq_regra` (`id_regra`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fila de excecao auditavel de qualidade de dados (regras de ctl_dq_regra)';
