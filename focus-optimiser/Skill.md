---
name: focus-optimiser
description: Track large sets of related and unrelated tasks, projects, and deadlines as a dependency graph, then prioritise the highest-impact work using the 4 quadrants and other leadership task-management frameworks. Supports a daily focus mode and imports tasks from the Business Idea Incubator and Business Outreach Generator. Visualises status trees and projected timelines.
search_aliases:
  - focus
  - what to do next
  - prioritise
  - task graph
  - deadline
  - timeline
  - focus mode
---

## Overview

This Skill turns a messy collection of tasks, projects, and deadlines into a single, prioritised focus list. It stores a local task graph in `.focus/`, applies multiple modern prioritisation frameworks, and picks the highest-impact work to do next. It can also enter a **daily focus mode** that hides everything except the chosen top priorities, import tasks from the **Business Idea Incubator** and **Business Outreach Generator** skills, and defer stuck work to the **progress-unblocker** skill.

---

## When to Trigger

Trigger this Skill when the user asks any of the following:

- "What should I focus on?"
- "What is my most important task?"
- "Prioritise my tasks / to-do list / deadlines"
- "Show my focus mode / daily focus"
- "I am overwhelmed, what next?"
- "Visualise my tasks / project timeline"
- "Import tasks from my ideas / leads"

---

## State Model

Persistent state lives in `.focus/` at the target repo root. Do not create `.focus/` unless the user explicitly asks to track tasks, import, or focus.

| File | Purpose |
|------|---------|
| `.focus/task-graph.md` | Human-readable master task list, relationships, deadlines, status, effort estimates. Kept as a markdown table. |
| `.focus/task-graph.tsv` | Machine-readable tabular view of the same data for the bash visualiser. |
| `.focus/history.md` | Completed tasks with actual durations for velocity averaging. |
| `.focus/today.md` | Daily focus mode snapshot: date and the selected top task IDs. |
| `.focus/focus-log.md` | Log of past daily focus selections. |
| `.focus/config.md` | Optional flags: `auto_sync`, `focus_mode_auto`, `focus_mode_size`. |

### `.focus/task-graph.md` table columns

| id | title | project | status | urgency | importance | impact | confidence | effort | due | deps | source |
|----|-------|---------|--------|---------|------------|--------|------------|--------|-----|------|--------|

- `id` — integer, unique.
- `title` — one-line task description.
- `project` — project, idea, or lead the task belongs to.
- `status` — `notstarted`, `inprogress`, `blocked`, `complete`.
- `urgency`, `importance`, `impact`, `confidence` — 1–5 scores.
- `effort` — estimated hours or relative effort.
- `due` — optional ISO date `YYYY-MM-DD`.
- `deps` — comma-separated list of task IDs this task depends on.
- `source` — `manual`, `business-idea-incubator`, `business-outreach-generator`.

---

## Startup Sequence

Run this order on every interaction:

1. **Check for `.focus/`**. If it does not exist, treat it as "no state" and ask whether to create it from scratch, import from other skills, or build a new task list.
2. **Load config** — read `.focus/config.md` if it exists. Defaults: `auto_sync: false`, `focus_mode_auto: false`, `focus_mode_size: 5`.
3. **Daily focus reset** — if `.focus/today.md` exists and its date is older than today, archive its contents to `.focus/focus-log.md`, clear it, and prompt the user to choose a new daily focus.
4. **Sync / import** (if `auto_sync: true` or user asked) — load `resources/sync-import.md` and append new tasks from `.ideas/ideas/*.md`, `.ideas/trends/refresh-queue.md`, `.leads/*.md`, and `.leads/todo-index.md`. If `auto_sync: false`, ask before importing.
5. **Score and prioritise** — load the current graph and compute a `focus_score` for every incomplete task using the curated framework combination below.
6. **Suggest or render** — present the ranked list, offer to enter focus mode, or produce the requested visualisation.

---

## Prioritisation Frameworks

For every incomplete task, compute:

```
focus_score = (urgency * importance * impact * confidence) / (effort + 1)
```

Then apply the curated lenses:

1. **Eisenhower / 4 quadrants** — `urgent=5` and `important=5` are the quadrant-1 "do first" tasks. Any Q1 task with a dependency should be preceded by that dependency.
2. **RICE / ICE** — treat `impact * confidence / (effort + 1)` as a cross-check for reach/impact/confidence/effort.
3. **Pareto 80/20** — the top 20% of tasks by `focus_score` are likely to deliver most of the value.
4. **MoSCoW** — a `Must` tag overrides `Should`/`Could` regardless of score. Honour it by placing the task at the top of its project.
5. **Buffett 5/25** — the top 5 tasks become the daily focus list. Hide the rest until one of the top 5 is completed.
6. **OKR alignment** — add an `okr_bonus` of `+1` to the score for every task explicitly linked to a key result.

