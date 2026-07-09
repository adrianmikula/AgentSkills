---
name: business-idea-incubator
description: Validate, refine, and implement business ideas through multidisciplinary coaching. Adapts to your experience level across idea validation, startup foundations, marketing, sales, deployment, and more. Tracks progress and surfaces blind spots. Also tracks external market trends and conditions that affect your ideas.
---

## Overview

This Skill helps entrepreneurs incubate business ideas by combining insights from multiple disciplines: idea validation, startup foundations, marketing, outreach framing, profitability, competitive intelligence, business operations, vibe coding, production deployment, e-commerce selling, social media, and funding & capital strategy. 

It adapts to your experience level, focusing research, advice, and coaching on the disciplines where you need the most help — especially areas you identify as weaknesses or blind spots. A core priority is understanding your actual financial resources before making any recommendations about funding, and matching funding strategies to your specific stage, industry, and value proposition.

2026-native validation methods are embedded throughout: **pain-mining tools** that scrape frustration language from Reddit, HN, and Product Hunt; **AEO query mining** for verbatim demand language from AI search systems; **pre-sale validation** as the gold-standard demand signal; and **adverse review mining** to identify where adjacent products underserve customers. These replace older "check Google Trends" and "would you use this?" survey patterns with higher-signal techniques.

Additionally, the Skill maintains a **Trends Log** of timestamped external factors (threat landscapes, regulatory changes, technology shifts, competitive moves) that affect the viability and positioning of your ideas. Trends are refreshed automatically if older than 30 days.

---

## State Management Protocol

> **`.ideas/` is gitignored** — `glob`/`grep` skip it. See `resources/accessing-idea-files.md` for how to list, read, write, and search files under `.ideas/`.

The Skill maintains persistent state across sessions using markdown files in a `.ideas/` folder at the project root.

### Directory Structure

```
.ideas/
├── ecosystem-map.md       # Visual/composite map of all ideas, trends, and relationships — use for upsell paths, bundling opportunities, and authority domain strategy
├── human-profile.md       # Your expertise, background, and financial resources
├── personality-profile.md # Working style, strengths/weaknesses, communication preferences
├── funding/
│   └── [idea-slug].md      # Funding status, milestones, and grant/investor tracking per idea
├── trends/
│   ├── index.md           # Index of all trends with timestamps and expiry dates
│   ├── trend-[slug].md    # One file per trend (deduplicated by slug)
│   └── refresh-queue.md   # Tracks trends approaching or past expiry, awaiting refresh
└── ideas/
    └── [idea-slug].md     # One file per business idea (deduplicated by slug)
```

### File Purposes

| File | Purpose | Update Trigger |
|------|---------|----------------|
| `.ideas/ecosystem-map.md` | Composite view of all ideas and trends — used to identify upsell paths, bundling opportunities, and authority domain gaps | Update whenever a new idea or trend is added that changes the relationship landscape |
| `.ideas/human-profile.md` | Stores your confidence/experience level per discipline, financial resources, background context, and tool preferences | Initial onboarding, then only when you explicitly update it |
| `.ideas/personality-profile.md` | Stores your working style, known strengths/weaknesses, and how you prefer to receive feedback | Initial onboarding, then when you share new self-awareness |
| `.ideas/funding/{slug}.md` | Tracks funding status, milestones, grant applications, investor contacts, and financial resources for a specific business idea | After each funding-related interaction, capital change, or milestone |
| `.ideas/trends/index.md` | Master index of all tracked trends with timestamps, category tags, and expiry dates | Added/updated when trends are logged or refreshed |
| `.ideas/trends/trend-[slug].md` | Detailed record of a single trend: source, context, impact assessment, and linked ideas | Added when new trend is recorded; updated when trend is refreshed |
| `.ideas/trends/refresh-queue.md` | Auto-generated list of trends approaching or past 30-day expiry, with refresh status | Updated every session during startup |
| `.ideas/ideas/{slug}.md` | Tracks progress, major decisions, key findings, and next steps for a specific business idea | After each meaningful interaction about that idea |

### Trend File Format

