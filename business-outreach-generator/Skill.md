---
name: Business Outreach Generator
description: Generate targeted security outreach emails, LinkedIn messages, or phone call scripts for small businesses. Uses conditional logic to select the outreach channel, localise content, and inject geo-specific breach examples.
---

## Overview

This Skill generates personalised, friendly-but-urgent security outreach messages for small businesses. It supports multiple outreach offerings and three output channels (Email, LinkedIn, or Phone). All content is localised to the target country and populated with recent, region-specific breach examples.

Before generating any outreach, the Skill collects targeting parameters from the human. It then loads the appropriate offering resource and populates the template with localised examples, spelling, and tone matched to the business size.

---

## User Onboarding (Required Before Generation)

Do not generate any outreach until the following five parameters have been collected. Ask the human for each in order:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 1 | **Offering** | `Auto-Recommend Best Fit (default)`, `AI-Era Security Audit Report`, `Jakarta Migration Risk Assessment`, or `AI Codebase Entropy Audit` — determines which resource template to load. If the human is unsure, default to **Auto-Recommend**. |
| 2 | **Output format** | `Email`, `LinkedIn`, or `Phone` |
| 3 | **Target country** | Free text (e.g., Australia, United States, United Kingdom) — used for spelling localisation and research |
| 4 | **Target city/region** | Free text (e.g., Adelaide, Manchester, Austin) — used for geo-specific targeting |
| 5 | **Industry sector** | Free text (e.g., hospitality, retail, professional services, manufacturing, tech) — used for relevant examples |
| 6 | **Business size** | `Micro` (1–9 staff), `Small` (10–99 staff), `Medium` (100–199 staff) — affects tone, example selection, and phrasing. If the human is unsure, estimate using the methods below. |

**If Offering is "Auto-Recommend Best Fit"**, collect the company website up front (see Auto-Recommendation Engine below) before selecting an offering.

**If Offering is "Jakarta Migration Risk Assessment" and the human does not provide a specific company name or website**, do not ask for one — trigger the **Developer Social Scanning Mode** instead (see below). Output format, country, city, and industry are still collected first to scope the scan.

**If Offering is "AI-Era Security Audit Report" and the human does not provide a specific company name or website**, do not ask for one — trigger the **Website Security Social Scanning Mode** instead (see below). Output format, country, city, and industry are still collected first to scope the scan.

**For ALL offerings when Output format is "Phone"**, also collect:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 7 | **Company website** | Domain or URL — used to research senior technical staff and assess technology stack suitability |
| 8 | **Contact research** | After receiving the website, research senior technical staff (CTO, Dev Director, Tech Lead, Architect, Founder) on the company website. If insufficient info, search LinkedIn. |
| 9 | **Contact phone** | Direct phone number for the identified senior technical contact. Check the website Contact page, team directory, or corporate directory. If unavailable online, ask the human if they have it, or note it as "Not found — dial main line and ask for contact by name." |

### Business Size Estimation (when the human is unsure)

If the human does not know the business size, estimate it using the following hierarchy:

1. **LinkedIn Company Page** — Check the company's LinkedIn page for a "Company size" field. Map as follows:
   - `1–10 employees` or `1–9 employees` → **Micro**
   - `11–50 employees`, `51–200 employees`, or `11–200 employees` → **Small**
   - `201–500 employees`, `501–1000 employees`, `1001–5000 employees`, or `5001–10,000 employees` → **Medium** (if within 100–199 range, use Small)
   - `10,001+ employees` → too large; skip this company for Jakarta Migration

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
3. **Analyse the findings against the decision rules below** and present a concise recommendation with rationale.
4. **Ask the human to confirm the recommended offering** or override it with a different choice.
5. **Then collect Output format** and any remaining parameters.

#### Pre-Screen: Universal Disqualifiers

Before evaluating offering fit, apply the **Universal Lead Disqualifiers** (see section below). If either disqualifier is triggered, skip this company entirely — do not score or recommend an offering for them.

#### Decision Rules

