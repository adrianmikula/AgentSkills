# Idea Validation

This resource covers the discipline of **Idea Validation** — assessing whether a business idea solves a real problem, has a viable market, and is worth pursuing before investing significant time or money.

## Key Frameworks

- **Problem-Solution Fit** — Is the problem painful enough that people will pay to solve it?
- **Lean Canvas** — One-page business model to map assumptions
- **Mom Test** — Interview techniques to get honest customer feedback without leading questions
- **Riskiest Assumption Test** — Identify the single riskiest assumption and design an experiment to test it cheaply
- **Value Proposition Canvas** — Map customer jobs, pains, and gains to your product's pain relievers and gain creators
- **Pain-Mining / Frustration Scraping** — Use tools like PainBase, Reddily, or Subreddit Signals to pull verbatim frustration language from Reddit, HN, and Product Hunt threads. This is a stronger demand signal than audience-intelligence tools because it surfaces actual complaints, not just follower counts.
- **AEO Query Mining** — Because users now ask AI search engines (ChatGPT, Perplexity, Claude) directly, mining the verbatim questions people type into those systems (and indexing them via platforms that capture AI-query data) gives you the exact demand language customers use. More accurate than classic keyword planners.
- **Pre-Sale Validation (Founder's Special)** — The gold-standard 2026 signal: a real waitlist with payment (even a $1 deposit or small pilot fee). A 10%+ conversion from interested-to-paying is the accepted bar. Surveys can help; actual payment commitments cannot lie.
- **Adverse Review Mining** — Read two-star and three-star reviews of adjacent products/courses on Maven, Udemy, Gumroad, and similar platforms to find where existing solutions underserve people. Cheap, fast, and highly specific.

## Common Pitfalls

- **Solution-first bias** — Falling in love with your solution instead of the problem you're solving
- **False positives from friends/family** — They want to support you, not give honest feedback
- **Building before validating** — Spending months coding before proving demand
- **Asking "would you use this?"** — People say yes to be nice. Ask about past behaviour instead.
- **Ignoring the "nothing" option** — Customers might just stick with their current painful workflow
- **Reliance on vanity metrics** — Follower counts, website visits, and "interest" surveys usually overstate willingness to pay. Validate with real transactions, not attention.
- **Skipping adverse review mining** — Only studying what competitors "do right" leaves you blind to the exact gaps customers will pay to close.

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `business-outreach-generator` | Validate demand by reaching out to potential customers with targeted messages | **Recommended now** — you can use it to interview target customers and validate demand quickly |
| `alirezarezvani/claude-skills` (`market-research`, `product-research`) | Market sizing, segmentation, and user research bundles packaged as skills — automates what we previously did with manual web_search | **Recommended now** — closest match to the manual research workflow we just designed; install the whole repo and use `market-research` for TAM/SAM and `product-research` for user interviews |
| `ferdinandobons/startup-skill` (`startup-design`) | 8-phase validation pipeline: market research, competitive analysis, product definition, financial projections, validation experiments | Useful for a deeper validation pass once you have initial sales data |
| `getagentseal/founder-playbook` (`lean-startup`, `mom-test`) | Customer interview frameworks and build-measure-learn loops | Useful if you want to run structured customer interviews |
| `iamzifei/show-me-the-money` (`discover`) | 6 forcing questions and 5-filter opportunity scoring to stress-test viability before you build | Useful for re-evaluating if you hit a wall with sales |
| `cognitive-sustainability` | Ensure you're not over-engineering validation before understanding the real problem | Lower priority for current sprint |
| `daymade/claude-code-skills` (`product-analysis`) | Structured product analysis with defined dimensions — useful for competitive teardowns and positioning audits | Install when building adverse review audits or competitive teardowns |
| `deep-research` or `manus` | Delegate market analysis and competitive landscaping to a second AI engine for cross-validation | Useful when you want independent verification of market sizing or competitive gaps |
| `alirezarezvani/claude-skills` (`pulse`) | Trend-scanning skill — automates monitoring of emerging topics and signals across the web | Useful for ongoing trend tracking alongside the skill's built-in `.ideas/trends/` system |

## MCP Tools

| MCP Tool | Why It Helps | How to Install |
|----------|-------------|----------------|
| `web-fetch` | Fetch and analyse competitor landing pages, review pages, and customer feedback sites for validation research | Built-in tool |
| `web-search` | Search for competitor reviews, pain-point discussions, and market sizing data in real time | Built-in tool |
| GitHub MCP (e.g., `github.com/modelcontextprotocol/github-server`) | Analyse GitHub issue discussions for feature requests and complaints in adjacent open-source tools | Configure via MCP settings |
| Filesystem MCP | Read and write validation documents, competitive research files, and experiment logs locally | Built-in / Configure |

## Output Templates

### Validation Report Template

```
# Idea Validation: {{IDEA_NAME}}

## Problem Assessment
- **Problem:** {{PROBLEM_STATEMENT}}
- **Evidence:** [Researched signals of pain]
- **Severity:** [Critical / Moderate / Minor]

## Pain Signal Summary
- **Frustration language sources:** [Reddit threads, HN discussions, Product Hunt comments]
- **Verbatim quotes:** [3-5 representative quotes showing intensity of pain]
- **Named concepts / vocabulary:** [Industry terms people are already using to describe the pain]

## Assumptions
| Assumption | Type | Risk | Validation Method |
|-----------|------|------|------------------|
| [Key assumption] | Desirability / Viability / Feasibility | High/Med/Low | [Experiment] |

## Market Supply Analysis
- **Adjacent products / courses / services:** [List with pricing]
- **Gap analysis:** [What they don't cover that customers want]
- **Two-star review insights:** [Common complaints from adverse reviews]

## Validation Roadmap
1. [Experiment 1 — e.g., Pain-mining scrape] — [Timeline] — [Success Metric]
2. [Experiment 2 — e.g., Pre-sale deposit page] — [Timeline] — [Success Metric]
3. [Experiment 3 — e.g., Adverse review audit] — [Timeline] — [Success Metric]

## Recommendation
[Go / Pivot / Kill] — [Rationale]
```

### Pain-Mining Research Log

```
# Pain-Mining: {{IDEA_NAME}}

## Sources Queried
- [ ] Reddit: r/[subreddit], r/[subreddit]
- [ ] HN: Threads on "[keyword]"
- [ ] Product Hunt: "[keyword]" discussions
- [ ] Twitter/X: Search "[keyword] frustration"
- [ ] Competitor reviews: [platform]

## Verbatim Quotes (highest-signal)
> "[Exact quote from user describing pain]"
> "[Exact quote from user describing pain]"

## Named Pain Concepts
- "[Concept]": [Description and why it matters]
- "[Concept]": [Description and why it matters]

## Frequency & Intensity
- [X mentions / Y threads]
- [Strong / Moderate / Weak signal]

## Implications for Offer
- [How this pain language should shape your positioning]
- [What customers are already paying for / trying to use as alternatives]
```

### Pre-Sale Validation Template

```
# Pre-Sale Validation: {{IDEA_NAME}}

## Offer Details
- **Module / Outcome:** [Narrow, single-outcome promise]
- **Price:** $[amount] (Founder's Special)
- **Waitlist / Deposit Page:** [URL if live]

## Metrics
- **Visitors to offer page:** [X]
- **Email signups:** [X]
- **Deposit commits:** [X] ($[total] committed)
- **Conversion rate:** [X%] (target: 10%+)

## Thank-You Page Question
- "What's your biggest frustration with [pain area]?"
- [Summary of responses]

## Signal Assessment
- [Green light / Red light / Needs more data]
```

### Adverse Review Audit Template

```
# Adverse Review Audit: {{CATEGORY}}

## Products / Courses Reviewed
| Product | Platform | Price | Rating | 2-Star Themes |
|---------|----------|-------|--------|---------------|
| [Name] | Maven/Udemy/Gumroad | $[price] | [stars] | [Top complaints] |
| [Name] | Maven/Udemy/Gumroad | $[price] | [stars] | [Top complaints] |

## Complaint Clusters
1. [Cluster 1]: [X mentions] — [Our opportunity]
2. [Cluster 2]: [X mentions] — [Our opportunity]

## Positioning Gap
- [What existing products promise vs. what they deliver]
- [Where we can differentiate]
```

| Block | Content |
|-------|---------|
| Problem | [Top 3 problems] |
| Solution | [Top 3 features] |
| Key Metrics | [How you measure success] |
| Unique Value Proposition | [One sentence] |
| Unfair Advantage | [What can't be copied] |
| Channels | [How you reach customers] |
| Customer Segments | [Target customers] |
| Cost Structure | [Key costs] |
| Revenue Streams | [How you make money] |
