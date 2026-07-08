# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: instituicoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela instituicoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **sigla** | varchar(20) | Nao |  |  | Sigla da Instituição de Ensino |
| **nome** | varchar(150) | Nao |  |  | Nome da Instituição de Ensino |
| **cnpj** | varchar(14) | Sim | NULL |  | CNPJ da Instituição de Ensino |
| **fone** | varchar(15) | Sim | NULL |  | Telefone da Instituição de Ensino |
| **ativo** | tinyint(1) | Sim | '0' |  | 0 = inativo, 1 = ativo |
| **situacao** | tinyint(1) | Sim | NULL |  | 0 = Cadastrado pelo usuário, 1 = Confirmação do Cadastro pela FAPEMA |
| **modalidade** | tinyint(1) | Sim | NULL |  | 0 = Instituição Pública , 1 = Instituição Privada |
| **tipo** | tinyint(1) | Sim | NULL |  | 0 = Empresa, 1 = Instituição de Ensino |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| - | - | - | - | Nenhuma chave estrangeira declarada. |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

