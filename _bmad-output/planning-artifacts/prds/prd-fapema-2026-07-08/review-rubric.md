# PRD Quality Review — PRD FAPEMA Patronage Analytics

## Overall verdict

The 2026-07-21 re-scope is stated boldly and traceably: two panels instead of four, a hard delivery boundary at the Data Warehouse semantic layer, and an explicit "[Obsoleto]" retirement of the old embed-in-Laravel decision (addendum §4). That is a genuine strength — the change is visible, not smoothed over. But the rewrite was not carried through consistently: the Painel Executivo homologation criteria (§6.3) still describe a visual "walkthrough" and "semaforização" review, directly contradicting FR-5's own new rule that homologation is "sobre o contrato de dados (não sobre tela implementada)" — the same contradiction that pendência 8.5 claims to have already resolved. Combined with an undefined "camada semântica" (the term the whole boundary now hinges on) and no journey/persona representing the Patronage dev team who is now the PRD's actual first consumer, the document reads as a scope change bolted onto UI-era language rather than fully re-derived from the new boundary.

## Decision-readiness — thin

The headline decision — 2 panels, DW/semantic-layer boundary — is stated as a decision, not hedged as a "consideration," and is cross-referenced to its trigger document (§6.3 Apêndice A note, line 176). That part is honest. What's missing is the trade-off side: ceding UI ownership is a real risk (this team no longer controls whether or when the shipped UI matches the contract), and nothing in the PRD or addendum names that risk. The addendum's risk list (§5) was left untouched by this edit even though the adjacent "Decisões Técnicas em Aberto" section (§4) did get a fresh line for the boundary change. There are zero `[NOTE FOR PM]` callouts anywhere in the document (confirmed by full-text search) — for a document that just moved a major deliverable boundary, that is a conspicuous silence exactly where the rubric expects one.

### Findings
- **high** Boundary-change risk not surfaced anywhere (addendum §5; PRD §6.3 "Fronteira de Responsabilidade", lines 144–146) — Addendum §4 (line 53) explicitly retires the old "embed no Laravel" decision as obsolete, but addendum §5 "Mapeamento Inicial de Riscos" (lines 55–61) was not updated with the mirror-image risk: that the Patronage team may not prioritize building the UI from this contract, or may drift from it, with no visibility or recourse for this team. *Fix:* add a risk entry to addendum §5 (e.g., "Risco de baixo alinhamento ou atraso na implementação da UI pelo time Patronage a partir do contrato de dados entregue") and/or a `[NOTE FOR PM]` at §6.3 naming the dependency as a tracked tension.
- **medium** Pendência 8.5 owner list omits the Patronage team (§8 item 5, line 255) — Owner is listed as "PO, liderança financeira, controle interno e patrocinador executivo," but SM-4 (line 225) requires homologation "pelos aprovadores designados **e pela equipe do Patronage**," and Assumption 2 (line 261) names their "participação" as a precondition. The accountable-parties list and the acceptance-gate definition disagree on who must sign off. *Fix:* add a Patronage-team owner/representative to the pendência 8.5 owner line.

## Substance over theater — adequate

Content stays close to verifiable claims (FRs with testable consequences, a real volumetry baseline in §6.4, contra-metrics). No new theater was introduced by this edit — the boundary language ("a entrega deste time termina na camada semântica," line 146) is specific to this institution's situation, not swappable boilerplate.

### Findings
- **low** "baixo esforço cognitivo" (§1, line 16) remains an unanchored qualitative claim carried over from the prior draft — no observable signal defines what counts as low cognitive effort for the consuming team. *Fix:* tie it to one measurable signal (e.g., time for a Patronage dev to map a view to a UI field without back-and-forth).

## Strategic coherence — adequate

