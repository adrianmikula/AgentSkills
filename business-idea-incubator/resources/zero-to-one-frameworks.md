# Zero-to-One Frameworks

This resource is the advanced methodology layer for the Business Idea Incubator. It embeds proven, named frameworks from Graham, Hormozi, Thiel, Ellis, McClure, Bezos, Munger, Kahneman, Brunson, Halbert, and Karpathy. Use it as the default operating system when coaching a founder from idea to first revenue and beyond.

The core principle: **build in phases, with explicit go/no-go gates.** Do not advance to the next phase until the current phase's gate outputs are produced and accepted. This is the single highest-leverage change for solo founders: it prevents building something nobody wants, overspending runway, or scaling on vibes.

---

## The 10 Phases

```
DISCOVER → VALIDATE → ARCHITECT → MODEL → OFFER → BUILD → LAUNCH → ITERATE → SUSTAIN → GROW
```

| Phase | Gate Question | Gate Outputs | Authority |
|-------|--------------|--------------|-----------|
| 0. **DISCOVER** | What should I build? | 3-5 candidate ideas; skills × interests × market gap map; contrarian/AI insight | Paul Graham, Peter Thiel, Andrej Karpathy |
| 1. **VALIDATE** | Will anyone pay for this? | Starving-crowd evidence; pre-sell or waitlist results; GO/NO-GO | Alex Hormozi, Sean Ellis |
| 2. **ARCHITECT** | Can I build the right thing cheaply? | Walking-skeleton scope; API/AI cost and risk estimate; stack decision | — |
| 3. **MODEL** | Do the numbers work? | Unit-economics model; pricing/monetization choice; break-even timeline | — |
| 4. **OFFER** | Is the promise irresistible? | Value Equation; Grand Slam Offer; name, guarantee, risk reversal | Alex Hormozi, Russell Brunson |
| 5. **BUILD** | What's the smallest thing I can ship? | MVP scope; walking skeleton built; analytics and payment wired | — |
| 6. **LAUNCH** | How do I generate first sales fast? | 7-day launch plan: landing copy, email, Reddit post, DMs, demo | Russell Brunson, Gary Halbert |
| 7. **ITERATE** | What does the first feedback tell me? | User interviews; churn diagnosis; PMF survey; top 3 fixes | Sean Ellis, Eric Ries |
| 8. **SUSTAIN** | Can I keep this alive profitably? | Runway calc; personal + business burn; three scenarios; legal minimum | Charlie Munger, Daniel Kahneman |
| 9. **GROW** | What's the highest-leverage next move? | AARRR audit; flywheel map; 3-experiment backlog; decision classification | Dave McClure, Jeff Bezos |

---

## Cross-Cutting Capabilities

Available at any phase. They should be invoked whenever a decision has meaningful consequences.

| Capability | Purpose | When to Use |
|------------|---------|-------------|
| **Pre-Mortem (Munger)** | Invert the problem: "What would guarantee failure?" List failure modes before committing. | Before large bets, pivots, spends, or hires. |
| **Kairo Business (Kahneman/Tversky)** | Bias audit: confirmation, sunk cost, overconfidence, availability. | When the founder is emotionally attached or under pressure. |
| **Runway Calculator** | Personal + business burn, three probability-weighted scenarios. | Funding, quit-job, or scaling decisions. |
| **Working Backwards (Bezos)** | Write the internal press release / FAQ before building. | Feature, product, or launch decisions. |
| **Decision Classification (Bezos)** | Type 1 (irreversible — slow down) vs Type 2 (reversible — speed up). | Every consequential decision. |
| **Research Engine** | Real-time web research for market sizing, competitors, pricing. | Any phase that requires facts, not assumptions. |
| **Analytics Engineer** | Define the one metric that matters and the telemetry to measure it. | Build, launch, iterate, grow. |
| **Legal Minimum** | Entity, IP, terms, privacy: the smallest protective setup for the stage. | Before taking money or exposing data. |

---

