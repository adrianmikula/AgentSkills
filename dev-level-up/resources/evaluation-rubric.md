# Evaluation Rubric

`dev-level-up` evaluates candidates in two stages: admission gates first, then a 7-axis score for survivors. The goal is to surface recent improvements that are relevant to the user's `.tech-stack/` scope and selected objectives, not merely interesting technology news.

---

## Admission Gates

Apply these gates before scoring. A candidate that fails a hard gate is excluded; a candidate that is weak but plausible may be downgraded to `Watch` or `Deep Dive`.

| Gate | Requirement | Failure Handling |
|------|-------------|------------------|
| **Freshness** | Published within the last 30 days, verified by API/feed/date evidence. | Exclude. |
| **Scope relevance** | Affects a `.tech-stack/` domain, manual/custom domain, or clearly selected objective. | Exclude unless it is a broadly applicable AI/dev breakthrough explicitly requested by the user. |
| **Objective relevance** | Advances at least one selected improvement objective. | Exclude or reclassify under a better objective if one exists. |
| **Evidence quality** | Has official release/docs/repo/paper/benchmark or credible corroboration. | Downgrade to `Watch` if promising but unverifiable. |
| **Actionability** | Offers a tool, version, pattern, config, workflow, migration path, or concrete research direction. | Downgrade to `Watch` if only conceptual. |
| **Duplication** | Same underlying release/tool/technique is merged into one candidate. | Merge and keep the strongest source set. |

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

- 5: An agentic coding tool that generates a tested CRUD module from a schema in one pass.
- 3: A faster test runner that shaves seconds off the inner loop.
- 1: A conceptual technique requiring extensive manual setup with no clear time savings.

---

## Axis 2: Accuracy

| Score | Description |
|-------|-------------|
| 1 | Increases risk of errors or introduces new failure modes |
| 2 | No impact on correctness; purely cosmetic or convenience |
| 3 | Catches some common errors or reduces simple bugs |
| 4 | Eliminates a class of bugs or enforces correctness at compile/build/test time |
| 5 | Eliminates entire error categories automatically, such as type-safe codegen, formal verification, or enforced invariants |

**Examples:**

- 5: A compiler/runtime feature that makes an entire bug class impossible.
- 4: A type-system or contract-test upgrade that catches previously missed integration errors.
- 1: An AI tool known to hallucinate APIs or generate insecure code.

---

## Axis 3: Capacity

| Score | Description |
|-------|-------------|
| 1 | Reduces what the team can deliver or introduces blocking constraints |
| 2 | No change in deliverable scope |
| 3 | Unlocks modest new capabilities, such as a new library or pattern |
| 4 | Unlocks significant new workflows, such as multi-file codegen or test auto-generation |
| 5 | Enables previously impossible tasks or unlocks 10x throughput |

**Examples:**

- 5: An agent that can scaffold, test, and document an entire service from a spec.
- 3: A new framework feature that simplifies one complex domain.
- 1: A tool that requires so much correction it slows overall output.

---

## Axis 4: Tools

| Score | Description |
|-------|-------------|
| 1 | No concrete tool; vague concept or speculative research only |
| 2 | Experimental tool with no install path or heavy custom build |
| 3 | Installable tool but with rough edges or limited integration |
| 4 | Polished tool with clear install instructions and IDE/editor/CI integration |
| 5 | Immediately installable; integrates seamlessly with the detected toolchain |

**Examples:**

- 5: A package or extension already compatible with the repo's package manager, IDE, and CI.
- 4: A CLI distributed through the ecosystem's standard registry with clear docs.
- 1: A research paper describing a technique with no implementation.

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

- 5: Adding an IDE extension or lint rule that can be disabled instantly.
- 3: Adopting a build/test tool that requires CI pipeline changes.
- 1: Replacing a core framework or datastore with no migration path.

---

## Axis 6: Objective Fit

