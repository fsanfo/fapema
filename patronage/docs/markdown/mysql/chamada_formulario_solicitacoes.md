# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: chamada_formulario_solicitacoes

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela chamada_formulario_solicitacoes.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **orientador** | enum('1','2','3') | Nao | '2' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **supervisor** | enum('1','2','3') | Nao | '2' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **instituicao_execucao** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **faixa** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **pos_graduacao** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **equipe** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **palavra_chave** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **justificativa** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **memorial** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **resumo** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **plano_trabalho** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **sintese** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **tipo_proposta** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **evento** | enum('1','2','3','4') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir; 4- Só o evento é obrigatorio |
| **atividades_proposta** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **tipo_solicitacao** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **forma_participacao** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **abrangencia_evento** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **orcamento** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **cronograma** | enum('1','2','3') | Nao | '1' |  | 1- Não obrigatorio; 2- Obrigatorio; 3- Não exibir |
| **edital_chamada_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **link_lattes** | tinyint(1) | Nao | '1' |  | Indica se o link para o currículo Lattes do solicitante é obrigatório |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_formulario_solicitacoes_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_formulario_solicitacoes_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

