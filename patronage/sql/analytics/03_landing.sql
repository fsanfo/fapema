-- ============================================================================
-- patronage_analytics | Script 03 - Camada Landing
-- Fase 1: Modelagem e Schema Base
--
-- Landing Patronage: copia rasa das colunas necessarias das entidades
-- priorizadas (mesma instancia MySQL, populada por INSERT...SELECT
-- incremental na Fase 2 - nao altera nem move dados do schema `patronage`).
--
-- Landing SIGEF: recebe o payload da API (JSON bruto + colunas parsed de
-- maior uso), populada pelo client de integracao a ser detalhado na Fase 2.
-- ============================================================================

USE `patronage_analytics`;

-- ============================================================================
-- LANDING PATRONAGE
-- ============================================================================

CREATE TABLE IF NOT EXISTS `lnd_patronage_editais` (
    `id_origem`               INT UNSIGNED NOT NULL,
    `nome`                    VARCHAR(255) NULL,
    `ano`                     VARCHAR(4) NULL,
    `numero`                  INT NULL,
    `tipo`                    VARCHAR(2) NULL,
    `caracteristica`          VARCHAR(2) NULL,
    `personalidade_juridica`  VARCHAR(1) NULL,
    `uso`                     TINYINT NULL,
    `quota`                   TINYINT NULL,
    `modalidade_id`           INT UNSIGNED NULL,
    `setor_id`                INT UNSIGNED NULL,
    `user_responsavel`        BIGINT UNSIGNED NULL,
    `edital_pai_id`           INT UNSIGNED NULL,
    `acesso_restrito`         TINYINT NULL,
    `created_at_origem`       TIMESTAMP NULL,
    `updated_at_origem`       TIMESTAMP NULL,
    `id_lote_carga`           BIGINT UNSIGNED NOT NULL,
    `dt_carga`                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.editais';

CREATE TABLE IF NOT EXISTS `lnd_patronage_edital_chamadas` (
    `id_origem`          INT UNSIGNED NOT NULL,
    `edital_id`           INT UNSIGNED NOT NULL,
    `numero`              INT UNSIGNED NULL,
    `grupo`               INT NULL,
    `nome`                VARCHAR(255) NULL,
    `inicio`              DATETIME NULL,
    `fim`                 DATETIME NULL,
    `publicada`           TINYINT NULL,
    `parecer_pesquisador` TINYINT NULL,
    `recurso_inicio`      DATETIME NULL,
    `recurso_fim`         DATETIME NULL,
    `deleted_at_origem`   TIMESTAMP NULL,
    `id_lote_carga`       BIGINT UNSIGNED NOT NULL,
    `dt_carga`            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_edital_chamadas_edital` (`edital_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.edital_chamadas';

CREATE TABLE IF NOT EXISTS `lnd_patronage_edital_chamada_faixas` (
    `id_origem`            INT UNSIGNED NOT NULL,
    `valor`                DECIMAL(10,2) NULL,
    `contigenciamento`     DECIMAL(10,2) NULL,
    `edital_chamada_id`    INT UNSIGNED NOT NULL,
    `descricao_faixa_id`   INT UNSIGNED NOT NULL,
    `id_lote_carga`        BIGINT UNSIGNED NOT NULL,
    `dt_carga`             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.edital_chamada_faixas';

CREATE TABLE IF NOT EXISTS `lnd_patronage_edital_dados_financeiro` (
    `id_origem`      INT UNSIGNED NOT NULL,
    `valor_edital`   DECIMAL(19,2) NULL,
    `sub_acao`       INT NULL,
    `fonte`          VARCHAR(1) NULL,
    `convenio_id`    INT UNSIGNED NULL,
    `edital_id`      INT UNSIGNED NULL,
    `id_lote_carga`  BIGINT UNSIGNED NOT NULL,
    `dt_carga`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.edital_dados_financeiro';

CREATE TABLE IF NOT EXISTS `lnd_patronage_modalidades` (
    `id_origem`       INT UNSIGNED NOT NULL,
    `sigla`           VARCHAR(30) NULL,
    `nome`            VARCHAR(100) NULL,
    `tipo`            VARCHAR(2) NULL,
    `status`          TINYINT NULL,
    `sub_programa_id` INT UNSIGNED NULL,
    `id_lote_carga`   BIGINT UNSIGNED NOT NULL,
    `dt_carga`        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.modalidades';

CREATE TABLE IF NOT EXISTS `lnd_patronage_setores` (
    `id_origem`               INT UNSIGNED NOT NULL,
    `nome`                    VARCHAR(30) NULL,
    `email`                   VARCHAR(100) NULL,
    `edital`                  TINYINT NULL,
    `id_lote_carga`           BIGINT UNSIGNED NOT NULL,
    `dt_carga`                DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.setores';

CREATE TABLE IF NOT EXISTS `lnd_patronage_erro_steps_chamada` (
    `id_origem`             BIGINT UNSIGNED NOT NULL,
    `edital_chamada_id`     INT UNSIGNED NULL,
    `erro_anexos`           TINYINT NULL,
    `erro_documentacoes`    TINYINT NULL,
    `erro_dados_contratacao` TINYINT NULL,
    `erro_termo_outorga`    TINYINT NULL,
    `erro_termo_aditivo_valor` TINYINT NULL,
    `erro_termo_aditivo_prazo` TINYINT NULL,
    `erro_termo_apostilamento` TINYINT NULL,
    `erro_termo_aditivo`    TINYINT NULL,
    `id_lote_carga`         BIGINT UNSIGNED NOT NULL,
    `dt_carga`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.erro_steps_chamada';

CREATE TABLE IF NOT EXISTS `lnd_patronage_processos` (
    `id_origem`             INT UNSIGNED NOT NULL,
    `sigla`                 VARCHAR(50) NULL,
    `situacao`               TINYINT NULL,
    `user_id`               BIGINT UNSIGNED NULL,
    `edital_chamada_id`     INT UNSIGNED NOT NULL,
    `edital_chamada_faixa_id` INT UNSIGNED NULL,
    `orientador_id`         BIGINT UNSIGNED NULL,
    `supervisor_id`         BIGINT UNSIGNED NULL,
    `area_id`               INT UNSIGNED NULL,
    `sub_area_id`           INT UNSIGNED NULL,
    `envio`                 TIMESTAMP NULL,
    `valor_concedido`       DOUBLE(10,2) NULL,
    `instituicao_id`        INT UNSIGNED NULL,
    `polo_id`               INT UNSIGNED NULL,
    `step`                  INT NULL,
    `data_assinatura`       TIMESTAMP NULL,
    `created_at_origem`     TIMESTAMP NULL,
    `updated_at_origem`     TIMESTAMP NULL,
    `deleted_at_origem`     TIMESTAMP NULL,
    `id_lote_carga`         BIGINT UNSIGNED NOT NULL,
    `dt_carga`              DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_processos_edital_chamada` (`edital_chamada_id`),
    KEY `ix_lnd_processos_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.processos';

CREATE TABLE IF NOT EXISTS `lnd_patronage_historico_processo_status` (
    `id_origem`         BIGINT UNSIGNED NOT NULL,
    `processo_id`       INT UNSIGNED NOT NULL,
    `status_anterior`   INT NULL,
    `status_atual`      INT NOT NULL,
    `user_id`           BIGINT UNSIGNED NOT NULL,
    `created_at_origem` TIMESTAMP NULL,
    `id_lote_carga`     BIGINT UNSIGNED NOT NULL,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_hist_processo` (`processo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.historico_processo_status';

CREATE TABLE IF NOT EXISTS `lnd_patronage_instituicoes` (
    `id_origem`   INT UNSIGNED NOT NULL,
    `sigla`       VARCHAR(20) NULL,
    `nome`        VARCHAR(150) NULL,
    `cnpj`        VARCHAR(14) NULL,
    `ativo`       TINYINT NULL,
    `situacao`    TINYINT NULL,
    `modalidade`  TINYINT NULL,
    `tipo`        TINYINT NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.instituicoes';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenios` (
    `id_origem`          INT UNSIGNED NOT NULL,
    `numero`             VARCHAR(20) NULL,
    `ano`                INT NULL,
    `nome`               VARCHAR(100) NULL,
    `tipo`               VARCHAR(2) NULL,
    `assinatura`         DATE NULL,
    `vigencia_inicial`   DATE NULL,
    `vigencia_final`     DATE NULL,
    `relatorio`          TINYINT NULL,
    `relatorio_parcial`  DATE NULL,
    `relatorio_final`    DATE NULL,
    `prestacao_inicial`  DATE NULL,
    `prestacao_final`    DATE NULL,
    `gestor_id`          INT UNSIGNED NULL,
    `created_at_origem`  TIMESTAMP NULL,
    `updated_at_origem`  TIMESTAMP NULL,
    `id_lote_carga`      BIGINT UNSIGNED NOT NULL,
    `dt_carga`           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenios';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenio_instituicao` (
    `id_origem`      INT UNSIGNED NOT NULL,
    `convenio_id`    INT UNSIGNED NOT NULL,
    `instituicao_id` INT UNSIGNED NOT NULL,
    `tipo`           INT UNSIGNED NOT NULL,
    `id_lote_carga`  BIGINT UNSIGNED NOT NULL,
    `dt_carga`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_conv_inst_convenio` (`convenio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenio_instituicao - liga convenio_financeiro ao convenio via instituicao';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenio_financeiro` (
    `id_origem`                    INT UNSIGNED NOT NULL,
    `despesa_corrente_custeio`     DECIMAL(10,2) NULL,
    `despesa_corrente_capital`     DECIMAL(10,2) NULL,
    `convenio_instituicao_id`      INT UNSIGNED NOT NULL,
    `id_lote_carga`                BIGINT UNSIGNED NOT NULL,
    `dt_carga`                     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenio_financeiro';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenio_planejamentos` (
    `id_origem`      INT UNSIGNED NOT NULL,
    `mes`            INT NOT NULL,
    `ano`            INT NOT NULL,
    `valor`          DECIMAL(10,2) NULL,
    `financeiro_id`  INT UNSIGNED NOT NULL,
    `id_lote_carga`  BIGINT UNSIGNED NOT NULL,
    `dt_carga`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenio_planejamentos';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenio_aditivos` (
    `id_origem`     BIGINT UNSIGNED NOT NULL,
    `tipo`          INT NULL,
    `ano`           INT NULL,
    `numero`        INT NULL,
    `assinatura`    DATE NULL,
    `prorrogacao`   DATE NULL,
    `convenio_id`   INT UNSIGNED NOT NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenio_aditivos';

CREATE TABLE IF NOT EXISTS `lnd_patronage_convenio_aditivo_financeiros` (
    `id_origem`              BIGINT UNSIGNED NOT NULL,
    `convenio_aditivo_id`    BIGINT UNSIGNED NOT NULL,
    `convenio_financeiro_id` INT UNSIGNED NOT NULL,
    `valor`                  DECIMAL(10,2) NOT NULL,
    `id_lote_carga`          BIGINT UNSIGNED NOT NULL,
    `dt_carga`               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.convenio_aditivo_financeiros';

CREATE TABLE IF NOT EXISTS `lnd_patronage_subacoes` (
    `id_origem` INT UNSIGNED NOT NULL,
    `nome`      VARCHAR(255) NULL,
    `numero`    VARCHAR(255) NULL,
    `ativa`     TINYINT NULL,
    `acao_id`   INT UNSIGNED NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.subacoes';

CREATE TABLE IF NOT EXISTS `lnd_patronage_fonte_pagadoras` (
    `id_origem` INT UNSIGNED NOT NULL,
    `nome`      VARCHAR(80) NULL,
    `numero`    BIGINT NULL,
    `natureza`  INT NULL,
    `tipo`      INT NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.fonte_pagadoras';

CREATE TABLE IF NOT EXISTS `lnd_patronage_termos` (
    `id_origem`         INT UNSIGNED NOT NULL,
    `vigencia_inicial`  DATE NULL,
    `vigencia_final`    DATE NULL,
    `valor`             DECIMAL(8,2) NULL,
    `numero`            INT NULL,
    `ano`               VARCHAR(4) NULL,
    `status`            INT NULL,
    `tipo`              VARCHAR(1) NULL,
    `processo_id`       INT UNSIGNED NOT NULL,
    `data_assinatura`   TIMESTAMP NULL,
    `created_at_origem` TIMESTAMP NULL,
    `deleted_at_origem` TIMESTAMP NULL,
    `id_lote_carga`     BIGINT UNSIGNED NOT NULL,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_termos_processo` (`processo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.termos';

CREATE TABLE IF NOT EXISTS `lnd_patronage_termo_parcelas` (
    `id_origem`      INT UNSIGNED NOT NULL,
    `termo_id`       INT UNSIGNED NOT NULL,
    `mes_vencimento` INT NOT NULL,
    `ano_vencimento` INT NOT NULL,
    `valor`          DECIMAL(10,2) NULL,
    `id_lote_carga`  BIGINT UNSIGNED NOT NULL,
    `dt_carga`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_termo_parcelas_termo` (`termo_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.termo_parcelas';

CREATE TABLE IF NOT EXISTS `lnd_patronage_termo_parcelas_pagas` (
    `id_origem`           INT UNSIGNED NOT NULL,
    `termo_parcela_id`    INT UNSIGNED NOT NULL,
    `data_pagamento`      DATE NULL,
    `ordem_bancaria`      VARCHAR(20) NULL,
    `nota_empenho`        VARCHAR(20) NULL,
    `situacao_pagamento`  VARCHAR(1) NULL,
    `valor_pago`          DECIMAL(10,2) NULL,
    `user_id`             BIGINT UNSIGNED NULL,
    `subacao_id`          INT UNSIGNED NULL,
    `fonte_id`            INT UNSIGNED NULL,
    `natureza_despesa_id` INT UNSIGNED NULL,
    `inserido_via_api`    TINYINT NULL,
    `id_lote_carga`       BIGINT UNSIGNED NOT NULL,
    `dt_carga`            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_tpp_termo_parcela` (`termo_parcela_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.termo_parcelas_pagas';

CREATE TABLE IF NOT EXISTS `lnd_patronage_users` (
    `id_origem`         BIGINT UNSIGNED NOT NULL,
    `name`              VARCHAR(150) NULL,
    `social_name`       VARCHAR(100) NULL,
    `tipo_documento`    VARCHAR(1) NULL,
    `documento`         VARCHAR(30) NULL,
    `email`             VARCHAR(100) NULL,
    `membro_comite`     VARCHAR(1) NULL,
    `created_at_origem` TIMESTAMP NULL,
    `updated_at_origem` TIMESTAMP NULL,
    `deleted_at_origem` TIMESTAMP NULL,
    `id_lote_carga`     BIGINT UNSIGNED NOT NULL,
    `dt_carga`          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.users - CPF em texto claro, ver ctl_lgpd_pendencias';

CREATE TABLE IF NOT EXISTS `lnd_patronage_user_infos` (
    `id_origem`            BIGINT UNSIGNED NOT NULL,
    `user_id`              BIGINT UNSIGNED NOT NULL,
    `data_nascimento`      DATE NULL,
    `sexo`                 VARCHAR(1) NULL,
    `nacionalidade`        VARCHAR(255) NULL,
    `etnia`                VARCHAR(20) NULL,
    `deficiencia_fisica`   VARCHAR(20) NULL,
    `nome_pai`             VARCHAR(255) NULL,
    `nome_mae`             VARCHAR(255) NULL,
    `telefone`             VARCHAR(255) NULL,
    `celular1`             VARCHAR(255) NULL,
    `celular2`             VARCHAR(255) NULL,
    `banco_id`             INT UNSIGNED NULL,
    `agencia`              VARCHAR(255) NULL,
    `conta`                VARCHAR(255) NULL,
    `id_lote_carga`        BIGINT UNSIGNED NOT NULL,
    `dt_carga`             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`),
    KEY `ix_lnd_user_infos_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.user_infos - dados sensiveis, ver ctl_lgpd_pendencias';

CREATE TABLE IF NOT EXISTS `lnd_patronage_gestores` (
    `id_origem` INT UNSIGNED NOT NULL,
    `inicio`    DATE NULL,
    `fim`       DATE NULL,
    `status`    TINYINT NULL,
    `user_id`   BIGINT UNSIGNED NOT NULL,
    `tipo`      INT NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_origem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de patronage.gestores';

-- Landing agregada de activity_log: carga diaria ja agregada na extracao
-- (evita replicar ~339 mil linhas/mes na Landing curated; ver blueprint 00,
-- secao 8, item 4). O detalhe fino permanece somente no `patronage` origem.
CREATE TABLE IF NOT EXISTS `lnd_patronage_activity_log_diario` (
    `dt_evento`            DATE NOT NULL,
    `log_name`             VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `event`                VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `subject_type`         VARCHAR(255) NOT NULL DEFAULT '(nao_informado)',
    `qtd_eventos`          BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `qtd_atores_distintos` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `id_lote_carga`        BIGINT UNSIGNED NOT NULL,
    `dt_carga`             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`dt_evento`, `log_name`, `event`, `subject_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing agregada diaria de patronage.activity_log'
  PARTITION BY RANGE (TO_DAYS(`dt_evento`)) (
      PARTITION p_inicial VALUES LESS THAN (TO_DAYS('2026-01-01')),
      PARTITION p_2026 VALUES LESS THAN (TO_DAYS('2027-01-01')),
      PARTITION p_futuro VALUES LESS THAN MAXVALUE
  );

-- ============================================================================
-- LANDING SIGEF (populada pelo client de integracao - detalhado na Fase 2)
-- ============================================================================

CREATE TABLE IF NOT EXISTS `lnd_sigef_ordembancaria` (
    `id_landing`             BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `numero_ordem_bancaria`  VARCHAR(60) NULL,
    `cdsubacao`              VARCHAR(30) NULL,
    `nuprocesso`             VARCHAR(30) NULL,
    `dtpagamento`            DATE NULL,
    `dttransacao`            DATE NULL,
    `vltotal`                DECIMAL(19,2) NULL,
    `domicilio_origem`       VARCHAR(60) NULL,
    `domicilio_destino`      VARCHAR(60) NULL,
    `cdcredor`               VARCHAR(30) NULL COMMENT 'CPF/CNPJ do favorecido - ver ctl_lgpd_pendencias',
    `nmcredor`               VARCHAR(255) NULL,
    `cdsituacaoordembancaria` VARCHAR(10) NULL,
    `payload_raw`            JSON NULL COMMENT 'Payload bruto retornado pela API para auditoria/reprocessamento',
    `id_lote_carga`          BIGINT UNSIGNED NOT NULL,
    `dt_carga`               DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_landing`),
    UNIQUE KEY `uq_lnd_sigef_ob_numero` (`numero_ordem_bancaria`),
    KEY `ix_lnd_sigef_ob_subacao` (`cdsubacao`),
    KEY `ix_lnd_sigef_ob_credor` (`cdcredor`),
    KEY `ix_lnd_sigef_ob_dtpagamento` (`dtpagamento`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de /sigef/ordembancaria/ - fonte principal de conciliacao';

CREATE TABLE IF NOT EXISTS `lnd_sigef_ordemcronologica` (
    `id_landing`     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `cpf_cnpj`       VARCHAR(30) NULL COMMENT 'ver ctl_lgpd_pendencias',
    `valor_pago`     DECIMAL(19,2) NULL,
    `data_pagamento` DATE NULL,
    `payload_raw`    JSON NULL,
    `id_lote_carga`  BIGINT UNSIGNED NOT NULL,
    `dt_carga`       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_landing`),
    UNIQUE KEY `uq_lnd_sigef_oc_natural` (`cpf_cnpj`, `data_pagamento`, `valor_pago`),
    KEY `ix_lnd_sigef_oc_cpf` (`cpf_cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de /sigef/ordemcronologica/ - auditoria alternativa de desembolso por beneficiario (acesso restrito, conforme mapeamento tecnico). Chave natural composta (cpf_cnpj+data+valor) e uma aproximacao - endpoint nao expoe id proprio no mapeamento disponivel.';

CREATE TABLE IF NOT EXISTS `lnd_sigef_credor` (
    `id_landing`    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `cdcredor`      VARCHAR(30) NULL,
    `cpf_cnpj`      VARCHAR(30) NULL COMMENT 'ver ctl_lgpd_pendencias',
    `nome_credor`   VARCHAR(255) NULL,
    `payload_raw`   JSON NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_landing`),
    UNIQUE KEY `uq_lnd_sigef_credor_cdcredor` (`cdcredor`),
    KEY `ix_lnd_sigef_credor_cpf` (`cpf_cnpj`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de /sigef/credor/ - de-para cdcredor <-> cpf_cnpj';

CREATE TABLE IF NOT EXISTS `lnd_sigef_execucaofinanceiranl` (
    `id_landing`    BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `numero_nl`     VARCHAR(60) NULL,
    `cdsubacao`     VARCHAR(30) NULL,
    `valor_nl`      DECIMAL(19,2) NULL,
    `valor_pago`    DECIMAL(19,2) NULL,
    `payload_raw`   JSON NULL,
    `id_lote_carga` BIGINT UNSIGNED NOT NULL,
    `dt_carga`      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id_landing`),
    UNIQUE KEY `uq_lnd_sigef_nl_numero` (`numero_nl`),
    KEY `ix_lnd_sigef_nl_subacao` (`cdsubacao`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Landing de /sigef/execucaofinanceiranl/ - verificacao de empenho/liquidacao vs pago';
