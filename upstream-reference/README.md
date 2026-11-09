# Upstream Reference Skill

A skill that finds the "golden reference" for a problem before designing the solution, then aligns the implementation and its tests with that reference — preventing reinvented solved problems and the guesswork, bug risk, and maintenance burden that come with them.

## When to use it

Run this skill when a plan involves logic that others have already battle-tested — especially where a bug produces silent, expensive outcomes (money, lost orders, stuck state machines, missed notifications). Do not run it for pure UI work, trivial CRUD, or genuinely novel problems.

## Modes

- **Design mode** — given a plan or feature description, decompose it into critical flows, search for mature upstream implementations (managed services, vendor-documented contracts, production-proven open source), verify their reputation, compose complementary references when no single one covers the requirement, and emit an alignment report with invariants to mirror, an adoption mode per seam (`service` / `vendored` / `pattern`), a test-scenario checklist, and an integration map.
- **Verify mode** — given existing code and tests plus an upstream reference, enumerate the upstream contract, map the local implementation onto it, and report divergences (missing, contradicted, untested, extended) with a severity-ordered fix list and an `aligned` / `aligned-with-gaps` / `diverged` verdict.

## Guardrails

- Vendor documentation always outranks third-party wrappers.
- Prefer adopting critical seams as a service over mirroring as a pattern.
- Every claim in the report is marked verified or assumed.
- If no adequate upstream exists, the skill says so plainly.

## Usage

Invoke this skill before finalizing the design of any critical flow (payments, order/state machines, auth, scheduling, webhooks, sync, retries, idempotency), or to audit existing code and tests against a known upstream contract.