## Named Frameworks by Authority

### Paul Graham — Idea Quality
- **Taste test:** If you can't make something that *you* want, stop. Build for yourself first.
- **Do things that don't scale:** The first 100 customers are hand-served. Scaling too early kills insight.
- **Schlep blindness:** The best ideas often have an unpleasant schlep the founder is uniquely willing to do.

### Peter Thiel — Contrarian / Secret
- **Contrarian question:** What valuable company is nobody building?
- **Secret:** A belief that is both unconventional and true. If you don't have a secret, you don't have a defensible idea.
- **0 to 1 vs 1 to n:** Create new value, not just copy existing models.

### Andrej Karpathy — AI Advantage
- **AI opportunity scan:** Where does an LLM, agent, or autonomous system create 10x leverage for this customer?
- **Unfair advantage:** Can the product be built such that AI reduces cost or time by an order of magnitude?

### Alex Hormozi — Demand, Offer, Value
- **Starving crowd:** Find people who are already desperate for the outcome, then sell them the solution.
- **Value Equation:** (Dream outcome × perceived likelihood of achievement) / (time delay × effort and sacrifice).
- **Grand Slam Offer:** High value, low risk, low friction. Stack the offer so it is irrational to say no.
- **Guarantee and risk reversal:** Remove the customer's risk before you ask for money.
- **Magnet phrase:** Name the offer around the outcome, not the category.

### Russell Brunson — Launch & Funnels
- **7-day launch:** Landing copy, email sequence, Reddit post, DM outreach, demo, launch day, post-launch metrics.
- **Hook, Story, Offer:** Every marketing asset needs a hook (pattern interrupt), story (credibility/relatability), and offer.

### Gary Halbert — Copy
- **MAGIC formula for naming:** Magnetic, Appealing, Goal-oriented, Inviting, Clear.
- **Direct-response discipline:** Copy is measured by action, not beauty.

### Sean Ellis — Product-Market Fit
- **40% test:** "How would you feel if you could no longer use this product?" At least 40% "very disappointed" signals PMF.
- **Segment for your north star:** Find the subgroup with the highest PMF score and build the roadmap to make them ecstatic.

### Dave McClure — Growth Engineering
- **AARRR:** Acquisition, Activation, Retention, Revenue, Referral.
- **One metric that matters (OMTM):** Pick the stage with the biggest leak and run max 3 experiments at a time.
- **Experiment design:** Hypothesis, metric, duration, kill criteria.

### Jeff Bezos — Long-Term Systems
- **Flywheel:** Each customer should make the next customer cheaper/easier to acquire.
- **Working backwards:** Write the press release and FAQ before building.
- **Day 1:** Maintain startup urgency and customer obsession.
- **Type 1 / Type 2 decisions:** Consequential and reversible vs. inconsequential and irreversible.

### Charlie Munger — Inversion & Mental Models
- **Inversion:** Ask how to fail, then avoid those paths.
- **Multiple mental models:** Use big ideas from mathematics, psychology, economics, and engineering.

### Daniel Kahneman — Bias and Decision Quality
- **System 1 vs System 2:** Fast, emotional thinking vs slow, evidence-based thinking.
- **Pre-mortem, outside view, reference class forecasting:** Reduce overconfidence in plans.

---

## Embedded Tools / Prompts

When a user is at a phase, run the matching prompt internally to produce the gate outputs. Do not expose raw prompts unless the user asks. Instead, produce the resulting artifact. For step-by-step playbooks of the highest-leverage tools, load `resources/zero-to-one-tool-playbooks.md`.

### Phase 0: DISCOVER
- `taste-test` — Is this idea something *you* deeply want?
- `contrarian-test` — What do you believe that is true but others disagree with?
- `ai-opportunity-scan` — Where could AI create 10x leverage for the customer?

### Phase 1: VALIDATE
- `starving-crowd` — Find 3 places where people already complain about this pain.
- `market-check` — Estimate TAM/SAM/SOM with real signals, not guesswork.
- `pre-sell` — Design a 7-day pre-sell experiment with a price and a deposit page.

