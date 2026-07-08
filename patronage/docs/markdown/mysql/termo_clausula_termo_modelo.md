# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: termo_clausula_termo_modelo

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela termo_clausula_termo_modelo.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **termo_clausula_id** | int unsigned | Nao |  | PK, FK | Nao informado no DDL. |
| **termo_modelo_id** | int unsigned | Nao |  | PK, FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | termo_clausula_id, termo_modelo_id | Chave primaria da tabela. |
| termo_clausula_termo_modelo_termo_modelo_id_foreign | KEY | termo_modelo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| termo_clausula_termo_modelo_termo_clausula_id_foreign | termo_clausula_id | termo_clausulas | id | CASCADE / RESTRICT |
| termo_clausula_termo_modelo_termo_modelo_id_foreign | termo_modelo_id | termo_modelo | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

