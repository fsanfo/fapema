# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: programas_instituicao_user

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela programas_instituicao_user.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **programa_institucional_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **consultoria_adhoc_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| programas_instituicao_user_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| programas_instituicao_user_programa_institucional_id_foreign | KEY | programa_institucional_id | Acelera filtros e operacoes de juncao. |
| programas_instituicao_user_consultoria_adhoc_id_foreign | KEY | consultoria_adhoc_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| programas_instituicao_user_consultoria_adhoc_id_foreign | consultoria_adhoc_id | consultoria_adhoc | id | RESTRICT / RESTRICT |
| programas_instituicao_user_programa_institucional_id_foreign | programa_institucional_id | programas_instituicao | id | RESTRICT / RESTRICT |
| programas_instituicao_user_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