Each `.ideas/trends/trend-[slug].md` follows this structure:

```markdown
# [Trend Title]

**Slug:** `[slug]`
**Category:** [Security / Regulatory / Technology / Competitive / Market / Economic]
**First Observed:** [Date]
**Last Verified:** [Date]
**Expires:** [Date + 30 days]
**Status:** Active / Stale / Archived / Superseded
**Source:** [URL or description of source]
**Confidence:** [High / Medium / Low]

## Summary
[1–2 sentences describing the trend and why it matters]

## Evidence
- [Specific data point, incident, or announcement]
- [Supporting source with date]

## Impact Assessment
**Affects ideas:**
- [Idea name] — [How this trend changes the idea's positioning, urgency, or viability]
- [Idea name] — [How this trend changes the idea's positioning, urgency, or viability]

**Recommended action:**
- [Concrete step to take advantage of or respond to this trend]

## Refresh Notes
[Added when trend is refreshed — what changed, what didn't]
```

### Trend Index Format

`.ideas/trends/index.md` follows this structure:

```markdown
# Trends Index

**Last Updated:** [Date]
**Total Trends:** [n]
**Active:** [n] | **Stale:** [n] | **Archived:** [n] | **Refresh Queue:** [n]

| Slug | Title | Category | First Observed | Last Verified | Expires | Status | Linked Ideas |
|------|-------|----------|----------------|---------------|---------|--------|--------------|
| [slug] | [title] | [category] | [date] | [date] | [date] | [status] | [idea-slug(s)] |
```

### Refresh Queue Format

`.ideas/trends/refresh-queue.md` follows this structure:

```markdown
# Trend Refresh Queue

**Generated:** [Date]

## Expired Trends (past 30 days) — Refresh Required

| Slug | Title | Expired | Linked Ideas | Action |
|------|-------|---------|--------------|--------|
| [slug] | [title] | [date] | [idea(s)] | [Refresh/Archive/Supersede] |

## Approaching Expiry (within 7 days)

| Slug | Title | Expires | Linked Ideas | Action |
|------|-------|---------|--------------|--------|
| [slug] | [title] | [date] | [idea(s)] | [Schedule refresh] |
```

### Deduplication Rules

**Trends:** Before creating a new trend file, search `.ideas/trends/` for existing files (see `resources/accessing-idea-files.md`). Match by:
1. Exact slug match (normalized: lowercase, hyphens for spaces)
2. Fuzzy match if title/summary closely matches a known trend

If a match is found, load and update that trend. If the trend is stale (expired), trigger a refresh instead of creating a duplicate.

**Ideas:** Before creating a new idea file, search `.ideas/ideas/` for existing files (see `resources/accessing-idea-files.md`). Match by:
1. Exact slug match (normalized: lowercase, hyphens for spaces)
2. Fuzzy match if title/description in file closely matches the new idea

If a match is found, load and continue that file. If multiple matches exist, ask which to continue.

### Trend Reference in Idea Files

Idea files may reference trends using this block (optional, appended near the bottom):

```markdown
## Linked Trends

| Trend Slug | Trend Title | Relevance |
|------------|-------------|-----------|
| [trend-slug] | [trend title] | [How this trend affects this idea] |
```

### Idea File Format

Each `.ideas/ideas/{slug}.md` follows this structure:

```markdown
# [Idea Name]

**Slug:** `[slug]`
**Created:** [Date]
**Status:** Ideation / Validating / Building / Launched / Paused

## Context
[Core concept, 1-2 sentences]

## Keywords
[Comma-separated list of relevant keywords for outreach, scanning, and search. Include technology terms, platform names, pain-point terms, and target audience descriptors. Example: "Java EE, Jakarta EE, migration, OpenRewrite, Spring, IntelliJ, enterprise Java"]

## Key Facts
- [Fact 1]
- [Fact 2]
- [Fact 3]

## Linked Trends
| Trend Slug | Trend Title | Relevance |
|------------|-------------|-----------|
| [trend-slug] | [trend title] | [How this trend affects this idea] |

## Current Focus
[Optional. If this idea is currently being actively built, outreached for, or delivered to customers, describe the current focus here. Ideas with a Current Focus section are prioritised and suggested first by the Business Outreach Generator.]

## Progress Log

### [Date] — [Session Title]
- **Decision:** [Key decision made]
- **Finding:** [Important discovery]
- **Next Step:** [Action item]
- **Disciplines Covered:** [List]

---
```

