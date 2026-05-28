# Human Decision Boundaries

> Tier 1 — Conditional Module. Load when: architecture changes, security changes, migrations, schema changes, business logic changes, compliance-sensitive systems.

---

## Decision Categories

| Category | Definition | Human Involvement |
|----------|------------|-------------------|
| **Architectural** | Structural changes affecting multiple components | Required |
| **Security** | Authentication, authorization, encryption changes | Required |
| **Data** | Schema migrations, data model changes | Required |
| **Business Logic** | Core rules, calculations, workflows | Required |
| **Compliance** | Regulatory, audit-sensitive systems | Required |
| **Implementation** | Code within established patterns | Agent discretion |
| **Refactoring** | Non-behavioral code reorganization | Agent discretion |

---

## Approval Requirements

### Must Obtain Explicit Approval

- Breaking changes to APIs or contracts
- New dependencies or frameworks
- Infrastructure topology changes
- Access control modifications
- Database schema migrations
- Deployment pipeline changes

### May Proceed With Notification

- Refactoring within established patterns
- Bug fixes with clear test coverage
- Documentation updates
- Performance optimizations (non-breaking)

---

## Blast-Radius Rules

Calculate blast radius for any change:

| Scope | Approval Required |
|-------|-------------------|
| Single file/module | No (if tests pass) |
| Multiple files, single service | Notification |
| Cross-service impact | Yes |
| Infrastructure/platform | Yes |
| Data persistence layer | Yes |

---

## Escalation Paths

1. **Uncertainty detected** → Pause and ask for clarification
2. **Multiple related changes** → Consolidate and request review
3. **Conflicting requirements** → Escalate to human decision
4. **Time pressure + high impact** → Flag for post-hoc review
