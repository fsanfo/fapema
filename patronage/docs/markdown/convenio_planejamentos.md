# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: convenio_planejamentos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela convenio_planejamentos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **mes** | int | Nao |  |  | Nao informado no DDL. |
| **ano** | int | Nao |  |  | Nao informado no DDL. |
| **valor** | decimal(10,2) | Nao | '0.00' |  | Nao informado no DDL. |
| **financeiro_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| convenio_planejamentos_financeiro_id_foreign | KEY | financeiro_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| convenio_planejamentos_financeiro_id_foreign | financeiro_id | convenio_financeiro | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

