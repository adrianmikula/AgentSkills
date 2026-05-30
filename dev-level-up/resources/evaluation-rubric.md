# Evaluation Rubric

Score every finding across 5 axes on a 1–5 scale. Use the descriptions below to anchor scores consistently.

---

## Axis 1: Speed

| Score | Description |
|-------|-------------|
| 1 | No measurable speed improvement; may slow workflow |
| 2 | Minor speedup for narrow tasks (<10% time reduction) |
| 3 | Moderate speedup for common tasks (10–25% reduction) |
| 4 | Significant speedup for broad tasks (25–50% reduction) |
| 5 | Near-instant adoption; cuts task time by 50%+ or eliminates entire manual steps |

**Examples:**
- 5: A new IDE extension that auto-generates boilerplate with a single keystroke
- 3: A linter update that catches errors slightly faster than before
- 1: A tool requiring heavy manual setup with no clear time savings

---

## Axis 2: Accuracy

| Score | Description |
|-------|-------------|
| 1 | Increases risk of errors or introduces new failure modes |
| 2 | No impact on correctness; purely cosmetic or convenience |
| 3 | Catches some common errors or reduces simple bugs |
| 4 | Eliminates a class of bugs or enforces correctness at compile/build time |
| 5 | Eliminates entire error categories automatically (e.g., type-safe codegen, formal verification integration) |

**Examples:**
- 5: A React compiler that eliminates useMemo misuse entirely
- 4: A Python type checker update that catches previously missed None errors
- 1: An AI tool known to hallucinate APIs or generate insecure code

---

## Axis 3: Capacity

| Score | Description |
|-------|-------------|
| 1 | Reduces what you can deliver or introduces blocking constraints |
| 2 | No change in deliverable scope |
| 3 | Unlocks modest new capabilities (new library, new pattern) |
| 4 | Unlocks significant new workflows (multi-file codegen, test auto-generation) |
| 5 | Enables previously impossible tasks or unlocks 10x throughput (e.g., agentic full-stack generation, autonomous refactoring) |

**Examples:**
- 5: An AI agent that can scaffold an entire CRUD API from a schema definition
- 3: A new Python library that simplifies one common ML pipeline step
- 1: A tool that requires so much manual correction it slows overall output

---

## Axis 4: Tools

| Score | Description |
|-------|-------------|
| 1 | No concrete tool; vague concept or speculative research only |
| 2 | Experimental tool with no install path or heavy custom build |
| 3 | Installable tool but with rough edges or limited integration |
| 4 | Polished tool with clear install instructions and IDE/editor integration |
| 5 | Immediately installable; integrates seamlessly with existing toolchain (IDE plugin, CLI, npm/pip/Maven package) |

**Examples:**
- 5: A VS Code extension available on the marketplace with one-click install
- 4: A CLI tool distributed via Homebrew / npm / pip with clear docs
- 1: A research paper describing a technique with no implementation

---

## Axis 5: Agility

| Score | Description |
|-------|-------------|
| 1 | Locked-in, hard to reverse, or requires heavy migration |
| 2 | Reversible but requires significant effort to undo |
| 3 | Moderate adoption cost; some config or learning curve |
| 4 | Low friction; minimal config, easy to try and revert |
| 5 | Drop-in replacement or zero-config addition; fully reversible with no side effects |

**Examples:**
- 5: Adding a new VS Code extension that can be disabled instantly
- 3: Adopting a new build tool that requires updating CI pipelines
- 1: A framework that requires rewriting existing components to adopt

---

## Classification Thresholds

After scoring all 5 axes, compute the total (range 5–25) and classify:

| Classification | Total Score | Additional Condition |
|----------------|-------------|----------------------|
| **Quick Win** | >= 20 | Agility >= 4 |
| **Deep Dive** | >= 18 | Agility <= 3 |
| **Watch** | 12–17 | None |
| **Skip** | < 12 | Or unverifiable claim |

**Tiebreaker rule:** If a finding scores exactly 20 but Agility = 3, classify as **Deep Dive**.

---

## Adoption Time Estimation

Estimate the concrete wall-clock time a competent developer needs to adopt the finding and see first value. Use these buckets:

| Time Bucket | Label | Examples |
|-------------|-------|----------|
| < 15 min | **Immediate** | Install a VS Code extension, toggle a setting, copy a snippet |
| 15–60 min | **Quick** | Configure a new linter rule, set up a simple CLI alias, read a short tutorial |
| 1–4 hrs | **Half day** | Integrate a new library, migrate a small module, set up a new GitHub Action |
| 4–8 hrs | **Day** | Adopt a new framework feature across a codebase, set up a complex multi-agent pipeline |
| 1+ days | **Major** | Full migration, replace a build system, adopt a new architectural pattern |

When estimating, assume the developer has the finding's documentation open and is working in a familiar codebase. Do not include "learning the concept" time unless the concept is genuinely novel and complex.

---

## Bang for Buck Score

For every finding that passes classification, compute:

```
Bang for Buck = Total Score / Adoption Time (in hours)
```

Use the midpoint of each time bucket:
- Immediate (0.25 hrs)
- Quick (0.6 hrs)
- Half day (2.5 hrs)
- Day (6 hrs)
- Major (use 16 hrs as baseline, or note if estimated longer)

### Interpretation

| Bang for Buck | Meaning |
|---------------|---------|
| > 15 | Exceptional — massive impact for tiny time investment |
| 8–15 | Strong — high ROI, prioritize |
| 4–8 | Good — solid value, adopt if time permits |
| 2–4 | Moderate — worthwhile only if it solves a specific pain point |
| < 2 | Low — consider only with abundant time or high strategic need |

This score is the primary sort key when making the 80/20 Recommendation.
