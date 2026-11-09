# Dev Level-Up

A repo-aware Claude Skill that finds recent, actionable developer improvements for the current codebase or user-selected technology domains. It auto-detects languages, frameworks, libraries, infrastructure, dev tooling, coding patterns, AI tooling, and risk domains, stores that scope in gitignored `.tech-stack/` Markdown state, then searches primary sources, high-authority community sources, AI vendor feeds, and general tech media for upgrades worth adopting.

## How It Works

1. **Choose scope** — auto-detect the current repo, enter manual/custom domains, use both, or reuse saved `.tech-stack` state.
2. **Persist scope** — create or update `.tech-stack/` category files in the target repository and ensure the folder is gitignored.
3. **Select objectives** — choose targeted improvement objectives such as agentic velocity, correctness, AI-era security, orchestration, modernization, capability expansion, toolchain DX, or MVP speed.
4. **Search broadly** — query official changelogs/docs/release notes, package registries, standards bodies, AI vendor feeds, Hacker News/Lobsters/practitioner sources, conferences/papers, and general tech media.
5. **Filter and narrow** — enforce a strict 30-day freshness window, then apply scope relevance, objective relevance, evidence, actionability, and duplicate gates.
6. **Score and recommend** — evaluate survivors across Speed, Accuracy, Capacity, Tools, Agility, Objective Fit, and Stack Relevance, then provide Quick Wins, Deep Dives, a Watch List, and time-budgeted 80/20 picks.

## Usage

Load the Skill and answer the onboarding questions:

- **Scope mode:** `Auto-detect current repo`, `Manual/custom domains`, `Both: detect + manual`, or `Use saved .tech-stack state`
- **Domains:** required for manual/custom scope; accepts tech stack, patterns/practices, risk domains, and AI/tooling entries
- **Improvement objective(s):** `All objectives` or selected objectives from the catalog
- **Output depth:** `Headlines` or `Full details`

Manual/custom domains are organised into `.tech-stack/` category files such as `languages.md`, `frameworks.md`, `libraries.md`, `infrastructure.md`, `developer-tooling.md`, `ai-tooling.md`, `patterns-practices.md`, `risk-domains.md`, and `custom-domains.md`.

## `.tech-stack` State

`.tech-stack/` is local state for the target repository, not part of the skill package. It records the domains used for search and scoring so repeated runs can build on prior scope without committing repo-specific state.

The skill will:

- Create the folder only after the user chooses a scope mode.
- Add `.tech-stack/` to `.gitignore` if missing.
- Preserve manual/custom rows while refreshing detected rows during auto-detection.
- Store evidence paths, search hints, source hints, confidence, and last-updated dates.

## Example Output

The report can include:

- **Executive Summary** — scope mode, domains evaluated, objectives, source classes, candidate funnel, and top recommendation.
- **Quick Wins** — high-score, high-agility findings with direct stack/objective fit and concrete adoption steps.
- **Deep Dives** — high-potential findings that need investigation before adoption.
- **Watch List** — promising but early, narrow, or costly findings with revisit conditions.
- **`.tech-stack` State Summary** — what was created, refreshed, or reused.
- **80/20 Recommendation** — time-budget-aware picks that maximize impact for the selected scope.

## Extending the Skill

### Add an Objective

1. Add the objective to `resources/improvement-objectives.md`.
2. Add it to the onboarding options in `Skill.md`.

### Add a `.tech-stack` Category

1. Add the category file to `resources/tech-stack-state-template.md`.
2. Add detection guidance to `resources/tech-stack-detection.md`.

### Add a Source

1. Add it to `resources/source-registry.md`.
2. Add API/feed templates to `resources/search-api-guide.md` if it has a reliable mechanism.
3. Add generic query templates to `resources/source-search-templates.md`.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `dist/dev-level-up-skill.zip` containing the Skill definition and all resource files, then refreshes multi-agent symlinks.
