# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: instituicao_vinculos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela instituicao_vinculos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | bigint unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **user_id** | bigint unsigned | Nao |  |  | Nao informado no DDL. |
| **unidade** | varchar(255) | Sim | NULL |  | Unidade de vínculo do usuário |
| **cargo** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **vinculo_empregaticio** | enum('S','C','P','B','N') | Sim | NULL |  | S - Servidor Público, C - Celetista, P - Professor Visitante, B - Bolsista, N - Não possui vínculo |
| **situacao** | enum('A','N') | Sim | NULL |  | A - Ativo, N - Não Ativo |
| **regime_trabalho** | enum('20H','40H','DE','O') | Sim | NULL |  | 20H - 20 horas, 40H - 40 horas, DE - Dedicação Exclusiva, O - Outros |
| **instituicao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **polo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **anexo_vinculo** | varchar(255) | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| instituicao_vinculos_instituicao_id_foreign | KEY | instituicao_id | Acelera filtros e operacoes de juncao. |
| instituicao_vinculos_polo_id_foreign | KEY | polo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| instituicao_vinculos_instituicao_id_foreign | instituicao_id | instituicoes | id | RESTRICT / RESTRICT |
| instituicao_vinculos_polo_id_foreign | polo_id | polos | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

