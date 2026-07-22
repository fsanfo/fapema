---
artifact: regra-correlacao-edital-cpf
story_id: 1.1
version: 0.2
status: draft
updated_at: 2026-07-22
---

# Regra de Correlacao Patronage x SIGEF por Edital + CPF

## Objetivo

Definir a regra oficial de correlacao entre registros de Patronage e SIGEF para conciliacao financeira no ciclo 1.

## Regra Principal

A correlacao base deve utilizar a chave composta:

- id_edital (ou equivalente funcional de edital/subacao/processo)
- cpf_proponente (normalizado)

Representacao logica:

join_key = normalizar(id_edital) + '|' + normalizar(cpf_proponente)

## Caminho de Chave no Patronage (validado em DDL)

- edital: editais.id
- chamada: edital_chamadas.id com FK edital_chamadas.edital_id -> editais.id
- processo: processos.id com FK processos.edital_chamada_id -> edital_chamadas.id
- proponente: users.id com FK processos.user_id -> users.id
- cpf: users.documento quando users.tipo_documento = '1'

Representacao logica Patronage:

join_key_patronage = normalizar(editais.id ou editais.numero/ano, conforme regra final) + '|' + normalizar(users.documento)

## Regras de Normalizacao

- CPF:
  - remover caracteres nao numericos;
  - validar comprimento de 11 digitos;
  - preservar sem mascaramento apenas na camada restrita;
  - aplicar mascaramento na camada de consumo geral.
- Edital/Subacao/Processo:
  - remover espacos laterais;
  - padronizar caixa e delimitadores;
  - aplicar tabela de-para versionada quando houver codificacoes distintas entre sistemas.

## Regras de Match

- Match exato: id_edital normalizado e cpf normalizado iguais nos dois sistemas.
- Match por de-para: quando edital em Patronage mapear para subacao/processo em SIGEF via tabela de-para oficial.
- Sem match: quando nao houver correspondencia apos normalizacao e consulta do de-para.

## Fontes de Evidencia (DDL Patronage)

- patronage/ddls/editais.sql
- patronage/ddls/edital_chamadas.sql
- patronage/ddls/processos.sql
- patronage/ddls/users.sql

## Classificacao de Divergencias

- ausencia_no_sigef: existe no Patronage e nao existe no SIGEF.
- ausencia_no_patronage: existe no SIGEF e nao existe no Patronage.
- diferenca_valor: match de chave com valor financeiro divergente.
- diferenca_status: match de chave com status de pagamento divergente.

## Tratamento de Excecoes

- Registros sem correspondencia confiavel devem ir para fila de excecao versionada.
- Nao consolidar no painel executivo enquanto excecao critica estiver aberta sem aceite funcional.

## Pontos em Aberto para Decisao Humana

- Definir se a chave de edital para conciliacao sera editais.id ou combinacao editais.numero + editais.ano.
- Definir estrutura oficial do identificador equivalente no SIGEF (subacao/processo).
- Definir regra para casos em que users.tipo_documento != '1' (passaporte) no ciclo 1.
- Definir criterio de fallback para match parcial quando faltar um dos componentes da chave.

## Evidencias de Auditoria

- lote_referencia
- data_execucao
- fonte_origem
- regra_aplicada
- tipo_divergencia
- usuario_responsavel_curadoria

## Aprovacao Funcional

- Responsavel pelo aceite: ____________________
- Data: ____/____/2026
- Decisao: aprovado | ressalvas | reprovado | pendente
- Observacoes: _______________________________________________
