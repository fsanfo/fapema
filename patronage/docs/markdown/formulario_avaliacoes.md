# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: formulario_avaliacoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela formulario_avaliacoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **ocultar_dados** | tinyint(1) | Sim | '0' |  | Nao informado no DDL. |
| **peso_curriculo** | decimal(5,1) | Sim | NULL |  | Nao informado no DDL. |
| **nome** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **avaliacao_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **data_inicio** | date | Sim | NULL |  | Data de início da atividade |
| **data_fim** | date | Sim | NULL |  | Data de fim da atividade |
| **edital_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **numero_consultores** | int | Sim | NULL |  | Nao informado no DDL. |
| **qtd_recomendacoes** | int | Sim | NULL |  | Nao informado no DDL. |
| **nota_maxima** | enum('5','10','100') | Nao | '10' |  | Nao informado no DDL. |
| **numero_solicitacoes_por_consultor** | int | Sim | NULL |  | Nao informado no DDL. |
| **avaliacao_curricular** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **calculo_modalidade** | tinyint(1) | Sim | '0' |  | Nao informado no DDL. |
| **calculo_area** | tinyint(1) | Sim | '0' |  | Nao informado no DDL. |
| **disponivel** | enum('0','1','2') | Nao | '0' |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_formulario_avaliacoes_avaliacao_chamada_id_foreign | KEY | avaliacao_chamada_id | Acelera filtros e operacoes de juncao. |
| chamada_formulario_avaliacoes_edital_id_foreign | KEY | edital_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_formulario_avaliacoes_avaliacao_chamada_id_foreign | avaliacao_chamada_id | chamada_avaliacoes | id | RESTRICT / RESTRICT |
| chamada_formulario_avaliacoes_edital_id_foreign | edital_id | editais | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