For each offering, evaluate the signals found during research and assign a fit score.

**AI-Era Security Audit Report**
- **Strongly recommend** if the company has a public website, handles customer data, provides digital/online services, or operates in any industry with a web presence.
- **Recommend** if the company is a digital agency, consultancy, e-commerce business, or professional services firm — their own site and client sites are attack surfaces.
- **Discourage** only if there is truly no public website and no digital footprint whatsoever (rare).
- **Rationale:** Automated AI-era attacks target every web-facing business regardless of size.

**Jakarta Migration Risk Assessment**
- **Strongly recommend** if the company is tech-focused, explicitly mentions Java / Jakarta EE / Spring / Enterprise / backend development, and has 10–99 staff.
- **Recommend** if the company is a software development firm with a visible engineering team and no clear stack, but a Java heritage is plausible.
- **Discourage** if any of these signals are present:
  - No evidence of Java in tech stack, case studies, or job postings
  - Primarily frontend, mobile, or low-code/no-code shop
  - Non-tech industry with no software development team
  - Team size is clearly <10 or >200 (outside the sweet spot)
- **Rationale:** This is a highly specialised offering; pitching it to a non-Java shop wastes both sides' time.

**AI Codebase Entropy Audit**
- **Strongly recommend** if the company is tech-focused, mentions large-scale Java systems, enterprise architecture, microservices, or legacy modernisation, and has 50+ developers.
- **Recommend** if the company builds complex custom software and has 20+ technical staff, even if the exact stack isn't visible.
- **Discourage** if any of these signals are present:
  - No evidence of large or complex codebases
  - Primarily uses low-code/no-code platforms, CMS-only builds, or simple brochure sites
  - Team size is clearly <20 (unlikely to have the codebase complexity this audit targets)
  - No backend development or API engineering mentioned
- **Rationale:** This is a deep, paid engineering audit. It requires substantial codebase complexity and a technical team large enough to act on the findings.

#### Presenting the Recommendation

Present the result in this exact format:

```
**Recommended Offering:** [Offering Name]
**Confidence:** [High / Medium / Low]
**Rationale:** [1–2 sentences explaining the key signals]
**Discouraged:** [List any offerings that are a poor fit and why, or "None"]
```

Then ask: *"Does this look right, or would you prefer a different offering?"*

If the human overrides, proceed with their manual choice. If they confirm, proceed with the recommended offering.

---

## Website Security Social Scanning Mode

When `Offering == "AI-Era Security Audit Report"` **and no specific company name or website has been provided**, and the human has not been routed to City Risk Landscape Mode, trigger Website Security Social Scanning Mode using the two resources below in combination:

- `resources/developer-social-scanning.md` — shared scanning framework (platform strategy, geo-filtering, scoring, output format, handoff)
- `resources/ai-era-security-audit-offer.md` — **Developer Social Scanning — Offering-Specific Signals** section (query variants, signal taxonomy, disqualifiers, opening line examples)

That mode will:
1. Confirm the target country, city/region, and industry sector (if not already collected)
2. Scan BuiltWith for WordPress, Joomla, and Drupal sites in the target city, filtering for vulnerable plugin combinations and neglected-maintenance signals
3. Cross-reference with local business directories to surface contact names and business details
4. Score and rank each discovered lead by signal strength against the AI-Era Security Audit free-tier criteria
5. Present a prioritised shortlist of candidate businesses with the source evidence, matched signals, and a suggested outreach angle
6. Offer to generate a targeted outreach message (Email, LinkedIn, or Phone brief) for any selected candidate, pre-populating all known parameters from the scan findings

Once the human selects a candidate from the shortlist, return to this skill with `Offering`, `City`, `Country`, `Industry`, `Business Size`, `Company Name`, and `Contact Name` pre-populated where discoverable, and continue from **Step 2 — Select Output Template**.

> **References:** `resources/developer-social-scanning.md` — shared framework | `resources/ai-era-security-audit-offer.md` — offering-specific signals

---

