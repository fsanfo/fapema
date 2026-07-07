# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: polos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela polos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **sigla** | varchar(20) | Nao |  |  | Sigla do polo de Ensino |
| **nome** | varchar(150) | Nao |  |  | Nome do polo de Ensino |
| **cnpj** | varchar(14) | Sim | NULL |  | CNPJ do Polo de Ensino |
| **fone** | varchar(15) | Sim | NULL |  | Nao informado no DDL. |
| **situacao** | tinyint(1) | Nao | '1' |  | false - Cadastrado pelo usuário, true = Confirmação do Cadastro pela FAPEMA |
| **instituicao_id** | int unsigned | Nao |  | FK | Id do instituição |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| polos_instituicao_id_foreign | KEY | instituicao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| polos_instituicao_id_foreign | instituicao_id | instituicoes | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

