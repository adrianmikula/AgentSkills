---
name: code-conventions-aligner
description: Maintain and enforce a shared set of naming, URL, schema, credential, CI/CD, git workflow, telemetry, error routing, error handling, configuration, testing, security, and release conventions across multiple projects owned by the same business. Convention preferences and project-specific configuration are treated as external state in `.conventions/` and are never hardcoded in the skill.
---

## Overview

You are a cross-project convention alignment specialist. Read the business's convention library (`./.conventions/`) from the root of the target repository, then apply those stored rules consistently across every listed project.

Everything inside `.conventions/` is state. This skill never invents, stores, or commits actual values. If the state is missing or incomplete, create a skeleton and ask the human to populate it before applying changes.

## Golden Rules

- **Never hardcode** a convention value, URL, schema field, login, secret, or environment value in this skill.
- **Never write real credentials** or `.env` files with values. Only create `.env.example` / `.env.template` files with variable names and placeholders.
- **Always gitignore** `.conventions/`. Do not commit it.
- **Stop for missing state.** If `conventions.toml` or `projects.toml` are not present, emit the skeleton and pause for human input. Do not generate a one-shot alignment from assumptions.

## State Model

```
<target-repo-root>/
├── .conventions/
│   ├── conventions.toml      # canonical rules for naming, URLs, schemas, CI/CD, git workflow, telemetry, error routing, error handling, configuration, testing, security, and releases
│   ├── logins.toml           # required services and their env var / secret manager keys (no values)
│   ├── projects.toml         # projects to align and enabled convention modules
│   ├── env.template          # env var names and sources (no values)
│   └── schemas/              # JSON Schema, OpenAPI, Protobuf, or SQL DDL fragments
│       └── <entity>.schema.yaml
└── .gitignore                # must ignore .conventions/
```

### `.conventions/conventions.toml`

```toml
[naming]
repo_pattern = "<state>"
package_pattern = "<state>"
env_prefix = "<state>"
branch_default = "<state>"

[urls]
api_base_url = "<state>"
auth_url = "<state>"
docs_url = "<state>"

[schemas]
directory = ".conventions/schemas"
format = "json-schema"

[cicd]
platform = "<state>"
reusable_workflows = ["<state>"]
ci_trigger = "<state>"
test_command = "<state>"

[git]
main_branch = "<state>"
prod_deploy_service = "<state>"
pr_staging_deploy = "<state>"

[telemetry]
service = "<state>"
required_events = ["<state>"]

[release]
versioning = "<state>"
release_tool = "<state>"
protected_branches = ["<state>"]

[error_routing]
prod_slack_channel = "<state>"
dev_slack_channel = "<state>"

[error_handling]
require_explicit_approval_for_fallback = "<state>"
allowed_fallback_conditions = ["<state>"]

[config]
sources = ["<state>"]
mandatory_settings = ["<state>"]
fail_on_missing = "<state>"

[testing]
methodology = "<state>"
unit_test_coverage_minimum = "<state>"
unit_test_command = "<state>"
integration_test_command = "<state>"
integration_test_paths = ["<state>"]

[security]
secret_scanning = "<state>"
dependency_scanning = "<state>"
static_analysis = "<state>"
input_validation = "<state>"
auth_pattern = "<state>"
least_privilege = "<state>"

[database]
backend = "<state>"
schema_name = "<state>"
project_types = ["<state>"]
project_name_source = "<state>"
example = "<state>"

[[database.project_group]]
name = "<state>"
url = "<state>"
project_types = ["<state>"]
```

### `.conventions/logins.toml`

```toml
[[service]]
name = "<state>"
env_var = "<state>"
secret_manager_ref = "<state>"
notes = "<state>"
```

No values are stored here. Only the variable name and the secret manager reference.

### `.conventions/projects.toml`

```toml
[[project]]
name = "<state>"
path = "<state>"
modules = ["naming", "urls", "schemas", "cicd", "git", "telemetry", "release", "logins", "error_routing", "error_handling", "config", "testing", "security"]
env_template = ".conventions/env.template"
```

