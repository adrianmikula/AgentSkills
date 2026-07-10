---
name: skillify-codebase
description: Examine an existing codebase, extract its core logic and inputs/outputs into a reusable Claude skill, and establish a deterministic, config-driven skill-sync workflow that keeps the skill (upstream spec) and code (downstream implementation) in lockstep.
---

## Overview

This Skill extracts the functional essence of a codebase into a skill that mirrors the codebase's inputs and outputs. The resulting skill becomes the **upstream source of truth** — changes flow from skill → code via a documented mapping and sync process.

**Core insight:** Instead of maintaining code and documentation separately, the Claude skill is the executable specification. Code is the rendered output. When business logic changes, update the skill and sync to code.

An optional **research mode** extends this model with affordance schemas (fixed vs open layers), lockfile-pinned builds, skill dependency trees, and conflict resolution. See `resources/research-mode.md` to activate.

---

## Core Concepts

### Upstream vs Downstream

```
┌─────────────────────┐     skill-sync     ┌─────────────────────┐
│  Claude Skill       │  ────────────────→  │  Production Code    │
│  (upstream spec)    │  ←────────────────  │  (downstream impl)  │
│                     │  reverse-sync       │                     │
│  - Inputs/outputs   │  (rare — manual)    │  - Webapp / API     │
│  - Core logic       │                     │  - CLI tool         │
│  - Business rules   │                     │  - Library          │
└─────────────────────┘                     └─────────────────────┘
```

### Config-Driven Parameter Pattern

All configurable numeric/literal parameters (thresholds, weights, rate limits, timeouts, constants, enums, lists, paths, etc.) live in a separate **config file** in YAML format — not in the skill markdown.

```
<skillified-project>/
├── config.yaml       ← ALL parameters live here. Primary sync target.
└── mapping.toml      ← Maps skill sections to config keys and code locations.
```

**Why this matters for determinism:**
- When the upstream skill spec changes, the sync agent only edits `config.yaml`
- The skill markdown is prose — the config file is the only structured, machine-parseable layer
- Parameter changes are isolated and reviewable in a single file
- The mapping table points every spec section to its config path, not to a line of source code

### Version Tracking

Every skillified project tracks version in the config file:

```yaml
# config.yaml
skill_version: "1.0.0"
```

The version is also recorded in `mapping.toml`:

```toml
skill_version = "1.0.0"
codebase_version = "{git-hash}"
```

When syncing, the AI agent updates the version in both files. A mismatch between `config.yaml` and `mapping.toml` is the first sign of drift.

---

## Research Mode (Optional)

An optional **research mode** extends the skillify model with:

- **Affordance schema** — formally separating what's fixed (non-negotiable contract) from what's open (implementation detail free to vary between generations)
- **Lockfile** (`skill.lock`) — pinning which version of the upstream skill a piece of code was compiled against, so open-layer changes never trigger a rebuild but fixed-layer changes do
- **Skill tree** — skills reference other skills, the way packages reference packages, with a dependency graph
- **Conflict resolution** — recording precedence rules when two upstream skills disagree
- **Codebase decomposition** — for complex projects (>= 5 modules, >= 50k LOC, or >= 3 entry points), automatically generates a multi-skill tree with one skill per high-level module, linked by upstream/downstream sync relationships

Research mode is **off by default**. Activate it per project by setting `research_mode: true` in the skill frontmatter or `research_mode.enabled: true` in `config.yaml`.

See `resources/research-mode.md` for the complete theoretical framework, lockfile format, skill tree traversal rules, conflict resolution authority levels, and activation workflow.

See `resources/module-decomposition.md` for the codebase decomposition workflow — complexity assessment, module discovery, dependency graph extraction, multi-skill generation, and cascading sync across the skill tree.

**AI agent instruction:** When this skill is first loaded, inform the user that research mode is available on request (affordance schemas, lockfile, skill tree, conflict resolution, and module decomposition for complex projects). Do not activate it unless the user asks.

---

## Phase 1 — Codebase Analysis

### 1.1 Map the Codebase

