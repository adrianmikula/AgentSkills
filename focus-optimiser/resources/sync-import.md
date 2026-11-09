# Sync / Import Protocol

The skill can import tasks from the **Business Idea Incubator** and **Business Outreach Generator** skills so the user has one place to see all work.

## Safety Rules

- Importing is **read-only** by default. It never overwrites `.focus/` files unless the user explicitly runs the import.
- If `.focus/config.md` contains `auto_sync: true`, the skill may import silently on startup and then present a summary.
- Every imported task is tagged with `source: business-idea-incubator` or `source: business-outreach-generator` so it can be refreshed without touching manually created tasks.
- Deduplicate by `source + slug + action text`. Exact duplicates are skipped.

## Source Locations

| Skill | Path | What to Import |
|-------|------|----------------|
| `business-idea-incubator` | `.ideas/ideas/{slug}.md` | Each idea becomes a project; `**Immediate Next Action:**`, `**Missing / Next Gate:**`, `**Current Focus**`, and `**Next Step:**` log entries become tasks. |
| `business-idea-incubator` | `.ideas/trends/refresh-queue.md` | Rows in the refresh queue become `trend-refresh` tasks. |
| `business-outreach-generator` | `.leads/{lead}.md` | Each lead becomes a project; `**Next Action:**` entries become tasks. |
| `business-outreach-generator` | `.leads/todo-index.md` | Rows become tasks grouped by the lead name. |

## Field-to-Task Mapping

### Business Idea Incubator

For each `.ideas/ideas/{slug}.md`:

1. Read `**Slug:**` and the `# [Idea Name]` to set `project = [Idea Name]`.
2. Read `**Immediate Next Action:**` → `task` with `status: notstarted`, `source: business-idea-incubator`.
3. For each `**Missing / Next Gate:**` bullet → `task` with `status: notstarted`.
4. For each `**Next Step:**` in `## Progress Log` → `task` with `status: notstarted` and the log date.
5. If `## Current Focus` exists, create a `current-focus` task for the idea.

### Business Outreach Generator

For each `.leads/{lead}.md`:

1. Read the `# [Business Name]` to set `project = [Business Name]`.
2. Read `**Next Action:**` → `task` with `status: notstarted`, `source: business-outreach-generator`.
3. If a `**Due:**` or follow-up date exists, set `due` on the task.

For `.leads/todo-index.md`:

1. Parse the table rows.
2. For each `Next Action`, create a `task` with `project = [Lead/Company]`, `source: business-outreach-generator`, and `status: notstarted`.

## Bash Snippets

### Discover importable sources

```bash
ls -1 .ideas/ideas/ 2>/dev/null | sed 's/\.md$//'
ls -1 .leads/ 2>/dev/null | sed 's/\.md$//' | grep -v '^todo-index$'
```

### Extract immediate next actions from idea files

```bash
for f in .ideas/ideas/*.md; do
  slug=$(basename "$f" .md)
  idea=$(sed -n 's/^# //p' "$f" | head -1)
  awk -v slug="$slug" -v idea="$idea" '
    /^\*\*Immediate Next Action:\*\*/ { getline; gsub(/^\*\*[[:space:]]*-[[:space:]]*/,""); print idea "\t" $0 "\tbusiness-idea-incubator\t" slug }
  ' "$f"
done
```

### Extract lead next actions

```bash
for f in .leads/*.md; do
  [[ "$f" == *todo-index.md ]] && continue
  lead=$(sed -n 's/^# //p' "$f" | head -1)
  awk -v lead="$lead" '
    /^\*\*Next Action:\*\*/ { getline; gsub(/^\*\*[[:space:]]*-[[:space:]]*/,""); print lead "\t" $0 "\tbusiness-outreach-generator\t" lead }
  ' "$f"
done
```
