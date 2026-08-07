## Financial Resources in Human Profile

When the financial resource questions are answered (Step A above), append or update the following section in `.ideas/human-profile.md`:

```markdown
## Financial Resources

**Last Updated:** [Date]

### Current Project Financials
- **Available Capital:** $[amount]
- **Runway Without Income:** [X] months
- **Salary Requirement:** [Yes / No / Part-time income needed]
- **Friends & Family Capital Access:** [Yes / Amount range / No / Not comfortable]

### Personal Financial Situation
- **Employment Status:** [Employed / Unemployed / Student / Retired / Other]
- **Previous Capital Raised:** [None / Amount and stage]
- **Revenue Timeline Target:** [Immediate / 3 months / 6 months / 12+ months]

### Ideal Outcome
- [Revenue business / Acquihire / VC-scale exit / Lifestyle / Other]

### Notes
- [Any relevant context: e.g., "Can dedicate 20 hrs/week while employed", "Has $50K savings but needs to cover rent"]
```

Update this section whenever the human's financial situation changes. Do not make assumptions about their financial resources — always ask and record their actual answers.

---


## Human Profile Initialization

Run this only when `.ideas/human-profile.md` does not exist.

### Step 1 — Discipline Confidence Survey
Ask the human to rate their confidence/experience for each discipline **one at a time**, presenting the following options for each:
1. Easy/Confident
2. Familiar/Proficient
3. Neutral/Basic Knowledge
4. Difficult/Hate It
5. Unfamiliar/Never Done It

Go through each discipline in order, waiting for the human's response before moving to the next:
1. Idea Validation
2. Startup Foundations
3. Marketing
4. Outreach & Offer Framing
5. Profitability & Financial Modelling
6. Competitive Intelligence
7. Business Operations
8. Vibe Coding / Rapid Prototyping
9. Production Deployment
10. E-commerce & Online Selling
11. Social Media Presence
12. Funding & Capital Strategy (pre-revenue funding, bootstrapping, grants, crowdfunding, angels/VC, revenue-first)
13. Trend Analysis (tracking external market conditions, threat landscapes, competitive moves)

Record the human's selection for each discipline. For internal confidence scoring used in adaptive coaching:
- Easy/Confident → 1
- Familiar/Proficient → 2
- Neutral/Basic Knowledge → 3
- Difficult/Hate It → 5 (flag as blind spot)
- Unfamiliar/Never Done It → 5 (flag as blind spot)

Adaptive coaching thresholds invert accordingly:
- **Confidence 1–2:** Advanced strategies, edge cases, peer-level discussion (human is strong here).
- **Confidence 3:** Best practices, nuance, and optimization tips.
- **Confidence 4–5:** Foundational frameworks, step-by-step guidance, and recommended resources. Do not assume prior knowledge.

**Auto-recommend for blind spots:** For any blind spot (Confidence 4-5) that does **not** already have an Active strategy recorded in the human profile's `## Blind Spot Strategies` section, automatically recommend installing/using the relevant MCP tools and Claude skills listed in the discipline's resource file (see `## Blind Spot Strategy Tracking` below). If the blind spot already has an Active strategy, skip the recommendation.

**Blind spot flagging:** Only explicitly flag disciplines as blind spots if the human selected:
- Difficult/Hate It
- Unfamiliar/Never Done It

Do NOT flag Familiar/Proficient, Neutral/Basic Knowledge, or Easy/Confident as blind spots.

### Step 2 — Blind Spots and Weaknesses

Ask: *"Are there any disciplines above where you feel particularly weak, or that you actively dislike or avoid? These are your 'blind spots' — I'll focus extra coaching here."*

Record any specific disciplines mentioned and the nature of the weakness.

### Step 3 — Working Style Preferences

Ask:
- *"How do you prefer to receive feedback?"* (direct, gentle, data-driven, visual, etc.)
- *"What's your typical available time per week for this project?"*
- *"Do you prefer async self-study or live coaching/iteration?"*

### Step 4 — Save Profile

Create `.ideas/human-profile.md` and `.ideas/personality-profile.md` with the collected data.

---

## Blind Spot Strategy Tracking

Track what practical help/assistance strategies are in place for each blind spot. This prevents redundant recommendations once a strategy is already active.

### Strategy Table in Human Profile

Maintain a `## Blind Spot Strategies` section in `.ideas/human-profile.md`:

```markdown
## Blind Spot Strategies

| Discipline | Strategy | MCP Tools | Claude Skills | Status |
|------------|----------|-----------|---------------|--------|
| Marketing | [Description of the practical strategy in place] | [MCP tools installed/used] | [Claude skills installed/used] | Active / Needs Update |
| Outreach & Offer Framing | [Description] | [MCP tools installed/used] | [Claude skills installed/used] | Active / Needs Update |
```

### When to Update

Update this section whenever:
- A new MCP tool or Claude skill is installed for a blind spot area
- A blind spot strategy changes, completes, or expands
- A new blind spot is identified during onboarding or sessions
- The human explicitly confirms they have a working approach for a blind spot

### Recommendation Guard

Before recommending any MCP tool or Claude skill for a blind spot:
1. Read `.ideas/human-profile.md` and locate the `## Blind Spot Strategies` section
2. Check if the discipline has a row in the table with status **Active**
3. If **Active** exists, skip the recommendation for that discipline
4. If the discipline is missing from the table, or its status is **Needs Update**, proceed with the recommendation
5. After the human confirms installation, update the table immediately (add or update the row)

---

