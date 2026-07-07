# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: permissions

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela permissions.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **name** | varchar(255) | Nao |  | UK | Nao informado no DDL. |
| **guard_name** | varchar(255) | Nao |  | UK | Nao informado no DDL. |
| **operacao_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **modulo_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| permissions_name_guard_name_unique | UNIQUE | name, guard_name | Garante unicidade dos dados indexados. |
| permissions_operacao_id_foreign | KEY | operacao_id | Acelera filtros e operacoes de juncao. |
| permissions_modulo_id_foreign | KEY | modulo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| permissions_modulo_id_foreign | modulo_id | modulos | id | RESTRICT / RESTRICT |
| permissions_operacao_id_foreign | operacao_id | operacoes | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

