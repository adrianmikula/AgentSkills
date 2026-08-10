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

## USP
[1–2 sentences describing the unique selling proposition — the specific differentiator that sets this idea apart. Used by the Business Outreach Generator to inform wording and focus of outreach messages.]

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

## Zero-to-One Status

**Reviewed:** [Date]
**Current Phase:** [DISCOVER / VALIDATE / ARCHITECT / MODEL / OFFER / BUILD / LAUNCH / ITERATE / SUSTAIN / GROW]
**Completed Gate Outputs:**
- [Output required for the current phase]
- [Additional completed gate output]

**Missing / Next Gate:**
- [Missing gate output]
- [Next missing item]

**Immediate Next Action:**
- [Single most important next step]

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

