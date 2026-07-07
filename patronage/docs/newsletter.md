# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: newsletter

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela newsletter.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **assunto** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **texto** | text | Sim |  |  | HTML do texto |
| **perfil** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **titulacao** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **situacao** | json | Sim | NULL |  | Nao informado no DDL. |
| **send_mode** | varchar(20) | Nao | 'individual' |  | Nao informado no DDL. |
| **instituicao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **instituicao_ids** | json | Sim | NULL |  | Nao informado no DDL. |
| **area_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **edital_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **edital_ids** | json | Sim | NULL |  | Nao informado no DDL. |
| **edital_chamada_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **edital_chamada_ids** | json | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| newsletter_instituicao_id_foreign | KEY | instituicao_id | Acelera filtros e operacoes de juncao. |
| newsletter_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |
| newsletter_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |
| newsletter_area_id_foreign | KEY | area_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| newsletter_area_id_foreign | area_id | areas | id | SET NULL / RESTRICT |
| newsletter_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | SET NULL / RESTRICT |
| newsletter_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |
| newsletter_instituicao_id_foreign | instituicao_id | instituicoes | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

