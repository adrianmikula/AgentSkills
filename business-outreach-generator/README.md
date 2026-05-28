# Business Outreach Generator

A Claude Skill for generating targeted security outreach messages to small businesses. Supports multiple outreach offerings and two output channels: **Email** and **LinkedIn**.

## How It Works

1. **Collect targeting parameters** — The Skill asks for output format, target country, city/region, industry sector, and business size.
2. **Select offering and channel** — Conditional logic loads the correct resource template (currently only the AI-Era Security Audit Report) and selects the Email or LinkedIn variant.
3. **Research local examples** — The Skill finds 2–3 recent (2025–2026) breaches in the target region and industry, preferring obscure small-business victims.
4. **Generate the message** — The template is populated with localised spelling, geo-specific examples, and tone matched to the business size.

## Usage

Load the Skill and provide the five targeting parameters when prompted:

- **Output format:** Email or LinkedIn
- **Target country:** e.g., Australia, United States, United Kingdom
- **Target city/region:** e.g., Adelaide, Manchester, Austin
- **Industry sector:** e.g., hospitality, retail, manufacturing, professional services
- **Business size:** Micro (1–4), Small (5–19), or Medium (20–199)

The Skill will then generate a complete, ready-to-send message with recent local breach examples and a clear, no-pressure call to action.

## Current Offerings

| Offering | Description |
|----------|-------------|
| AI-Era Security Audit Report | A free, no-obligation security audit report for small businesses. Emphasises the new AI-era threat landscape where automated attacks make even the smallest business a viable target. |

## Extending the Skill

To add a new outreach offering:

1. Create a new markdown file in `resources/` (e.g., `resources/compliance-gap-analysis-offer.md`).
2. Follow the same structure as `resources/ai-era-security-audit-offer.md`: include an Email Template section and a LinkedIn Message Template section.
3. Register the new offering in `Skill.md` under **Available Offerings** and add its routing condition under **Conditional Routing → Step 1**.
4. Update the **Current Offerings** table in this README.

No changes to `build-skill.sh` are required if the new resource file is placed in `resources/`.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `business-outreach-generator-skill.zip` containing the Skill definition and all resource files.
