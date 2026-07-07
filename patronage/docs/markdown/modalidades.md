# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: modalidades

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela modalidades.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **sigla** | varchar(30) | Nao |  |  | Nao informado no DDL. |
| **nome** | varchar(100) | Nao |  |  | Nao informado no DDL. |
| **tipo** | varchar(2) | Nao | '1' |  | 1- bolsa; 2- auxilio |
| **status** | tinyint(1) | Nao | '1' |  | 0- inativo, 1- ativo |
| **sub_programa_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| modalidades_sub_programa_id_foreign | KEY | sub_programa_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| modalidades_sub_programa_id_foreign | sub_programa_id | sub_programas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

