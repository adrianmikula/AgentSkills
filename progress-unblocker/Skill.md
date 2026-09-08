---
name: progress-unblocker
description: Create visual progress snapshots for a dev task across requirements, design, implementation, configuration, dev testing, and production deployment. Breaks stuck work into smaller parts and prioritises blockers, actions, and completion with unblocking alternatives.
---

## Overview

This skill turns a loose or blocked dev task into a clear, visual status board. It tracks work through six delivery phases and forces each phase to answer three questions:

- **Blockers** — what is stopping progress?
- **Actions** — what is the next concrete step?
- **Completion** — how much of this phase is done?

When a phase is stuck, it is decomposed into smaller, parallel or sequential sub-tasks with alternatives. Unconfirmed design or architectural choices are surfaced first so the team can gather the information needed for a confident decision.

---

## Delivery Phases

1. **Requirements gathering**
2. **Design / architectural choices**
3. **Implementation**
4. **Configuration**
5. **Dev testing**
6. **Production deployment / testing**

---

## Process

### 1. Capture the current task

Ask the user (or infer from context):

- What is the overall goal?
- What has been completed so far?
- What feels stuck, unclear, or blocked?
- Are any design or architectural decisions still open?

### 2. Build the summary progress board

For each delivery phase, render a row with:

| Phase | Status | Completion | Blockers | Next Action |
|-------|--------|------------|----------|-------------|
| Requirements gathering | `Not started` / `In progress` / `Blocked` / `Complete` | `0%` | ... | ... |
| Design / architectural choices | ... | ... | ... | ... |
| Implementation | ... | ... | ... | ... |
| Configuration | ... | ... | ... | ... |
| Dev testing | ... | ... | ... | ... |
| Production deployment / testing | ... | ... | ... | ... |

### 3. Deep-dive any blocked phase

For every phase with status `Blocked`, produce a dedicated sub-board:

| Sub-task | Purpose | Action options | Alternatives if still stuck |
|----------|---------|----------------|-----------------------------|
| ... | ... | ... | ... |

Each sub-task must be small enough to finish in one session. If the blocker is external (waiting on a person, system, or decision), include:

- Who/what is being waited on
- The question that needs an answer
- A fallback if the answer is delayed

### 4. Prioritise unconfirmed architectural choices

For any design or architecture not yet decided, create a decision card:

- **Open decision:** what needs to be chosen?
- **Information required:** what is missing?
- **Options:** 2–4 realistic options with short trade-offs
- **Decision criteria:** what would make one option clearly better for this project?
- **Cheapest way to gather the missing info:** spike, prototype, document review, stakeholder question
- **Recommended default action:** what to do if the decision cannot be made immediately

If multiple architectural questions exist, rank them by how much they block later phases.

### 5. Render the full picture

Combine the three outputs into one visual response:

1. Summary progress board (all six phases)
2. Blocker deep-dives (one per blocked phase)
3. Decision cards (one per unconfirmed architectural choice)

Use markdown tables as the default format. If useful, add a mermaid flowchart or ASCII pipeline showing the order of phases and where work is stuck.

---

## Output Rules

- Always lead with the summary board so the user sees the whole picture first.
- Never mark a phase `Complete` unless its acceptance criteria are explicit and satisfied.
- A phase is `Blocked` only when the next action cannot start without an external input or a decision.
- Sub-tasks should be smaller than the original blocker and independently actionable.
- Every blocked phase must have at least one alternative path to keep the task moving.
- Unconfirmed architectural choices must appear before implementation details, because they gate later work.

---

## Output Summary

Return:

1. The summary progress board
2. Blocker deep-dives for any blocked phases
3. Decision cards for any unconfirmed design or architecture
4. A short list of the highest-impact next actions, ordered by what unblocks the most downstream work
