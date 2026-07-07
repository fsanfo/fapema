# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: cancelamentos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela cancelamentos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **tipo_solicitante** | varchar(20) | Nao | 'bolsista' |  | bolsista ou orientador |
| **user_solicitante_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **motivo_cancelamento_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **outros_motivos** | text | Sim |  |  | Nao informado no DDL. |
| **status** | int | Nao | '0' |  | 0: Pendente, 1: Deferido, 2: Indeferido |
| **user_deferimento_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **observacao_deferimento** | text | Sim |  |  | Nao informado no DDL. |
| **data_solicitacao** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **data_deferimento** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| cancelamentos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| cancelamentos_motivo_cancelamento_id_foreign | KEY | motivo_cancelamento_id | Acelera filtros e operacoes de juncao. |
| cancelamentos_user_deferimento_id_foreign | KEY | user_deferimento_id | Acelera filtros e operacoes de juncao. |
| cancelamentos_user_solicitante_id_foreign | KEY | user_solicitante_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| cancelamentos_motivo_cancelamento_id_foreign | motivo_cancelamento_id | motivos_cancelamentos | id | RESTRICT / RESTRICT |
| cancelamentos_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| cancelamentos_user_deferimento_id_foreign | user_deferimento_id | users | id | SET NULL / RESTRICT |
| cancelamentos_user_solicitante_id_foreign | user_solicitante_id | users | id | SET NULL / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

