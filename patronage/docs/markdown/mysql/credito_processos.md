# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: credito_processos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela credito_processos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **custeio** | double(8,2) | Nao |  |  | valor do custeio |
| **capital** | double(8,2) | Nao |  |  | valor do capital |
| **status** | varchar(1) | Nao | '0' |  | 0 = não avaliado, 1 = deferido, 2 = indeferido |
| **tipo** | varchar(1) | Nao | '1' |  | 1 = suplementar, 2 = publicação, 3 = importação |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **processoscredito_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| credito_processos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| credito_processos_processoscredito_id_foreign | KEY | processoscredito_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| credito_processos_processo_id_foreign | processo_id | processos | id | RESTRICT / RESTRICT |
| credito_processos_processoscredito_id_foreign | processoscredito_id | processos | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

