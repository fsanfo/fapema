# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: edital_chamadas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela edital_chamadas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** *Soft Delete* habilitado (coluna deleted_at).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **numero** | int unsigned | Nao |  |  | Nao informado no DDL. |
| **grupo** | int | Sim | NULL |  | Nao informado no DDL. |
| **nome** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **inicio** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **fim** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **publicada** | tinyint(1) | Nao | '0' |  | 0 - não publicada; 1 - publicada |
| **edital_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **parecer_pesquisador** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **exibir_nota** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **recurso_inicio** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **recurso_fim** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **deleted_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| edital_chamadas_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| edital_chamadas_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

