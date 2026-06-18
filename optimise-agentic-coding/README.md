# Optimise Agentic Coding

A Claude Code skill that analyzes any source code repository and applies a systematic 5-layer set of improvements to optimize it for AI agent-assisted debugging.

## What It Does

When invoked, this skill will:

1. **Detect your tech stack** — frameworks, languages, dependencies
2. **Check existing debugging infra** — logs, MCP configs, agent rules
3. **Apply 5 layers of optimization:**
   - **Layer 1:** Framework-level debug mode (Next.js, Rails, Django, etc.)
   - **Layer 2:** Structured logger utility (zero-dependency, context-based)
   - **Layer 3:** MCP server configuration (`.mcp.json`)
   - **Layer 4:** Agent-specific configs (Windsurf, OpenCode, Devin, Claude)
   - **Layer 5:** Env var documentation (`LOG_LEVEL`)

## Installation

This skill is published in the [AgentSkills marketplace](https://github.com/anomalyco/AgentSkills-main).

To install:

```bash
claude plugins install https://github.com/anomalyco/AgentSkills-main
```

Or build locally:

```bash
cd optimise-agentic-coding
bash build-skill.sh
```

Then install the generated `.zip` from `dist/`.
