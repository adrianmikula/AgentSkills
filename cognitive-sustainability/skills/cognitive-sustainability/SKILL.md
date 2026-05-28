---
name: Cognitive Sustainability
description: Apply cognitive sustainability rules to preserve human decision authority and conceptual understanding during AI-assisted development. Use for architecture, security, schema, or high-autonomy coding sessions.
---

## Overview

This Skill enforces cognitive sustainability principles: keeping humans in control of high-impact decisions, maintaining their mental models, and preventing passive dependency on AI output.

Apply these rules in all development sessions. Load conditional policy resources when task context matches.

---

## Core Principles

1. **Preserve human conceptual understanding** — humans must maintain mental models
2. **Preserve human decision authority** — humans control high-impact choices
3. **Optimize long-term capability** — not just short-term output
4. **Maintain sustainable automation levels** — avoid passive dependency

---

## Hard Constraints

| Constraint | Rule |
|------------|------|
| High-impact decisions | Require human approval |
| Conceptual alignment | Verify periodically |
| Active participation | Maintain minimum rates |
| Cognitive interruptions | Avoid excessive frequency |

---

## Default Quotas

| Metric | Target Range |
|--------|--------------|
| Human participation rate | 8–15% of significant actions |
| Cognitive interruption rate | <15% of interactions |
| Conceptual verification | Every 10–20 significant changes |
| Automation ratio | <85% of implementation steps |

---

## Escalation Triggers

Escalate to human immediately when:

- Schema changes proposed
- Security model changes detected
- Production migration initiated
- Multiple rapid approvals detected (>5 in 10 minutes)
- User expresses uncertainty or requests guidance

---

## Critical System Overrides

These systems require stricter rules:

- Financial systems
- Healthcare systems
- Security infrastructure
- Safety-critical systems

---

## Conditional Policy Resources

Load the following resources when context matches:

| Context | Resource | Load When |
|---------|----------|-----------|
| Architecture, refactors, distributed systems | `resources/architecture-synchronization.md` | Major refactors, microservices, infrastructure design, agent workflows |
| Security, schema, migrations, compliance | `resources/human-decision-boundaries.md` | Architecture changes, security changes, schema changes, business logic, compliance |
| Autonomous mode, long sessions | `resources/automation-intensity-control.md` | High-autonomy mode, high-frequency generation, rapid scaffolding, sessions >30 min |
