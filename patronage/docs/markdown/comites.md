# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: comites

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela comites.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **presencial** | tinyint(1) | Nao | '1' |  | 0- não, 1- sim |
| **inicio_distribuicao** | date | Sim | NULL |  | Data de inicio de distribuição |
| **fim_distribuicao** | date | Sim | NULL |  | Data de fim de distribuição |
| **inicio_avaliacao** | timestamp | Sim | NULL |  | Data de inicio da avaliação |
| **fim_avaliacao** | timestamp | Sim | NULL |  | Data de fim da avaliação |
| **edital_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **edital_avaliacao_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **chamadas** | varchar(10) | Nao | '1' |  | Uma ou mais chamadas |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| comites_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |
| comites_edital_avaliacao_id_foreign | KEY | edital_avaliacao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| comites_edital_avaliacao_id_foreign | edital_avaliacao_id | formulario_avaliacoes | id | CASCADE / RESTRICT |
| comites_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

