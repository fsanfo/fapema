# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: edital_chamada_faixas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela edital_chamada_faixas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **valor** | decimal(10,2) | Nao |  |  | valor máximo por proposta |
| **contigenciamento** | decimal(10,2) | Nao | '0.00' |  | contigenciamento do comitê |
| **edital_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **descricao_faixa_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| edital_chamada_faixas_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |
| edital_chamada_faixas_descricao_faixa_id_foreign | KEY | descricao_faixa_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| edital_chamada_faixas_descricao_faixa_id_foreign | descricao_faixa_id | descricao_faixas | id | RESTRICT / RESTRICT |
| edital_chamada_faixas_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

