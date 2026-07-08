# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: users

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela users.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** *Soft Delete* habilitado (coluna deleted_at).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **name** | varchar(150) | Nao |  |  | Nao informado no DDL. |
| **social_name** | varchar(100) | Sim | NULL |  | Nao informado no DDL. |
| **tipo_documento** | enum('1','2') | Nao |  |  | 1 = CPF, 2 = passaporte |
| **documento** | varchar(30) | Nao |  |  | CPF/Passaport |
| **email** | varchar(100) | Sim | NULL | UK | Nao informado no DDL. |
| **dark_mode** | tinyint(1) | Sim | '0' |  | Nao informado no DDL. |
| **email_verified_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **password** | varchar(100) | Sim | NULL |  | Nao informado no DDL. |
| **membro_comite** | enum('1','2','3') | Nao | '3' |  | online, presencial, não disponível |
| **remember_token** | varchar(100) | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **old_password** | varchar(50) | Sim | NULL |  | Nao informado no DDL. |
| **deleted_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| users_email_unique | UNIQUE | email | Garante unicidade dos dados indexados. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | Nenhuma chave estrangeira declarada. |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

