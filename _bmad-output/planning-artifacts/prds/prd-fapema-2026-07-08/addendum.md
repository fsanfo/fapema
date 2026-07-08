---
title: Addendum Tecnico - PRD FAPEMA Patronage Analytics
status: draft
created: 2026-07-08
updated: 2026-07-08
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
- Fato de eventos operacionais (activity_log) para qualidade e rastreabilidade.

Dimensoes candidatas:
- Tempo.
- Edital.
- Chamada.
- Tipo de instrumento.
- Situacao/publicacao.
- Setor/modalidade.
- Usuario/perfil (com controles de LGPD).

## 3. Governanca de Dados e LGPD

- Definir classificacao de dados pessoais por dominio antes da exposicao analitica.
- Aplicar minimizacao e mascaramento/pseudonimizacao onde cabivel.
- Criar trilha de auditoria de cargas por lote (quantidade, horario, status e rejeicoes).

## 4. Decisoes Tecnicas em Aberto

- Ferramenta/estrategia de orquestracao ETL (jobs SQL, procedures, Python ou combinacao).
- Estrategia de refresh confirmada: batch diario (D+1).
- Estrategia de particionamento e retenao para tabelas volumosas.
- Estrategia de embed de paineis no ecossistema Laravel.

## 5. Mapeamento Inicial de Riscos

- Risco de indisponibilidade de janela de carga adequada.
- Risco de inconsistencias historicas em dominios sem governanca formal previa.
- Risco de sobrecarga de escopo por tentativa de cobrir todos os indicadores na fase 1.
- Risco de baixa adocao se os paineis nao refletirem as perguntas reais dos decisores.
