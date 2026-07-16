---
name: business-outreach-generator
description: Generate targeted outreach emails, LinkedIn messages, phone call scripts, Reddit posts, StackOverflow answers, or Airtasker task responses for any business idea. Offerings are automatically derived from the Business Idea Incubator (../.ideas/ideas/). Supports Auto-Recommend, developer social scanning, website scanning, and geo-localised outreach.
search_aliases:
  - todo list
  - to-do
  - next steps
  - next actions
  - follow-ups
  - action items
  - call list
  - Monday list
  - leads
  - outreach
---

## Overview

This Skill generates personalised outreach messages for selling your business ideas. It is tightly integrated with the **Business Idea Incubator** skill: the list of available offerings is loaded dynamically from `../.ideas/ideas/` at startup, and trend context from `../.ideas/trends/` is folded into messaging when relevant.

Before generating any outreach, the Skill collects targeting parameters from the human, loads the appropriate idea file, and populates the template with localised examples, spelling, and tone matched to the target.

This Skill also maintains a **To-Do Index** at `../.leads/todo-index.md` that aggregates `Next Action` fields from all lead files into a central table grouped by urgency. Query this skill with "todo list", "to-do", "next steps", "next actions", "follow-ups", "action items", "call list", or "Monday list" to view or update your action items.

---

## Startup Sequence — Load Offerings from Idea Incubator

> **`.ideas/` is gitignored** — `glob`/`grep` skip it. See `resources/accessing-idea-files.md` for how to list, read, and write files under `../.ideas/`.

On every interaction, before collecting parameters:

1. List `../.ideas/ideas/` for `.md` files (see `resources/accessing-idea-files.md`).
2. Parse each to extract: `# [Idea Name]`, `**Slug:**`, `**Status:**`, `## Context`, `## Keywords` (if present), `## Current Focus` (if present), and `## Positioning` (if present — use the Elevator Pitch and USP for messaging).
3. Filter to ideas with `Status` in: `Validating`, `Active`, `Building`, `Launched`. Exclude `Ideation` and `Paused`.
4. Sort ideas so that those with a `## Current Focus` section appear first in the offering list. These are the ideas you are actively working on right now.
5. Build the offering options list dynamically from these ideas, including the extracted keywords for use in scanning.
6. Also read `../.ideas/trends/index.md` (see `resources/accessing-idea-files.md`) to surface active trends relevant to the selected offering.

7. **Check for existing drafts** — List `../.drafts/` for `.md` files. Parse each for `**Status:**` in the header block. Present any with Status `Draft`:
   ```
   You have [N] saved draft outreach message(s):
     [1] [title] — for [idea name], [format], created [date]
     [2] [title] — for [idea name], [format], created [date]
   Would you like to review/resume one, start fresh, or archive drafts you've already posted?
   ```
   - If the human selects a draft: load it, ask *"What would you like to refine?"*, and skip the normal onboarding. The loaded offering and format are determined by the file's `**Target Idea:**` and `**Target Format:**` fields.
   - If the human selects "start fresh": proceed with normal onboarding below.
   - If the human selects "archive": prompt them to mark drafts as `Posted` or `Archived` and save the file. Then proceed with normal onboarding.

8. **Check for active leads** — List `../.leads/` for `.md` files. Parse each for `**Status:**` in the header block. Present any with Status `Warm` or `Follow-up`:
   ```
   You have [N] active lead(s) requiring follow-up:
     [1] [business name] — [contact], last contact [date], status: [Warm/Follow-up]
     [2] [business name] — [contact], last contact [date], status: [Warm/Follow-up]
   Would you like to update any lead, generate follow-up outreach, or proceed with new outreach?
   ```
   - If the human selects a lead: load it, show the conversation history, and ask what action to take.
   - If the human selects "proceed": continue with normal onboarding below.

9. **Check for next-action todos** — Read `../.leads/todo-index.md` if it exists (it auto-indexes `Next Action` fields from all lead files). If any actions are due today or overdue, alert the human:
   ```
   ⏰ You have [N] todo(s) due today:
     [1] [lead] — [next action]
     [2] [lead] — [next action]
   Need help with any of these?
   ```
   This step is triggered by queries about "todo list", "to-do", "next steps", "next actions", "follow-ups", "action items", "call list", or "Monday list".

---

## User Onboarding (Required Before Generation)

