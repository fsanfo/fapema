# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_equipe

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_equipe.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **area_trabalho** | varchar(70) | Nao |  |  | Nao informado no DDL. |
| **data_confirmacao** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **adicionado_por_user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **funcao_equipe_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_equipe_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| processo_equipe_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| processo_equipe_funcao_equipe_id_foreign | KEY | funcao_equipe_id | Acelera filtros e operacoes de juncao. |
| processo_equipe_adicionado_por_user_id_foreign | KEY | adicionado_por_user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_equipe_adicionado_por_user_id_foreign | adicionado_por_user_id | users | id | SET NULL / RESTRICT |
| processo_equipe_funcao_equipe_id_foreign | funcao_equipe_id | funcao_equipe | id | RESTRICT / RESTRICT |
| processo_equipe_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| processo_equipe_user_id_foreign | user_id | users | id | SET NULL / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

