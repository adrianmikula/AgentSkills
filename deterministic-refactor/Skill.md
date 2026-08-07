---
name: deterministic-refactor
description: Plan, sandbox, and execute complex refactors deterministically for senior engineers. Builds a refactor impact tree, records containerized test runs, and applies the final change in one low-risk operation.
version: 1.0.0
---

## Overview

This skill is for senior engineers who need to refactor large, risky codebases without surprise breakage or merge-conflict churn.

It borrows the *experiment-in-a-container* model from the `JakartaMigrationMCP` project (`/home/adrian/Source/JakartaMigrationMCP`) — specifically the idea of running OpenRewrite-driven refactors inside an isolated sandbox, then applying the proven sequence in one clean operation.

The skill adds two new layers of intelligence:

- **Refactor Impact Tree (RIT)** — a structured map of everything a refactor can break: test coverage gaps, dependency changes, source-level changes, downstream production impacts (config, data, state), and explicit uncertainties.
- **Refactor Run Ledger** — a standardised record of every containerized experiment so runs can be compared, forked, and tuned.

## Modes

| Mode | Purpose |
|------|---------|
| **Experiment** | Run a refactor sequence inside a throwaway Testcontainer. No local files are changed. |
| **Apply** | Execute the validated sequence once, on a fresh branch, ready for a single PR. |

## Core Concepts

### 1. Refactor Impact Tree (RIT)

Before any code is changed, the skill builds `refactor-impact-tree.yaml`. Each branch captures a class of risk.

```yaml
refactor:
  target: "jakarta-ee-10"
  base_commit: "main@abc123"
  branches:
    - test_coverage_gaps:
        - module: "web"
          missing_tests: ["servlet-migration", "filter-chain"]
    - dependency_changes:
        - current: "javax.servlet:servlet-api:3.1"
          proposed: "jakarta.servlet:jakarta.servlet-api:6.0"
          compatibility: known
    - source_changes:
        - recipe: "org.openrewrite.java.migrate.jakarta.JavaxToJakarta"
          files_affected_estimate: 140
        - manual_patch: "custom-spring-boot-3-adapters"
          confidence: medium
    - downstream_production_impacts:
        - config_files: ["application.yml"]
        - data_migrations: ["flyway/V3__rename_packages.sql"]
        - state_changes: ["redis-cache-key-prefix"]
    - uncertainties:
        - dependency: "com.example:legacy-lib"
          issue: "No published Jakarta-compatible release"
        - recipe: "custom-SPI-migration"
          issue: "Outdated docs; manual scope unknown"
```

The tree is treated as a living document. Each experiment updates it with real pass/fail data.

### 2. Refactor Run Ledger

Every experiment is recorded in `runs/<run-id>.yaml`.

```yaml
run_id: "refactor-2026-08-04-001"
parent_run: "refactor-2026-08-04-000"
base_commit: "abc123"
recipe_set:
  - "org.openrewrite.java.migrate.jakarta.JavaxToJakarta"
  - "org.openrewrite.java.spring.boot3.UpgradeSpringBoot_3_2"
container_image: "mycompany/build-env:java-21"
metrics:
  build: "SUCCESS"
  test_failures: 0
  test_new_failures: 0
  lint_errors: 3
  coverage_delta: -0.02
  diff_size_lines: 2140
  duration_seconds: 184
outcome: "partial"
delta_from_parent: "Upgraded Spring Boot recipe from 3.0 to 3.2"
notes: "Still 3 lint errors in web/ that need a custom recipe."
```

The ledger is the single source of truth for comparing how well each run worked.

## Workflow

1. **Scope the refactor** — read the repo, the target, available OpenRewrite recipes, dependency manifests, and test layout.
2. **Build the RIT** — map every known risk and uncertainty before changing code.
3. **Plan the first experiment** — select a base commit, a recipe set, and pass/fail criteria.
4. **Run the container** — clone, apply, build, test, and collect metrics without touching the local working tree.
5. **Record the ledger** — persist the result and diff it against previous runs.
6. **Iterate** — tweak recipes, add manual patches, or narrow scope until the RIT is green and the latest run passes all criteria.
7. **Enter Apply mode** — create one branch, apply the proven recipe set, and prepare the final PR.

