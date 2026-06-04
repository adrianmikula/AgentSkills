---
name: City Risk Landscape
description: Generate interactive AI-era cyber risk charts for a target city. Three modes available — Landscape (bubble chart of industry subcategories by vulnerability vs data sensitivity), Timeline (24-month exploit trend analysis), and Simulation (5-year business survival probability calculator with financial exposure modeling).
---

## Overview

This Skill generates AI-era cyber risk charts for a target city. It operates in three modes:

- **Landscape** — bubble chart of industry subcategories scored by vulnerability and data sensitivity
- **Timeline** — time-series chart of WordPress/WooCommerce exploit trends over the past 24 months
- **Simulation** — 5-year business survival probability calculator modeling financial exposure and cost of inaction

Landscape and Timeline identify *which* businesses to contact and *why the urgency is real*. Simulation models *what happens* to a specific business profile under different security investment scenarios. After rendering any chart, the skill offers to hand off to the **Business Outreach Generator** skill.

---

## Chart Mode Selection

This Skill supports three visualisation modes. Ask the human which they want before generating:

| Mode | Chart Type | Best For |
|------|-----------|----------|
| **Landscape** (default) | Bubble chart — industry subcategories plotted by vulnerability vs data sensitivity | Identifying *which industries* to prioritise for outreach |
| **Timeline** | Line/bar chart — WordPress/WooCommerce exploit trends over the past 24 months | Understanding *how fast* the threat is accelerating and making the urgency case |
| **Simulation** | Interactive calculator — 5-year survival probability and financial exposure | Modeling *expected outcomes* for a specific business profile under different security scenarios |

If no preference is stated, default to **Landscape** mode.

If the human wants multiple modes, generate in order: Landscape → Timeline → Simulation.

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

### E. Simulation Threat Parameters (Simulation mode only)

Only perform this research when generating a **Simulation** chart.

The Simulation engine requires base-rate threat data to model 5-year survival probabilities. Extract the following from Steps 2A–D research and populate the simulation data structure:

| Parameter | Source | Value to extract |
|-----------|--------|------------------|
| **Industry base attack rate** | Step 2B Industry Attack Patterns + ASD Annual Cyber Threat Report | ASD 2024–25: 38% of Australian SMBs faced an attack attempt. Apply industry modifier: Restaurant/Café (1.0x), Retail (1.1x), Allied Health (0.9x), Church/NFP (0.8x), Education/Childcare (0.85x), Trades/Services (1.05x), Other (1.0x) |
| **Ransomware prevalence** | Step 2B + Verizon DBIR | Verizon DBIR 2025: 88% of SMB breaches involve ransomware — use as conditional probability given breach |
| **Average recovery cost** | Hyetech Australia + Sophos | Hyetech AUD $97,000 Australian SMB average. Scale by revenue: multiply by `(annual_revenue / 500000) ^ 0.6` |
| **Ransom component ratio** | IBM Cost of Data Breach 2025 | Ransom = 15% of total breach cost |
| **Downtime statistics** | Sophos State of Ransomware 2025 | 53% recover within 1 week; 33% take 1–6 months. Use median 7 days for "quick recovery" branch, 90 days for "extended recovery" branch |
| **Customer churn after breach** | Hiscox Cyber Readiness Report 2024 | 43% of businesses lost customers after attack; 70% of consumers less likely to continue business |
| **Business closure risk** | VikingCloud 2025 SMB Threat Landscape | ~20% of SMBs would be forced to permanently close due to successful cyberattack (replaces debunked "60% within 6 months" statistic). Scale by revenue: 35% (<$500k), 20% ($500k–$2M), 10% (>$2M) |
| **AI-era attack compression** | arXiv 2605.06713 + NCSC assessment | Agentic AI reduces attacker time/skill/cost — apply 1.35× annual multiplier to attack probability from Year 2 onward |
| **Regulatory fine exposure** | OAIC enforcement history | ACL penalty $5.8M (2023) establishes precedent. For SMB simulation: $25k–$50k for health/childcare/NDIS sectors |
| **Cyber insurance penetration** | BD Emerson 2026 Statistics | Only 18% of small businesses have cyber insurance |

