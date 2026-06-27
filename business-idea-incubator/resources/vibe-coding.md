# Vibe Coding / Rapid Prototyping

This resource covers **Vibe Coding** — rapidly building working prototypes, MVPs, and proof-of-concepts to validate ideas quickly without getting bogged down in perfect code.

## Key Frameworks

- **MVP (Minimum Viable Product)** — Smallest thing that tests your hypothesis
- **Concierge MVP** — Manual service disguised as software; validate before automating
- **Wizard of Oz MVP** — Looks automated but humans are behind it
- **No-Code / Low-Code Stack** — Bubble, Webflow, Notion, Airtable, Glide, Softr
- **Rapid Prototyping Stack** — Next.js, Supabase, Vercel, Railway, Render
- **Prompt-to-Prototype** — Using AI to generate functional code from descriptions

## Common Pitfalls

- **Over-engineering the MVP** — Building scalable architecture before proving demand
- **Ignoring no-code options** — Spending 3 months coding what Bubble could do in 3 days
- **Premature optimization** — Database indexing, caching, and microservices before you have users
- **Gold plating** — Adding "just one more feature" instead of launching
- **Not defining "done"** — Infinite scope creep without a launch date

## Recommended Claude Skills

| Skill | Why It Helps |
|-------|-------------|
| `optimise-agentic-coding` | Set up your repo for AI-assisted development from day one; install structured logging, MCP servers, and agent workflows |
| `build_wordpress_plugin` | If your MVP needs a WordPress plugin or site, generate it fast |
| `production-deployment` | Deploy your prototype to a real URL for user testing |
| `cognitive-sustainability` | Maintain clarity on what the MVP actually needs to test; avoid over-engineering before understanding the problem |

## Output Templates

### MVP Definition Template

```
# MVP Definition: {{IDEA_NAME}}

## Hypothesis
[Single sentence: "We believe that [target users] will [behaviour] because [reason]."]

## Success Criteria
| Metric | Target | Measurement |
|--------|--------|-------------|
| [Metric 1] | [Number] | [How to measure] |
| [Metric 2] | [Number] | [How to measure] |

## Scope
| In Scope | Out of Scope |
|----------|-------------|
| [Feature 1] | [Feature 2] |
| [Feature 2] | [Feature 3] |

## Stack Decision
| Component | Choice | Rationale |
|-----------|--------|-----------|
| Frontend | [Tool] | [Why] |
| Backend | [Tool] | [Why] |
| Database | [Tool] | [Why] |
| Hosting | [Tool] | [Why] |

## Timeline
- **Week 1:** [Milestone]
- **Week 2:** [Milestone]
- **Launch:** [Date]
```

### No-Code Stack Options

| Stack | Best For | Speed | Cost |
|-------|----------|-------|------|
| Bubble | Web apps, marketplaces | Fast | $29–$349/mo |
| Webflow | Marketing sites, blogs | Very fast | $14–$212/mo |
| Softr + Airtable | CRMs, directories | Fast | $14–$237/mo |
| Glide | Mobile-first apps | Very fast | $25–$99/mo |
| Notion + Super | Simple web apps | Fast | Free–$20/mo |
