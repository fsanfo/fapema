# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: subedital_proponente_vagas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela subedital_proponente_vagas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **termo_id** | int unsigned | Sim | NULL | UK, FK | id do termo de outorga |
| **edital_pai_id** | int unsigned | Nao |  | FK | id do edital pai |
| **subedital_id** | int unsigned | Nao |  | UK, FK | id do subedital |
| **proponente_id** | bigint unsigned | Nao |  | UK, FK | id do proponente (user_id) |
| **vagas** | int | Nao | '0' |  | quantidade de vagas do proponente no subedital |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| unique_termo_subedital_proponente | UNIQUE | termo_id, subedital_id, proponente_id | Garante unicidade dos dados indexados. |
| subedital_proponente_vagas_edital_pai_id_foreign | KEY | edital_pai_id | Acelera filtros e operacoes de juncao. |
| subedital_proponente_vagas_subedital_id_foreign | KEY | subedital_id | Acelera filtros e operacoes de juncao. |
| subedital_proponente_vagas_proponente_id_foreign | KEY | proponente_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| subedital_proponente_vagas_edital_pai_id_foreign | edital_pai_id | editais | id | CASCADE / RESTRICT |
| subedital_proponente_vagas_proponente_id_foreign | proponente_id | users | id | CASCADE / RESTRICT |
| subedital_proponente_vagas_subedital_id_foreign | subedital_id | editais | id | CASCADE / RESTRICT |
| subedital_proponente_vagas_termo_id_foreign | termo_id | termos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

