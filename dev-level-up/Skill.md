---
name: dev-level-up
description: Repo-aware, language-agnostic scout for cutting-edge developer improvements. Auto-detects or accepts manual tech domains, searches primary sources, high-authority community sources, and AI vendor feeds, then scores findings for objective fit, stack relevance, speed, accuracy, capacity, tools, and agility.
---

## Overview

This Skill finds recent, actionable developer improvements for the repository or technology domains the user cares about. It is not limited to Java, React, Python, or any other fixed stack.

The workflow is:

1. Ask whether to **auto-detect** the current repo, accept **manual/custom domains**, use **both**, or use the **saved `.tech-stack` state**.
2. Resolve the scope into `.tech-stack/` Markdown state inside the target repository.
3. Derive improvement objectives and dynamic source queries from that state.
4. Search primary ecosystem sources, high-authority community sources, AI vendor feeds, and general tech media.
5. Filter to the last 30 days, then narrow candidates through relevance, evidence, and actionability gates.
6. Score surviving candidates and recommend the highest-ROI upgrades for the user's available time.

Use this skill when you want a curated, recent, repo-specific digest of tools, techniques, releases, patterns, and breakthroughs worth adopting.

---

## Golden Rules

- **Never assume a language, framework, library, platform, or methodology.** Infer scope from `.tech-stack/` state, manifests, configs, code, or explicit user input.
- **`.tech-stack/` is local state.** It must be gitignored and never committed by this skill.
- **Only create or update `.tech-stack/` during a skill run** after the user has chosen a scope mode.
- **Preserve manual/custom state.** Auto-detection may refresh detected rows, but it must not delete or overwrite user-provided domains unless the user asks.
- **Do not store secrets.** `.tech-stack/` may record package names, versions, domains, and evidence paths, but never credentials, tokens, private URLs requiring auth, or sensitive business data.
- **Prefer evidence over hype.** A finding needs a concrete artifact, official announcement, reproducible technique, or credible secondary reporting before it can become a recommendation.

---

## User Onboarding (Required Before Search)

Before searching, collect the following parameters from the human:

| # | Parameter | Options / Format | Default |
|---|-----------|------------------|---------|
| 1 | **Scope mode** | `Auto-detect current repo`, `Manual/custom domains`, `Both: detect + manual`, `Use saved .tech-stack state` | Required — ask; do not assume |
| 2 | **Domains** | Free-form list grouped by category when manual/custom domains are selected, e.g. `Rust`, `Next.js`, `GraphQL`, `Terraform`, `MCP security`, `TDD` | Required when manual/custom is selected; skip for auto-only or saved-state-only |
| 3 | **Improvement objective(s)** | `All objectives` or a comma-separated list from the objective catalog in `resources/improvement-objectives.md` | Required — ask; use `All objectives` only if the user explicitly accepts broad coverage |
| 4 | **Output depth** | `Headlines` (concise ranked list with scores and one-line summaries), `Full details` (complete report with adoption steps, verification notes, classification, and state summary) | `Full details` |

### Scope Handling

- If the user chooses `Manual/custom domains`, ask for the domains if they were not provided. Accept any combination of:
  - **Tech stack:** languages, frameworks, libraries, databases, cloud/platforms, protocols, package ecosystems.
  - **Patterns & practices:** architecture styles, coding techniques, testing approaches, observability, DevOps/GitOps, agent workflows.
  - **Risk domains:** security, privacy, compliance, reliability, AI safety, supply-chain concerns.
  - **AI/tooling:** models, agents, MCP servers, prompt workflows, AI IDEs, coding assistants, evals.
- If the user chooses `Auto-detect current repo`, resolve the repository root and run the detection workflow below.
- If the user chooses `Both`, run detection first, then merge the user's manual/custom entries into the appropriate `.tech-stack/` category files.
- If the user chooses `Use saved .tech-stack state`, load the existing state without re-scanning unless the user asks for a refresh. If `.tech-stack/` is missing or materially incomplete, say so and offer `Auto-detect current repo`, `Manual/custom domains`, or `Both` instead of assuming scope.
- If `.tech-stack/` already exists and the user chooses auto-detect or both, preserve manual/custom rows and refresh detected/inferred rows.

