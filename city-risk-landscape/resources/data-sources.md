# City Risk Landscape — Data Sources Reference

This file lists the preferred primary sources for each dataset required by the skill, the fastest query method for each, and web search fallbacks when primary sources are unavailable or paywalled.

---

## 1. Active WordPress/WooCommerce CVEs

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **Wordfence Intelligence** | `https://www.wordfence.com/threat-intel/vulnerabilities` | Filter by "Exploited" status. The weekly vulnerability report blog posts at `wordfence.com/blog` list confirmed-in-wild CVEs with CVSS, patch status, and install counts. Search for the most recent weekly report. |
| **Patchstack Vulnerability DB** | `https://patchstack.com/database/` | Filter by "Actively Exploited". Patchstack's Priority Score (not raw CVSS) identifies real-world exploitability — use the Priority Score as primary severity signal. |
| **WPScan Vulnerability DB** | `https://wpscan.com/plugins` | Free-tier API or browse by plugin name. Lists CVEs, CVSS, and exploit references. |
| **NVD (NIST)** | `https://nvd.nist.gov/vuln/search` | Search `wordpress plugin` + date range. Use the CVE Detail pages for CVSS v3 scores and CWE classification. |

### Backup web searches

```
WordPress plugin vulnerability actively exploited [current month year] site:wordfence.com
WordPress CVE confirmed in-wild [current month year] site:patchstack.com
WooCommerce plugin exploit [current month year]
```

---

## 2. Industry Attack Patterns (AU context)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **ACSC Annual Cyber Threat Report** | `https://www.cyber.gov.au/about-us/view-all-content/reports-and-statistics/annual-cyber-threat-report-[year]-[year+1]` | Read the "Key Statistics" and "Sectors" sections. Look for the industry breakdown table and top reported threat types. Published annually around October. |
| **OAIC Notifiable Data Breaches Report** | `https://www.oaic.gov.au/privacy/notifiable-data-breaches/notifiable-data-breaches-publications` | Half-yearly. Read the "Top 5 sectors" table (exact published counts and percentages). Use H1 and H2 of the most recent year. Exclude Australian Government when calculating SMB-relevant ratios. |
| **Verizon DBIR** | `https://www.verizon.com/business/resources/reports/dbir/` | Annual. The "Industries" chapter contains sector-level breach counts, attack patterns, and actor motives. Use the SMB/small business filter where available. |

### Backup web searches

```
Australia small business cyber attack sector breakdown [current year] ACSC OR OAIC
cyberattack [sector] Australia [current year] statistics
Verizon DBIR [current year] [sector] breach statistics
```

---

## 3. Average Ransom Demand by Sector (Bubble size B2)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **Coveware Quarterly Ransomware Reports** | `https://www.coveware.com/ransomware-quarterly-reports` | Most recent quarter. Read the "Industry Verticals" section for median and average payment by sector. Note whether figures are median or mean — use median for SMB proxy (mean is skewed by large enterprise incidents). |
| **Sophos State of Ransomware** | `https://www.sophos.com/en-us/content/state-of-ransomware` | Annual (published ~May each year). The "Industry" chapter has mean ransom demands, payment rates, and backup destruction rates per sector. |
| **ACSC Annual Cyber Threat Report** | See above | Contains Australian-specific ransomware demand ranges and payment amounts for the most recent fiscal year. |

### SMB scaling rule

Published figures skew toward large enterprises. If the report does not specify SMB vs enterprise, halve the median figure for the SMB estimate (businesses < 200 staff).

### Backup web searches

```
average ransomware payment [sector] 2025 Coveware OR Sophos median
ransomware demand [sector] small business [current year]
Coveware ransomware report [current year] industry breakdown
```

---

## 4. Recent Exploit Count by Sector (Bubble size B3)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **Wordfence weekly reports** | `https://www.wordfence.com/blog/` | Search for "weekly vulnerability report [month year]". Each report lists plugins patched that week and flags which are confirmed exploited in-wild. Tally confirmed-exploited entries. |
| **Patchstack weekly advisories** | `https://patchstack.com/articles/` | Filter by "Actively Exploited". Count entries from the past 4 weeks. |
| **OAIC NDB sector ratios (fallback)** | See section 2 above | If sector-level exploit counts are unavailable, apply the OAIC top-5 sector percentages (renormalised, excluding Australian Government) to the total monthly exploit index. |

