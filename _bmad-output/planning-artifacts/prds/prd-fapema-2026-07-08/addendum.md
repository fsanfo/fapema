---
title: Addendum Tecnico - PRD FAPEMA Patronage Analytics
status: final
created: 2026-07-08
updated: 2026-07-13
---

# Addendum Tecnico

## 1. Hipotese de Arquitetura de Dados

- Origem: banco transacional Patronage (MySQL 8.0.34).
- Camadas iniciais: Landing e Curated, com avaliacao posterior para evolucao ao modelo Medalhao (bronze/prata/ouro).
- Modelo de consumo: Star Schema com dimensoes conformadas e fatos por dominio prioritario.

## 2. Hipotese de Fatos e Dimensoes Iniciais

Fatos candidatos:
- Fato de editais.
- Fato de chamadas (edital_chamadas e tabelas relacionadas de chamada).
- Fato de convenios.
- Fato de atividades/processos.
- Fato de conciliacao financeira Patronage x SIGEF para pagamentos de bolsas e auxilios.
- Fato de eventos operacionais (activity_log) para qualidade e rastreabilidade.

Dimensoes candidatas:
- Tempo.
- Edital.
- Chamada.
- Beneficiario/Proponente (com CPF tratado segundo regras LGPD).
- Tipo de instrumento.
- Situacao/publicacao.
- Setor/modalidade.
- Usuario/perfil (com controles de LGPD).

Regra de identidade e reconciliacao:
- Chave composta funcional obrigatoria: ID do edital + CPF do proponente.
- No SIGEF, o elo operacional esperado usa o mapeamento de edital para subacao ou numero de processo e o CPF/CNPJ do favorecido para o credor correspondente.
- Registros sem de-para confiavel entram em fila de excecao versionada para curadoria funcional antes de qualquer consolidacao executiva.

## 3. Governanca de Dados e LGPD

- Definir classificacao de dados pessoais por dominio antes da exposicao analitica.
- Aplicar minimizacao e mascaramento/pseudonimizacao onde cabivel.
- Criar trilha de auditoria de cargas por lote (quantidade, horario, status e rejeicoes).

## 4. Decisoes Tecnicas em Aberto

- Estrategia de orquestracao ETL confirmada: jobs para automacao dos dados SIGEF via API com gravacao em MySQL on-premise; demais artefatos por SQL em schema analytics/BI.
- Endpoints de maior prioridade para o recorte funcional SIGEF: ordembancaria, ordemcronologica e credor, conforme mapeamento tecnico vigente.
- Janela de refresh confirmada: batch diario (D+1), inicio as 5h, finalizacao ate 7h e disponibilidade curada ate 8h.
- Estrategia de particionamento e retenao para tabelas volumosas.
- Estrategia de embed de paineis no ecossistema Laravel.

## 5. Mapeamento Inicial de Riscos

- Risco de indisponibilidade de janela de carga adequada.
- Risco de inconsistencias historicas em dominios sem governanca formal previa.
- Risco de sobrecarga de escopo por tentativa de cobrir todos os indicadores na fase 1.
- Risco de baixa adocao se os paineis nao refletirem as perguntas reais dos decisores.
- Risco de colisao ou baixa confiabilidade no mapeamento entre edital do Patronage e subacao/processo equivalente no SIGEF.

Mitigacoes iniciais:
- Manter tabela versionada de de-para edital Patronage x subacao/processo SIGEF com responsavel funcional definido.
- Segregar registros sem correspondencia confiavel em fila de excecao auditavel por lote D+1.
