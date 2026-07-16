-- ============================================================================
-- patronage_analytics | Script 08 - Procedures de Povoamento das Dimensoes
-- Fase 2: ETL / Reconciliacao
--
-- Todas as procedures sao idempotentes (INSERT ... ON DUPLICATE KEY UPDATE ou
-- INSERT IGNORE contra a chave natural/unique da dimensao) e devem ser
-- chamadas SOMENTE apos a carga da Landing correspondente (script 07).
-- ============================================================================

USE `patronage_analytics`;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- sp_povoar_dim_tempo: gera/estende a dimensao de tempo. Idempotente - so
-- insere datas ainda nao existentes. Chamar uma vez no setup e depois apenas
-- quando for necessario estender o horizonte (ex.: virada de ano).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_povoar_dim_tempo`$$
CREATE PROCEDURE `sp_povoar_dim_tempo` (IN p_data_inicio DATE, IN p_data_fim DATE)
BEGIN
    DECLARE v_data DATE;
    SET v_data = p_data_inicio;

    WHILE v_data <= p_data_fim DO
        INSERT IGNORE INTO dim_tempo
            (dt_referencia, ano, trimestre, semestre, mes, nome_mes, dia,
             dia_semana, nome_dia_semana, semana_ano, ano_mes, flag_dia_util)
        VALUES (
            v_data,
            YEAR(v_data),
            QUARTER(v_data),
            IF(MONTH(v_data) <= 6, 1, 2),
            MONTH(v_data),
            ELT(MONTH(v_data), 'Janeiro','Fevereiro','Marco','Abril','Maio','Junho',
                                'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'),
            DAY(v_data),
            DAYOFWEEK(v_data),
            ELT(DAYOFWEEK(v_data), 'Domingo','Segunda-feira','Terca-feira','Quarta-feira',
                                    'Quinta-feira','Sexta-feira','Sabado'),
            WEEK(v_data, 3),
            YEAR(v_data) * 100 + MONTH(v_data),
            IF(DAYOFWEEK(v_data) IN (1,7), 0, 1)
        );
        SET v_data = DATE_ADD(v_data, INTERVAL 1 DAY);
    END WHILE;
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_modalidade
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_modalidade`$$
CREATE PROCEDURE `sp_carga_dim_modalidade` ()
BEGIN
    INSERT INTO dim_modalidade (id_modalidade_origem, sigla, nome, tipo, status, sub_programa_id)
    SELECT id_origem, sigla, nome, tipo, status, sub_programa_id
    FROM lnd_patronage_modalidades src
    ON DUPLICATE KEY UPDATE
        sigla = VALUES(sigla), nome = VALUES(nome), tipo = VALUES(tipo),
        status = VALUES(status), sub_programa_id = VALUES(sub_programa_id);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_setor
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_setor`$$
CREATE PROCEDURE `sp_carga_dim_setor` ()
BEGIN
    INSERT INTO dim_setor (id_setor_origem, nome, email, flag_responsavel_edital)
    SELECT id_origem, nome, email, edital
    FROM lnd_patronage_setores src
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome), email = VALUES(email), flag_responsavel_edital = VALUES(flag_responsavel_edital);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_fonte_pagadora
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_fonte_pagadora`$$
CREATE PROCEDURE `sp_carga_dim_fonte_pagadora` ()
BEGIN
    INSERT INTO dim_fonte_pagadora (id_fonte_origem, nome, numero, natureza, tipo)
    SELECT id_origem, nome, numero, natureza, tipo
    FROM lnd_patronage_fonte_pagadoras src
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome), numero = VALUES(numero), natureza = VALUES(natureza), tipo = VALUES(tipo);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_subacao
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_subacao`$$
CREATE PROCEDURE `sp_carga_dim_subacao` ()
BEGIN
    INSERT INTO dim_subacao (id_subacao_origem, nome, numero, flag_ativa, acao_id_origem)
    SELECT id_origem, nome, numero, ativa, acao_id
    FROM lnd_patronage_subacoes src
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome), numero = VALUES(numero), flag_ativa = VALUES(flag_ativa), acao_id_origem = VALUES(acao_id_origem);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_instituicao
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_instituicao`$$
CREATE PROCEDURE `sp_carga_dim_instituicao` ()
BEGIN
    INSERT INTO dim_instituicao (id_instituicao_origem, sigla, nome, cnpj, flag_ativo, modalidade, tipo)
    SELECT id_origem, sigla, nome, cnpj, ativo, modalidade, tipo
    FROM lnd_patronage_instituicoes src
    ON DUPLICATE KEY UPDATE
        sigla = VALUES(sigla), nome = VALUES(nome), cnpj = VALUES(cnpj),
        flag_ativo = VALUES(flag_ativo), modalidade = VALUES(modalidade), tipo = VALUES(tipo);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_usuario: consolida users + user_infos (role-playing dimension,
-- ver 01_modelo_dimensional.md). CPF/dados sensiveis em texto claro por
-- decisao registrada em ctl_lgpd_pendencias.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_usuario`$$
CREATE PROCEDURE `sp_carga_dim_usuario` ()
BEGIN
    INSERT INTO dim_usuario (
        id_user_origem, nome, social_name, tipo_documento, documento, email, membro_comite,
        data_nascimento, sexo, etnia, deficiencia_fisica, nacionalidade, telefone, celular1,
        banco_id, agencia, conta, flag_ativo
    )
    SELECT
        u.id_origem, u.name, u.social_name, u.tipo_documento, u.documento, u.email, u.membro_comite,
        i.data_nascimento, i.sexo, i.etnia, i.deficiencia_fisica, i.nacionalidade, i.telefone, i.celular1,
        i.banco_id, i.agencia, i.conta,
        IF(u.deleted_at_origem IS NULL, 1, 0)
    FROM lnd_patronage_users u
    LEFT JOIN lnd_patronage_user_infos i ON i.user_id = u.id_origem
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome), social_name = VALUES(social_name), tipo_documento = VALUES(tipo_documento),
        documento = VALUES(documento), email = VALUES(email), membro_comite = VALUES(membro_comite),
        data_nascimento = VALUES(data_nascimento), sexo = VALUES(sexo), etnia = VALUES(etnia),
        deficiencia_fisica = VALUES(deficiencia_fisica), nacionalidade = VALUES(nacionalidade),
        telefone = VALUES(telefone), celular1 = VALUES(celular1), banco_id = VALUES(banco_id),
        agencia = VALUES(agencia), conta = VALUES(conta), flag_ativo = VALUES(flag_ativo);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_edital: depende de dim_modalidade e dim_setor ja carregadas
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_edital`$$
CREATE PROCEDURE `sp_carga_dim_edital` ()
BEGIN
    INSERT INTO dim_edital (
        id_edital_origem, nome, ano, numero, tipo, caracteristica, personalidade_juridica,
        uso, quota, sk_modalidade, sk_setor, edital_pai_id_origem, flag_ativo,
        dt_criacao_origem, dt_atualizacao_origem
    )
    SELECT
        e.id_origem, e.nome, e.ano, e.numero, e.tipo, e.caracteristica, e.personalidade_juridica,
        e.uso, e.quota, dm.sk_modalidade, ds.sk_setor, e.edital_pai_id,
        IF(e.acesso_restrito = 1, 0, 1),
        e.created_at_origem, e.updated_at_origem
    FROM lnd_patronage_editais e
    LEFT JOIN dim_modalidade dm ON dm.id_modalidade_origem = e.modalidade_id
    LEFT JOIN dim_setor ds ON ds.id_setor_origem = e.setor_id
    ON DUPLICATE KEY UPDATE
        nome = VALUES(nome), ano = VALUES(ano), numero = VALUES(numero), tipo = VALUES(tipo),
        caracteristica = VALUES(caracteristica), personalidade_juridica = VALUES(personalidade_juridica),
        uso = VALUES(uso), quota = VALUES(quota), sk_modalidade = VALUES(sk_modalidade),
        sk_setor = VALUES(sk_setor), edital_pai_id_origem = VALUES(edital_pai_id_origem),
        flag_ativo = VALUES(flag_ativo), dt_atualizacao_origem = VALUES(dt_atualizacao_origem);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_chamada: depende de dim_edital ja carregada
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_chamada`$$
CREATE PROCEDURE `sp_carga_dim_chamada` ()
BEGIN
    INSERT INTO dim_chamada (
        id_chamada_origem, sk_edital, numero, grupo, nome, dt_inicio, dt_fim,
        flag_publicada, dt_recurso_inicio, dt_recurso_fim
    )
    SELECT
        c.id_origem, de.sk_edital, c.numero, c.grupo, c.nome,
        DATE(c.inicio), DATE(c.fim), c.publicada, DATE(c.recurso_inicio), DATE(c.recurso_fim)
    FROM lnd_patronage_edital_chamadas c
    JOIN dim_edital de ON de.id_edital_origem = c.edital_id
    ON DUPLICATE KEY UPDATE
        sk_edital = VALUES(sk_edital), numero = VALUES(numero), grupo = VALUES(grupo), nome = VALUES(nome),
        dt_inicio = VALUES(dt_inicio), dt_fim = VALUES(dt_fim), flag_publicada = VALUES(flag_publicada),
        dt_recurso_inicio = VALUES(dt_recurso_inicio), dt_recurso_fim = VALUES(dt_recurso_fim);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_convenio: depende de dim_usuario (gestor) ja carregada
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_convenio`$$
CREATE PROCEDURE `sp_carga_dim_convenio` ()
BEGIN
    INSERT INTO dim_convenio (
        id_convenio_origem, numero, ano, nome, tipo, dt_assinatura, dt_vigencia_inicial,
        dt_vigencia_final, dt_relatorio_parcial, dt_relatorio_final, dt_prestacao_inicial,
        dt_prestacao_final, sk_gestor
    )
    SELECT
        c.id_origem, c.numero, c.ano, c.nome, c.tipo, c.assinatura, c.vigencia_inicial,
        c.vigencia_final, c.relatorio_parcial, c.relatorio_final, c.prestacao_inicial,
        c.prestacao_final, du.sk_usuario
    FROM lnd_patronage_convenios c
    LEFT JOIN lnd_patronage_gestores g ON g.id_origem = c.gestor_id
    LEFT JOIN dim_usuario du ON du.id_user_origem = g.user_id
    ON DUPLICATE KEY UPDATE
        numero = VALUES(numero), ano = VALUES(ano), nome = VALUES(nome), tipo = VALUES(tipo),
        dt_assinatura = VALUES(dt_assinatura), dt_vigencia_inicial = VALUES(dt_vigencia_inicial),
        dt_vigencia_final = VALUES(dt_vigencia_final), dt_relatorio_parcial = VALUES(dt_relatorio_parcial),
        dt_relatorio_final = VALUES(dt_relatorio_final), dt_prestacao_inicial = VALUES(dt_prestacao_inicial),
        dt_prestacao_final = VALUES(dt_prestacao_final), sk_gestor = VALUES(sk_gestor);
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dim_situacao: dimensao conformada generica de status. Popula a
-- partir dos codigos DISTINTOS observados na Landing. Descricoes conhecidas
-- (documentadas em COMMENT no DDL original) sao mapeadas explicitamente;
-- codigos sem definicao de negocio confirmada recebem um rotulo de pendencia
-- (ver GAP do xlsx de descricoes vazio, registrado em 00_blueprint_arquitetura.md).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dim_situacao`$$
CREATE PROCEDURE `sp_carga_dim_situacao` ()
BEGIN
    -- dominio: pagamento (termo_parcelas_pagas.situacao_pagamento) - enum documentado no DDL
    INSERT IGNORE INTO dim_situacao (dominio_origem, codigo_origem, descricao)
    SELECT DISTINCT 'pagamento', situacao_pagamento,
        CASE situacao_pagamento
            WHEN '1' THEN 'Pago'
            WHEN '2' THEN 'Pago parcialmente'
            WHEN '3' THEN 'Nao pago'
            ELSE CONCAT('(pendente de definicao de negocio - codigo ', situacao_pagamento, ')')
        END
    FROM lnd_patronage_termo_parcelas_pagas
    WHERE situacao_pagamento IS NOT NULL;

    -- dominio: chamada_publicacao (edital_chamadas.publicada) - enum documentado no DDL
    INSERT IGNORE INTO dim_situacao (dominio_origem, codigo_origem, descricao)
    SELECT DISTINCT 'chamada_publicacao', publicada,
        CASE publicada WHEN 0 THEN 'Nao publicada' WHEN 1 THEN 'Publicada'
             ELSE CONCAT('(pendente de definicao de negocio - codigo ', publicada, ')') END
    FROM lnd_patronage_edital_chamadas
    WHERE publicada IS NOT NULL;

    -- dominio: processo (processos.situacao) - SOMENTE o codigo 0 e documentado no DDL
    -- ("nao enviado"); demais codigos ficam com rotulo de pendencia ate confirmacao
    -- de negocio (xlsx de descricoes oficial nao foi preenchido - ver GAP na Fase 1).
    INSERT IGNORE INTO dim_situacao (dominio_origem, codigo_origem, descricao)
    SELECT DISTINCT 'processo', situacao,
        CASE situacao WHEN 0 THEN 'Nao enviado'
             ELSE CONCAT('(pendente de definicao de negocio - codigo ', situacao, ')') END
    FROM lnd_patronage_processos
    WHERE situacao IS NOT NULL;

    -- dominio: termo (termos.status) - sem enum documentado no DDL de origem
    INSERT IGNORE INTO dim_situacao (dominio_origem, codigo_origem, descricao)
    SELECT DISTINCT 'termo', status,
        CONCAT('(pendente de definicao de negocio - codigo ', status, ')')
    FROM lnd_patronage_termos
    WHERE status IS NOT NULL;

    -- dominio: convenio_relatorio (derivado - flag binaria de entrega do relatorio final)
    INSERT IGNORE INTO dim_situacao (dominio_origem, codigo_origem, descricao) VALUES
        ('convenio_relatorio', '0', 'Relatorio final pendente de entrega'),
        ('convenio_relatorio', '1', 'Relatorio final entregue');
END$$

-- ----------------------------------------------------------------------------
-- sp_carga_dimensoes: orquestra a carga de todas as dimensoes na ordem de
-- dependencia correta (chamada pela orquestracao mestra do script 13).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_carga_dimensoes`$$
CREATE PROCEDURE `sp_carga_dimensoes` (IN p_id_lote BIGINT UNSIGNED)
BEGIN
    CALL sp_carga_dim_modalidade();
    CALL sp_carga_dim_setor();
    CALL sp_carga_dim_fonte_pagadora();
    CALL sp_carga_dim_subacao();
    CALL sp_carga_dim_instituicao();
    CALL sp_carga_dim_usuario();
    CALL sp_carga_dim_situacao();
    CALL sp_carga_dim_edital();       -- depende de dim_modalidade, dim_setor
    CALL sp_carga_dim_chamada();      -- depende de dim_edital
    CALL sp_carga_dim_convenio();     -- depende de dim_usuario

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_carga_dimensoes', 'info', 'Dimensoes atualizadas com sucesso');
END$$

DELIMITER ;
