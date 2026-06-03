# Jakarta Migration Risk Assessment — Outreach Template

This resource contains the reusable outreach templates for the Jakarta Migration Risk Assessment offering. It is loaded by `Skill.md` when the selected offering is "Jakarta Migration Risk Assessment".

---

## Research Instructions (Executed Before Template Population)

Before populating either template, perform the following research steps:

### Step 1 — Identify Senior Technical Staff

1. **Visit the company website** and look for:
   - Leadership/About/Team pages
   - Job titles containing: CTO, Chief Technology Officer, Development Director, Engineering Director, Tech Lead, Technical Lead, Lead Developer, Software Architect, Solutions Architect, Principal Engineer, VP Engineering, Head of Engineering, or Founder/Co-founder (in micro companies)
   - Technical blog posts with author names and titles
   - Press releases mentioning technical leadership

2. **Priority order for targeting** (first match wins):
   - CTO / Chief Technology Officer
   - VP Engineering / Head of Engineering
   - Development Director / Engineering Director
   - Software Architect / Solutions Architect
   - Tech Lead / Technical Lead / Lead Developer
   - Principal Engineer / Senior Engineer
   - Founder / Co-founder (for micro companies with <10 staff)

3. **Capture details**:
   - Full name (for personalization)
   - Job title (for role-specific messaging)
   - Any publicly mentioned technology focus (Java, enterprise systems, etc.)
   - Direct phone number if listed (Contact page, team directory, corporate directory, or press releases)

### Step 2 — LinkedIn Fallback (if website lacks staff info)

If the company website does not list staff or leadership:

1. **Search LinkedIn** using: `site:linkedin.com "[Company Name]" CTO` or similar role searches
2. **Look for**:
   - Current employees with senior technical titles
   - Founders who list technical backgrounds
   - Mutual connections who can provide warm introductions

3. **Verify company size** aligns with target (1-99 employees for this offering)

### Step 3 — Assess Company Suitability

Verify this company is a good fit for Jakarta migration assessment:

| Indicator | Good Fit Sign |
|-----------|---------------|
| Technology stack | Mentions Java, Java EE, J2EE, Spring, enterprise applications |
| Job postings | Seeking Java developers, mentioning legacy system maintenance |
| Products/services | Enterprise software, B2B platforms, internal business systems |
| Blog/content | Technical posts about Java frameworks, dependency management |
| Company age | Established company (5+ years) more likely to have legacy Java EE |

**Skip companies that**:
- Clearly use modern cloud-native stacks only (Node.js, Go, Python, serverless)
- Are brand new startups with no legacy codebase
- Have publicly announced recent Jakarta migrations

### Step 4 — Localise Content

Match spelling and phrasing to `{{COUNTRY}}`:
- Australia / UK: "localise", "programme", "organisation", "centre", "analyse", "behaviour"
- United States: "localize", "program", "organization", "center", "analyze", "behavior"

---

## Email Template

```
Subject: Jakarta EE migration — quick question about {{COMPANY_NAME}}'s Java stack

Hi {{CONTACT_NAME}},

I came across {{COMPANY_NAME}} while researching {{INDUSTRY}} companies in {{CITY}} that might be navigating the Java EE to Jakarta EE transition.

If you're responsible for {{COMPANY_NAME}}'s technical architecture, I'd value a brief conversation about your current Java EE setup and any migration plans you may be considering.

The namespace change from `javax.*` to `jakarta.*` (and the ripple effects through dependencies, frameworks, and build tools) has created significant friction for teams maintaining legacy Java EE applications. We've helped several {{BUSINESS_SIZE}} {{INDUSTRY}} companies through this transition.

Our assessment process combines:

- **Automated tooling** that scans your codebase and dependency tree for migration blockers
- **Deep bytecode analysis of transitive dependencies** — catching compatibility issues that surface-only scans miss
- **Previous industry experience** with javax → jakarta migrations across similar {{INDUSTRY}} environments
- **Supply-chain security assessment** identifying vulnerabilities while you're still on the javax stack

The deliverable is a detailed risk assessment and refactoring guide (typically 3-5 PDF reports) that your team can use to estimate effort, plan phases, and avoid common migration pitfalls.

This is a paid engagement, but we start with a no-obligation discovery call to confirm the assessment is appropriate for your situation.

Worth a 15-minute conversation? Just reply with a time that works, or send your preferred contact method.

Best regards,

[Your Name]
[Your Title]
[Your Company]
[Website] | [Email] | [Phone]
```