The arc (data foundation → curation → reconciliation/executive visibility as first bets) still holds together, and the MVP-scope logic (defer Operacional/Gerencial, keep Conciliação + Executivo) is stated as fact in §6.3/Apêndice A. What's not stated in the PRD body itself is *why* Conciliação and Executivo were chosen over Operacional/Gerencial — the change-trigger brief has that context, but it wasn't pulled into the PRD, so a reader of the PRD alone sees a priority label without a rationale.

### Findings
- **medium** Priority ordering asserted without stated rationale (§6.3, lines 148–172) — "Conciliação (prioridade principal)" and "Executivo (prioridade secundária)" are declared but not justified inside the PRD (e.g., audit/regulatory exposure, executive sponsorship pressure). *Fix:* add one or two sentences in §6.3 or §1 naming the criterion that drove this specific ordering.

## Done-ness clarity — thin

FR-1 through FR-4 and the Painel de Conciliação criteria (§6.3, lines 156–159) are properly data/contract-level and testable. The Painel Executivo criteria are not, and the gap is severe precisely because it sits on one of only two in-scope panels for this cycle.

### Findings
- **critical** Painel Executivo homologation criteria contradict FR-5's own done-definition (§6.3, lines 169–172 vs. FR-5, line 106) — FR-5 states the acceptance gate is "criterio de homologacao formalizado sobre o contrato de dados (**nao sobre tela implementada**)." Yet the Painel Executivo criteria read: "Resume os KPIs institucionais prioritarios em uma unica visao com **walkthrough executivo** concluido em ate 5 minutos..." and "Destaca variacoes relevantes, alertas e riscos com **semaforizacao** aprovada pelo patrocinador executivo." Both phrases describe reviewing a rendered screen, not a data contract. Pendência 8.5 (line 254) asserts the criteria were already "redefinidos para contrato de dados/views (nao mais tela implementada)," but the actual text for this panel was not rewritten to match — contrast with the Painel de Conciliação criteria immediately above it, which *are* fully contract-level (batimento, classificação de divergências, trilha de auditoria). An approver reading §6.3 today cannot tell whether they are homologating a schema/view or a visual mockup walkthrough. *Fix:* rewrite the Painel Executivo criteria in contract terms (e.g., "views expõem os KPIs institucionais definidos com granularidade e regra de semaforização documentada" and "aprovador revisa consulta/amostra de dados em até 5 minutos"), or explicitly state that the walkthrough is conducted over the FR-6 mockup as a named exception to FR-5's "não sobre tela" rule.
- **medium** ETL/quality gates still lack numeric thresholds (§4.2, FR-3/FR-4, lines 77–93) — "checklist de qualidade executado por lote" and "inconsistencias criticas geram alerta" don't say what threshold or severity blocks publication of curated data. Carried over from the prior round; still unresolved. *Fix:* define minimum thresholds (e.g., max % of unreconciled records, SLA for curated-layer availability) that gate publication.

## Scope honesty — adequate

§6.2 and Apêndice A explicitly name what was cut (Operacional/Gerencial deferred, not discarded) and cite the trigger document — that's honest de-scoping, not silent omission. Two things weaken the picture: an ambiguous metric that may still be reaching into deferred scope, and an open-items density that looks too light given how much changed.

### Findings
- **medium** SM-1 references "relatório gerencial recorrente" while validating FR-5 (line 223) — FR-5 now covers only Conciliação and Executivo (line 107: "Paineis Operacional e Gerencial ficam fora do ciclo 1"). "Relatório gerencial" reads as a plain description but risks being conflated with the now-explicitly-deferred "Painel Gerencial de Convênios" (Apêndice A, line 191). If SM-1 means a generic recurring report, say so; if it silently still measures Gerencial-panel-adjacent output, it's validating out-of-cycle scope via FR-5. *Fix:* clarify SM-1's referent or drop "gerencial" in favor of a term that doesn't collide with the deferred panel's name.
- **low** Open-items density looks thin for the size of the change — only 2 `[ASSUMPTION]` entries (§9) and zero `[NOTE FOR PM]` callouts exist anywhere in a document that just moved its delivery boundary to depend on another team's roadmap. Not wrong, but light relative to the stakes. *Fix:* see the Decision-readiness finding on the missing boundary-risk note — resolving that also improves this dimension.

