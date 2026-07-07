# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: passagens

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela passagens.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **trecho_ida** | varchar(200) | Sim | NULL |  | Trecho de ida, exemple: Imperatriz - São Luís |
| **trecho_volta** | varchar(200) | Sim | NULL |  | Trecho de volta, exemple: São Luís - Imperatriz |
| **data_ida** | date | Sim | NULL |  | Data de ida |
| **data_volta** | date | Sim | NULL |  | Data de volta |
| **quantidade** | int | Sim | NULL |  | Quantidade de passagens |
| **valor_unitario** | double(9,2) | Sim | NULL |  | Valor unitário da passagem |
| **valor_total** | double(9,2) | Sim | NULL |  | Valor total da passagem |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **tipo** | int | Sim | NULL |  | 1 - Aéreo, 2 - Fluvial, 3 - Terrestre |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| passagens_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| passagens_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

