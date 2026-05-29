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
| `{{CONTACT_ROLE}}` | Job title of the contact (for internal reference, not used in templates) |

All tokens must be replaced before presenting the final message to the human.

---

## Tone Guidelines

- **Respect technical competence** — Assume the recipient understands Java EE, Jakarta EE, dependency management, and migration complexity
- **Be specific about capabilities** — Mention concrete techniques (bytecode scanning, transitive dependency analysis)
- **No fear-mongering** — Present risks factually, not dramatically
- **Clear value proposition** — The assessment saves them manual effort and catches issues they'd likely miss
- **Low-pressure CTA** — Discovery call first, paid engagement only if mutually confirmed as appropriate
