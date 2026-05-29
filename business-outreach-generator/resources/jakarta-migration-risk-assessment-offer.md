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

## Phone Call Template

### OPENING

| Conversation Direction | Your Next Question / Line |
|---|---|
| Introduce yourself | "Hi {{CONTACT_NAME}}, this is [Your Name] from CodeMedic Consulting. Do you have five minutes for a quick call?" |
| They say yes | "I came across {{COMPANY_NAME}} while researching {{INDUSTRY}} companies in {{CITY}} navigating the Java EE to Jakarta EE transition. If you're the right person to speak with about your technical architecture, I'd value a brief conversation." |
| They say no / busy | "No problem at all. When would be a better time to call back?" |

### INTRODUCTIONS

| Conversation Direction | Your Next Question / Line |
|---|---|
| Ask about their role | "What's your current focus at {{COMPANY_NAME}} — are you managing the Java stack and migration planning, or is that handled by someone else?" |
| They describe their role | Listen, note any Java EE, Jakarta EE, Spring, or legacy system mentions. |
| Establish what CodeMedic does | "At CodeMedic, we help engineering teams navigate complex Java EE to Jakarta EE migrations by identifying hidden blockers — transitive dependency conflicts, deprecated API usage, and bytecode-level compatibility issues that surface-only analysis misses." |
| Establish relevance | "That aligns with what we're seeing across {{CITY}} {{INDUSTRY}} companies — especially teams maintaining legacy Java EE applications that need a clear migration path." |

### CURIOSITY

| Conversation Direction | Your Next Question / Line |
|---|---|
| Pivot to the gap | "Most teams have a migration plan on paper. What's your current visibility into the hidden compatibility blockers — the transitive dependency conflicts and deprecated API usage that only surface during the build?" |
| They express concern / mention blockers | "Exactly — that's where migrations stall. The javax to jakarta namespace change creates ripple effects through dependencies, frameworks, and build tools that aren't obvious until you're deep in the refactor." |
| They say migration is going smoothly | "That's great to hear. Our assessment is designed to validate progress and catch the blockers that surface scans miss — often in transitive dependencies or bytecode-level compatibility. Worth confirming there's nothing lurking?" |

### LEADS

| Conversation Direction | Your Next Question / Line |
|---|---|
| Introduce the assessment | "We run a focused Jakarta Migration Risk Assessment for {{BUSINESS_SIZE}} {{INDUSTRY}} companies. It combines automated bytecode scanning, transitive dependency analysis, and hands-on migration experience to produce a detailed risk report and refactoring guide." |
| They ask about deliverables | "You get a risk assessment and refactoring guide — typically 3-to-5 reports — that your team can use to estimate effort, plan phases, and avoid common migration pitfalls." |
| They ask about pricing | "This is a paid engagement, but we start with a no-obligation discovery call to confirm the assessment is appropriate for your situation." |
| Ask for the meeting | "Worth a fifteen-minute discovery call to understand your current setup and confirm the assessment would be valuable?" |
| They agree | "Great. What works better — Tuesday or Thursday morning?" |
| They want email instead | "Absolutely — what's the best address? I'll include a sample risk assessment outline and a recent case study from a similar {{BUSINESS_SIZE}} {{INDUSTRY}} environment." |

### Pre-Call Checklist

- [ ] Verify the contact's full name, role, and correct pronunciation
- [ ] Review {{COMPANY_NAME}}'s website for Java, Spring, or enterprise stack mentions
- [ ] Confirm the company size aligns with the target range (1-99 staff)
- [ ] Have a sample assessment outline or case study ready to reference
- [ ] Ensure you're calling during business hours in {{COUNTRY}}
- [ ] Prepare to leave a brief voicemail if they don't answer (see below)

### Voicemail Script (if no answer)

> Hi {{CONTACT_NAME}}, this is [Your Name] from [Your Company]. I'm calling about a Jakarta EE migration risk assessment we run for {{BUSINESS_SIZE}} {{INDUSTRY}} companies in {{CITY}}. It combines automated bytecode scanning with hands-on migration experience to catch dependency and compatibility issues early. I'd value a brief discovery call when you have fifteen minutes. I'll follow up via email, or feel free to call me back on [Phone Number]. Thanks.

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
