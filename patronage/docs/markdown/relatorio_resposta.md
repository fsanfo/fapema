# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: relatorio_resposta

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela relatorio_resposta.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **relatorio_subpergunta_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **processo_relatorio_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **resposta_texto** | text | Sim |  |  | Nao informado no DDL. |
| **resposta_numero** | int | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| relatorio_resposta_relatorio_subpergunta_id_foreign | KEY | relatorio_subpergunta_id | Acelera filtros e operacoes de juncao. |
| relatorio_resposta_processo_relatorio_id_foreign | KEY | processo_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| relatorio_resposta_processo_relatorio_id_foreign | processo_relatorio_id | processo_relatorio | id | SET NULL / RESTRICT |
| relatorio_resposta_relatorio_subpergunta_id_foreign | relatorio_subpergunta_id | relatorio_subperguntas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

