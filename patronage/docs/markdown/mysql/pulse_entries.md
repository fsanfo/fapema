# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: pulse_entries

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela pulse_entries.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **timestamp** | int unsigned | Nao |  |  | Nao informado no DDL. |
| **type** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **key** | mediumtext | Nao |  |  | Nao informado no DDL. |
| **key_hash** | binary(16) | Sim |  |  | Nao informado no DDL. |
| **value** | bigint | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| pulse_entries_timestamp_index | KEY | timestamp | Acelera filtros e operacoes de juncao. |
| pulse_entries_type_index | KEY | type | Acelera filtros e operacoes de juncao. |
| pulse_entries_key_hash_index | KEY | key_hash | Acelera filtros e operacoes de juncao. |
| pulse_entries_timestamp_type_key_hash_value_index | KEY | timestamp, type, key_hash, value | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | Nenhuma chave estrangeira declarada. |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