**Security posture multipliers** (based on ACSC Small Business Cyber Security Guide):
- None (no IT support, unpatched WordPress): 1.0×
- Basic (Wordfence Free, no backups): 0.6×
- Moderate (Wordfence Premium, occasional backups): 0.35×
- Good (patched, offsite backups, MFA): 0.15×

**Location modifiers**:
- Perth WA: 0.7× Year 1, rising to 1.0× by Year 3 (attacker scanning latency)
- Sydney NSW, Melbourne VIC, Brisbane QLD: 1.0×
- Regional Australia: 0.8× Year 1, 0.9× Year 2, 1.0× Year 3+
- Colorado USA: 1.1× (higher baseline threat exposure)

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

### Mode C — Simulation Chart (Interactive Business Survival Calculator)

Produce an interactive HTML artifact that models 5-year financial survival probability for a configurable small business profile. The artifact runs entirely client-side using Chart.js (loaded from CDN) with no external API dependencies.

**Template Files:** Use the pre-built template files located at:
- `/media/adrian/SOURCE/Projects/AgentSkills/city-risk-landscape/resources/simulation-template.html`
- `/media/adrian/SOURCE/Projects/AgentSkills/city-risk-landscape/resources/simulation-template.css`
- `/media/adrian/SOURCE/Projects/AgentSkills/city-risk-landscape/resources/simulation-template.js`

**Workflow:**
1. Read the template files (CSS, JS, HTML)
2. Copy contents and customize the `CONFIG:` sections for the target business/sector
3. Output a single self-contained HTML file with inline CSS and JS (no external dependencies)

**Key customizations for each sector:**
- `industryModifiers`: Set (mod, dailyRate, regulatoryFine) for each industry option
- `locationModifiers`: Adjust for attacker maturity curve (major city vs regional)
- `revenue`: Set default revenue slider value appropriate for sector
- Industry dropdown options and labels
- Methodology section: Add sector-specific citations and context

**Chart requirements:**

#### Input Panel (User-Configurable Parameters)

Render a simplified control panel appropriate for micro SMB decision-making:

| Input | Type | Options/Range |
|-------|------|---------------|
| **Industry type** | Dropdown | Restaurant/Café, Retail (independent), Allied Health Clinic, Church/NFP, Independent School/Childcare, Trades/Services |
| **Security Approach** | Dropdown | **None** — No security investment; **Traditional** — Human-driven (backups, firewall, MFA, staff training); **AI-Powered** — Automated defense (anomaly detection, response, air-gapped recovery) |
| **Annual revenue (AUD)** | Slider | $100k – $2M |
| **Profit Margin** | Dropdown | Low (5-10%), Medium (15-20%), High (25%+) |
| **AI Business Tools** | Toggle | Yes / No — Represents mid-range AI adoption (scheduling, chatbots, automation) |
| **Online payment/booking** | Toggle | Yes (+0.25× attack risk) / No |
| **Cyber insurance** | Toggle | Yes (-60% recovery cost, -25% failure risk) / No |

**Note:** Location defaults to Perth WA, platform assumed WordPress. Technical debt, employee count, and granular security controls (MFA, backups, training) are consolidated into the Security Approach selector for micro SMB simplicity.

#### Simulation Engine

Model three scenarios over a 5-year forward horizon (Year 0 through Year 5):

**Scenario A — Status quo (no security improvement)**
- Security posture multiplier: unchanged from user selection
- Cost: $0 security investment

**Scenario B — Basic hardening (patch cycle + backups + MFA)**
- Security posture multiplier: minimum 0.35× (Moderate)
- Cost: $3,000/year ($15,000 over 5 years)

**Scenario C — Full audit + remediation**
- Security posture multiplier: 0.15× (Good)
- Cost: $8,000 upfront + $2,000/year ongoing ($18,000 over 5 years)

