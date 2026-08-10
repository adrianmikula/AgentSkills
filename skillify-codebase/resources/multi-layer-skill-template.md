# Multi-Layer Skill Template

> Use this template when the chosen mitigation for a one-shot hazard is **multi-layer / zonal generation**. Zonal decomposition is not the only way to handle a one-shot hazard, but it is especially effective when the output has spatial, visual, numerical, or step-order invariants that are easier to verify per-zone than whole.

A multi-layer skill splits a module into **three deterministic layers**. The agent may not skip a layer or merge them into a single generation step.

---

## Skill Header

```markdown
---
name: <module-or-task-name>-layers
description: >
  Multi-layer skill for <module>. Layer 1 = spec/plan, Layer 2 = per-zone
  generation, Layer 3 = composition and verification.
---

# <Module Name> Multi-Layer Skill

> **Boundary:** <Human Input | AI/Skills | Code | Config>
> **Input:** <brief description of user brief / raw artifact>
> **Output:** <final rendered or structured artifact>
> **Layers:** 3
```

---

## Layer 1 — Spec / Plan

Output a single structured spec table before any generation begins. Do not produce any part of the artifact until the spec is complete.

| Field | Value | Notes |
|-------|-------|-------|
| Canvas / container | `<width>x<height>` or `<bounding box>` | Exact dimensions, units, coordinate system |
| Zones | list of zone names | One named sub-region per row |
| Per-zone dimensions | `x, y, w, h` or path descriptors | Anchor points, radii, stroke bounds |
| Palette | hex / rgb / named colors | Forbidden colors, contrast minimums, mode rules |
| Stroke / line / texture invariants | widths, dash patterns, corner radii, gradients | Must hold across every zone |
| Duplicates | which zones repeat, with offsets | Do not regenerate; use the transform helper |
| Mirrors | which zones are mirrored or rotated | Axis, angle, flip rules |
| Ordered steps | step list and dependencies | For flows/wizards: what must happen before what |
| Acceptance check | list of pass/fail assertions | Used by Layer 3 |

### Spec acceptance rule

Before moving to Layer 2, the agent must be able to answer **yes** to:

- [ ] Every zone has a unique name and defined bounds
- [ ] Every color/number/style invariant is recorded
- [ ] Duplicates and mirrors are fully described (not just drawn)
- [ ] The acceptance check is explicit and testable

---

## Layer 2 — Per-Zone Generation

Generate **one sub-artifact per zone**. A zone is the smallest unit that can be verified independently. Do not generate the final combined artifact yet.

For each zone:

1. **Load** the zone row from the Layer 1 spec.
2. **Generate** the zone artifact with the zone's own constraints.
3. **Tag** the output with the zone name and version.
4. **Stop** and compare against the spec row before moving to the next zone.

### Output table

| Zone | Generated? | Verification against spec | Notes |
|------|------------|---------------------------|-------|
| `<zone-1>` | [ ] | passes / fails | |
| `<zone-2>` | [ ] | passes / fails | |
| ... | | | |

---

## Layer 3 — Composition & Verification

1. **Assemble** all zone sub-artifacts according to the Layer 1 layout table.
2. **Apply** duplication / mirroring transforms using the helper below.
3. **Run the acceptance check** from Layer 1.
4. **Output** the final artifact **only if** all checks pass.
5. **If any check fails**, return to the failing layer (usually Layer 2 for a single zone, Layer 1 if the spec itself was wrong) and regenerate that layer only.

### Generic Mirroring / Duplication Helper

Use this to create derived zones without re-generating them from scratch.

| Transform | Inputs | Effect |
|-----------|--------|--------|
| `duplicate` | `(source_zone, offset_x, offset_y, count)` | Copy source zone N times at fixed offsets |
| `mirror_x` | `(source_zone, axis_x)` | Flip horizontally across a vertical axis |
| `mirror_y` | `(source_zone, axis_y)` | Flip vertically across a horizontal axis |
| `rotate` | `(source_zone, degrees, cx, cy)` | Rotate around a center point |
| `clone_with_style` | `(source_zone, palette_swap)` | Copy a zone and replace colors via map |

All derived zones inherit the source zone's invariants unless the transform explicitly overrides them. Record derived zones in the final composition table.

### Final verification table

| Assertion | Expected | Actual | Pass |
|-----------|----------|--------|------|
| `<assertion-1>` | `<value>` | `<measured>` | [ ] |
| `<assertion-2>` | `<value>` | `<measured>` | [ ] |
| ... | | | |

---

## Related Skills

- `skills/<orchestrator>/SKILL.md` — entry point that calls this multi-layer skill
- `skills/<sibling>/SKILL.md` — any skill that consumes the verified output of this skill
- `skills/<data-input>/SKILL.md` — any skill that produces the raw inputs for Layer 1

---

## Layer Output Locations

Record where each layer's output lives so a downstream agent does not collapse the skill back into a one-shot call.

| Layer | Output file / artifact | Format | Verifier |
|-------|------------------------|--------|----------|
| Layer 1 — Spec | `skills/<name>/spec.md` or inline table | Markdown / YAML | Human or agent review |
| Layer 2 — Zone artifacts | `skills/<name>/zones/` or inline per-zone blocks | SVG / JSON / text per zone | Spec comparison |
| Layer 3 — Composed artifact | `skills/<name>/output.{svg,json,md,...}` | Final output format | Acceptance check |