Record all answers. If the human is unsure about any field, explain the options briefly but do not silently narrow the scope.

---

## `.tech-stack` State Model

`.tech-stack/` lives at the target repository root and stores the scope used for candidate generation and relevance scoring.

```text
<target-repo-root>/
├── .tech-stack/
│   ├── index.md                 # scope summary, last scan, category counts
│   ├── languages.md             # languages and runtimes
│   ├── frameworks.md            # frameworks, ORMs, UI/meta-frameworks
│   ├── libraries.md             # notable libraries and packages
│   ├── infrastructure.md        # cloud, containers, IaC, databases, platforms
│   ├── developer-tooling.md     # editors, CLIs, build/test/lint/debug tools
│   ├── ai-tooling.md            # models, agents, MCP, prompts, AI coding tools
│   ├── patterns-practices.md    # architecture, testing, observability, workflows
│   ├── risk-domains.md          # security, privacy, compliance, reliability
│   └── custom-domains.md        # user-defined domains that do not fit above
└── .gitignore                   # must ignore .tech-stack/
```

Load `resources/tech-stack-state-template.md` for the exact Markdown skeleton and `resources/tech-stack-detection.md` for the detection playbook.

### State Update Rules

1. Resolve the target repository root. If the user points at a subdirectory, use the nearest repo root containing `.git`; otherwise use the current working directory.
2. Ensure `.gitignore` contains `.tech-stack/`. Add the entry if missing and mention the change in the final summary.
3. If `.tech-stack/` does not exist, create it from the template only after the user has chosen a scope mode.
4. For auto-detection, populate detected/inferred rows with evidence paths and confidence.
5. For manual/custom input, write or update the matching category file and mark rows as `manual` or `custom`.
6. Update `index.md` with the scan date, scope mode, category counts, and selected objectives.
7. Present a concise scope summary before searching when detection confidence is mixed or the user provided manual additions. Ask for confirmation or corrections if needed.
8. Never commit `.tech-stack/` or include it in generated reports as a repository change.

---

## Tech-Stack Detection Workflow

For `Auto-detect current repo` or `Both`, load `resources/tech-stack-detection.md` and perform a bounded repo scan.

Detection must cover:

- **Languages/runtimes:** manifest files, runtime version files, lockfiles, shebangs, source extensions.
- **Frameworks:** framework-specific configs, dependencies, directory conventions, entrypoints.
- **Libraries/packages:** direct dependencies, notable transitive ecosystems, package registries implied by manifests.
- **Infrastructure:** Docker, Kubernetes, Terraform/Pulumi, serverless configs, cloud SDKs, database clients/ORMS.
- **Developer tooling:** package scripts, Makefile/justfile/taskfile, CI workflows, formatter/linter/typecheck/test configs, editor/agent configs.
- **Coding patterns/techniques:** inferred from architecture, tests, API style, observability, migrations, feature flags, agent rules, and code organization.
- **AI tooling:** model/provider configs, MCP configs, agent rules, prompt/eval files, AI IDE/editor integrations.
- **Risk domains:** only record risks with concrete evidence or explicit user input; do not invent compliance claims.

Write the results into the relevant `.tech-stack/` category files. Use confidence values `detected`, `inferred`, `manual`, or `custom`, and cite evidence such as `package.json`, `pyproject.toml`, `.github/workflows/ci.yml`, or `src/auth/`.

After detection, show the user a compact table of the resolved domains by category. If the list is unexpectedly broad, ask which domains to prioritise before searching.

---

## Search Architecture

The skill uses a **tiered, source-class-aware search strategy** that prioritises APIs and feeds with reliable date filtering, then falls back to web search only where necessary.

Load `resources/source-registry.md` for source classes, seed sources, dynamic source derivation, and authority rules. Load `resources/search-api-guide.md` for endpoint parameters, authentication, rate limits, and example calls. Load `resources/source-search-templates.md` for generic query templates.

### Source Classes

