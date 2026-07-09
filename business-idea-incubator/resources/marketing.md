# Marketing

This resource covers **Marketing** — understanding your market, positioning your product, and building awareness and demand for your business.

## Key Frameworks

- **STP Framework** — Segmentation, Targeting, Positioning
- **Positioning Statement** — "For [target customer] who [need], [product] is a [category] that [benefit] unlike [alternative]"
- **AIDA** — Attention, Interest, Desire, Action (classic funnel model)
- **PAS** — Problem, Agitation, Solution (copywriting framework)
- **Jobs to be Done** — Customers "hire" products to do a job; understand the job, not just the customer
- **4Ps / 7Ps** — Product, Price, Place, Promotion (+ People, Process, Physical evidence for services)
- **AEO (AI Engine Optimization)** — In 2026, people query ChatGPT, Perplexity, and Claude directly instead of googling. Optimize your messaging, content, and landing copy to match the exact phrases people type into AI systems. These are proxy demand signals from real human intent.
- **Pain-Language Copy** — Position using the exact frustration language mined from Reddit/HN/Product Hunt. If engineers say "code slop" and "comprehension debt," those phrases belong in your headline, not generic "technical debt" jargon.

## Common Pitfalls

- **Marketing to everyone** — "Everyone needs this" means no one feels specifically targeted
- **Feature-focused messaging** — Customers buy benefits and outcomes, not specs
- **Ignoring positioning early** — Without clear positioning, every marketing channel feels expensive and ineffective
- **Attribution confusion** — Not knowing which channel actually drives revenue
- **Chasing trends** — Every new platform feels mandatory; most are distractions for early-stage startups
- **Using your own jargon instead of customer language** — If customers don't search for your exact terms, your copy won't resonate. Mine their actual language from pain sources.
- **Ignoring AEO** — In 2026, ignoring AI-query optimization means you miss the channel where high-intent buyers now start their research.

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `business-outreach-generator` | Generate cold emails, LinkedIn messages, and outreach campaigns for early customer acquisition | **Recommended now** — Marketing is a blind spot; this generates the actual copy you need to run this week's sales blitz |
| `alirezarezvani/claude-skills` (`AEO`) | Answer Engine Optimization — tracks how you show up in ChatGPT/Perplexity/Claude answers and optimizes content for AI citation | **Recommended** — directly implements the AEO framework in this skill; install the repo and use the `AEO` skill |
| `coreyhaines31/marketingskills` | Modular marketing library: copywriting, CRO, SEO, email sequences, AEO (AI search citations) | **Recommended** — provides done-for-you frameworks for AEO and copy so you don't have to invent marketing from scratch |
| `wondelai/skills` | 25 skills for UX/CRO/sales/growth built on Cialdini, Ries (Lean Startup), Hormozi frameworks — closer to positioning/pricing validation than data-pulling | **Recommended now** — install and use the positioning/pricing skills to refine your offer structure |
| `@clawfu/mcp-skills` | 169 marketing skills (Dunford, Schwartz, Ogilvy, Cialdini) exposed as a live MCP server with "brand memory" — not just prompt skills, actual MCP tools | **Recommended if you use MCP** — check `search_mcp_registry-connect` to see if it integrates with your setup; brand memory is useful for consistent positioning across channels |
| `ferdinandobons/startup-skill` (`startup-positioning`) | USP/positioning via April Dunford's framework | Useful if you need to refine how you describe your product to different audience segments |
| `getagentseal/founder-playbook` (`traction`) | Bullseye channel-selection framework and GTM planning | Lower priority for this week; revisit when scaling |
| `build_wordpress_plugin` | Build marketing sites, landing pages, or content platforms | Only if you need to build a new landing page |

## MCP Tools

| MCP Tool | Why It Helps | How to Install |
|----------|-------------|----------------|
| `@clawfu/mcp-skills` | 169 marketing skills exposed as live MCP server with brand memory — Dunford, Schwartz, Ogilvy, Cialdini frameworks | See repo: `@clawfu/mcp-skills` |
| Brave Search MCP | Search current marketing benchmarks, competitor positioning, and content trends | Configure via MCP settings |
| Puppeteer / Browserbase MCP | Automate SEO audits, scrape competitor landing pages, check SERP positions | Configure via MCP settings |
| Exa AI MCP | Deep search for marketing research and content topic ideation | Configure via MCP settings |
| YouTube Transcript MCP | Transcribe competitor videos and thought leader content for positioning research | Configure via MCP settings |

## Output Templates

### Positioning Statement Template

```
# Positioning: {{IDEA_NAME}}

## Target Customer
- **Demographics:** [Age, location, role, income]
- **Psychographics:** [Values, fears, aspirations]
- **Behaviours:** [How they currently solve the problem]

## Positioning Statement
"For [target customer] who [statement of need],
[product name] is a [category] that [key benefit]
unlike [primary alternative], we [key differentiator]."

## Value Proposition
[One sentence on why someone should care]

## Messaging Pillars
1. [Pillar 1: core benefit]
2. [Pillar 2: proof point]
3. [Pillar 3: call to action]
```

### Channel Strategy Template

| Channel | Target Audience | Content Type | Cadence | Owner | Success Metric |
|---------|----------------|-------------|---------|-------|---------------|
| [Channel] | [Audience] | [Type] | [Frequency] | [Name] | [KPI] |