The `## Keywords` field is used by the Business Outreach Generator to build consistent scan queries and signal taxonomies. Update it whenever the idea's positioning or target audience changes.

Do not store full conversation transcripts. Append only structured summaries of decisions, findings, and next steps.

### Funding Section in Idea Files

Each `.ideas/ideas/{slug}.md` may include a funding section (append after Key Facts or Linked Trends):

```markdown
## Funding

**Stage:** Pre-Revenue / Prototype / Early Traction / Revenue
**Available Capital:** $[amount]
**Runway:** [X] months
**Salary Requirement:** [Yes / No / Part-time]
**Friends & Family Access:** [Yes / No / Amount range]
**Previous Funding:** [None / Amount and stage]

### Funding Plan
[Summarize the current funding strategy: bootstrap, grants, pre-sales, etc.]

### Funding Milestones Log

| Date | Action | Amount | Status | Notes |
|------|--------|--------|--------|-------|
| [Date] | [Applied to grant / pitched to angel / pre-sold] | $[amount] | [Pending / Won / Lost] | [Notes] |
```

Update the funding section whenever the financial situation changes, a funding milestone is reached, or a new funding option is being pursued.

### Funding File Format

Each `.ideas/funding/{slug}.md` follows this structure:

```markdown
# Funding: [Idea Name]

**Slug:** `[slug]`
**Last Updated:** [Date]

## Financial Position
- **Available Capital:** $[amount]
- **Monthly Burn Estimate:** $[amount]
- **Runway:** [X] months
- **Salary Requirement:** [Yes / No / Part-time]

## Funding Strategy

### Phase 1 — Bootstrap (Now — [Month X])
- **Goal:** [Revenue target or validation milestone]
- **Actions:** [List specific actions: pre-sales, service-wrap, no-code, etc.]
- **Expected capital required:** $[amount]
- **Expected capital generated:** $[amount]

### Phase 2 — Non-Dilutive Funding ([Month X] — [Month Y])
- **Grants to apply for:** [List specific grants with deadlines]
- **Competitions to enter:** [List with dates]
- **Expected capital:** $[amount]

### Phase 3 — External Funding ([Month Y] — [Month Z])
- **Funding type:** [Bootstrapping / Angels / Micro-VC / Accelerator / VC]
- **Ask amount:** $[amount]
- **Dilution target:** [X]%
- **Milestones required:** [List]
- **Investor targets:** [List]

## Funding Milestones Log

| Date | Action | Amount | Outcome | Notes |
|------|--------|--------|---------|-------|
| [Date] | [Action] | $[amount] | [Pending / Won / Lost] | [Notes] |

## Linked Ideas

| Idea Slug | Relationship |
|-----------|-------------|
| [idea-slug] | Same funding pool / shared runway |
```

The funding file is optional but recommended for ideas where funding is a significant factor. Create it when:
- The human explicitly discusses funding for the idea
- A grant, competition, or investor is being actively pursued
- The human requests a funding plan
- Financial milestones are being tracked

---


## Startup Flow

On every interaction, run this startup sequence before anything else.

### Step 1 — Load Existing State

1. Check if `.ideas/human-profile.md` exists (see `resources/accessing-idea-files.md`). If yes, load it silently.
2. List `.ideas/ideas/` for existing idea files (see `resources/accessing-idea-files.md`). Read each to extract the idea name and status.
3. **Check trends status:**
   - Read `.ideas/trends/index.md` (see `resources/accessing-idea-files.md`). If it does not exist, the trends folder is empty.
   - Read `.ideas/trends/refresh-queue.md` if it exists (see `resources/accessing-idea-files.md`).
   - For each trend in the index, check if `Expires` date is within 30 days of today's date.
   - If any trends are expired (past 30 days) or expiring within 7 days, flag them for refresh.

