---
name: City Risk Landscape
description: Generate an interactive AI-era cyber risk landscape map for a target city. Scores industry subcategories by AI attack likelihood and customer data sensitivity using live CVE research, then renders an interactive bubble chart to identify which businesses to prioritise for security outreach.
---

## Overview

This Skill generates an AI-era cyber risk landscape map for a target city. It is used to identify *which* businesses to contact — not to generate outreach for a specific company. After rendering an interactive bubble chart of industry subcategories scored by attack likelihood and data sensitivity, it offers to hand off to the **Business Outreach Generator** skill to produce targeted outreach for selected industries.

---

## When to Trigger

Trigger this Skill automatically when ALL of the following are true:

- The human wants to identify which businesses in a city to contact (not generate outreach for a specific company)
- No specific company name or website has been provided

Do not ask for a company name — generate the landscape map first, then let the human pick targets from it.

This Skill is also triggered automatically by the **Business Outreach Generator** when `Offering == "AI-Era Security Audit Report"` and no specific company has been provided yet.

---

## Step 1 — Collect City Parameters

Before generating the map, confirm two parameters if not already collected:

| # | Parameter | Format |
|---|-----------|--------|
| 1 | **Target city** | e.g. Perth, Brisbane, Adelaide |
| 2 | **Country** | e.g. Australia — used for CVE localisation and breach examples |

---

## Step 2 — Research Current Threat Landscape

Perform the following web searches before generating the chart. **All data must reflect the current month and year — do not use assumptions from training data alone.**

### A. Active CVEs

Search: `WooCommerce WordPress plugin vulnerabilities [current month year] active exploit`

Record for each finding:
- CVE identifier
- Affected plugin name and install count
- Whether exploitation is confirmed in the wild (vs theoretical)
- CVSS score
- Patch status

### B. Industry Attack Patterns

Search: `small business cyberattack [target country] [current year] industry sector`

Record which industry verticals are most frequently targeted in the target country in the current reporting period.

### C. Local Breach Examples

Search: `data breach [target city OR target country] small business [current year]`

Record 2–3 local or near-local examples to use as social proof in follow-up outreach.

---

## Step 3 — Score Each Industry Subcategory

For each Perth SMB subcategory below (extend or adapt for other cities), produce a score from 0–100 on each axis using the research above.

**Default subcategories (Perth / Australian SMB context):**
- Medical & Allied Health
- Legal & Accounting
- E-commerce Retail
- Hospitality & Food
- Real Estate & Property
- Trade & Construction
- Automotive Services
- Education & Tutoring
- Beauty & Wellness
- Financial Planning & Broking

### X-axis — AI Attack Likelihood

Score based on:
- Prevalence of WordPress/WooCommerce in that industry (high = 70+)
- Active CVEs affecting plugins commonly used in that sector (active exploit = +15)
- Known Magecart/skimmer campaigns targeting that sector (confirmed = +10)
- Mythos-class autonomous scan readiness (publicly known = +10)

### Y-axis — Customer Data Sensitivity

Score based on:
- Health or medical data present (yes = 80+)
- Financial account data or stored card-on-file (yes = 65+)
- Personal identifying data volume (name/DOB/address = 50+)
- Regulatory penalty exposure under Australian Privacy Act or equivalent (high = +15)

### Bubble Size — Payment and Data Volume

Relative estimate of transaction value + customer record volume per typical site.

| Ordinal | Radius |
|---------|--------|
| Micro | r = 10 |
| Small | r = 15 |
| Medium | r = 20 |
| Large | r = 25 |

### Colour Tier

| Tier | Condition | Colour |
|------|-----------|--------|
| 🔴 Critical | x ≥ 70 AND y ≥ 70, OR confirmed active exploit targeting that sector | Red |
| 🟠 High | x ≥ 60 OR y ≥ 60 | Amber |
| 🔵 Medium | Everything else | Blue |

---

## Step 4 — Generate the Risk Landscape Chart

Produce an interactive bubble chart visualisation using the scored data.

**Chart requirements:**
- X-axis: AI attack likelihood (0–100)
- Y-axis: Customer data sensitivity (0–100)
- Bubble size: Payment and data volume (relative, per ordinal scale above)
- Bubble colour: Exposure tier (critical = red, high = amber, medium = blue)
- Labels: Short industry name on each bubble
- Tooltips: On hover — show CVEs affecting that sector, active exploit status, and 1-sentence rationale for the score
- Legend: Colour tier key + bubble size key

**Visual style:** Flat design, Claude.ai CSS variables, Chart.js bubble chart.

---

## Step 5 — Present Findings and Offer Next Steps

After rendering the chart, output:

1. **Top 3 priority industries** — one sentence each explaining why they rank highest right now, referencing specific CVEs or active campaigns from the research.

2. **Active threat callout** — if any CVE is confirmed actively exploited in the wild right now, flag it prominently:

   > ⚠️ Active skimmer campaign: [CVE] is being exploited in the wild against [sector] sites as of [month year]. Any unpatched [plugin] installation is currently being targeted.

3. **Mythos readiness note** — brief note on the upcoming public availability of Mythos-class models and what that means for the attack surface of the industries in the top-right quadrant.

4. **Offer to proceed** — ask:

   > Want me to find specific [city] businesses in the top-priority categories and generate phone briefs?

   If the human says yes, hand off to the **Business Outreach Generator** skill with the selected industry and city/country pre-populated.

---

## Refresh Cadence

This chart must be regenerated fresh each time it is requested — never cached or re-used from a previous session. The CVE and breach landscape changes weekly.

Flag the research date at the top of every output: *"Risk landscape as of [date]."*

---

## Related Skills

- **Business Outreach Generator** — after identifying target industries from this chart, use this skill to generate emails, LinkedIn messages, or phone briefs for specific businesses.
- **AI-Era Vulnerability Scanner** — once a specific business is selected, use this skill to scan their public website for AI-era vulnerabilities before the outreach call.