### Backup web searches

```
WordPress plugin confirmed exploited [current month year] site:wordfence.com
Patchstack actively exploited plugin [current month year]
WordPress malware [sector] [current month year]
```

---

## 5. Historical Monthly CVE Counts (Timeline Y1 — new CVEs per month)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **Patchstack annual/mid-year reports** | `https://patchstack.com/whitepaper/` | The State of WordPress Security (annual) and Mid-Year Vulnerability Report give total CVE counts per period. Divide by number of months in the period for a monthly average. |
| **Wordfence Intelligence stats** | `https://www.wordfence.com/threat-intel/vulnerabilities` | The weekly reports each give a weekly CVE count. Sum 4–5 weekly reports per month to build a monthly total. |
| **NVD CPE search** | `https://nvd.nist.gov/vuln/search?form_type=Advanced&results_type=overview&query=wordpress+plugin&search_type=all` | Filter by date range to get exact counts for a given month. |

### Backup web searches

```
WordPress plugin CVE count [month year] statistics
Patchstack vulnerability report [year] total CVEs monthly
site:wordfence.com weekly vulnerability report [month year]
```

---

## 6. Time-to-Exploit and Time-to-Patch (Timeline Y2)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **Patchstack Mid-Year / Annual Reports** | `https://patchstack.com/whitepaper/` | Look for "time to exploit" or "days between disclosure and exploit" statistics. The 2025 mid-year report noted attackers exploit critical unauthenticated CVEs within 1–3 days. |
| **Wordfence blog — specific CVE posts** | `https://www.wordfence.com/blog/` | Individual CVE posts note the date of disclosure vs date Wordfence first observed exploitation. Manual tally of 5–10 high-profile CVEs per quarter gives a representative average. |
| **Wordfence free-tier delay** | Confirmed policy: `https://www.wordfence.com/help/firewall/real-time-ip-blocklist/` | Free users receive firewall rules 30 days after paid users. This is a fixed, published constant — do not estimate or vary it. |

### Backup web searches

```
WordPress plugin exploit within days disclosure [current year] site:wordfence.com OR site:patchstack.com
time to exploit WordPress CVE 2024 2025 average days
Wordfence free vs premium patch delay days
```

---

## 7. Cost-to-Exploit Estimates (Timeline Y3)

### Primary sources

| Source | URL | Query method |
|--------|-----|--------------|
| **AI-Era Vulnerability Scanner resource** | `resources/ai-era-cost-estimation.md` (if loaded) | Use the cost estimation framework defined there. This is the canonical source within the skill suite. |
| **Patchstack Priority Score descriptions** | `https://patchstack.com/database/` | Patchstack labels exploits as "Easy", "Medium", or "Hard" to exploit. Map to cost ordinals: Easy = Trivial (<$50), Medium = Low ($50–$500), Hard = Medium ($500–$5k). |
| **CISA KEV (Known Exploited Vulnerabilities)** | `https://www.cisa.gov/known-exploited-vulnerabilities-catalog` | CISA lists CVEs confirmed exploited in the wild. If a WordPress CVE appears here, it is trivially exploitable (cost = Trivial). |

### Cost ordinal scale (use when no specific data is available)

| Ordinal | USD range | Typical profile |
|---------|-----------|-----------------|
| Trivial | < $50 | Unauthenticated, public PoC, scripted in commodity toolkits |
| Low | $50–$500 | Requires minimal skill; PoC available but needs adaptation |
| Medium | $500–$5k | Requires moderate skill or purchased exploit kit |
| High | $5k–$50k | Requires specialist knowledge or bespoke tooling |

### Backup web searches

```
cost to exploit WordPress vulnerability 2025 attacker toolkit
[CVE ID] proof of concept public exploit site:github.com OR site:exploit-db.com
CISA known exploited vulnerabilities WordPress [current year]
```

---

## 8. OAIC Breach Scale Split (Timeline Y5)

### Primary source

