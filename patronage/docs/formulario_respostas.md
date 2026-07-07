# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: formulario_respostas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela formulario_respostas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **resposta_numero** | decimal(8,2) | Sim | NULL |  | Nao informado no DDL. |
| **resposta_texto** | text | Sim |  |  | Nao informado no DDL. |
| **distribuicao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **formulario_subpergunta_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| avaliacao_subpergunta_resposta_distribuicao_id_foreign | KEY | distribuicao_id | Acelera filtros e operacoes de juncao. |
| avaliacao_subpergunta_resposta_avaliacao_subpergunta_id_foreign | KEY | formulario_subpergunta_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| avaliacao_subpergunta_resposta_distribuicao_id_foreign | distribuicao_id | distribuicoes | id | CASCADE / RESTRICT |
| avaliacao_subpergunta_resposta_formulario_subpergunta_id_foreign | formulario_subpergunta_id | formulario_subperguntas | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