Score how directly the finding advances the selected improvement objective or best-matching objective when `All objectives` was selected.

| Score | Description |
|-------|-------------|
| 1 | Does not meaningfully advance the objective |
| 2 | Tangentially related; benefit depends on broader changes |
| 3 | Partially advances the objective or applies to an adjacent domain |
| 4 | Strongly advances the objective with minor adaptation or setup |
| 5 | Directly advances the objective for the detected stack; adoption path is clear |

**Examples:**

- 5: A Terraform/OpenTofu feature that directly enables a selected capability-expansion goal.
- 4: An AI code-review tool that directly supports correctness verification but needs repo-specific rule tuning.
- 2: A generic productivity article that mentions the domain but offers no objective-specific mechanism.

---

## Axis 7: Stack Relevance

Score how directly the finding applies to the `.tech-stack/` domains in scope.

| Score | Description |
|-------|-------------|
| 1 | Unrelated to the detected/manual scope |
| 2 | Generic developer practice with indirect relevance |
| 3 | Adjacent domain or ecosystem; likely useful after adaptation |
| 4 | Applies to the detected ecosystem with minor assumptions or configuration |
| 5 | Directly upgrades, replaces, extends, or improves a detected/manual domain |

**Examples:**

- 5: A Next.js release-note item for a repo whose `.tech-stack/frameworks.md` lists Next.js 15.
- 4: A React ecosystem tool for a repo using React through Next.js.
- 2: A generic AI coding tip that could apply anywhere but has no stack-specific mechanism.

---

## Classification Thresholds

After scoring all 7 axes, compute the total (range 7–35) and classify:

| Classification | Total Score | Additional Condition |
|----------------|-------------|----------------------|
| **Quick Win** | >= 28 | Agility >= 4 |
| **Deep Dive** | >= 25 | Agility <= 3 |
| **Watch** | 18–24 | None |
| **Skip** | < 18 | Or failed an admission gate |

**Ordering rule:** Check Quick Win first, then Deep Dive, then Watch, then Skip.

**Tiebreaker rule:** If a finding scores exactly 28 but Agility = 3, classify as **Deep Dive**.

---

## Adoption Time Estimation

Estimate the concrete wall-clock time a competent developer needs to adopt the finding and see first value. Use these buckets:

| Time Bucket | Label | Examples |
|-------------|-------|----------|
| < 15 min | **Immediate** | Install an extension, toggle a setting, copy a snippet |
| 15–60 min | **Quick** | Configure a lint rule, set up a CLI alias, read a short tutorial |
| 1–4 hrs | **Half day** | Integrate a library, migrate a small module, add a GitHub Action |
| 4–8 hrs | **Day** | Adopt a framework feature across a codebase, set up a multi-agent pipeline |
| 1+ days | **Major** | Full migration, replace a build system, adopt a new architectural pattern |

When estimating, assume the developer has the finding's documentation open and is working in a familiar codebase. Do not include "learning the concept" time unless the concept is genuinely novel and complex.

---

## Bang for Buck Score

For every finding that passes classification, compute:

```text
Bang for Buck = Total Score / Adoption Time (in hours)
```

Use the midpoint of each time bucket:

- Immediate: 0.25 hrs
- Quick: 0.6 hrs
- Half day: 2.5 hrs
- Day: 6 hrs
- Major: 16 hrs baseline, or note if estimated longer

### Interpretation

| Bang for Buck | Meaning |
|---------------|---------|
| > 15 | Exceptional — massive impact for tiny time investment |
| 8–15 | Strong — high ROI, prioritise |
| 4–8 | Good — solid value, adopt if time permits |
| 2–4 | Moderate — worthwhile only if it solves a specific pain point |
| < 2 | Low — consider only with abundant time or high strategic need |

This score is the primary sort key for the 80/20 recommendation. Use Stack Relevance and Objective Fit as tie-breakers when Bang for Buck values are close.
