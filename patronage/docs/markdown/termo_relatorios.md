# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: termo_relatorios

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela termo_relatorios.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **termo_id** | int unsigned | Nao |  | UK, FK | Nao informado no DDL. |
| **chamada_relatorio_id** | int unsigned | Nao |  | UK, FK | Nao informado no DDL. |
| **data_entrega** | date | Sim | NULL |  | data limite de entrega definida no termo, padrão vindo de chamada_relatorios.data_fim |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| termo_relatorios_termo_id_chamada_relatorio_id_unique | UNIQUE | termo_id, chamada_relatorio_id | Garante unicidade dos dados indexados. |
| termo_relatorios_chamada_relatorio_id_foreign | KEY | chamada_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| termo_relatorios_chamada_relatorio_id_foreign | chamada_relatorio_id | chamada_relatorios | id | CASCADE / RESTRICT |
| termo_relatorios_termo_id_foreign | termo_id | termos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

