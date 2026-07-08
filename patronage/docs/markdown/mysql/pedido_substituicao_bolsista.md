# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: pedido_substituicao_bolsista

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela pedido_substituicao_bolsista.
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
| **processo_substituto_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_solicitante_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **novo_user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **justificativa** | text | Nao |  |  | Nao informado no DDL. |
| **status** | int | Nao | '0' |  | 0: Pendente, 1: Deferido, 2: Indeferido |
| **data_solicitacao** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **data_deferimento** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **user_deferimento_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **observacao_deferimento** | text | Sim |  |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| pedido_substituicao_bolsista_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| pedido_substituicao_bolsista_processo_substituto_id_foreign | KEY | processo_substituto_id | Acelera filtros e operacoes de juncao. |
| pedido_substituicao_bolsista_user_solicitante_id_foreign | KEY | user_solicitante_id | Acelera filtros e operacoes de juncao. |
| pedido_substituicao_bolsista_novo_user_id_foreign | KEY | novo_user_id | Acelera filtros e operacoes de juncao. |
| pedido_substituicao_bolsista_user_deferimento_id_foreign | KEY | user_deferimento_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| pedido_substituicao_bolsista_novo_user_id_foreign | novo_user_id | users | id | CASCADE / RESTRICT |
| pedido_substituicao_bolsista_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| pedido_substituicao_bolsista_processo_substituto_id_foreign | processo_substituto_id | processos | id | SET NULL / RESTRICT |
| pedido_substituicao_bolsista_user_deferimento_id_foreign | user_deferimento_id | users | id | SET NULL / RESTRICT |
| pedido_substituicao_bolsista_user_solicitante_id_foreign | user_solicitante_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

