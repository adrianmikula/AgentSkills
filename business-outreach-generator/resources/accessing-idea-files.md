# Accessing Idea Files

The `.ideas/` directory is **gitignored**. The `glob` and `grep` tools skip gitignored paths by default, so they **will not** return files under `.ideas/`. You must use `bash` and the `read`/`write` tools on explicit full paths instead.

| Task | How |
|------|-----|
| List all ideas | `ls <repo-root>/.ideas/ideas/` (bash) |
| List all trends | `ls <repo-root>/.ideas/trends/` (bash) |
| Read a file | `read` tool on `<repo-root>/.ideas/ideas/<slug>.md` |
| Write a file | `write` tool on `<repo-root>/.ideas/ideas/<slug>.md` |
| Check if a file exists | `test -f <repo-root>/.ideas/ideas/<slug>.md` (bash) or `ls <repo-root>/.ideas/ideas/<slug>.md` (bash) |
| Search file contents | `grep -l pattern <repo-root>/.ideas/ideas/*.md` (bash) or read each file individually |

The `<repo-root>` is the project root where the `.ideas/` folder lives. Both skills are cloned into the same working tree, so `<repo-root>` is the parent of the current skill directory.

When this skill references `../.ideas/`, resolve it to `<repo-root>/.ideas/` before using `read`/`write`/bash.

## Positioning Section

Each idea file can include a `## Positioning` section that tracks the evolving elevator pitch and USP:

```markdown
## Positioning

- **Elevator Pitch:** [1-2 sentence value prop]
- **USP:** [What differentiates from competitors]
- **Revision History:**
  - YYYY-MM-DD — [what changed and why]
```

The `## Positioning` section should be updated whenever outreach, customer conversations, or competitive research reveals a better way to describe the offering. Each revision should include a dated entry explaining the shift. The Outreach Skill reads this section when generating messages to ensure consistent positioning.

## Gitignore Note

The `.ideas/` directory is listed in `.gitignore`, but that only affects `git` commands. All OS-level file operations (`ls`, `read`, `write`, `test -f`) work normally. The only limitation is that `glob` and `grep` tools may not index these files.
