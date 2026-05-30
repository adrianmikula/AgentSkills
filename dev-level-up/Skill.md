---
name: dev-level-up
description: Scan high-authority tech news sources for cutting-edge AI coding tools, tricks, methods, and techniques targeting Java, React, and Python. Filters to the last month and evaluates every finding for impact on AI-powered coding speed, accuracy, capacity, tools, and agility.
---

## Overview

This Skill actively searches high-authority tech news sources for new AI coding innovations specifically relevant to **Java**, **React**, and **Python**. It enforces a strict 1-month freshness filter, then evaluates each finding against five targeted axes to surface actionable opportunities for leveling up AI-powered development.

Use this skill when you want a curated, recent, and scored digest of AI-dev advancements you can adopt immediately.

---

## User Onboarding (Required Before Search)

Before searching, collect the following two parameters from the human:

| # | Parameter | Options / Format | Default |
|---|-----------|------------------|---------|
| 1 | **Focus area** | `All focus areas` (top techniques across all areas), `Vibe coding speed` (2x–10x dev velocity), `Code quality assurance` (guaranteeing correctness of AI-generated code), `AI-era security` (securing AI-generated code against new threats), `AI workflow orchestration` (complex multi-agent pipelines and processes), `MVP acceleration` (turning ideas into monetisable products fast), `Tech debt modernisation` (safe automated refactoring and migration), `Bleeding-edge tools & integrations` (innovative new abilities and toolchain additions) | `All focus areas` |
| 2 | **Language focus** | `All`, `Java`, `React`, `Python` | `All` |
| 3 | **Output depth** | `Headlines` (concise ranked list with scores and one-line summaries), `Full details` (complete report with adoption steps, verification notes, and classification) | `Full details` |

Record all answers. If the human is unsure about any field, explain the options briefly but do not assume defaults.

---

## Search Architecture

The skill uses a **tiered search strategy** that prioritizes APIs with native, reliable date filtering over generic web search operators. This minimizes false positives from stale content and eliminates the need for repeated search reruns.

### Search Tiers

| Tier | Mechanism | Date Filtering | When to Use |
|------|-----------|----------------|-------------|
| 1 | **Direct APIs** (HN Algolia, GitHub Search) | Precise native timestamps | Hacker News stories, Show HN, GitHub repos/releases |
| 2 | **Brave Search API** | Custom `freshness` ranges (`YYYY-MM-DDtoYYYY-MM-DD`) | General web, news, discussions across all remaining sources |
| 3 | **News APIs** (News API) | Publish-date `from`/`to` | Mainstream tech news only if Brave coverage is insufficient |
| 4 | **Web Search Fallback** | Operator-based (`after:`, `site:`) | Sources with no API access, with mandatory manual date verification |

Load `resources/search-api-guide.md` for exact endpoint parameters, authentication requirements, example `curl` calls, and rate limits.

### High-Authority Sources

| Source | Domain | Search Focus | Preferred Mechanism |
|--------|--------|-------------|---------------------|
| TechRadar | techradar.com | AI coding tool reviews, IDE updates, agentic workflows | Brave Search API |
| Hacker News | news.ycombinator.com | Community-validated tools, Show HN launches, technique discussions | HN Algolia API |
| Dev.to | dev.to | Tutorial-style deep-dives, new library introductions | Brave Search API |
| Ars Technica | arstechnica.com | Policy and tooling intersections, language ecosystem shifts | Brave Search API |
| The Verge | theverge.com | Product launches, IDE and toolchain announcements | Brave Search API |
| GitHub Blog | github.blog | Copilot updates, Actions features, AI-native workflows | Brave Search API |
| GitHub (Repos) | github.com | New tools, releases, launch announcements | GitHub Search API |
| OpenJDK Blog | openjdk.org | Java language and VM enhancements with AI codegen implications | Brave Search API |
| React Blog | react.dev/blog | React compiler, server components, AI-assisted UI patterns | Brave Search API |
| Python Insider | blog.python.org | Language features that improve AI codegen or static analysis | Brave Search API |

