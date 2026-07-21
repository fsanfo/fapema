# UX Design - FAPEMA (CU)

- Status: concluido
- Skill: bmad-ux (menu CU)
- Data de registro: 2026-07-17
- Contexto: mockups produzidos e iterados em duas versoes; versao vigente v2.

## Objetivo do artefato

Consolidar em texto o contrato de UX implicito nos mockups V2 para que PRD, epicos, arquitetura e a equipe do Patronage tenham uma referencia rastreavel unica de segmentadores, filtros e desagregacoes. Este documento nao substitui os mockups HTML; ele descreve as decisoes de experiencia, estrutura e homologacao ja representadas neles. A partir do reescopo de 2026-07-21, este time nao implementa mais a UI definitiva — o documento passa a ser consumido pela equipe do Patronage como contrato de referencia, priorizando os paineis de Conciliacao e Executivo no ciclo 1.

## Evidencias fonte

- Mockups v1: `patronage/docs/html/mockups/v1`
- Mockups v2 vigentes: `patronage/docs/html/mockups/v2`
- Entrada principal v2: `patronage/docs/html/mockups/v2/index.html`
- Design system compartilhado: `patronage/docs/html/mockups/v2/dashboard.css`
- Checklist de homologacao: `patronage/docs/html/mockups/v2/checklist-homologacao.html`

## Escopo de UX coberto

Este artefato cobre os quatro paineis mandatarios da fase 1 e a tela de checklist de homologacao:

- `painel-operacional-chamadas-editais.html`
- `painel-gerencial-convenios-execucao.html`
- `painel-conciliacao-sigef-patronage.html`
- `painel-executivo-kpis.html`
- `checklist-homologacao.html`

Prioridade do ciclo 1: `painel-conciliacao-sigef-patronage.html` (principal) e `painel-executivo-kpis.html` (secundaria). Os paineis operacional e gerencial permanecem documentados neste artefato como referencia, mas ficam fora do ciclo 1 e adiados para ciclo futuro.

## Direcao visual homologada

Os mockups V2 estabelecem uma linguagem editorial premium e nao generica, com estes pilares:

- Superficie de papel quente com sobreposicoes de vidro translucido.
- Acento terracota reservado para interacao, foco e assinatura visual.
- Paleta institucional FAPEMA mantida via tokens de marca azul primario e secundario.
- Tipografia display em `League Spartan` para titulos em caixa alta e `Poppins` para corpo, apoio e metadados.
- Cartoes, hero sections, sidebars e tabelas com bordas suaves, sombras profundas e hierarquia visual forte.

## Contrato de design system compartilhado

O arquivo `dashboard.css` define um sistema unico para todas as telas V2. A implementacao final deve preservar estes contratos:

### Tokens base

- Cores de marca: `--brand-primary`, `--brand-primary-dark`, `--brand-secondary`.
- Estados semanticos: sucesso, alerta, risco e informacao com pares de alto e baixo contraste.
- Tokens de superficie: `--paper`, `--panel`, `--panel-strong`, `--line`, `--shadow`.
- Tipografia: `--font-display` e `--font-body`.
- Raios e espacamentos consistentes com `--radius-xl`, `--radius-lg`, `--radius-md`, `--radius-sm`.

### Componentes compartilhados obrigatorios

- Shell de aplicacao com sidebar fixa e coluna principal.
- Marca institucional no topo da sidebar.
- Navegacao lateral com cinco destinos consistentes entre telas.
- Breadcrumb contextual na coluna principal.
- `meta-pill` para status e contexto da tela.
- Hero principal com resumo de contexto e metricas destacadas.
- Cartoes de KPI, tabelas e blocos contextuais com mesma semantica visual.
- Estados ativos e hover em links e chips com feedback visual claro.

## Arquitetura de informacao e navegacao

As cinco telas compartilham uma navegacao lateral fixa com esta ordem:

1. Visao geral
2. Painel Operacional
3. Painel Gerencial
4. Painel de Conciliacao
5. Painel Executivo
6. Checklist de Homologacao

Requisitos derivados:

- O usuario deve conseguir alternar entre todos os paineis sem perder contexto institucional.
- A navegacao lateral deve destacar a tela ativa.
- O breadcrumb deve mostrar o contexto atual do painel.
- O checklist deve ser acessivel a partir da mesma malha de navegacao e funcionar como fechamento do ciclo de validacao.

## Acessibilidade base obrigatoria

Os mockups V2 deixam explicitos requisitos minimos de acessibilidade que a implementacao nao pode regredir:

- Todas as paginas usam `lang="pt-BR"`.
- Existe `skip-link` para pular ao conteudo principal.
- O foco visivel usa contorno dedicado de alto contraste.
- A navegacao deve ser completamente operavel por teclado.
- Estados semanticos nao podem depender exclusivamente de cor.
- Tabelas e grupos de decisao devem manter rotulos suficientes para contexto e acao.

## Responsividade e comportamento adaptativo

Os mockups e o CSS definem responsividade como requisito de homologacao, nao como melhoria opcional:

