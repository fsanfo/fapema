# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: termo_parcelas_pagas

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela termo_parcelas_pagas.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **termo_parcela_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **data_pagamento** | date | Sim | NULL |  | Nao informado no DDL. |
| **data_notificacao** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **ordem_bancaria** | varchar(20) | Sim | NULL |  | Nao informado no DDL. |
| **nota_empenho** | varchar(20) | Sim | NULL |  | Nao informado no DDL. |
| **situacao_pagamento** | enum('1','2','3') | Sim | NULL |  | 1 - pago, 2 - pago parcialmente, 3 - não pago |
| **valor_pago** | decimal(10,2) | Nao | '0.00' |  | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **subacao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **fonte_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **natureza_despesa_id** | int unsigned | Sim | NULL |  | Nao informado no DDL. |
| **inserido_via_api** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| termo_parcelas_pagas_termo_parcela_id_foreign | KEY | termo_parcela_id | Acelera filtros e operacoes de juncao. |
| termo_parcelas_pagas_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| termo_parcelas_pagas_fonte_id_foreign | KEY | fonte_id | Acelera filtros e operacoes de juncao. |
| termo_parcelas_pagas_subacao_id_foreign | KEY | subacao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| termo_parcelas_pagas_fonte_id_foreign | fonte_id | fonte_pagadoras | id | RESTRICT / RESTRICT |
| termo_parcelas_pagas_subacao_id_foreign | subacao_id | subacoes | id | RESTRICT / RESTRICT |
| termo_parcelas_pagas_termo_parcela_id_foreign | termo_parcela_id | termo_parcelas | id | CASCADE / RESTRICT |
| termo_parcelas_pagas_user_id_foreign | user_id | users | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