### Phase 2: ARCHITECT
- `stack-selection` — Choose the smallest viable stack.
- `api-cost-calc` — Model per-user API/AI cost at 1×, 10×, 100× scale.
- `api-risk` — List single points of failure and vendor lock-in risks.

### Phase 3: MODEL
- `monetization-model` — Choose and justify pricing model.
- `unit-economics-sim` — Build per-customer economics: CAC, LTV, payback, margin.
- `runway-calc` — Personal + business burn, three scenarios.

### Phase 4: OFFER
- `value-equation` — Score the offer on dream outcome, likelihood, time delay, effort.
- `grand-slam-offer` — Design the offer stack, guarantee, and risk reversal.
- `guarantee-designer` — Remove the customer's risk.
- `offer-naming` — Use the MAGIC formula.

### Phase 5: BUILD
- `mvp-scope` — Define the absolute minimum that can deliver the promised outcome.
- `walking-skeleton` — Build the thinnest end-to-end working version.
- `deploy`, `stripe-setup`, `analytics-setup` — Production wiring.

### Phase 6: LAUNCH
- `launch-sequence` — 7-day sprint checklist.
- `reddit-post`, `dm-outreach`, `email-sequence` — Day-by-day assets.
- `demo-builder` — Build a 5-minute demo path.

### Phase 7: ITERATE
- `user-interview` — Script and synthesize 5-10 customer interviews.
- `churn-diagnosis` — Why did early users drop off?
- `pmf-survey`, `pmf-score` — Sean Ellis 40% test.

### Phase 8: SUSTAIN
- `pre-mortem` — What would guarantee failure now?
- `faq-generator` — Answer the top 10 objections before they are asked.
- `legal-kit` — Minimum legal setup.

### Phase 9: GROW
- `aarrr-audit` — Find the biggest leak.
- `experiment-design` — Hypothesis, metric, duration, kill criteria.
- `flywheel-map` — Map self-reinforcing loops.
- `working-backwards` — Press release before building the next feature.
- `decision-classify` — Type 1 or Type 2?

---

## Phase Gate Protocol

When the user wants to move to a new phase or asks for help, run this protocol:

1. **Identify the current phase.** Use the idea file's `## Progress Log` and `## Status`.
2. **Check the previous gate.** If any required outputs are missing, do not proceed. Instead, run the missing tool/prompt and produce the gate artifact.
3. **Run the relevant prompt/tool** for the target phase (see list above and `resources/zero-to-one-tool-playbooks.md` for step-by-step playbooks).
4. **Produce a concrete artifact:** a markdown file, checklist, model, or decision log saved to `.ideas/ideas/{slug}.md` or a phase-specific file.
5. **Update the idea status and `## Zero-to-One Status` section** in the idea file. Record the current phase, completed gate outputs, missing gates, and immediate next action.
6. **End with the next action** — the single most important thing the founder should do before the next session.

---

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `business-outreach-generator` | Validate demand and launch outreach | Recommended in Phase 1 and Phase 6 |
| `alirezarezvani/claude-skills` (`market-research`, `product-research`) | Deep TAM/SAM, competitive, and user research | Phase 1 and Phase 7 |
| `iamzifei/show-me-the-money` (`discover`) | 6 forcing questions and 5-filter opportunity scoring | Phase 0 and Phase 1 |
| `deep-research` or `manus` | Independent market analysis cross-check | Phase 1 and Phase 9 |
| `cognitive-sustainability` | Prevent bias, over-engineering, and premature scaling | Cross-cutting, especially Phase 8 |

## MCP Tools

| MCP Tool | Why It Helps | How to Install |
|----------|-------------|----------------|
| `web-search` / `web-fetch` | Real-time demand, competitor, and pricing research | Built-in / Configure |
| Filesystem MCP | Read/write `.ideas/` files and phase artifacts | Built-in / Configure |
