# Developer Social Scanning — Shared Resource

This resource is loaded by `Skill.md` when Developer Social Scanning Mode is triggered. It defines the platform search strategy, signal taxonomy, scoring rules, and output format used to discover inbound leads from developer social and forum platforms. It is offering-agnostic; offering-specific signal definitions are passed in by the calling resource file.

---

## When This Resource Is Used

This resource is invoked when ALL of the following are true:

- An offering has been selected that supports social scanning (see the offering's resource file for the trigger condition)
- The human has **not** provided a specific company name or website

It replaces the standard company-research flow with a proactive scan of developer platforms to discover leads that have already publicly signalled pain matching the selected offering.

---

## Step 1 — Confirm Scan Parameters

Before scanning, confirm the following parameters if not already collected:

| # | Parameter | Format |
|---|-----------|--------|
| 1 | **Target country** | e.g. Australia, United States — used to geo-filter results where possible |
| 2 | **Target city/region** | Optional but preferred — e.g. Perth, Manchester — tightens geo-relevance |
| 3 | **Industry sector** | Optional — focuses the scan on verticals more likely to exhibit the target pain |

If city or industry are not provided, proceed with country-level scope and note this in the output.

Load the **offering-specific signal definitions** from the calling resource file before beginning Step 2. These define:
- The search query variants to use on each platform
- The Tier 1 / Tier 2 / Tier 3 signal taxonomy for this offering
- The disqualifying signals for this offering
- The scan-sourced opening line examples for outreach handoff

---

## Step 2 — Target Platforms and Search Strategy

Scan the following platforms in priority order. Use web search (`site:` operators and targeted queries) for each. Substitute the offering-specific query variants provided by the calling resource file where indicated.

> **Priority override:** If the calling offering resource defines a custom platform priority order in its "Platform Query Variants" section, **follow that order instead of the default order below.** Some offerings (e.g. Jakarta Migration) front-load job boards and direct company research before social platforms because those sources yield more geo-specific leads with less noise.

#### Priority 1 — Stack Overflow

Use offering-specific query variants. Generic pattern:
- `site:stackoverflow.com [offering-specific keywords] [current year]`
- `site:stackoverflow.com [offering-specific keywords] migration [current year]`

Look for:
- Questions asked by developers actively blocked on a problem relevant to the offering
- Answers from developers describing their company's situation
- Comments mentioning company names, team sizes, or specific technical blockers
- Questions with no accepted answer (indicates unresolved, active pain)

#### Priority 2 — GitHub

Use offering-specific query variants. Generic pattern:
- `site:github.com [offering-specific keywords] issues OR discussions [current year]`
- GitHub Issues search: `[offering-specific label or keyword]` in public repos
- GitHub Discussions search: `[offering-specific keywords]`

Look for:
- Open issues in company or project repositories describing a relevant blocker
- Discussion threads where maintainers mention their team is stuck or planning relevant work
- Pull requests with offering-relevant terms that are stale or have unresolved review comments
- `README.md` or `CHANGELOG.md` snippets referencing the target problem as a known issue

#### Priority 3 — LinkedIn

Use offering-specific query variants. Generic pattern:
- `site:linkedin.com [offering-specific keywords] [current year]`
- LinkedIn People search: `[offering-specific role/topic]` filtered by `{{COUNTRY}}` and company size 10–99

Look for:
- Posts or articles from developers or CTOs describing their company's situation or blockers
- Profile "About" sections or experience entries mentioning relevant work
- Comments on relevant ecosystem posts where users describe their own company's situation
- Job postings by companies seeking staff with offering-relevant skills (strong signal of active intent)

**Rate limiting:** Apply the same LinkedIn rules defined in `Skill.md` — maximum 3 LinkedIn page requests per minute, 20-second wait between loads, no re-querying the same page within a session.

#### Priority 4 — Reddit

Use offering-specific query variants. Generic pattern:
- `site:reddit.com/r/[relevant subreddit] [offering-specific keywords] [current year]`
- `site:reddit.com [offering-specific keywords] "still on" OR "haven't migrated" OR "stuck on"`

Look for:
- Threads where developers describe their company's situation or blockers
- Posts asking for help with specific problems the offering addresses (active pain signal)
- Comments mentioning company size, team, or industry context

#### Priority 5 — Hacker News

Use offering-specific query variants. Generic pattern:
- `site:news.ycombinator.com [offering-specific keywords]`

Look for:
- Show HN posts from developers building adjacent tooling (partner or competitor signal)
- Comment threads where people describe their company's situation
- Ask HN threads requesting advice on the problem the offering addresses

#### Priority 6 — Dev.to and similar

Use offering-specific query variants. Generic pattern:
- `site:dev.to [offering-specific keywords] [current year]`
- `site:medium.com [offering-specific keywords]`
- `site:dzone.com [offering-specific keywords] "small team" OR "legacy"`

Look for:
- Blog posts authored by developers working in companies that haven't solved the target problem yet
- Articles describing specific blockers that map to the offering's value proposition

---

## Step 3 — Apply Offering-Specific Signal Taxonomy

The calling resource file defines three tiers of signals for the selected offering:

- **Tier 1 — High-Confidence (score +3 each)**
- **Tier 2 — Medium-Confidence (score +2 each)**
- **Tier 3 — Weak/Contextual (score +1 each)**
- **Disqualifying signals — exclude the lead entirely**

For each post, comment, issue, or profile found, assess it against the tiers defined in the calling resource file and assign a score.

---

## Step 4 — Geo-Filtering

Apply geo-filtering where possible to surface candidates in the target city/country:

1. **LinkedIn** — filter search by country and proximity when the LinkedIn search interface permits it
2. **Stack Overflow / GitHub** — look for location fields in user profiles; where no location is listed, note as "Location unknown — verify before outreach"
3. **Reddit / Dev.to / HN** — user location is often not available; flag these as "Geo-unverified" in the shortlist
4. **Job postings** — use the job posting location as the company geo-signal

If the scan returns no geo-verified results for the target city, broaden to country-level and note the expansion in the output.

---

## Step 5 — Score, Deduplicate, and Rank

After collecting raw findings:

1. **Deduplicate** — if the same company or individual appears across multiple platforms, merge into a single lead record and aggregate all signals
2. **Score each lead** — sum the signal tier scores from the offering-specific taxonomy (Step 3)
3. **Sort descending by score**
4. **Cap the shortlist at 10 leads** — present only the top 10 by score; note the total number of raw signals found

Minimum score threshold for inclusion: **3 points** (at least one Tier 1 signal or a combination of Tier 2/3 signals). Discard leads below this threshold.

---

## Step 6 — Shortlist Output Format

Present the results as a ranked shortlist using this exact structure:

```
**Developer Social Scan Results — [Offering Name]**
**Scan scope:** {{COUNTRY}} / {{CITY}} (if specified) / {{INDUSTRY}} (if specified)
**Platforms searched:** [list of platforms actually queried]
**Scan date:** [today's date]
**Total raw signals found:** [n] | **Leads in shortlist:** [n, max 10]

---

**#1 — [Company Name or "Individual: [Username/Handle]"] | Score: [n]**
- **Platform:** [Stack Overflow / GitHub / LinkedIn / Reddit / etc.]
- **Source:** [Direct URL to the post, issue, comment, or profile]
- **Signal summary:** [1–2 sentences describing the specific signals — what they said or showed that indicates a strong match with the offering]
- **Matched signals:** [Tier 1: list] / [Tier 2: list] / [Tier 3: list]
- **Contact clue:** [Name, role, or handle if identifiable; "Identity unverified — research required" if not]
- **Company clue:** [Company name if mentioned; "Company unknown — research required" if not]
- **Geo status:** [Verified: [city, country]] / [Geo-unverified] / [Location unknown]
- **Suggested outreach angle:** [1 sentence — what specifically to reference from their post/comment to make the outreach feel personal and relevant]

---

[Repeat for #2–#10]

---

**Next step:** Select a candidate by number to generate a targeted outreach message, or type "all" to generate briefs for all shortlisted leads.
```

If no candidates meet the minimum score threshold, output:

```
**No qualifying leads found in this scan.**
Platforms searched: [list]
Scan scope: [parameters]

Suggestions:
- Broaden the industry sector filter (or remove it)
- Expand from city-level to country-level scope
- Extend the date range search to include posts from the past 24 months
- Try again with "all" as the industry to maximise coverage
```

---

## Step 7 — Handoff to Outreach Generation

When the human selects one or more candidates from the shortlist:

1. **Pre-populate known parameters** from the scan findings:
   - `{{COMPANY_NAME}}` — from the company clue field (or mark as requiring research)
   - `{{CONTACT_NAME}}` — from the contact clue field (or mark as requiring research)
   - `{{CONTACT_ROLE}}` — inferred from platform profile or post context
   - `{{CITY}}`, `{{COUNTRY}}`, `{{INDUSTRY}}` — from scan scope parameters
   - `{{BUSINESS_SIZE}}` — estimate using the Business Size Estimation hierarchy in `Skill.md` if company is identified; otherwise mark as "Estimate required"

2. **If any required fields are still missing** (especially `{{COMPANY_NAME}}` and `{{CONTACT_NAME}}`), perform targeted research:
   - Search the company website and LinkedIn profile to fill gaps
   - Apply the same rate-limiting rules from `Skill.md`

3. **Return to the standard outreach flow** in `Skill.md` at **Step 2 — Select Output Template**, with all discovered parameters pre-populated.

4. **Include a scan-sourced opening line** in the generated message that references the specific post, comment, or issue that triggered the lead. Use the opening line examples defined in the calling resource file for this offering.

---

## Rate Limiting

Apply these constraints during the scan:

- **LinkedIn:** Maximum 3 page requests per minute; 20-second wait between loads; no re-querying the same page within a session (same rules as `Skill.md`)
- **Stack Overflow / GitHub / Reddit:** No explicit rate limit, but do not make more than 10 search queries per platform per session to avoid triggering bot detection
- **If a platform returns a 403, CAPTCHA, or access block:** Move to the next platform in priority order; do not retry the blocked platform in the same session
- **Do not scrape user-private data** — only use publicly visible posts, comments, issues, profiles, and job listings

---

## Extension Guide (Adding Social Scanning to a New Offering)

To add Developer Social Scanning support to a new or existing offering resource file:

1. **Add an "Offering-Specific Social Scanning Signals" section** to the offering's resource file containing:
   - Platform search query variants tailored to the offering's topic and keywords
   - Tier 1 / Tier 2 / Tier 3 signal definitions
   - Disqualifying signals
   - 2–3 example scan-sourced opening lines for outreach messages

2. **Register the trigger condition** in `Skill.md` under the Conditional Routing section:
   - Add a branch for `Offering == "[Offering Name]"` and `no company provided` that triggers Developer Social Scanning Mode, referencing this file and the offering-specific signal section.

3. **Update the Developer Social Scanning Mode section** in `Skill.md` to list the new offering as supported.
