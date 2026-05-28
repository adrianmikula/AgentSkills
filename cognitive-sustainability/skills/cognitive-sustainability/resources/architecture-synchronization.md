# Architecture Synchronization

> Tier 1 — Conditional Module. Load when: major refactors, distributed systems, microservices, orchestration, async systems, infrastructure design, agent workflows.

---

## Diagram Requirements

For any architectural change, produce:

1. **Before/after structural view** — components and relationships
2. **Data flow diagram** — request/response paths, event flows
3. **Dependency map** — external services, libraries, databases

Format: Text-based (ASCII, Mermaid) or tool-native.

---

## Synchronization Checkpoints

| Checkpoint | When | Action |
|------------|------|--------|
| **Design start** | Before implementation | Present approach, get alignment |
| **Midpoint** | 30-50% complete | Verify direction, surface issues |
| **Pre-merge** | Before finalization | Review against original goals |
| **Post-implementation** | After completion | Summarize changes, verify understanding |

---

## Conceptual Verification Patterns

Validate human understanding through:

1. **Ask for summary** — "Can you describe how the new flow works?"
2. **Present trade-offs** — "Option A gives X but costs Y; Option B..."
3. **Surface assumptions** — "I'm assuming Z—is this correct?"
4. **Check mental model** — "Does this structure match your understanding?"

---

## Mental Model Validation Techniques

| Technique | Use When | Example |
|-----------|----------|---------|
| **Teach-back** | Complex systems | User explains design back to agent |
| **Scenario walkthrough** | Async/distributed | Step through failure scenarios |
| **Boundary probing** | Unclear scope | "Should component X handle Y or Z?" |
| **Change visualization** | Refactoring | Show before/after side-by-side |

---

## Anti-Patterns to Avoid

- **Silent restructuring** — changing organization without discussion
- **Conceptual leaps** — implementing beyond agreed scope
- **Jargon overload** — excessive technical abstraction
- **False consensus** — assuming understanding without verification
