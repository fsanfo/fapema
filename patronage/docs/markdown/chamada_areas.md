# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: chamada_areas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela chamada_areas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **edital_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **area_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_areas_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |
| chamada_areas_area_id_foreign | KEY | area_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_areas_area_id_foreign | area_id | areas | id | RESTRICT / RESTRICT |
| chamada_areas_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