Do not generate any outreach until the following parameters have been collected. Ask the human for each in order:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 1 | **Offering** | `Trend-Match (default)`, `Auto-Recommend Best Fit`, followed by all active ideas loaded from `../.ideas/ideas/` (see `resources/accessing-idea-files.md`) — determines which idea file to load. If the human is unsure, default to **Trend-Match**. |
| 2 | **Output format** | `Email`, `LinkedIn`, `Phone`, `Reddit`, `StackOverflow`, `Instagram`, `Flyer`, `PowerPoint`, or `Airtasker`. When `LinkedIn`, `Instagram`, or `Flyer` is selected, an infographic / flyer is co-generated alongside the text. When `PowerPoint` is selected, a series of 1920×1080 slide HTML files are generated for use as presentation slides. See `../infographic-generator/Skill.md` for details. |
| 3 | **Target country** | Free text (e.g., Australia, United States, United Kingdom) — used for spelling localisation and research |
| 4 | **Target city/region** | Free text (e.g., Adelaide, Manchester, Austin) — used for geo-specific targeting |
| 5 | **Industry sector** | Derived from the selected idea file if it specifies one; otherwise infer from `## Context` and `## Key Facts` (e.g., tech, software development, SMBs, agencies, e-commerce, hospitality). If ambiguous, present a shortlist of 3–5 prime target industries for that idea and ask the human to pick one. — used for relevant examples |
| 6 | **Business size** | `Micro` (1–9 staff), `Small` (10–99 staff), `Medium` (100–199 staff) — affects tone, example selection, and phrasing. If the human is unsure, estimate using the methods below. |

**If Offering is "Auto-Recommend Best Fit"**, collect the company website up front (see Auto-Recommendation Engine below) before selecting an offering.

**For specific offering routing rules** (e.g., triggering Developer Social Scanning for Jakarta / Java-related ideas), see **Conditional Routing** below. The routing rules are dynamically matched based on the selected offering's name, slug, and linked trends.

**For ALL offerings when Output format is "Phone"**, also collect:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 7 | **Company website** | Domain or URL — used to research senior technical staff and assess technology stack suitability |
| 8 | **Contact research** | After receiving the website, research senior technical staff (CTO, Dev Director, Tech Lead, Architect, Founder) on the company website. If insufficient info, search LinkedIn. |
| 9 | **Contact phone** | Direct phone number of the identified senior technical contact. Check the website Contact page, team directory, or corporate directory. If unavailable online, ask the human if they have it, or note it as "Not found — dial main line and ask for contact by name." |

### Business Size Estimation (when the human is unsure)

If the human does not know the business size, estimate it using the following hierarchy:

1. **LinkedIn Company Page** — Check the company's LinkedIn page for a "Company size" field. Map as follows:
   - `1–10 employees` or `1–9 employees` → **Micro**
   - `11–50 employees`, `51–200 employees`, or `11–200 employees` → **Small**
   - `201–500 employees`, `501–1000 employees`, `1001–5000 employees`, or `5001–10,000 employees` → **Medium** (if within 100–199 range, use Small)
   - `10,001+ employees` → too large; skip this company for small-team offerings

2. **Website Locations / Offices Page** — If LinkedIn data is unavailable, check the company's website for an "Our Offices", "Locations", or "Contact" page:
   - Single location, no mention of additional offices → likely **Micro** or **Small**
   - 2–5 locations listed → likely **Small**
   - 6+ locations or explicit mention of multiple countries → likely **Medium** or larger

3. **Team / About Page** — Count named staff on the website:
   - Fewer than 10 named staff → **Micro**
   - 10–50 named staff → **Small**
   - More than 50 named staff → **Medium** (or skip if clearly 200+)

4. **Cross-reference** — If multiple methods yield conflicting results, prefer the **most conservative** estimate (the smaller size category). When in doubt, ask the human to confirm.

Record the estimated size and the source of the estimate (e.g., "LinkedIn: 11–50 employees → Small").

### Rate Limiting for External Research

When performing LinkedIn lookups or any external web research during contact research or business size estimation:

- **Maximum 3 LinkedIn page requests per minute** to avoid triggering rate limits, firewalls, or bot detection.
- If multiple companies need research, **pace requests** and wait at least 20 seconds between each LinkedIn page load.
- If a page fails to load or returns an error, **do not retry immediately** — move to the next fallback method (website, other sources) and return to LinkedIn later if needed.
- Prefer **caching results** when working through a batch of companies; do not re-query LinkedIn for the same company within the same session.

