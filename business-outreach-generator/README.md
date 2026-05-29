# Business Outreach Generator

A Claude Skill for generating targeted security outreach messages to small businesses. Supports multiple outreach offerings and two output channels: **Email** and **LinkedIn**.

## How It Works

1. **Collect targeting parameters** — The Skill asks for offering type, output format, target country, city/region, industry sector, and business size.
2. **Select offering and channel** — Conditional logic loads the correct resource template (AI-Era Security Audit Report or Jakarta Migration Risk Assessment) and selects the Email or LinkedIn variant.
3. **Research** — For AI-Era, the Skill finds 2–3 recent breaches; for Jakarta Migration, it researches senior technical staff on the company website.
4. **Generate the message** — The template is populated with localised spelling, geo-specific examples, and tone matched to the business size.

## Usage

Load the Skill and provide the targeting parameters when prompted:

- **Offering:** AI-Era Security Audit Report or Jakarta Migration Risk Assessment
- **Output format:** Email or LinkedIn
- **Target country:** e.g., Australia, United States, United Kingdom
- **Target city/region:** e.g., Adelaide, Manchester, Austin
- **Industry sector:** e.g., hospitality, retail, manufacturing, professional services, tech
- **Business size:** Micro (1–9), Small (10–99), or Medium (100–199)

**For Jakarta Migration only**, also provide the company website URL for senior staff research.

The Skill will then generate a complete, ready-to-send message with recent local breach examples and a clear, no-pressure call to action.

## Current Offerings

| Offering | Description |
|----------|-------------|
| AI-Era Security Audit Report | A free, no-obligation security audit report for small businesses. Emphasises the new AI-era threat landscape where automated attacks make even the smallest business a viable target. |
| Jakarta Migration Risk Assessment | A paid, multi-day consultation for tech companies (1-99 staff) to assess Java EE to Jakarta EE migration risks. Includes automated tooling, deep bytecode dependency analysis, and supply-chain security evaluation. Deliverable: detailed PDF reports with refactoring guides. |

## Extending the Skill

To add a new outreach offering:

1. Create a new markdown file in `resources/` (e.g., `resources/compliance-gap-analysis-offer.md`).
2. Follow the same structure as `resources/ai-era-security-audit-offer.md`: include an Email Template section and a LinkedIn Message Template section.
3. Register the new offering in `Skill.md` under **Available Offerings** and add its routing condition under **Conditional Routing → Step 1**.
4. Update the **Current Offerings** table in this README.

4. Update `build-skill.sh` to copy the new resource file into the staging directory.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `business-outreach-generator-skill.zip` containing the Skill definition and all resource files.
