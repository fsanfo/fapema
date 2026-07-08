# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: relatorio_avaliacao_respostas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela relatorio_avaliacao_respostas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **relatorio_avaliacao_subpergunta_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **resposta_texto** | text | Sim |  |  | Nao informado no DDL. |
| **resposta_numero** | decimal(15,2) | Sim | NULL |  | Nao informado no DDL. |
| **distribuicao_relatorio_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| fk_ra_resp_subp | KEY | relatorio_avaliacao_subpergunta_id | Acelera filtros e operacoes de juncao. |
| relatorio_avaliacao_respostas_distribuicao_relatorio_id_foreign | KEY | distribuicao_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| fk_ra_resp_subp | relatorio_avaliacao_subpergunta_id | relatorio_avaliacao_subperguntas | id | RESTRICT / RESTRICT |
| relatorio_avaliacao_respostas_distribuicao_relatorio_id_foreign | distribuicao_relatorio_id | distribuicoes_relatorio | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

