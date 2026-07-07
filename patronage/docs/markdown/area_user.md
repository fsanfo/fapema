# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: area_user

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela area_user.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **area_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **sub_area_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| area_user_area_id_foreign | KEY | area_id | Acelera filtros e operacoes de juncao. |
| area_user_sub_area_id_foreign | KEY | sub_area_id | Acelera filtros e operacoes de juncao. |
| area_user_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| area_user_areas_id_forein | area_id | areas | id | RESTRICT / RESTRICT |
| area_user_sub_areas_id_forein | sub_area_id | sub_areas | id | RESTRICT / RESTRICT |
| area_user_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

