# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: notificacao_execucao

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela notificacao_execucao.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_notificado** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **fase** | int | Nao |  |  | Fase da notificação |
| **dias** | int | Sim | NULL |  | Dias Colocados para a Prestação de Contas |
| **data_notificacao** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  | FK | Usuário que realizou a notificação |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| notificacao_execucao_user_notificado_foreign | KEY | user_notificado | Acelera filtros e operacoes de juncao. |
| notificacao_execucao_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| notificacao_execucao_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| notificacao_execucao_processo_id_foreign | processo_id | processos | id | RESTRICT / RESTRICT |
| notificacao_execucao_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

