# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_relatorio

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_relatorio.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **parecer** | text | Sim |  |  | Nao informado no DDL. |
| **codigo** | varchar(64) | Sim | NULL |  | Nao informado no DDL. |
| **despacho_name** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **assinatura_diretor** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **assinatura_presidente** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **situacao** | varchar(1) | Nao | '0' |  | 0 - nao enviado; 1 - enviado ao orientador; 2 - enviado a Fapema |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **chamada_relatorio_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_relatorio_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| processo_relatorio_chamada_relatorio_id_foreign | KEY | chamada_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_relatorio_chamada_relatorio_id_foreign | chamada_relatorio_id | chamada_relatorios | id | RESTRICT / RESTRICT |
| processo_relatorio_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

