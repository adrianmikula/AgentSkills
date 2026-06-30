# Business Outreach Generator

A Claude Skill for generating targeted outreach messages for your business ideas. Tightly integrated with the **Business Idea Incubator** skill: offerings are loaded dynamically from `.ideas/ideas/`, and trend context from `.ideas/trends/` is folded into messaging.

Supports six output channels: **Email**, **LinkedIn**, **Phone** (dot-point research brief), **Reddit** (self-post), **StackOverflow** (answer-style post), and **Airtasker** (task response / bid proposal).

## How It Works

1. **Load offerings from Idea Incubator** — The Skill scans `.ideas/ideas/` for active ideas (Validating, Active, Building, Launched) and presents them as available offerings.
2. **Collect targeting parameters** — The Skill asks for offering selection, output format, target country, city/region, industry sector, and business size.
3. **Scan for leads or threads** (if no specific target provided) — The route depends on output format:
   - **Email, LinkedIn, Phone:** Company/developer social scanning
   - **Reddit, StackOverflow:** Thread/question scanning for highly-relevant discussions
   - **Airtasker:** Job/task scanning for open work with few offers
4. **Select offering and channel** — Conditional logic loads the correct resource template (or generates a generic one from the idea file) and selects the appropriate output format.
5. **Research** — The Skill finds relevant breaches, threads, or task matches depending on the format.
6. **Generate the message** — The template is populated with localised spelling, geo-specific examples, and tone matched to the business size.

## Usage

Load the Skill and provide the targeting parameters when prompted:

- **Offering:** Auto-Recommend Best Fit (default), or any active idea from your Idea Incubator
- **Output format:** Email, LinkedIn, Phone, Reddit, StackOverflow, or Airtasker
- **Target country:** e.g., Australia, United States, United Kingdom
- **Target city/region:** e.g., Adelaide, Manchester, Austin
- **Industry sector:** e.g., hospitality, retail, manufacturing, professional services, tech
- **Business size:** Micro (1–9), Small (10–99), or Medium (100–199)

For Phone output, the Skill will also ask for the company website URL for senior staff and tech stack research.

For Reddit, the Skill generates a self-post optimised for the target subreddit (e.g., r/coolgithubprojects, r/selfhosted, r/Wordpress) and respects self-promotion rules.

For StackOverflow, the Skill generates an answer-style post that addresses a specific technical question and mentions the tool/service only as a relevant additional resource.

For Airtasker, the Skill generates a concise bid proposal that leads with what you'll deliver, why you're qualified, and a clear fixed price or price range.

## Current Offerings

Offerings are dynamically loaded from `.ideas/ideas/`. Any idea file with status `Validating`, `Active`, `Building`, or `Launched` will automatically appear as an offering. No manual registration required.

## Architecture

- **Core skill** (`Skill.md`) — Dynamic offering loading, onboarding, scanning mode routing, and conditional routing. Delegates all format-specific behaviour to `resources/output-formats.md`.
- **Output formats** (`resources/output-formats.md`) — Tone rules, template sections, presentation formats, research behaviour, and scanning behaviour for each output channel.
- **Offering templates** (`resources/*-offer.md`) — Per-offering Email/LinkedIn/Phone templates populated with the idea's specifics.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `business-outreach-generator-skill.zip` containing the Skill definition and all resource files.
