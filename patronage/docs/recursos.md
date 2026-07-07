# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: recursos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela recursos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **tipo** | enum('1','2','3','4','5') | Sim | NULL |  | 1 - Valor, 2 - Material, 3 - Diversos, 4 - Resultado, 5 - Prorrogação |
| **justificativa** | text | Sim |  |  | Justificativa do pedido de recurso pelo pesquisador |
| **status** | int | Sim | NULL |  | 1 - Solicitado, 2 - Deferido, 3 - Indeferido |
| **user_id** | bigint unsigned | Sim | NULL | FK | Usuário que vai dar o parecer |
| **parecer** | text | Sim |  |  | Parecer do pedido de recurso pelo administrador |
| **data_parecer** | date | Sim | NULL |  | Nao informado no DDL. |
| **anexo_recurso_path** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **anexo_recurso_name** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **notificacao** | enum('1','2') | Sim | NULL |  | 1 - Não Notificado, 2 - Notificado |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **parecer_recurso_name** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **enviado** | tinyint(1) | Sim | '0' |  | 0 - Não enviado para o setor, 1 - Enviado para o setor |
| **assinado** | tinyint(1) | Sim | '0' |  | 0 - Não assinado pelo presidente, 1 - Assinado pelo presidente |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| recursos_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| recursos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| recursos_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| recursos_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