**Calculations for each scenario and year (EXPONENTIAL DYNAMICS):**

1. **Annual attack probability** — compounded annual probability with exponential security decay/growth:
   ```
   base_rate = 0.38 (ASD 2024-25 Australian SMB attack attempt rate)
   × industry_modifier (0.8×-1.1× from sector table)
   × security_approach_effectiveness (EXPONENTIAL over time)
     - None: 1.0× static
     - Traditional: 0.25× Year 1 (75% reduction), decays 50% per year—static human-driven defenses cannot adapt to evolving AI attacks
     - AI-Powered: 0.06× Year 1, improves 8% per year as system learns
   × location_modifier (0.7×→1.0× over 3 years for Perth)
   × online_payment_modifier (+0.25 if present)
   × mythos_multiplier (1.35^year exponential AI attack compression)
   × ai_business_surface (+35% if AI tools enabled)
   
   attack_probability_year = base_rate × all_modifiers
   ```

2. **Expected financial impact if attacked** (with EXPONENTIAL reputational compounding):
   ```
   recovery_cost = AUD $97,000 × (annual_revenue / 500000) ^ 0.6
   
   ransom_component = 15% of recovery_cost (IBM 2025)
   
   downtime_cost = industry_daily_rate × recovery_days × security_approach_recovery_mult
   - Industry daily rates: Health $1,500, Restaurant $1,200, Trades $900, Retail $800, Education $600, NFP $400
   - Recovery multipliers: None=2.0×, Traditional=0.6×, AI-Powered=0.3×
   
   regulatory_fine = $35,000 (Health/Childcare) or $0 (other sectors)
   
   // EXPONENTIAL VIRAL AMPLIFICATION of reputational damage:
   base_reputational_hit = 12% × annual_revenue
   viral_amplification = 20% per year (network effects of bad news)
   years_since_breach = current_year - breach_year
   reputational_loss = base_reputational_hit × (1.20 ^ years_since_breach)
   // Multiple breaches compound independently
   
   insurance_offset = -60% × recovery_cost if insured
   
   total_impact = sum of all components (compounds across breach history)
   ```

3. **Business survival probability** (with CASH FLOW INSOLVENCY and profit margin buffer):
   ```
   start = 100%
   base_failure_risk = 35% (<$500k), 20% ($500k-$2M), 10% (>$2M)
   
   // CASH RESERVES by profit margin (working capital depth)
   cash_reserve_months = 1.5 (low 5-10%), 3.5 (medium 15-20%), 6.0 (high 25%+)
   monthly_profit = annual_revenue × profit_margin / 12
   initial_cash_reserves = monthly_profit × cash_reserve_months
   
   For each year:
   // Base failure risk adjustments
   adjusted_failure_risk = base_failure_risk
     × profit_margin_mult (low=1.3×, medium=1.0×, high=0.7×)
     × insurance_reduction (0.75× if insured)
     × security_survival_boost (none=1.0×, traditional=0.8×, ai-powered=0.65×)
     × ai_defense_dwell_time_reduction
   
   // CASH FLOW CATASTROPHE: Can the business survive the immediate hit?
   expected_breach_cost = attack_probability × total_impact
   available_cash = initial_cash_reserves + accumulated_cash
   catastrophic_threshold = annual_profit × 2
   
   if expected_breach_cost > available_cash:
     // Business lacks cash to survive the breach - immediate insolvency risk
     cash_shortfall = expected_breach_cost - available_cash
     cash_flow_failure_risk = min(0.80, cash_shortfall / catastrophic_threshold)
   else:
     cash_flow_failure_risk = 0
   
   // Deplete cash reserves by breach cost, rebuild with annual profit
   accumulated_cash = accumulated_cash - expected_breach_cost + annual_profit
   
   // Combined survival probability
   base_survival = 1 - (attack_probability × adjusted_failure_risk)
   survival = survival × base_survival × (1 - cash_flow_failure_risk)
   ```
   
   **Key insight**: Low-margin businesses face dramatically higher failure rates from the SAME breach because they lack cash reserves. A $250k business with 5% margin (~$2,800 cash reserves) faces near-certain failure from a $97k breach, while a 25% margin business (~$18,750 reserves) can absorb the hit.

