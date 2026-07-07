# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: enquadramentos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela enquadramentos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **enquadramento** | enum('D','E','P') | Sim | NULL |  | D = desenquadramento; E = enquadramento, P = Com pendência |
| **justificativa** | text | Sim |  |  | Justificativa |
| **ponto_curriculo** | double(8,2) | Sim | NULL |  | Pontos do curriculo quando hover |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| enquadramentos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| enquadramentos_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| enquadramentos_processo_id_foreign | processo_id | processos | id | RESTRICT / RESTRICT |
| enquadramentos_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