Analyze the target codebase to build a functional inventory:

| Artifact | What to extract | Example |
|----------|----------------|---------|
| Entry points | Routes, handlers, event listeners | `POST /api/orders`, `OrderPlaced` event |
| Core domain logic | Business rules, validations, calculations | Tax calculation, eligibility checks |
| Data models | Schemas, types, interfaces | `Order { id, items, total }` |
| External integrations | APIs, databases, third-party services | Square POS API, PostgreSQL |
| Inputs | Request schemas, CLI args, event payloads | `CreateOrderRequest { customerId, items[] }` |
| Outputs | Response schemas, side effects, return values | `OrderConfirmation { orderId, eta }` |
| Error modes | Failure states, error types, edge cases | `OutOfStockError`, `ValidationError` |
| Configuration | Env vars, feature flags, constants | `MAX_ORDER_ITEMS=50`, `TAX_RATE=0.1` |
| Test files | Unit/integration/E2E tests | `tests/orders.test.ts` |

### 1.2 Extract Functional Boundaries

Group related inputs/outputs into skill capabilities. Each capability maps to one or more code files:

```
Codebase: Cafe ordering webapp

Capability A: "Browse menu"
  Inputs:  category filter (optional), search query (optional)
  Outputs: list of menu items with availability
  Maps to: src/routes/menu.ts, src/services/menuService.ts

Capability B: "Place order"
  Inputs:  customer info, items[], payment method
  Outputs: order confirmation, payment receipt
  Maps to: src/routes/orders.ts, src/services/orderService.ts, src/payment/

Capability C: "Manage cafe settings"
  Inputs:  operating hours, menu prices, tax rate
  Outputs: confirmation, updated config
  Maps to: src/routes/admin.ts, src/services/configService.ts
```

### 1.3 Extract Configurable Parameters

For each capability, identify ALL parameters that are currently hardcoded or configurable:

| Category | Examples | Config file destination |
|----------|----------|------------------------|
| Thresholds | `max_order_items=50`, `tax_rate=0.1` | `config.yaml` → `thresholds` section |
| Weights/scoring | `relevance_weight=0.6`, `severity_weight=0.4` | `config.yaml` → `scoring` section |
| Constants | `default_page_size=20`, `cache_ttl_ms=300000` | `config.yaml` → `constants` section |
| Enums/lists | `valid_categories=["food","drinks"]`, `blacklisted_ips=[]` | `config.yaml` → `lists` section |
| External URLs | API endpoints, data source URLs | `config.yaml` → `data_sources` section |
| Timeouts/limits | `request_timeout_ms=5000`, `max_retries=3` | `config.yaml` → `limits` section |

Every identified parameter MUST be extracted to the config file during skillification.

---

## Phase 2 — Skill Generation

### 2.1 Output Structure

Each skillified codebase produces one directory with the config-driven pattern:

```
.opencode/skill/skillified-{project-name}/
├── SKILL.md              # The generated skill — inputs, outputs, core logic
├── config.yaml            # ALL configurable parameters (PRIMARY SYNC TARGET)
├── mapping.toml           # Granular section-by-section skill-to-code mapping table
│                         # Also contains conflict_resolution rules (research mode)
├── skill.lock             # Lockfile — research mode only. Pins upstream versions + hashes.
├── sync-workflow.md       # Sync process documentation
└── resources/
    ├── data-models.md     # Schema definitions
    ├── api-contract.md    # Input/output contracts
    └── test-cases.md      # Example invocations + expected outputs
```

**Content rules:**
- All files are MD, YAML, TOML, or JSON — never source code (.ts, .js, .py, .rs, .kt, .java, etc.)
- Lightweight CLI helper scripts (bash/PowerShell) may be added to `resources/` for common operations (e.g. config validation, lockfile verification). These are the only exception.

### 2.2 SKILL.md Template

The generated SKILL.md must mirror the webapp's functional interface:

