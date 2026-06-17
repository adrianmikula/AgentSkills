---
name: AI-Era Vulnerability Scanner
description: Scan a code repository or public-facing website for AI-era security vulnerabilities: supply chain risks, CI/CD misconfigs, zero-trust gaps, secrets sprawl, crypto-agility, LLM/MCP guardrail absence, and observable production weaknesses. Not a CVE scanner.
---

## Overview

This Skill guides security scanning for AI-era threats — vulnerabilities that have emerged or escalated due to AI-assisted development, large package ecosystems, and agentic workflows. It operates in two modes: **Dev Mode** (scanning a code repository) and **Prod Mode** (scanning a public-facing website).

---

## Mode Detection

Before scanning, determine the scan mode from the target:

| Target | Mode | Scope |
|--------|------|-------|
| Local file path or repository | **Dev Mode** | Source code, config files, CI pipelines, lockfiles, internal architecture |
| URL (`http://` or `https://`) | **Prod Mode** | HTTP headers, HTML source, public JS, TLS config, observable endpoints |

- If the target is a URL, use **Prod Mode** — load `resources/prod-mode-website-scan.md` and work through the Prod Mode Scan Checklist below.
- If the target is a local path or repository, use **Dev Mode** — work through the Dev Mode Scan Checklist below and load the relevant dev-mode resource files.
- Prod Mode is **passive observation only** — analyse only what the site serves to a normal browser request. No port scanning, fuzzing, or active penetration testing.

---

## Report Format Selection

Before starting the scan, ask the human to choose the output format:

| Option | Audience | Content |
|--------|----------|---------|
| **Detailed technical summary** | Security engineers, developers, architects | Full checklist results, exact headers, curl commands, code snippets, endpoint details, exploitation steps, remediation commands |
| **High-level business impact summary** | Executives, product owners, non-technical stakeholders | Risk ratings in business terms, breach-impact descriptions, cost-to-fix relative assessments, prioritised remediation roadmap, no raw technical artifacts |

**How to ask:** Present both options clearly. Example:

> Before I begin the scan, which output format would you like?
> 1. **Detailed technical summary** — full findings with headers, endpoints, and exact remediation commands
> 2. **High-level business impact summary** — risk ratings, business impact, and prioritised action plan in plain language

Record the selection and tailor the final report to it. Do not mix detailed technical artifacts into a business summary, and do not omit critical risk ratings from a technical summary.

---

## Business Impact Summary — HTML Output Specification

When the human selects **High-level business impact summary**, the output MUST be a standalone HTML file delivered via `present_files`. Plain text, markdown, or inline prose is not acceptable for this format. Follow this specification exactly.

### Required Sections (in order)

1. **Cover** — dark background (`#1a1a2e`), company name + "AI-Era Security Audit — Business Impact Summary" headline in Playfair Display serif, scan metadata (target, scan type, date, audience) in a flex row of labelled fields.
2. **Executive Summary** — red accent background (`#c0392b`), 2–3 sentences in plain English naming the most urgent risk and why it is dangerous now (AI context). No bullet points.
3. **Finding Overview Scorecard** — 4-card grid showing counts for 🔴 Critical, 🟠 High, 🟡 Medium, ✅ Pass. Large Playfair Display numerals, colour-coded backgrounds.
4. **Findings & Business Risk** — one card per finding. Each card has: a severity badge (top right), a Threat Evolution badge (e.g. `+25%` or `NEW`, styled as a small monospace badge indicating the change in danger level over the past 12 months, placed next to the severity badge), impact category tags (small coloured badges listed inline below the severity badge), a plain-English title, 2–3 plain-English paragraphs (what it is, why it matters now, consequence if exploited), and a three-column impact row (Exploit Difficulty / Breach Impact / Fix Cost). No technical commands or code blocks in this section.
5. **AI-Era Context Callout** — dark panel with icon, headed "Why 'We Haven't Been Hacked Yet' Is No Longer a Valid Risk Assessment". Cites current HTB/benchmark data (numeric %). 2–3 sentences. Mandatory — include in every business report.
6. **Remediation Roadmap** — dark background (`#1a1a2e`), three numbered phases: This Week / Within 2 Weeks / Ongoing. Each phase has a colour-coded tag (red/orange/green), a heading, and a bullet list of actions in plain English. No code or commands.
7. **Footer** — company name, domain, report date, "Passive external observation only", "Confidential".

### Design Tokens (use exactly)

```
--ink: #1a1a2e         Background: dark panel
--paper: #f8f7f2       Background: page
--accent: #c0392b      Executive summary bar, Phase 1 circle, Critical badges
--amber: #e67e22       High badges, Phase 2 circle
--green: #27ae60       Pass badges, Phase 3 circle
--slate: #5a6478       Muted label text
--rule: #d5d0c5        Divider lines

Display typeface: 'Playfair Display' (Google Fonts) — cover h1, section h2, score numerals
Body typeface: 'Inter' (Google Fonts) — all other text
```

