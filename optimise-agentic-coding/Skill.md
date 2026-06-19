---
name: Optimise Agentic Coding
description: Analyze a source code repository and apply a systematic 5-layer set of improvements that optimize it for AI agent-assisted debugging and coding velocity. Detects tech stack, sets up fast lint + fast tests + velocity hacks, installs structured logging, configures MCP servers, creates command catalogue + common issues doc, sets up agent workflows, and documents env vars.
---

## Overview

You are a "debugging infrastructure" and "agentic velocity" specialist. Your task is to analyze a source code repository and apply a systematic set of improvements that optimize it for AI agent-assisted debugging **and high-speed agentic coding loops**. The goal: when an AI coding agent (Claude Code, OpenCode, Cursor, Windsurf, Devin) works on this repo in the future, it should be able to immediately access live error state, trace logs with context, follow established debugging workflows, and have sub-second edit--validate feedback cycles — all without manual setup.

---

## Process

### 1. Detect the tech stack

Read `package.json`, `*.csproj`, `Cargo.toml`, `pyproject.toml`, `Gemfile`, etc. Identify the framework (Next.js, Rails, Django, Express, etc.) and language.

### 2. Check for existing debugging infra

Grep for `console\.log|console\.error|\.log\(|logger\.|mcp|\.mcp\.json|opencode\.jsonc|\.windsurfrules|AGENTS\.md`. Note what exists and what is missing.

### 3. Load stack-specific resource

Based on the detected stack, load the corresponding resource file from the table below. This file contains Layers 1–3 details (framework debug mode, fast linting, fast test configuration, velocity hacks, logger path, MCP servers) tailored to that stack.

### 3.5 Load cross-stack optimisation resources

After loading the stack-specific resource, also load these cross-stack resources for additional Layer 4 content:
- `resources/agentic-ci-cd-optimisations.md` — CI/CD debugging workflow patterns
- `resources/commands-template.md` — Template for creating the command catalogue in Layer 4

### 4. Apply the 5-layer debugging optimization

Apply all five layers below. For Layers 1–3, follow the instructions in the stacked resource loaded in step 3. Layers 4–5 are generic and defined here.

#### Layer 4: Agent-specific configs

Create or update these agent config files:

**4a. Debugging workflows**
- `.windsurfrules` — Add a "Debugging Runtime Errors" section with: prerequisite check (dev server running), MCP tool usage flow (`get_errors` -> `get_logs` -> analyze -> fix -> verify), logger usage rule
- `opencode.jsonc` — Add MCP server registration and `permission` rules
- `.devin/workflows/debug-runtime-error.md` — Step-by-step workflow for Devin
- If `.claude/settings.json` or `AGENTS.md` exists, merge in debugging instructions
- **Additional MCP servers** — Beyond the stack-specific MCPs in Layer 3, recommend these cross-stack MCPs in `.mcp.json`:
  - Codebase indexing: `npx -y @anthropic/mcp-server-codebase-indexer`
  - GitHub: `npx -y @anthropic/mcp-server-github` (for issue/PR context during debugging)
  - Persistent memory: `npx -y @anthropic/mcp-server-memory` (maintains context across agent sessions)
  - Database: appropriate DB MCP for the detected database

**4b. Command catalogue** — Create `COMMANDS.md` listing all relevant build/test/lint/run/debug CLI commands with example usage. Agents waste significant time guessing CLI syntax — this eliminates that. Use `resources/commands-template.md` as a starting point. Structure:
```markdown
# Commands

## Fast iteration
| Command | Description | Expected time |
|---------|-------------|---------------|
| `npm run lint` | Lint check | < 2s |
| `npm run test:fast` | Fast unit tests | < 5s |

## Full validation (CI only)
| Command | Description | Expected time |
|---------|-------------|---------------|
| `npm run test` | Full test suite | ~2min |
```