4. **Cumulative cost of inaction** (with EXPONENTIAL AI business revenue growth):
   ```
   // AI businesses capture market share EXPONENTIALLY:
   if ai_business_tools = Yes:
     year_revenue = base_revenue × (1.25 ^ year)  // 25% compound growth
     annual_savings = base_revenue × 0.45 × 0.15  // 15% staff cost reduction
   
   // Calculate expected loss each year with compounding reputational damage:
   For each year 1-5:
     expected_loss = attack_probability × total_impact
     cumulative_reputational_damage = sum of all prior breaches' amplified harm
     net_cost = expected_loss + cumulative_reputational_damage - ai_savings
   
   cumulative_cost_A = sum of net_cost for Scenario A (no improvement)
   cumulative_cost_C = sum of net_cost for Scenario C (full audit) + $18,000 remediation
   cost_of_inaction = cumulative_cost_A - cumulative_cost_C
   roi_ratio = cumulative_cost_A / cumulative_cost_C
   ```

#### Output Visualisation (Four Panels)

**Panel 1 — Survival probability curve**
- Line chart (Chart.js)
- Three lines: Scenario A (red), B (amber), C (green)
- X-axis: Year 0–5
- Y-axis: Survival probability 0–100%
- Shade the gap between A and C curves
- Tooltip: show exact percentage on hover

**Panel 2 — Attack probability by year**
- Stacked bar chart (recharts)
- X-axis: Year 1–5
- Y-axis: Annual attack probability 0–100%
- Three series (A/B/C) with different opacities
- Mythos-era multiplier visible as acceleration from Year 2 onward

**Panel 3 — Financial exposure summary**
- Single year selector (slider: Year 1–5)
- Horizontal stacked bar comparing Scenario A vs C
- Segments: ransom, recovery, downtime, regulatory, reputational
- Values displayed as AUD with thousands separator

**Panel 4 — 5-year cost of inaction**
- Large bold number display
- "Expected cost of doing nothing over 5 years: $XXX,XXX"
- "Expected cost with full audit + remediation: $XX,XXX"
- "ROI ratio: X.X×" (cost of inaction / cost of remediation)

#### Methodology Expander

Include an expandable section below the panels explaining each calculation with citations:

- **Attack probability (EXPONENTIAL)**: Base rate 38% from ASD Annual Cyber Threat Report 2024-25. Traditional security DECAYS: 50% effectiveness lost per year as AI attacks evolve—static defenses cannot adapt to AI attack evolution. AI-Powered security IMPROVES: 8% effectiveness gain per year as system learns. Security multipliers derived from ACSC Small Business Cyber Security Guide and Microsoft MFA effectiveness data (99.9% automated attack block).

- **AI Business Efficiency (EXPONENTIAL)**: PwC AI Performance Study (April 2026) patterns. AI-enabled businesses capture market share at 25% compound annual growth—not linear 15% improvement. Network effects and competitive dynamics create exponential separation between AI-adopting and non-AI businesses.

- **Financial impact**: Recovery cost AUD $97k from Hyetech Australia/Sophos. Ransom component 15% from IBM Cost of a Data Breach 2025. Downtime statistics from Sophos State of Ransomware 2025 (53% recover <1 week, 33% take 1-6 months).

- **Reputational Damage (EXPONENTIAL)**: Breach harm compounds virally at 20% per year through network effects. Digital permanence of bad news creates growing—not fading—damage over time. Multiple breaches compound independently, creating overlapping damage waves.

- **Survival model (with CASH FLOW CATASTROPHE)**: Business closure risk (~20%) from VikingCloud 2025 SMB Threat Landscape Report. Revenue-scaled failure risk aligns with Hiscox Cyber Readiness Report 2024. **Cash flow insolvency model**: Low-margin businesses (5-10%) have only 1.5 months cash reserves vs 6+ months for high-margin (25%+). If breach cost exceeds available working capital, immediate insolvency risk up to 80%. This models the reality that many SMBs fail not from long-term unprofitability, but from immediate cash exhaustion after a cyber incident.

