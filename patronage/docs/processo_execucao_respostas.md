# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_execucao_respostas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_execucao_respostas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **tipo_operacao** | enum('1','2','3','4','5','6','7') | Sim | NULL |  | 1 - Despesas Bancarias, 2 - Devolver Recurso, \n            3 - Despesas Gerais, 4 - Rendimento da Aplicação, 5 - Receitas Gerais, 6 - Recursos Próprios, 7 - Atualização Monetária |
| **tipo_despesa** | enum('1','2','3','4','5','6','7','8','9','10','11','12','13') | Sim | NULL |  | 1 - Material Consumo, 2 - Diárias no Estado, \n            3 -Diárias fora do Estado, 4 - Aquisição de Componentes ou Peças de Reposição para Equipamentos, 5 - Passagem, 6 - Serviços de Terceiros - Pessoa Física, \n            7 - Serviços de Terceiros - Pessoa Jurídica, 8 - Despesa de Importação (Até o Limite de 18% do Valor do Bem Importado, 9 - Despesas Gerais (CUSTEIO), 10 - Equipamento e Material Permanente\n            11 - Despesas Gerais (CAPITAL), 12 - Saldo Remanescente, 13 - Receita Financeira |
| **data_doc** | date | Sim | NULL |  | Data do Documento |
| **numero_doc** | varchar(50) | Sim | NULL |  | Número do Documento |
| **tipo_doc** | enum('1','2','3','4','5','6') | Sim | NULL |  | 1 - Nota Fiscal, 2 - Cupom Fiscal, \n            3 - Serviço de Pessoa Física, 4 - Serviço de Pessoa Jurídica, 5 - Extrato Bancário (Conta Corrente), 6 - Extrato Aplicação |
| **fornecedor** | char(100) | Sim | NULL |  | Nome do Fornecedor |
| **valor** | double(9,2) | Sim | NULL |  | Valor do Documento |
| **descricao** | text | Sim |  |  | Descrição do Documento |
| **forma_pagamento** | enum('1','2','3','4','5','6') | Sim | NULL |  | 1 - Cheque, 2 - Cartão de Débito, \n            3 - Cartão de Crédito, 4 - PIX, 5 - Transferência, 6 - Em Espécie |
| **comprovante_execucao_path** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **comprovante_execucao_name** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **processo_execucao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_execucao_respostas_processo_execucao_id_foreign | KEY | processo_execucao_id | Acelera filtros e operacoes de juncao. |
| processo_execucao_respostas_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_execucao_respostas_processo_execucao_id_foreign | processo_execucao_id | processo_execucao | id | CASCADE / RESTRICT |
| processo_execucao_respostas_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

