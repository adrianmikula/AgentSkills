---
name: City Risk Landscape
description: Generate interactive AI-era cyber risk charts for a target city. Landscape mode plots industry subcategories on a vulnerability vs data-sensitivity bubble chart (X = composite vulnerability score: security team capacity + public exposure footprint + time-to-patch; bubble size switchable between payment volume, avg ransom demand, and recent exploit count). Timeline mode plots WordPress/WooCommerce exploit trends over 24 months with switchable Y-axes for exploit volume, time-to-exploit vs time-to-patch, cost-to-exploit, industry breakdown, and breach scale.
---

## Overview

This Skill generates AI-era cyber risk charts for a target city. It operates in two modes: **Landscape** (bubble chart of industry subcategories scored by vulnerability and data sensitivity) and **Timeline** (time-series chart of WordPress/WooCommerce exploit trends over the past 24 months). Both modes are used to identify *which* businesses to contact and *why the urgency is real* — not to generate outreach for a specific company. After rendering the chart, it offers to hand off to the **Business Outreach Generator** skill.

---

## Chart Mode Selection

This Skill supports two visualisation modes. Ask the human which they want before generating:

| Mode | Chart Type | Best For |
|------|-----------|----------|
| **Landscape** (default) | Bubble chart — industry subcategories plotted by vulnerability vs data sensitivity | Identifying *which industries* to prioritise for outreach |
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

> **Data source hints:** Before searching, consult `resources/data-sources.md` (included in this skill package). It lists the fastest query path for each dataset, exact URLs to try first, and backup web searches to fall back to if a primary source returns a 403, stream error, or paywall.

### A. Active CVEs

*See `resources/data-sources.md` § 1 — primary sources: Wordfence Intelligence (filter by Exploited), Patchstack DB (filter by Actively Exploited), WPScan, NVD. Backup searches listed there.*

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

Also collect the following data to support the Landscape bubble size options:

**Average ransom demand by sector (B2):**
*See `resources/data-sources.md` § 3 — Coveware quarterly reports (primary), Sophos State of Ransomware (fallback), ACSC Annual Cyber Threat Report (AU-specific). SMB scaling rule and backup searches included.*
Search: `average ransomware demand [sector] small business [current year] Coveware OR Sophos OR ACSC`
For each industry subcategory, record the average or median ransom demand (USD) reported for that sector. Use Coveware quarterly reports as primary source; fall back to Sophos State of Ransomware or ACSC Annual Cyber Threat Report.

**Recent exploit count by sector (B3):**
*See `resources/data-sources.md` § 4 — Wordfence weekly reports and Patchstack weekly advisories. OAIC sector ratio fallback method described there.*
Search: `WordPress exploit [sector] confirmed in-wild [current month year] site:wordfence.com OR site:patchstack.com`
For each industry subcategory, record the count of confirmed in-wild exploits in the past 30 days. Use Wordfence weekly reports and Patchstack advisories. If sector-level count is unavailable, apply the OAIC sector ratio from Step 2D to the total monthly exploit index.

### C. Local Breach Examples

Search: `data breach [target city OR target country] small business [current year]`

Record 2–3 local or near-local examples to use as social proof in follow-up outreach.

### D. Historical Exploit Volume (Timeline mode only)

Only perform this research when generating a **Timeline** chart.

*See `resources/data-sources.md` for section-by-section source guidance:*
*§ 5 — monthly CVE counts (Patchstack annual/mid-year reports, NVD date-range search)*
*§ 6 — time-to-exploit and time-to-patch (Patchstack/Wordfence CVE posts; Wordfence free-tier delay = fixed 30 days)*
*§ 7 — cost-to-exploit (AI-Era Vulnerability Scanner resource, Patchstack Priority Score, CISA KEV)*
*§ 2 — OAIC sector ratios for Y4 industry breakdown*
*§ 8 — OAIC breach scale split for Y5*

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
- Number of breach notifications that period broken down by **victim industry sector**, using the exact sector names published by the OAIC Notifiable Data Breaches report:
  - **Health service providers**
  - **Finance (incl. superannuation)**
  - **Education**
  - **Retail**
  - **Other sectors** — all remaining sectors not individually listed above
  - Exclude **Australian Government** notifications — not SMB-relevant. Renormalise percentages across remaining sectors before applying.
  - Source: OAIC Notifiable Data Breaches half-yearly reports (latest available). Apply the most recent published sector ratio to each month's exploit index and annotate that the ratios are fixed, not independently counted per month.
- Number of breach notifications broken down by **scale of individuals affected**, using the exact split published by the OAIC:
  - **≤100 individuals affected** — small-scale breaches
  - **100+ individuals affected** — large-scale breaches
  - Source: OAIC Notifiable Data Breaches H1 2024 and subsequent reports (published figure: 63% ≤100, 37% 100+). Apply as fixed ratio and note the source.
  - Do not further subdivide by staff count — no public source reports this breakdown monthly.

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

### X-axis — Vulnerability

Composite score (0–100) based on three equally-weighted factors:

**1. Security team capacity** (0–35)
How likely the typical business in this sector has a dedicated IT/security function:
- Solo operator / no IT staff — 35
- Shared IT (part-time or outsourced) — 20
- Dedicated internal IT, no security specialist — 10
- Dedicated security staff or MSSP — 0

Source: ABS Business Characteristics Survey, IBISWorld sector profiles, ACSC Small Business Cyber Security Guide. *See `resources/data-sources.md` § 9 for exact URLs and query methods.*

