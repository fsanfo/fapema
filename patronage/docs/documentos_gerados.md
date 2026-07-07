# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: documentos_gerados

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela documentos_gerados.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **tipo** | tinyint | Nao |  |  | Tipo de declaração/documento (1-8 conforme TIPOS_DECLARACOES) |
| **hash_verificacao** | varchar(64) | Nao |  | UK | Hash SHA256 gerada com tipo e data/hora |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| documentos_gerados_hash_verificacao_unique | UNIQUE | hash_verificacao | Garante unicidade dos dados indexados. |
| documentos_gerados_processo_id_index | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| documentos_gerados_hash_verificacao_index | KEY | hash_verificacao | Acelera filtros e operacoes de juncao. |
| documentos_gerados_user_id_index | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| documentos_gerados_processo_id_foreign | processo_id | processos | id | SET NULL / RESTRICT |
| documentos_gerados_user_id_foreign | user_id | users | id | SET NULL / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

