# DOCUMENTACAO DE DICIONARIO DE DADOS

## Schema: patronage | Tabela: chamada_anexos

### 1. Visao Geral (Overview)
* **Descricao Funcional:** Documentacao tecnica gerada automaticamente a partir do DDL da tabela chamada_anexos.
* **Tipo de Tabela:** Transacional / Entidade de dominio.
* **Mecanismo de Armazenamento (Engine):** InnoDB
* **Charset/Collation:** utf8mb4 / utf8mb4_unicode_ci
* **Estrategia de Delecao:** Exclusao fisica (sem coluna de soft delete detectada no DDL).

---

### 2. Dicionario de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulavel | Padrao | Restricoes / Atributos | Descricao / Regra de Negocio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | int unsigned | Nao |  | PK, AUTO_INCREMENT | Nao informado no DDL. |
| **tamanho** | int | Nao |  |  | Tamanho do Anexo em megabytes: 2mb, 6mb, 10mb |
| **tipo** | enum('pdf','imagem') | Nao | 'pdf' |  | Nao informado no DDL. |
| **sigla** | varchar(200) | Nao |  |  | Nao informado no DDL. |
| **obrigatorio** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **equipe** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **permite_excluir** | tinyint(1) | Nao | '0' |  | Nao informado no DDL. |
| **edital_chamada_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **chamada_relatorio_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **tela_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **funcao_equipe_id** | int unsigned | Sim | NULL | FK | Nao informado no DDL. |
| **descricao_anexo_id** | int unsigned | Nao |  | FK | Nao informado no DDL. |
| **created_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |
| **updated_at** | timestamp | Sim | NULL |  | Nao informado no DDL. |

---

### 3. Chaves e Indices (Keys and Indexes)

| Nome do Indice | Tipo | Coluna(s) | Comportamento / Proposito |
| :--- | :--- | :--- | :--- |
| PRIMARY | BTREE | id | Chave primaria da tabela. |
| chamada_anexos_edital_chamada_id_foreign | KEY | edital_chamada_id | Acelera filtros e operacoes de juncao. |
| chamada_anexos_tela_id_foreign | KEY | tela_id | Acelera filtros e operacoes de juncao. |
| chamada_anexos_funcao_equipe_id_foreign | KEY | funcao_equipe_id | Acelera filtros e operacoes de juncao. |
| chamada_anexos_descricao_anexo_id_foreign | KEY | descricao_anexo_id | Acelera filtros e operacoes de juncao. |
| chamada_anexos_chamada_relatorio_id_foreign | KEY | chamada_relatorio_id | Acelera filtros e operacoes de juncao. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| chamada_anexos_chamada_relatorio_id_foreign | chamada_relatorio_id | chamada_relatorios | id | SET NULL / RESTRICT |
| chamada_anexos_descricao_anexo_id_foreign | descricao_anexo_id | descricao_anexos | id | RESTRICT / RESTRICT |
| chamada_anexos_edital_chamada_id_foreign | edital_chamada_id | edital_chamadas | id | CASCADE / RESTRICT |
| chamada_anexos_funcao_equipe_id_foreign | funcao_equipe_id | funcao_equipe | id | RESTRICT / RESTRICT |
| chamada_anexos_tela_id_foreign | tela_id | telas | id | RESTRICT / RESTRICT |

---

### 5. Observacoes Especiais e Padroes de Negocio
* Documentacao gerada automaticamente a partir do DDL em patronage/ddls. Revisar e complementar regras de negocio quando necessario.

