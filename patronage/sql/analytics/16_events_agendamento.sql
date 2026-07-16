-- ============================================================================
-- patronage_analytics | Script 16 - Agendamento (MySQL Events)
-- Fase 3: Views, Materializadas, Agendamento e Documentacao Final
--
-- PRE-REQUISITO OPERACIONAL: o Event Scheduler e um recurso GLOBAL do
-- servidor MySQL (nao por schema) e requer privilegio SUPER ou
-- SYSTEM_VARIABLES_ADMIN para ser habilitado. Rodar UMA VEZ, como DBA,
-- ANTES de executar este script (testado neste ambiente: o proprio
-- CREATE/DROP EVENT falha com erro 1577 se o scheduler estiver desligado
-- no momento da implantacao, mesmo que va ser ligado depois):
--
--     SET GLOBAL event_scheduler = ON;
--
-- Sem isso, o script inteiro falha ja no DROP EVENT IF EXISTS. Adicionar
-- `event_scheduler = ON` ao my.cnf para que sobreviva a reinicializacoes do
-- servidor (recomendado no ambiente on-premises de producao) - do contrario
-- a variavel global volta para OFF a cada restart do mysqld e os eventos
-- ficam registrados porem inertes.
--
-- JANELA D+1: dados disponiveis ate 08:00 (premissa tecnica obrigatoria).
-- Sequencia adotada:
--     05:00 -> client SIGEF (script 12, fora do MySQL - agendado via cron/
--              systemd timer, FORA do escopo do Event Scheduler)
--     05:20 -> ev_carga_d1        (Landing Patronage -> Fatos -> Reconciliacao -> DQ)
--     06:30 -> ev_refresh_marts_d1 (materializadas - roda depois para garantir
--              que a carga principal, mais demorada, ja terminou)
-- Ambos os horarios tem folga generosa dentro da janela 05:00-07:00 e podem
-- ser ajustados conforme o tempo real de execucao observado em producao.
-- ============================================================================

USE `patronage_analytics`;

-- Necessario apenas nesta sessao para o CREATE EVENT nao falhar caso o
-- scheduler global esteja desligado no momento da implantacao do script
-- (o evento e criado mesmo assim - so nao executa ate o scheduler ser ligado).

DELIMITER $$

DROP EVENT IF EXISTS `ev_carga_d1`$$
CREATE EVENT `ev_carga_d1`
ON SCHEDULE EVERY 1 DAY STARTS (TIMESTAMP(CURDATE(), '05:20:00') + INTERVAL 1 DAY)
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Executa a carga incremental D+1 (Landing -> Dimensoes -> Fatos -> Pontes -> Reconciliacao -> DQ)'
DO
BEGIN
    CALL sp_executar_carga_d1('incremental');
END$$

DROP EVENT IF EXISTS `ev_refresh_marts_d1`$$
CREATE EVENT `ev_refresh_marts_d1`
ON SCHEDULE EVERY 1 DAY STARTS (TIMESTAMP(CURDATE(), '06:30:00') + INTERVAL 1 DAY)
ON COMPLETION PRESERVE
ENABLE
COMMENT 'Executa o refresh das tabelas materializadas apos a carga D+1'
DO
BEGIN
    CALL sp_refresh_marts_d1();
END$$

DELIMITER ;

-- ----------------------------------------------------------------------------
-- Consultas de monitoramento do agendamento (uso operacional)
-- ----------------------------------------------------------------------------
-- Verificar se o scheduler global esta ligado:
--   SHOW VARIABLES LIKE 'event_scheduler';
-- Verificar os eventos cadastrados e proxima execucao:
--   SELECT event_name, status, last_executed, event_definition
--   FROM information_schema.events WHERE event_schema = 'patronage_analytics';
-- Acompanhar o resultado da ultima execucao do lote:
--   SELECT * FROM ctl_lote_carga ORDER BY id_lote DESC LIMIT 5;
--   SELECT * FROM ctl_log_execucao ORDER BY id_log DESC LIMIT 20;
--   SELECT * FROM ctl_mv_refresh;
