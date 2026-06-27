# Competitive Intelligence

This resource covers **Competitive Intelligence** — mapping your competitive landscape, identifying differentiation opportunities, and developing strategies to win against incumbents and new entrants.

## Key Frameworks

- **Porter's Five Forces** — Supplier power, buyer power, competitive rivalry, threat of substitutes, threat of new entrants
- **Blue Ocean Strategy** — Create uncontested market space instead of fighting in red oceans
- **Competitive Positioning Matrix** — 2x2 matrix plotting competitors on key differentiators
- **Perceptual Mapping** — How customers perceive your brand vs. competitors
- **Jobs to be Done (Competitive Angle)** — What are customers really trying to accomplish?

## Common Pitfalls

- **Competing on features** — Feature wars are expensive and rarely winnew entrants
- **Ignoring indirect competitors** — The biggest threat is often "do nothing" or a workaround
- **Copying competitors** — Differentiation requires being different, not slightly better
- **Underestimating switching costs** — Customers don't switch just because you're better
- **Focusing only on direct competitors** — Adjacent players and substitutes often disrupt first

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `ferdinandobons/startup-skill` (`startup-competitors`) | Battle cards, pricing landscape, feature matrix built from real reviews and forums | **Recommended now** — helps you build a competitive comparison to show in your sales process |
| `ferdinandobons/startup-skill` (`startup-positioning`) | April Dunford's positioning framework: competitive alternatives map, perceptual mapping, messaging implications | Useful when refining your pitch if you hit objections |
| `business-outreach-generator` | Reach out to ex-customers of competitors for honest feedback | Useful if you want to gather competitive intelligence via direct outreach |
| `city-risk-landscape` | Map competitive density by geography | Lower priority — useful at scale |
| `ai-era-vulnerability-scanner` | If you're a tech product, scan competitors' digital footprint for weaknesses | Useful — you can scan competing cafe websites for security vulnerabilities and use that in your pitch |

## Output Templates

### Competitive Map Template

```
# Competitive Intelligence: {{IDEA_NAME}}

## Landscape Overview
| Competitor | Type | Target | Pricing | Strength | Weakness |
|-----------|------|--------|---------|----------|----------|
| [Name] | Direct/Indirect | [Segment] | $[price] | [Strength] | [Weakness] |

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
