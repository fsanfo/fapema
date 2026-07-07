# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: politica_dados_aceites

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela politica_dados_aceites.
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
| **politica_dados_versao_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **accepted_at** | timestamp | Nao |  |  | Nao informado no DDL. |
| **ip_address** | varchar(45) | Sim | NULL |  | Nao informado no DDL. |
| **user_agent** | text | Sim |  |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| politica_dados_aceites_politica_dados_versao_id_foreign | KEY | politica_dados_versao_id | Acelera filtros e operacoes de juncao. |
| politica_dados_aceites_user_id_politica_dados_versao_id_index | KEY | user_id, politica_dados_versao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| politica_dados_aceites_politica_dados_versao_id_foreign | politica_dados_versao_id | politica_dados_versoes | id | CASCADE / RESTRICT |
| politica_dados_aceites_user_id_foreign | user_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