## City Risk Landscape Mode

When `Offering == "AI-Era Security Audit Report"` (or auto-recommended to it) **and no specific company name or website has been provided**, **and the human is asking for a city-level risk overview, risk chart, or industry landscape** (rather than a direct lead shortlist), trigger the **City Risk Landscape** skill automatically.

> **Mode disambiguation:** If the human's intent is to get a shortlist of specific businesses to contact, use **Website Security Social Scanning Mode** above. If the human's intent is to understand which industries in a city are highest-risk (e.g. "what does the risk landscape look like in Perth?"), use **City Risk Landscape Mode**. When intent is ambiguous, ask: *"Would you like a list of specific businesses to contact, or a city-level risk overview chart first?"*

That skill will:
1. Confirm the target city and country
2. Research active CVEs and local breach examples for the current month
3. Score Perth (or target-city) SMB industry subcategories by AI attack likelihood and customer data sensitivity
4. Render an interactive bubble chart of the risk landscape
5. Offer to hand back here to generate phone briefs for specific businesses in the top-priority categories

Once the human has selected a target industry from the landscape map, return to this skill with `Offering`, `City`, `Country`, and `Industry` pre-populated and continue from **Step 2 — Select Output Template**.

> **Reference:** `city-risk-landscape` skill — `Skill.md`

---

## Developer Social Scanning Mode

When `Offering == "Jakarta Migration Risk Assessment"` **and no specific company name or website has been provided**, do not ask for a company name. Instead, trigger Developer Social Scanning Mode using the two resources below in combination:

- `resources/developer-social-scanning.md` — shared scanning framework (platform strategy, geo-filtering, scoring, output format, handoff)
- `resources/jakarta-migration-risk-assessment-offer.md` — **Developer Social Scanning — Offering-Specific Signals** section (query variants, signal taxonomy, disqualifiers, opening line examples)

That mode will:
1. Confirm the target country, city/region, and industry sector (if not already collected)
2. Scan developer social, Q&A, and forum platforms (Stack Overflow, GitHub, Reddit, LinkedIn, Hacker News, Dev.to, and similar) for public posts or comments that signal active Jakarta EE migration pain, legacy Java EE maintenance burden, or related technical blockers
3. Score and rank each discovered lead by signal strength against the Jakarta Migration Risk Assessment offering criteria
4. Present a prioritised shortlist of candidate companies or individuals with the source post/comment, the matched signals, and a suggested outreach angle
5. Offer to generate a targeted outreach message (Email, LinkedIn, or Phone brief) for any selected candidate, pre-populating all known parameters from the scan findings

Once the human selects a candidate from the shortlist, return to this skill with `Offering`, `City`, `Country`, `Industry`, `Business Size`, `Company Name`, and `Contact Name` pre-populated where discoverable, and continue from **Step 2 — Select Output Template**.

> **References:** `resources/developer-social-scanning.md` — shared framework | `resources/jakarta-migration-risk-assessment-offer.md` — offering-specific signals

---

## Available Offerings

| Offering Name | Resource File | Status | Description |
|---------------|-------------|--------|-------------|
| AI-Era Security Audit Report | `resources/ai-era-security-audit-offer.md` | Active | Free public-facing website audit for small businesses; paid repository-level security analysis for tech/enterprise Java development teams. Supports Website Security Social Scanning Mode (BuiltWith-first) when no company is provided. |
| Jakarta Migration Risk Assessment | `resources/jakarta-migration-risk-assessment-offer.md` | Active | Paid consultation for Java EE to Jakarta EE migration risk assessment for tech companies (1-99 staff) |
| AI Codebase Entropy Audit | `resources/ai-codebase-entropy-audit-offer.md` | Active | Paid 2-to-5-day engineering audit surfacing architectural drift, codebase entropy, and AI-assisted development risk in large-scale Java systems (AUD $1,500–$3,000 pilot pricing) |
| Agency Security Pipeline | `resources/agency-security-pipeline-offer.md` | Active | Managed white-label CI/CD security pipeline for web agencies: sandboxed staging, automated smoke tests, instant production rollback, and a client-facing security score dashboard. Pilot entry at AUD $3,000–$5,000 for 3 sites; ongoing SaaS licence from AUD $600–$1,500/month based on portfolio size. Target: agency owners managing 10+ client sites on WordPress/Winter CMS/October CMS or similar plugin-based stacks. |

