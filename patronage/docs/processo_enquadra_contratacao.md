# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_enquadra_contratacao

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_enquadra_contratacao.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **valido** | enum('1','2','3') | Sim | NULL |  | 1 - Atende, 2 - Não atende, 3 - Não se aplica |
| **justificativa** | text | Sim |  |  | Justificativa |
| **enquadra_contratacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **chamada_anexo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_enquadra_contratacao_enquadra_contratacao_id_foreign | KEY | enquadra_contratacao_id | Acelera filtros e operacoes de juncao. |
| processo_enquadra_contratacao_chamada_anexo_id_foreign | KEY | chamada_anexo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_enquadra_contratacao_chamada_anexo_id_foreign | chamada_anexo_id | chamada_anexos | id | RESTRICT / RESTRICT |
| processo_enquadra_contratacao_enquadra_contratacao_id_foreign | enquadra_contratacao_id | enquadramentos_contratacao | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

