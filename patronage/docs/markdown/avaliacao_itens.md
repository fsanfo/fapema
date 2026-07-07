# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: avaliacao_itens

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela avaliacao_itens.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **formulario_avaliacao_subpergunta_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **descricao_item_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| form_avaliacao_itens_form_avaliacao_subpergunta_id_foreign | KEY | formulario_avaliacao_subpergunta_id | Acelera filtros e operacoes de juncao. |
| avaliacao_itens_descricao_item_id_foreign | KEY | descricao_item_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| avaliacao_itens_descricao_item_id_foreign | descricao_item_id | descricoes_item | id | CASCADE / RESTRICT |
| form_avaliacao_itens_form_avaliacao_subpergunta_id_foreign | formulario_avaliacao_subpergunta_id | formulario_subperguntas | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

