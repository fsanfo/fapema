# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_cancelamento

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_cancelamento.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **motivo** | enum('1','2','3','4','5','6','7','8','9','10','11','12','13','14','15') | Nao |  |  | 1 - Critério do Curso, 2 - Prazo de Bolsa Esgotado, 3 - Desligado do Curso por Limite de Prazo, 4 - Desistência da Bolsa, 5 - Acúmulo de Bolsas, 6 - Bolsista Adquiriu Vínculo Empregatício, 7 - Mudança de Agência de Fomento à Pesquisa, 8 - Desistência do Curso, 9 - Aposentadoria, 10 - Mudança de Programa CAPES, 11 - Trancamento de Matrícula, 12 - Insuficiência de Aproveitamento, 13 - Falecimento, 14 - Não Atende às Normas do Programa, 15 - Outros |
| **justificativa** | text | Nao |  |  | Justificativa do Cancelamento |
| **processo_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_cancelamento_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_cancelamento_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

