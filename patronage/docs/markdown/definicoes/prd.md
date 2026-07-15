# PRD 

## 8. Questoes em Aberto

### Qual o crescimento mensal das principais tabelas (a volumetria baseline atual ja foi registrada na secao 6.4)?

Resposta: crescimento mensal de 5-7%.

### Qual a janela operacional exata para execucao das cargas ETL diarias (D+1)?

Resposta: 2h (duas horas), iniciando as 5h e com final previsto para as 7h. As 8h tudo devera estar atualizado, curado e disponivel.

### Quais regras obrigatorias de mascaramento e pseudonimizacao LGPD por dominio?

Resposta: Vão usar as regras vigentes em legislacao, já cobertas na aplicação Patronage em produção. 

### Qual estrategia preferencial de orquestracao ETL (SQL nativo, jobs, Python, outra)?

Resposta: Utilização de JOBs para automação dos dados do SIGEF, via API, gravando dados para o banco de dados MySQL on-premise.
Demais artefatos serão acessados via SQL em schema específico a ser criado para a aplicação analytics e BI.

### Os tres paineis mandatarios propostos em 6.3 estao aprovados sem ajustes?

Resposta: Ainda aguardando validação.