| Class | Examples | Use For | Preferred Mechanism |
|-------|----------|---------|---------------------|
| **Primary ecosystem sources** | Official blogs, docs, release notes, changelogs, package registries, standards bodies | Version upgrades, breaking changes, new capabilities, authoritative techniques | Official feeds/APIs where available; Brave/web search with `site:` |
| **High-authority community sources** | Hacker News, Lobsters, recognised practitioner blogs, conference talks, research papers/whitepapers | Community validation, practitioner techniques, early signals | HN Algolia, Brave Search, targeted `site:` queries |
| **AI vendor feeds** | OpenAI, Anthropic, Google DeepMind, GitHub, Cursor, JetBrains, Windsurf, MCP ecosystem, other coding-tool vendors | AI models, agents, IDEs, MCP servers, coding workflows | Vendor blogs/changelogs/docs via Brave/web; GitHub Search for repos/releases |
| **General tech media** | TechRadar, Ars Technica, The Verge, InfoQ, The New Stack, SD Times, GitHub Blog | Product launches, ecosystem shifts, broad analysis | Brave Search API or News API |

### Dynamic Source Derivation

For each `.tech-stack/` row:

1. Identify the canonical domain/package name and aliases.
2. Derive likely official sources: project site, docs, blog, changelog, releases page, package registry, GitHub org/repo.
3. Derive relevant standards or ecosystem bodies where applicable.
4. Add high-authority community sources only when the domain has meaningful community discussion or practitioner coverage.
5. Add AI vendor sources when the domain or objective involves AI tooling, agents, models, prompts, MCP, or AI-assisted coding.

Do not search every possible source for every domain. Prioritise sources with the highest likelihood of fresh, relevant, actionable findings.

### Query Composition

Use placeholders from `resources/source-search-templates.md`:

- `{{DOMAIN}}` — canonical domain name, e.g. `Rust`, `Next.js`, `Terraform`
- `{{DOMAIN_ALIASES}}` — aliases or package names, e.g. `nextjs`, `npm:next`
- `{{DOMAIN_KEYWORDS}}` — concise search keywords for the domain
- `{{OBJECTIVE_KEYWORDS}}` — keywords from `resources/improvement-objectives.md`
- `{{ECOSYSTEM}}` — package manager or platform, e.g. `npm`, `PyPI`, `crates.io`, `Maven`
- `{{PACKAGE_NAME}}` — exact package/module name when known
- `{{CURRENT_VERSION}}` — currently detected version, if any
- `{{SOURCE_DOMAIN}}` — official/community/vendor domain being searched
- `{{START}}`, `{{END}}`, `{{TIMESTAMP}}` — 30-day date window

**Query composition logic:**

1. Select the top domains and objectives within the user's scope.
2. For each domain/objective pair, generate 1–3 targeted queries across the most relevant source classes.
3. Prefer official changelog/release-note queries for versioned libraries and frameworks.
4. Prefer AI vendor and MCP ecosystem queries for AI/tooling objectives.
5. Use HN Algolia or GitHub Search when those APIs fit the query.
6. Use Brave Search for source-specific and general web coverage.
7. Deduplicate by URL and by underlying announcement/release before evaluation.
8. Do not exceed the query budget in `resources/search-api-guide.md` unless the user explicitly asks for exhaustive coverage.

---

## Candidate Pipeline

The goal is not to evaluate every news item equally. Build a candidate set that is already relevant to the user's stack and objectives, then narrow it before detailed scoring.

### Candidate Record

For each potential finding, capture:

- Title and URL
- Source and source class
- Publish date
- Domain(s) affected
- Objective(s) advanced
- Core claim or proposed upgrade
- Evidence type: official release, docs, repo, paper, benchmark, practitioner report, or secondary news
- Current-stack relevance: direct, adjacent, or generic
- Adoption path, if known

### Admission Gates

Discard or downgrade candidates that fail these gates before scoring:

1. **Freshness:** published within the last 30 days, per the Date Filter Rule.
2. **Scope relevance:** affects a `.tech-stack/` domain, selected objective, or explicit manual/custom domain.
3. **Objective relevance:** clearly advances at least one selected improvement objective.
4. **Evidence quality:** has an official artifact, reproducible demo, credible technical detail, or corroborating sources.
5. **Actionability:** offers a concrete tool, version, pattern, config, workflow, or research direction that can be evaluated.
6. **Duplicate/cannibalisation:** merge duplicate coverage of the same release, tool, or technique.

### Narrowing

After gates, if the candidate set is too large:

