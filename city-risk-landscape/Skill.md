---
name: City Risk Landscape
description: Generate interactive AI-era cyber risk charts for a target city. Landscape mode scores industry subcategories by attack likelihood and data sensitivity (bubble chart). Timeline mode plots WordPress/WooCommerce exploit trends over 24 months with switchable Y-axes for exploit volume, time-to-exploit vs time-to-patch (with Wordfence 30-day delay reference line), and cost-to-exploit.
---

## Overview

This Skill generates AI-era cyber risk charts for a target city. It operates in two modes: **Landscape** (bubble chart of industry subcategories scored by attack likelihood and data sensitivity) and **Timeline** (time-series chart of WordPress/WooCommerce exploit trends over the past 24 months). Both modes are used to identify *which* businesses to contact and *why the urgency is real* — not to generate outreach for a specific company. After rendering the chart, it offers to hand off to the **Business Outreach Generator** skill.

---

## Chart Mode Selection

This Skill supports two visualisation modes. Ask the human which they want before generating:

| Mode | Chart Type | Best For |
|------|-----------|----------|
| **Landscape** (default) | Bubble chart — industry subcategories plotted by attack likelihood vs data sensitivity | Identifying *which industries* to prioritise for outreach |
| **Timeline** | Line/bar chart — WordPress/WooCommerce exploit trends over the past 24 months | Understanding *how fast* the threat is accelerating and making the urgency case |

If no preference is stated, default to **Landscape** mode.

If the human wants both, generate Landscape first, then Timeline.

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

### D. Historical Exploit Volume (Timeline mode only)

Only perform this research when generating a **Timeline** chart.

Search: `WordPress WooCommerce plugin CVE exploit monthly statistics [year-1] [year] site:nvd.nist.gov OR site:wordfence.com OR site:wpscan.com`

For each of the past 24 calendar months, collect or estimate:
- Number of new CVEs published affecting WordPress/WooCommerce plugins
- Number confirmed actively exploited in the wild that month, broken down by incident outcome category:
  - **Ransomware** — encryption/extortion of site or hosting environment
  - **Data leak** — exfiltration of customer PII, credentials, or payment data (includes skimmers/Magecart)
  - **Outage** — defacement, DDoS, or service disruption with no data theft
  - **Money theft** — direct financial fraud, payment redirection, or account takeover for financial gain
  - If a known incident spans multiple categories, count it in its *primary* outcome category
  - If category breakdown is unavailable for a month, distribute confirmed exploits proportionally using the closest available period's ratio and note the estimate
- Average CVSS score for that month's exploited CVEs
- Average days from CVE publication to first confirmed exploit (time-to-exploit)
- Average days from CVE publication to patch release (time-to-patch)
- Estimated cost-to-exploit for a non-technical attacker (use the cost estimation framework from the AI-Era Vulnerability Scanner's `resources/ai-era-cost-estimation.md` if loaded, otherwise use ordinal: Trivial <$50, Low $50–$500, Medium $500–$5k, High $5k–$50k)

If monthly granularity is unavailable for older months, interpolate from quarterly reports and note the interpolation.

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

## Step 4 — Generate the Chart

Generate the chart(s) selected in the Mode Selection step.

---

### Mode A — Landscape Chart (Bubble)

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

### Mode B — Timeline Chart (Line/Bar)

Produce an interactive time-series chart covering the past 24 calendar months.

**X-axis:** Calendar month (past 24 months, oldest left)

**Y-axis selector:** Render a toggle/tab control so the human can switch between three Y-axis views without reloading:

| Y-axis | Series | Chart type |
|--------|--------|------------|
| **Y1 — Exploit volume** | Stacked bar — confirmed-in-wild exploits per month broken into four categories: **Ransomware** (red), **Data leak** (amber), **Outage** (blue), **Money theft** (green). Total new CVEs per month shown as a separate line overlay (secondary Y-axis, right). | Stacked bar + line overlay |
| **Y2 — Time-to-exploit vs time-to-patch** | Average days from publish to first exploit (line) + average days from publish to patch (line) + **Wordfence 30-day free-tier patch delay** (horizontal dotted reference line at y = 30) | Multi-line |
| **Y3 — Cost-to-exploit** | Average estimated cost-to-exploit per month (line), plotted on a log scale if range exceeds 2 orders of magnitude | Line |

**Tooltips:** On hover over any data point — show month, metric value, notable CVEs that month, and a 1-sentence narrative (e.g. "March 2025: CVE-2025-XXXX drove a spike in skimmer deployments against WooCommerce checkout pages").

**Annotations:** Mark any month where a Mythos-class or frontier AI model was publicly released or benchmarked, with a vertical dashed line labelled with the model name — to visually correlate AI capability jumps with exploit volume changes.

**Legend:** Series labels + reference line explanation ("Wordfence free-tier delay: patches available to paid users 30 days before free users").

**Visual style:** Flat design, Claude.ai CSS variables, Chart.js line/bar chart. Y-axis toggle implemented as button group above the chart.

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
