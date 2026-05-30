# AI Dev News Scout

A Claude Skill that actively scans high-authority tech news sources for cutting-edge AI coding tools, tricks, methods, and techniques targeting **Java**, **React**, and **Python**. It filters to the last 30 days, evaluates every finding for impact on AI-powered coding velocity, and delivers a ranked, actionable report.

## How It Works

1. **Collect preferences** — Ask for focus area and language focus, then output depth.
2. **Search** — Use a tiered API-first strategy (HN Algolia, Brave Search, GitHub Search) with native date filtering; fall back to web search only for sources without APIs.
3. **Filter** — Enforce a strict 30-day freshness cutoff using API-native date filters; discard stale content with minimal manual verification for API results.
4. **Evaluate** — Score each finding across 5 axes: Speed, Accuracy, Capacity, Tools, Agility, and estimate Adoption Time.
5. **Deliver** — Produce a structured report with Quick Wins, Deep Dives, and a Watch List.
6. **Prioritize** — Ask how much time the human has, then apply the 80/20 rule to recommend the highest-ROI items that fit the budget.

## Usage

Load the Skill and optionally specify your preferences:

- **Focus area:** `All focus areas` (default), or one of: `Vibe coding speed`, `Code quality assurance`, `AI-era security`, `AI workflow orchestration`, `MVP acceleration`, `Tech debt modernisation`, `Bleeding-edge tools & integrations`
- **Language focus:** `All` (default), `Java`, `React`, or `Python`
- **Output depth:** `Headlines` (concise ranked list) or `Full details` (complete report with adoption steps)

The Skill will search, filter, score, and present findings with direct links and concrete adoption steps.

## Example Output

The report includes:

- **Executive Summary** — total scanned, total passing, top recommendation
- **Quick Wins** — high-score, high-agility items with install commands, adoption time, and bang-for-buck score
- **Deep Dives** — high-potential items that need further investigation before adoption
- **Watch List** — promising but early or narrow findings with revisit conditions
- **80/20 Recommendation** — time-budget-aware picks that maximize impact for minimal effort

## Extending the Skill

### Add a New Language

1. Add language-specific search queries to `resources/source-search-templates.md`.
2. Update the User Onboarding table in `Skill.md`.

### Add a New Source

1. Add the source to the High-Authority Sources table in `Skill.md`.
2. Add corresponding query templates to `resources/source-search-templates.md`.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `ai-dev-news-scout-skill.zip` containing the Skill definition and all resource files.