- Keep the top candidates per domain/objective pair.
- Prefer direct stack relevance over generic AI/dev advice.
- Prefer primary sources over community retellings when both exist.
- Prefer candidates with concrete adoption paths over abstract research unless the objective is `Capability expansion` or `MVP & product speed`.
- Record skipped high-level categories in the executive summary rather than evaluating every marginal item.

---

## Date Filter Rule (Hard Constraint)

- **Discard any article, post, release note, paper, or announcement published more than 30 days before the current date.**
- **API-native date filters** (Brave `freshness`, HN `numericFilters`, GitHub `created:`/`pushed:`, registry timestamps, RSS/pub dates) are authoritative when they filter by publish/update date.
- **Web search operator results** (`after:`, `daterange:`) require mandatory manual verification because they can reflect crawl/index date rather than publish date.
- If a source does not display a clear publish date, estimate from URL date segments, release/tag dates, paper submission dates, feed timestamps, or Wayback Machine earliest capture.
- When in doubt, exclude. Do not include undated content.

---

## Evaluation Framework

For every candidate that passes the admission gates, score it across 7 axes (1–5 scale). Load `resources/evaluation-rubric.md` for detailed scoring guidance.

### Axes

| Axis | Question | High Score (5) Means |
|------|----------|----------------------|
| **Speed** | How much faster does this make relevant coding tasks? | Near-instant adoption; cuts task time by 50%+ |
| **Accuracy** | Does it reduce bugs, type errors, security flaws, or AI mistakes? | Eliminates whole error classes or enforces correctness automatically |
| **Capacity** | What new scale or capability does it unlock? | Enables previously impossible tasks or 10x throughput |
| **Tools** | Is there a concrete tool, extension, CLI, library, model, or workflow? | Immediately installable or usable; integrates with the detected toolchain |
| **Agility** | How easy is it to adopt and reverse? | Drop-in replacement; minimal config; reversible |
| **Objective Fit** | How directly does it advance a selected objective? | Squarely targets the user's chosen objective with little interpretation |
| **Stack Relevance** | How directly does it apply to `.tech-stack/` domains? | Directly upgrades, replaces, extends, or improves a detected/manual domain |

### Scoring Workflow

1. **Extract** the core claim, tool, release, technique, or research finding.
2. **Verify** with a secondary source when possible, prioritising official docs/repos over commentary.
3. **Score** each axis 1–5 using the rubric.
4. **Estimate Adoption Time** using the time buckets in `resources/evaluation-rubric.md`.
5. **Compute total** = Speed + Accuracy + Capacity + Tools + Agility + Objective Fit + Stack Relevance (range 7–35).
6. **Classify**:
   - **Quick Win**: Total >= 28 and Agility >= 4
   - **Deep Dive**: Total >= 25 but Agility <= 3 (requires investigation)
   - **Watch**: Total 18–24 (promising but early, narrow, or costly)
   - **Skip**: Total < 18 or failed an admission gate

When `All objectives` was selected, score Objective Fit against the single best-matching objective and record that objective in the output.

---

## Output Format

Present findings in one of the following structures, based on the selected **Output depth**.

---

### Headlines Output

A concise ranked table. Maximum 10 items. One line per finding.

| Rank | Finding | Domain(s) | Objective | Source | Date | Score | Adoption Time | One-Liner |
|------|---------|-----------|-----------|--------|------|-------|---------------|-----------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

- **Score**: Total 7-axis score (7–35)
- **Adoption Time**: Estimated time to first value
- **One-Liner**: Single sentence summarising the benefit and why it fits the repo scope

---

### Full Details Output

#### 1. Executive Summary

- Scope mode and `.tech-stack/` state used
- Domains evaluated by category
- Objectives selected
- Source classes searched
- Candidate funnel: generated → passed gates → fully scored
- Total findings passing date filter
- Breakdown by classification (Quick Wins / Deep Dives / Watch / Skip)
- Top recommended action in one sentence
- Domain/objective pair with the highest concentration of high-scoring findings

#### 2. Quick Wins

| # | Finding | Domain(s) | Objective | Source | Date | Total Score | Adoption Time | Bang for Buck | Action Item |
|---|---------|-----------|-----------|--------|------|-------------|---------------|---------------|-------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... | ... |

Each entry includes:

