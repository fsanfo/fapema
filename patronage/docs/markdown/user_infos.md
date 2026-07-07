# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: user_infos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela user_infos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  | FK | Nao informado no DDL. |
| **data_nascimento** | date | Sim | NULL |  | Nao informado no DDL. |
| **sexo** | enum('M','F','N') | Sim | NULL |  | M - Masculino, F - Feminino, N - Não informar |
| **estado_civil** | enum('S','C','V','D') | Sim | NULL |  | S - Solteiro, C - Casado, V - Viúvo, D - Divorciado |
| **nacionalidade** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **etnia** | varchar(20) | Sim | NULL |  | Nao informado no DDL. |
| **deficiencia_fisica** | varchar(20) | Sim | NULL |  | Nao informado no DDL. |
| **naturalidade** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **nome_pai** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **nome_mae** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **telefone** | varchar(255) | Sim | NULL |  | Telefone do usuário |
| **celular1** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **celular2** | varchar(255) | Sim | NULL |  | Celular secundário do usuário |
| **email2** | varchar(255) | Sim | NULL | UK | E-mail secundário do usuário |
| **lattes** | varchar(255) | Sim | NULL |  | Link do currículo lattes |
| **anexo_lattes** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **anexo_rg** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **anexo_comprovante_residencia** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **anexo_conta_corrente** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **banco_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **agencia** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **conta** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **info_fapema** | enum('S','N') | Sim | NULL |  | Se o usuário deseja receber informações do FAPEMA (S - Sim, N - Não) |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| user_infos_email2_unique | UNIQUE | email2 | Garante unicidade dos dados indexados. |
| user_infos_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| user_infos_banco_id_foreign | KEY | banco_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| user_infos_banco_id_foreign | banco_id | bancos | id | SET NULL / RESTRICT |
| user_infos_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

