# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: erro_steps_chamada

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela erro_steps_chamada.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **erroAnexos** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **erroDocumentacoes** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim / obrigatório se não for quota |
| **erroDadosContratacao** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **erroTermoOutorga** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **erroTermoAditivoValor** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **erroTermoAditivoPrazo** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **erroTermoApostilamento** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **edital_chamada_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **erroTermoAditivo** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| erro_steps_chamada_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| erro_steps_chamada_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

