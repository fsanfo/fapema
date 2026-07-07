# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: resultado_publicacoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela resultado_publicacoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **chamada_formulario_avaliacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **situacao** | varchar(2) | Nao | '0' |  | 0 - Indisponivel, 1 - Disponivel |
| **nome** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **descricao** | text | Sim |  |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| resultado_publicacoes_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| resultado_publicacoes_chamada_formulario_avaliacao_id_foreign | KEY | chamada_formulario_avaliacao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| resultado_publicacoes_chamada_formulario_avaliacao_id_foreign | chamada_formulario_avaliacao_id | formulario_avaliacoes | id | CASCADE / RESTRICT |
| resultado_publicacoes_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

