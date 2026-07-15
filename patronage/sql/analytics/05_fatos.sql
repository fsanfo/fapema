-- ============================================================================
-- patronage_analytics | Script 05 - Tabelas Fato
-- Fase 1: Modelagem e Schema Base
-- ============================================================================

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- fato_chamada_ciclo (accumulating snapshot; grao = 1 linha por edital_chamada)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_chamada_ciclo` (
    `sk_fato`                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sk_chamada`                BIGINT UNSIGNED NOT NULL,
    `sk_edital`                 BIGINT UNSIGNED NOT NULL,
    `sk_modalidade`             BIGINT UNSIGNED NULL,
    `sk_setor`                  BIGINT UNSIGNED NULL,
    `dt_abertura`               DATE NULL,
    `dt_fechamento`             DATE NULL,
    `qtd_dias_ciclo`            INT NULL,
    `qtd_processos_recebidos`  INT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_processos_aprovados`  INT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_processos_reprovados` INT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_erros_step`            INT UNSIGNED NOT NULL DEFAULT 0,
    `sk_situacao_publicacao`   BIGINT UNSIGNED NULL,
    `id_lote_carga`             BIGINT UNSIGNED NOT NULL,
    `dt_carga`                  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_chamada_ciclo` (`sk_chamada`),
    KEY `ix_fcc_edital` (`sk_edital`),
    KEY `ix_fcc_dt_abertura` (`dt_abertura`),
    CONSTRAINT `fk_fcc_chamada` FOREIGN KEY (`sk_chamada`) REFERENCES `dim_chamada` (`sk_chamada`),
    CONSTRAINT `fk_fcc_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_fcc_modalidade` FOREIGN KEY (`sk_modalidade`) REFERENCES `dim_modalidade` (`sk_modalidade`),
    CONSTRAINT `fk_fcc_setor` FOREIGN KEY (`sk_setor`) REFERENCES `dim_setor` (`sk_setor`),
    CONSTRAINT `fk_fcc_situacao` FOREIGN KEY (`sk_situacao_publicacao`) REFERENCES `dim_situacao` (`sk_situacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato de ciclo de chamadas - Painel Operacional de Chamadas e Editais';

-- ----------------------------------------------------------------------------
-- fato_processo_atividade (grao = 1 linha por processo)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_processo_atividade` (
    `sk_fato`               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_processo_origem`    INT UNSIGNED NOT NULL,
    `sk_edital`             BIGINT UNSIGNED NULL,
    `sk_chamada`            BIGINT UNSIGNED NOT NULL,
    `sk_instituicao`        BIGINT UNSIGNED NULL,
    `sk_area_origem`        INT UNSIGNED NULL COMMENT 'Referencia direta a patronage.areas.id (sem dimensao propria nesta fase)',
    `sk_proponente`         BIGINT UNSIGNED NULL,
    `sk_orientador`         BIGINT UNSIGNED NULL,
    `sk_supervisor`         BIGINT UNSIGNED NULL,
    `dt_envio`              DATE NULL,
    `dt_assinatura`         DATE NULL,
    `qtd_dias_ate_assinatura` INT NULL,
    `valor_concedido`       DECIMAL(12,2) NULL,
    `sk_situacao`           BIGINT UNSIGNED NULL,
    `step_atual`            INT NULL,
    `id_lote_carga`         BIGINT UNSIGNED NOT NULL,
    `dt_carga`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_processo_origem` (`id_processo_origem`),
    KEY `ix_fpa_edital` (`sk_edital`),
    KEY `ix_fpa_chamada` (`sk_chamada`),
    KEY `ix_fpa_proponente` (`sk_proponente`),
    KEY `ix_fpa_dt_envio` (`dt_envio`),
    CONSTRAINT `fk_fpa_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_fpa_chamada` FOREIGN KEY (`sk_chamada`) REFERENCES `dim_chamada` (`sk_chamada`),
    CONSTRAINT `fk_fpa_instituicao` FOREIGN KEY (`sk_instituicao`) REFERENCES `dim_instituicao` (`sk_instituicao`),
    CONSTRAINT `fk_fpa_proponente` FOREIGN KEY (`sk_proponente`) REFERENCES `dim_usuario` (`sk_usuario`),
    CONSTRAINT `fk_fpa_orientador` FOREIGN KEY (`sk_orientador`) REFERENCES `dim_usuario` (`sk_usuario`),
    CONSTRAINT `fk_fpa_supervisor` FOREIGN KEY (`sk_supervisor`) REFERENCES `dim_usuario` (`sk_usuario`),
    CONSTRAINT `fk_fpa_situacao` FOREIGN KEY (`sk_situacao`) REFERENCES `dim_situacao` (`sk_situacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato de processos/atividades - Painel Operacional e Executivo';

-- ----------------------------------------------------------------------------
-- fato_convenio_execucao (grao = convenio x mes de competencia)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_convenio_execucao` (
    `sk_fato`                 BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sk_convenio`             BIGINT UNSIGNED NOT NULL,
    `ano_mes_competencia`     INT UNSIGNED NOT NULL COMMENT 'YYYYMM - referencia dim_tempo.ano_mes',
    `valor_planejado`         DECIMAL(14,2) NOT NULL DEFAULT 0,
    `valor_executado`         DECIMAL(14,2) NOT NULL DEFAULT 0,
    `valor_aditivado`         DECIMAL(14,2) NOT NULL DEFAULT 0,
    `sk_situacao_relatorio`   BIGINT UNSIGNED NULL,
    `dias_atraso_prestacao`   INT NULL,
    `id_lote_carga`           BIGINT UNSIGNED NOT NULL,
    `dt_carga`                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_convenio_execucao` (`sk_convenio`, `ano_mes_competencia`),
    KEY `ix_fce_competencia` (`ano_mes_competencia`),
    CONSTRAINT `fk_fce_convenio` FOREIGN KEY (`sk_convenio`) REFERENCES `dim_convenio` (`sk_convenio`),
    CONSTRAINT `fk_fce_situacao` FOREIGN KEY (`sk_situacao_relatorio`) REFERENCES `dim_situacao` (`sk_situacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato de execucao de convenios por mes de competencia - Painel Gerencial';

-- ----------------------------------------------------------------------------
-- fato_financeiro_patronage (grao = 1 linha por parcela paga)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_financeiro_patronage` (
    `sk_fato`                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_termo_parcela_paga_origem` INT UNSIGNED NOT NULL,
    `sk_edital`                  BIGINT UNSIGNED NULL,
    `sk_proponente`              BIGINT UNSIGNED NULL,
    `sk_subacao`                 BIGINT UNSIGNED NULL,
    `sk_fonte_pagadora`          BIGINT UNSIGNED NULL,
    `ano_mes_vencimento`         INT UNSIGNED NULL COMMENT 'YYYYMM',
    `dt_pagamento`               DATE NULL,
    `valor_parcela`              DECIMAL(12,2) NULL,
    `valor_pago`                 DECIMAL(12,2) NULL,
    `sk_situacao_pagamento`     BIGINT UNSIGNED NULL,
    `ordem_bancaria`             VARCHAR(20) NULL COMMENT 'Chave textual auxiliar de cruzamento com fato_financeiro_sigef',
    `nota_empenho`               VARCHAR(20) NULL,
    `flag_inserido_via_api`     TINYINT(1) NOT NULL DEFAULT 0,
    `id_lote_carga`              BIGINT UNSIGNED NOT NULL,
    `dt_carga`                   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_fin_patronage_origem` (`id_termo_parcela_paga_origem`),
    KEY `ix_ffp_edital` (`sk_edital`),
    KEY `ix_ffp_proponente` (`sk_proponente`),
    KEY `ix_ffp_ordem_bancaria` (`ordem_bancaria`),
    KEY `ix_ffp_competencia` (`ano_mes_vencimento`),
    CONSTRAINT `fk_ffp_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_ffp_proponente` FOREIGN KEY (`sk_proponente`) REFERENCES `dim_usuario` (`sk_usuario`),
    CONSTRAINT `fk_ffp_subacao` FOREIGN KEY (`sk_subacao`) REFERENCES `dim_subacao` (`sk_subacao`),
    CONSTRAINT `fk_ffp_fonte` FOREIGN KEY (`sk_fonte_pagadora`) REFERENCES `dim_fonte_pagadora` (`sk_fonte`),
    CONSTRAINT `fk_ffp_situacao` FOREIGN KEY (`sk_situacao_pagamento`) REFERENCES `dim_situacao` (`sk_situacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato financeiro lado Patronage (pagamentos de bolsas/auxilios) - insumo da conciliacao SIGEF';

-- ----------------------------------------------------------------------------
-- fato_financeiro_sigef (grao = 1 linha por Ordem Bancaria SIGEF)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_financeiro_sigef` (
    `sk_fato`                    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `id_ordem_bancaria_origem`   VARCHAR(60) NOT NULL,
    `sk_subacao`                 BIGINT UNSIGNED NULL COMMENT 'Resolvido via ponte_edital_sigef_subacao na Fase 2',
    `cdcredor`                   VARCHAR(30) NULL COMMENT 'PENDENTE mascaramento LGPD',
    `cpf_cnpj_credor`            VARCHAR(30) NULL COMMENT 'PENDENTE mascaramento LGPD',
    `dt_pagamento`               DATE NULL,
    `dt_transacao`               DATE NULL,
    `valor_total`                DECIMAL(19,2) NULL,
    `domicilio_origem`           VARCHAR(60) NULL,
    `domicilio_destino`          VARCHAR(60) NULL,
    `cd_situacao_ordem_bancaria` VARCHAR(10) NULL,
    `id_lote_carga`              BIGINT UNSIGNED NOT NULL,
    `dt_carga`                   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_fin_sigef_origem` (`id_ordem_bancaria_origem`),
    KEY `ix_ffs_subacao` (`sk_subacao`),
    KEY `ix_ffs_cdcredor` (`cdcredor`),
    KEY `ix_ffs_dt_pagamento` (`dt_pagamento`),
    CONSTRAINT `fk_ffs_subacao` FOREIGN KEY (`sk_subacao`) REFERENCES `dim_subacao` (`sk_subacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato financeiro lado SIGEF (Ordens Bancarias) - insumo da conciliacao';

-- ----------------------------------------------------------------------------
-- fato_reconciliacao_sigef_patronage (grao = Edital + Proponente + competencia)
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `fato_reconciliacao_sigef_patronage` (
    `sk_fato`                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sk_edital`               BIGINT UNSIGNED NOT NULL,
    `sk_proponente`           BIGINT UNSIGNED NOT NULL,
    `ano_mes_competencia`     INT UNSIGNED NOT NULL COMMENT 'YYYYMM',
    `valor_patronage`         DECIMAL(14,2) NOT NULL DEFAULT 0,
    `valor_sigef`             DECIMAL(14,2) NOT NULL DEFAULT 0,
    `diferenca_valor`         DECIMAL(14,2) NOT NULL DEFAULT 0,
    `status_patronage`        VARCHAR(30) NULL,
    `status_sigef`            VARCHAR(30) NULL,
    `flag_divergencia`        TINYINT(1) NOT NULL DEFAULT 0,
    `tipo_divergencia`        ENUM('ok','ausencia_sigef','ausencia_patronage','diferenca_valor','diferenca_status') NOT NULL DEFAULT 'ok',
    `id_lote_carga`           BIGINT UNSIGNED NOT NULL,
    `dt_conciliacao`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`sk_fato`),
    UNIQUE KEY `uq_fato_reconciliacao` (`sk_edital`, `sk_proponente`, `ano_mes_competencia`, `id_lote_carga`),
    KEY `ix_frsp_competencia` (`ano_mes_competencia`),
    KEY `ix_frsp_divergencia` (`flag_divergencia`, `tipo_divergencia`),
    CONSTRAINT `fk_frsp_edital` FOREIGN KEY (`sk_edital`) REFERENCES `dim_edital` (`sk_edital`),
    CONSTRAINT `fk_frsp_proponente` FOREIGN KEY (`sk_proponente`) REFERENCES `dim_usuario` (`sk_usuario`),
    CONSTRAINT `fk_frsp_lote` FOREIGN KEY (`id_lote_carga`) REFERENCES `ctl_lote_carga` (`id_lote`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato central do Painel de Conciliacao SIGEF x Patronage - chave Edital+CPF';

-- ----------------------------------------------------------------------------
-- fato_eventos_operacionais_diario (grao = dia x log_name x event x subject_type)
-- ----------------------------------------------------------------------------
-- Observacao tecnica: em tabela particionada por RANGE(dt_evento), o MySQL 8
-- exige que toda chave unica (inclusive a PRIMARY KEY) contenha a coluna de
-- particionamento. Por isso a chave primaria e composta incluindo dt_evento,
-- em vez de um surrogate key isolado (mesmo padrao adotado em
-- lnd_patronage_activity_log_diario).
CREATE TABLE IF NOT EXISTS `fato_eventos_operacionais_diario` (
    `dt_evento`             DATE NOT NULL,
    `log_name`              VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `event`                 VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `subject_type`          VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `qtd_eventos`           BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_atores_distintos`  BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `id_lote_carga`         BIGINT UNSIGNED NOT NULL,
    `dt_carga`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`dt_evento`, `log_name`, `event`, `subject_type`),
    KEY `ix_feod_lote` (`id_lote_carga`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Fato agregado diario de eventos operacionais (activity_log) - qualidade/auditoria'
  PARTITION BY RANGE (TO_DAYS(`dt_evento`)) (
      PARTITION p_inicial VALUES LESS THAN (TO_DAYS('2026-01-01')),
      PARTITION p_2026 VALUES LESS THAN (TO_DAYS('2027-01-01')),
      PARTITION p_futuro VALUES LESS THAN MAXVALUE
  );