**To add a new offering:** Create a new resource file in `resources/`, then add a row to this table and add the routing condition in the Conditional Routing section below.

---

## Universal Lead Disqualifiers

**Apply these checks before generating any outreach**, regardless of offering, output format, or how the lead was sourced (manual entry, scanning, or auto-recommend). Conditions 2 and 3 are hard skips. Condition 1 (web agency) has a two-path flow that may convert the lead rather than skip it — follow its instructions carefully.

### 1 — Business Already Has a Web Agency (Recent)

When there is credible, recent evidence that the business is currently engaged with a web agency or managed-web-services provider ("recent" means within the last 12 months), **do not immediately skip**. Instead, follow the two-path flow below.

**Signals to check:**
- Website footer or "Built by" credit linking to an active, external agency
- Recent (≤12 months) blog post, press release, or social media announcement naming a web or digital agency as their partner or builder
- LinkedIn posts from agency staff crediting this business as a current client
- "Agency" or "web partner" listed in their technology or vendor section

**Recency caveat:** If the agency credit appears older than 12 months with no further evidence the relationship is ongoing (e.g. no recent updates to the site, no recent social mentions), **do not disqualify** — the relationship may have lapsed. Note the uncertainty to the human and let them decide.

#### Two-Path Flow When an Agency Is Confirmed

**Step 1 — Identify the agency's website.** Extract the agency name and URL from the "Built by" credit, footer link, or social mention.

**Step 2 — Offer to scan the agency's site.** Ask the human:

> *"[Company Name] appears to currently work with [Agency Name] ([agency URL]). Before skipping, would you like me to run a quick security scan of the agency's own website? If their web agency has security problems on their own site, that's a very compelling cold-call angle — you can show the client that their current provider isn't practising what they preach."*

**Step 3a — If the human says yes:** Trigger a **Prod Mode scan** of the agency's website using the **AI-Era Vulnerability Scanner** skill (`ai-era-vulnerability-scanner/Skill.md`). Run the full P1–P7 passive checklist against the agency's URL. Once complete, present the findings summary to the human.

- If **significant findings exist** (any 🔴 Critical or 🟠 High rated issue): **do not skip this lead**. Instead, continue to outreach generation and inject the agency scan results as the primary cold-call angle (see **Agency Scan Angle** below).
- If **no significant findings** (only 🟡 Medium or clean): inform the human — *"[Agency Name]'s site looks reasonably well-secured. This lead may be a harder pitch — their agency appears competent. Skip, or continue anyway?"* — and follow their decision.

**Step 3b — If the human says no:** Apply the original skip behaviour — *"Skipping [Company Name] — they may already have this covered. Move to the next candidate?"*

#### Agency Scan Angle (when significant findings exist)

When outreach is generated for a lead where the agency scan revealed findings, adjust the message to lead with the agency credibility gap rather than the standard offering pitch. Inject the following into the outreach:

- **Phone brief:** Add an "Agency Scan Summary" section listing the top 2–3 findings from the agency's own site, framed as: *"Their current web agency ([Agency Name]) has [finding] on their own website — which raises a question about the security posture of the sites they build for clients."*
- **Email/LinkedIn:** Open with a personalised observation referencing the agency's site weakness before pivoting to the offering. Example framing: *"I noticed your website was built by [Agency Name] — I had a quick look at their own site and spotted [finding]. If that's the standard they apply to their own infrastructure, it's worth checking what's underneath yours."*
- **Tone:** Keep this factual and non-aggressive. The goal is to raise a legitimate question, not to trash a competitor. Stick to observable, verifiable findings only.

