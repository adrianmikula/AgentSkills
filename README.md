# AgentSkills

A collection of Claude plugins and skills for AI-assisted security, outreach, and cognitive sustainability workflows.

## Available Skills

| Plugin | Description |
|--------|-------------|
| **AI-Era Vulnerability Scanner** | Scan repositories and public-facing websites for AI-era security vulnerabilities. |
| **Business Outreach Generator** | Generate targeted security outreach emails, LinkedIn messages, or phone scripts for small businesses and engineering teams. |
| **Cognitive Sustainability** | Preserve human decision authority and conceptual understanding during AI-assisted development. |
| **dev-level-up** | Scan high-authority tech news for cutting-edge AI coding tools and techniques targeting Java, React, and Python. Filters to the last month and scores findings for speed, accuracy, capacity, tools, and agility. |
| **City Risk Landscape** | Generate interactive AI-era cyber risk charts for a target city. Landscape mode scores SMB industry subcategories by attack likelihood and data sensitivity (bubble chart). Timeline mode plots WordPress/WooCommerce exploit trends over 24 months with stacked bars by incident type (ransomware, data leak, outage, money theft) and switchable Y-axes for exploit volume, time-to-exploit vs time-to-patch, and cost-to-exploit. |
| **Optimise Agentic Coding** | Analyze a code repository and apply 5-layer debugging infrastructure: structured logger, MCP server config, agent-specific workflow instructions, framework debug mode, and env var documentation. Supports Next.js, Rails, Django, Express, Java/Kotlin, Rust, and .NET stacks via per-stack resource files. |
| **Build WordPress Plugin** | Generate a complete WordPress plugin codebase from a plain-English description. Produces free (.org-clean) and premium ZIPs from one monorepo with zero telemetry violations. |
| **Business Idea Incubator** | Validate, refine, and implement business ideas through multidisciplinary coaching across 11 disciplines. Tracks progress and surfaces blind spots. |

## Installation

### Claude Code (Terminal)

Add this marketplace and install any skill:

```bash
/plugin marketplace add adrianmikula/AgentSkills
/plugin install ai-era-vulnerability-scanner@adrianmikula-agentskills
```

Replace `ai-era-vulnerability-scanner` with the plugin name you want.

### Claude.ai (Browser / Desktop)

1. Download the latest skill ZIP from the [Releases](../../releases) page.
2. Go to **Settings > Capabilities > Skills > Upload**.
3. Select the ZIP file. Claude will read the `SKILL.md` and display the skill name and description.

### Multi-Agent Setup (Kilo Code, Opencode, Devin)

All three agents use the same `.agents/skills/` standard for skill discovery. Skills are symlinked into `.agents/skills/<name>/SKILL.md` automatically when you run the build script (see [Building Skills](#building-skills)).

| Agent | Discovery paths |
|-------|----------------|
| **Kilo Code** | `.kilocode/skills/`, `.agents/skills/` |
| **Opencode** | `.opencode/skill/`, `.claude/skills/`, `.kilocode/skills/` |
| **Devin** | `.devin/skills/`, `.agents/skills/` |

The build script creates symlinks under `.agents/skills/<name>/` (shared by Kilo Code and Devin) and `.opencode/skill/<name>/` (for Opencode). All symlinks point back to the canonical source files, so edits to `Skill.md` or `resources/` are immediately reflected.

After building, invoke any skill by name in your agent:

```bash
# Kilo Code — triggered by matching description or /skill-name
# Opencode — triggered by matching description or in-skill prompt
# Devin CLI — /skill-name or automatic when relevant
```

#### Manual symlink setup (no build required)

```bash
# From the repo root
SKILL=city-risk-landscape
mkdir -p .agents/skills/$SKILL
ln -sf ../../$SKILL/Skill.md .agents/skills/$SKILL/SKILL.md
ln -sf ../../$SKILL/resources .agents/skills/$SKILL/resources
mkdir -p .opencode/skill/$SKILL
ln -sf ../../../.agents/skills/$SKILL/SKILL.md .opencode/skill/$SKILL/SKILL.md
ln -sf ../../../.agents/skills/$SKILL/resources .opencode/skill/$SKILL/resources
```

Repeat for each skill. Run `./build-all.sh` to set up all skills at once.

### Windsurf (Cascade)

Windsurf supports the same `SKILL.md` format natively via `.agents/skills/` (already set up by the build script).

> **Note on filename casing:** Windsurf expects `SKILL.md` (all-caps). The symlinks in `.agents/skills/<name>/` use the correct casing.

## Building Skills

Each skill directory contains a `build-skill.sh` script that packages it into a ZIP for manual import:

```bash
cd ai-era-vulnerability-scanner/
./build-skill.sh
```

To build all skills at once:

```bash
./build-all.sh
```

This validates plugin manifests and produces ZIP files in each skill directory.

## Auto-Updating the Scanner

The vulnerability scanner's detection categories must evolve as frontier AI capabilities and cryptographic threats change. The file `ai-era-vulnerability-scanner/resources/external-intelligence-sources.md` tracks external threat intelligence sources and describes how to auto-generate scanner updates when those sources signal a change.

**How it works:**
1. Run an AI coding agent (Claude Code, Windsurf) with access to this repo
2. Ask it to read `resources/external-intelligence-sources.md` and check each source for changes
3. For each source where new developments are detected (new benchmarks, CVEs, standards, publications), the file contains explicit instructions for what scanner files to update and how
4. The agent auto-generates the corresponding updates — new detection sub-classes, updated cost estimates, revised migration checklists
5. You review and commit the changes

**Quick start:**
```bash
# From the repo root — load the intel sources and ask your AI agent to check for updates
# The agent will run source-specific curl commands, compare against baselines,
# and apply any auto-updates identified in the instructions.
```

**When to run this:** Before each scanner release, or when a major AI capability benchmark or cryptographic standard is published. See the `Version History` table at the bottom of `external-intelligence-sources.md` to track what was last checked.