**2. Public-facing exposure and data footprint** (0–35)
How large and exposed the sector's typical online presence is:
- Transactional website with stored customer data (WooCommerce/bookings/health portal) — 35
- Informational site with contact forms collecting PII — 20
- Minimal web presence (directory listing only) — 5
- Add +5 if the sector commonly uses third-party plugins with historically high CVE rates (e.g. booking, payment, forms plugins)
- Add +5 if confirmed active exploit campaign targeting this sector's typical plugin stack

**3. Typical time-to-patch** (0–30)
How long businesses in this sector typically take to apply security patches:
- > 60 days or unknown — 30
- 30–60 days (Wordfence free-tier window) — 20
- 14–29 days — 10
- < 14 days — 0

Source: Wordfence/Patchstack sector patch-lag data; if unavailable, use sector IT-maturity proxy from ABS or ACSC guidance. *See `resources/data-sources.md` § 9 (typical time-to-patch) and § 6 (Wordfence/Patchstack patch-lag statistics).*

### Y-axis — Customer Data Sensitivity

Score based on:
- Health or medical data present (yes = 80+)
- Financial account data or stored card-on-file (yes = 65+)
- Personal identifying data volume (name/DOB/address = 50+)
- Regulatory penalty exposure under Australian Privacy Act or equivalent (high = +15)

### Bubble Size — Three Selectable Metrics

The bubble chart renders a toggle control so the human can switch the bubble size metric without reloading:

| Option | What it represents | Data source |
|--------|--------------------|-------------|
| **B1 — Payment & data volume** *(default)* | Relative estimate of transaction value + customer record volume per typical site in that sector | Sector research + industry benchmarks |
| **B2 — Average ransom demand** | Average ransomware demand targeting businesses in that sector (USD) | Coveware quarterly reports, ACSC annual threat report, Sophos State of Ransomware |
| **B3 — Recent exploit count** | Total confirmed in-wild exploits targeting that sector in the past 30 days | Wordfence/Patchstack advisories, OAIC notifications |

Map raw values to radius using this ordinal scale:

| Ordinal | Radius | B1 | B2 (USD) | B3 (count) |
|---------|--------|----|----------|------------|
| Micro | r = 10 | Lowest tier | < $10k | ≤ 2 |
| Small | r = 15 | Low-mid | $10k–$50k | 3–6 |
| Medium | r = 20 | Mid-high | $50k–$200k | 7–15 |
| Large | r = 25 | Highest tier | > $200k | > 15 |

### Colour Tier

| Tier | Condition | Colour |
|------|-----------|--------|
| 🔴 Critical | x ≥ 70 AND y ≥ 70, OR confirmed active exploit targeting that sector's typical plugin stack | Red |
| 🟠 High | x ≥ 55 OR y ≥ 60 | Amber |
| 🔵 Medium | Everything else | Blue |

---

## Step 4 — Generate the Chart

Generate the chart(s) selected in the Mode Selection step.

---

### Mode A — Landscape Chart (Bubble)

Produce an interactive bubble chart visualisation using the scored data.

**Chart requirements:**
- X-axis: Vulnerability (0–100) — composite of security team capacity, public-facing exposure/data footprint, and typical time-to-patch
- Y-axis: Customer data sensitivity (0–100)
- Bubble size: Controlled by a toggle above the chart with three options:
  - **B1 — Payment & data volume** *(default)*
  - **B2 — Avg ransom demand**
  - **B3 — Recent exploit count (30 days)**
- Bubble colour: Exposure tier (critical = red, high = amber, medium = blue)
- Labels: Short industry name on each bubble
- Tooltips: On hover — show the active bubble-size metric value, CVEs affecting that sector, active exploit status, and 1-sentence rationale for the score
- Legend: Colour tier key + bubble size key (updates label when metric is switched)

**Visual style:** Flat design, Claude.ai CSS variables, Chart.js bubble chart. Bubble size toggle implemented as button group above the chart, matching the style of the Timeline Y-axis toggle.

---

### Mode B — Timeline Chart (Line/Bar)

Produce an interactive time-series chart covering the past 24 calendar months.

**X-axis:** Calendar month (past 24 months, oldest left)

**Y-axis selector:** Render a toggle/tab control so the human can switch between five Y-axis views without reloading:

| Y-axis | Series | Chart type |
|--------|--------|------------|
| **Y1 — Exploit volume** | Stacked bar — confirmed-in-wild exploits per month broken into four categories: **Ransomware** (red), **Data leak** (amber), **Outage** (blue), **Money theft** (green). Total new CVEs per month shown as a separate line overlay (secondary Y-axis, right). | Stacked bar + line overlay |
| **Y2 — Time-to-exploit vs time-to-patch** | Average days from publish to first exploit (line) + average days from publish to patch (line) + **Wordfence 30-day free-tier patch delay** (horizontal dotted reference line at y = 30) | Multi-line |
| **Y3 — Cost-to-exploit** | Average estimated cost-to-exploit per month (line), plotted on a log scale if range exceeds 2 orders of magnitude | Line |
| **Y4 — Industry breakdown** | Stacked bar — breach notifications per month broken by OAIC sector: **Health service providers** (red), **Finance incl. superannuation** (amber), **Education** (purple), **Retail** (blue), **Other sectors** (slate). Australian Government excluded and percentages renormalised. Ratios are fixed from latest OAIC report — annotate as such in chart subtitle. | Stacked bar |
| **Y5 — Breach scale** | Stacked bar — breach notifications per month broken by OAIC published scale split: **≤100 individuals affected** (teal), **100+ individuals affected** (indigo). Source: OAIC Notifiable Data Breaches H1 2024 (63% / 37%). Annotate in chart subtitle. | Stacked bar |

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
