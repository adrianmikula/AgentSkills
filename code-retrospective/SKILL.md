---
name: code-retrospective
description: Turn any code fix into project-wide quality improvement by extracting generic patterns, searching for related instances, closing test gaps, and producing pattern docs, checklists, and roadmap entries.
---

## Overview

Given a code fix (diff, commit, PR, description, or file path), analyze the fix to extract the **generic anti-pattern** it eliminates or **pattern** it establishes. Search the codebase for all related instances, then find and close the test gaps the bug exposed. Produce pattern documentation, a development checklist, and a roadmap entry. Turn every local patch into a project-wide quality improvement.

---

## Process

### Step 1: Gather the fix

Accept one of the following as input:
- A git diff (`git diff`, `git show`, or a PR URL)
- A commit hash or PR number
- A plain-English description of what was fixed and why
- A file path to a recently modified file

If none provided, ask: **"What code fix should I document?"**

When a commit hash or PR is given, use `git show` or `gh pr diff` to obtain the diff. When a file path is given, use `git diff HEAD -- <path>` to capture recent changes.

### Step 2: Understand the fix

Read the changed files and their surrounding context. Determine:
1. What was broken or wrong before the fix?
2. What does the fix change and why was the old approach wrong?
3. Is the root cause location-specific, or a generalizable principle?
4. Does the fix introduce a new pattern or align with an existing one?

### Step 3: Classify the anti-pattern

Categorize into one of these buckets (or define a new one if none fit):

| Category | Description |
|----------|-------------|
| Error handling | Silent swallowing, wrong log level, missing propagation |
| Resource management | Leaked resources, missing cleanup/teardown |
| Concurrency | Thread safety, race conditions, blocking |
| Data flow | Missing mappings, dropped fields, format mismatches |
| Configuration | Hardcoded values, missing fallbacks, duplicated config |
| Architecture | Layering violations, circular deps, god classes |
| Testing | Missing tests, brittle assertions, untested paths |
| Performance | Unnecessary allocations, N+1 queries, blocking the UI |
| Security | Exposed secrets, injection, missing validation |
| Code hygiene | Dead code, duplication, naming inconsistencies |

### Step 4: Search for related instances

Use `grep`, `glob`, and file reads to find:
1. **Exact duplicates** — other files with the same anti-pattern
2. **Near-misses** — files one step away from the same problem
3. **Correct examples** — files that already follow the correct pattern

Record for each instance:
- File path and line number
- Classification: exact match, near-miss, or already correct
- Severity: **HIGH** (user-facing bug/data loss), **MEDIUM** (invisible degradation), **LOW** (code quality)

### Step 5: Produce pattern documentation

Check if `docs/patterns/` exists. If not, create it.

Check if an existing pattern doc already covers this category:
- **Yes** → add the new insight, anti-pattern, and example to the existing doc
- **No** → create a new file following the template below

**Template** (`docs/patterns/<pattern-name>.md`):

```markdown
# <Pattern Name>

<1-2 sentence summary>

## Overview
<When this pattern applies, why it matters>

## Rules
### Rule N: <Rule title>
<Explanation>

<Anti-pattern example — what NOT to do>

<Correct example — what to do>

## Anti-Patterns Summary
| Anti-Pattern | Problem | Fix |
|-------------|---------|-----|

## Checklist
- [ ] <Concrete, verifiable action>
```

### Step 6: Produce checklist

Every pattern doc must have a checklist covering:
- **Core logic** — what the implementer must verify
- **Integration/adapter** — what the boundary layer must do
- **UI/presentation** — what the display layer must do
- **Testing** — what tests must cover

Items must be concrete and verifiable. "Add error handling" is wrong. "Every catch block logs `e.getClass().getSimpleName()` with the failing operation context" is right.

### Step 7: Produce roadmap entry (if applicable)

Check `docs/roadmap/` for active roadmaps. If found:
1. Add the fix as a task under the appropriate phase
2. Include file paths, effort estimate, and verification criteria
3. If the fix revealed incomplete work, add follow-up tasks

Roadmap entry format:
```markdown
- [ ] <Description>
  - Files: <file paths>
  - Effort: <estimate>
  - Verify: <criteria>
```

### Step 8: Find and fix test gaps (regression-test closure)

After a fix is applied, it is not complete until at least one test fails on the pre-fix code and passes on the post-fix code. Use this procedure to find and close the test gap automatically.

1. **State the observable failure in one concrete sentence**
   - Format: "Given X, the code returns/produces Y, but should return/produce Z."
   - Examples:
     - "When the parser sees `\--- group:artifact:version`, it returns an empty list instead of the dependency."
     - "When a Jakarta equivalent is known, the table row is grey and the equivalent column is empty instead of yellow and populated."

2. **Locate the tests for the changed code**
   - Read the production files that were modified.
   - Find test files for the same classes/packages using naming conventions (`*Test`, `*Spec`, `*_test.rb`, `test_*.py`).
   - If no tests exist, create a test file in the same module/package.

