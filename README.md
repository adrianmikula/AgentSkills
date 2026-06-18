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

### Windsurf (Cascade)

Windsurf supports the same `SKILL.md` format natively. Skills are auto-invoked when your prompt matches the skill description, or triggered manually with `@skill-name`.

> **Note on filename casing:** Windsurf expects `SKILL.md` (all-caps). The files in this repo are named `Skill.md`. Rename the file after copying, or use the one-liner below which handles it automatically.

#### Option A — Workspace skill (project-specific, committed with your repo)

```bash
# From your project root — example for city-risk-landscape
SKILL=city-risk-landscape
mkdir -p .windsurf/skills/$SKILL
cp -r /path/to/AgentSkills/$SKILL/* .windsurf/skills/$SKILL/
mv .windsurf/skills/$SKILL/Skill.md .windsurf/skills/$SKILL/SKILL.md
```

Repeat for each skill you want. The `.windsurf/skills/` folder is committed with your repo, so your whole team gets the skill automatically.

#### Option B — Global skill (available in every workspace on your machine)

```bash
SKILL=city-risk-landscape
mkdir -p ~/.codeium/windsurf/skills/$SKILL
cp -r /path/to/AgentSkills/$SKILL/* ~/.codeium/windsurf/skills/$SKILL/
mv ~/.codeium/windsurf/skills/$SKILL/Skill.md ~/.codeium/windsurf/skills/$SKILL/SKILL.md
```

#### Invoking skills in Cascade

| Method | How |
|--------|-----|
| **Auto-invocation** | Describe what you want — Cascade reads the skill description and loads it automatically |
| **Manual** | Type `@city-risk-landscape` (or the skill name) in the Cascade input box |

> **Cross-agent path:** Windsurf also discovers skills placed in `.agents/skills/` — useful if you want a single copy shared by multiple agents without committing to `.windsurf/`.

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
