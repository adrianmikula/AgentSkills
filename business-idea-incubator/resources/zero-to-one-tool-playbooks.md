# Zero-to-One Tool Playbooks

Step-by-step playbooks for the highest-leverage embedded tools in the zero-to-one operating system. Load this resource when the founder needs to run a tool, not just know its name. Each playbook produces a concrete artifact that is saved to `.ideas/`.

---

## 1. Pre-Sell Validation

**Purpose:** Prove demand with real payment commitments before building.

**Inputs:**
- Idea summary, target customer, and the one painful outcome it creates
- Price point (start at $50-$500 for B2B, $10-$200 for consumers)
- 3-5 places where the starving crowd already complains (Reddit, HN, Product Hunt, etc.)

**Steps:**
1. Write a one-page offer with a single, narrow outcome. Example: "I'll build a tool that exports your Notion docs to a static site in under 60 seconds." Include the dream outcome, the promised speed, and the guarantee.
2. Set up the simplest deposit page possible (Stripe, LemonSqueezy, Gumroad, or a Typeform + PayPal link). Keep it to one headline, three bullets, price, and a call to action. No logo, no custom domain needed.
3. Post or message in 3-5 places where the starving crowd lives. Do not say "would you use this?" Say: "I'm building [outcome]. If you want early access, put down a refundable $X deposit and I'll build your account first."
4. Run the test for 7 days. Track: visitors, email signups, deposits, conversion rate.
5. Interview every depositor. Ask what they were doing before, why this is worth money, and what must be true on day one.

**Output artifact:** `.ideas/ideas/{slug}.md` with a `## Pre-Sell Results` section and a GO/NO-GO decision.

**Success criteria:**
- 10%+ of visitors put down a deposit, or
- At least 3 people pay, or
- Clear pattern of "I want this now" language from 5+ prospects.

**Common mistakes:**
- Making the promise too broad
- Running the test for fewer than 7 days
- Counting email signups as demand

---

## 2. Value Equation Scorecard

**Purpose:** Quantify whether the offer feels like a no-brainer.

**Inputs:**
- The exact dream outcome the customer wants
- The customer's perception that the outcome will happen
- Time until they get the outcome
- Effort and sacrifice they must make

**Steps:**
1. Ask the customer (or use interview notes): "What does success look like in 30, 60, 90 days?" Capture it in one sentence.
2. Rate dream outcome on a scale of 1-10 (1 = nice to have, 10 = life-changing).
3. Rate perceived likelihood of achievement on 1-10 (1 = skeptical, 10 = certain). Base this on proof, testimonials, demo, or guarantee.
4. Rate time delay on a scale of 1-10, inverted: 1 = years, 10 = immediate. A 1-minute setup scores 10; a 6-month onboarding scores 1.
5. Rate effort and sacrifice on 1-10, inverted: 1 = massive change/risk/learning, 10 = almost no effort.
6. Compute the Value Score: `(Dream Outcome × Likelihood) / (Time Delay × Effort)`.

**Output artifact:** A markdown table saved to the idea file.

| Factor | Score | Notes |
|--------|-------|-------|
| Dream outcome | [1-10] | [Why] |
| Likelihood | [1-10] | [Proof or risk] |
| Time delay | [1-10] | [Inverted] |
| Effort & sacrifice | [1-10] | [Inverted] |
| **Value Score** | `(D×L)/(T×E)` | [Interpretation] |

**Success criteria:**
- Score above 2.0 is workable. Above 4.0 is strong. Below 1.0, the offer is not a no-brainer; improve likelihood, reduce time, or reduce effort.

**Common mistakes:**
- Over-scoring dream outcome because the founder is excited
- Ignoring effort the customer must put in (setup, migration, learning)
- Skipping the guarantee or proof that drives "perceived likelihood"

---

## 3. Grand Slam Offer

**Purpose:** Stack the offer so the customer would be irrational to refuse.

**Inputs:**
- Value Equation scorecard
- List of customer pains, fears, and desired outcomes
- Competitor pricing and adverse reviews

**Steps:**
1. Choose one primary outcome. The offer is not the product; it is the result.
2. Add a fast-start bonus that removes setup friction. Example: "I will import your first 100 records for free."
3. Add a guarantee that removes the customer's risk. Options: money-back, double-your-money-back, results-or-you-don't-pay, pay-only-if-you-love-it.
4. Add a scarcity or urgency that is real: limited founding-customer slots, a deadline, or a price that rises after the first 10 buyers.
5. Name the offer with the MAGIC formula: Magnetic, Appealing, Goal-oriented, Inviting, Clear. It should name the outcome, not the category.
6. List the full stack on the sales page: main outcome, bonuses, guarantee, fast-start, price.