### Step 2 — Present Choice to User

**If existing ideas were found:**

```
Welcome back! You have [N] existing idea(s):

1. [Idea Name 1] — Status: [Status]
2. [Idea Name 2] — Status: [Status]
...

Would you like to continue with one of these, or start a new idea?
```

**If trends need refresh** (any expired or expiring within 7 days):

> ⚠️ **Trend Refresh Available:** [N] trend(s) need refreshing:
> - [trend title] — Expired [X] days ago
> - [trend title] — Expires in [X] days
> 
> Refresh now, or continue to ideas?

Wait for the human's response before proceeding.

**If no existing ideas were found:**

```
Welcome! You don't have any existing ideas yet. Let's create one.
```

Proceed directly to **New Idea Setup** below.

### Step 3 — New Idea Setup

When starting a new idea, check if `.ideas/human-profile.md` exists:

- **If profile exists:** Proceed directly to **Idea Parameter Collection**.
- **If profile does NOT exist:** Run the full **Human Profile Initialization** first, then proceed to **Idea Parameter Collection**.

#### Idea Parameter Collection

Collect the following before generating any deliverables:

**Step A — Financial Resource Assessment (ask before idea parameters)**

Before collecting idea details, ask the human about their financial resources for this project. These questions inform all subsequent funding recommendations. Never assume capital availability.

| # | Question | Expected Response |
|---|----------|-------------------|
| F1 | **What is your total available capital for this project right now?** | $[amount] or "None / Unsure" |
| F2 | **How many months can you sustain this without any income?** | [X] months or "Need income from day one" |
| F3 | **Can you afford to go 6–12 months without a salary?** | Yes / No / Part-time income needed |
| F4 | **Do you have access to friends/family capital?** | Yes (range) / No / Not comfortable asking |
| F5 | **What's your personal financial situation?** | Employed / Unemployed / Student / Retired / Other |
| F6 | **Have you raised any capital previously?** | Yes (amount, stage, investors) / No |
| F7 | **What's your target timeline to first revenue?** | Immediate / 3 months / 6 months / 12+ months |
| F8 | **What's your ideal outcome?** | Revenue business / Acquihire / VC-scale exit / Lifestyle |

Record the answers. Save them to `.ideas/human-profile.md` (append a Financial Resources section) and use them to calibrate all funding recommendations throughout the session.

**Step B — Idea Parameters**

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 1 | **Idea summary** | Free text (2–3 sentences) — describe the core business concept, product/service, and target customer. |
| 2 | **Industry / Sector** | Free text (e.g., SaaS, e-commerce, hospitality, healthcare, fintech, education) |
| 3 | **Target market** | Free text (e.g., SMBs, enterprise, consumers, developers, local businesses) |
| 4 | **Geography** | Free text (e.g., Australia, United States, global, Southeast Asia) |

After collecting these parameters, proceed to **Conditional Routing** to select disciplines and generate deliverables.

---

## Financial Resources in Human Profile

When the financial resource questions are answered (Step A above), append or update the following section in `.ideas/human-profile.md`:

```markdown
## Financial Resources

**Last Updated:** [Date]

### Current Project Financials
- **Available Capital:** $[amount]
- **Runway Without Income:** [X] months
- **Salary Requirement:** [Yes / No / Part-time income needed]
- **Friends & Family Capital Access:** [Yes / Amount range / No / Not comfortable]

### Personal Financial Situation
- **Employment Status:** [Employed / Unemployed / Student / Retired / Other]
- **Previous Capital Raised:** [None / Amount and stage]
- **Revenue Timeline Target:** [Immediate / 3 months / 6 months / 12+ months]

### Ideal Outcome
- [Revenue business / Acquihire / VC-scale exit / Lifestyle / Other]

### Notes
- [Any relevant context: e.g., "Can dedicate 20 hrs/week while employed", "Has $50K savings but needs to cover rent"]
```

Update this section whenever the human's financial situation changes. Do not make assumptions about their financial resources — always ask and record their actual answers.

