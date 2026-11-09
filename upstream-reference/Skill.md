---
name: upstream-reference
description: >
  Before designing or auditing critical logic flows (payments, order/state
  machines, auth, scheduling, webhooks, sync, retries, idempotency), search
  for mature, proven upstream implementations of the same problem class and
  align the design and tests with their documented contract — composing two
  or more complementary references when no single one covers the
  requirement. Includes a verification mode that audits existing code and
  tests against an upstream contract. Prevents reinventing solved problems
  and the guesswork, bug risk, and maintenance burden that come with it.
version: 0.1.0
---

# Upstream Reference

Find the "golden reference" for a problem before designing the solution, then
align the implementation and its tests with that reference. Use it when a
plan involves logic that others have already battle-tested — especially
where a bug produces silent, expensive outcomes (money, lost orders, stuck
state machines, missed notifications).

## When to run this skill

- **Design mode** — you have a plan or feature description and no (or little)
  implementation yet. Run this before finalizing the design of any critical
  flow.
- **Verify mode** — you have existing code + tests and a known upstream
  reference. Run this to audit alignment.

Do not run it for pure UI work, trivial CRUD, or genuinely novel problems —
the value is proportional to how "solved" the problem class is and how costly
a bug would be.

## Design mode

Input: a plan, feature description, or problem statement.

### Step 1 — Decompose into critical flows

Extract the distinct logic flows, sequences, and patterns the plan depends
on. Name each by its **problem class**, not its local implementation:

| Instead of | Name it |
|---|---|
| "POST /api/orders validates the PI then writes the row" | "payment collection → order creation consistency" |
| "update state via admin button" | "order lifecycle state machine" |
| "webhook updates paymentStatus" | "webhook-driven status sync / event fulfillment contract" |
| "the cron reminds customers" | "scheduled notifications / abandoned-resource reaping" |

Generic names find better upstreams than project-specific ones.

### Step 2 — Search widely per flow

For each flow, search the internet aggressively and in parallel where
possible:

- Query the problem class plus: `open source`, `reference implementation`,
  `state machine`, `architecture`, domain terms ("restaurant ordering",
  "booking", "fulfillment").
- Cover all three upstream shapes:
  1. **Managed/hosted services** whose execution you can adopt outright
     (hosted checkout, managed auth, queue/scheduler services, webhook
     delivery).
  2. **Vendor-documented contracts** — official API docs, event catalogs,
     protocol specs. Docs describe the canonical contract even when the
     implementation isn't public.
  3. **Production-proven open source** — mature codebases with real
     deployments, readable internals, and test suites worth mining for
     edge cases.
- Prefer candidates from strongly reputed vendors or communities, but see
  Step 3 before trusting any claim.

### Step 3 — Verify reputation; don't trust labels

Before treating anything as upstream truth, verify:

- **Authorship**: the publishing org/account actually belongs to the claimed
  vendor — check org membership, links from the vendor's own domain, and
  official announcements. A README claiming an association, a similar name,
  or a plugin ecosystem is **not** evidence. (Ecosystem plugins are
  third-party code almost by definition.)
- **Maturity evidence**: commit history, release cadence, test coverage,
  production users, issue/PR activity. Stars and marketing copy are weak
  signals; a young repo can be less proven than your own code.
- **Stability**: pre-1.0 versions and "may evolve" docs mean the contract
  shifts under you. Treat v0.x projects as *pattern references*, never
  authorities.
- **Watch for agent-generated projects**: committed AI-assistant artifacts
  (session notes, phase-plan files, resume files) suggest rapid generated
  code, not battle-tested engineering.

### Step 4 — Compose when no 1:1 match exists

If no single upstream covers the requirement set:

- Assign **one upstream per seam**. Example shape: a payment vendor's
  documented contract owns the money seam; a mature domain-specific platform
  owns the business-logic semantics (lifecycle states, lead times,
  scheduling).
- Record explicitly which upstream owns which invariant. When two references
  disagree, prefer whichever's authority covers that layer — payment
  semantics from the payment vendor, domain lifecycle from the domain
  platform.
- **Compose at seams, never mid-flow.** Splicing two references inside one
  unbroken sequence recreates the bespoke-integration risk this skill exists
  to remove.
- If the local plan fundamentally conflicts with the upstream contract,
  surface the conflict to the human instead of silently resolving it.

### Step 5 — Emit the alignment report

Produce a report containing:

1. **Candidate table** — each candidate, its maturity evidence, and what it
   could provide (adopt-as-service vs mirror-as-pattern).
2. **Chosen upstreams and why** — one paragraph each.
3. **Invariants to mirror**, per flow:
   - state machine: states + legal transitions + terminal states
   - event/webhook contract: event types, ordering, delivery semantics,
     dedup, retry/backoff behavior
   - idempotency rules: keys, replay behavior, at-least-once handling
   - timeouts and expiry: what happens to in-flight/abandoned work
   - failure modes: what each documented failure does to the record
4. **Adoption mode per seam**, chosen in this preference order:
   - `service` — their servers execute the logic (maximum de-risking;
     strongly preferred for payment, authn, and secret-bearing flows)
   - `vendored` — their library/SDK runs in your process
   - `pattern` — you reimplement their documented design in your code
5. **Test-scenario checklist** derived from upstream documentation — every
   documented edge case, failure path, duplicate/retry behavior, and legal
   transition becomes a test item, each annotated with the doc/section it
   derives from.
6. **Integration map** — the exact files/functions where local logic mirrors
   the upstream contract, so future audits have a starting point.

### Step 6 — Pin, don't track

Extract the invariants once into local artifacts (types, tests, docs) and
record the upstream version/date consulted. Do **not** design for staying in
sync with a moving upstream; the snapshot plus your tests is the durable
asset.

## Verify mode

Input: existing code (+ tests) and an upstream reference (chosen by the user
or by a design-mode run).

1. **Enumerate the upstream contract** from its documentation: states,
   transitions, events, invariants, documented failure modes. Cite the doc
   section for each.
2. **Map the local implementation** onto the contract: which local states,
   functions, handlers, and tests correspond to which upstream elements.
3. **Report divergences**, classified:
   - *Missing*: upstream states/transitions/events with no local equivalent
   - *Contradicted*: local behavior that violates documented upstream
     behavior
   - *Untested*: upstream invariants with no covering test
   - *Extended*: local additions — flag whether each is an intentional domain
     extension or drift
4. **Verdict**: `aligned` / `aligned-with-gaps` / `diverged`, plus a fix list
   ordered by severity (money and consistency bugs first, cosmetic last).

## Guardrails

- The vendor's own documentation always outranks third-party code that wraps
  it — never let a wrapper project override the underlying contract.
- "Adopt as service" de-risks more than "mirror as pattern". Prefer moving
  critical seams onto the vendor's execution before borrowing design.
- Every claim in the report must be marked verified (source checked) or
  assumed.
- If no adequate upstream exists, say so plainly — a false "golden reference"
  is worse than none.
