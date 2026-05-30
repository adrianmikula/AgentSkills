# AgentSkills

A collection of Claude plugins and skills for AI-assisted security, outreach, and cognitive sustainability workflows.

## Available Skills

| Plugin | Description |
|--------|-------------|
| **AI-Era Vulnerability Scanner** | Scan repositories and public-facing websites for AI-era security vulnerabilities. |
| **Business Outreach Generator** | Generate targeted security outreach emails, LinkedIn messages, or phone scripts for small businesses and engineering teams. |
| **Cognitive Sustainability** | Preserve human decision authority and conceptual understanding during AI-assisted development. |
| **dev-level-up** | Scan high-authority tech news for cutting-edge AI coding tools and techniques targeting Java, React, and Python. Filters to the last month and scores findings for speed, accuracy, capacity, tools, and agility. |

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
