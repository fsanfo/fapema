# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: recurso_instrucao

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela recurso_instrucao.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **instrucao** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **aprovado** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **recurso_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| recurso_instrucao_recurso_id_foreign | KEY | recurso_id | Acelera filtros e operacoes de juncao. |
| recurso_instrucao_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| recurso_instrucao_recurso_id_foreign | recurso_id | recursos | id | CASCADE / RESTRICT |
| recurso_instrucao_user_id_foreign | user_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

