-- Código SQL bara gerar batch de ANALYZE TABLE para todas as tabelas de um banco de dados MySQL
SELECT 
    CONCAT('ANALYZE TABLE `', TABLE_SCHEMA, '`.`', TABLE_NAME, '`;') AS script_analyze
FROM 
    information_schema.TABLES 
WHERE 
    TABLE_SCHEMA = 'patronage' 
    AND TABLE_TYPE = 'BASE TABLE';

-- Cálculo de volumetria das tabelas em um banco de dados MySQL
SELECT 
    TABLE_NAME AS 'Tabela',
    TABLE_ROWS AS 'Total de Linhas',
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Tamanho Total (MB)',
    ROUND((DATA_LENGTH / 1024 / 1024), 2) AS 'Dados (MB)',
    ROUND((INDEX_LENGTH / 1024 / 1024), 2) AS 'Índices (MB)',
    DATA_FREE AS 'Espaço Livre (Bytes)'
FROM 
    information_schema.TABLES
WHERE 
    TABLE_SCHEMA = 'patronage'
ORDER BY 
    (DATA_LENGTH + INDEX_LENGTH) DESC;