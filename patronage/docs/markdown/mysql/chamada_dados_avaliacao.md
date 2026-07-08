# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: chamada_dados_avaliacao

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela chamada_dados_avaliacao.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **data_inicio_avaliacao_admissao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_fim_avaliacao_admissao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_inicio_avaliacao_relatorio** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_fim_avaliacao_relatorio** | date | Sim | NULL |  | Nao informado no DDL. |
| **numero_consultores** | int | Sim | NULL |  | Nao informado no DDL. |
| **qtd_recomendacoes** | int | Sim | NULL |  | Nao informado no DDL. |
| **numero_solicitacoes_por_consultor** | int | Sim | NULL |  | Nao informado no DDL. |
| **data_inicio_periodo_avaliacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_fim_periodo_avaliacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **porcentagem_aprovacao_avaliacao** | int | Sim | NULL |  | Nao informado no DDL. |
| **avaliacao_permanente** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **tipo_pergunta** | enum('NOTA','QUANTIDADE') | Nao | 'NOTA' |  | Nao informado no DDL. |
| **nota_maxima** | enum('5','10','100') | Nao | '10' |  | Nao informado no DDL. |
| **calcular_media_ponderada** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **totalizar_avaliacao** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **propor_corte_orcamentario** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **propor_alteracoes_metodologicas** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **recomendado_com_restricoes** | tinyint(1) | Nao | '1' |  | Nao informado no DDL. |
| **edital_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_dados_avaliacao_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_dados_avaliacao_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

