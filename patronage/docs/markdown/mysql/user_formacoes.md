# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: user_formacoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela user_formacoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  |  | Nao informado no DDL. |
| **titulo** | enum('EM','MT','GN','G','E','MN','M','DN','D') | Sim | NULL |  | EM - Ensino médio, MT - Médio/Técnico, GN - Graduando, G - Graduado, E - Especialista, MN - Mestrando, M - Mestre, DN - Doutorando, D - Doutor |
| **nome_curso** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **ano_formacao** | year | Sim | NULL |  | Nao informado no DDL. |
| **instituicao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **anexo_diploma** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| user_formacoes_instituicao_id_foreign | KEY | instituicao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| user_formacoes_instituicao_id_foreign | instituicao_id | instituicoes | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

