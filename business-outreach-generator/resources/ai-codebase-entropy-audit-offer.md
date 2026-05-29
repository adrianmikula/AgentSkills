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

## Phone Call Template

```
[Ring — they pick up]

Hi {{CONTACT_NAME}}, this is [Your Name] from [Your Company]. [pause] I hope I'm not catching you at a bad time — do you have a quick minute?

[pause for response. If yes, continue. If no, ask for a better time to call back.]

Great. I came across {{COMPANY_NAME}} while researching {{INDUSTRY}} companies in {{CITY}} navigating AI-accelerated software delivery. If you're the right person to speak with about engineering architecture, I'd value a brief conversation.

Most organisations already have infrastructure observability and CI/CD. What we rarely see is visibility into the structural side effects of rapid, AI-assisted development — the gradual drift from intended boundaries, the accumulation of structural disorder, and the erosion of design consistency that compounds quietly.

We run a focused **AI Codebase Entropy Audit** — a 2-to-5-day assessment that surfaces these early signals across large Java and JVM-based systems. You get an executive-ready report with an architectural integrity overview, entropy map, drift analysis, and prioritised recommendations. Currently at founding pilot pricing: AUD $1,500 to $3,000.

If the audit reveals ongoing structural concerns, many teams follow on with our **AI SDLC Observability Dashboard** for continuous, real-time tracking — so you catch drift as it forms, not after it compounds.

Worth a fifteen-minute discovery call?

[pause for response]

Thanks {{CONTACT_NAME}}, speak soon.
```

### Objection Responses

| Objection | Response |
|-----------|----------|
| "We already have monitoring / dashboards" | "That's great — this complements what you have. Existing tools track runtime behaviour, errors, and performance. The entropy audit tracks the structure of the code itself: how boundaries drift, how entropy accumulates, and how AI-assisted changes affect design consistency. It's a snapshot most organisations don't realise they need until they see it." |
| "We handle code quality internally" | "Understood. Many strong teams do. The audit is designed to complement internal efforts by providing an external, systematic view of structural trends that manual code reviews and static analysis snapshots can't capture — longitudinal patterns across your entire system." |
| "We're not using AI-assisted development yet" | "Fair enough. Even without AI tools, large Java and JVM systems naturally accumulate drift and entropy over time. The audit establishes a baseline now. If you adopt AI-assisted tools later, you'll have a clear before-and-after picture of structural impact." |
| "Send me an email" | "Absolutely — what's the best address? I'll include a one-page overview and a sample report structure from a similar {{BUSINESS_SIZE}} {{INDUSTRY}} environment." |
| "Not interested / no budget" | "No problem at all. I'll send a brief overview — if circumstances change, you'll have the details. What's the best email for you?" |
| "Can you just do the audit without the call?" | "We prefer a short discovery call first to confirm the audit is appropriate for your system size and complexity. It takes ten to fifteen minutes and ensures you get maximum value from the assessment. When would suit you?" |

### Pre-Call Checklist

- [ ] Verify the contact's full name, role, and correct pronunciation
- [ ] Review {{COMPANY_NAME}}'s website for Java, JVM, Spring, AI, or enterprise stack mentions
- [ ] Confirm the company size and engineering team scale align with the target (typically 20+ staff, multiple dev teams)
- [ ] Have a one-page overview or sample report structure ready to reference
- [ ] Ensure you're calling during business hours in {{COUNTRY}}
- [ ] Prepare to leave a brief voicemail if they don't answer (see below)

### Voicemail Script (if no answer)

> Hi {{CONTACT_NAME}}, this is [Your Name] from [Your Company]. I'm calling about an AI Codebase Entropy Audit we run for {{BUSINESS_SIZE}} {{INDUSTRY}} companies in {{CITY}} with large Java and JVM-based systems. It's a 2-to-5-day assessment that surfaces early architectural drift, codebase entropy, and AI-assisted development risk before they compound into structural cost. I'd value a brief discovery call when you have fifteen minutes. I'll follow up via email, or feel free to call me back on [Phone Number]. Thanks.

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

- **Respect technical competence** — Assume the recipient understands software architecture, technical debt, observability, and CI/CD
- **Be specific about capabilities** — Mention concrete techniques (architectural drift tracking, entropy scoring, structural analysis)
- **No fear-mongering** — Present risks factually; focus on the gap in visibility, not catastrophe
- **Clear value proposition** — The audit provides a snapshot of structural integrity; the observability dashboard provides continuous tracking
- **Low-pressure CTA** — Discovery call first, paid engagement only if mutually confirmed as appropriate
- **Upsell naturally** — Mention the observability dashboard as a logical follow-on, not a hard sell