```markdown
---
name: skillified-{project-name}
description: {one-line summary of what the codebase does}
version: 1.0.0
---

## Overview

{2–3 sentence description of the codebase's purpose and architecture}

## Capabilities

### {Capability A: Verb + noun}

{Description of what this capability does}

**Logic:**
{Concise description of the core business logic — rules, validations, calculations.
This section should be precise enough that an AI agent can implement the logic correctly.}

**Config parameters used:**
| Parameter | Config path | Purpose |
|-----------|-------------|---------|
| `{threshold}` | `thresholds.{key}` | {what it controls} |

**Error states:**
| Condition | Error | Handling |
|-----------|-------|----------|
| {condition} | {error type} | {fallback behavior} |

**Affordance schema (optional — see `resources/research-mode.md`):**
> When research mode is active, add **Fixed contract** and **Open layer** tables here.
> Fixed contract: inputs, outputs, business rules, error semantics (stable).
> Open layer: algorithm, structure, framework choices (free to vary between builds).

**Example:**
```json
// Input
{json example}
// Output
{json example}
```

### {Capability B}

...

## Configuration

| Variable | Config path | Default | Description |
|----------|-------------|---------|-------------|
| `{var}` | `{section}.{key}` | `{default}` | {description} |

## Dependencies

- Runtime: {language + version}
- Key libraries: {list}
- External services: {list}

## Test Cases

See `resources/test-cases.md` for full invocation examples and expected outputs.
```

### 2.3 Config File Template (`config.yaml`)

```yaml
# Config for skillified-{project-name}
# skill_version: 1.0.0  — also recorded in mapping.toml

thresholds:
  max_order_items: 50
  tax_rate: 0.1
  free_shipping_min: 30

scoring:
  category_weights:
    relevance: 0.6
    severity: 0.4
  pass_threshold: 0.7

lists:
  valid_categories:
    - food
    - drinks
    - specials
  blacklisted_ips: []

data_sources:
  menu_api: "https://api.example.com/menu"
  order_api: "https://api.example.com/orders"

limits:
  request_timeout_ms: 5000
  cache_ttl_ms: 300000
  max_retries: 3

# Research mode (optional — see resources/research-mode.md)
research_mode:
  enabled: false
```

### 2.4 Generation Rules

- **Inputs and outputs of the skill MUST match the inputs and outputs of the webapp.** Every field the webapp accepts or returns must be represented in the skill's capability definitions.
- **Core logic must be extracted and documented** at a level where an AI agent could re-implement the feature correctly — rule descriptions, edge cases, business decisions.
- **Implementation details (frameworks, deployment, infrastructure) are NOT included** in the skill. Those belong in `mapping.toml`.
- **Error states must be thorough** — document every failure mode the webapp handles, not just the happy path.
- **All configurable parameters MUST be extracted to `config.yaml`**. The skill markdown describes logic, but parameter values live in config. No hardcoded values in the skill spec.
- **Every capability's Logic section must list the config parameters it uses**, linking each to its config path. This is what makes the mapping table deterministic.

---

## Phase 3 — Skill-to-Code Mapping

### 3.1 Granular Mapping Table (`mapping.toml`)

Unlike a simple capability→file mapping, this table maps every **section of the skill markdown** to its config key and implementation file:

