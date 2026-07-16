-- ============================================================================
-- patronage_analytics | Script 10 - Reconciliacao SIGEF x Patronage
-- Fase 2: ETL / Reconciliacao
--
-- Ordem de dependencia: script 07 (landing, incl. lnd_sigef_*) e script 08/09
-- (dimensoes e fatos) devem ter rodado antes.
-- ============================================================================

USE `patronage_analytics`;

DELIMITER $$

-- ----------------------------------------------------------------------------
-- sp_bootstrap_ponte_proponente_credor_sigef
--
-- Tenta casar automaticamente dim_usuario.documento (CPF/CNPJ) com o
-- cpf_cnpj/cdcredor observado em lnd_sigef_credor. So insere quando o CPF tem
-- correspondencia UNICA e nao ambigua (1 documento -> 1 cdcredor); casos
-- ambiguos (mesmo CPF associado a mais de um cdcredor) NAO sao inseridos
-- aqui - ficam para curadoria manual (fora do escopo automatizavel).
-- confiabilidade='alta' por ser casamento exato de documento e unico.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_bootstrap_ponte_proponente_credor_sigef`$$
CREATE PROCEDURE `sp_bootstrap_ponte_proponente_credor_sigef` ()
BEGIN
    INSERT INTO ponte_proponente_credor_sigef
        (sk_usuario, cpf_cnpj, cdcredor_sigef, dt_vigencia_inicio, confiabilidade, flag_ativo)
    SELECT
        du.sk_usuario, du.documento, cand.cdcredor, CURDATE(), 'alta', 1
    FROM dim_usuario du
    JOIN (
        SELECT cpf_cnpj, MIN(cdcredor) AS cdcredor, COUNT(DISTINCT cdcredor) AS qtd_credores
        FROM lnd_sigef_credor
        WHERE cpf_cnpj IS NOT NULL
        GROUP BY cpf_cnpj
        HAVING COUNT(DISTINCT cdcredor) = 1
    ) cand ON cand.cpf_cnpj = du.documento
    LEFT JOIN ponte_proponente_credor_sigef existente
        ON existente.sk_usuario = du.sk_usuario AND existente.flag_ativo = 1
    WHERE existente.sk_ponte IS NULL;
END$$

-- ----------------------------------------------------------------------------
-- sp_sugerir_ponte_edital_subacao
--
-- O vinculo Edital <-> Subacao/Processo SIGEF exige validacao de um
-- responsavel funcional (mitigacao de risco do addendum tecnico - a coluna
-- responsavel_funcional e NOT NULL por design). Esta procedure apenas
-- SUGERE candidatos com base no cruzamento textual de
-- edital_dados_financeiro.sub_acao (Patronage) com subacoes.numero (Landing),
-- inserindo-os com confiabilidade='baixa' e responsavel_funcional marcado
-- como pendente - a curadoria (fora do MySQL) deve revisar e atualizar
-- responsavel_funcional/confiabilidade antes de a ponte ser usada com
-- confianca 'alta'/'media' na reconciliacao.
--
-- [ASSUNCAO DE NEGOCIO - PENDENTE DE CONFIRMACAO] edital_dados_financeiro.sub_acao
-- e tratado aqui como referencia numerica a subacoes.id (nao ha FK declarada
-- no DDL de origem - mais um reflexo do GAP do xlsx de descricoes vazio,
-- Fase 1). Por isso o vinculo sai com confiabilidade='baixa' por padrao.
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_sugerir_ponte_edital_subacao`$$
CREATE PROCEDURE `sp_sugerir_ponte_edital_subacao` ()
BEGIN
    INSERT INTO ponte_edital_sigef_subacao
        (sk_edital, sk_subacao, dt_vigencia_inicio, responsavel_funcional, confiabilidade, flag_ativo)
    SELECT DISTINCT
        de.sk_edital, dsa.sk_subacao, CURDATE(),
        '(PENDENTE_VALIDACAO_CURADORIA)', 'baixa', 1
    FROM lnd_patronage_edital_dados_financeiro edf
    JOIN dim_edital de ON de.id_edital_origem = edf.edital_id
    JOIN lnd_patronage_subacoes sa ON sa.id_origem = edf.sub_acao
    JOIN dim_subacao dsa ON dsa.id_subacao_origem = sa.id_origem
    LEFT JOIN ponte_edital_sigef_subacao existente
        ON existente.sk_edital = de.sk_edital AND existente.sk_subacao = dsa.sk_subacao AND existente.flag_ativo = 1
    WHERE existente.sk_ponte IS NULL;
