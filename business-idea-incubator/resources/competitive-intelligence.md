# Competitive Intelligence

This resource covers **Competitive Intelligence** — mapping your competitive landscape, identifying differentiation opportunities, and developing strategies to win against incumbents and new entrants.

## Key Frameworks

- **Porter's Five Forces** — Supplier power, buyer power, competitive rivalry, threat of substitutes, threat of new entrants
- **Blue Ocean Strategy** — Create uncontested market space instead of fighting in red oceans
- **Competitive Positioning Matrix** — 2x2 matrix plotting competitors on key differentiators
- **Perceptual Mapping** — How customers perceive your brand vs. competitors
- **Jobs to be Done (Competitive Angle)** — What are customers really trying to accomplish?
- **Adverse Review Mining (2026 method)** — Systematically audit two-star and three-star reviews of adjacent products, courses, and services. These reviews are the clearest, most honest record of where incumbents fail and where customers are already willing to pay for something better.
- **Pain-Language Positioning** — Use the verbatim frustration language from adverse reviews to position your offering. If multiple reviews say "the course doesn't cover how to actually apply this in production," that becomes your headline differentiation.

## Common Pitfalls

- **Competing on features** — Feature wars are expensive and rarely winnew entrants
- **Ignoring indirect competitors** — The biggest threat is often "do nothing" or a workaround
- **Copying competitors** — Differentiation requires being different, not slightly better
- **Underestimating switching costs** — Customers don't switch just because you're better
- **Focusing only on direct competitors** — Adjacent players and substitutes often disrupt first
- **Relying only on competitor marketing** — Competitors only tell you what they do well. Two-star reviews tell you what customers actually hate.

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `ferdinandobons/startup-skill` (`startup-competitors`) | Battle cards, pricing landscape, feature matrix built from real reviews and forums | **Recommended now** — helps you build a competitive comparison to show in your sales process |
| `ferdinandobons/startup-skill` (`startup-positioning`) | April Dunford's positioning framework: competitive alternatives map, perceptual mapping, messaging implications | Useful when refining your pitch if you hit objections |
| `alirezarezvani/claude-skills` (`market-research`) | Market sizing, segmentation, and trend bundles — automates TAM/SAM analysis and competitor landscape scanning | **Recommended** — use alongside adverse review mining to get both top-down (market size) and bottom-up (complaint density) intelligence |
| `business-outreach-generator` | Reach out to ex-customers of competitors for honest feedback | Useful if you want to gather competitive intelligence via direct outreach |
| `deep-research` or `manus` | Delegate competitive landscaping to a second AI engine for independent validation of market gaps | Useful when you want to cross-check your own competitive analysis |
| `daymade/claude-code-skills` (`product-analysis`) | Structured product analysis with defined dimensions — useful for repeatable competitive teardowns | Install when building systematic adverse review audits |
| `city-risk-landscape` | Map competitive density by geography | Lower priority — useful at scale |
| `ai-era-vulnerability-scanner` | If you're a tech product, scan competitors' digital footprint for weaknesses | Useful — you can scan competing websites for security vulnerabilities and use that in your pitch |

## MCP Tools

| MCP Tool | Why It Helps | How to Install |
|----------|-------------|----------------|
| Brave Search MCP | Continuously monitor competitor announcements, funding news, and product launches | Configure via MCP settings |
| Exa AI MCP | Deep competitor research, find competitor review sites, scrape product pages | Configure via MCP settings |
| Puppeteer MCP | Scrape competitor websites, pricing pages, and changelogs for intelligence gathering | Configure via MCP settings |
| GitHub MCP | Monitor competitor open-source repos for feature direction and community sentiment | Configure via MCP settings |

## Output Templates

### Competitive Map Template

```
# Competitive Intelligence: {{IDEA_NAME}}

## Landscape Overview
| Competitor | Type | Target | Pricing | Strength | Weakness |
|-----------|------|--------|---------|----------|----------|
| [Name] | Direct/Indirect | [Segment] | $[price] | [Strength] | [Weakness] |

## Adverse Review Audit
| Competitor | Platform | Rating | 2-Star Complaint Themes | Our Opportunity |
|-----------|----------|--------|------------------------|----------------|
| [Name] | Maven/Udemy/Gumroad | [stars] | [Top complaints] | [Gap we exploit] |

## Pain-Language Positioning
- **What customers say (verbatim from reviews):** "[Quote]"
- **What competitors promise:** "[Promise]"
- **What we deliver instead:** "[Contrast]"

## Positioning Matrix
- **X-Axis:** [e.g., Price / Convenience / Quality]
- **Y-Axis:** [e.g., Enterprise / SMB / Consumer]
- **Our Position:** [Where we sit and why]

## White Space Analysis
| Opportunity | Why It Matters | How to Exploit |
|------------|---------------|----------------|
| [Gap 1] | [Rationale] | [Strategy] |

## Differentiation Strategy
- **Unique Value:** [One sentence]
- **Defensible Moats:** [What makes this hard to copy]
- **Key Differentiators:** [3-5 bullet points]
- **Messaging Angle:** [How to talk about the difference]
- **Opposing Language:** [Compelling competitor weakness to surface in copy]
```

### Competitor Teardown Template

| Dimension | Competitor A | Competitor B | Competitor C | Us |
|-----------|-------------|-------------|-------------|-----|
| Price | $[amount] | $[amount] | $[amount] | $[amount] |
| Key Feature 1 | Yes/No | Yes/No | Yes/No | Yes/No |
| Key Feature 2 | Yes/No | Yes/No | Yes/No | Yes/No |
| Target Segment | [Segment] | [Segment] | [Segment] | [Segment] |
| Review Score | [x/5] | [x/5] | [x/5] | [x/5] |
| Key Weakness | [Weakness] | [Weakness] | [Weakness] | [Weakness] |
| 2-Star Recurring Complaint | [Complaint] | [Complaint] | [Complaint] | N/A |
| Our Counter | [How we solve it] | [How we solve it] | [How we solve it] | — |