| Source | URL | Query method |
|--------|-----|--------------|
| **OAIC Notifiable Data Breaches Report — Statistics section** | `https://www.oaic.gov.au/privacy/notifiable-data-breaches/notifiable-data-breaches-publications` | Navigate to the most recent half-yearly report → "Statistics" → "Number of individuals affected by breaches". The 63% (≤100 individuals) / 37% (100+) split comes from the H1 2024 report. Verify whether the most recent report has updated this ratio before applying. |

### Backup web searches

```
OAIC notifiable data breaches report [current year] individuals affected percentage
site:oaic.gov.au notifiable data breaches statistics [year]
```

---

## 9. Vulnerability X-axis Scoring Inputs (Landscape mode)

### Security team capacity

| Source | URL | Query method |
|--------|-----|--------------|
| **ABS Business Characteristics Survey** | `https://www.abs.gov.au/statistics/economy/business-indicators/business-characteristics-survey` | Look for IT expenditure and cybersecurity awareness by industry and business size. Published annually. |
| **IBISWorld sector profiles** | `https://www.ibisworld.com/au/` | Each sector report includes "Technology & Systems" subsection noting typical IT investment. Requires subscription — use summary/press release if full report unavailable. |
| **ACSC Small Business Cyber Security Guide** | `https://www.cyber.gov.au/resources-business-and-government/essential-cyber-security/small-business-cyber-security` | Lists typical IT posture assumptions for Australian SMBs by sector. |

### Backup web searches

```
[sector] small business IT staff Australia cybersecurity posture [current year]
ABS business characteristics IT security [sector] Australia
ACSC small business [sector] cyber risk Australia
```

### Typical time-to-patch by sector

| Source | URL | Query method |
|--------|-----|--------------|
| **Wordfence/Patchstack sector advisories** | See sections 1 and 4 above | Look for "X% of sites still unpatched N days after disclosure" statistics in advisory posts. These appear in high-severity plugin posts. |
| **Ponemon Institute / Veracode patch lag reports** | `https://www.veracode.com/state-of-software-security` | Annual. The "Time to Fix" chapter gives average patch lag by application type and sector. |

### Backup web searches

```
WordPress plugin patch lag days unpatched sites [sector] [current year]
average time to patch vulnerability small business Australia [current year]
Ponemon patch management time-to-remediate [current year]
```

---

## 10. Simulation Base Rates (Simulation Mode)

### Primary sources

| Parameter | Source | URL | Query method |
|-----------|--------|-----|--------------|
| **Business survival/closure risk** | VikingCloud 2025 SMB Threat Landscape Report | `https://www.vikingcloud.com/press-news/successful-cyberattacks-would-force-1-in-5-smbs-out-of-business-according-to-new-vikingcloud-research` | Search for "20% SMB close after cyberattack" — primary source replacing debunked "60% within 6 months" statistic |
| | Hiscox Cyber Readiness Report 2024 | `https://www.hiscox.com/articles/over-two-thirds-us-businesses-suffered-increase-cyber-attacks-reveals-annual-hiscox-cyber` | 20% of businesses reported cyberattack nearly rendered them insolvent |
| **Cost of breach (SMB)** | Microsoft SMB Cybersecurity Report | `https://cdn-dynmedia-1.microsoft.com/is/content/microsoftcorp/microsoft/final/en-us/microsoft-brand/documents/SMBCybersecurity-Report-Final.pdf` | Average total cost for SMB cyberattack: $254,445 |
| | IBM Cost of a Data Breach 2025 | `https://www.ibm.com/security/data-breach` | Global average $4.44M; US $10.22M; Ransom = 15% of total cost |
| | Hyetech Australia | `https://hyetech.com.au/` (blog/reports section) | AUD $97,000 average Australian SMB recovery cost |
| **Downtime & recovery** | Sophos State of Ransomware 2025 | `https://www.sophos.com/en-us/content/state-of-ransomware` | 53% recover within 1 week; 33% take 1–6 months; median recovery metrics |
| | BD Emerson 2026 Statistics | `https://www.bdemerson.com/article/small-business-cybersecurity-statistics` | 51% SMBs report 8–24 hours downtime; 50% take 24+ hours to recover |
| **Customer churn** | Hiscox 2024 + BD Emerson | See above | 43% lost customers after attack; 70% of consumers less likely to continue |
| **AI-era attack compression** | arXiv 2605.06713 (May 2025) | `https://arxiv.org/abs/2605.06713` | "Agentic AI and the Industrialization of Cyber Offense" — attack compression reducing time/skill/cost |
| | UK NCSC assessment | NCSC annual report and threat assessments | AI will "almost certainly continue to make cyber intrusion operations more effective and efficient through 2027" |
| **Australian attack rate** | ASD Annual Cyber Threat Report 2024–25 | `https://www.cyber.gov.au/about-us/view-all-content/reports-and-statistics/annual-cyber-threat-report-2024-2025` | 38% of Australian SMBs faced an attack attempt last year; 84,700 reports (1 every 6 minutes) |
| **Ransomware prevalence** | Verizon DBIR 2025 | `https://www.verizon.com/business/resources/reports/dbir/` | 88% of SMB breaches involve ransomware; exploitation increased 34% |
| **Cyber insurance penetration** | BD Emerson 2026 Statistics | See above | Only 18% of small businesses have cyber insurance |
| **Regulatory fines (AU)** | OAIC enforcement history | `https://www.oaic.gov.au/about-the-OAIC/our-regulatory-approach/guide-to-privacy-regulatory-action` | ACL penalty $5.8M (2023) establishes precedent for Privacy Act civil penalties |

