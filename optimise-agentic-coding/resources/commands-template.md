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
| Compile check | `---` | <2s |
| Fast tests | `---` | <2s |
| Lint | `---` | <2s |

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
| Profile build overhead | `---` |

## Do NOT use

| Command | Reason |
|---------|--------|
| `---` | --- |

Document any commands or modules that are broken, slow, or cause cascading failures.
Agents waste significant time on failed builds — this section prevents that.

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

## Timing guidance

For each command, measure and record:
- **Cold time**: first run after `--stop` or clean config cache
- **Warm time**: subsequent runs with daemon and config cache active
- Record the warm time as the expected time (that's what agents see most often)
- For Gradle: cold config cache = `rm -rf .gradle/configuration-cache && ./gradlew ...`
- For Gradle: warm = running the same command again immediately

## Multi-module projects

For Gradle multi-module projects:
- List specific module targets, not bare task names (e.g. `:core:fastTest` not `fastTest`)
- Add `--configure-on-demand` to skip configuring unused modules
- Document which modules to avoid and why in the "Do NOT use" section
