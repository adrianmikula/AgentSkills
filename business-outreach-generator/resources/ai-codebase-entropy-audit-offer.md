# AI Codebase Entropy Audit — Outreach Template

This resource contains the reusable outreach templates for the AI Codebase Entropy Audit offering. It is loaded by `Skill.md` when the selected offering is "AI Codebase Entropy Audit".

---

## Research Instructions (Executed Before Template Population)

Before populating either template, perform the following research steps:

### Step 1 — Identify Senior Technical Staff

1. **Visit the company website** and look for:
   - Leadership/About/Team pages
   - Job titles containing: CTO, Chief Technology Officer, VP Engineering, Head of Engineering, Engineering Director, Development Director, Tech Lead, Technical Lead, Lead Developer, Software Architect, Solutions Architect, Principal Engineer, or Founder/Co-founder (in micro companies)
   - Technical blog posts with author names and titles
   - Press releases mentioning technical leadership

2. **Priority order for targeting** (first match wins):
   - CTO / Chief Technology Officer
   - VP Engineering / Head of Engineering
   - Engineering Director / Development Director
   - Software Architect / Solutions Architect
   - Tech Lead / Technical Lead / Lead Developer
   - Principal Engineer / Senior Engineer
   - Founder / Co-founder (for micro companies with <10 staff)

3. **Capture details**:
   - Full name (for personalization)
   - Job title (for role-specific messaging)
   - Any publicly mentioned technology focus (Java, JVM, AI, enterprise systems, etc.)
   - Direct phone number if listed (Contact page, team directory, corporate directory, or press releases)

### Step 2 — LinkedIn Fallback (if website lacks staff info)

If the company website does not list staff or leadership:

1. **Search LinkedIn** using: `site:linkedin.com "[Company Name]" CTO` or similar role searches
2. **Look for**:
   - Current employees with senior technical titles
   - Founders who list technical backgrounds
   - Mutual connections who can provide warm introductions

3. **Verify company size** aligns with target (typically 20+ staff for this offering; the audit is designed for organisations with multiple engineering teams and large-scale Java/JVM systems)

### Step 3 — Assess Company Suitability

Verify this company is a good fit for the AI Codebase Entropy Audit:

| Indicator | Good Fit Sign |
|-----------|---------------|
| Technology stack | Mentions Java, JVM, Spring, enterprise applications, or large-scale systems |
| Team size | Multiple engineering teams, 10+ developers, or clear engineering leadership |
| AI adoption | Mentions AI-assisted development, Copilot, or accelerated delivery practices |
| Company age | Established company (5+ years) more likely to have complex, evolving systems |
| Modernisation | Mentions legacy modernisation, platform evolution, or technical debt initiatives |
| Industry | Mining, healthcare, finance, professional services — sectors with long-lived systems |

**Skip companies that**:
- Clearly use only modern cloud-native stacks with no legacy concerns (Node.js, Go, Python, serverless only)
- Are brand new startups with no established codebase
- Have fewer than 5 staff or a single developer

### Step 4 — Localise Content

Match spelling and phrasing to `{{COUNTRY}}`:
- Australia / UK: "localise", "programme", "organisation", "centre", "analyse", "behaviour"
- United States: "localize", "program", "organization", "center", "analyze", "behavior"

---

## Email Template

```
Subject: {{COMPANY_NAME}} — a quick question about engineering sustainability

Hi {{CONTACT_NAME}},

I came across {{COMPANY_NAME}} while researching {{INDUSTRY}} companies in {{CITY}} that are navigating the shift toward AI-accelerated software delivery.

If you're responsible for {{COMPANY_NAME}}'s engineering architecture, I'd value a brief conversation about whether your teams have visibility into how your system's structural integrity is holding up under increased delivery speed.

Most organisations already track delivery velocity, uptime, and infrastructure health. Very few have visibility into the structural side effects of rapid, AI-assisted development — the gradual architectural drift, the accumulating codebase entropy, and the erosion of design consistency that compounds quietly until it becomes expensive.

We run a focused **AI Codebase Entropy Audit** — a 2-to-5-day assessment that provides early visibility into:

- **Architectural drift** — where your system is diverging from intended design boundaries and modular structure
- **Codebase entropy** — accumulation of structural disorder, duplication growth, coupling expansion, and reduced predictability of change
- **AI-assisted development risk** — implementation-level inconsistencies introduced by AI coding tools where velocity outpaces architectural coherence
- **Engineering sustainability signals** — whether the system is becoming easier or harder to evolve safely over time

The deliverable is a concise, executive-ready engineering report including an Architectural Integrity Overview, Codebase Entropy Map, System Drift Analysis, Engineering Sustainability Scorecard, and prioritised stabilisation recommendations. Optional: a 30-to-60-minute technical walkthrough with your engineering leadership.

This is a paid audit, currently offered at founding pilot pricing (AUD $1,500 to $3,000 depending on system size). We start with a no-obligation discovery call to confirm scope and suitability.

If the audit surfaces structural concerns, many teams choose to follow on with our **AI SDLC Observability Dashboard** — a custom-built internal system that provides continuous, real-time tracking of these same signals so you catch drift and entropy as they form, not after they compound.

Worth a fifteen-minute discovery call? Just reply with a time that works, or send your preferred contact method.

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

Quick question about {{COMPANY_NAME}}'s engineering operations — do your teams have visibility into how your architecture is evolving under AI-accelerated delivery?

Most orgs track velocity and uptime. Very few track the structural side effects: architectural drift, codebase entropy, and the erosion of design consistency that compounds quietly.

We run a focused 2-to-5-day **AI Codebase Entropy Audit** for {{BUSINESS_SIZE}} {{INDUSTRY}} companies in {{CITY}} with large Java or JVM-based systems. It surfaces early signals of structural degradation before they become expensive.

The audit is a paid engagement (AUD $1,500–$3,000 at founding pilot pricing), but we start with a brief discovery call to confirm it's a fit.

Worth a conversation?

[Your Name]
```

