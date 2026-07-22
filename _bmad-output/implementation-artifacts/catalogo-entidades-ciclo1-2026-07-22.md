---
artifact: catalogo-entidades-prioritarias
story_id: 1.1
version: 0.2
status: draft
updated_at: 2026-07-22
---

# Catalogo de Entidades Prioritarias - Ciclo 1

## Objetivo

Consolidar entidades e relacionamentos prioritarios de Patronage e SIGEF para suportar modelagem analitica e conciliacao financeira.

## Criterios de Priorizacao

- Impacto direto em Conciliacao e Executivo (ciclo 1).
- Disponibilidade e qualidade minima dos dados na origem.
- Possibilidade de correlacao por ID do edital + CPF.

## Inventario Base

| Entidade | Sistema de origem | Dominio | Prioridade | Chave tecnica principal | Chaves de correlacao | Periodicidade | Dono funcional | Observacoes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| editais | Patronage | edital | alta | id | id | diaria (D+1) | PO/gestao | fonte mestre de identificacao de edital |
| edital_chamadas | Patronage | chamada | alta | id | edital_id | diaria (D+1) | PO/gestao | ponte entre chamada e edital |
| processos | Patronage | solicitacoes/processo | alta | id | edital_chamada_id + user_id | diaria (D+1) | PO/gestao | contem referencia de edital_chamada e usuario |
| users | Patronage | pessoa | alta | id | documento (CPF quando tipo_documento=1) | diaria (D+1) | PO/gestao | campo documento usado para CPF |
| creditos | Patronage | financeiro | alta | id | processo_id | diaria (D+1) | PO/gestao | valores concedidos por processo |
| credito_processos | Patronage | financeiro | media | id | processo_id/processoscredito_id | diaria (D+1) | PO/gestao | complemento de credito por processo |
| chamada_dados_contratacao | Patronage | contratacao | media | id | edital_chamada_id | diaria (D+1) | PO/gestao | janela de contratacao e valor_bolsa |
| chamada_execucoes | Patronage | execucao | media | id | edital_chamada_id | diaria (D+1) | PO/gestao | etapas e datas de execucao por chamada |
| pagamentos_sigef | SIGEF | financeiro | alta | identificador_pagamento | edital + cpf_proponente | diaria (D+1) | financeiro | entidade externa; schema pendente de anexo |
| saldos_sigef | SIGEF | financeiro | alta | identificador_saldo | edital + cpf_proponente | diaria (D+1) | financeiro | entidade externa; schema pendente de anexo |
| processo_sigef/subacao | SIGEF | processo/subacao | alta | numero_processo/subacao | edital + cpf_proponente | diaria (D+1) | financeiro | entidade externa; schema pendente de anexo |

## Relacionamentos Prioritarios

| Entidade A | Entidade B | Tipo | Regra de associacao | Criticidade |
| --- | --- | --- | --- | --- |
| editais | edital_chamadas | 1:N | editais.id = edital_chamadas.edital_id | alta |
| edital_chamadas | processos | 1:N | edital_chamadas.id = processos.edital_chamada_id | alta |
| processos | users | N:1 | processos.user_id = users.id | alta |
| processos | creditos | 1:N | processos.id = creditos.processo_id | alta |
| processos | credito_processos | 1:N | processos.id = credito_processos.processo_id | media |
| edital_chamadas | chamada_dados_contratacao | 1:N | edital_chamadas.id = chamada_dados_contratacao.edital_chamada_id | media |
| edital_chamadas | chamada_execucoes | 1:N | edital_chamadas.id = chamada_execucoes.edital_chamada_id | media |
| processos+users+editais | pagamentos_sigef/saldos_sigef | N:N logico | correlacao por edital (normalizado) + CPF (normalizado) + periodo | alta |

## Evidencias de Schema (Patronage)

- patronage/ddls/editais.sql: tabela editais (id, numero, ano).
- patronage/ddls/edital_chamadas.sql: tabela edital_chamadas (id, edital_id, numero).
- patronage/ddls/processos.sql: tabela processos (id, edital_chamada_id, user_id, valor_concedido, numero_sei).
- patronage/ddls/users.sql: tabela users (id, tipo_documento, documento).
- patronage/ddls/creditos.sql: tabela creditos (id, credito, processo_id, status).
- patronage/ddls/credito_processos.sql: tabela credito_processos (id, processo_id, processoscredito_id, custeio, capital).
- patronage/ddls/chamada_dados_contratacao.sql: tabela chamada_dados_contratacao (id, edital_chamada_id, valor_bolsa).
- patronage/ddls/chamada_execucoes.sql: tabela chamada_execucoes (id, edital_chamada_id, etapa_id, data_inicio, data_fim).

## Pendencias em Aberto

- Definir donos funcionais nominais por entidade com PO/gestao.
- Anexar schema oficial SIGEF para pagamentos, saldos e processo/subacao.
- Validar regra de de-para edital Patronage x subacao/processo SIGEF.
- Confirmar recorte temporal e granularidade por entidade para KPI.
- Confirmar politica de mascaramento de CPF na camada de consumo geral.

## Itens que Exigem Decisao Humana

- Dono funcional nomeado para cada entidade prioritaria.
- Regra oficial de de-para entre edital e subacao/processo SIGEF.
- Definicao de qual coluna oficial de CPF chega do SIGEF e seu formato.
- Definicao de SLA para curadoria de excecoes sem match.

## Aprovacao Funcional

- Responsavel pelo aceite: ____________________
- Data: ____/____/2026
- Decisao: aprovado | ressalvas | reprovado | pendente
- Observacoes: _______________________________________________