- Layout principal baseado em grid com sidebar e conteudo, adaptando espacamento por `clamp`.
- Blocos de resumo precisam reorganizar colunas em larguras menores sem perda de leitura.
- Filtros, cards e acoes principais devem permanecer visiveis e acionaveis em desktop e mobile.
- Tabelas precisam preservar legibilidade com tratamento seguro para densidade e rolagem horizontal quando necessario.

## Requisitos transversais de interacao

- Filtros devem comunicar claramente a combinacao ativa e o contexto aplicado.
- KPIs e paineis devem exibir metadados de status relevantes para homologacao e leitura rapida.
- O checklist deve consolidar decisoes por item em resumo agregado automaticamente.
- O fluxo visual deve apoiar leitura executiva em poucos minutos, especialmente no painel C-Level.

## Requisitos por tela

### 1. Visao geral dos prototipos

Objetivo: funcionar como pagina de entrada da rodada de revisao dos mockups V2.

Requisitos:

- Explicar que os prototipos correspondem aos quatro paineis mandatarios do PRD e ao FR-6.
- Apresentar a linguagem visual da fase e orientar a navegacao para cada painel.
- Mostrar que os mockups pertencem ao ciclo de homologacao, nao a um front-end final ja operacional.

### 2. Painel Operacional de Chamadas e Editais

Objetivo: apoiar gestor operacional na leitura de volume, status, tempo medio e gargalos.

Requisitos:

- Manter filtros por periodo, edital, status e area.
- Evidenciar indicadores de volume, status e tempo medio de ciclo.
- Destacar gargalos por segmentador principal com semaforizacao.
- Preservar rastreabilidade entre filtro aplicado e leitura do resultado.

### 3. Painel Gerencial de Convenios e Execucao

Objetivo: apoiar leitura de carteira, vigencia, status de relatorios e aderencia a prazos.

Requisitos:

- Exibir carteira por tipo e vigencia dentro do recorte da fase 1.
- Evidenciar desvios de prazo com regra visual consistente.
- Permitir leitura gerencial rapida sem perder a origem analitica dos indicadores.

### 4. Painel de Conciliacao SIGEF x Patronage

Objetivo: apoiar analista financeiro na triagem de divergencias e excecoes.

Requisitos:

- Exibir divergencias por ausencia no SIGEF, ausencia no Patronage e diferenca de valor ou status.
- Mostrar referencia de lote D+1, data de carga e quantidade conciliada.
- Sinalizar explicitamente quando o lote estiver parcial, falho ou dependente de fonte externa.
- Preservar leitura orientada a auditoria e tratamento de excecao.

### 5. Painel Executivo C-Level

Objetivo: apoiar lideranca institucional em leitura consolidada dos KPIs prioritarios.

Requisitos:

- Exibir visao unica de KPIs institucionais prioritarios.
- Destacar tendencias, comparativos, alertas e semaforizacao executiva.
- Preservar fluxo de leitura que permita walkthrough executivo em ate 5 minutos.
- Manter forte hierarquia visual entre destaques, contexto e detalhes secundarios.

### 6. Checklist de Homologacao

Objetivo: registrar decisoes formais por criterio e por painel durante revisao com stakeholders e Product Owner.

Requisitos:

- Consolidar resumo da rodada com totais por decisao.
- Permitir decisao por item com estados `aprovado`, `ressalvas`, `reprovado` e `pendente`.
- Associar criterio, evidencia no mockup, responsavel provavel e observacoes SH/PO.
- Funcionar como artefato de transicao entre UX e arquitetura/implementacao.

## Rastreabilidade com PRD e epicos

### Vinculo com PRD

- FR-5: os quatro paineis mandatarios e seus criterios de homologacao sao refletidos nos mockups V2.
- FR-6: a existencia dos mockups HTML navegaveis e do checklist formaliza o ciclo de validacao anterior a implementacao definitiva.

### Vinculo com epicos

- Story 2.1: este documento confirma os contratos de design system e shell de navegacao.
- Story 2.2: este documento confirma os requisitos de acessibilidade e responsividade base.
- Stories 2.3 a 2.6: este documento descreve o comportamento e a intencao de cada painel mandatorio.
- Story 2.7: este documento confirma o contrato funcional do checklist de homologacao.

## Criticos para a equipe do Patronage considerar na implementacao

Para evitar divergencia entre mockup de referencia e tela final implementada pela equipe do Patronage, a implementacao deve preservar explicitamente:

- o shell compartilhado de navegacao;
- os tokens de marca e estados semanticos;
- o comportamento de foco, `skip-link` e navegacao por teclado;
- a responsividade da malha principal, cards e tabelas;
- a sinalizacao de status parcial ou bloqueante em conciliacao e homologacao;
- a consistencia de rotulagem entre os paineis priorizados (Conciliacao, Executivo) e o checklist.

Esta secao e uma recomendacao a ser comunicada a equipe do Patronage; a validacao final de aderencia e responsabilidade dela.

## Decisao para fluxo BMad

Este artefato substitui o registro resumido anterior como referencia textual de UX para o projeto. O CU permanece concluido. A partir do reescopo de 2026-07-21, o documento deixa de ser especificacao de implementacao deste time e passa a ser contrato de referencia para a equipe do Patronage, com prioridade nos paineis de Conciliacao e Executivo.
