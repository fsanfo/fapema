# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: logs

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela logs.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **chave** | bigint unsigned | Sim | NULL |  | Nao informado no DDL. |
| **modulo_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **operacao_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **operador_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **mensagem** | text | Nao |  |  | Nao informado no DDL. |
| **conteudo_alterado** | text | Sim |  |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| logs_modulo_id_foreign | KEY | modulo_id | Acelera filtros e operacoes de juncao. |
| logs_operacao_id_foreign | KEY | operacao_id | Acelera filtros e operacoes de juncao. |
| logs_operador_id_foreign | KEY | operador_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| logs_modulo_id_foreign | modulo_id | modulos | id | RESTRICT / RESTRICT |
| logs_operacao_id_foreign | operacao_id | operacoes | id | RESTRICT / RESTRICT |
| logs_operador_id_foreign | operador_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

