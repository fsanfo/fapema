# Patronage

## Definições Iniciais do Projeto

### Objetivo

Este documento visa escrever as definições iniciais do projeto de Analytics do ecossistema Patronage da FAPEMA para utilização no BMAD Method. PATRONAGE é a plataforma online da FAPEMA para gerenciar as bolsas e auxílios de pesquisa e desenvolvimento científico e tecnológico do Maranhão. 

### Premissas

1. A única documentação existente atualmente é relacionada ao SGBD
2. O SGDB do ecossistema é MySQL 8.0.34
3. A solução foi desenvolvida em Laravel, atualmente na versão 12
4. Todos os servidores são on-premises
5. O site é publicado na internet, sem proxy reverso, ou seja, o DNS aponta diretamente para o servidor da instituição
6. A documentação existente, bem como qualquer outra informação do projeto, encontra-se na pasta patronage

### O que vamos criar?

Na primeira fase do projeto, precisamos criar a camada de analytics.

A ideia inicial é entender o dicionário de dados para construir um ETL que sustente métricas e KPIs operacionais, gerenciais, de qualidade e performance.

A granularidade será anual, semestral, trimestral e mensal.

Devemos analisar na documentação quais são as principais desagregações entre as dimensões existentes para apresentá-las como segmentadores/filtros de dados principais e separar dos secundários que serão disponibilizados separadamente.

Vamos utilizar as melhores práticas de mercado para sugerir o storytelling, visuais, gráficos, o que for necessário para diminuir o esforço cognitivo dos usuários, tanto operacionais quanto do C-Level (chefe de gabinete, presidente, etc.)

O modelo indicado é o star-schema, onde cada tabela fato poderá compartilhar as dimensões existentes no projeto.

Se for relevante, factível e cabível, iremos utilizar o esquema de Medalhão (bronze, prata, ouro). Caso não seja necessário, criaremos uma camada para landing e uma para curated, para os artefatos finais serem consumidos nas aplicações.

### Pontos de Atenção

1. Por se tratar de uma empresa ligada ao Estado e haver várias informações sensíveis de pessoas físicas, deveremos adequar a solução conforme a LGPD.
2. As interfaces devem ser pensadas e criadas para o ambiente PHP, em Laravel, existente. Caso haja outras tecnologias que possam ser usadas e, posteriormente, "embeddadas" na aplicação, podemos também considerar, desde que tenha free tier.
3. Sempre faremos mockups de todas as interfaces em HTML, para apresentação ao Product Owner e a equipe de desenvolvimento.
4. Todo projeto deverá ser documentado em formato próprio, utilizando uma ferramenta free, como Swagger ou similar.
5. Temos acesso a um servidor de testes, onde poderemos criar um schema exclusivo para analytics e BI, bem como artefatos para nosso ETL (tabelas, visões, visões materializadas, stored procedures, jobs, etc.)