# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: relatorio_avaliacoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela relatorio_avaliacoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **nome** | varchar(255) | Nao |  |  | Nao informado no DDL. |
| **data_inicio** | datetime | Sim | NULL |  | data inicial do relatorio |
| **data_fim** | datetime | Sim | NULL |  | data final do relatorio |
| **disponivel** | enum('0','1','2') | Nao | '0' |  | Nao informado no DDL. |
| **chamada_relatorio_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **ocultar_dados** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **numero_consultores** | int | Sim | NULL |  | Nao informado no DDL. |
| **nota_maxima** | enum('5','10','100') | Nao | '10' |  | Nao informado no DDL. |
| **numero_solicitacoes_por_consultor** | int | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| relatorio_avaliacoes_chamada_relatorio_id_foreign | KEY | chamada_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| relatorio_avaliacoes_chamada_relatorio_id_foreign | chamada_relatorio_id | chamada_relatorios | id | SET NULL / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

