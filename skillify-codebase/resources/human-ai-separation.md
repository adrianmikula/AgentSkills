# Human / AI Separation

> **Standard mode.** Use during Phase 4 of skillification to define explicit ownership and handoff contracts for each architectural boundary.

## Boundary Ownership Contracts

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

## AI Agent Constraints

When an AI agent operates across these boundaries, it MUST follow these rules:

| Rule | Detail |
|------|--------|
| **Never silently overwrite human content** | Always confirm before modifying human-authored files in the Human Input boundary |
| **Never make irreversible production changes** | All production data changes require human review in the AI/Skills boundary |
| **Never hardcode values in skill markdown** | All configurable values belong in `config.yaml` |
| **Never add source code to skills** | Skills are MD, YAML, TOML, JSON only |
| **Respect config ownership** | Do not modify `.env.local` with real secrets; document in `.env.local.example` |

---

## Skill Boundary Declaration

Each generated skill must declare its boundary in the frontmatter and body:

```yaml
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
```
