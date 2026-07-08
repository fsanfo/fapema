# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: erro_steps_processo

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela erro_steps_processo.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **erroDadosPessoais** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroInstituicao** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroArea** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroEquipe** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroProjeto** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroEvento** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroOrcamento** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **erroAnexos** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| erro_steps_processo_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| erro_steps_processo_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