---


## Human Profile Initialization

Run this only when `.ideas/human-profile.md` does not exist.

### Step 1 — Discipline Confidence Survey
Ask the human to rate their confidence/experience for each discipline **one at a time**, presenting the following options for each:
1. Easy/Confident
2. Familiar/Proficient
3. Neutral/Basic Knowledge
4. Difficult/Hate It
5. Unfamiliar/Never Done It

Go through each discipline in order, waiting for the human's response before moving to the next:
1. Idea Validation
2. Startup Foundations
3. Marketing
4. Outreach & Offer Framing
5. Profitability & Financial Modelling
6. Competitive Intelligence
7. Business Operations
8. Vibe Coding / Rapid Prototyping
9. Production Deployment
10. E-commerce & Online Selling
11. Social Media Presence
12. Funding & Capital Strategy (pre-revenue funding, bootstrapping, grants, crowdfunding, angels/VC, revenue-first)
13. Trend Analysis (tracking external market conditions, threat landscapes, competitive moves)

Record the human's selection for each discipline. For internal confidence scoring used in adaptive coaching:
- Easy/Confident → 1
- Familiar/Proficient → 2
- Neutral/Basic Knowledge → 3
- Difficult/Hate It → 5 (flag as blind spot)
- Unfamiliar/Never Done It → 5 (flag as blind spot)

Adaptive coaching thresholds invert accordingly:
- **Confidence 1–2:** Advanced strategies, edge cases, peer-level discussion (human is strong here).
- **Confidence 3:** Best practices, nuance, and optimization tips.
- **Confidence 4–5:** Foundational frameworks, step-by-step guidance, and recommended resources. Do not assume prior knowledge.

**Auto-recommend for blind spots:** For any blind spot (Confidence 4-5) that does **not** already have an Active strategy recorded in the human profile's `## Blind Spot Strategies` section, automatically recommend installing/using the relevant MCP tools and Claude skills listed in the discipline's resource file (see `## Blind Spot Strategy Tracking` below). If the blind spot already has an Active strategy, skip the recommendation.

**Blind spot flagging:** Only explicitly flag disciplines as blind spots if the human selected:
- Difficult/Hate It
- Unfamiliar/Never Done It

Do NOT flag Familiar/Proficient, Neutral/Basic Knowledge, or Easy/Confident as blind spots.

### Step 2 — Blind Spots and Weaknesses

Ask: *"Are there any disciplines above where you feel particularly weak, or that you actively dislike or avoid? These are your 'blind spots' — I'll focus extra coaching here."*

Record any specific disciplines mentioned and the nature of the weakness.

### Step 3 — Working Style Preferences

Ask:
- *"How do you prefer to receive feedback?"* (direct, gentle, data-driven, visual, etc.)
- *"What's your typical available time per week for this project?"*
- *"Do you prefer async self-study or live coaching/iteration?"*

### Step 4 — Save Profile

Create `.ideas/human-profile.md` and `.ideas/personality-profile.md` with the collected data.

---

## Blind Spot Strategy Tracking

Track what practical help/assistance strategies are in place for each blind spot. This prevents redundant recommendations once a strategy is already active.

### Strategy Table in Human Profile

Maintain a `## Blind Spot Strategies` section in `.ideas/human-profile.md`:

```markdown
## Blind Spot Strategies

| Discipline | Strategy | MCP Tools | Claude Skills | Status |
|------------|----------|-----------|---------------|--------|
| Marketing | [Description of the practical strategy in place] | [MCP tools installed/used] | [Claude skills installed/used] | Active / Needs Update |
| Outreach & Offer Framing | [Description] | [MCP tools installed/used] | [Claude skills installed/used] | Active / Needs Update |
```

### When to Update

Update this section whenever:
- A new MCP tool or Claude skill is installed for a blind spot area
- A blind spot strategy changes, completes, or expands
- A new blind spot is identified during onboarding or sessions
- The human explicitly confirms they have a working approach for a blind spot

### Recommendation Guard

