# Architectural Boundaries

> **Standard mode.** Use during Phase 1 of skillification to map the codebase into four canonical boundaries and identify handoff points.

## The Four Boundaries

Every codebase can be mapped into exactly four boundaries. Do not invent a fifth.

| Boundary | Role | Primary Concern |
|----------|------|-----------------|
| **Human Input** | Originates from humans or external real-world sources | Content, data, configuration that humans create or curate |
| **AI / Skills** | Decides *what* to generate or *how* to transform inputs | Decision-making, orchestration, content generation |
| **Code** | Deterministically transforms data or renders output | Business logic, rendering, validation, API routes |
| **Config** | Controls environment, build, or runtime behavior | Environment variables, build settings, deployment config |

---

## Boundary A: Human Input

Everything that originates from a human or an external real-world source and is consumed by the system as data.

### Look for

- `content/`, `data/`, `static/`, `assets/` directories containing JSON, YAML, Markdown, images
- CMS content, site profiles, catalogues, dimension specs, configuration JSON
- Test fixtures, reference configs, seed data
- External data sources (APIs, scrapers, importers) that feed into the system

### Record for each item

- File path and format
- Schema/contract (if any)
- Whether it is human-editable or machine-fetched

---

## Boundary B: AI / Skills

Everything that decides *what* to generate or *how* to transform inputs.

### Look for

- `skills/`, `.kilo/`, `mcp.json`, `AGENTS.md`
- Pipeline orchestrators, LLM call sites, prompt files
- Agent instructions, workflow definitions
- Any code whose primary role is decision-making rather than data transformation

### Record for each item

- What decision it makes
- What inputs it reads
- What outputs it produces

---

## Boundary C: Code

Everything that deterministically transforms data or renders output.

### Look for

- `src/`, `lib/`, `app/`, `components/`, `api/`
- Generators, sequencers, renderers, compilers
- Schemas, type definitions, validation logic
- Business logic, API routes, rendering pipelines

### Record for each item

- Module responsibility
- Inputs consumed
- Outputs produced
- Dependencies on other modules

---

## Boundary D: Config

Everything that controls the environment, build, or runtime behavior without being business data.

### Look for

- `next.config.*`, `tsconfig.*`, `package.json`, `.env*`, `*.config.*`
- Build scripts, deployment config, CI/CD
- Theme bundles, dimension specs (if they are environment/build-level rather than content)
- Env var enforcement, MCP servers, supply-chain config

### Record for each item

- What it configures
- Which code modules consume it
- Whether it is static (checked in) or dynamic (set at runtime)

---

## Phase 1 Output

### Discovery Table

| Module / File | Boundary | Responsibility | Inputs | Outputs |
|---------------|----------|---------------|--------|---------|

### Generation Flow Diagram

```
Human Input → AI/Skills → Code → Rendered Output
```

### Handoff Points

Identify the **specific files or data structures** where one boundary passes control to another:

| From Boundary | To Boundary | Handoff Point | Artifact |
|---------------|-------------|---------------|----------|
| Human Input | AI / Skills | `content/spec.json` read by pipeline | Theme specification |
| AI / Skills | Code | `config.yaml` written by orchestrator | Configurable parameters |
| Code | Human Input | `output/` directory written by renderer | Rendered HTML/assets |
| Config | Code | `.env` loaded at startup | Environment variables |