3. **Detect too-weak assertions**
   - Read each candidate test and look for assertions that only check:
     - existence/non-null (`assertNotNull`, `isNotNull`, `assertTrue(... != null)`)
     - success/valid flags (`isSuccess()`, `isValid()`, `succeeded`)
     - non-emptiness (`isNotEmpty`, `size() > 0`)
     - exception thrown/not thrown
   - If any of these assertions passed while the bug existed, they are too weak. Strengthen them to assert the concrete value or state that was wrong.
   - Example upgrades:
     - `assertTrue(result.isSuccess())` → also assert `result.getDependencies()` is not empty and contains expected values.
     - `assertNotNull(coordinates)` → assert the exact coordinates string.
     - `assertEquals(OK, status)` → also assert the displayed text and color.

4. **Add a regression test for the exact symptom**
   - If no test exercises the bug path, add one using the smallest input that triggers it (a string, a mock, a fixture file, a parsed line).
   - The test must:
     - Reproduce the failing input/state.
     - Assert the corrected output exactly.
     - Pass now and have failed before the fix.

5. **Verify the tests catch the original bug**
   - Run the new or strengthened tests against the fixed code; they should pass.
   - If possible, temporarily revert the fix and re-run the tests; at least one must fail.
   - If the tests still pass with the fix reverted, the assertions are still too weak. Repeat steps 3-4.

6. **Record coverage in the pattern doc**
   - Add a **Testing** checklist item to the pattern doc from Step 5/6:
     - "Every bug fix has a regression test that fails on the pre-fix code."
     - "Assertions verify the concrete symptom, not only success/non-empty flags."

### Step 9: Report related locations and get user decision

Output a summary table of all related locations found, sorted by severity:

```
| # | File | Line | Severity | Status |
|---|------|------|----------|--------|
| 1 | SomeFile.java | 42 | HIGH | Fix needed |
| 2 | OtherFile.java | 108 | HIGH | Fix needed |
| 3 | GoodExample.java | 33 | — | Already correct |
```

If any locations have `Status: Fix needed`, ask the user:

**"Found N location(s) affected by this anti-pattern. How would you like to handle them?"**

- **Fix now** → apply the fix immediately in this session using the correct pattern from the pattern doc
- **Add to roadmap** → add them to the active roadmap as tasks with file paths, effort estimates, and verification criteria (do not fix yet)
- **Add to techdebt** → record them under `docs/techdebt/` as tracked debt items with severity, file path, and line number (do not fix yet)

If the user chooses **fix now**, apply each fix immediately using the correct pattern. If **add to roadmap**, add each location as a task in the active roadmap under the appropriate phase. If **add to techdebt**, create or append to `docs/techdebt/<pattern-name>.md`:

```markdown
# Tech Debt: <Pattern Name>

| # | File | Line | Severity | Added | Status |
|---|------|------|----------|-------|--------|
| 1 | SomeFile.java | 42 | HIGH | <date> | Open |
| 2 | OtherFile.java | 108 | MEDIUM | <date> | Open |
```

### Step 10: Cross-reference

- If a **new** pattern doc was created: reference it from `AGENTS.md`, any active roadmap, and the `docs/patterns/` index (if one exists)
- If an **existing** pattern doc was updated: add a changelog note at the top of the modified section

---

## Anti-Pattern Categories Reference

Use this table when classifying in Step 3:

| Category | Detection signals | Common languages |
|----------|-------------------|------------------|
| Error handling | Empty catch, catch-and-ignore, `print` for errors | All |
| Resource management | Missing `finally`, unclosed streams/connections | Java, Python, C# |
| Concurrency | Shared mutable state, missing locks, UI thread blocking | Java, JavaScript, Swift |
| Data flow | Silent field drops, missing null checks on map results | All |
| Configuration | Magic numbers, `localhost` in prod code, duplicated URLs | All |
| Architecture | Service calling service directly, circular imports | All |
| Testing | No test for new branch, `assertTrue(true)`, assertions that pass on buggy code, mocking everything | All |
| Performance | Loop queries, synchronous I/O in hot path, no caching | All |
| Security | String concatenation in queries, secrets in source | All |
| Code hygiene | Copy-pasted blocks, `temp`/`foo` names, unused imports | All |

---

## Rules

- **Generic over specific**: Frame rules for any module, not just the triggering one. Use the fixing module as an example only.
- **Anti-patterns require correct examples**: Never document what's wrong without showing what's right.
- **Checklists must be concrete**: Every item must be verifiable. No aspirational goals.
- **Don't duplicate**: Check `docs/patterns/` first. Extend, don't fork.
- **Severity matters**: Not every anti-pattern is a bug. Classify so teams can prioritize.
- **Respect existing style**: Read an existing pattern doc before creating one to match tone and structure.
- **Fixes need regression tests**: A bug fix is not complete until at least one test fails on the pre-fix code and passes on the post-fix code.

---

## Output Summary

Return exactly:
1. **Pattern doc** (new or updated) with full content
2. **Related locations table** sorted by severity
3. **User decision**: fix now, add to roadmap, or add to techdebt
4. **Roadmap entry** (if add to roadmap was chosen)
5. **Regression tests and strengthened assertions** from Step 8, with one line per test/change
6. **Files created/updated/cross-referenced** with one-line descriptions
