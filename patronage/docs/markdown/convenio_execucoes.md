# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: convenio_execucoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela convenio_execucoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **data** | date | Nao |  |  | Nao informado no DDL. |
| **valor** | decimal(10,2) | Nao | '0.00' |  | Nao informado no DDL. |
| **convenio_planejamento_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| convenio_execucoes_convenio_planejamento_id_foreign | KEY | convenio_planejamento_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| convenio_execucoes_convenio_planejamento_id_foreign | convenio_planejamento_id | convenio_planejamentos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

