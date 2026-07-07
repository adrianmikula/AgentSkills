# Business Idea Incubator

A multidisciplinary Claude Skill that helps entrepreneurs validate, refine, and implement business ideas. Adapts to your experience level across 12 key disciplines — including funding & capital strategy — and tracks progress over time. A core priority is understanding your actual financial resources before making any recommendations.

## Disciplines Covered

| # | Discipline | What It Covers |
|---|-----------|---------------|
| 1 | Idea Validation | Problem-solution fit, MVP definition, hypothesis testing |
| 2 | Startup Foundations | Entity formation, equity, cofounder agreements, runway planning |
| 3 | Marketing | Positioning, messaging, channel strategy, go-to-market |
| 4 | Outreach & Offer Framing | Offer design, pricing psychology, cold outreach scripts |
| 5 | Profitability & Financial Modelling | Unit economics, break-even, pricing strategy |
| 6 | Competitive Intelligence | Competitor mapping, differentiation, positioning |
| 7 | Business Operations | Systems, metrics, processes, scaling infrastructure |
| 8 | Vibe Coding / Rapid Prototyping | MVP development, no-code stacks, prompt-to-prototype |
| 9 | Production Deployment | Hosting, CI/CD, monitoring, security hardening |
| 10 | E-commerce & Online Selling | Store setup, CRO, fulfilment, payment processing |
| 11 | Social Media Presence | Content strategy, platform selection, community building |
| 12 | Funding & Capital Strategy | Pre-revenue funding, bootstrapping, grants, crowdfunding, angels/VC, revenue-first strategies, funding securement process |

## How It Works

1. **Initialise your profile** — Rate your confidence in each discipline and identify blind spots
2. **Adaptive coaching** — The Skill focuses on your weak areas and provides extra scaffolding where needed
3. **State tracking** — Progress is saved in `.ideas/` so you can pick up where you left off
4. **Multidisciplinary analysis** — When evaluating ideas, the Skill loads relevant disciplines and applies them to your specific context
5. **Recommended skills** — Each discipline includes a curated index of Claude skills that can extend capability

## State Management

The Skill creates a `.ideas/` folder in your project root:

```
.ideas/
├── human-profile.md       # Your expertise levels, financial resources, and preferences
├── personality-profile.md # Working style, strengths, weaknesses
├── funding/
│   └── [idea-slug].md      # Funding status, milestones, and grant/investor tracking per idea
└── ideas/
    └── [idea-name].md     # One file per business idea (deduplicated)
```

## Usage

Load the Skill and interact naturally. On first run, it will ask about your experience levels and preferences. After that, it remembers and adapts.

**Example interactions:**
- "I have an idea for a pet-sitting app. Help me validate it."
- "Rate my SaaS pricing strategy."
- "Build a quick prototype for my food truck ordering system."
- "What social media channels should I focus on for my B2B consulting business?"

## Extending the Skill

To add a new discipline:

1. Create a new markdown file in `resources/` (e.g., `resources/fundraising.md`).
2. Follow the same structure as existing discipline files: overview, frameworks, pitfalls, recommended skills, templates.
3. Register the discipline in `Skill.md` under **Available Disciplines** and add the onboarding survey item.
4. Update the **Disciplines Covered** table in this README.
5. Update `build-skill.sh` to copy the new resource file.

## Building the Skill

Run the build script to package the Skill into a `.zip` file for import into Claude:

```bash
./build-skill.sh
```

This produces `business-idea-incubator-skill.zip` containing the Skill definition and all resource files.