### Industry daily rates (for downtime cost modeling)

| Industry | Estimated Daily Rate (AUD) | Source/Rationale |
|----------|---------------------------|------------------|
| Restaurant/Café | $1,200 | Lost revenue + staff wages + spoilage |
| Retail (independent) | $800 | Lost sales + staff wages |
| Allied Health Clinic | $1,500 | Appointment revenue + staff costs + rescheduling |
| Church/NFP | $400 | Limited transactional revenue, mostly operational |
| Education/Childcare | $600 | Per-student fees + staff + regulatory risk |
| Trades/Services | $900 | Per-job revenue + rescheduling costs |
| Other | $700 | Weighted average |

### Security posture multipliers

| Posture | Multiplier | Rationale |
|---------|------------|-----------|
| None (no IT, unpatched) | 1.0× | Baseline — unprotected exposure |
| Basic (Wordfence Free, no backups) | 0.6× | Basic protection, delayed patching (30-day free tier lag) |
| Moderate (Wordfence Premium, occasional backups) | 0.35× | Real-time protection, some backup coverage |
| Good (patched, offsite backups, MFA) | 0.15× | Defense in depth, rapid recovery capability |

### Location modifiers

| Location | Year 1 | Year 2 | Year 3+ | Rationale |
|----------|--------|--------|---------|-----------|
| Perth WA | 0.7× | 0.85× | 1.0× | Attacker scanning latency — less targeted initially |
| Sydney NSW | 1.0× | 1.0× | 1.0× | Major metro baseline |
| Melbourne VIC | 1.0× | 1.0× | 1.0× | Major metro baseline |
| Brisbane QLD | 1.0× | 1.0× | 1.0× | Major metro baseline |
| Regional Australia | 0.8× | 0.9× | 1.0× | Moderate latency as attackers expand targeting |
| Colorado USA | 1.1× | 1.1× | 1.1× | Higher baseline threat exposure (US market) |

### Mythos-era multiplier

Apply 1.35× compounding annual increase to attack probability from Year 2 onward:
- Year 1: 1.0×
- Year 2: 1.35×
- Year 3: 1.35² = 1.82×
- Year 4: 1.35³ = 2.46×
- Year 5: 1.35⁴ = 3.32×

**Source**: arXiv 2605.06713 (May 2025) and NCSC assessment documenting agentic AI attack compression reducing attacker time, skill, and cost requirements.

---

## Source Freshness Rules

1. **Always use the most recently published report** — check the publication date before extracting figures.
2. **OAIC and ACSC reports lag by ~3–6 months** — the latest available H1 report may reflect data from 6+ months ago. Note the reporting period when citing figures.
3. **Wordfence and Patchstack weekly posts are current** — these are the fastest-moving sources and should be checked first for active exploit confirmation.
4. **Coveware/Sophos ransom figures are annual or quarterly** — apply the most recent full-period figure; do not extrapolate forward without noting the extrapolation.
5. **If a primary source returns a 403/Forbidden or stream error**, move immediately to the next source in the table — do not retry the same URL.
