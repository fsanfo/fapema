# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: editais

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela editais.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **nome** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **ano** | varchar(4) | Sim | NULL |  | Nao informado no DDL. |
| **numero** | int | Sim | NULL |  | Nao informado no DDL. |
| **tipo** | varchar(2) | Nao | '1' |  | 1- bolsa; 2- auxilio |
| **caracteristica** | varchar(2) | Nao | '1' |  | 1-Edital; 3-Fluxo contínuo; 4-Demandas institucionais; 5-ACT; 6-Monitoria; 7-CTC; 8-Portaria; 9-Resolução; 10-Convênio |
| **personalidade_juridica** | enum('F','J') | Nao | 'F' |  | F - Pessoa fisica; J - Pessoa Juridica |
| **uso** | tinyint(1) | Nao | '1' |  | 0 - interno; 1 - externo |
| **link** | varchar(200) | Sim | NULL |  | Anexo Edital(Buscar o link do site) |
| **quota** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **quota_indicacao_multipla** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **substituir_bolsista** | tinyint(1) | Nao | '0' |  | Pode ter substituição |
| **indicar_bolsista** | tinyint(1) | Nao | '0' |  | 0- não; 1- sim |
| **portal_projetos** | tinyint(1) | Nao | '1' |  | exibir no Buriti |
| **rep_institucional** | tinyint(1) | Nao | '0' |  | solicitar representante institucional |
| **assinatura_rep_institucional** | tinyint(1) | Nao | '0' |  | solicitar representante institucional |
| **inscricao_permanente** | tinyint(1) | Nao | '0' |  | solicitar representante institucional |
| **modalidade_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **setor_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **user_responsavel** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **edital_pai_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **acesso_restrito** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **conta_exclusiva** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| editais_modalidade_id_foreign | KEY | modalidade_id | Acelera filtros e operacoes de juncao. |
| editais_setor_id_foreign | KEY | setor_id | Acelera filtros e operacoes de juncao. |
| editais_edital_pai_id_foreign | KEY | edital_pai_id | Acelera filtros e operacoes de juncao. |
| editais_user_responsavel_foreign | KEY | user_responsavel | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| editais_edital_pai_id_foreign | edital_pai_id | editais | id | RESTRICT / RESTRICT |
| editais_modalidade_id_foreign | modalidade_id | modalidades | id | RESTRICT / RESTRICT |
| editais_setor_id_foreign | setor_id | setores | id | RESTRICT / RESTRICT |
| editais_user_responsavel_foreign | user_responsavel | users | id | SET NULL / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