END$$

-- ----------------------------------------------------------------------------
-- sp_reconciliar_sigef_patronage
--
-- Grao: Edital + Proponente + competencia (ano_mes). So gera linha no fato
-- central quando ha ponte com confiabilidade 'alta' ou 'media' em AMBOS os
-- lados (edital<->subacao e proponente<->credor). Casos sem correspondencia
-- confiavel vao para exc_reconciliacao_sigef_patronage (FR-4 do PRD - Fase 1).
-- ----------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS `sp_reconciliar_sigef_patronage`$$
CREATE PROCEDURE `sp_reconciliar_sigef_patronage` (IN p_id_lote BIGINT UNSIGNED, IN p_ano_mes INT UNSIGNED)
BEGIN
    DROP TEMPORARY TABLE IF EXISTS tmp_patronage_lado;
    DROP TEMPORARY TABLE IF EXISTS tmp_sigef_lado;

    -- lado Patronage: agregado por edital+proponente+competencia
    CREATE TEMPORARY TABLE tmp_patronage_lado AS
    SELECT sk_edital, sk_proponente, ano_mes_vencimento AS ano_mes,
           SUM(valor_pago) AS valor_patronage,
           MAX(sk_situacao_pagamento) AS sk_situacao_pagamento
    FROM fato_financeiro_patronage
    WHERE ano_mes_vencimento = p_ano_mes AND sk_edital IS NOT NULL AND sk_proponente IS NOT NULL
    GROUP BY sk_edital, sk_proponente, ano_mes_vencimento;

    -- lado SIGEF: resolve subacao->edital (ponte confiavel) e credor->proponente (ponte confiavel)
    CREATE TEMPORARY TABLE tmp_sigef_lado AS
    SELECT pes.sk_edital, ppc.sk_usuario AS sk_proponente,
           YEAR(fs.dt_pagamento) * 100 + MONTH(fs.dt_pagamento) AS ano_mes,
           SUM(fs.valor_total) AS valor_sigef,
           MAX(fs.cd_situacao_ordem_bancaria) AS cd_situacao_ordem_bancaria
    FROM fato_financeiro_sigef fs
    JOIN ponte_edital_sigef_subacao pes ON pes.sk_subacao = fs.sk_subacao
        AND pes.flag_ativo = 1 AND pes.confiabilidade IN ('alta','media')
    JOIN ponte_proponente_credor_sigef ppc ON ppc.cdcredor_sigef = fs.cdcredor
        AND ppc.flag_ativo = 1 AND ppc.confiabilidade IN ('alta','media')
    WHERE YEAR(fs.dt_pagamento) * 100 + MONTH(fs.dt_pagamento) = p_ano_mes
    GROUP BY pes.sk_edital, ppc.sk_usuario, ano_mes;

    -- consolidado: full outer join emulado via UNION de LEFT JOINs.
    -- IMPORTANTE: so entra aqui quem tem ponte confiavel para edital E
    -- proponente (subquery de filtro abaixo) - sem isso, nao ha como
    -- afirmar com confianca "ausencia_sigef"; esses casos vao SOMENTE para
    -- a fila de excecao (ver INSERT seguinte), nunca para os dois lugares.
    INSERT INTO fato_reconciliacao_sigef_patronage
        (sk_edital, sk_proponente, ano_mes_competencia, valor_patronage, valor_sigef,
         diferenca_valor, status_patronage, status_sigef, flag_divergencia, tipo_divergencia, id_lote_carga)
    SELECT
        COALESCE(p.sk_edital, s.sk_edital), COALESCE(p.sk_proponente, s.sk_proponente), p_ano_mes,
        COALESCE(p.valor_patronage, 0), COALESCE(s.valor_sigef, 0),
        COALESCE(p.valor_patronage, 0) - COALESCE(s.valor_sigef, 0),
        (SELECT descricao FROM dim_situacao WHERE sk_situacao = p.sk_situacao_pagamento),
        s.cd_situacao_ordem_bancaria,
        CASE WHEN p.sk_edital IS NULL OR s.sk_edital IS NULL THEN 1
             WHEN COALESCE(p.valor_patronage,0) <> COALESCE(s.valor_sigef,0) THEN 1
             ELSE 0 END,
        CASE
            WHEN p.sk_edital IS NULL THEN 'ausencia_patronage'
            WHEN s.sk_edital IS NULL THEN 'ausencia_sigef'
            WHEN COALESCE(p.valor_patronage,0) <> COALESCE(s.valor_sigef,0) THEN 'diferenca_valor'
            ELSE 'ok'
        END,
        p_id_lote
    FROM tmp_patronage_lado p
    LEFT JOIN tmp_sigef_lado s ON s.sk_edital = p.sk_edital AND s.sk_proponente = p.sk_proponente
    WHERE EXISTS (
        SELECT 1 FROM ponte_edital_sigef_subacao pes
        WHERE pes.sk_edital = p.sk_edital AND pes.flag_ativo = 1 AND pes.confiabilidade IN ('alta','media')
    ) AND EXISTS (
        SELECT 1 FROM ponte_proponente_credor_sigef ppc
        WHERE ppc.sk_usuario = p.sk_proponente AND ppc.flag_ativo = 1 AND ppc.confiabilidade IN ('alta','media')
    )
    UNION ALL
    SELECT
        s.sk_edital, s.sk_proponente, p_ano_mes, 0, s.valor_sigef, 0 - s.valor_sigef,
        NULL, s.cd_situacao_ordem_bancaria, 1, 'ausencia_patronage', p_id_lote
    FROM tmp_sigef_lado s
    LEFT JOIN tmp_patronage_lado p ON p.sk_edital = s.sk_edital AND p.sk_proponente = s.sk_proponente
    WHERE p.sk_edital IS NULL
    ON DUPLICATE KEY UPDATE
        valor_patronage = VALUES(valor_patronage), valor_sigef = VALUES(valor_sigef),
        diferenca_valor = VALUES(diferenca_valor), status_patronage = VALUES(status_patronage),
        status_sigef = VALUES(status_sigef), flag_divergencia = VALUES(flag_divergencia),
        tipo_divergencia = VALUES(tipo_divergencia), dt_conciliacao = CURRENT_TIMESTAMP;

    -- fila de excecao: pagamentos Patronage no periodo cujo proponente OU
    -- edital NAO possui ponte confiavel - mutuamente exclusivo com o
    -- consolidado acima (mesma condicao, negada).
    INSERT INTO exc_reconciliacao_sigef_patronage
        (id_lote_carga, tipo_excecao, sk_edital, sk_proponente, ano_mes_competencia,
         valor_patronage, status_patronage)
    SELECT
        p_id_lote, 'chave_ambigua_ponte', p.sk_edital, p.sk_proponente, p_ano_mes,
        p.valor_patronage, (SELECT descricao FROM dim_situacao WHERE sk_situacao = p.sk_situacao_pagamento)
    FROM tmp_patronage_lado p
    WHERE NOT EXISTS (
        SELECT 1 FROM ponte_edital_sigef_subacao pes
        WHERE pes.sk_edital = p.sk_edital AND pes.flag_ativo = 1 AND pes.confiabilidade IN ('alta','media')
    ) OR NOT EXISTS (
        SELECT 1 FROM ponte_proponente_credor_sigef ppc
        WHERE ppc.sk_usuario = p.sk_proponente AND ppc.flag_ativo = 1 AND ppc.confiabilidade IN ('alta','media')
    );

    DROP TEMPORARY TABLE IF EXISTS tmp_patronage_lado;
    DROP TEMPORARY TABLE IF EXISTS tmp_sigef_lado;

    INSERT INTO ctl_log_execucao (id_lote, etapa, nivel, mensagem)
    VALUES (p_id_lote, 'sp_reconciliar_sigef_patronage',
            'info', CONCAT('Competencia processada: ', p_ano_mes));
END$$

DELIMITER ;