## Downstream usability — thin

FR/UJ/SM IDs are contiguous and unique, and the addendum keeps technical hypothesis material out of the PRD body — that discipline held up. Two things will trip up whoever sources from this PRD next: a load-bearing term that isn't defined, and a heading structure that no longer numbers cleanly.

### Findings
- **high** "Camada semântica" is undefined in the Glossário (§3, lines 41–47) despite being the literal definition of the new delivery boundary — used in §1 ("contrato de dados/views homologado... camada semantica" — implied), FR-5 (line 101: "na camada semantica do Data Warehouse"), §6.1 (line 132), and §6.3 "Fronteira de Responsabilidade" (line 146: "A entrega deste time termina na camada semantica do Data Warehouse"). This is now the single most important boundary-defining noun in the document and it isn't in the glossary next to Camada Landing/Camada Curated. *Fix:* add "Camada Semântica" (and optionally "Contrato de Dados/Views") to §3.
- **medium** Section numbering breaks at §6.3 (lines 142–202) — "Fronteira de Responsabilidade" (line 144) and "Apêndice A" (line 174) are unnumbered H3 headings sitting as siblings of the numbered "6.3"/"6.4" subsections, rather than nested under 6.3 as 6.3.x. Cross-references like "ver §6.3" become ambiguous about which of three co-located blocks is meant. *Fix:* fold these into the numbering scheme (e.g., 6.3.1 Fronteira de Responsabilidade, 6.3.2/6.3.3 per panel, 6.3.4 Apêndice A) or demote them to H4 under 6.3.

## Shape fit — thin

This PRD now delivers a technical capability (a homologated data contract) consumed by another engineering team, not a UI experience consumed by end business users — but the document's user-facing framing wasn't adjusted to match.

### Findings
- **high** No UJ or JTBD represents the actual immediate consumer of this PRD's deliverable (§2.1, §2.3, lines 22–39) — §1 (line 16) promises a contract "de baixo esforco cognitivo" specifically for "as interfaces que a equipe do Patronage implementa," and FR-5/FR-6 name the Patronage team as the direct recipient of the views and mockup-as-contract. Yet all four UJs (UJ-1..UJ-4) represent end-business roles (gestor operacional, C-level, equipe técnica interna, analista financeiro) several steps downstream of this team's actual deliverable boundary — none represents "a Patronage dev consumes the documented views/mockup contract to build UI without re-litigating scope," which is now the first and most immediate journey this PRD's output enables. *Fix:* add a UJ (or a JTBD line in §2.1) for the Patronage dev team as direct consumer of the contract, or explicitly note in §2 why that audience is intentionally out of the UJ set.

## Mechanical notes

- UJ-1..UJ-4 (§2.3) still use role labels, not named protagonists ("Gestor operacional," "Lideranca C-Level") — pre-existing gap, unaffected by this round, still true.
- Assumptions Index (§9, lines 258–261) has 2 entries; zero inline `[ASSUMPTION]` tags exist elsewhere in the document body, so the roundtrip is trivially satisfied (nothing inline to cross-check) rather than substantively verified.
- Zero `[NOTE FOR PM]` and zero `[NON-GOAL for MVP]` tags anywhere in the PRD (confirmed by full-text search).
- SM-4 appears in the "Primárias" list (line 225) between SM-2 and the "Secundárias" SM-3 (line 228) — IDs are unique and non-duplicated, just presented out of numeric order; cosmetic only.
- FR-1..FR-6, UJ-1..UJ-4 IDs are contiguous with no gaps or duplicates.
- No broken cross-references found; §6.3 references to "secao 6.3" from §7/§8/§9 all resolve, modulo the numbering-structure note above.
