# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: convenios

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela convenios.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **numero** | varchar(20) | Nao |  |  | Nao informado no DDL. |
| **ano** | int | Nao |  |  | Nao informado no DDL. |
| **nome** | varchar(100) | Nao |  |  | nome |
| **tipo** | varchar(2) | Nao |  |  | 1- municipal, 2- estadual, 3- federal, 4-internacional |
| **assinatura** | date | Sim | NULL |  | data da assinatura |
| **diario_estadual** | date | Sim | NULL |  | data da diario estadual |
| **diario_uniao** | date | Sim | NULL |  | data da diario uniao |
| **vigencia_inicial** | date | Sim | NULL |  | data vigencia inicial |
| **vigencia_final** | date | Sim | NULL |  | data vigencia final |
| **relatorio** | tinyint(1) | Sim | NULL |  | possui relatorio de atividades |
| **relatorio_parcial** | date | Sim | NULL |  | data relatorio parcial |
| **relatorio_final** | date | Sim | NULL |  | data relatorio final |
| **prestacao_inicial** | date | Sim | NULL |  | data inicial prestacao |
| **prestacao_final** | date | Sim | NULL |  | data final prestacao |
| **objeto** | text | Sim |  |  | objeto |
| **banco** | varchar(20) | Sim | NULL |  | banco |
| **conta** | varchar(20) | Sim | NULL |  | conta |
| **agencia** | varchar(20) | Sim | NULL |  | agencia |
| **interveniente** | varchar(100) | Sim | NULL |  | interveniente |
| **implantacao** | varchar(100) | Sim | NULL |  | implantacao |
| **anexo_path** | varchar(100) | Sim | NULL |  | path anexo |
| **anexo_name** | varchar(100) | Sim | NULL |  | nome anexo |
| **anexo_financeiro_path** | varchar(100) | Sim | NULL |  | path anexo financeiro |
| **anexo_financeiro_name** | varchar(100) | Sim | NULL |  | nome anexo financeiro |
| **gestor_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| convenios_gestor_id_foreign | KEY | gestor_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| convenios_gestor_id_foreign | gestor_id | gestores | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