---

## Focus Mode

### Trigger

Offer to enter focus mode when:

- The user explicitly asks for it.
- Task priorities were just modified.
- A new task with `focus_score` in the top 20% was added.
- `.focus/today.md` is missing or expired.

### Selection

From the current ranked task list, select the top `N` tasks:

- `N` defaults to `5`, configurable via `focus_mode_size` in `.focus/config.md`.
- Only include `notstarted` or `inprogress` tasks.
- Exclude `blocked` tasks unless the user explicitly wants them; they should be handed to `progress-unblocker` first.
- Respect dependencies: if a selected task depends on another incomplete task, pull that dependency into the list first.

### Snapshot

Write the selected task IDs and today's date to `.focus/today.md`:

```markdown
# Daily Focus — 2026-09-27

Selected: 3, 7, 12, 4, 9

Notes:
- Top focus is #3 because it unlocks #7 and #12.
```

### Active Mode

While `.focus/today.md` is current:

- Default queries show only the selected tasks.
- Always offer a "show full graph" option.
- Marking a selected task `complete` removes it from `today.md` and triggers a re-suggestion to refill the top 5.

### Reset

At the next session, compare `.focus/today.md`'s date with today's date. If older:

1. Append the old snapshot to `.focus/focus-log.md`.
2. Clear `.focus/today.md`.
3. If `focus_mode_auto: true`, generate a new top-`N` list and present it for confirmation.
4. If `focus_mode_auto: false`, ask the user before selecting.

---

## Sync / Import Protocol

Before importing, read `resources/sync-import.md` for the exact field mapping and bash snippets.

### Default Behaviour

- Ask the user before importing.
- If `.focus/config.md` has `auto_sync: true`, import silently and then show a summary.

### Sources

- **Business Idea Incubator** (`business-idea-incubator`):
  - `.ideas/ideas/{slug}.md` becomes a project.
  - `**Immediate Next Action:**`, `**Missing / Next Gate:**`, `**Current Focus**`, and `**Next Step:**` entries become tasks.
  - `.ideas/trends/refresh-queue.md` rows become `trend-refresh` tasks.
- **Business Outreach Generator** (`business-outreach-generator`):
  - `.leads/{lead}.md` becomes a project.
  - `**Next Action:**` and `.leads/todo-index.md` rows become tasks.

### Deduplication

Skip an imported row if a task already exists with the same `source`, `project`, and `title`.

### Safety

- Never overwrite manual `.focus/` rows.
- Tag every imported task with its `source`.
- If a source file disappears, do not delete the imported task from `.focus/`; just mark it as stale.

---

## Blocked-Task Handoff

When a task has `status: blocked` or the user says a task is stuck:

1. Pause scoring and focus mode.
2. Call the `progress-unblocker` skill on the blocked task, passing the task title, project, and context.
3. From `progress-unblocker`'s output, take the unblocked sub-tasks and re-integrate them into `.focus/task-graph.md` as new rows linked to the original task.
4. Re-run scoring and focus mode.

---

## Visualisation Commands

Before rendering, load `resources/visualisation-snippets.md` for the colour codes, Mermaid templates, and quick scoring formula.

- **Full colour-coded tree** — render a project → status → task tree. Use red (`blocked`), amber (`inprogress`), green (`complete`), and grey (`notstarted`).
- **Focus-mode view** — same tree, but only the tasks listed in `.focus/today.md`.
- **Projected timeline** — use `resources/focus-visualiser.sh` to output an ASCII or Mermaid view based on `due` dates and `effort` estimates, adjusted by historical velocity from `.focus/history.md` if available.

### Bash Helper

```bash
bash resources/focus-visualiser.sh
bash resources/focus-visualiser.sh --today
bash resources/focus-visualiser.sh --format mermaid
```

---

## Output Rules

- Always show the top 5 ranked tasks first, with `focus_score` and quadrant.
- When in focus mode, show the current daily focus list and offer to "show full graph".
- Never mark a task `complete` unless the user confirms.
- A task is `blocked` only when it cannot proceed without an external input or decision.
- Suggest `progress-unblocker` for any `blocked` task before it appears in the focus list.
- Keep `.focus/task-graph.tsv` in sync with `.focus/task-graph.md` before running the bash visualiser.

---

## Output Summary

Return:

1. The current top-5 ranked tasks and their rationale.
2. The current daily focus list (if focus mode is active).
3. The requested visualisation (ASCII tree or Mermaid graph/timeline).
4. Any blocked tasks and a prompt to hand them off to `progress-unblocker`.
5. A short note about what changed if an import was performed.