Record all answers. If the human is unsure about any field, suggest common values for their country but do not assume defaults.

### Auto-Recommendation Engine (when Offering == "Auto-Recommend Best Fit")

If the human selects **Auto-Recommend Best Fit**, change the onboarding order slightly:

1. **Collect company name, website URL, country, city, and industry first** — these are needed for research.
2. **Research the company website** (and LinkedIn if needed) following the same rate-limiting rules above.
3. **Read `../.ideas/trends/index.md`** (see `resources/accessing-idea-files.md`) to understand current market conditions.
4. **Evaluate each active idea from `../.ideas/ideas/`** against the company's signals (see `resources/accessing-idea-files.md`). Use the idea's own `## Context`, `## Key Facts`, and any `## Linked Trends` to determine fit.
5. Score each idea based on:
   - Direct match between idea's target market and the company's profile
   - Relevant active trends that increase urgency
   - Technology stack alignment (e.g., Jakarta migration for Java shops, WordPress plugins for WP sites)
6. Present a concise recommendation with rationale.
7. **Ask the human to confirm the recommended idea** or override it with a different choice.
8. **Then collect Output format** and any remaining parameters.

#### Presenting the Recommendation

Present the result in this exact format:

```
**Recommended Offering:** [Idea Name from incubator]
**Status:** [Idea Status]
**Confidence:** [High / Medium / Low]
**Rationale:** [1–2 sentences explaining the key signals]
**Discouraged:** [List any ideas that are a poor fit and why, or "None"]
```

Then ask: *"Does this look right, or would you prefer a different offering?"*

If the human overrides, proceed with their manual choice. If they confirm, proceed with the recommended offering.

---

## Trend-Based Offering Selection (when Offering == "Trend-Match")

When the human selects **Trend-Match** (the default), select the offering by matching active trends to available ideas rather than asking the human to choose directly:

1. **Load active ideas** — Use the idea list already loaded during the Startup Sequence (filtered to Status: `Validating`, `Active`, `Building`, `Launched`).

2. **Read trend data** — Load `../.ideas/trends/index.md` (see `resources/accessing-idea-files.md`) and parse the trends table for all entries where `Status` is `Active`.

3. **Cross-reference** — For each active trend, look up its `Linked Ideas` column. Match slugs against the loaded ideas to find which ideas are linked to which trends.

4. **Score ideas** by the following criteria:
   - **Trend count:** number of active trends linked to the idea (higher is better)
   - **Trend urgency:** preference for trends categorised as `Security` over `Technology`, and trends with the most recent `Last Verified` date
   - **Idea status:** `Validating` ideas get a slight bonus (they benefit most from trend-driven outreach); `Active` and `Building` are neutral; `Launched` get no bonus

5. **Select the top-scoring idea.** If there is a tie, prefer the idea with the most recently verified linked trend, then the idea whose `## Context` most closely mirrors the trend description.

6. **Present the selection** to the human with rationale:
   ```
   **Trend-Match Result:** [Idea Name from incubator]
   **Status:** [Idea Status]
   **Matched Trend(s):** [trend titles, one per line]
   **Rationale:** [1–2 sentences explaining why this trend makes this offering timely]
   ```

7. **Confirm** with the human: *"This is my recommendation based on current trends. Shall I proceed with [Idea Name], or would you prefer a different offering?"*

8. If the human confirms, proceed with the selected offering, passing the matched trend context into the outreach generation (Step 4 of Conditional Routing will use it for research). If they override, proceed with their manual choice.