### Impact Tag Badges

| Tag | Background | Text Colour |
|-----|------------|-------------|
| Account Access | `#e8f0fe` | `#1a73e8` |
| Data Leak | `#fef3e8` | `#e67e22` |
| Financial Theft | `#e6f7e6` | `#1b8a1b` |
| Ransomware | `#fce8e6` | `#c0392b` |
| Outage | `#f3e8ff` | `#7b1fa2` |
| Defacement | `#e0f7fa` | `#00838f` |

Impact tag badges: `font-size: 9px`, `font-weight: 600`, `letter-spacing: 0.04em`, `text-transform: capitalize`, `padding: 2px 8px`, `border-radius: 3px`, `display: inline-block`, `margin: 0 4px 4px 0`. Listed inline after the severity badge.

### Threat Evolution Badge

Threat Evolution badge: `font-size: 10px`, `font-weight: 700`, `font-family: 'JetBrains Mono', monospace`, `letter-spacing: 0.04em`, `padding: 3px 8px`, `border-radius: 4px`, `background: #1a1a2e`, `color: #f1c40f`, `display: inline-block`, `margin-left: 6px`. Placed inline next to the severity badge.

### Severity Card Colours

| Severity | Background | Border |
|----------|------------|--------|
| Critical | `#f8e8e6` | `#e74c3c` with 4px left border |
| High     | `#fef5ec` | `#e67e22` with 4px left border |
| Medium   | `#fffde7` | `#f1c40f` with 4px left border |
| Pass     | `#eafaf1` | `#27ae60` with 4px left border |

### Writing Rules for Business Section

- **Never** use the words: CVE, HTTP header, REST API, JSON, endpoint, `.htaccess`, `wp-json`, `functions.php`, or any shell command. These belong only in the technical report.
- **Use instead:** "login page", "software version", "admin panel", "browser security controls", "website configuration".
- Every finding must answer three questions in plain English: What is exposed? Why is this worse in 2026 than it was before? What happens to the business if it is exploited?
- Breach consequences must reference business outcomes: "your clients' data", "your site redirects visitors to scam pages", "you are locked out of your own website", "your agency's reputation".

### HTML Structure Rules

- Single self-contained `.html` file — no external CSS files, no JavaScript frameworks.
- All fonts loaded via Google Fonts `@import` in the `<style>` block.
- All section padding: `56px 72px` (desktop). No responsive breakpoints required.
- All `<pre>` and `<code>` tags are forbidden in the business report.
- Severity badges: `font-size: 10px`, `font-weight: 700`, `letter-spacing: 0.12em`, `text-transform: uppercase`, `padding: 4px 10px`, `border-radius: 4px`.
- Include a `@media print` block: `{ .finding { break-inside: avoid; } .phase { break-inside: avoid; } }`

### File Naming

Save as: `[domain-slug]-business-report.html`
Example: `thewebshop-business-report.html`

---

## Impact Rating Key

| Rating | Meaning |
|--------|---------|
| 🔴 Critical | Full credential/infra/machine compromise, self-propagating, or data exfiltration at scale |
| 🟠 High | Significant exposure window, auth bypass, lateral movement potential, or enables chaining |
| 🟡 Medium | Information disclosure, indirect risk, or requires chaining with other weaknesses |

---

## Dev Mode Scan Checklist

### Group A — Supply Chain (npm / PyPI)

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 1 | Release-age cooldown configured | 🔴 Critical | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +95% | `.npmrc` missing `min-release-age`; pnpm/bun/uv equivalents absent |
| 2 | Lifecycle scripts disabled | 🔴 Critical | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +150% | `.npmrc` missing `ignore-scripts=true`; no pnpm `onlyBuiltDependencies` allowlist |
| 3 | Transitive dependency surface audited | 🟠 High | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +95% | >500 packages for a small project; AI-added deps with no human review |
| 4 | Deps have fast time-to-patch | 🟠 High | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +35% | Low OpenSSF Scorecard scores; unmaintained packages; single-maintainer packages |
| 5 | No git-URL dependencies | 🔴 Critical | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +95% | `git+https://`, `github:`, `gitlab:` in `package.json`; `.npmrc` missing `allow-git=none` |
| 6 | SLSA provenance not sole trust signal | 🟠 High | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak | +95% | Pipeline accepts packages on provenance alone; no behavioral analysis at install time |

