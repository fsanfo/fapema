# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: edital_fonte_pagadoras

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela edital_fonte_pagadoras.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **valor** | double(9,2) | Sim | NULL |  | valor da fonte pagadora |
| **edital_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **fonte_pagadora_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| edital_fonte_pagadoras_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |
| edital_fonte_pagadoras_fonte_pagadora_id_foreign | KEY | fonte_pagadora_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| edital_fonte_pagadoras_edital_id_foreign | edital_id | editais | id | CASCADE / RESTRICT |
| edital_fonte_pagadoras_fonte_pagadora_id_foreign | fonte_pagadora_id | fonte_pagadoras | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

