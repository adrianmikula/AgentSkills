---
name: Business Outreach Generator
description: Generate targeted security outreach emails or LinkedIn messages for small businesses. Uses conditional logic to select the outreach channel, localise content, and inject geo-specific breach examples.
---

## Overview

This Skill generates personalised, friendly-but-urgent security outreach messages for small businesses. It supports multiple outreach offerings and two output channels (Email or LinkedIn). All content is localised to the target country and populated with recent, region-specific breach examples.

Before generating any outreach, the Skill collects targeting parameters from the human. It then loads the appropriate offering resource and populates the template with localised examples, spelling, and tone matched to the business size.

---

## User Onboarding (Required Before Generation)

Do not generate any outreach until the following five parameters have been collected. Ask the human for each in order:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 1 | **Offering** | `AI-Era Security Audit Report` or `Jakarta Migration Risk Assessment` — determines which resource template to load |
| 2 | **Output format** | `Email` or `LinkedIn` |
| 3 | **Target country** | Free text (e.g., Australia, United States, United Kingdom) — used for spelling localisation and research |
| 4 | **Target city/region** | Free text (e.g., Adelaide, Manchester, Austin) — used for geo-specific targeting |
| 5 | **Industry sector** | Free text (e.g., hospitality, retail, professional services, manufacturing, tech) — used for relevant examples |
| 6 | **Business size** | `Micro` (1–9 staff), `Small` (10–99 staff), `Medium` (100–199 staff) — affects tone, example selection, and phrasing |

**For Jakarta Migration Risk Assessment only**, also collect:

| # | Parameter | Options / Format |
|---|-----------|------------------|
| 7 | **Company website** | Domain or URL — used to research senior technical staff and assess Java EE suitability |
| 8 | **Contact research** | After receiving the website, research senior technical staff (CTO, Dev Director, Tech Lead, Architect, Founder) on the company website. If insufficient info, search LinkedIn. |

Record all answers. If the human is unsure about any field, suggest common values for their country but do not assume defaults.

---

## Available Offerings

| Offering Name | Resource File | Status | Description |
|---------------|-------------|--------|-------------|
| AI-Era Security Audit Report | `resources/ai-era-security-audit-offer.md` | Active | Free, no-obligation security audit report for small businesses |
| Jakarta Migration Risk Assessment | `resources/jakarta-migration-risk-assessment-offer.md` | Active | Paid consultation for Java EE to Jakarta EE migration risk assessment for tech companies (1-99 staff) |

**To add a new offering:** Create a new resource file in `resources/`, then add a row to this table and add the routing condition in the Conditional Routing section below.

---

## Conditional Routing

After collecting the five onboarding parameters, select the template and resource using the following logic:

### Step 1 — Select Offering Resource

Based on the collected `Offering` parameter:

- If `Offering == "AI-Era Security Audit Report"`, load `resources/ai-era-security-audit-offer.md`
- If `Offering == "Jakarta Migration Risk Assessment"`, load `resources/jakarta-migration-risk-assessment-offer.md`

Follow the research instructions in the loaded resource file. Note that Jakarta Migration outreach does NOT require breach research; instead, it requires identifying senior technical staff on the company website (with LinkedIn as fallback).

### Step 2 — Select Output Template

Within the loaded resource, apply the output-format-specific template:

- If `Output format == "Email"`, use the **Email Template** section.
- If `Output format == "LinkedIn"`, use the **LinkedIn Message Template** section.

### Step 3 — Populate Placeholders

Replace all placeholder tokens in the selected template with the collected parameters:

| Placeholder | Value |
|-------------|-------|
| `{{COUNTRY}}` | Target country |
| `{{CITY}}` | Target city/region |
| `{{INDUSTRY}}` | Industry sector |
| `{{BUSINESS_SIZE}}` | Business size |
| `{{COMPANY_NAME}}` | Company name (Jakarta offering only) |
| `{{CONTACT_NAME}}` | Name of identified senior technical contact (Jakarta offering only) |
| `{{CONTACT_ROLE}}` | Job title of the contact (Jakarta offering only, for internal reference) |

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

---

## Extension Guide (For Maintainers)

To add a new outreach offering:

1. **Create the resource file** in `resources/` following the structure of `ai-era-security-audit-offer.md`.
2. **Register the offering** in the Available Offerings table above.
3. **Add routing logic** in Step 1 of the Conditional Routing section.
4. **Update `README.md`** with a brief description of the new offering.

No changes to `build-skill.sh` are needed if the new resource file is placed in `resources/`.