### Group B — CI/CD & Pipeline

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 7 | Supply chain checks in pipeline | 🟠 High | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak, ⏱️ Outage | +70% | No `npm audit`; no SCA tool (socket.dev/Snyk); no lockfile; `npm install` instead of `npm ci` |
| 8 | GitHub Actions hardened | 🔴 Critical | 💀 Ransomware, 💰 Financial Theft, 📦 Data Leak, 🎨 Defacement | +70% | `pull_request_target` + fork checkout; floating `uses:` refs (`@main`); shared cache scope |
| 9 | Fully automated release pipeline | 🟠 High | 🎨 Defacement, ⏱️ Outage, 💀 Ransomware | +95% | Manual deploy steps; devs with direct prod credentials; no automated rollback |
| 10 | No secrets sprawl | 🔴 Critical | 🔑 Account Access, 📦 Data Leak, 💰 Financial Theft | +35% | Hardcoded tokens/keys in code; `.npmrc` auth tokens committed; MCP config files with embedded keys |

### Group C — Zero-Trust Inner Perimeter

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 11 | Build scripts use least privilege | 🔴 Critical | 💀 Ransomware, ⏱️ Outage, 📦 Data Leak | +70% | `sudo` in setup scripts; Docker steps running as root; CI jobs with over-broad IAM roles |
| 12 | Build/test tooling is audited | 🟠 High | 💀 Ransomware, 📦 Data Leak, ⏱️ Outage | +40% | `vm2` in use; EOL headless browser versions; unaudited Jest/Vitest plugins; EOL test frameworks |
| 13 | Zero-trust applied internally | 🔴 Critical | 🔑 Account Access, 📦 Data Leak, 💀 Ransomware | +100% | IP-only allowlisting for internal services; no mTLS; CI runners with broad internal network access |

### Group D — Frontend & Code Exposure

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 14 | No source maps or raw JS in production | 🟡 Medium | 📦 Data Leak, 🔑 Account Access | +30% | `.map` files served publicly; `devtool: 'source-map'` in prod config; unminified bundles |
| 15 | Security gates on AI-generated code | 🟠 High | 📦 Data Leak, 🎨 Defacement, 🔑 Account Access | +90% | No SAST on PRs; `[skip ci]` bypass allowed; no minimum reviewer enforcement |

### Group E — Auth & AI Integration

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 16 | Crypto-agility / quantum-safe path | 🟠 High | 📦 Data Leak, 💰 Financial Theft | +100% | Hardcoded `RS256`/`ES256`; no algorithm abstraction; no PQC migration plan |
| 17 | LLM/MCP guardrails present | 🔴 Critical | 📦 Data Leak, 🔑 Account Access, 🎨 Defacement, 💰 Financial Theft | +90% | Unsanitized user input into prompts; over-permissioned MCP tools; no output filtering; MCP packages unpinned |

### Follow-Up Options (after initial results)

After all categories (1–17) have been scored and documented and the initial results have been presented to the human, ask which follow-up they want:

> **Which analysis would you like next?**
>
> **A — Cost-to-fix analysis:** Load `resources/ai-era-cost-estimation.md` and produce cost-to-exploit and cost-to-fix estimates for each finding.
>
> **B — Worst-case scenario:** Load `resources/worst-case-synthesis.md` and produce a single worst-case scenario block identifying the most damaging real-world outcome achievable by chaining the identified findings.
>
> **C — Both:** Run cost estimation first, then worst-case scenario synthesis.

After the human selects, execute the chosen follow-up(s) and present the results.

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| 18 | Follow-up selected by human | — | — | — | Human chooses A (cost-to-fix), B (worst-case), or C (both). Default: ask — do not skip. |

---

## Dev Mode Escalation Triggers

Stop and flag immediately when:

- Any `git+https://` or `github:` dependency found in `package.json`
- `pull_request_target` workflow that checks out `refs/pull/.../merge` (Pwn Request pattern)
- Credentials or API keys found in committed files (including `.npmrc`, `.env`, MCP config)
- Build or CI steps running as root with access to production credentials
- LLM/MCP integration with no input sanitization and shell/filesystem tool access

---

## Prod Mode Scan Checklist

### Group F — Public Website Scan (Passive Observation)

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| P1 | Tech stack fingerprinting | 🟡 Medium | 📦 Data Leak, 🎨 Defacement | +25% | `X-Powered-By` header; `<meta name="generator">`; `/wp-content/` URL patterns; JS framework globals (`React`, `Vue`, `Angular`) |
| P2 | Exposed JS dependencies | 🟠 High | 📦 Data Leak, 🎨 Defacement, 🔑 Account Access | +30% | CDN `<script>` tags with version strings; webpack chunk names revealing packages; known-vulnerable library fingerprints (jQuery <3.5, Angular 1.x, Lodash <4.17.21) |
| P3 | TLS & encryption posture | 🟠 High | 📦 Data Leak, 🔑 Account Access | +15% | TLS version; key exchange algorithm (classical-only vs hybrid PQC); HSTS presence/max-age; certificate details |
| P4 | Auth protocol exposure | 🟠 High | 🔑 Account Access | +45% | Session cookie flags (`Secure`, `HttpOnly`, `SameSite`); `.well-known/openid-configuration`; login form patterns; MFA indicators |
| P5 | HTTP security headers | 🟡 Medium | 🎨 Defacement, 📦 Data Leak | +25% | Missing/weak CSP; missing `X-Frame-Options`; permissive CORS (`Access-Control-Allow-Origin: *`); missing `Referrer-Policy` |
| P6 | Information leakage | 🟠 High | 📦 Data Leak, 🔑 Account Access | +35% | Source maps publicly accessible (`.js.map` returning 200); `Server` header with version; verbose error pages; exposed API docs / GraphQL introspection |
| P7 | AI-era threat assessment | 🔴 Critical | 🔑 Account Access, 📦 Data Leak, 💰 Financial Theft | +85% | LLM API keys in client JS (`sk-proj-`, `sk-ant-`); chatbot/AI widgets; direct browser-to-LLM API calls; exposed agent/MCP endpoints; prompt injection surfaces |

