# Agent Rules Reference

Principles from [AgentRules](https://github.com/adrianmikula/AgentRules) evaluated as lower-priority (1-3/5) for the `optimise-agentic-coding` skill. Documented here for awareness; these are better handled as project-level conventions rather than automation.

## Coding Standards (rated 1-2)

| Principle | Rating | Context |
|-----------|--------|---------|
| DRY — Don't Repeat Yourself | ⭐⭐ | Valuable general practice, but not actionable in debugging infra setup |
| OOP / SOLID | ⭐ | Too generic; every project has its own conventions |
| KISS (500-line file limit) | ⭐⭐⭐ | Indirectly useful — smaller files improve agent context windows |

## Architecture Principles (rated 2-3)

| Principle | Rating | Context |
|-----------|--------|---------|
| Consider agent velocity in architecture | ⭐⭐⭐ | Valid but a design-time concern, not debugging infra |
| Prefer LLM-friendly languages | ⭐⭐ | Matters for new projects; skill works with whatever stack exists |
| Document architectural decisions | ⭐⭐ | Useful convention; not directly debugging-related |

## Testing Strategy (rated 1-3)

| Principle | Rating | Context |
|-----------|--------|---------|
| TDD as methodology | ⭐⭐⭐ | Already reflected in the skill's SDD workflow (Layer 4f) |
| Code coverage targets (50% POC, 80% prod) | ⭐⭐⭐ | Useful milestone, not a debugging infra concern |
| Test pyramid (unit → component → E2E) | ⭐⭐ | Architectural guidance for test organization |
| Performance / load tests | ⭐ | Infrastructure concern, not agent debugging |
| Pause if build/test is slow | ⭐⭐ | Meta-rule handled implicitly by the skill's velocity hacks |

## Task Management (rated 1-2)

| Principle | Rating | Context |
|-----------|--------|---------|
| ROADMAP.md for task discovery | ⭐ | Project management, not debugging |
| TASKS.md tracking | ⭐ | PM concern |
| Completed tasks → one-line git-summary | ⭐ | Changelog convention |
| Graph-centric task execution (Agint, etc.) | ⭐⭐ | Experimental; not production-ready |

## DevOps (rated 1-3)

| Principle | Rating | Context |
|-----------|--------|---------|
| Human-managed API keys / env vars | ⭐⭐⭐ | Relevant but outside the skill's scope (manual setup) |
| PR pipeline: compile + test + coverage + staging | ⭐⭐⭐ | CI infra setup; the skill's CI workflow (Layer 4d) covers agent-facing parts |
| Main branch: full pipeline + deploy | ⭐ | Production infra, outside scope |
| Act MCP for local CI testing | ⭐⭐⭐ | Useful tool; can be added to MCP configs if detected |

## Documentation Principles (rated 1-3)

| Principle | Rating | Context |
|-----------|--------|---------|
| Structured docs folder layout | ⭐⭐⭐ | Partially covered by the skill's Layer 4e (decisions/ standards/) |
| Named reusable doc entities | ⭐⭐⭐ | Good practice for agent-oriented docs; too deep for automation |
| Date once-off docs | ⭐ | Minor convention |
| Human-only for requirements/standards | ⭐ | Process rule |

## Research Findings (rated 2-3)

| Topic | Rating | Context |
|-------|--------|---------|
| Language choice & coding velocity | ⭐⭐⭐ | Informative background; informs the skill's stack detection priorities |
| Symbolic task graphs (full SDLC) | ⭐⭐ | Interesting but experimental (Agint, AutoGRAMS, etc.) |
| Container build optimisations | ⭐⭐ | Niche — only relevant for Docker-heavy projects |
| Browser test optimisations | ⭐⭐ | Niche — only relevant for frontend-heavy projects |

## When to Re-evaluate

Revisit these items for the skill if:
- A new experimental approach becomes production-ready (e.g., Agint-like graph compilers)
- The project scope expands to cover Docker/frontend-specific optimisations as a Layer
- Deeper documentation automation (entity-first, semantic indexing) becomes practical for agent workflows
