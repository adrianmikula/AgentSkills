# COMMANDS.md Template

Template for creating a command catalogue in Layer 4 of the Optimise Agentic Coding skill.

## Usage
Copy this into `COMMANDS.md` at the repo root. Fill in the actual commands detected during stack analysis.

## Template

```markdown
# Commands

## Fast iteration (inner loop — run after every change)

| Category | Command | Expected time |
|----------|---------|---------------|
| Lint | `---` | <2s |
| Type check | `---` | <2s |
| Fast tests | `---` | <5s |
| Dev server | `---` | <2s |

## Full validation (CI — run before commit/push)

| Category | Command | Expected time |
|----------|---------|---------------|
| Full test suite | `---` | ~2min |
| Build | `---` | ~1min |
| E2E tests | `---` | ~5min |

## Debugging

| Purpose | Command |
|---------|---------|
| View logs | `---` |
| Run with debug mode | `---` |
| Inspect DB | `---` |

## Common gotchas

- `---` commands must be run from project root, not a subdirectory
- `---` requires `---` to be running first
- Set `LOG_LEVEL=debug` before running for verbose output
```

## Per-stack command detection rules

When filling the template, detect commands from:
- `package.json` scripts (Node/Next.js)
- `Makefile` targets (Python/Go/Rust)
- `pyproject.toml` tool configs (Python)
- `Cargo.toml` scripts (Rust)
- `build.gradle` tasks (Java Gradle)
- `pom.xml` plugins (Java Maven)
- `.csproj` configurations (.NET)
- `Rakefile` tasks (Rails)
- `Gemfile` scripts (Rails)
