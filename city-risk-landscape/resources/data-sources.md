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

## Source Freshness Rules

1. **Always use the most recently published report** — check the publication date before extracting figures.
2. **OAIC and ACSC reports lag by ~3–6 months** — the latest available H1 report may reflect data from 6+ months ago. Note the reporting period when citing figures.
3. **Wordfence and Patchstack weekly posts are current** — these are the fastest-moving sources and should be checked first for active exploit confirmation.
4. **Coveware/Sophos ransom figures are annual or quarterly** — apply the most recent full-period figure; do not extrapolate forward without noting the extrapolation.
5. **If a primary source returns a 403/Forbidden or stream error**, move immediately to the next source in the table — do not retry the same URL.