### Follow-Up Options (after initial results)

After all categories (P1–P7) have been scored and documented and the initial results have been presented to the human, ask which follow-up they want:

> **Which analysis would you like next?**
>
> **A — Cost-to-fix analysis:** Load `resources/ai-era-cost-estimation.md` and produce cost-to-exploit and cost-to-fix estimates for each finding.
>
> **B — Worst-case scenario:** Load `resources/worst-case-synthesis.md` and produce a single worst-case scenario block identifying the most damaging real-world outcome achievable by chaining the identified findings.
>
> **C — Both:** Run cost estimation first, then worst-case scenario synthesis.

After the human selects, execute the chosen follow-up(s) and present the results.

| # | Check | Impact | Tags | Threat Evolution | Look For |
|---|-------|--------|------|-----------------|----------|
| P8 | Follow-up selected by human | — | — | — | Human chooses A (cost-to-fix), B (worst-case), or C (both). Default: ask — do not skip. |

## Prod Mode Escalation Triggers

Stop and flag immediately when:

- LLM API keys found in client-side JavaScript (`sk-proj-`, `sk-ant-`, `AIzaSy`)
- Source maps publicly accessible exposing full application source
- Session cookies missing `Secure` flag (credentials sent over HTTP)
- TLS 1.0 or 1.1 still enabled (vulnerable to downgrade attacks)
- Direct browser-to-LLM-API calls with no backend proxy
- GraphQL introspection enabled in production (full API schema exposed)

---

## Conditional Policy Resources

Load the following resources when scanning the relevant area:

### Dev Mode Resources

| Scan Area | Resource | Load When |
|-----------|----------|-----------|
| npm/PyPI packages, lockfiles, `.npmrc`, `package.json` | `resources/supply-chain-npm.md` | Reviewing dependency configuration or supply chain posture |
| CI/CD workflows, GitHub Actions, pipeline config | `resources/ci-cd-pipeline-security.md` | Reviewing `.github/workflows/`, `Jenkinsfile`, deployment pipelines |
| Build scripts, Dockerfiles, test frameworks, network config | `resources/zero-trust-inner-perimeter.md` | Reviewing `Makefile`, `Dockerfile`, test runner config, internal service access |
| Frontend build config, JS bundles, PR/code review process | `resources/frontend-and-ai-code.md` | Reviewing `webpack.config.js`, `vite.config.ts`, frontend output, branch protection |
| Auth code, JWT config, cryptographic libraries | `resources/crypto-agility.md` | Reviewing authentication, token signing, encryption configuration |
| LLM integrations, MCP server config, AI agent code | `resources/llm-mcp-guardrails.md` | Any file referencing LLM APIs, MCP servers, or agent workflows |
| Cost estimation after scan complete | `resources/ai-era-cost-estimation.md` | After all findings have been identified and scored |

### Prod Mode Resources

| Scan Area | Resource | Load When |
|-----------|----------|-----------|
| Public website URL (all prod-mode categories P1–P7) | `resources/prod-mode-website-scan.md` | Scanning a public-facing website for observable AI-era vulnerabilities |
| WordPress-specific passive enumeration | `resources/prod-mode-wordpress-scan.md` | When `X-Powered-By`, `/wp-json/`, `robots.txt`, or `<meta name="generator">` indicates WordPress during a prod-mode scan |
| Cost estimation after scan complete | `resources/ai-era-cost-estimation.md` | After all findings have been identified and scored |

---

## Related Skills

- **City Risk Landscape** — use this skill *before* scanning a specific company, when the human wants to identify which businesses in a city to target. It scores Perth (or target-city) SMB industries by AI attack likelihood and customer data sensitivity, then hands off here once a specific business has been selected.
- **Business Outreach Generator** — after completing a scan, use this skill to generate personalised outreach emails, LinkedIn messages, or phone briefs for the scanned business.
