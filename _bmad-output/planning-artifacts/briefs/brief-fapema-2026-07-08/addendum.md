---
title: Addendum - FAPEMA Patronage Analytics
status: draft
created: 2026-07-08
updated: 2026-07-08
---

# Addendum: FAPEMA Patronage Analytics

## 1) Hipotese Inicial de Fatos Analiticos

- Fato de chamadas (edital_chamadas): quantidade de chamadas, publicadas x nao publicadas, janelas de inscricao e recurso.
- Fato de editais (editais): quantidade por tipo, caracteristica, personalidade juridica e uso.
- Fato de convenios (convenios): convenios por tipo, vigencia, status de relatorios e prestacao.
- Fato de atividades (atividades): quantidade e duracao de atividades por processo.
- Fato de eventos de sistema (activity_log): eventos por tipo, modulo e ator.

## 2) Hipotese Inicial de Dimensoes

Dimensoes principais:
- Tempo (dia, mes, trimestre, semestre, ano).
- Edital.
- Chamada.
- Tipo de instrumento (bolsa, auxilio, convenio etc.).
- Situacao/publicacao.

Dimensoes secundarias:
- Usuario/perfil (com anonimizacao conforme LGPD).
- Setor e modalidade.
- Area/subarea (quando aplicavel).
- Origem do evento (subject_type, causer_type no activity_log).

## 3) Sugestao Inicial de KPIs (a validar)

- Taxa de chamadas publicadas por periodo.
- Tempo medio entre criacao e fechamento de chamada.
- Distribuicao de editais por tipo/caracteristica.
- Percentual de convenios com relatorio parcial/final no prazo.
- Duracao media de atividades por processo.
- Taxa de eventos de retrabalho (ex.: alteracoes recorrentes no mesmo objeto).

## 4) Regras de Governanca Recomendadas

- Catalogo unico de metricas com definicao de owner por indicador.
- Versionamento de regras de calculo dos KPIs.
- Trilha de auditoria de cargas ETL com contagem de linhas por lote.
- Politica de minimizacao de dados pessoais no schema analitico.

## 5) Pendencias para PRD

- Confirmar SLAs de atualizacao dos dados (frequencia e janela).
- Confirmar volumetria e estrategia de particionamento.
- Definir criterios de mascaramento e pseudonimizacao.
- Definir primeiro pacote de dashboards para homologacao do PO.
