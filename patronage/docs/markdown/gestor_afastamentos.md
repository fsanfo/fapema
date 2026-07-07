# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: gestor_afastamentos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela gestor_afastamentos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **gestor_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **tipo** | tinyint unsigned | Nao | '1' |  | Nao informado no DDL. |
| **data_inicio** | date | Nao |  |  | Nao informado no DDL. |
| **data_fim** | date | Nao |  |  | Nao informado no DDL. |
| **substituto_user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| gestor_afastamentos_gestor_id_foreign | KEY | gestor_id | Acelera filtros e operacoes de juncao. |
| gestor_afastamentos_substituto_user_id_foreign | KEY | substituto_user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| gestor_afastamentos_gestor_id_foreign | gestor_id | gestores | id | CASCADE / RESTRICT |
| gestor_afastamentos_substituto_user_id_foreign | substituto_user_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