- **AI-era multiplier**: 1.35× annual compounding reflects attack compression documented in arXiv 2605.06713 "Agentic AI and the Industrialization of Cyber Offense" (May 2025) and NCSC assessment through 2027.

#### Data Source Footnotes

Display small footnotes beneath each panel:

- **Panel 1 footnote**: "Survival model: VikingCloud 2025 (20% baseline), Hiscox 2024. Revenue-scaled: <500k=35%, 500k-2M=20%, >2M=10%. CASH FLOW INSOLVENCY: Low-margin businesses have 1.5 months reserves vs 6+ months for high-margin. If breach exceeds cash: immediate failure risk up to 80%. Profit margin: low=+30% risk, high=-30% risk. Insurance: -25% failure risk."
- **Panel 2 footnote**: "Base attack rate: ASD Annual Cyber Threat Report 2024-25 (38%). Traditional security DECAYS 50%/year—human-driven defenses cannot adapt to AI attack evolution. AI-Powered IMPROVES 8%/year. Security multipliers: ACSC Small Business Guide."
- **Panel 3 footnote**: "Recovery: Hyetech AUD $97k. Ransom: IBM 2025 (15%). Reputational: EXPONENTIAL viral amplification 20%/year. Downtime: Sophos 2025."
- **Panel 4 footnote**: "AI business revenue: PwC 2026 (25% exponential growth). AI-era attacks: arXiv 2605.06713, NCSC 2025. Insurance: 60% recovery offset. Key insight: By Year 5, AI-powered businesses have 2× revenue AND 4× better attack survival than traditional setups."

#### Visual Style

- Flat design with Claude.ai CSS variables (defined in `simulation-template.css`)
- Mobile-responsive CSS grid layout (2 columns desktop, 1 column mobile)
- Interactive inputs update charts in real-time using vanilla JavaScript
- Neutral language throughout: "expected financial exposure" not "you will be attacked"
- Chart.js loaded from CDN (consistent with Landscape and Timeline modes)
- All calculations performed client-side in JavaScript (no external API calls)
- **Template-driven:** Copy and customize the three template files (HTML, CSS, JS) with `CONFIG:` markers for rapid sector adaptation

---

## Step 5 — Present Findings and Offer Next Steps

After rendering the chart, output:

1. **Top 3 priority industries** — one sentence each explaining why they rank highest right now, referencing specific CVEs or active campaigns from the research.

2. **Active threat callout** — if any CVE is confirmed actively exploited in the wild right now, flag it prominently:

   > ⚠️ Active skimmer campaign: [CVE] is being exploited in the wild against [sector] sites as of [month year]. Any unpatched [plugin] installation is currently being targeted.

3. **Mythos readiness note** — brief note on the upcoming public availability of Mythos-class models and what that means for the attack surface of the industries in the top-right quadrant.

4. **Offer to proceed** — ask:

   For Landscape/Timeline modes:
   > Want me to find specific [city] businesses in the top-priority categories and generate phone briefs?

   For Simulation mode:
   > Want me to find [industry] businesses in [location] matching this profile and generate outreach briefs?

   If the human says yes, hand off to the **Business Outreach Generator** skill with the selected industry and city/country pre-populated.

---

## Refresh Cadence

This chart must be regenerated fresh each time it is requested — never cached or re-used from a previous session. The CVE and breach landscape changes weekly.

Flag the research date at the top of every output: *"Risk landscape as of [date]."*

---

## Related Skills

- **Business Outreach Generator** — after identifying target industries from this chart, use this skill to generate emails, LinkedIn messages, or phone briefs for specific businesses.
- **AI-Era Vulnerability Scanner** — once a specific business is selected, use this skill to scan their public website for AI-era vulnerabilities before the outreach call.