---

## LinkedIn Message Template

```
Hi {{CONTACT_NAME}},

Quick question about {{COMPANY_NAME}}'s Java stack — are you currently managing any applications still on Java EE (javax namespace) that are candidates for Jakarta EE migration?

The javax → jakarta transition creates hidden complexity: transitive dependency conflicts, deprecated API usage, and supply-chain security gaps that surface-only analysis misses.

We run deep bytecode scanning assessments for {{BUSINESS_SIZE}} {{INDUSTRY}} companies in {{CITY}}. Our process combines automated tooling with hands-on migration experience, producing detailed risk reports and refactoring guides.

If there's a potential fit, happy to start with a brief call to understand your architecture and confirm the assessment would be valuable.

Worth a conversation?

[Your Name]
```

---

## Phone Research Brief

When `Output format == "Phone"`, do not generate a scripted conversation. Instead, produce a concise dot-point research brief the caller can reference during a real call.

### Research Steps (Before Generating the Brief)

1. **Visit the company website** and capture:
   - Products, services, and value proposition
   - Technology stack signals: Java, Java EE, J2EE, Spring, Jakarta EE, enterprise applications, build tools (Maven, Gradle), application servers
   - Staffing signals: technical leadership roles, engineering team size, any Java-specific job postings
   - Content signals: technical blog posts about Java frameworks, dependency management, or legacy system modernisation

2. **If the website lacks detail**, search LinkedIn for the company and review:
   - Current employees with Java, Spring, or enterprise Java titles
   - Company size and headcount
   - Any posts or articles mentioning Java EE, Jakarta EE, or migration projects

3. **Cross-reference with the collected parameters** (`{{COUNTRY}}`, `{{CITY}}`, `{{INDUSTRY}}`, `{{BUSINESS_SIZE}}`) and localise spelling.

### Brief Format

```
**Phone Research Brief — {{COMPANY_NAME}}**

- **Company:** {{COMPANY_NAME}}, {{BUSINESS_SIZE}}, {{CITY}}, {{COUNTRY}}
- **Contact Details:**
  - **Name:** {{CONTACT_NAME}} [or "Not found — dial main line and ask"]
  - **Role:** {{CONTACT_ROLE}} [e.g. CTO, Engineering Director, Architect, Founder]
  - **Phone:** {{CONTACT_PHONE}} [direct line, mobile, or main company line with extension/transfer instructions]
- **Industry Focus:** {{INDUSTRY}} [add any specifics found, e.g. "B2B SaaS serving healthcare clinics"]
- **Products or Services:** [2–3 sentence summary of what the company sells or delivers, and who their customers are]
- **Tech Stack:** [relevant aspects: Java EE / Jakarta EE status, Spring usage, build tools, application servers, enterprise applications, any legacy system signals]
- **Suggested Offering Focus:**
  - Jakarta Migration Risk Assessment — paid engagement combining automated bytecode scanning, transitive dependency analysis, and hands-on migration experience
  - Key talking points: hidden compatibility blockers, deprecated API usage, ripple effects through dependencies and build tools, supply-chain security gaps while still on javax stack
- **Leading Questions:**
  1. [Tailored question 1, e.g. "Are you currently managing any applications still on Java EE (javax namespace) that are candidates for Jakarta EE migration?"]
  2. [Tailored question 2, e.g. "What's your current visibility into the hidden compatibility blockers — the transitive dependency conflicts that only surface during the build?"]
```

### Tone Guidance for the Call

