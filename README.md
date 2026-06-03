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