## Capabilities

### Analyze Refactor Target

**Inputs:** `projectRoot`, `target` (e.g. `jakarta-ee-10`, `spring-boot-3.2`, `java-21`), optional `pathFilter`

**Outputs:** `RefactorAnalysis { target, modulesAtRisk[], availableRecipes[], dependencyConflicts[], impactTreeDraft }`

**Logic:**
1. Scan build files for direct and transitive dependencies.
2. Look for OpenRewrite recipes matching the target in `build.gradle` / `pom.xml` / `rewrite.yml`.
3. Identify files/modules with the highest churn or lowest migration-related test coverage.
4. Draft the first RIT.

### Build Refactor Impact Tree

**Inputs:** `RefactorAnalysis`

**Outputs:** `refactor-impact-tree.yaml`

**Logic:**
1. For each dependency, flag `known`, `unknown`, or `incompatible` status.
2. For each recipe, estimate files affected and confidence.
3. For each module, list test coverage gaps that would catch a refactor regression.
4. Surface downstream config/data/state changes explicitly.
5. Record every unknown as a node with a research owner or exit criterion.

### Run Refactor Experiment

**Inputs:** `experiment: { baseCommit, recipeSet[], containerImage, timeoutSeconds, passCriteria }`

**Outputs:** `ExperimentResult { runId, buildStatus, testSummary, metrics, runLogPath }`

**Logic:**
1. Build or reuse a container image with the project build toolchain.
2. Inside the container, clone the repo and check out `baseCommit`.
3. Apply `recipeSet` via OpenRewrite or equivalent tooling.
4. Run full build, tests, lint, and coverage collection.
5. Report metrics and write `runs/<run-id>.yaml`.
6. Never modify files outside the container.

### Compare Runs

**Inputs:** `runA`, `runB`

**Outputs:** `RunDiff { changedVariables[], metricDelta, recommendation }`

**Logic:**
1. Diff recipe sets, base commits, and manual patches.
2. Compare build, test, lint, and coverage metrics.
3. Suggest the smallest next tweak that closes the most red RIT nodes.

### Apply Refactor

**Inputs:** `runId` of a successful experiment

**Outputs:** `PullRequest { branch, commitRange, summary }`

**Logic:**
1. Verify the chosen run is green and the RIT has no unresolved red nodes.
2. Create a fresh branch from the current `main` tip.
3. Replay the exact recipe set and manual patch order from the ledger.
4. Open a single PR with the full change and a generated summary.

## Configuration

| Parameter | Default | Description |
|-----------|---------|-------------|
| `container_image` | auto-detected | Base Docker image that can build the repo |
| `default_timeout_seconds` | 1800 | Maximum time for one experiment |
| `rit_path` | `refactor-impact-tree.yaml` | Where the RIT is written |
| `ledger_dir` | `runs/` | Where experiment records are stored |
| `openrewrite_active_recipes` | `[]` | Active recipe list for OpenRewrite |

## Dependencies

- OpenRewrite or the project's native refactoring toolchain
- Docker / Testcontainers for the experiment sandbox
- The project's build tool (Gradle, Maven, npm, etc.)
- Git

## When to Use

- **Use this skill** when the refactor is large, spans modules or dependencies, and the cost of a bad merge is high.
- **Do not use it** for small, localised refactors that can be done and reviewed in a single small PR.

## Example Output

After a successful experiment:

```yaml
run_id: "refactor-2026-08-04-007"
outcome: "success"
rit_status: "all green"
branch: "migrate/jakarta-ee-10"
pr_summary: |
  Applied OpenRewrite recipe set JavaxToJakarta + Spring Boot 3.2 upgrade.
  Build, tests, and lint pass. Coverage change: -0.01%.
  No unresolved RIT nodes. 2,140 lines changed across 142 files.
```