**4c. Known issues** — Create `docs/COMMON_ISSUES.md` cataloguing frequent error patterns and their resolutions. This prevents agents from re-investigating known problems. Structure:
```markdown
# Common Issues

## [ERR-001] Database connection timeout
- **Symptom:** `SequelizeConnectionError` on startup
- **Cause:** Docker Postgres container not running
- **Fix:** `docker compose up -d db`
- **Diagnosis command:** `docker compose ps`

## [ERR-002] TypeScript build failure — cannot find module
- **Symptom:** `Cannot find module 'x' or its corresponding type declarations`
- **Cause:** Missing `@types/x` package
- **Fix:** `npm install -D @types/x`
```

**4d. CI debugging workflow** — Add to `.windsurfrules` or `AGENTS.md`:
- Validate CI pipeline config locally before pushing (dry-run)
- Run change-aware signal stages (lint → typecheck → fast tests)
- Only escalate to full CI suite when signal passes
- Split between "signal" (seconds) and "confidence" (minutes) stages

**4e. Structured docs directory** — Create `docs/decisions/` directory for recording architectural and debugging workflow rationale. Create `docs/standards/` for conventions that should remain stable.

**4f. Spec-driven development workflow** — Add to agent configs: when starting a new feature, first write a spec file (`docs/specs/<feature>.md`) describing the expected behavior, then implement code matching the spec, then verify alignment.

#### Layer 5: Env var documentation

Add the `LOG_LEVEL` env var to the project's `.env.example` with clear documentation of accepted values and defaults.

### 5. Final verification

After all changes, confirm the repo has:
- (a) A structured logger
- (b) MCP server config for the framework
- (c) Agent workflow instructions for debugging
- (d) Fast lint setup configured
- (e) Fast test subset configured
- (f) `COMMANDS.md` command catalogue
- (g) `docs/COMMON_ISSUES.md` known issues doc

---

## Stack-Specific Resources

| Detected Stack | Load This Resource |
|----------------|--------------------|
| Next.js 16+ | `resources/stack-nextjs.md` |
| Next.js <16 | `resources/stack-nextjs.md` |
| Rails | `resources/stack-rails.md` |
| Django | `resources/stack-django.md` |
| Python (FastAPI, Flask, generic) | `resources/stack-python.md` |
| Express / Generic Node.js | `resources/stack-node.md` |
| Java / Kotlin (Maven/Gradle) | `resources/stack-java.md` |
| Rust / Cargo | `resources/stack-rust.md` |
| .NET / C# | `resources/stack-dotnet.md` |
| Other (not listed) | Use generic guidance — create `lib/logger.js`, enable debug mode per framework docs, add relevant MCP servers |

---

## Logger Contract (Layer 2 — Generic)

All stack-specific resources follow the same logger contract:
- Context-based: `logger('module-name').warn('message', data)`
- Level-aware: respects `LOG_LEVEL` env var, defaults to `debug` in dev, `warn` in production
- Error-aware: when an `Error` object is passed, includes the full stack trace automatically
- Serializes non-string data as JSON
- Levels: `debug`, `info`, `warn`, `error`
- No runtime dependencies (use built-in console underneath)
- No comments in source code
- < 60 lines, stateless, zero-dependency
- Then migrate ALL existing `console.*` calls to use the logger with meaningful context names

---

## Principles

- Never add runtime dependencies (use built-in console underneath).
- Never add comments to source code.
- Keep the logger file small (< 60 lines), stateless, zero-dependency.
- Agent configs should instruct the *agent* on workflow, not the human.
- Prefer modifying existing files over creating new ones.
- Fast feedback is paramount: optimize for sub-second lint/test cycles, not full-suite correctness.
- Separate signal from confidence: fast checks in the inner loop, slow checks deferred to CI.
- A command catalogue prevents wasted agent cycles on CLI guesswork.
- A known-issues doc prevents re-investigation of recurring errors.

---

## Output Summary

Return a summary of every file created or modified, and what was changed.