```toml
# Skill-to-code mapping for {project-name}
# Generated: {date}

skill_version = "1.0.0"
codebase_version = "{git-hash}"

# Each capability has a granular section-by-section mapping
[[capabilities]]
name = "Browse menu"
description = "List menu items with optional filtering"

  # Every paragraph/section in the skill's Logic maps to a config key + code location
  [[capabilities.sections]]
  skill_section = "Logic — category filtering"
  config_path = "lists.valid_categories"
  config_file = "config.yaml"
  impl_files = [
    { file = "src/routes/menu.ts", type = "entrypoint", function = "getMenu" },
    { file = "src/services/menuService.ts", type = "logic", function = "filterByCategory" },
  ]
  test_files = ["tests/menu.test.ts"]

  [[capabilities.sections]]
  skill_section = "Logic — tax calculation"
  config_path = "thresholds.tax_rate"
  config_file = "config.yaml"
  impl_files = [
    { file = "src/services/orderService.ts", type = "logic", function = "calculateTotal" },
  ]
  test_files = ["tests/orders.test.ts"]

  [[capabilities.sections]]
  skill_section = "Error states — invalid category"
  config_path = null  # error handling has no config parameter
  impl_files = [
    { file = "src/middleware/validation.ts", type = "logic", function = "validateCategory" },
  ]
  test_files = ["tests/validation.test.ts"]

# ... more capabilities

[data_models]
  [[data_models.fields]]
  model = "Order"
  field = "total"
  type = "number"
  maps_to_skill_param = "orderTotal"
  config_path = "thresholds.tax_rate"
  file = "src/models/order.ts"

[config_mapping]
  skill_var = "tax_rate"
  code_var = "TAX_RATE_PERCENTAGE"
  file = ".env"

  skill_var = "max_order_items"
  code_var = "app-config.maxOrderItems"
  file = "config/production.yaml"

[external_services]
  name = "Square POS API"
  purpose = "Payment processing"
  api_version = "2026-01-01"
  config_path = "data_sources.order_api"
  skill_impact = "API version bumps may change request/response shapes"
```

### 3.2 Why This Level of Granularity?

| Without it | With it |
|------------|---------|
| "Update the menu capability" — vague, risky | "Update `thresholds.tax_rate` in config.yaml and the tax calculation in orderService.ts" — precise |
| AI agent guesses which config parameter changed | Every config path is linked to its skill section — no guesswork |
| Hard to verify completeness of a sync | Every section has a `config_path` — null means "no parameter change needed" |
| Mapping drifts from actual code over time | Each file+function reference is testable — CI can verify they still exist |

### 3.3 Mapping Maintenance

- Update `codebase_version` on every deployment that changes mapped files.
- When adding a new feature, add it to the skill first, then add a new `[[capabilities]]` section to mapping.toml.
- When deleting code, verify no mapping points to removed files. Remove stale entries.
- When a config parameter changes name or location, update ALL references across all sections that use it.
- `config_path` entries use YAML dot-notation (e.g. `thresholds.max_items`), not programming-language-style (e.g. `THRESHOLDS.MAX_ITEMS`).

---

## Phase 4 — Skill-Sync Process

### 4.1 Sync Triggers

| Trigger | Direction | Process |
|---------|-----------|---------|
| Business logic change | Skill → Code (forward) | Update skill capability → edit config.yaml → apply file mapping → run tests |
| Bug fix discovered in code | Code → Skill (reverse) | Fix code → update skill to reflect corrected behavior → bump version |
| New feature | Skill → Code (forward) | Add capability to skill first → add config keys → implement code |
| Parameter tuning only | Skill → Code (forward) | Edit config.yaml only — no skill markdown changes needed |
| Dependency update | Neither | Update mapping.toml dependency versions only |
| Research mode sync | Lockfile | Verify hashes, check fixed vs open layer change, cascade if needed |

### 4.2 Config-Driven Sync Procedure (Forward)

When business logic changes upstream (skill):

1. **Update the skill capability** — modify Logic, Error states, or Config parameters in SKILL.md
2. **Edit config.yaml** — update the specific config path(s) that changed. This is the primary action.
3. **Apply file mapping** — for each changed `impl_file` in the mapping, navigate to that file+function and apply the downstream equivalent change
4. **Bump version** — update `skill_version` in both `config.yaml` and `mapping.toml`
5. **Run tests** — verify all mapped test files pass
6. **Commit** — using the convention below

### 4.3 Reverse Sync (Code → Skill)

When a fix is discovered in code that changes behavior:

1. **Fix the code** as normal
2. **Update config.yaml** if parameter values changed
3. **Update the skill** to reflect the corrected behavior in Logic / Error states
4. **Bump version** — update `skill_version` in `config.yaml` and `mapping.toml`
5. **Document the divergence** — add a note:
   ```
   reverse-sync note: {date} — {description of code fix}
   Skill updated to match corrected behavior.
   ```
6. **Commit** — using the convention below

### 4.4 AI Agent Sync Rules

