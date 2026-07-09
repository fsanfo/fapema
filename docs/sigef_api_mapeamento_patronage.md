# Mapeamento de Endpoints da API do SIGEF (SEPLAN-MA) para Integração com o Patronage

Com base na documentação do Swagger da API do SIGEF (SEPLAN-MA), foram identificados os endpoints mais estratégicos para realizar a integração com o Patronage, tanto para o **monitoramento de saldos e contas** quanto para a **conciliação bancária e de pagamentos**.

---

## 1. Monitoramento de Contas e Saldos Atualizados

Para obter a listagem de contas da FAPEMA, verificar saldos atuais e acompanhar a movimentação contábil/financeira de débito e crédito, utilize:

*   **`GET /sigef/contas/` (operationId: `sigef_contas_list`)**
    *   **O que faz:** Retorna dados detalhados de contas contábeis filtrados por período (`datainicio`/`datafim`) e pelo número da conta contábil (`cdcontacontabil`).
    *   **Relevância para o Patronage:** O objeto de retorno (`Contas`) possui campos fundamentais como `nucontacorrente` (número da conta corrente), `vldebito`, `vlcredito` e o **`vlsaldo`**. É o endpoint ideal para monitorar a saúde financeira das contas da FAPEMA.
*   **`GET /sigef/razao/` (operationId: `sigef_razao_list`)**
    *   **O que faz:** Retorna o razão contábil filtrado por período e conta contábil por meio de consulta SQL dinâmica.
    *   **Relevância para o Patronage:** Permite auditar e rastrear detalhadamente o histórico de lançamentos de uma conta específica para entender a origem de cada movimentação.
*   **`GET /sigef/contacontabil/` (operationId: `sigef_contacontabil_list`)**
    *   **O que faz:** Retorna o plano/lista de contas contábeis cadastradas filtradas por `ano`.
    *   **Relevância para o Patronage:** Útil para mapear os códigos (`cdcontacontabil`) e nomes das contas que a FAPEMA utiliza no SIGEF.

---

## 2. Acompanhamento e Conciliação de Pagamentos de Bolsas e Auxílios

Para cruzar as ordens de pagamento emitidas no SIGEF com os registros de concessão do Patronage, os seguintes endpoints de execução financeira são os mais indicados:

*   **`GET /sigef/ordembancaria/` (operationId: `sigef_ordembancaria_list`)**
    *   **O que faz:** Retorna as Ordens Bancárias (OB) filtradas por período (`datainicio`/`datafim`) e opcionalmente por número da ordem bancária ou subação.
    *   **Relevância para o Patronage:** Este é o **principal endpoint para conciliação**. O esquema de retorno (`OrdemBancaria`) traz dados vitais dos pagamentos como:
        *   `dtpagamento` e `dttransacao`.
        *   `vltotal` (valor pago).
        *   `domicilio_origem` e `domicilio_destino` (para identificar as contas envolvidas).
        *   `cdcredor` e `nmcredor` (para bater com o favorecido).
        *   `cdsituacaoordembancaria` (para validar se o pagamento foi efetivado).
*   **`GET /sigef/ordemcronologica/` (operationId: `sigef_ordemcronologica_list`)**
    *   **O que faz:** Retorna a fila e o histórico de pagamentos realizados extraídos do ClickHouse.
    *   **Relevância para o Patronage:** Contém o campo **`cpf_cnpj`** diretamente no nó principal do objeto (`OrdemCronologica`), além de `valor_pago` e `data_pagamento`. É um excelente ponto alternativo para auditoria de desembolsos por beneficiário. *(Nota: requer liberação de acesso restrito junto ao administrador).*
*   **`GET /sigef/execucaofinanceiranl/` (operationId: `sigef_execucaofinanceiranl_list`)**
    *   **O que faz:** Retorna a execução financeira das Notas de Lançamento (NL), detalhando o `valor_nl` e o `valor_pago`.
    *   **Relevância para o Patronage:** Permite verificar se o valor empenhado e liquidado para a bolsa foi integralmente pago.

---

## 3. Créditos Recebidos e Outras Movimentações

*   **`GET /sigef/guiarecebimento/` (operationId: `sigef_guiarecebimento_list`)**
    *   **O que faz:** Retorna as guias de recebimento registradas no sistema filtradas por ano e unidade gestora.
    *   **Relevância para o Patronage:** Se as contas da FAPEMA receberem aportes, estornos de bolsas não utilizadas ou créditos via Guia de Recebimento, este endpoint trará o valor (`vlguiarecebimento`), a conta (`conta`) e o evento associado.

---

## Estratégia de Conciliação com a Chave (`ID Edital` + `CPF`)

Como a API do SIGEF é estruturada sobre a ótica da contabilidade pública (Unidade Gestora, Empenho, Liquidação e Pagamento), ela não possui um campo explícito chamado "ID Edital". Para realizar o batimento usando a sua regra de negócio, adote o seguinte fluxo:

1.  **Mapeamento por Subação ou Processo:** Geralmente, editais específicos de pesquisa ou grandes blocos de bolsas são vinculados a uma **Subação Orçamentária (`cdsubacao`)** ou a um **Número de Processo (`nuprocesso`)** no SIGEF. Ao listar as ordens bancárias (`/sigef/ordembancaria/`), você pode filtrar ou agrupar os resultados pela subação correspondente ao Edital.
2.  **Batimento pelo CPF (Credor):** O proponente da bolsa constará no SIGEF como o **Credor** da despesa. 
    *   Na resposta de `/sigef/ordembancaria/`, utilize o campo **`cdcredor`** (que costuma armazenar o CPF/CNPJ do favorecido) para localizar o proponente.
    *   Alternativamente, você pode usar o endpoint **`GET /sigef/credor/`** para cruzar o `cpf_cnpj` com o código interno do credor (`cdcredor`) e usar esse ID para varrer os pagamentos.

**Resumo da regra de conciliação no seu código:**
```text
Patronage (ID Edital -> cdsubacao/nuprocesso) + (CPF Proponente -> cdcredor) 
   == 
SIGEF (/sigef/ordembancaria/ onde subacao = X e cdcredor = CPF)
```