**Output artifact:** A one-page offer spec saved to the idea file under `## Grand Slam Offer`.

| Element | Content |
|---------|---------|
| Primary outcome | [One sentence] |
| Fast-start bonus | [What you do for them] |
| Guarantee | [Exact terms] |
| Scarcity | [Real constraint] |
| Name | [MAGIC name] |
| Price | [Amount] |

**Success criteria:**
- The customer would need a reason *not* to buy.
- The perceived value is at least 10x the price.
- The guarantee is so strong it scares the founder a little.

**Common mistakes:**
- Fake scarcity ("only 3 left" when you have no customers)
- Weak guarantee that the customer knows is standard
- Bundling too many bonuses so the main outcome is unclear

---

## 4. 7-Day Launch Sprint

**Purpose:** Generate first sales in one week, not one month.

**Inputs:**
- Finished offer with name, price, and guarantee
- A simple deposit page or checkout link
- 3-5 customer quotes or evidence from validation

**Steps:**
1. **Day 1 — Landing page.** Write one headline, three bullets, one story/testimonial, price, and a call to action. Use Hook, Story, Offer.
2. **Day 2 — Email sequence.** Three emails: (1) problem + promise, (2) story of your own pain + how you solved it, (3) deadline/offer close.
3. **Day 3 — Reddit post.** Post in one relevant subreddit with a genuine story. Do not sell. End with "If you're dealing with this, I'd love to show you what I built. DM me."
4. **Day 4 — DM outreach.** Send 20 personalized DMs to people who liked, commented, or are in your target. Ask one question about their problem, then offer the demo.
5. **Day 5 — Demo builder.** Build a 5-minute, end-to-end demo. One customer, one use case, one outcome. Record it.
6. **Day 6 — Launch day.** Post the offer page on all channels, send the email, and reply to every comment in real time.
7. **Day 7 — Metrics review.** Count visitors, signups, sales, conversion rate, and top 3 objections. Save the results.

**Output artifact:** `.ideas/ideas/{slug}.md` with `## Launch Sprint Results`.

**Success criteria:**
- Any revenue at all proves the offer works.
- Conversion >2% is good for a cold audience.
- 5+ meaningful conversations with target buyers.

**Common mistakes:**
- Polishing the landing page for more than a day
- Launching on too many channels at once
- Not following up with people who opened but did not buy

---

## 5. PMF 40% Test

**Purpose:** Measure whether users would be very disappointed if your product disappeared.

**Inputs:**
- A group of active users who have used the product at least twice
- A survey tool (Typeform, Google Forms, email)

**Steps:**
1. Pick the exact question: "How would you feel if you could no longer use [product]?" Options: very disappointed, somewhat disappointed, not disappointed, no longer using it.
2. Send it to users who have experienced the core outcome. Avoid users who signed up but never used it.
3. Aim for at least 30 responses. 40+ is better for segmentation.
4. Calculate the percentage who answered "very disappointed."
5. Segment the results: by use case, by acquisition channel, by user type, by frequency of use.
6. Identify the segment with the highest "very disappointed" score. This is your north-star segment.
7. Ask the open follow-up: "What is the main benefit you get from [product]?" and "How can we improve?"

**Output artifact:** `.ideas/ideas/{slug}.md` with `## PMF Survey`.

| Segment | N | Very Disappointed | What they love | How to improve |
|---------|---|-------------------|----------------|----------------|
| [Segment 1] | [n] | [x%] | [quote] | [top request] |
| [North star] | [n] | [x%] | [quote] | [top request] |

**Success criteria:**
- 40%+ "very disappointed" overall = product-market fit signal.
- One segment with 50%+ = focus all roadmap on that segment.
- Below 40% = interview non-disappointed users to find the missing outcome.

**Common mistakes:**
- Surveying users who never used the product
- Asking "how likely are you to recommend" instead of "very disappointed"
- Stopping at the score without segmenting

---

## 6. AARRR Audit

**Purpose:** Find the biggest leak in the growth funnel and design a focused experiment.

**Inputs:**
- Funnel metrics for the last 30 days: visitors, signups, activations, active users, revenue, referrals
- User journey map from first touch to first value