When an AI agent performs the sync, it MUST follow these hard constraints:

| Rule | Detail |
|------|--------|
| **Never change the capability interface** | Inputs, outputs, and capability names are stable. Only the implementation inside each capability changes. |
| **Never add source code to the skill** | The generated skill is MD, YAML, TOML, JSON only. CLI helper scripts (bash/PowerShell) may live in `resources/`. No `.ts`, `.js`, `.py`, `.rs`, `.kt`, `.java`, or any compiled language files. |
| **Update config.yaml first** | Config is the primary sync target. Changes to logic descriptions in SKILL.md are secondary. |
| **Bump version** | Update `skill_version` in both `config.yaml` and `mapping.toml` to the new upstream version. |
| **Never hardcode a value in the skill markdown** | If the change requires a new constant, add it to `config.yaml` and reference it from the skill by config path. |
| **Update mapping.toml** | If a new section was added to the skill, add a new `[[capabilities.sections]]` entry. If a mapped file no longer exists, remove the entry. |
| **Check research mode** (if active) | Compare lockfile hashes before build. Fixed-layer mismatch = full rebuild. Open-layer-only = lightweight re-theme. |

### 4.5 Commit Convention

Use this commit message pattern:

```
skill-sync({project-name}): v{old} → v{new} — {brief description}

Config changes:
- {config key}: {old value} → {new value}
- ...

Mapped files updated:
- {file}: {function} — {what changed}

Reverse sync: {yes/no}
```

Examples:
```
skill-sync(cafe-ordering): v1.0.0 → v1.1.0 — increased max_order_items to 100

Config changes:
- thresholds.max_order_items: 50 → 100

Mapped files updated:
- src/services/orderService.ts: validateOrder — updated max items check
- src/routes/orders.ts: createOrder — updated error message
```

### 4.6 Sync Verification Checklist

After every sync:

- [ ] `skill_version` matches between `config.yaml` and `mapping.toml`
- [ ] Skill capability inputs/outputs still match webapp inputs/outputs
- [ ] Every changed config key has a corresponding update in the mapped `impl_files`
- [ ] No stale mappings (all mapped files and functions still exist)
- [ ] All test files in mapping still pass
- [ ] No hardcoded values embedded in skill markdown — everything configurable is in `config.yaml`
- [ ] `mapping.toml` updated if new sections were added or removed
- [ ] `codebase_version` and/or `skill_version` bumped
- [ ] Commit message follows convention
- [ ] No source code files (.ts, .js, .py, .rs, .kt, .java) in the skillified project directory

### 4.7 Detecting Drift

If code and skill diverge (e.g., hotfix in production, AI-generated change that bypassed the skill):

1. **Check version mismatch** — if `skill_version` in `config.yaml` differs from `mapping.toml`, drift has occurred
2. **Run capability tests** — execute each capability's inputs and compare outputs against actual webapp behavior
3. **If mismatch found**, decide: is the code correct (reverse-sync) or is the skill correct (forward-sync)?
4. **Execute the appropriate sync direction**
5. **Update version** in both `config.yaml` and `mapping.toml`

---

## Workflow

### Initial skillification

```
1. Analyze codebase → build functional inventory (Phase 1)
2. Extract all configurable parameters → config.yaml (Phase 1.3)
3. Generate SKILL.md with matching inputs/outputs (Phase 2)
4. Create mapping.toml with granular section-level map (Phase 3)
5. Verify: run every capability through the skill → output matches webapp output
6. Set skill_version = "1.0.0" in both config.yaml and mapping.toml
7. Create SKILL_SYNC.md in the downstream repo root (see below)
```

### Ongoing maintenance

```
1. Business change requested
2. Update skill capability (upstream)
3. Update config.yaml with new parameter values
4. Apply file mapping to propagate to code (downstream)
5. Verify tests pass
6. Bump version, commit
```

---

## Downstream Skill-Sync File

### Purpose

The `SKILL_SYNC.md` file lives at the root of the downstream repo (the codebase
that was skillified). It tells future AI agents how to sync the downstream code
with the upstream skill spec when changes occur.