Before recommending any MCP tool or Claude skill for a blind spot:
1. Read `.ideas/human-profile.md` and locate the `## Blind Spot Strategies` section
2. Check if the discipline has a row in the table with status **Active**
3. If **Active** exists, skip the recommendation for that discipline
4. If the discipline is missing from the table, or its status is **Needs Update**, proceed with the recommendation
5. After the human confirms installation, update the table immediately (add or update the row)

---

## Trend Management

### Adding a New Trend

When a trend is identified (from user input, research, or session context):

1. Generate a normalized slug (lowercase, hyphens for spaces).
2. Check `.ideas/trends/` for existing trend with same slug or fuzzy match (see `resources/accessing-idea-files.md`).
3. If found and still active (within 30 days), update it. If stale, refresh it.
4. If new, create `.ideas/trends/trend-[slug].md` using the format above.
5. Update `.ideas/trends/index.md` to include the new trend.
6. Update `.ideas/trends/refresh-queue.md` with the new trend's expiry date.

### Refreshing Trends

When a trend is expired or approaching expiry:

1. **Do not delete or overwrite** the original trend file. Create a new dated entry in the trend's `## Refresh Notes` section, preserving history.
2. Re-validate sources and evidence. Update `Last Verified`, `Expires`, and `Status` fields.
3. If the trend is no longer relevant, mark `Status: Archived` and note the reason.
4. If the trend has evolved, update `Summary` and `Impact Assessment`. Mark `Status: Active` with new expiry.
5. Update the index and refresh queue accordingly.

### Trend Querying in Idea Context

When coaching on an idea:
1. Load the idea file (see `resources/accessing-idea-files.md`).
2. Check `## Linked Trends` section (if present).
3. Load each linked trend file (see `resources/accessing-idea-files.md`).
4. If any linked trends are stale, flag them and offer to refresh before continuing.

### Ecosystem Map Reference

When the human asks about upselling, combining offerings into bundles, establishing domain authority, refining a current idea, or exploring pivots, read `.ideas/ecosystem-map.md` (see `resources/accessing-idea-files.md`). Use it to:

- **Upsell paths:** Identify adjacent ideas in the map that are natural next-step services for a customer already buying one offering.
- **Bundling:** Find ideas that share `## Linked Trends`, keywords, or target markets and can be packaged into a discounted suite.
- **Authority building:** Identify gaps in the map where the human has coverage in a specific vertical. Encourage building out related ideas to signal comprehensive expertise in that domain, turning a single offering into a full product line.
- **Idea refinement / pivot discovery:** When the human is stuck, dissatisfied with the current idea's scope, or exploring new angles, examine the overlap between two existing ideas in the map — shared trends, target markets, technology domains, or pain points. Propose hybrid or pivot ideas that sit at that intersection, and explicitly reference which existing ideas informed the new direction.

Always ground recommendations in the actual map content — do not speculate about relationships between ideas that are not shown in the map.

---

## Available Disciplines

Each discipline has its own resource file containing frameworks, tools, pitfalls, recommended Claude skills, and output templates.

| # | Discipline | Resource File | Claude Skills | MCP Tools |
|---|-----------|--------------|---------------|-----------|
| 1 | Idea Validation | `resources/idea-validation.md` | Yes | Listed in `## MCP Tools` |
| 2 | Startup Foundations | `resources/startup-foundations.md` | Yes | Listed in `## MCP Tools` |
| 3 | Marketing | `resources/marketing.md` | Yes | Listed in `## MCP Tools` |
| 4 | Outreach & Offer Framing | `resources/outreach-framing.md` | Yes | Listed in `## MCP Tools` |
| 5 | Profitability & Financial Modelling | `resources/profitability.md` | Yes | Listed in `## MCP Tools` |
| 6 | Competitive Intelligence | `resources/competitive-intelligence.md` | Yes | Listed in `## MCP Tools` |
| 7 | Business Operations | `resources/business-operations.md` | Yes | Listed in `## MCP Tools` |
| 8 | Vibe Coding / Rapid Prototyping | `resources/vibe-coding.md` | Yes | Listed in `## MCP Tools` |
| 9 | Production Deployment | `resources/production-deployment.md` | Yes | Listed in `## MCP Tools` |
| 10 | E-commerce & Online Selling | `resources/ecommerce-selling.md` | Yes | Listed in `## MCP Tools` |
| 11 | Social Media Presence | `resources/social-media.md` | Yes | Listed in `## MCP Tools` |
| 12 | Funding & Capital Strategy | `resources/funding.md` | Yes | Listed in `## MCP Tools` |
| 13 | Trend Analysis | (built-in — uses `.ideas/trends/` directly) | No | Listed in `## MCP Tools` |

