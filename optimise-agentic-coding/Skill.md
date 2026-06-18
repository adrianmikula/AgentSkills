---
name: Optimise Agentic Coding
description: Analyze a source code repository and apply a systematic 5-layer set of improvements that optimize it for AI agent-assisted debugging. Detects tech stack, installs structured logging, configures MCP servers, sets up agent workflows, and documents env vars.
---

## Overview

You are a "debugging infrastructure" specialist. Your task is to analyze a source code repository and apply a systematic set of improvements that optimize it for AI agent-assisted debugging. The goal: when an AI coding agent (Claude Code, OpenCode, Cursor, Windsurf, Devin) works on this repo in the future, it should be able to immediately access live error state, trace logs with context, and follow established debugging workflows without manual setup.

---

## Process

### 1. Detect the tech stack

Read `package.json`, `*.csproj`, `Cargo.toml`, `pyproject.toml`, `Gemfile`, etc. Identify the framework (Next.js, Rails, Django, Express, etc.) and language.

### 2. Check for existing debugging infra

Grep for `console\.log|console\.error|\.log\(|logger\.|mcp|\.mcp\.json|opencode\.jsonc|\.windsurfrules|AGENTS\.md`. Note what exists and what is missing.

### 3. Load stack-specific resource

Based on the detected stack, load the corresponding resource file from the table below. This file contains Layers 1–3 details (framework debug mode, logger path, MCP servers) tailored to that stack.

### 4. Apply the 5-layer debugging optimization

Apply all five layers below. For Layers 1–3, follow the instructions in the stacked resource loaded in step 3. Layers 4–5 are generic and defined here.

#### Layer 4: Agent-specific configs

Create or update these agent config files:
- `.windsurfrules` — Add a "Debugging Runtime Errors" section with: prerequisite check (dev server running), MCP tool usage flow (`get_errors` -> `get_logs` -> analyze -> fix -> verify), logger usage rule
- `opencode.jsonc` — Add MCP server registration and `permission` rules
- `.devin/workflows/debug-runtime-error.md` — Step-by-step workflow for Devin
- If `.claude/settings.json` or `AGENTS.md` exists, merge in debugging instructions

#### Layer 5: Env var documentation

Add the `LOG_LEVEL` env var to the project's `.env.example` with clear documentation of accepted values and defaults.

### 5. Final verification

After all changes, confirm the repo has:
- (a) A structured logger
- (b) MCP server config for the framework
- (c) Agent workflow instructions for debugging

---

## Stack-Specific Resources

| Detected Stack | Load This Resource |
|----------------|--------------------|
| Next.js 16+ | `resources/stack-nextjs.md` |
| Next.js <16 | `resources/stack-nextjs.md` |
| Rails | `resources/stack-rails.md` |
| Django | `resources/stack-django.md` |
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

---

## Output Summary

Return a summary of every file created or modified, and what was changed.
