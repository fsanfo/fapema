# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: relatorio_avaliacao_perguntas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela relatorio_avaliacao_perguntas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **tipo** | enum('1','2','3','4','5') | Nao | '1' |  | 1- Justificativa, 2- numerico, 3- Tabela, 4- Seletivo, 5- Seletivo com Justificativa |
| **relatorio_avaliacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **descricao_pergunta_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **peso** | decimal(8,2) | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| relatorio_avaliacao_perguntas_relatorio_avaliacao_id_foreign | KEY | relatorio_avaliacao_id | Acelera filtros e operacoes de juncao. |
| relatorio_avaliacao_perguntas_descricao_pergunta_id_foreign | KEY | descricao_pergunta_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| relatorio_avaliacao_perguntas_descricao_pergunta_id_foreign | descricao_pergunta_id | descricoes_pergunta | id | RESTRICT / RESTRICT |
| relatorio_avaliacao_perguntas_relatorio_avaliacao_id_foreign | relatorio_avaliacao_id | relatorio_avaliacoes | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

