# Idea Validation

This resource covers the discipline of **Idea Validation** — assessing whether a business idea solves a real problem, has a viable market, and is worth pursuing before investing significant time or money.

## Key Frameworks

- **Problem-Solution Fit** — Is the problem painful enough that people will pay to solve it?
- **Lean Canvas** — One-page business model to map assumptions
- **Mom Test** — Interview techniques to get honest customer feedback without leading questions
- **Riskiest Assumption Test** — Identify the single riskiest assumption and design an experiment to test it cheaply
- **Value Proposition Canvas** — Map customer jobs, pains, and gains to your product's pain relievers and gain creators

## Common Pitfalls

- **Solution-first bias** — Falling in love with your solution instead of the problem you're solving
- **False positives from friends/family** — They want to support you, not give honest feedback
- **Building before validating** — Spending months coding before proving demand
- **Asking "would you use this?"** — People say yes to be nice. Ask about past behaviour instead.
- **Ignoring the "nothing" option** — Customers might just stick with their current painful workflow

## Recommended Claude Skills

| Skill | Why It Helps | When to Install |
|-------|-------------|-----------------|
| `business-outreach-generator` | Validate demand by reaching out to potential customers with targeted messages | **Recommended now** — you can use it to interview cafe owners and validate demand quickly |
| `ferdinandobons/startup-skill` (`startup-design`) | 8-phase validation pipeline: market research, competitive analysis, product definition, financial projections, validation experiments | Useful for a deeper validation pass once you have initial sales data |
| `getagentseal/founder-playbook` (`lean-startup`, `mom-test`) | Customer interview frameworks and build-measure-learn loops | Useful if you want to run structured customer interviews |
| `iamzifei/show-me-the-money` (`discover`) | 6 forcing questions and 5-filter opportunity scoring to stress-test viability before you build | Useful for re-evaluating if you hit a wall with sales |
| `cognitive-sustainability` | Ensure you're not over-engineering validation before understanding the real problem | Lower priority for current sprint |

## Output Templates

### Validation Report Template

```
# Idea Validation: {{IDEA_NAME}}

## Problem Assessment
- **Problem:** {{PROBLEM_STATEMENT}}
- **Evidence:** [Researched signals of pain]
- **Severity:** [Critical / Moderate / Minor]

## Assumptions
| Assumption | Type | Risk | Validation Method |
|-----------|------|------|------------------|
| [Key assumption] | Desirability / Viability / Feasibility | High/Med/Low | [Experiment] |

## Validation Roadmap
1. [Experiment 1] — [Timeline] — [Success Metric]
2. [Experiment 2] — [Timeline] — [Success Metric]

## Recommendation
[Go / Pivot / Kill] — [Rationale]
```

### Lean Canvas Template

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