### Focus-Area-Driven Search Queries

Load `resources/source-search-templates.md` for exact query strings and API call templates. Use the templates that match the selected **Focus area** and **Language focus**. If `All focus areas` is selected, run a representative query from each focus area and merge results. If `All` languages is selected, run queries across Java, React, and Python.

**Query composition logic:**
1. Determine the source's preferred mechanism from the table above
2. Use the corresponding API template from `resources/search-api-guide.md` or web-search template from `resources/source-search-templates.md`
3. Set the date range to 30 days before today through today
4. Run multiple queries per focus area to maximize coverage
5. Deduplicate results by URL before evaluation

---

## Date Filter Rule (Hard Constraint)

- **Discard any article, post, release note, or announcement published more than 30 days before the current date.**
- **API-native date filters** (Brave `freshness`, HN `numericFilters`, GitHub `created:>`, News API `from`) are considered authoritative — manual verification is still recommended but not mandatory if the API explicitly filters by publish date.
- **Web search operator results** (`after:`, `daterange:`) require mandatory manual verification because they filter by crawl/index date, not publish date.
- If a source does not display a clear publish date, estimate from:
  - URL slug date segments (`/2026/05/...`)
  - First comment timestamp
  - GitHub release/tag date
  - Wayback Machine earliest capture
- When in doubt, exclude. Do not include undated content.

---

## Evaluation Framework

For every finding that passes the date filter, score it across 5 axes (1–5 scale). Load `resources/evaluation-rubric.md` for detailed scoring guidance.

### Axes

| Axis | Question | High Score (5) Means |
|------|----------|----------------------|
| **Speed** | How much faster does this make common coding tasks? | Near-instant adoption; cuts task time by 50%+ |
| **Accuracy** | Does it reduce bugs, type errors, or security flaws? | Eliminates whole error classes or enforces correctness automatically |
| **Capacity** | What scale of work does it unlock? | Enables previously impossible tasks or 10x throughput |
| **Tools** | Is there a concrete tool, extension, CLI, or library? | Immediately installable; integrates with existing toolchain |
| **Agility** | How easy is it to adopt and swap out? | Drop-in replacement; minimal config; reversible |

### Scoring Workflow

1. **Extract** the core claim or tool from the source.
2. **Verify** the claim with a secondary source if possible (e.g., official docs, GitHub repo, another news outlet).
3. **Score** each axis 1–5 using the rubric.
4. **Estimate Adoption Time** using the time buckets in `resources/evaluation-rubric.md`.
5. **Compute total** = Speed + Accuracy + Capacity + Tools + Agility (range 5–25).
6. **Classify**:
   - **Quick Win**: Total >= 20 and Agility >= 4
   - **Deep Dive**: Total >= 18 but Agility <= 3 (requires investigation)
   - **Watch**: Total 12–17 (promising but early or narrow)
   - **Skip**: Total < 12 or unverifiable claim

---

## Output Format

Present findings in one of the following structures, based on the selected **Output depth**.

---

### Headlines Output

A concise ranked table. Maximum 10 items. One line per finding.

| Rank | Finding | Source | Date | Focus Area | Lang | Score | Adoption Time | One-Liner |
|------|---------|--------|------|------------|------|-------|---------------|-----------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

- **Score**: Total 5-axis score (5–25)
- **Adoption Time**: Estimated time to first value (e.g., "15 min", "2 hrs", "1 day")
- **One-Liner**: Single sentence summarising the benefit (e.g., "VS Code extension auto-generates Javadoc from method signatures, cutting doc time 80%")

---

### Full Details Output

#### 1. Executive Summary

- Total queries run
- Total findings passing date filter
- Breakdown by classification (Quick Wins / Deep Dives / Watch / Skip)
- Top recommended action in one sentence
- Focus area with the highest concentration of high-scoring findings

#### 2. Quick Wins

