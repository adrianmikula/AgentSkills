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
| 1 | **Offering** | `AI-Era Security Audit Report`, `Jakarta Migration Risk Assessment`, or `AI Codebase Entropy Audit` — determines which resource template to load |
| 2 | **Output format** | `Email`, `LinkedIn`, or `Phone` |
| 3 | **Target country** | Free text (e.g., Australia, United States, United Kingdom) — used for spelling localisation and research |
| 4 | **Target city/region** | Free text (e.g., Adelaide, Manchester, Austin) — used for geo-specific targeting |
| 5 | **Industry sector** | Free text (e.g., hospitality, retail, professional services, manufacturing, tech) — used for relevant examples |
| 6 | **Business size** | `Micro` (1–9 staff), `Small` (10–99 staff), `Medium` (100–199 staff) — affects tone, example selection, and phrasing. If the human is unsure, estimate using the methods below. |

**For Jakarta Migration Risk Assessment, AI Codebase Entropy Audit, and AI-Era Security Audit Report when Output format is "Phone"**, also collect:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 7 | **Company website** | Domain or URL — used to research senior technical staff and assess technology stack suitability |
| 8 | **Contact research** | After receiving the website, research senior technical staff (CTO, Dev Director, Tech Lead, Architect, Founder) on the company website. If insufficient info, search LinkedIn. |

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

---

## Available Offerings

| Offering Name | Resource File | Status | Description |
|---------------|-------------|--------|-------------|
| AI-Era Security Audit Report | `resources/ai-era-security-audit-offer.md` | Active | Free public-facing website audit for small businesses; paid repository-level security analysis for tech/enterprise Java development teams |
| Jakarta Migration Risk Assessment | `resources/jakarta-migration-risk-assessment-offer.md` | Active | Paid consultation for Java EE to Jakarta EE migration risk assessment for tech companies (1-99 staff) |
| AI Codebase Entropy Audit | `resources/ai-codebase-entropy-audit-offer.md` | Active | Paid 2-to-5-day engineering audit surfacing architectural drift, codebase entropy, and AI-assisted development risk in large-scale Java systems (AUD $1,500–$3,000 pilot pricing) |

**To add a new offering:** Create a new resource file in `resources/`, then add a row to this table and add the routing condition in the Conditional Routing section below.

---

## Conditional Routing

After collecting the five onboarding parameters, select the template and resource using the following logic:

### Step 1 — Select Offering Resource

Based on the collected `Offering` parameter:

- If `Offering == "AI-Era Security Audit Report"`, load `resources/ai-era-security-audit-offer.md`
- If `Offering == "Jakarta Migration Risk Assessment"`, load `resources/jakarta-migration-risk-assessment-offer.md`
- If `Offering == "AI Codebase Entropy Audit"`, load `resources/ai-codebase-entropy-audit-offer.md`

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
| `{{CONTACT_NAME}}` | Name of identified senior technical contact (Jakarta and Entropy Audit offerings) |
| `{{CONTACT_ROLE}}` | Job title of the contact (Jakarta and Entropy Audit offerings, for internal reference) |

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