- Respect technical competence — assume the recipient understands Java EE, Jakarta EE, dependency management, and migration complexity
- Be specific about capabilities — mention concrete techniques (bytecode scanning, transitive dependency analysis)
- No fear-mongering — present risks factually, not dramatically
- Clear value proposition — the assessment saves them manual effort and catches issues they'd likely miss
- Low-pressure CTA — discovery call first, paid engagement only if mutually confirmed as appropriate

---

## Placeholder Reference

| Placeholder | Source Parameter |
|-------------|------------------|
| `{{COUNTRY}}` | Target country |
| `{{CITY}}` | Target city/region |
| `{{INDUSTRY}}` | Industry sector |
| `{{BUSINESS_SIZE}}` | Business size (Micro: 1-9, Small: 10-99, Medium: 100-199) |
| `{{COMPANY_NAME}}` | Company website domain (extracted during research) |
| `{{CONTACT_NAME}}` | Name of identified senior technical contact |
| `{{CONTACT_ROLE}}` | Job title of the contact (Phone output, for internal reference) |
| `{{CONTACT_PHONE}}` | Direct phone number of the contact, or main company line with instructions (Phone output) |

All tokens must be replaced before presenting the final message to the human.

---

## Tone Guidelines

- **Respect technical competence** — Assume the recipient understands Java EE, Jakarta EE, dependency management, and migration complexity
- **Be specific about capabilities** — Mention concrete techniques (bytecode scanning, transitive dependency analysis)
- **No fear-mongering** — Present risks factually, not dramatically
- **Clear value proposition** — The assessment saves them manual effort and catches issues they'd likely miss
- **Low-pressure CTA** — Discovery call first, paid engagement only if mutually confirmed as appropriate

---

## Developer Social Scanning — Offering-Specific Signals

When Developer Social Scanning Mode is triggered for this offering, load `resources/developer-social-scanning.md` for the shared scanning framework (platform strategy, geo-filtering, scoring, output format, and handoff). The definitions below are the offering-specific inputs that the shared resource requires.

---

### Platform Query Variants

Supply these query variants to the shared resource's Step 2 platform searches.

> **Execution order note:** For the Jakarta Migration offering, job boards and direct company research return far more actionable geo-specific leads than Stack Overflow, Reddit, or GitHub, which yield mostly global noise. **Run Priority 1 (job boards) and Priority 2 (company lists) first.** Only proceed to SO/Reddit/GitHub if Priority 1–2 return fewer than 5 leads. Recruiter-posted job listings are acceptable leads — contact the recruiter directly, identify the client company, and proceed from there.

#### Priority 1 — Job Boards (run first; highest geo-specificity)

Run these searches **before** social platforms. Job postings signal active Java modernisation intent and reveal both the company and the stack.

**SEEK (Australia):**
- `site:seek.com.au "Java" "Spring" "{{CITY}}" OR "{{COUNTRY}}" enterprise OR legacy OR modernis`
- `site:seek.com.au "Java EE" OR "JBoss" OR "Spring Boot" "{{CITY}}" developer`
- `site:seek.com.au "Java" "Spring Boot" "legacy" OR "modernisation" OR "migration" "{{CITY}}"`
- Read each returned job ad in full — capture company name (or recruiter contact if anonymous), stack details, and modernisation language

> **Redirect note:** SEEK may redirect `www.seek.com.au` to `au.seek.com` — if a URL fails with a redirect error, retry with the `au.seek.com` subdomain directly.

**LinkedIn Jobs:**
- `site:linkedin.com/jobs "Java" "Spring" "{{CITY}}" "legacy" OR "modernis" OR "enterprise"`
- `site:linkedin.com/jobs "Java EE" OR "Spring Boot 2" OR "JBoss" "{{CITY}}"`
- `site:linkedin.com/jobs "Java" "{{CITY}}" "javax" OR "Jakarta EE" OR "Spring Framework"`

