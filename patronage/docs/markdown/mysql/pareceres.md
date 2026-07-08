# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: pareceres

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela pareceres.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **parecer** | text | Sim |  |  | Nao informado no DDL. |
| **status** | enum('1','2','3','4','5','6','7') | Sim | '7' |  | 1. Deferido, 2. Indeferido, 3. Deferido com restricao, 4. Em análise, 5. Pendência de regularização, 6. Em tomada de contas especial, 7. Aguardando Análise |
| **objeto_tce** | enum('ausencia','pendencia') | Sim | NULL |  | Objeto da Tomada de Contas Especial: ausencia = Por Ausência de Prestação de Contas, pendencia = Por Pendência na Prestação de Contas |
| **valor_tce** | decimal(10,2) | Sim | NULL |  | Valor da Tomada de Contas Especial |
| **data_parecer** | datetime | Sim | NULL |  | data do parecer |
| **analisado_id** | int unsigned | Nao |  |  | Nao informado no DDL. |
| **analisado_tipo** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| pareceres_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| pareceres_user_id_foreign | user_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

