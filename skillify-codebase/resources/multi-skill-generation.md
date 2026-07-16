# Multi-Skill Generation

> **Standard mode.** Use during Phases 2 and 3 of skillification to design the skill hierarchy and generate the orchestrator and per-module skills.

## Phase 2 — Identify Major Modules

Within the Code boundary, identify the major functional modules. A "major module" is a cohesive unit that:
- Has a single, clear responsibility
- Produces or consumes a distinct config artifact (a typed object, JSON file, rendered output)
- Could be explained in one paragraph

For each major module, define:
- **Name** (noun phrase, e.g. "Sequencer", "Renderer", "Tuner System")
- **Boundary** (which of the four it belongs to)
- **Input artifact** (the data structure it consumes)
- **Output artifact** (the data structure it produces)
- **Core files** (2-5 key source files)
- **Responsibility** (one sentence)

Group modules by boundary. The goal is to end up with 3-8 major modules per boundary.

---

## Phase 3 — Design the Skill Hierarchy

### 3a. Orchestrator Skill

Create one top-level skill that:
- Is named `<project>-generator` or similar (e.g. `website-generator`)
- Lives at `skills/<orchestrator-name>/SKILL.md`
- Describes the full pipeline from user brief to rendered output
- References every sub-skill by path
- Contains the iteration loop: interpret → execute pipeline → preview → verify → iterate
- Is the entry point when a user asks for generation

### 3b. Per-Module Skills

For each major module, create a skill at `skills/<module-name>/SKILL.md`.

Each per-module skill must contain:

```markdown
---
name: <module-name>
description: >
  <One sentence: what this skill guides the agent to do, which boundary it belongs to,
  and what artifact it produces or consumes.>
---

# <Module Name> Skill

> **Boundary:** <Human Input | AI/Skills | Code | Config>
> **Input:** <artifact name and brief description>
> **Output:** <artifact name and brief description>

## Mission

<One paragraph: why this module exists, what problem it solves, where it sits in the pipeline.>

## <Artifact> Contract

<If the module produces or consumes a typed artifact, show the TypeScript interface or
JSON schema. If there is no formal schema, describe the shape in prose.>

## Core Files

| File | Responsibility |
|------|---------------|
| `<path>` | `<role>` |
| `<path>` | `<role>` |

## Workflow / Usage

<Step-by-step instructions for the agent:
- How to invoke this module
- What inputs to prepare
- What the expected output looks like
- Error handling or edge cases>

## Related Skills

- `skills/<orchestrator>/SKILL.md` — <relationship>
- `skills/<sibling-1>/SKILL.md` — <relationship>
- `skills/<sibling-2>/SKILL.md` — <relationship>
```

### 3c. Skill Naming Convention

| Module type | Naming rule | Example |
|-------------|-------------|---------|
| Orchestrator | `<project>-generator` | `website-generator` |
| Code module | kebab-case matching module name | `sequencer`, `tuner-system`, `gene-designer` |
| AI module | kebab-case matching module name | `layout-selector`, `content-generator` |
| Human-input module | kebab-case matching data role | `business-profile` |
| Legacy/old module | `legacy-` prefix | `legacy-theme-dimensions` |
| External wrapper | tool name | `ticonderoga` |

### 3d. SKILL_SYNC.md

Create or update `skills/SKILL_SYNC.md` with:

1. **Architecture-Aligned Skill Map** — table of all skills with path, boundary, artifact produced
2. **Pipeline diagram** — ASCII flow showing Human Input → AI/Skills → Code → Output
3. **Active Skills by layer** — four tables (Human Input, AI/Skills, Code, Config)
4. **Unskilled Modules** — table of codebase modules that still need skills
5. **How to Add a New Skill** — instructions
6. **Sync workflow** — how to keep skills aligned with code changes

---

## Output Structure

```
<skillified-project>/
├── skills/
│   ├── <orchestrator>/SKILL.md
│   ├── <module-1>/SKILL.md
│   ├── <module-2>/SKILL.md
│   ├── ...
│   └── SKILL_SYNC.md
├── config.yaml            # ALL configurable parameters (PRIMARY SYNC TARGET)
├── mapping.toml           # Granular section-by-section mapping table
└── resources/
    ├── data-models.md     # Full schema definitions for all data models
    ├── api-contract.md    # Complete input/output contracts
    └── test-cases.md      # Example invocations with expected outputs
```

**Content rules:**
- All files are MD, YAML, TOML, or JSON — never source code (.ts, .js, .py, .rs, .kt, .java, etc.)
- Lightweight CLI helper scripts (bash/PowerShell) may be added to `resources/` for common operations (e.g. config validation, lockfile verification). These are the only exception.

---

## Config File Template (`config.yaml`)

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

---

## Granular Mapping Table (`mapping.toml`)

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

### Why This Level of Granularity?

| Without it | With it |
|------------|---------|
| "Update the menu capability" — vague, risky | "Update `thresholds.tax_rate` in config.yaml and the tax calculation in orderService.ts" — precise |
| AI agent guesses which config parameter changed | Every config path is linked to its skill section — no guesswork |
| Hard to verify completeness of a sync | Every section has a `config_path` — null means "no parameter change needed" |
| Mapping drifts from actual code over time | Each file+function reference is testable — CI can verify they still exist |

### Mapping Maintenance

- Update `codebase_version` on every deployment that changes mapped files.
- When adding a new feature, add it to the skill first, then add a new `[[capabilities]]` section to mapping.toml.
- When deleting code, verify no mapping points to removed files. Remove stale entries.
- When a config parameter changes name or location, update ALL references across all sections that use it.
- `config_path` entries use YAML dot-notation (e.g. `thresholds.max_items`), not programming-language-style (e.g. `THRESHOLDS.MAX_ITEMS`).
