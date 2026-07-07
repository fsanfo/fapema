# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: activity_log

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela activity_log.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **log_name** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **description** | text | Nao |  |  | Nao informado no DDL. |
| **subject_type** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **event** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **subject_id** | bigint unsigned | Sim | NULL |  | Nao informado no DDL. |
| **causer_type** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **causer_id** | bigint unsigned | Sim | NULL |  | Nao informado no DDL. |
| **properties** | json | Sim | NULL |  | Nao informado no DDL. |
| **batch_uuid** | char(36) | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| subject | KEY | subject_type, subject_id | Acelera filtros e operacoes de juncao. |
| causer | KEY | causer_type, causer_id | Acelera filtros e operacoes de juncao. |
| activity_log_log_name_index | KEY | log_name | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | Nenhuma chave estrangeira declarada. |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

