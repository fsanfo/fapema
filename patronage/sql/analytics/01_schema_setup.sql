-- ============================================================================
-- patronage_analytics | Script 01 - Criacao de schema e convencoes
-- Fase 1: Modelagem e Schema Base
-- MySQL 8.0.34 | Idempotente | Nao altera nem move dados do schema `patronage`
-- ============================================================================

CREATE SCHEMA IF NOT EXISTS `patronage_analytics`
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE `patronage_analytics`;

-- ----------------------------------------------------------------------------
-- Convencao de nomenclatura (documentada em 00_blueprint_arquitetura.md):
--   lnd_   -> Landing (copia rasa de origem, Patronage ou SIGEF)
--   dim_   -> Dimensao conformada
--   fato_  -> Fato
--   ponte_ -> Tabela ponte (bridge) de reconciliacao
--   exc_   -> Fila de excecao auditavel
--   ctl_   -> Controle, auditoria, watermark, qualidade de dados
--   mv_    -> Snapshot/agregacao (equivalente a materialized view) - Fase 3
--   vw_    -> View semantica de consumo - Fase 3
--
-- Toda tabela dimensional/fato usa sk_* (surrogate key, bigint unsigned
-- AUTO_INCREMENT) como chave tecnica e preserva id_..._origem como chave
-- natural de origem, usada nas procedures de carga (Fase 2) para
-- INSERT ... ON DUPLICATE KEY UPDATE (idempotencia).
-- ----------------------------------------------------------------------------

-- Usuario/role dedicado de aplicacao para o schema analitico pode ser criado
-- pela equipe de TI conforme politica de acesso institucional. Nao criado
-- automaticamente neste script por depender de decisao de governanca de
-- acesso (fora do escopo tecnico desta fase).

SELECT
    'patronage_analytics' AS schema_criado,
    @@version AS versao_mysql,
    NOW() AS dt_execucao;
