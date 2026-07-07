# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_sub_edital

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_sub_edital.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **processo_id** | int unsigned | Sim | NULL | FK | id do processo |
| **edital_id** | int unsigned | Sim | NULL | FK | id do sub edital |
| **termo_id** | int unsigned | Sim | NULL | FK | id do termo |
| **qtd_vagas** | int | Nao |  |  | Número de bolsistas |
| **parcelas** | int | Nao |  |  | Número de parcelas |
| **valor** | double(9,2) | Nao |  |  | valor da parcela |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_sub_edital_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| processo_sub_edital_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |
| processo_sub_edital_termo_id_foreign | KEY | termo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_sub_edital_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |
| processo_sub_edital_processo_id_foreign | processo_id | processos | id | RESTRICT / RESTRICT |
| processo_sub_edital_termo_id_foreign | termo_id | termos | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

