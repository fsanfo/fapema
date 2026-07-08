# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: edital_dados_financeiro

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela edital_dados_financeiro.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **valor_edital** | decimal(19,2) | Sim | NULL |  | Nao informado no DDL. |
| **sub_acao** | int | Sim | NULL |  | Nao informado no DDL. |
| **fonte** | enum('C','E') | Sim | NULL |  | C- convenio; E- estado |
| **convenio_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **edital_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| edital_dados_financeiro_convenio_id_foreign | KEY | convenio_id | Acelera filtros e operacoes de juncao. |
| edital_dados_financeiro_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| edital_dados_financeiro_convenio_id_foreign | convenio_id | convenios | id | RESTRICT / RESTRICT |
| edital_dados_financeiro_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