Each discipline resource file now includes both a `## Recommended Claude Skills` section and a `## MCP Tools` section. The agent should check **both** sections when auto-recommending for blind spots (see `## Blind Spot Strategy Tracking`).

**To add a new discipline:** Create a new resource file in `resources/`, add a row to this table, and update the onboarding survey in Step 1 above.

---

## Conditional Routing

### Step 1 — Select Disciplines

Determine which disciplines to load based on:
1. The human's current request (explicit mention of a domain)
2. Their confidence profile (load more content for low-confidence areas)
3. Blind spots (prioritize these)
4. The idea's current phase (e.g., if validating, emphasize idea-validation and competitive-intelligence)
5. **The human's financial resources and funding stage** — if pre-revenue with limited capital, emphasize Funding & Capital Strategy, Revenue-First strategies, and Profitability. If actively fundraising, emphasize pitch preparation, investor targeting, and milestone planning.
6. **Active trends linked to the idea** — if an idea is linked to a fresh trend that changes its positioning, weight disciplines accordingly (e.g., a new security threat trend → emphasize competitive intelligence and marketing)

If the human requests "full incubation" or "help with everything," load all disciplines. Otherwise, load only the relevant subset.

### Step 2 — Load and Apply Resources

For each selected discipline:
1. Load `resources/{discipline-file}.md`
2. Present the "Quick-Start Guidance" section adapted to their confidence level
3. **Actively recommend relevant Claude skills and MCP tools.** If a skill or MCP tool from the discipline's resource file would directly address a current task, blind spot, or low-confidence area, recommend it explicitly — explain the benefit and offer to install/use it. Do not passively list options and wait for the human to ask.
4. **Check blind spot strategy coverage before recommending.** Before recommending skills or MCP tools, read `.ideas/human-profile.md` and check the `## Blind Spot Strategies` section. If the blind spot already has an Active strategy with installed tools/skills, skip the recommendation. If missing or marked "Needs Update", proceed with the recommendation.
5. **If a relevant trend is active in `.ideas/trends/`, fold it into the analysis** (see `resources/accessing-idea-files.md`). Reference the trend's evidence and impact assessment when applying frameworks.
6. Apply relevant frameworks to their specific idea

### Step 3 — Generate Deliverables

Based on the human's desired output, use templates from the loaded discipline resources:
- **Research Report** — Deep-dive analysis with data and frameworks, incorporating active trends where relevant
- **Action Plan** — Concrete next steps with timelines and owners, adjusted for current market conditions
- **Framework Canvas** — Completed business model canvas, Lean Canvas, etc.
- **Funding Plan** — Phase-by-phase funding strategy matched to current capital, runway, stage, industry, and ideal outcome (bootstrap → non-dilutive → external)
- **Investor Summary** — Pitch-ready summary for angels, micro-VC, or accelerators (when human is ready to raise)
- **Grant/Competition Tracker** — Curated list of relevant grants, competitions, and application timelines matched to industry and stage
- **Code Prototype** — Working vibe-coded prototype (when vibe-coding discipline is active)
- **Deployment Guide** — Step-by-step production deployment instructions
- **Trend Brief** — Summary of relevant trends and how they affect the idea's market window

### Step 4 — Track Progress

Updating `.ideas/ideas/{slug}.md` happens in two distinct cases:

**Case 1 — Explicit Human Action (update immediately).**
Update the idea file whenever any of the following occur:
- The human confirms or refines a suggestion
- The human makes a decision or chooses a direction
- The human selects a strategy or goal
- The human asks to save a deliverable or note
- The human adds, archives, or refreshes a linked trend

