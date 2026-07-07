# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: distribuicoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela distribuicoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **situacao** | varchar(2) | Nao | '1' |  | 1- Convite distribuido; 2- Convite notificado; 3- Convite aceito; 4- Convite cancelado; 5- Avaliado; 6- Avaliado e enviado a FAPEMA; 7 - Convite recusado. |
| **codigo** | varchar(64) | Sim | NULL | UK | Hash única para a distribuição |
| **formulario_pdf_name** | varchar(255) | Sim | NULL |  | Nome do arquivo PDF do formulário gerado |
| **nota** | decimal(8,2) | Sim | NULL |  | Nao informado no DDL. |
| **valor_aprovado** | double(8,2) | Sim | NULL |  | Valor aprovado pelo consultor |
| **parecer** | varchar(2) | Nao | '1' |  | 1- Recomendado, 2- Não recomendado, 3- Recomendado com alterações, 4- Recomendado mais não rankeado, 5- Não enquadrado |
| **justificativa** | text | Sim |  |  | justificativa do consultor |
| **ordem_ranqueamento** | int | Sim | NULL |  | ordem do ranqueamento |
| **selecionado** | tinyint(1) | Sim | '1' |  | selecionado para ranqueamento |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **user_id** | bigint unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **chamada_formulario_avaliacao_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **data_envio** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **data_distribuicao** | datetime | Sim | NULL |  | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| distribuicoes_codigo_unique | UNIQUE | codigo | Garante unicidade dos dados indexados. |
| distribuicoes_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| distribuicoes_user_id_foreign | KEY | user_id | Acelera filtros e operacoes de juncao. |
| distribuicoes_chamada_formulario_avaliacao_id_foreign | KEY | chamada_formulario_avaliacao_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| distribuicoes_chamada_formulario_avaliacao_id_foreign | chamada_formulario_avaliacao_id | formulario_avaliacoes | id | RESTRICT / RESTRICT |
| distribuicoes_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |
| distribuicoes_user_id_foreign | user_id | users | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

