# Integração de Contexto: API SIGEF (SEPLAN/MA) & Patronage (FAPEMA)

Este documento estabelece as diretrizes e requisitos técnicos para a expansão do escopo do PRD (Product Requirement Document), integrando o fluxo de dados entre o sistema **Patronage** (gestão de bolsas e auxílios da FAPEMA) e o sistema **SIGEF** (Sistema Integrado de Planejamento e Gestão Financeira do Estado do Maranhão, mantido pela SEPLAN).

O objetivo desta integração é permitir o monitoramento de saldos, conciliação de pagamentos e rastreabilidade total de movimentações financeiras diretamente na plataforma Patronage.

---

## 1. Escopo e Objetivos da Integração

O PRD deverá considerar o mapeamento e a implementação dos endpoints da API do SIGEF necessários para atender a três frentes principais:

1. **Gestão de Saldos e Contas**: Obter dados cadastrais das contas bancárias da FAPEMA e seus respectivos saldos atualizados em tempo real ou em cargas programadas.
2. **Monitoramento de Créditos e Movimentações**: Rastrear transações de créditos recebidos nessas contas e quaisquer transferências/movimentações efetuadas entre as contas da própria instituição.
3. **Conciliação Financeira de Bolsas e Auxílios**: Validar e conciliar os pagamentos de bolsas e auxílios de estudo processados no SIGEF com os registros internos do Patronage.

## 2. Regra de Associação de Registros (Chave Composta)

Para garantir a integridade da conciliação e o correto de-para entre os dois sistemas, o mapeamento de transações de pagamento no SIGEF deve, obrigatoriamente, utilizar a seguinte chave composta para identificação unívoca dos registros:

$$\text{Chave Composta} = \text{ID do Edital} + \text{CPF do Proponente}$$

Esta chave será o elo de ligação para atualizar o status de pagamento de cada beneficiário dentro do Patronage a partir dos retornos gerados pelo SIGEF.

## 3. Endpoints e Mapeamento da API

A definição técnica exata dos endpoints da API do SIGEF que cobrem os requisitos de saldos, transações, créditos e pagamentos de auxílios já foi consolidada e deve ser consultada diretamente no arquivo de mapeamento técnico do projeto:

*   **Arquivo de Referência:** `docs/sigef_api_mapeamento_patronage.md`

O BMad e o time de produto devem cruzar as regras de negócio descritas neste PRD com os respectivos contratos e schemas de payload documentados no arquivo supracitado para desenhar os fluxos de integração e as histórias de usuário correspondentes.

---
*Nota: Este arquivo deve ser incorporado à documentação viva do projeto para que o BMad/Time de Produto ajuste a arquitetura de dados e as regras de negócio.*