### 2 — Business Requires Security Clearance or a Site Pass

Skip the business if there is any indication that in-person or contracted work requires a security clearance, government security pass, working-with-children check, police clearance, or site induction/pass that would restrict the ability to deliver the service.

**Signals to check:**
- Business operates in defence, government, intelligence, critical infrastructure, or classified research
- Job postings or RFPs explicitly require NV1/NV2, Baseline, Top Secret, SC, DV, or equivalent clearances
- Site access requirements listed on their website (e.g. "all contractors must hold a current security pass")
- Industry category is defence contracting, classified government services, or similar
- Business is located on a restricted military, government, or critical-infrastructure site

**If disqualified:** State *"[Company Name] appears to require security clearance or a site pass for contractors. Skipping — this engagement may not be viable without clearance. Move to the next candidate?"*

### 3 — Business Is Not Located in the Target City/Region

Skip the business if it is clearly based outside the target city or region provided in `{{CITY}}`. The goal is locally-relevant outreach — a poor geo match weakens the pitch and wastes effort.

**How to verify location:**
- Check the business website's Contact page, footer address, or Google Maps listing
- Check LinkedIn Company Page location field
- Check ABN Lookup, Companies House, or the relevant national business registry for a registered address

**Matching rules:**
- **Exact match or adjacent suburb** — proceed without comment
- **Same metro area / greater region** — proceed; note the suburb or district in the outreach if it adds local colour (e.g. "I noticed your office is in [suburb], just outside the CBD…")
- **Different city, same state/county** — flag to the human: *"[Company Name] appears to be based in [actual city], not [target city]. Still want to proceed?"* Only continue if the human confirms.
- **Different state, country, or clearly national/remote** — skip. State *"[Company Name] doesn't appear to be based in {{CITY}}. Skipping. Move to the next candidate?"*

**Exception — scanning mode:** When operating in Developer or Website Security Social Scanning Mode, geo-verification is applied as part of Step 4 (Geo-Filtering) in `resources/developer-social-scanning.md`. Leads flagged as "Geo-unverified" should still have location confirmed before outreach is generated.

---

## Conditional Routing

After collecting the five onboarding parameters, select the template and resource using the following logic:

### Step 1 — Select Offering Resource

Based on the collected `Offering` parameter:

- If `Offering == "Auto-Recommend Best Fit"`, follow the Auto-Recommendation Engine instructions above first. Once the human confirms the final offering, load the corresponding resource below.
- If `Offering == "AI-Era Security Audit Report"` **and no company name or website has been provided**, trigger the **Website Security Social Scanning Mode** (see section above) using `resources/developer-social-scanning.md` and the offering-specific signals in `resources/ai-era-security-audit-offer.md`. Do not proceed to Step 2 until the human has selected a candidate from the scan results and confirmed they want to generate outreach for that candidate.
- If `Offering == "AI-Era Security Audit Report"` **and a company name or website has been provided**, load `resources/ai-era-security-audit-offer.md` and proceed normally.
- If `Offering == "Jakarta Migration Risk Assessment"` **and no company name or website has been provided**, trigger the **Developer Social Scanning Mode** (see section above) using `resources/developer-social-scanning.md` and the offering-specific signals in `resources/jakarta-migration-risk-assessment-offer.md`. Do not proceed to Step 2 until the human has selected a candidate from the scan results and confirmed they want to generate outreach for that candidate.
- If `Offering == "Jakarta Migration Risk Assessment"` **and a company name or website has been provided**, load `resources/jakarta-migration-risk-assessment-offer.md` and proceed normally.
- If `Offering == "AI Codebase Entropy Audit"`, load `resources/ai-codebase-entropy-audit-offer.md`
- If `Offering == "Agency Security Pipeline"` **and no company name or website has been provided**, prompt the human: *"Which web agency would you like to target? Provide a name, URL, or city and I'll identify candidates."* Once a target agency is confirmed, run a passive scan of the agency's own site and 2–3 of their portfolio client sites using the AI-Era Vulnerability Scanner skill (Prod Mode). Use the findings to populate the scan-specific placeholders in the template, then load `resources/agency-security-pipeline-offer.md` and proceed.
- If `Offering == "Agency Security Pipeline"` **and a company name or website has been provided**, run the passive scan as above, then load `resources/agency-security-pipeline-offer.md` and proceed normally.