**Seek / Indeed / other local job boards:**
- `"Java" "Spring" "{{CITY}}" "legacy" OR "modernisation" site:indeed.com.au`
- `"Java" "Spring Boot" "{{CITY}}" "enterprise" developer site:glassdoor.com.au`

**From job ad results, score each company using these signals:**
- Explicitly mentions "modernisation", "migration", "legacy platform" → Tier 1 (+3)
- Mentions Spring Boot version (any), JPA, JBoss, WebLogic, WebSphere → Tier 2 (+2)
- Mentions Java + enterprise context without stack detail → Tier 3 (+1)
- If posted via a recruiter agency with the company anonymous: record the recruiter's contact details — they are a valid path to the lead

#### Priority 2 — Direct Company Research (run second)

Search for known Perth/`{{CITY}}`-based Java ISVs and enterprise software companies directly. This surfaces established companies whose public repos or Docker images contain `javax.*` evidence even if they're not actively posting about migration pain.

**Company list searches:**
- `"{{CITY}}" OR "{{CITY_STATE}}" enterprise software company Java Spring employees 2024 2025`
- `top software companies "{{CITY}}" Java enterprise OR B2B OR SaaS 2025`
- `"{{CITY}}" Java software ISV "Spring" OR "JBoss" OR "enterprise applications"`

**For each identified company, check their public GitHub org for javax signals:**
- Visit `github.com/[company-name]` — look for `javax.*` in README, Dockerfiles, `pom.xml`, or `build.gradle` snippets
- Search: `site:github.com "[company-name]" "javax" OR "java ee"` to surface any public code or issues

**Company size check:**
- Check LinkedIn company page, Crunchbase, RocketReach, or ZoomInfo for employee count
- Target: 10–99 employees; note but don't discard Micro (1–9) if technical depth is strong
- Flag and deprioritise companies with >200 employees

#### Priority 3 — Stack Overflow (run if Priority 1–2 return < 5 leads)

Stack Overflow geo-filtering is weak — most users don't disclose location. Expect low geo-signal yield; use to find individual developers whose profiles can be traced to `{{CITY}}`-area companies.

- `site:stackoverflow.com "javax" "jakarta" migration [current year]` — check answerer/asker profile locations
- `site:stackoverflow.com "Spring Boot 3" "javax" migration "still on" OR "haven't migrated"` — look for company context in the question body
- `site:stackoverflow.com "javax.persistence" OR "javax.servlet" migration "Spring Boot 3" [current year]`
- `site:stackoverflow.com "legacy Java EE" OR "Java EE 8" OR "JBoss" OR "WebLogic" "migration" "team" OR "company"` — look for company-context mentions

#### Priority 4 — GitHub (run if Priority 1–2 return < 5 leads)

GitHub is most useful for finding `javax.*` usage in public company repos, not for finding geo-tagged pain posts.

- For each company identified in Priority 2, inspect their public GitHub org directly (more effective than generic searches)
- `site:github.com "javax to jakarta" issues OR discussions [current year]` — check issue author location/employer in their profile
- `site:github.com "[company name from Priority 1-2]" "javax" OR "java ee"` — targeted per-company check

#### Priority 5 — LinkedIn Posts and Reddit (run if Priority 1–2 return < 5 leads)

- `site:linkedin.com "Jakarta EE" "migration" "{{CITY}}" [current year]`
- `site:linkedin.com "Java EE to Jakarta EE" OR "javax to jakarta" "{{CITY}}"`
- `site:linkedin.com "legacy Java EE" "refactor" OR "modernise" "{{CITY}}"`
- `site:reddit.com/r/java "javax to jakarta" "company" OR "team" "still on" OR "stuck" [current year]`
- `site:reddit.com/r/java "Java EE 8" OR "Spring Boot 2" "haven't migrated" OR "still running" [current year]`

> **Note:** LinkedIn `site:` searches frequently return no content due to login walls. If a LinkedIn URL fails to load, skip it — do not retry. Use job board and company research paths instead.

#### Priority 6 — Hacker News and Dev.to (lowest yield; run last if shortlist still < 5)