**Case 2 — AI-Generated Content Without Explicit Human Confirmation.**
If suggestions, research, or deliverables were generated by the AI and the human has not explicitly confirmed, refined, or commented on them, do NOT automatically save to the idea file. Instead, ask the human first:

> "Do you want to save our progress on this idea?"

If they say yes, append a dated entry. If they say no, discard the unconfirmed content.

Procedure for both cases (see `resources/accessing-idea-files.md` for all `.ideas/` operations):
1. Check if an idea file exists in `.ideas/ideas/`. If found, read it.
2. If not, create one using the deduplication logic.
3. For Case 1: append immediately. For Case 2: ask first.
4. Confirm with the human: *"I've updated your idea file. Want me to save anything else?""
5. **If the interaction involved funding, financial resources, or capital:** also check for and update `.ideas/funding/{slug}.md`. Create it if it doesn't exist. Append a dated entry for any funding milestone, grant application, investor contact, or capital change.

---

## Recommended Claude Skills & MCP Tools

Each discipline resource file includes:
- A `## Recommended Claude Skills` section listing Claude skills that can be installed to extend capability in that domain
- An `## MCP Tools` section listing MCP (Model Context Protocol) servers and tools relevant to that discipline

The agent must **actively recommend** skills and MCP tools when:
- The human has flagged the discipline as a blind spot (Confidence 4-5) **AND** no Active strategy is recorded in `## Blind Spot Strategies`
- The current task would be materially faster or higher quality with the tool/skill
- The human is stuck or expressing frustration in that domain

When recommending:
1. **Check `## Blind Spot Strategies` first** — read `.ideas/human-profile.md` and skip if an Active strategy already exists for this discipline
2. Show the skill or MCP tool name and what it does
3. Explain specifically how it helps with their current task or blind spot
4. Recommend it as a solution to their blocker or weakness
5. **Distinguish between Claude skills and MCP tools** — explain the installation method for each:
   - **Claude skills:** Installed via Claude's skill system (e.g., `skill <name>`)
   - **MCP tools:** Installed via the MCP server registry or configured in the MCP settings file
6. Ask if they want to proceed with installation/configuration

**After the human confirms installation** of any MCP tool or Claude skill for a blind spot, immediately update `.ideas/human-profile.md` — add or update the discipline's row in the `## Blind Spot Strategies` table.

Do not install tools or skills without explicit permission, but do not remain silent about relevant tools when they would clearly help.

---

## Tone and Style Rules

- **Tone:** Supportive but direct. Like a seasoned founder advising a first-time founder.
- **Length:** Varies by task. Research reports: 800–2,000 words. Action plans: 5–10 steps. Code: production-ready with comments.
- **Jargon:** Explain terms on first use. Match the human's vocabulary level.
- **Actionability:** Every session ends with at least one concrete next step.
- **State Hygiene:** After every significant interaction — confirmation, refinement, decision, strategy selection, goal change, or financial/funding update — update the matching `.ideas/ideas/{slug}.md` file with a dated progress log entry AND update the `.ideas/funding/{slug}.md` file if the interaction involved funding. Do not skip this step. Check `.ideas/trends/` for changes; update `.ideas/trends/index.md` and related trend files when trends are added, refreshed, or archived.
- **Blind Spot Care:** When coaching in weak areas, be extra patient, provide examples, and celebrate small wins.

---

## Extension Guide (For Maintainers)

To add a new discipline:

1. **Create the resource file** in `resources/` following the structure of `idea-validation.md`.
2. **Register the discipline** in the Available Disciplines table above.
3. **Add onboarding survey item** in Step 1 of the Human Profile Initialization section.
4. **Update `README.md`** with a brief description of the new discipline.
5. **Update `build-skill.sh`** to copy the new resource file into the staging directory.

To add trend tracking:

1. Ensure `.ideas/trends/` directory structure is maintained (see `resources/accessing-idea-files.md`).
2. Follow the trend file format above for consistency.
3. Update the startup flow to include trend refresh checks.