Follow the research instructions in the loaded resource file. Note that Jakarta Migration and AI Codebase Entropy Audit outreach do NOT require breach research; instead, they require identifying senior technical staff on the company website (with LinkedIn as fallback).

### Step 2 — Select Output Template

Within the loaded resource, apply the output-format-specific template:

- If `Output format == "Email"`, use the **Email Template** section.
- If `Output format == "LinkedIn"`, use the **LinkedIn Message Template** section.
- If `Output format == "Phone"`, use the **Phone Call Template** section.

### Step 3 — Populate Placeholders

Replace all placeholder tokens in the selected template with the collected parameters:

| Placeholder | Value |
|-------------|-------|
| `{{COUNTRY}}` | Target country |
| `{{CITY}}` | Target city/region |
| `{{INDUSTRY}}` | Industry sector |
| `{{BUSINESS_SIZE}}` | Business size |
| `{{COMPANY_NAME}}` | Company name (Jakarta and Entropy Audit offerings) |
| `{{CONTACT_NAME}}` | Name of identified senior technical contact (Phone output format) |
| `{{CONTACT_ROLE}}` | Job title of the contact (Phone output format, for internal reference) |
| `{{CONTACT_PHONE}}` | Direct phone number of the contact, or main company line with instructions to reach them (Phone output format) |

### Step 4 — Localise and Research

Follow the instructions in the loaded resource file to:

1. Adjust spelling and phrasing to match the target country’s English variant (e.g., Australian English: "programme", "localise"; US English: "program", "localize").
2. Research 2–3 recent (2025–2026) breaches in `{{COUNTRY}}`, preferring victims in or near `{{CITY}}` and operating in `{{INDUSTRY}}` or an adjacent sector.
3. Prefer **obscure, non-high-profile victims** — family-owned businesses, regional franchises, niche suppliers, small hospitality groups, local manufacturers. Avoid multinational corporations or well-known brands unless no local examples exist.
4. For each example, verify the source is reputable (news outlet, cyber-security reporting site, government advisory) and include a link.

---

## Tone and Style Rules

- **Tone:** Friendly, direct, slightly urgent but never fear-mongering. The sender is a knowledgeable peer offering help, not a vendor pushing a sale.
- **Length:** Email should be 200–350 words. LinkedIn message should be 100–180 words (shorter, punchier).
- **Jargon:** Avoid unnecessary technical terms. If a term is needed (e.g., "ransomware", "vulnerability"), briefly define it in plain language or use context to make the meaning clear.
- **CTA:** One clear, low-friction action. No multiple links, no calendars, no "book a call" pressure.
- **No-sales guarantee:** Explicitly mention the audit is free, no-obligation, and comes with no follow-up spam.

---

## Output Format Selection

When presenting the final message to the human:

| Channel | Presentation |
|---------|-------------|
| **Email** | Show the full email with Subject line, body, and placeholder sign-off block. Offer to adjust any section. |
| **LinkedIn** | Show the message as a single block of text optimised for LinkedIn’s character limits and conversational style. Offer to adjust tone or length. |
| **Phone** | Show a dot-point research brief covering: company overview, industry focus, products/services, tech stack, suggested offering focus, and 1–2 leading questions. No scripted conversation snippets. |

---

## Extension Guide (For Maintainers)

To add a new outreach offering:

1. **Create the resource file** in `resources/` following the structure of `ai-era-security-audit-offer.md`.
2. **Register the offering** in the Available Offerings table above.
3. **Add routing logic** in Step 1 of the Conditional Routing section.
4. **Update `README.md`** with a brief description of the new offering.

4. Update `build-skill.sh` to copy the new resource file into the staging directory.