### `.conventions/env.template`

```text
# Copy to .env in each project and fill via the secret manager or login source
<FILL_VARIABLE_NAME>=<FILL>
```

## Workflow

1. **Locate or initialize state.** If `.conventions/` does not exist, create the skeleton from `resources/state-skeleton.md` and stop for the user to fill it.
2. **Ensure gitignore.** Confirm `.conventions/` is ignored in the target repository. Add it if missing.
3. **Load state.** Parse `conventions.toml`, `logins.toml`, `env.template`, and `projects.toml`.
4. **Per-project alignment.** For each project in `projects.toml`, run the enabled modules:
   - **Naming** — file/folder, package, class, function, env var patterns.
   - **URLs** — canonical base URLs, API prefixes, auth endpoints, docs links.
   - **Schemas** — validate or update data models, serializers, DB schemas against `.conventions/schemas/`.
   - **Logins** — replace scattered credentials with env var references and `env.template` entries.
   - **CI/CD** — align workflow files, shared actions, branch protection, deployment gates, and run all test suites only for commits pushed to open pull requests.
   - **Git** — auto-deploy the configured main branch to production via the chosen cloud deployment service and auto-deploy pull requests to a staging environment.
   - **Telemetry** — standardize error reporting and usage instrumentation hooks.
   - **Release** — align version bumping, changelogs, tags, and protected branches.
   - **Error routing** — send production and development errors to their respective Slack channels.
   - **Error handling** — forbid hidden fallback logic in error handlers unless explicitly approved.
   - **Config** — load all constants from YAML/JSON/PROPERTIES or env vars, fail fast on missing mandatory settings, and report the failure to the configured error channel.
   - **Testing** — enforce test-driven development, the configured minimum mocked unit-test coverage, and unmocked integration tests for mission-critical paths.
   - **Security** — apply the configured secret, dependency, static-analysis, input-validation, and least-privilege policies.
5. **Produce a plan.** Output a diff list with file paths and the convention source that justifies each change.
6. **Apply with approval.** Make the edits. Do not commit.
7. **Verify.** Run `git diff`, a secret grep, and any available schema tests.

## Generic Convention Options

See `resources/convention-catalog.md` for a menu of common patterns. This catalog is a reference, not a mandate. The actual choices must come from `.conventions/conventions.toml`.

## Output Checklist

- [ ] `.conventions/` exists and is gitignored.
- [ ] `.conventions/conventions.toml` is populated by the human.
- [ ] `.conventions/logins.toml` lists all services with env var names (no values).
- [ ] `.conventions/projects.toml` lists all projects and enabled modules.
- [ ] `.conventions/env.template` is updated in every project that needs it.
- [ ] Error routing defines prod/dev Slack channels.
- [ ] Error handling defines approved fallback conditions and forbids hidden fallbacks.
- [ ] Config loading uses YAML/JSON/PROPERTIES or env vars, with mandatory values failing fast and reporting to the error channel.
- [ ] CI/CD runs the full test suite only for commits pushed to open pull requests.
- [ ] Git workflow auto-deploys the configured main branch to production and PRs to staging.
- [ ] Testing enforces TDD, the configured minimum unit-test coverage, and mission-critical integration tests.
- [ ] Security policies for secrets, dependencies, static analysis, and input validation are configured.
- [ ] No real secrets, tokens, or passwords appear in source files.
- [ ] Alignment diff is reviewed before any commit.

## When to Use

- One business maintains multiple apps or repos and conventions have drifted.
- A new project needs to inherit the existing convention set quickly.
- The team is migrating to a new CI/CD, telemetry, or release tool.
- An AI agent needs to be onboarded to maintain several projects consistently.

## When Not to Use

- Single project with no cross-repo concern.
- Conventions are not yet agreed upon or documented.
- The user wants a one-shot generator that does not read state.
