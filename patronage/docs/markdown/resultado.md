# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: resultado

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela resultado.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **nota** | int unsigned | Nao |  |  | Nao informado no DDL. |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **resultado_publicacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **ordem_ranqueamento** | int | Sim | NULL |  | ordem do ranqueamento |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| resultado_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| resultado_resultado_publicacao_id_foreign | KEY | resultado_publicacao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| resultado_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| resultado_resultado_publicacao_id_foreign | resultado_publicacao_id | resultado_publicacoes | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