---

## Phone Research Brief

When `Output format == "Phone"`, do not generate a scripted conversation. Instead, produce a concise dot-point research brief the caller can reference during a real call.

### Research Steps (Before Generating the Brief)

1. **Visit the company website** and capture:
   - Products, services, and value proposition
   - Technology stack signals: Java, JVM, Spring, enterprise applications, large-scale systems, AI-assisted development mentions (Copilot, etc.)
   - Team signals: multiple engineering teams, 10+ developers, clear engineering leadership
   - Content signals: technical blog posts about architecture, modernisation, technical debt, or AI-assisted development
   - Modernisation signals: legacy modernisation, platform evolution, or technical debt initiatives

2. **If the website lacks detail**, search LinkedIn for the company and review:
   - Engineering team size and structure
   - Employee roles suggesting Java/JVM, architecture, or AI-assisted development
   - Company size and headcount
   - Any posts or articles mentioning delivery velocity, architecture, or AI tooling

3. **Cross-reference with the collected parameters** (`{{COUNTRY}}`, `{{CITY}}`, `{{INDUSTRY}}`, `{{BUSINESS_SIZE}}`) and localise spelling.

### Brief Format

```
**Phone Research Brief — {{COMPANY_NAME}}**

- **Company:** {{COMPANY_NAME}}, {{BUSINESS_SIZE}}, {{CITY}}, {{COUNTRY}}
- **Contact Details:**
  - **Name:** {{CONTACT_NAME}} [or "Not found — dial main line and ask"]
  - **Role:** {{CONTACT_ROLE}} [e.g. CTO, VP Engineering, Head of Engineering, Architect, Founder]
  - **Phone:** {{CONTACT_PHONE}} [direct line, mobile, or main company line with extension/transfer instructions]
- **Industry Focus:** {{INDUSTRY}} [add any specifics found, e.g. "mining sector with long-lived operational systems"]
- **Products or Services:** [2–3 sentence summary of what the company sells or delivers, and who their customers are]
- **Tech Stack:** [relevant aspects: Java/JVM, Spring, enterprise applications, AI-assisted development signals, team size, any legacy/modernisation initiatives]
- **Suggested Offering Focus:**
  - AI Codebase Entropy Audit — paid 2-to-5-day assessment (AUD $1,500–$3,000 pilot pricing)
  - Key talking points: architectural drift, codebase entropy, AI-assisted development risk, engineering sustainability signals, optional follow-on AI SDLC Observability Dashboard for continuous tracking
- **Leading Questions:**
  1. [Tailored question 1, e.g. "Do your teams have visibility into how your architecture is evolving under AI-accelerated delivery?"]
  2. [Tailored question 2, e.g. "Most organisations track velocity and uptime. How are you tracking the structural side effects — gradual drift, accumulating entropy, erosion of design consistency?"]
```

### Tone Guidance for the Call

- Respect technical competence — assume the recipient understands software architecture, technical debt, observability, and CI/CD
- Be specific about capabilities — mention concrete techniques (architectural drift tracking, entropy scoring, structural analysis)
- No fear-mongering — present risks factually; focus on the gap in visibility, not catastrophe
- Clear value proposition — the audit provides a snapshot of structural integrity; the observability dashboard provides continuous tracking
- Low-pressure CTA — discovery call first, paid engagement only if mutually confirmed as appropriate
- Upsell naturally — mention the observability dashboard as a logical follow-on, not a hard sell

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

- **Respect technical competence** — Assume the recipient understands software architecture, technical debt, observability, and CI/CD
- **Be specific about capabilities** — Mention concrete techniques (architectural drift tracking, entropy scoring, structural analysis)
- **No fear-mongering** — Present risks factually; focus on the gap in visibility, not catastrophe
- **Clear value proposition** — The audit provides a snapshot of structural integrity; the observability dashboard provides continuous tracking
- **Low-pressure CTA** — Discovery call first, paid engagement only if mutually confirmed as appropriate
- **Upsell naturally** — Mention the observability dashboard as a logical follow-on, not a hard sell
