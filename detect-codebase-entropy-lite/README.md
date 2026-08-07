# Detect Codebase Entropy Lite

A free Claude Code skill that scans staged and unstaged git changes for code-quality issues before you commit.

## What it does

- Scans only files with current worktree changes.
- Finds duplication, dead code, test smells, and AI-generated slop.
- Does **not** report security or performance issues (Pro only).
- Returns the top 5 findings with concrete quick fixes.

## Installation

### From a built ZIP

```bash
cd detect-codebase-entropy-lite
bash build-skill.sh
```

Then import the generated `dist/detect-codebase-entropy-lite-skill.zip` into Claude Code.

### From a marketplace

Search for `detect-codebase-entropy-lite` in MyClaude, Agensi, SkillHQ, or Anthropic Skills.

## Usage

In Claude Code, run:

```
/detect-codebase-entropy-lite
```

The skill inspects your staged and unstaged changes and produces a pre-commit entropy report.

## What it does not cover

Security and performance findings are intentionally excluded from the lite version. Upgrade to the Pro skill for those.

## Upgrade

Unlock `detect-codebase-entropy` Pro for:

- Security and performance entropy findings
- Full-repo analysis beyond the current worktree
- Git history drift and trend analysis
- An adaptive Claude skill generated for your repo