- One-sentence description of the tool/technique/release
- Direct link to source
- Verification status
- Exact adoption step or investigation step
- Adoption Time estimate and concrete first step

#### 3. Deep Dives

| # | Finding | Domain(s) | Objective | Source | Date | Total Score | Adoption Time | Why It Needs Investigation |
|---|---------|-----------|-----------|--------|------|-------------|---------------|--------------------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

Each entry includes:

- Why the potential impact is high
- What uncertainty blocks immediate adoption
- Suggested next step

#### 4. Watch List

| # | Finding | Domain(s) | Objective | Source | Date | Total Score | Adoption Time | Revisit Condition |
|---|---------|-----------|-----------|--------|------|-------------|---------------|-------------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

#### 5. `.tech-stack` State Summary

- Whether state was created, refreshed, or reused
- Detected/manual/custom domains added or updated
- Any low-confidence detections the user should correct
- Reminder that `.tech-stack/` is gitignored local state

---

## Time-Based Prioritization & 80/20 Recommendation

After presenting the initial findings, ask the human:

> **"How much time do you have to implement something this week?"**
>
> Options: `< 1 hour`, `1–4 hours`, `Half a day`, `1–2 days`, `A full week`

### Recommendation Logic

1. **Map time budget** to the `Adoption Time` estimates on each finding.
2. **Filter** Quick Wins and high-scoring Deep Dives to items within the affordable time range.
3. **Compute Bang for Buck**:
   ```
   Bang for Buck = Total Score / Adoption Time (in hours)
   ```
   Use the midpoint of any time range.
4. **Sort** by Bang for Buck descending, using Stack Relevance and Objective Fit as tie-breakers.
5. **Present the 80/20 Picks** — the top 3–5 items that:
   - Fit inside the time budget
   - Deliver the highest combined Total Score
   - Apply directly to the detected/manual scope
   - Stack well together without conflicting migrations or toolchain changes

### Output Format: 80/20 Recommendation

**Your time budget:** [human's answer]

| Pick | Finding | Domain(s) | Objective | Adoption Time | Total Score | Bang for Buck | Why It's High-ROI |
|------|---------|-----------|-----------|---------------|-------------|---------------|-------------------|
| 1 | ... | ... | ... | ... | ... | ... | ... |

- **Combined impact**: Sum of Total Scores for the recommended picks.
- **Time required**: Sum of Adoption Times.
- **Skipped for now**: Any Quick Wins above the time threshold, with a note to revisit when more time is available.

---

## Escalation & Quality Gates

Stop and flag immediately when:

- A source claims a "breakthrough" but provides no reproducible artifact, official docs, repo, benchmark, or credible technical explanation.
- Two or more credible sources contradict each other on a key capability claim.
- A tool is advertised as "free" but requires credit card or enterprise signup without a clear free tier.
- A finding is clearly sponsored content, undisclosed affiliate marketing, or vendor marketing without technical substance.
- A security or correctness claim is made without evidence.
- `.tech-stack/` would need to store secrets, private credentials, or sensitive customer data.
- Auto-detection produces an implausibly broad scope and the user has not confirmed priorities.

---

## Extension Guide (For Maintainers)

To add a new improvement objective:

1. Add the objective to `resources/improvement-objectives.md` with candidate signals, query keywords, negative filters, and examples.
2. Add it to the **Improvement objective(s)** options in User Onboarding.
3. No build-script changes are needed if `build-skill.sh` packages all Markdown resources.

To add a new `.tech-stack` category:

1. Add the category file to `resources/tech-stack-state-template.md`.
2. Add detection guidance to `resources/tech-stack-detection.md`.
3. Add category-specific search hints to `resources/source-search-templates.md` or `resources/source-registry.md` if needed.

To add a new source class or seed source:

1. Add it to `resources/source-registry.md` with authority level, mechanism, and query patterns.
2. Add concrete API/feed templates to `resources/search-api-guide.md` if it has a reliable mechanism.
3. Add generic `site:` or keyword templates to `resources/source-search-templates.md`.

To support a new ecosystem in auto-detection:

1. Add manifest/config signals and version-extraction rules to `resources/tech-stack-detection.md`.
2. Add package-registry/version-check guidance to `resources/search-api-guide.md` if applicable.
3. Add ecosystem query examples to `resources/source-search-templates.md`.
