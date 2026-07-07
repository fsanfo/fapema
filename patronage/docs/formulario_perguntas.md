# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: formulario_perguntas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela formulario_perguntas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **tipo** | enum('1','2','3','4','5','6','7','8') | Nao | '1' |  | Nao informado no DDL. |
| **peso** | decimal(5,1) | Nao |  |  | Nao informado no DDL. |
| **formulario_avaliacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **descricao_pergunta_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| avaliacao_perguntas_chamada_avaliacao_id_foreign | KEY | formulario_avaliacao_id | Acelera filtros e operacoes de juncao. |
| avaliacao_perguntas_descricao_pergunta_id_foreign | KEY | descricao_pergunta_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| avaliacao_perguntas_chamada_avaliacao_id_foreign | formulario_avaliacao_id | formulario_avaliacoes | id | CASCADE / RESTRICT |
| avaliacao_perguntas_descricao_pergunta_id_foreign | descricao_pergunta_id | descricoes_pergunta | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

