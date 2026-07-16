---
name: skillify-codebase
description: Examine any codebase, map its architectural boundaries (Human Input, AI/Skills, Code, Config), and produce a complete set of boundary-aligned skills — an orchestrator plus per-module skills — with explicit human/AI separation of responsibilities and a deterministic config-driven skill-sync workflow.
---

## Overview

This Skill analyzes a codebase's architecture, extracts its core logic and inputs/outputs into boundary-aligned Claude skills, and establishes a deterministic, config-driven skill-sync workflow that keeps the skill (upstream spec) and code (downstream implementation) in lockstep.

**Standard mode (default):** Produces an orchestrator skill + one skill per major module, with explicit input/output contracts and human/AI ownership per architectural boundary.

**Research mode (optional):** Extends the model with affordance schemas, lockfile-pinned builds, skill dependency trees, and conflict resolution. See `resources/research-mode.md` to activate.

---

## Core Concepts

### Four Architectural Boundaries

```
┌──────────────────────────────────────────────────────────────────────┐
│                      ARCHITECTURAL BOUNDARIES                        │
├─────────────────┬─────────────────┬─────────────────┬────────────────┤
│  Human Input    │   AI / Skills   │      Code       │     Config     │
│                 │                 │                 │                │
│  Content, data, │  Decision-making│  Deterministic  │  Environment,  │
│  fixtures, CMS, │  orchestration, │  transformation, │  build, runtime│
│  external APIs  │  generation     │  rendering       │  behavior      │
└─────────────────┴─────────────────┴─────────────────┴────────────────┘
```

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

## Workflow

The skillify process has 7 phases. Detailed templates and tables are in the `resources/` directory.

```
1. Discover Architecture → boundary table + handoff points
2. Identify Major Modules → module definitions per boundary
3. Design Skill Hierarchy → orchestrator + per-module skills
4. Define Human/AI Separation → per-boundary ownership contracts
5. Write Skills → SKILL.md for each skill
6. Update Documentation → README + SKILL_SYNC.md
7. Verify Consistency → run structural checks
```

---

## Phase 1 — Discover Architecture

Map the codebase into four canonical boundaries. Do not invent a fifth.

For detailed discovery tables, generation flow diagrams, and handoff-point identification, see `resources/architectural-boundaries.md`.

### A. Human Input

Everything that originates from a human or an external real-world source and is consumed by the system as data. Look for:
- `content/`, `data/`, `static/`, `assets/` directories containing JSON, YAML, Markdown, images
- CMS content, site profiles, catalogues, dimension specs, configuration JSON
- Test fixtures, reference configs, seed data
- External data sources (APIs, scrapers, importers)

For each item, record: file path and format, schema/contract, whether it is human-editable or machine-fetched.

### B. AI / Skills

Everything that decides *what* to generate or *how* to transform inputs. Look for:
- `skills/`, `.kilo/`, `mcp.json`, `AGENTS.md`
- Pipeline orchestrators, LLM call sites, prompt files
- Agent instructions, workflow definitions
- Any code whose primary role is decision-making rather than data transformation

For each item, record: what decision it makes, what inputs it reads, what outputs it produces.

### C. Code

Everything that deterministically transforms data or renders output. Look for:
- `src/`, `lib/`, `app/`, `components/`, `api/`
- Generators, sequencers, renderers, compilers
- Schemas, type definitions, validation logic
- Business logic, API routes, rendering pipelines

For each item, record: module responsibility, inputs consumed, outputs produced, dependencies on other modules.

### D. Config

Everything that controls the environment, build, or runtime behavior without being business data. Look for:
- `next.config.*`, `tsconfig.*`, `package.json`, `.env*`, `*.config.*`
- Build scripts, deployment config, CI/CD
- Theme bundles, dimension specs (if they are environment/build-level rather than content)
- Env var enforcement, MCP servers, supply-chain config

For each item, record: what it configures, which code modules consume it, whether it is static or dynamic.

### Phase 1 Output

Produce:
1. A table: `| Module / File | Boundary | Responsibility | Inputs | Outputs |`
2. A **generation flow diagram**: `Human Input → AI/Skills → Code → Rendered Output`
3. **Handoff points** — the specific files or data structures where one boundary passes control to another

---

## Phase 2 — Identify Major Modules

Within the Code boundary, identify the major functional modules. A "major module" is a cohesive unit that:
- Has a single, clear responsibility
- Produces or consumes a distinct config artifact
- Could be explained in one paragraph

For each major module, define: name, boundary, input artifact, output artifact, core files (2-5), responsibility.

Group modules by boundary. The goal is to end up with 3-8 major modules per boundary.

---

## Phase 3 — Design Skill Hierarchy

### Orchestrator Skill

