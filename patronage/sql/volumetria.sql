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

-- Infraestrutura para gerar relatório de volumetria das tabelas em um banco de dados MySQL
-- 1. Cria a tabela de histórico
CREATE TABLE historico_volumetria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data_registro DATE NOT NULL,
    nome_tabela VARCHAR(64) NOT NULL,
    tamanho_mb DECIMAL(10,2) NOT NULL,
    total_linhas BIGINT NOT NULL
);

-- 2. Agende para rodar todo mês um INSERT coletando os dados atuais
INSERT INTO historico_volumetria (data_registro, nome_tabela, tamanho_mb, total_linhas)
SELECT 
    CURDATE(), 
    table_name, 
    ROUND(((data_length + index_length) / 1024 / 1024), 2),
    table_rows
FROM information_schema.tables 
WHERE table_schema = 'patronage';