| # | Finding | Source | Date | Focus Area | Lang | Total Score | Adoption Time | Bang for Buck | Action Item |
|---|---------|--------|------|------------|------|-------------|---------------|---------------|-------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... | ... |

Each entry includes:
- One-sentence description of the tool/technique
- Direct link to source
- Verification status (confirmed by secondary source / single source)
- Exact adoption step (install command, config change, or workflow update)
- Adoption Time estimate and concrete first step

#### 3. Deep Dives

| # | Finding | Source | Date | Focus Area | Lang | Total Score | Adoption Time | Why It Needs Investigation |
|---|---------|--------|------|------------|------|-------------|---------------|--------------------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

Each entry includes:
- Why the potential impact is high
- What uncertainty blocks immediate adoption
- Suggested next step (e.g., "spin up a test repo", "read the RFC", "check GitHub issues for stability")

#### 4. Watch List

| # | Finding | Source | Date | Focus Area | Lang | Total Score | Adoption Time | Revisit Condition |
|---|---------|--------|------|------------|------|-------------|---------------|-------------------|
| 1 | ... | ... | ... | ... | ... | ... | ... | ... |

---

## Time-Based Prioritization & 80/20 Recommendation

After presenting the initial findings, ask the human:

> **"How much time do you have to implement something this week?"**
>
> Options: `< 1 hour`, `1–4 hours`, `Half a day`, `1–2 days`, `A full week`

### Recommendation Logic

1. **Map time budget** to the `Adoption Time` estimates on each finding:
   - `< 1 hour` → select items under 1 hour
   - `1–4 hours` → select items up to 4 hours
   - `Half a day` → select items up to 1 day
   - `1–2 days` → select items up to 2 days
   - `A full week` → select all Quick Wins and priority Deep Dives

2. **Filter** the Quick Wins (and high-scoring Deep Dives if time allows) to items within the affordable time range.

3. **Compute Bang for Buck** for each remaining item:
   ```
   Bang for Buck = Total Score / Adoption Time (in hours)
   ```
   Use the midpoint of any time range (e.g., "1–4 hrs" = 2.5 hrs, "15–60 min" = 0.6 hrs).

4. **Sort** by Bang for Buck descending.

5. **Present the 80/20 Picks** — the top 3–5 items that:
   - Fit inside the time budget
   - Deliver the highest combined Total Score
   - Stack well together (e.g., an IDE extension + a lint rule that complement each other)

### Output Format: 80/20 Recommendation

**Your time budget:** [human's answer]

| Pick | Finding | Focus Area | Adoption Time | Total Score | Bang for Buck | Why It's High-ROI |
|------|---------|------------|---------------|-------------|---------------|-------------------|
| 1 | ... | ... | ... | ... | ... | ... |

- **Combined impact**: Sum of Total Scores for the recommended picks.
- **Time required**: Sum of Adoption Times.
- **Skipped for now**: Any Quick Wins above the time threshold, with a note to revisit when more time is available.

---

## Escalation & Quality Gates

Stop and flag immediately when:

- A source claims a "breakthrough" but provides no reproducible artifact (no GitHub repo, no install command, no demo)
- Two or more sources contradict each other on a key capability claim
- A tool is advertised as "free" but requires credit card or enterprise signup without a clear free tier
- A finding is clearly sponsored content or undisclosed affiliate marketing
- A security or correctness claim is made without evidence (e.g., "100% bug-free codegen")

---

## Extension Guide (For Maintainers)

To add a new focus area:

1. Define the focus area in the **Focus area** options in the User Onboarding table.
2. Add focus-area-specific search queries to `resources/source-search-templates.md`.
3. No changes to `build-skill.sh` needed.

To add a new language:

1. Add language-specific search queries to `resources/source-search-templates.md` under each focus area.
2. Update the **Language focus** options in the User Onboarding table.

To add a new source:

1. Add the source to the **High-Authority Sources** table with domain and focus.
2. Add corresponding query templates to `resources/source-search-templates.md` under each focus area.
