# Profitability & Financial Modelling

This resource covers **Profitability & Financial Modelling** — building financial models, understanding unit economics, pricing strategies, and ensuring your business can sustainably generate profit.

## Key Frameworks

- **Unit Economics** — CAC, LTV, LTV:CAC ratio, payback period
- **Break-Even Analysis** — Fixed costs vs. variable costs, contribution margin
- **Gross Margin** — Revenue minus COGS; the health of your core business model
- **Net Dollar Retention** — Do customers expand, contract, or churn over time?
- **Rule of 40** — Growth rate + profit margin should exceed 40% (for SaaS)
- **Burn Multiple** — How much capital you burn per dollar of net new ARR

## Common Pitfalls

- **Ignoring hidden costs** — Payment processing fees, support, refunds, chargebacks
- **Pricing below cost** — Acquiring customers for more than their lifetime value
- **Assuming scale solves everything** — Unprofitable unit economics don't magically improve at scale
- **Forgetting founder salary** — Your time has a cost; include it in models
- **Vanity metrics** — Focusing on revenue or user count while ignoring margin

## Recommended Claude Skills

| Skill | Why It Helps |
|-------|-------------|
| `founderjourney/claude-skills` (`saas-financial-projections`) | Dense SaaS CFO skill: MRR/ARR/LTV:CAC/Rule of 40, cohort-based projections, 2025–26 valuation benchmarks |
| `iamzifei/show-me-the-money` (`finance`) | Unit economics, revenue tracking, session checkpointing for viability testing |
| `getagentseal/founder-playbook` (`monetizing-innovation`) | Pricing/packaging economics from the Innovation pro: value-based pricing, price elasticity |
| `getagentseal/founder-playbook` (`100m-offers`) | Offer structuring to maximize margin and perceived value |
| `business-outreach-generator` | Price your offer and structure outreach around value, not cost |

## Output Templates

### Unit Economics Template

```
# Unit Economics: {{IDEA_NAME}}

## Assumptions
| Metric | Value | Source |
|--------|-------|--------|
| Average Revenue Per User (ARPU) | $[amount] | [Estimate / Data] |
| Customer Acquisition Cost (CAC) | $[amount] | [Channel estimate] |
| Gross Margin | [%] | [Calculation] |
| Monthly Churn | [%] | [Industry benchmark] |
| Customer Lifetime (months) | [months] | 1 / Churn |

## Calculations
- **LTV** = ARPU × Gross Margin × Customer Lifetime = $[amount]
- **LTV:CAC Ratio** = [x:1] — Target: >3x
- **Payback Period** = CAC / (ARPU × Gross Margin) = [months]
- **Verdict:** [Healthy / Needs Work / Unprofitable]

## Scenarios
| Scenario | ARPU | CAC | LTV:CAC | Payback |
|----------|------|-----|---------|---------|
| Conservative | $[low] | $[high] | [x] | [mo] |
| Base Case | $[mid] | $[mid] | [x] | [mo] |
| Optimistic | $[high] | $[low] | [x] | [mo] |
```

### Pricing Strategy Template

| Tier | Price | Target Segment | Features | Margin |
|------|-------|----------------|---------|--------|
| [Tier 1] | $[amount] | [Segment] | [Features] | [%] |
| [Tier 2] | $[amount] | [Segment] | [Features] | [%] |
| [Tier 3] | $[amount] | [Segment] | [Features] | [%] |