**How this differs from Auto-Recommend Best Fit:** Trend-Match selects based on macro-level market trends (what's being discussed broadly on Reddit, news, and social platforms), not on a specific target company's signals. Auto-Recommend selects based on a specific company's technology stack, industry, and profile. Trend-Match does not require a company website or LinkedIn research.

---

## Developer Social Scanning Mode

When the human has **not** provided a specific company name or website for the selected offering, decide whether to trigger **Developer Social Scanning Mode** based on the idea's content, not hardcoded slug lists.

### Mode Selection Heuristic

Load the selected idea file and analyse `## Context` and `## Key Facts` for the following signals:

**Trigger Developer Social Scanning if ANY of these are true:**
- The idea targets developers, engineers, or technical teams (e.g., mentions "IDE", "plugin", "developer tooling", "engineering team", "codebase", "migration", "refactoring", "audit", "Java", "JVM", "backend")
- The idea's `## Key Facts` mentions a platform like "JetBrains Marketplace", "VS Code Marketplace", "Stack Overflow", "GitHub", "IntelliJ", "IDE integration"
- The idea is described as "power tooling", "consulting", "engineering audit", "technical assessment", or "developer productivity"
- The idea's linked trends are categorised as `Technology` or `Security` with code-level risk signals
- The idea's target market is listed as "tech companies", "enterprise Java teams", "software development firms", or similar

If none of these signals are present, ask the human:
> "This idea doesn't appear to be developer-focused. Should I scan general business directories instead, or do you have a specific company in mind?"

### Dynamic Signal Extraction

Before scanning, extract the following from the selected idea file:

**Query keywords** — use the idea's `## Keywords` field if present. These are the pre-defined, idea-specific terms for scanning. If the field is missing, fall back to combining terms from `## Context` and `## Key Facts`.

**Signal taxonomy** — use the idea's `## Key Facts` and `## Context` to define Tier 1 / Tier 2 / Tier 3 signals. The `## Keywords` inform the query; the `## Context` and `## Key Facts` inform what counts as a strong match.

**Opening line examples** — reference the idea's specific value proposition, using `## Keywords` where relevant to make the outreach feel specific.

**Signal taxonomy** — derive Tier 1 / Tier 2 / Tier 3 signals from the idea's own problem description:
- **Tier 1 (+3):** Posts that directly describe the exact pain the idea solves (e.g., "stuck on javax imports", "Spring 7 won't compile with javax")
- **Tier 2 (+2):** Posts describing adjacent pain or related blockers (e.g., "transitive dependency conflicts", "legacy server assumptions")
- **Tier 3 (+1):** Posts mentioning the technology domain or expressing general frustration with the problem space
- **Disqualify:** Posts explicitly stating the problem is already solved, or off-topic

**Opening line examples** — reference the idea's specific value proposition:
- "[Idea name] here — I built [specific capability] because [specific reason from idea's Context]."
- "I saw your post about [specific pain from thread]. I've been working on [idea's solution] and found [relevant insight]."

### Scanning Behaviour

Use the shared scanning framework in `resources/developer-social-scanning.md`, but substitute the dynamically extracted keywords and signals:
1. Confirm the target country, city/region, and industry sector (if not already collected)
2. Scan developer social, Q&A, and forum platforms (Stack Overflow, GitHub, Reddit, LinkedIn, Hacker News, Dev.to, and similar) using the extracted query keywords
3. Score and rank each discovered lead against the dynamically built signal taxonomy
4. Present a prioritised shortlist with matched signals and suggested outreach angle
5. Offer to generate a targeted outreach message for any selected candidate

> **Format adaptation:** When `Output format` is `Reddit` or `StackOverflow`, reinterpret this mode as **Thread / Question Scanning**: search for relevant discussion threads or questions rather than companies or developers. See `resources/output-formats.md` → "Lead-Scanning Mode Routing" for details.

---

## Website Security Social Scanning Mode

When the human has **not** provided a specific company name or website for the selected offering, decide whether to trigger **Website Security Social Scanning Mode** based on the idea's content, not hardcoded slug lists.

### Mode Selection Heuristic

Load the selected idea file and analyse `## Context` and `## Key Facts` for the following signals:

**Trigger Website Security Social Scanning if ANY of these are true:**
- The idea targets website owners, agencies, or non-technical businesses (e.g., mentions "website", "WordPress", "plugin", "security audit", "vulnerability scan", "patch", "CDN", "supply chain", "agency", "client sites")
- The idea's `## Key Facts` mentions platforms like "WordPress Plugin Directory", "BuiltWith", "WPScan", "npm audit", "Packagist", "WordPress", "Laravel", "CMS"
- The idea is described as "security tooling", "vulnerability scanner", "security pipeline", "compliance audit", or "web security"
- The idea's linked trends are categorised as `Security` involving supply chain, plugin, website, or CDN risk
- The idea's target market is listed as "SMBs", "web agencies", "small businesses", "e-commerce", "hospitality", or similar non-developer segments

If none of these signals are present, ask the human:
> "This idea doesn't appear to be website/security-focused. Should I scan developer platforms instead, or do you have a specific company in mind?"

### Dynamic Signal Extraction

Before scanning, extract the following from the selected idea file:

**Query keywords** — use the idea's `## Keywords` field if present. These are the pre-defined, idea-specific terms for scanning. If the field is missing, fall back to combining terms from `## Context` and `## Key Facts`.

**Signal taxonomy** — use the idea's `## Key Facts` and `## Context` to define Tier 1 / Tier 2 / Tier 3 signals. The `## Keywords` inform the query; the `## Context` and `## Key Facts` inform what counts as a strong match.

**Opening line examples** — reference the idea's specific value proposition, using `## Keywords` where relevant to make the outreach feel specific.

### Scanning Behaviour

Use the shared scanning framework in `resources/developer-social-scanning.md` with security scanning variations, but substitute the dynamically extracted keywords and signals:
1. Confirm the target country, city/region, and industry sector (if not already collected)
2. Scan BuiltWith for relevant platforms (WordPress, Joomla, Drupal, etc.) in the target city, using the extracted keywords to filter for risk signals matching the idea
3. Cross-reference with local business directories to surface contact names and business details
4. Score and rank each discovered lead against the dynamically built signal taxonomy
5. Present a prioritised shortlist with matched signals and suggested outreach angle
6. Offer to generate a targeted outreach message for any selected candidate

> **Format adaptation:** When `Output format` is `Reddit` or `StackOverflow`, reinterpret this mode as **Thread / Question Scanning**: search for relevant discussion threads or questions rather than companies. When `Output format` is `Airtasker`, trigger **Job / Task Scanning** instead. See `resources/output-formats.md` → "Lead-Scanning Mode Routing" for full details.

---

## Local Business Lead Generation

When the selected offering targets micro/local businesses (cafes, restaurants, hairdressers, retail, etc.) that may need website work, use `resources/local-business-lead-gen.md` instead of developer/website scanning modes. That file contains lead sources, search queries, scoring criteria, and outreach angles specific to this segment.

---

## Conditional Routing

After collecting the onboarding parameters, select the template and resource using the following logic:

### Step 1 — Select Offering Resource

Based on the selected `Offering` parameter:

The offering resource is determined by the idea file's slug. Try loading resource files in this order:

1. `resources/{slug}-offer.md`
2. `resources/{slug}.md`
3. If no specific resource file exists, generate a **Generic Outreach Template** using the idea's `## Context` and `## Key Facts` from the idea file.

**Special mode triggers (evaluated after resource selection):**

- If the selected offering is **Developer Social Scanning eligible** (per the section above) AND no company name or website has been provided, trigger Developer Social Scanning Mode. Do not proceed to Step 2 until the human has selected a candidate from the scan results and confirmed they want to generate outreach for that candidate.

- If the selected offering is **Website Security Social Scanning eligible** (per the section above) AND no company name or website has been provided, trigger Website Security Social Scanning Mode. Do not proceed to Step 2 until the human has selected a candidate from the scan results and confirmed they want to generate outreach for that candidate.

### Step 2 — Select Output Template

Within the loaded resource (or generic template), apply the output-format-specific section as defined in `resources/output-formats.md` → "Template Sections". If the loaded resource file does not contain the requested section, use the fallback rules in that same document.

### Step 3 — Populate Placeholders

Replace all placeholder tokens in the selected template with the collected parameters and data loaded from the idea incubator. Placeholder definitions are in the loaded resource file or `resources/output-formats.md` → "Template Sections".

### Step 4 — Localise, Research, and Generate Infographic (if applicable)

Follow the instructions in the loaded resource file to:

1. Adjust spelling and phrasing to match the target country's English variant (e.g., Australian English: "programme", "localise"; US English: "program", "localize").
2. Read `../.ideas/trends/index.md` (see `resources/accessing-idea-files.md`) for any active trends linked to the selected idea. If linked trends exist:
   - For **Email, LinkedIn, Phone** formats: research 2–3 recent (2025–2026) breaches or incidents illustrating the trend's evidence. Prefer **obscure, non-high-profile victims** — family-owned businesses, regional franchises, niche suppliers, small hospitality groups, local manufacturers. Avoid multinationals unless no local examples exist. Verify sources are reputable and include links.
   - For **Reddit, StackOverflow** formats: find 1–2 relevant threads or incidents from the trend to reference naturally in the post/answer. Do not force-fit breach examples into technical threads.
   - For **Airtasker** format: no breach research needed; focus on matching the task requirements.
3. If no linked trends exist, fall back to standard breach research for `{{INDUSTRY}}` in `{{COUNTRY}}` using the same criteria (Email, LinkedIn, Phone only).
4. **If Output format is `LinkedIn`, `Instagram`, or `Flyer`:** Generate a visual asset alongside the text and convert to PNG. Load `../infographic-generator/Skill.md` for canvas dimensions, branding rules, styling approach, target audience, and PNG generation. For `Flyer` format specifically, see `../infographic-generator/Skill.md` → "Flyer-Specific (A5)" for ink-saving light-background design rules, QR code placement, and contact section requirements. Derive the `target_audience` from the onboarding parameters already collected:

   ```
   Derive target_audience from Business size + Industry sector:
   - Micro (1–9 staff) + hospitality/retail/service/healthcare → non-technical
   - Micro + tech/software/IT → mixed
   - Small (10–99 staff) + non-technical industry → mixed
   - Small + tech/software/IT → technical
   - Medium (100–199 staff) + any industry → technical
   - Default fallback: non-technical
   ```

   Pass the derived value to the infographic generator so it governs wording, jargon level, and framing (see `../infographic-generator/Skill.md` → "Target Audience Parameter"). Save both the `.html` and `.png` files to `../.infographics/` and note the PNG path in the draft metadata.

5. **If Output format is `Flyer`:** Generate an A5 flyer alongside the text and convert to PNG. Load `../infographic-generator/Skill.md` → "Flyer-Specific (A5)" for dimensions (1748×2480 px), ink-saving light-background design rules, QR code generation, and contact section layout. See also `../infographic-generator/Skill.md` → "Branding Assets" for logo embedding. Save both the `.html` and `.png` files to `../.flyers/` and note the PNG path in the draft metadata.

6. **If Output format is `PowerPoint`:** Generate a series of 1920×1080 slide HTML files for use as presentation slides. Load `../infographic-generator/Skill.md` → "PowerPoint Slide Generation" for dimensions, slide structure, and deck organization. Save each slide as a numbered HTML file under `../.slides/{deck-name}/` and generate an index deck file. Note the slide directory path in the draft metadata.

### Branding Assets

When generating infographics, slides, or flyers, source images from `.branding/`. See `../infographic-generator/Skill.md` → "Branding Assets" for directory structure, theme selection, and embedding rules.

---

## Tone, Style, and Presentation Rules

All tone rules, length guidelines, platform-specific rules, and presentation guidance are defined in `resources/output-formats.md`. That file contains:

- **Tone and Style Rules by Format** — length, tone, CTA style, and platform rules for each output format
- **Template Sections** — which section name to use per format, and fallback template structures
- **Presentation by Format** — how to display the final output for each channel
- **Format-Specific Research Behaviour** — how research differs for Email/LinkedIn/Phone vs. Reddit/StackOverflow vs. Airtasker
- **Lead-Scanning Mode Routing** — how scanning modes adapt to the output format

Consult `resources/output-formats.md` whenever generating any outreach message.

---

## Grounding Requirement — No Hallucinated Claims

All outreach messages must be factually grounded in the selected idea file. **Do not invent capabilities, experiments, metrics, pricing, guarantees, or offer details that don't exist.**

### Required Pre-Generation Check

Before writing any outreach, load the selected idea file and extract:

1. **`## Current Focus`** — What you are actively building/working on right now. Only claim features listed here.
2. **`## One-Sentence Pitch`** — The one-sentence description of what your product/service actually does.
3. **`## USP`** — The specific differentiator. Don't invent others.
4. **`## Context` and `## Key Facts`** — Any specific research findings, papers, or data points referenced here may be cited. Do not cite research not listed here.
5. **`## Refined Acquisition Offer`** (if present) — The actual pricing, tiers, and terms. Do not mention, imply, or promise any pricing, discounts, or guarantees not explicitly listed here.

### Strict Rules — No Invented Offer Details

- **Pricing:** Only mention prices or pricing structures explicitly documented in the idea file. Never invent or guess at pricing, payment terms, or discount amounts.
- **Guarantees:** Never claim satisfaction guarantees, refund policies, warranties, or service-level agreements unless they are explicitly stated in the idea file.
- **Tiers/features:** Only list tiers, features, and capabilities that are explicitly documented. Do not add extra features to make an offer sound more appealing.
- **Availability:** Do not claim specific turnaround times, availability, or delivery dates that are not documented (e.g., "live in 24 hours", "unlimited revisions").
- **Results/promises:** Never promise specific outcomes (e.g., "double your sales", "rank #1 on Google", "get 1000 customers"). Stick to describing what the product/service is and does.
- **External claims:** Do not cite external statistics, research, or case studies not listed in the idea file's `## Key Facts`.
- **If the idea file has no offer/pricing section at all:** Do not mention pricing. Frame the outreach as exploratory: *"I'm not sure if this fits your needs, but I'd love to chat about what I'm working on."*

### Claim Validation Rules

For every specific claim in the draft, verify:

| Claim type | Must be grounded in | Example violation | Example fix |
|---|---|---|---|
| "I built / I've been building / I'm experimenting with X" | `## Current Focus` | "I built a CI gate" (tool runs IDE-only) | "I'm experimenting with IDE-level drift detection" |
| "X does Y" (product capability) | `## One-Sentence Pitch` or `## USP` | "SlopGuard runs structural CI checks" (only flags IDE problems) | "SlopGuard flags problems while the agent is coding" |
| "Research shows Z" (data/papers) | `## Key Facts` or cited in idea file | Citing a paper not in the idea file | Only cite papers listed in the idea file |
| "I've been tracking / measuring W" | `## Current Focus` or `## Context` | "Tracking afferent coupling" (no such feature) | "Researching patterns of architectural drift in AI code" |
| "It costs / starts at / is priced at X" | `## Refined Acquisition Offer` | Quoting $300 for a service priced at $500 | Use the exact price from the offer section |
| "We guarantee / we promise / your money back" | `## Refined Acquisition Offer` or not present | Claiming a 30-day money-back guarantee not in the idea file | Omit guarantee claims entirely |
| "Tier X includes Y feature" | `## Refined Acquisition Offer` tier description | Saying "Premium includes 24/7 support" when not listed | Only list features explicitly in the tier description |

### When in Doubt, Omit or Vague Up

If you're unsure whether a claim is accurate for the actual product or offer:
- Do NOT guess, embellish, or extrapolate
- Omit the detail entirely if you cannot verify it from the idea file
- Use generic framing: *"I've been researching..."*, *"I'm exploring..."*, *"I'm working on something in this space"*
- Keep claims at the observation/research level, not the product or offer level
- When referencing the product or offer, use the exact language from the idea file — no more, no less
- **It is better to be vague than to be wrong.** A generic message with accurate claims is more trustworthy than a specific message with invented details.

### Audit Trail

Save the verification with the draft metadata:
```
**Grounded In:** [idea-slug]
**Verified Claims:** [list of claims made and where each is grounded]
```

This applies to **all formats** — Email, LinkedIn, Reddit, StackOverflow, Instagram, Phone, PowerPoint, Airtasker.

### Infographic-Specific Grounding

When generating an infographic (Instagram, LinkedIn visual) or slide deck (PowerPoint), the rules above apply to the accompanying text. For the visual content itself (stats, quotes, personas rendered on the canvas), see `../infographic-generator/Skill.md` → "Grounding Rules — No Hallucinated Content" — which prohibits fabricated testimonials, unsourced metrics, and includes a post-generation verification step.

---

## Drafts System

Draft outreach messages are stored in `../.drafts/` (gitignored — never committed). Each draft is a markdown file with a header block containing metadata:

```markdown
# [Human-readable title]

**Target Idea:** [idea-slug]
**Target Format:** [Email | LinkedIn | Phone | Reddit | StackOverflow | Instagram | Flyer | PowerPoint | Airtasker]
**Status:** [Draft | Posted | Archived]
**Created:** [YYYY-MM-DD]
**Thread:** [URL to thread/post being replied to, if applicable]
**Infographic:** [Path to generated infographic HTML file, if applicable]
**Flyer:** [Path to generated flyer PNG file, if applicable]
**Slide Deck:** [Path to generated slide deck directory, if applicable]
```

### Draft lifecycle

1. **Created** — The agent writes the draft and saves it to `../.drafts/{slug}.md` with Status: `Draft`.
2. **Resumed** — On next skill init, the Startup Sequence detects Draft-status files and offers to resume them.
3. **Refined** — If the human chooses to resume, load the draft, apply their requested changes, and re-save.
4. **Posted / Archived** — After the human confirms the message is final, ask: *"Mark this as Posted or Archive it?"* Update the Status field and save.

### Draft directory conventions

- `../.drafts/` is gitignored — safe to save incomplete messages, API keys, or thread URLs.
- Filenames should be descriptive: `{topic}-{format}-{target}.md` (e.g., `jakarta-migration-reddit-r-springboot.md`).
- Each file contains the **final rendered message**, not a template. The header metadata is the only structured section.
- Deleting a draft file is equivalent to discarding it. The agent can suggest deletion if a draft is stale, but should confirm with the human first.

---

## Leads System

Active leads (warm responses, follow-ups requested, details asked for) are tracked in `../.leads/` (gitignored — never committed). Each lead is a markdown file with a header block containing metadata:

```markdown
# [Business Name]

**Target Idea:** [idea-slug]
**Lead Source:** [Phone call | Email | LinkedIn | Instagram DM | In-person | Referral]
**Status:** [New | Warm | Follow-up | Meeting booked | Closed won | Closed lost]
**First Contact:** [YYYY-MM-DD]
**Last Contact:** [YYYY-MM-DD]
**Contact Person:** [Name, Role]
**Contact Method:** [Phone | Email | DM | etc.]
**Next Action:** [What needs to happen next]
```

### Lead lifecycle

1. **Created** — When a cold call/email gets a positive response ("interested", "passing to owner", "send more details", "call me next week"), create a lead file in `../.leads/{slug}.md` with Status `Warm`.
2. **Follow-up** — When the Startup Sequence detects Warm/Follow-up leads, offer to generate follow-up outreach or log a status update.
3. **Updated** — Each interaction with the lead appends a dated entry to the Conversation Log section.
4. **Closed** — When the deal is won or lost, update Status to `Closed won` or `Closed lost` and add a closing note.

### Lead file structure

```markdown
# [Business Name]

**Target Idea:** [idea-slug]
**Lead Source:** [source]
**Status:** [Warm]
**First Contact:** [YYYY-MM-DD]
**Last Contact:** [YYYY-MM-DD]
**Contact Person:** [Name, Role]
**Contact Method:** [Phone | Email | DM]
**Next Action:** [specific next step]

## Conversation Log

### YYYY-MM-DD — [Type: Cold call / Follow-up / Update]
- [Key points from the interaction]
- [Outcome: what the contact said, what was agreed]
- [Next step agreed]
```

### Lead directory conventions

- `../.leads/` is gitignored — safe to store contact names, notes, and follow-up dates.
- Filenames should be descriptive: `{business-slug}.md` (e.g., `kalahari-taste-of-africa.md`).
- Each file contains the conversation history. The header metadata is the only structured section.
- Closing a lead: update Status to `Closed won` or `Closed lost`, add a closing note, keep the file for reference.

### To-Do Index

A central `../.leads/todo-index.md` file auto-indexes all `Next Action` fields across lead files. It groups actions by urgency (due today, this week, flexible) and is consumed by the Startup Sequence (step 9) for daily action reminders. After creating, updating, or closing a lead, regenerate this index to keep it in sync. The index's `search_aliases` (todo list, to-do, next steps, next actions, follow-ups, action items, call list, Monday list) ensure queries about task lists route to the right skill.

### Initial leads migration

When the human reports positive responses from cold outreach, the agent should:
1. Ask: "Should I create a lead file for [business]?"
2. Extract the key details from the conversation and write the file.
3. Offer to generate follow-up outreach if next steps are clear.

---

MCP servers can formalize API calls for outreach formats. See `resources/mcp-tools-for-outreach.md` for a catalog of available servers per format, installation instructions, and recommended setup order. Once configured, the agent can use MCP tools to discover leads, post content, and send messages directly from within the session.

---

## Extension Guide (For Maintainers)

To add a new outreach offering:

1. **Add the idea** to the Business Idea Incubator by creating a new `../.ideas/ideas/{slug}.md` file with Status: `Validating` or `Active` (see `resources/accessing-idea-files.md`).
2. **Optionally create** `resources/{slug}-offer.md` following the structure of `ai-era-security-audit-offer.md` for the offering.
3. **If the idea** is developer-tooling or technical consulting, it will automatically trigger Developer Social Scanning Mode based on slug/keyword matching.
4. **If the idea** is security or website-focused, it will automatically trigger Website Security Social Scanning Mode based on slug/keyword matching.
5. **Output formats** are handled centrally in `resources/output-formats.md` — no per-offering format changes are needed.
6. **Thread/Question scanning** (Reddit, StackOverflow) and **Job/Task scanning** (Airtasker) are enabled automatically based on the output format selected; no per-offering configuration is needed.
7. **Update `build-skill.sh`** to copy any new resource file into the staging directory.
