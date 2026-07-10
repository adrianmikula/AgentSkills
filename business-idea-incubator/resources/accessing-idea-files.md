# Accessing Idea Files

The `.ideas/` directory is **gitignored**. The `glob` and `grep` tools skip gitignored paths by default, so they **will not** return files under `.ideas/`. You must use `bash` and the `read`/`write` tools on explicit full paths instead.

**Critical: First check if `.ideas/` exists at all.** Start every session with:
```
ls .ideas/            (bash — will show contents or error if missing)
```
If `ls` errors, the directory doesn't exist — treat as "no existing state." Do NOT use `glob` to check for `.ideas/` — it will return nothing even if the directory exists.

| Task | How |
|------|-----|
| List all ideas | `ls .ideas/ideas/` (bash, from repo root) |
| List all trends | `ls .ideas/trends/` (bash, from repo root) |
| Read a file | `read` tool on `.ideas/ideas/<slug>.md` (from repo root) |
| Write a file | `write` tool on `.ideas/ideas/<slug>.md` (from repo root) |
| Check if a file exists | `test -f .ideas/ideas/<slug>.md` (bash) or `ls .ideas/ideas/<slug>.md` (bash) |
| Search file contents | `grep -l pattern .ideas/ideas/*.md` (bash) or read each file individually |

All paths are relative to the project root (where `.ideas/` lives). The agent's working directory is typically the repo root; if not, resolve `.ideas/` to an absolute path first.

## Gitignore Note

The `.ideas/` directory is listed in `.gitignore`, but that only affects `git` commands. All OS-level file operations (`ls`, `read`, `write`, `test -f`) work normally. The only limitation is that `glob` and `grep` tools may not index these files.
