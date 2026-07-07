# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: chamada_dados_contratacao

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela chamada_dados_contratacao.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **relatorio_obrigatorio** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **edital_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **data_inicial_contratacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_final_contratacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_inicial_vigencia** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_final_vigencia** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_inicial_prestacao_de_conta** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_final_prestacao_de_conta** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_relatorio_parcial** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_relatorio_final** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_inicial_periodo_renovacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_final_periodo_renovacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **valor_bolsa** | decimal(8,2) | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_dados_contratacao_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_dados_contratacao_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

