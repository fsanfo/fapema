# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: processo_eventos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela processo_eventos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **nome** | varchar(50) | Sim | NULL |  | nome do evento |
| **provedor** | varchar(50) | Sim | NULL |  | quem promove o evento |
| **link** | varchar(150) | Sim | NULL |  | link para o evento |
| **inicio** | date | Sim | NULL |  | data de inicio do evento |
| **fim** | date | Sim | NULL |  | data de fim do evento |
| **abrangencia** | varchar(2) | Sim | '1' |  | 1 - estadual; 2 - regional; 3 - nacional; 4 - internacional |
| **forma_participacao** | varchar(2) | Sim | '1' |  | 1 = Conferencista; 2 = Debatedor; 3 = Palestrante convidado; 4 = Palestrante com Trabalho completo; 5 = Palestrante com Resumo ou poster |
| **custo_inscricao** | double(9,2) | Sim | NULL |  | custo de inscricao |
| **processo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **cidade_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| processo_eventos_processo_id_foreign | KEY | processo_id | Acelera filtros e operacoes de juncao. |
| processo_eventos_cidade_id_foreign | KEY | cidade_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| processo_eventos_cidade_id_foreign | cidade_id | cidades | id | RESTRICT / RESTRICT |
| processo_eventos_processo_id_foreign | processo_id | processos | id | CASCADE / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

