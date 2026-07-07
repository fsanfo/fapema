# 📑 DOCUMENTAÇÃO DE DICIONÁRIO DE DADOS

## 🏢 Schema: `patronage` | 📋 Tabela: `processos`

### 1. Visão Geral (Overview)
* **Descrição Funcional:** Armazena os dados principais dos processos/projetos submetidos à plataforma (ex: solicitações de bolsas, auxílios, editais de fomento). Centraliza o fluxo de submissão, informações científicas/acadêmicas, dados bancários exclusivos e o progresso do ciclo de vida do projeto.
* **Tipo de Tabela:** Transacional / Entidade Core.
* **Mecanismo de Armazenamento (Engine):** `InnoDB`
* **Charset/Collation:** `utf8mb4` / `utf8mb4_unicode_ci`
* **Estratégia de Deleção:** *Soft Delete* habilitado (coluna `deleted_at`).

---

### 2. Dicionário de Colunas (Data Dictionary)

| Campo | Tipo de Dados | Nulável | Padrão | Restrições / Atributos | Descrição / Regra de Negócio |
| :--- | :--- | :---: | :--- | :--- | :--- |
| **id** | `int unsigned` | ❌ Não | *AUTO_INCREMENT* | **PK** | Identificador único incremental do processo. |
| **sigla** | `varchar(50)` | ✔️ Sim | `NULL` | **UK** | Sigla identificadora única do processo. |
| **titulo** | `varchar(300)` | ✔️ Sim | `NULL` | | Título principal do projeto/processo. |
| **situacao** | `tinyint` | ❌ Não | `0` | | Status do projeto. Ex: `0` = Não enviado. |
| **palavra_chave1** | `varchar(50)` | ✔️ Sim | `NULL` | | Primeira palavra-chave de indexação do trabalho. |
| **palavra_chave2** | `varchar(50)` | ✔️ Sim | `NULL` | | Segunda palavra-chave de indexação do trabalho. |
| **palavra_chave3** | `varchar(50)` | ✔️ Sim | `NULL` | | Terceira palavra-chave de indexação do trabalho. |
| **justificativa** | `text` | ✔️ Sim | `NULL` | | Texto descritivo contendo a justificativa do trabalho. |
| **resumo** | `text` | ✔️ Sim | `NULL` | | Resumo técnico/científico do projeto. |
| **memorial** | `text` | ✔️ Sim | `NULL` | | Descrição do memorial descritivo ou justificativa. |
| **prest_contas** | `tinyint(1)` | ✔️ Sim | `NULL` | Flag Booleana | Indica se houve prestação de contas (`1` = Sim, `0` = Não). |
| **declaracao** | `tinyint(1)` | ✔️ Sim | `NULL` | Flag Booleana | Termo de aceite do usuário às declarações vigentes. |
| **user_id** | `bigint unsigned` | ✔️ Sim | `NULL` | **FK** | ID do usuário proponente/criador do processo. |
| **quota_indicador_id** | `bigint unsigned` | ✔️ Sim | `NULL` | **FK** | ID do usuário indicador da cota (on delete: null). |
| **edital_chamada_id** | `int unsigned` | ❌ Não | | **FK** | ID do edital ou chamada pública vinculada. |
| **edital_chamada_faixa_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID da faixa financeira/operacional do edital. |
| **processotabela_id** | `int unsigned` | ✔️ Sim | `NULL` | Relação Polimórfica | ID da entidade relacionada (Instituição ou Polo). |
| **processotabela_type** | `varchar(50)` | ✔️ Sim | `NULL` | Relação Polimórfica | Nome da classe/tabela alvo (Ex: 'Instituicao', 'Polo'). |
| **orientador_id** | `bigint unsigned` | ✔️ Sim | `NULL` | **FK** | ID do usuário na função de orientador. |
| **supervisor_id** | `bigint unsigned` | ✔️ Sim | `NULL` | **FK** | ID do usuário na função de supervisor. |
| **area_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID da área de conhecimento CNPq/Capes vinculada. |
| **sub_area_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID da subárea de conhecimento vinculada. |
| **instituicao_apoio** | `varchar(300)` | ✔️ Sim | `NULL` | | Nome da instituição externa de apoio, se houver. |
| **bolsista_instituicao** | `varchar(300)` | ✔️ Sim | `NULL` | | Nome de bolsista pertencente a outra instituição. |
| **envio** | `timestamp` | ✔️ Sim | `NULL` | Data/Hora | Data e hora exata em que o processo foi submetido. |
| **codigo_controle** | `varchar(64)` | ✔️ Sim | `NULL` | Hash | Hash MD5/SHA256 para validação e autenticidade do recibo. |
| **valor_concedido** | `double(10,2)` | ✔️ Sim | `NULL` | Monetário | Valor financeiro total alocado para o processo. |
| **instituicao_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID da instituição principal vinculada. |
| **polo_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID do polo executor/vinculado. |
| **unidade_instituicao** | `varchar(300)` | ✔️ Sim | `NULL` | | Departamento, laboratório, núcleo ou centro interno. |
| **step** | `int` | ❌ Não | `1` | | Etapa/Passo atual do formulário de submissão. |
| **created_at** | `timestamp` | ✔️ Sim | `NULL` | Auditoria | Data de criação do registro no banco de dados. |
| **updated_at** | `timestamp` | ✔️ Sim | `NULL` | Auditoria | Data da última modificação do registro. |
| **deleted_at** | `timestamp` | ✔️ Sim | `NULL` | Auditoria | Data de exclusão lógica (Soft Delete). |
| **data_assinatura** | `timestamp` | ✔️ Sim | `NULL` | Data/Hora | Data da assinatura digital do contrato/termo. |
| **numero_sei** | `varchar(30)` | ✔️ Sim | `NULL` | Integração | Número do processo gerado no Sistema Eletrônico de Informações. |
| **programa_institucional_id**| `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID do programa institucional associado (on delete: null).|
| **relacao_bens_assinado_path**| `varchar(500)` | ✔️ Sim | `NULL` | Armazenamento | Caminho físico/S3 do arquivo de relação de bens. |
| **conta_exclusiva** | `varchar(50)` | ✔️ Sim | `NULL` | Financeiro | Número da conta bancária criada exclusivamente para o projeto.|
| **agencia_exclusiva** | `varchar(20)` | ✔️ Sim | `NULL` | Financeiro | Agência bancária da conta exclusiva. |
| **banco_exclusivo_id** | `int unsigned` | ✔️ Sim | `NULL` | **FK** | ID da instituição bancária (on delete: null). |
| **conta_exclusiva_pdf_path** | `varchar(500)` | ✔️ Sim | `NULL` | Armazenamento | Caminho de armazenamento do comprovante da conta em PDF. |
| **conta_exclusiva_pdf_nome** | `varchar(255)` | ✔️ Sim | `NULL` | Meta | Nome original do arquivo PDF anexado. |

---

### 3. Chaves e Índices (Keys & Indexes)

| Nome do Índice | Tipo | Coluna(s) | Comportamento / Propósito |
| :--- | :--- | :--- | :--- |
| `PRIMARY` | BTREE | `id` | Chave primária clusterizada da tabela. |
| `uq_processos_sigla` | UNIQUE | `sigla` | Garante a não duplicidade de siglas no sistema. |
| `processos_user_id_foreign` | KEY | `user_id` | Otimização de busca e junção com a tabela `users`. |
| `processos_edital_chamada_id_foreign` | KEY | `edital_chamada_id` | Otimização de busca de processos por edital. |
| `processos_edital_chamada_faixa_id_foreign`| KEY | `edital_chamada_faixa_id`| Filtros por faixa de edital. |
| `processos_orientador_id_foreign` | KEY | `orientador_id` | Performance na listagem por Orientador. |
| `processos_supervisor_id_foreign` | KEY | `supervisor_id` | Performance na listagem por Supervisor. |
| `processos_area_id_foreign` | KEY | `area_id` | Agrupamentos por Grandes Áreas de Conhecimento. |
| `processos_sub_area_id_foreign` | KEY | `sub_area_id` | Filtros por subáreas. |
| `processos_instituicao_id_foreign` | KEY | `instituicao_id` | Cruzamento de dados institucionais. |
| `processos_polo_id_foreign` | KEY | `polo_id` | Segmentação geográfica ou por polos. |
| `processos_programa_institucional_id_foreign`| KEY | `programa_institucional_id`| Filtros por programas institucionais vinculados. |
| `processos_quota_indicador_id_foreign` | KEY | `quota_indicador_id` | Performance em auditorias de cotas. |
| `processos_banco_exclusivo_id_foreign` | KEY | `banco_exclusivo_id` | Relatórios financeiros por banco. |

---

### 4. Relacionamentos e Integridade (Foreign Keys)

> ⚠️ **Nota de Arquitetura:** As chaves estrangeiras apontadas para a tabela `users` representam múltiplos papéis (Roles) que um usuário pode exercer no fluxo (Proponente, Orientador, Supervisor, Indicador de Cota).

| Nome da Constraint | Coluna Local | Tabela Estrangeira | Coluna Estrangeira | Comportamento On Delete / On Update |
| :--- | :--- | :--- | :--- | :--- |
| `processos_user_id_foreign` | `user_id` | `users` | `id` | RESTRICT / RESTRICT |
| `processos_orientador_id_foreign` | `orientador_id` | `users` | `id` | RESTRICT / RESTRICT |
| `processos_supervisor_id_foreign` | `supervisor_id` | `users` | `id` | RESTRICT / RESTRICT |
| `processos_quota_indicador_id_foreign` | `quota_indicador_id`| `users` | `id` | **SET NULL** / RESTRICT |
| `processos_edital_chamada_id_foreign` | `edital_chamada_id` | `edital_chamadas` | `id` | RESTRICT / RESTRICT |
| `processos_edital_chamada_faixa_id_foreign`| `edital_chamada_faixa_id`| `edital_chamada_faixas`| `id` | RESTRICT / RESTRICT |
| `processos_area_id_foreign` | `area_id` | `areas` | `id` | RESTRICT / RESTRICT |
| `processos_sub_area_id_foreign` | `sub_area_id` | `sub_areas` | `id` | RESTRICT / RESTRICT |
| `processos_instituicao_id_foreign` | `instituicao_id` | `instituicoes` | `id` | RESTRICT / RESTRICT |
| `processos_polo_id_foreign` | `polo_id` | `polos` | `id` | RESTRICT / RESTRICT |
| `processos_banco_exclusivo_id_foreign` | `banco_exclusivo_id`| `bancos` | `id` | **SET NULL** / RESTRICT |
| `processos_programa_institucional_id_foreign`| `programa_institucional_id`| `programas_instituicao`| `id` | **SET NULL** / RESTRICT |

---

### 5. Observações Especiais e Padrões de Negócio
* **Polimorfismo:** As colunas `processotabela_id` e `processotabela_type` indicam uma relação polimórfica no nível de aplicação. O mapeamento do ORM deve tratar se o processo pertence dinamicamente a uma instituição ou a um polo de forma exclusiva através da string gravada na coluna `_type`.
* **Segurança de Dados (LGPD):** Campos como `justificativa`, `resumo` e os caminhos de arquivos anexados podem conter dados intelectuais sensíveis ou dados pessoais. Recomenda-se aplicar mascaramento de dados se clonados para ambientes de Staging/Homologação.