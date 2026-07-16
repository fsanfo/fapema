# Checklist LGPD por Entidade Analitica — patronage_analytics

## Status geral desta rodada
Por decisao explicita do solicitante (registrada em `ctl_lgpd_pendencias`,
script `02_controle_auditoria.sql`), **nenhum mascaramento foi aplicado** nas
Fases 1-3. Este checklist documenta o risco de forma auditável e da a base
para uma decisao formal de governanca antes de o schema ir para producao
com usuarios reais além da equipe tecnica.

## Como ler este checklist
- **Classificacao**: identificador direto / dado sensivel (LGPD Art. 5, II) / dado financeiro / dado institucional (baixo risco).
- **Superficie de exposicao**: quais views/tabelas expõem o campo hoje.
- **Acao recomendada**: o que fazer quando a governanca decidir tratar o risco.

## 1. Identidade (`dim_usuario`)

| Campo | Classificacao | Exposto em | Acao recomendada |
|---|---|---|---|
| `documento` (CPF/passaporte) | Identificador direto | `dim_usuario`, `vw_painel_operacional_processos`, `vw_painel_conciliacao_*`, `ponte_proponente_credor_sigef` | Mascaramento parcial (`***.XXX.XXX-**`) nas views de consumo geral; manter dado pleno apenas em tabela vault com acesso restrito por role para auditoria/financeiro |
| `nome`, `social_name` | Dado pessoal | `dim_usuario` e views que fazem JOIN | Exibicao integral apenas para perfis com necessidade de identificacao (auditoria, financeiro); demais perfis veem iniciais ou pseudonimo |
| `data_nascimento`, `sexo`, `etnia`, `deficiencia_fisica`, `nacionalidade` | Dado sensivel (Art. 5, II) | `dim_usuario` (nao exposto em nenhuma view atual, mas presente na tabela base) | Nao replicar para a camada analitica, exceto se houver KPI de equidade/inclusao explicitamente aprovado — nesse caso, agregar (nunca expor por individuo) |
| `nome_pai`, `nome_mae`, `telefone`, `celular1`, `celular2` | Dado pessoal | `dim_usuario` (nao exposto em views) | Remover da camada analitica — nao ha KPI documentado que precise desses campos; foram replicados apenas porque a Landing espelha a origem |
| `banco_id`, `agencia`, `conta` | Dado financeiro pessoal | `dim_usuario` (nao exposto em views) | Remover da camada analitica pelo mesmo motivo acima, ou tokenizar se algum KPI futuro precisar validar dados bancarios |

## 2. Reconciliacao SIGEF x Patronage

| Campo | Classificacao | Exposto em | Acao recomendada |
|---|---|---|---|
| `cpf_cnpj` (ponte_proponente_credor_sigef) | Identificador direto | Tabela ponte (uso interno, nao exposta diretamente em view) | Mascaramento parcial se alguma view futura expuser esta tabela diretamente |
| `cdcredor`, `cpf_cnpj_credor` (fato_financeiro_sigef) | Identificador direto | Tabela fato (uso interno) | Mesma recomendacao acima |
| `payload_raw` (lnd_sigef_*) | Pode conter identificadores diretos no JSON bruto | Landing (uso interno, retencao para auditoria) | Definir politica de retencao (ex.: expurgar apos N meses) e restringir acesso de leitura a essa coluna por role |

## 3. Instituicoes (`dim_instituicao`)
CNPJ e demais dados sao institucionais, nao pessoais — **risco baixo**, sem
acao de mascaramento necessaria. Mantido no checklist apenas para registro
de que foi avaliado.

## 4. Eventos operacionais (`fato_eventos_operacionais_diario`)
Já agregado (nao ha identificador individual na tabela fato — `causer_id` e
usado apenas para contagem `COUNT(DISTINCT)` na Landing, nao replicado como
coluna no fato). **Risco baixo por desenho.**

## 5. Acoes de curto prazo recomendadas (independente da decisao sobre mascaramento pleno)
1. **Remover da Landing/dim_usuario os campos sem uso analitico confirmado**: `nome_pai`, `nome_mae`, `telefone`, `celular1`, `celular2`, `banco_id`, `agencia`, `conta`, `deficiencia_fisica`, `etnia`, `data_nascimento`, `sexo`, `nacionalidade`. Nenhum KPI do escopo minimo (4 paineis) usa esses campos — foram trazidos apenas porque a Landing espelha `user_infos` por completo. Minimizacao de dados (Art. 6, III da LGPD) recomenda nao replicar o que nao e usado.
2. **Definir o dono da decisao de mascaramento** (DPO institucional ou equivalente) e preencher `ctl_lgpd_pendencias.responsavel_decisao`.
3. **Definir politica de retencao para `payload_raw` (JSON)** nas tabelas `lnd_sigef_*`, que podem conter dados pessoais no payload bruto da API.
4. **Avaliar necessidade de log de acesso** as views que expõem CPF (`vw_painel_operacional_processos`, `vw_painel_conciliacao_*`) para atender ao principio de responsabilizacao (Art. 6, X).

## 6. O que NAO fizemos e por que
Nao implementamos mascaramento, hashing ou tokenizacao nesta rodada porque
foi uma decisao explicita do solicitante (ver historico da conversa e
`ctl_lgpd_pendencias`). Se essa decisao mudar, o ponto de menor esforço para
aplicar mascaramento é nas **views** (`vw_*`), sem precisar alterar as
tabelas fato/dimensao — por exemplo, trocar `prop.documento` por
`CONCAT('***.', SUBSTRING(prop.documento,4,3), '.', SUBSTRING(prop.documento,7,3), '-**')`
nas views que hoje expõem o CPF em texto claro.