Create one top-level skill named `<project>-generator` at `skills/<orchestrator-name>/SKILL.md` that:
- Describes the full pipeline from user brief to rendered output
- References every sub-skill by path
- Contains the iteration loop: interpret → execute pipeline → preview → verify → iterate
- Is the entry point when a user asks for generation

### Per-Module Skills

For each major module, create a skill at `skills/<module-name>/SKILL.md`. Use the template in `resources/multi-skill-generation.md`.

### Naming Convention

| Module type | Naming rule | Example |
|-------------|-------------|---------|
| Orchestrator | `<project>-generator` | `website-generator` |
| Code module | kebab-case matching module name | `sequencer`, `tuner-system` |
| AI module | kebab-case matching module name | `layout-selector`, `content-generator` |
| Human-input module | kebab-case matching data role | `business-profile` |
| Legacy/old module | `legacy-` prefix | `legacy-theme-dimensions` |
| External wrapper | tool name | `ticonderoga` |

---

## Phase 4 — Define Human/AI Separation

For each boundary, explicitly state ownership and handoff rules. Use the contracts in `resources/human-ai-separation.md`.

### Human Input Boundary
- **Human owns:** creation, curation, editing of input files
- **AI may:** read, analyze, fetch from external sources, suggest edits
- **AI may NOT:** silently overwrite human-authored content without confirmation
- **Handoff:** AI reads human inputs, produces config artifacts

### AI / Skills Boundary
- **AI owns:** pipeline orchestration, decision-making, content generation, archetype selection
- **Human may:** override AI decisions by editing the produced config artifacts
- **AI may NOT:** make irreversible changes to production data without human review
- **Handoff:** AI writes to `content/` or config files; human edits same files via CMS or direct edit

### Code Boundary
- **Code owns:** deterministic generation, rendering, validation, API routes
- **AI may:** edit source code when implementing features or fixing bugs (with human oversight)
- **Human may:** read, review, edit source code
- **Handoff:** Code reads config artifacts and human inputs, produces rendered output or API responses

### Config Boundary
- **Human owns:** environment variables, build settings, deployment config
- **AI may:** suggest config changes, generate dimension specs, modify `next.config.ts`
- **AI may NOT:** modify `.env.local` with real secrets; use `.env.local.example` for documentation
- **Handoff:** Config is loaded at startup/build time; code enforces required vars

---

## Phase 5 — Write Skills

For each skill, write the full `SKILL.md` following the template in `resources/multi-skill-generation.md`.

Each per-module skill must contain:
- YAML frontmatter with `name` and `description`
- Boundary and input/output artifacts prominently stated
- Artifact contract (TypeScript interface or JSON schema)
- Core files table with responsibilities
- Step-by-step workflow or usage instructions
- Related skills with relationship descriptions
- No source code (skills are documentation-only, MD/YAML/JSON)

---

## Phase 6 — Update Documentation

### README.md

Add or update the "Architectural Boundaries" section with:
- Table of four boundaries with ownership and handoff
- Generation flow diagram
- Bullet list of what humans own, AI owns, code owns, config owns

Update the "Generator skills for AI agents" section to reflect the new skill hierarchy.

### SKILL_SYNC.md

Replace with the Architecture-Aligned Skill Map, pipeline diagram, layer tables, and unskilled modules list. Use the template in `resources/multi-skill-generation.md`.

---

## Phase 7 — Verify Consistency

Run these checks (full checklist in `resources/skill-verification.md`):

1. Every major module has a skill
2. Every skill has a boundary
3. Every skill has an artifact contract
4. Orchestrator references all sub-skills
5. No circular references in related-skills sections
6. README and SKILL_SYNC.md are consistent
7. Legacy skills are prefixed

---

## Output Checklist

When skillification is complete, the following must exist:
- [ ] `skills/<orchestrator>/SKILL.md` — top-level orchestrator
- [ ] `skills/<module-1>/SKILL.md` through `skills/<module-n>/SKILL.md` — one per major module
- [ ] `skills/SKILL_SYNC.md` — architecture-aligned skill map, pipeline diagram, layer tables
- [ ] `README.md` — architectural boundaries section, updated skill tables
- [ ] All skills have YAML frontmatter, boundary, artifact contracts, core files, workflow, related skills
- [ ] Legacy skills renamed with `legacy-` prefix
- [ ] Human/AI separation documented for each boundary

---

## Skill-Sync Process

For the detailed sync procedures (triggers, forward/reverse sync, AI rules, commit convention, verification checklist, drift detection), see `resources/skill-sync-process.md`.

---

## Downstream Skill-Sync File

The `SKILL_SYNC.md` file lives at the root of the downstream repo (the codebase that was skillified). It tells future AI agents how to sync the downstream code with the upstream skill spec when changes occur.

For the full template and creation instructions, see `resources/multi-skill-generation.md`.

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