The downstream code is the "compiled" output from the upstream skill. When the
upstream skill spec changes, an agent reads `SKILL_SYNC.md` and follows its
instructions to propagate those changes to the codebase.

### Creation (Final Step of Initial Skillification)

After the skillified project is generated at
`.opencode/skill/skillified-{project-name}/`, create `SKILL_SYNC.md` at the root
of the downstream repo with the following content:

```markdown
# Skill Sync — {Project Name}

This repo has been skillified. The upstream skill spec is at:
`.opencode/skill/skillified-{project-name}/`

## When to run this sync

Run these instructions when business logic, config parameters, or data models
change in the upstream skill spec and need to propagate to this codebase.

## How an agent performs the sync

1. Load the `skillify-codebase` skill
2. Navigate to `.opencode/skill/skillified-{project-name}/`
3. Open `mapping.toml` to identify changed sections
4. Follow the Phase 4 sync procedure in the skill:
   - **Forward sync** (skill → code): update `config.yaml`, apply file mapping
   - **Reverse sync** (code → skill): update code, then update the skill
   - **Parameter-only**: edit `config.yaml` and propagate mapped files
5. Bump `skill_version` in both `config.yaml` and `mapping.toml`
6. Run all mapped test files to verify
7. Commit with the `skill-sync()` convention

## Drift detection

If the codebase has drifted from the skill spec:
1. Check `skill_version` match between `config.yaml` and `mapping.toml`
2. Run each capability's test cases against actual codebase behavior
3. Decide direction: forward sync (skill is correct) or reverse sync (code is correct)

## Key constraints

| Rule | Detail |
|------|--------|
| Never change capability interface | Inputs, outputs, and capability names are stable |
| Config first | `config.yaml` is the primary sync target, not source code |
| No source code in the skill | The skillified project is MD, YAML, TOML, JSON only |
| Bump version on every sync | Update `skill_version` in both `config.yaml` and `mapping.toml` |
| Update mapping on structural changes | Every skill section change needs a corresponding `mapping.toml` update |

## Dependencies

- **Skill:** `skillify-codebase` — must be registered in agent skill directory
- **Config:** `.opencode/skill/skillified-{project-name}/config.yaml`
- **Mapping:** `.opencode/skill/skillified-{project-name}/mapping.toml`

{version_info}
```

Replace the placeholders (`{Project Name}`, `{project-name}`, `{version_info}`)
with actual values. Set `{version_info}` to:

```
**Last sync:** [YYYY-MM-DD]
**Skill version:** 1.0.0
```

---

## Output Structure

```
.opencode/skill/skillified-{project-name}/
├── SKILL.md              # Generated skill — executable specification
├── config.yaml            # ALL configurable parameters (PRIMARY SYNC TARGET)
├── mapping.toml           # Granular section-by-section mapping table
├── skill.lock             # Lockfile — research mode only. Pins upstream versions + hashes.
├── sync-workflow.md       # This file (sync process documentation)
└── resources/
    ├── data-models.md     # Full schema definitions for all data models
    ├── api-contract.md    # Complete input/output contracts
    └── test-cases.md      # Example invocations with expected outputs
```

**Content constraint:** No source code files. The skillified project is exclusively MD, YAML, TOML, JSON. Lightweight CLI helper scripts (bash/PowerShell) are the only exception and must live in `resources/`.

---

## When to Use

| Scenario | Use skillify |
|----------|-------------|
| You have an existing webapp with stable business logic | Yes — extract and map |
| You're building a new feature and want spec-first development | Yes — write skill capability first, code second |
| You need to onboard an AI agent to maintain or extend a codebase | Yes — the skill IS the onboarding document, config.yaml is the sync target |
| You want deterministic parameter changes without touching logic | Yes — config-driven pattern makes this exact |
| The codebase is a prototype/POC with rapidly changing logic | No — wait until logic stabilizes |
| The codebase is infrastructure-only (no domain logic) | No — skillify is for business logic, not config |
| The codebase is a third-party dependency you don't control | No — you can't maintain bidirectional sync |