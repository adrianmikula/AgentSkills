# E-commerce & Online Selling

This resource covers **E-commerce & Online Selling** — setting up online stores, optimizing conversion, managing payments, and fulfilling orders.

## Key Frameworks

- **Conversion Rate Optimization (CRO)** — Reduce friction in the purchase journey
- **AIDA for E-commerce** — Attention (landing), Interest (product page), Desire (reviews), Action (checkout)
- **Cart Abandonment Recovery** — Email sequences, retargeting, exit-intent offers
- **Product-Market Fit for E-commerce** — Repeat purchase rate, NPS, customer LTV
- **Fulfilment Models** — Dropshipping, self-fulfilment, 3PL, print-on-demand

## Common Pitfalls

- **Ignoring mobile** — 60%+ of e-commerce traffic is mobile; bad mobile UX kills conversions
- **Hidden costs** — Payment fees, shipping, returns, platform fees eat into margins
- **Poor product photography** — The #1 reason for cart abandonment
- **No trust signals** — Missing reviews, security badges, clear return policies
- **Complicated checkout** — Every extra field reduces conversion by ~10%

## Recommended Claude Skills

| Skill | Why It Helps |
|-------|-------------|
| `build_wordpress_plugin` | Build WooCommerce extensions, custom store functionality, or .org-compliant plugins |
| `business-outreach-generator` | Outreach to suppliers, dropshippers, wholesale partners, or early customers |
| `coreyhaines31/marketingskills` | CRO, copywriting, email sequences, and analytics setup for non-marketers |
| `optimise-agentic-coding` | Optimize store performance for Core Web Vitals and SEO |

## MCP Tools

| MCP Tool | Why It Helps | How to Install |
|----------|-------------|----------------|
| Stripe MCP | Manage payments, refunds, subscription billing directly from conversation | Configure via MCP settings |
| Shopify / WooCommerce MCP | Manage product listings, inventory, and orders programmatically | Configure via MCP settings |
| Google Sheets MCP | Track unit economics, inventory levels, and order fulfillment status | Configure via MCP settings |
| Puppeteer MCP | Run competitor price checks, monitor marketplace listings | Configure via MCP settings |

## Output Templates

### Store Setup Checklist

```
# E-commerce Setup: {{IDEA_NAME}}

## Platform Decision
| Platform | Rationale | Cost |
|----------|-----------|------|
| [Chosen] | [Why] | $[amount] |

## Product Listings
- [ ] Product photos (min. 3 angles, lifestyle shots)
- [ ] Product descriptions (benefit-focused, not feature-dumps)
- [ ] Pricing (cost + margin + competitor research)
- [ ] Variants (size, color, etc.)
- [ ] Inventory management setup

## Checkout Optimization
- [ ] Guest checkout enabled
- [ ] Multiple payment methods (Stripe, PayPal, etc.)
- [ ] Shipping calculated at checkout
- [ ] Tax calculated automatically
- [ ] Abandoned cart recovery emails configured

## Trust Signals
- [ ] Reviews plugin installed (Trustpilot, Yotpo, etc.)
- [ ] SSL certificate active
- [ ] Return policy visible on product pages
- [ ] Contact info / live chat available
- [ ] About page with real photos/story

## Launch Plan
1. [Pre-launch: soft launch to friends/family]
2. [Launch day: social media, email list, paid ads]
3. [Post-launch: analyze data, optimize checkout]
```

### Unit Economics for E-commerce

| Metric | Value | Notes |
|--------|-------|-------|
| Product Cost | $[amount] | COGS per unit |
| Shipping Cost | $[amount] | Average |
| Payment Processing | $[amount] | ~2.9% + $0.30 |
| Platform Fees | $[amount] | Shopify/WooCommerce/etc. |
| Total Cost | $[amount] | Sum above |
| Sale Price | $[amount] | |
| Gross Margin | [%] | (Sale - Total Cost) / Sale |
