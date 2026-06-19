# Agentic CI/CD Optimisations

Reference for setting up CI/CD pipelines optimized for agent debugging workflows. See `Skill.md` Layer 4d for usage.

## Core Principle: Signal vs Confidence

Split every pipeline into two tiers:

| Tier | What | Target time | Agent usage |
|------|------|-------------|-------------|
| **Signal** | lint → typecheck → fast tests (unit + contract) | <30s | Every push |
| **Confidence** | integration → security → full matrix → deploy | minutes | CI only, async |

> CI is no longer the feedback loop. CI is the *verifier* of a loop that already happened locally.

## Agent-Specific Pipeline Patterns

### 1. Pipeline dry-run validation
Validate pipeline config without executing:
- GitHub Actions: `gh workflow run --dry-run`
- GitLab CI: `gitlab-ci-lint`
- Buildkite: `buildkite-agent pipeline validate`

Agents should validate pipeline config before pushing — most CI failures are YAML/config errors, not code errors.

### 2. Change-aware test selection
Map code diffs to minimal test sets:
```
git diff --name-only HEAD~1 → affected modules → related tests only
```
Skip 70-95% of pipeline per change. Agent PRs go green in seconds.

### 3. Fast-fail lint before containers
Rule: No container starts until lint + config + typing pass. Containers are expensive; agents break syntax constantly.

### 4. Local CI mirrors
Maintain local scripts that mirror CI logic:
```
ci signal --changed-only
```
This gives CI-equivalent results in 1-10s before pushing. Not Docker Compose — it's CI logic extracted into runnable scripts.

### 5. Persistent CI workers
Warm everything: long-lived runners, warm caches, sticky workspaces, preloaded toolchains. Cold starts dominate runtime.

### 6. Contract-first gates over integration-first
Instead of spinning services for API tests, use schema contracts + consumer-driven tests. Runs in milliseconds, no infra needed.

## What to Avoid in the Inner Loop
- Full pipeline on every commit
- Matrix explosion for early feedback
- Security scans before unit confidence
- Integration tests before signal passes
- CI-only logic with no local equivalent

## Agent-Facing CI Commands (add to COMMANDS.md)

| Command | Purpose | Expected time |
|---------|---------|---------------|
| `ci lint` | Lint only | <5s |
| `ci signal --changed` | Fast signal, affected only | <30s |
| `ci validate` | Pipeline config dry-run | <2s |
| `ci full` | Full confidence suite | async |
