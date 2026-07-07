# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: pulse_aggregates

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela pulse_aggregates.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **bucket** | int unsigned | Nao |  | UK | Nao informado no DDL. |
| **period** | mediumint unsigned | Nao |  | UK | Nao informado no DDL. |
| **type** | varchar(255) | Nao |  | UK | Nao informado no DDL. |
| **key** | mediumtext | Nao |  |  | Nao informado no DDL. |
| **key_hash** | binary(16) | Sim |  | UK | Nao informado no DDL. |
| **aggregate** | varchar(255) | Nao |  | UK | Nao informado no DDL. |
| **value** | decimal(20,2) | Nao |  |  | Nao informado no DDL. |
| **count** | int unsigned | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| pulse_aggregates_bucket_period_type_aggregate_key_hash_unique | UNIQUE | bucket, period, type, aggregate, key_hash | Garante unicidade dos dados indexados. |
| pulse_aggregates_period_bucket_index | KEY | period, bucket | Acelera filtros e operacoes de juncao. |
| pulse_aggregates_type_index | KEY | type | Acelera filtros e operacoes de juncao. |
| pulse_aggregates_period_type_aggregate_bucket_index | KEY | period, type, aggregate, bucket | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | Nenhuma chave estrangeira declarada. |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