**Steps:**
1. **Acquisition:** Count new visitors by channel. Which channel has the lowest CAC and the highest intent?
2. **Activation:** Count the percentage of new users who reach the first aha-moment within the first session or 24 hours.
3. **Retention:** Count the percentage of users who return on day 1, day 7, day 30.
4. **Revenue:** Count conversion to paid, ARPU, and payback period.
5. **Referral:** Count organic mentions, invite rates, and NPS-based word of mouth.
6. Identify the stage with the biggest leak relative to industry benchmarks. That is your One Metric That Matters (OMTM).
7. Design an experiment: hypothesis, metric, change, duration, sample size, kill criteria.

**Output artifact:** `.ideas/ideas/{slug}.md` with `## AARRR Audit` and `## Experiment Backlog`.

| Stage | Metric | Current | Benchmark | Leak Score |
|-------|--------|---------|-----------|------------|
| Acquisition | [metric] | [x] | [y] | [low/med/high] |
| Activation | [metric] | [x] | [y] | [low/med/high] |
| ... | ... | ... | ... | ... |

**Success criteria:**
- The OMTM is one of the five stages, not a vanity metric.
- The experiment has a clear kill criterion (e.g., "If activation does not improve by 10% in 2 weeks, kill it.").
- No more than 3 active experiments at once.

**Common mistakes:**
- Optimizing acquisition when activation is the real leak
- Running experiments without a kill criterion
- Looking at all metrics instead of one

---

## 7. Flywheel Map

**Purpose:** Design self-reinforcing loops so each customer makes the next one cheaper.

**Inputs:**
- Core loop: what creates value for the customer and for the business
- How new customers discover the product
- What data, content, network, or cost advantage grows with usage

**Steps:**
1. Draw the customer loop: Attract → Use → Succeed → Share/Return.
2. For each arrow, ask: "Does this step get easier or cheaper because of the previous customer?"
3. Identify the feedback loops. Examples: user-generated content (more users → more content → more SEO → more users), data network effects (more data → better AI → more users → more data), word of mouth (delight → referrals → new users → more delight).
4. Score each loop on: strength (0-10), defensibility over time (0-10), and current evidence (0-10).
5. Choose the highest-scoring loop. Design one experiment to make it stronger in the next 30 days.
6. Classify decisions as Type 1 (hard to reverse) or Type 2 (easy to reverse). Move fast on Type 2.

**Output artifact:** A diagram or table in `.ideas/ideas/{slug}.md` under `## Flywheel Map`.

| Loop | Customer benefit | Business benefit | Strength | Evidence | 30-day experiment |
|------|------------------|------------------|----------|----------|-------------------|
| [Loop 1] | [x] | [y] | [s] | [e] | [experiment] |

**Success criteria:**
- At least one clearly identified feedback loop is improving a metric the customer already wants.
- The loop does not rely on paid marketing.
- A Type 2 experiment is running within 7 days.

**Common mistakes:**
- Calling normal referral marketing a flywheel
- Building a feature that is defensible for the business but not valuable to the customer
- Not running an experiment to validate the loop

---

## 8. Working Backwards

**Purpose:** Decide what to build by writing the customer-facing announcement first.

**Inputs:**
- A feature, product, or launch idea
- The exact customer who will use it
- The one-sentence outcome the customer will achieve

**Steps:**
1. Write a one-page internal press release from the customer's perspective. Headline the customer outcome, not the feature name.
2. Write a subheading that explains the problem in the customer's words.
3. Include three customer quotes. Make them specific and emotional.
4. List the three biggest customer benefits. One sentence each.
5. Write a "How it works" section in simple terms (max 5 steps).
6. List the top 5 customer FAQs and answer them.
7. Iterate 3 times. If the press release does not excite the founder by the third draft, kill the feature.

**Output artifact:** `.ideas/ideas/{slug}.md` with a `## Working Backwards PR` section.

| Section | Content |
|---------|---------|
| Headline | [Customer outcome] |
| Problem | [Customer words] |
| Customer quote | [Specific, emotional] |
| Benefits | [3 bullets] |
| How it works | [5 steps] |
| FAQs | [Top 5] |

**Success criteria:**
- The press release is customer-outcome oriented.
- The founder would want to read this if they were the target customer.
- A clear kill/go decision is made before any code is written.

**Common mistakes:**
- Writing about the feature instead of the customer outcome
- Skipping the FAQ step
- Not killing the idea when the press release is weak
