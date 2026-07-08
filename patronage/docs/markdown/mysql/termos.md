# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: termos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela termos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** *Soft Delete* habilitado (coluna deleted_at).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **agencia** | varchar(15) | Sim | NULL |  | agencia |
| **conta** | varchar(15) | Sim | NULL |  | conta corrente |
| **banco_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **vigencia_inicial** | date | Sim | NULL |  | data da vigencia inicial |
| **vigencia_final** | date | Sim | NULL |  | data da vigencia final |
| **data_autorizacao** | date | Sim | NULL |  | Nao informado no DDL. |
| **vigencia_inicial_convenio** | date | Sim | NULL |  | data da vigencia inicial do convênio |
| **vigencia_final_convenio** | date | Sim | NULL |  | data da vigencia final do convênio |
| **prestacao_conta** | date | Sim | NULL |  | data da prestação de contas |
| **data_relatorio_parcial** | date | Sim | NULL |  | data do relatório parcial |
| **data_relatorio_final** | date | Sim | NULL |  | data do relatório final |
| **valor** | decimal(8,2) | Sim | NULL |  | Valor |
| **numero** | int | Sim | NULL |  | numero do termo |
| **ano** | varchar(4) | Sim | NULL |  | ano de criacao |
| **anexo_path** | varchar(500) | Sim | NULL |  | caminho do anexo do termo |
| **anexo_name** | varchar(500) | Sim | NULL |  | nome do anexo do termo |
| **status** | int | Sim | '0' |  | Nao informado no DDL. |
| **tipo** | varchar(1) | Nao | '1' |  | 1 - Outorga, 2 - Aditivo de Prazo, 3 - Aditivo de valor, 4 - Apostilamento, 5 - Termo Aditivo |
| **observacao** | varchar(255) | Sim | NULL |  | observacao |
| **observacao_visivel_no_termo** | tinyint(1) | Nao | '0' |  | 0 = não visivel, 1 = visivel |
| **termo_disponivel** | tinyint(1) | Nao | '0' |  | 0 = não disponivel, 1 = disponivel |
| **email_enviado** | tinyint(1) | Nao | '0' |  | Email de termo disponível enviado ao pesquisador |
| **responsavel_anexo_id** | bigint unsigned | Sim | NULL | FK | responsavel pelo criação do anexo |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **deleted_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **data_assinatura** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| termos_responsavel_anexo_id_foreign | KEY | responsavel_anexo_id | Acelera filtros e operacoes de juncao. |
| termos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| termos_banco_id_foreign | KEY | banco_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| termos_banco_id_foreign | banco_id | bancos | id | RESTRICT / RESTRICT |
| termos_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| termos_responsavel_anexo_id_foreign | responsavel_anexo_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