- `site:news.ycombinator.com "Jakarta EE" OR "javax to jakarta" migration`
- `site:dev.to "javax to jakarta" OR "Jakarta EE migration" [current year]`
- `site:medium.com "Java EE to Jakarta EE" "small team" OR "our company" migration blockers`
- `site:dzone.com "Jakarta EE" "migration" "small team" OR "legacy"`

---

### Signal Taxonomy

#### Tier 1 — High-Confidence Signals (score +3 each)

| Signal | Example |
|--------|---------|
| Explicit javax → jakarta migration blocker | "We can't upgrade because our third-party library still uses `javax.persistence`" |
| Mentions specific Java EE artefacts that are hard to migrate | `javax.ejb`, `javax.faces`, `javax.ws.rs`, `javax.mail`, JBoss EAP, WebLogic, WebSphere |
| States the company is actively planning or stuck mid-migration | "We started the migration last quarter but hit dependency hell" |
| Mentions transitive dependency conflicts as the specific problem | "Half our dependencies chain back to a javax version" |
| Posts a question with no accepted answer | Unanswered SO question about javax → jakarta conflict |
| LinkedIn post from a senior technical contact describing migration struggles | CTO post: "We're evaluating Jakarta EE 10 migration timelines" |

#### Tier 2 — Medium-Confidence Signals (score +2 each)

| Signal | Example |
|--------|---------|
| Running Java 8 or Java 11 with no mention of 17+ | Implies older ecosystem, likely pre-Jakarta |
| Mentions Spring Boot < 3.x or Spring Framework < 6 | These versions use javax; upgrade requires jakarta migration |
| Uses JBoss, WildFly, WebLogic, or WebSphere (non-Liberty) application servers | Legacy app server environments strongly correlated with Java EE |
| References Java EE 7 or Java EE 8 codebase | Directly in scope for the offering |
| Uses Maven/Gradle with `javax.*` group IDs visible in pom.xml or build.gradle snippets | Direct code signal |
| Company GitHub repo has unresolved javax → jakarta migration issues open for 3+ months | Indicates stuck or deprioritised effort |

#### Tier 3 — Weak/Contextual Signals (score +1 each)

| Signal | Example |
|--------|---------|
| General Java enterprise developer context (no explicit javax mention) | Spring developer at a 20-person software firm |
| Company description suggests Java-first development | "Enterprise Java solutions" on LinkedIn profile |
| Job posting for Java EE or Spring developer | Indicates Java codebase exists but stack unclear |
| Active in Java/enterprise forums generally | Frequent contributor to r/java, Stack Overflow Java tag |

#### Disqualifying Signals (exclude the lead entirely)

- Explicitly states migration is complete: "We finished migrating to Jakarta EE last month"
- Uses cloud-native/serverless stack exclusively (Quarkus native, Micronaut, Lambda, Node.js) with no enterprise Java mention
- Clearly a student or individual contributor with no company context
- Company size signals suggest >200 employees (outside the sweet spot; note and skip)
- Post is more than 18 months old with no recent follow-up activity

---

### Scan-Sourced Opening Line Examples

Use one of these as the personalised opening line in the generated outreach message (Step 7 of the shared scanning resource):

- *"I came across your Stack Overflow question about javax.persistence compatibility issues…"*
- *"I noticed your GitHub issue on the javax → jakarta migration blocker in [repo]…"*
- *"I saw your LinkedIn post about your team's Jakarta EE upgrade timeline…"*
- *"I spotted your Reddit thread about transitive dependency conflicts during your Jakarta EE migration…"*
- *"I saw your SEEK listing for a Senior Java Developer — the mention of Spring Boot modernisation caught my attention…"* (job-posting lead)
- *"I noticed your GitHub repo still uses javax.net.ssl environment configuration — I wanted to ask about your Jakarta migration roadmap…"* (public repo signal)
- *"I came across [company] through a recruiter listing for a Java engineer, and your Spring + JPA stack caught my attention…"* (recruiter-sourced lead)
