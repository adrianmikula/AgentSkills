# Skill-Sync Process

> **Standard mode.** Use during Phase 4 of skillification and for ongoing maintenance. Contains detailed sync triggers, forward/reverse procedures, AI agent rules, commit conventions, verification checklist, and drift detection.

## Sync Triggers

| Trigger | Direction | Process |
|---------|-----------|---------|
| Business logic change | Skill → Code (forward) | Update skill capability → edit config.yaml → apply file mapping → run tests |
| Bug fix discovered in code | Code → Skill (reverse) | Fix code → update skill to reflect corrected behavior → bump version |
| New feature | Skill → Code (forward) | Add capability to skill first → add config keys → implement code |
| Parameter tuning only | Skill → Code (forward) | Edit config.yaml only — no skill markdown changes needed |
| Dependency update | Neither | Update mapping.toml dependency versions only |
| Research mode sync | Lockfile | Verify hashes, check fixed vs open layer change, cascade if needed |

---

## Config-Driven Sync Procedure (Forward)

When business logic changes upstream (skill):

1. **Update the skill capability** — modify Logic, Error states, or Config parameters in SKILL.md
2. **Edit config.yaml** — update the specific config path(s) that changed. This is the primary action.
3. **Apply file mapping** — for each changed `impl_file` in the mapping, navigate to that file+function and apply the downstream equivalent change
4. **Bump version** — update `skill_version` in both `config.yaml` and `mapping.toml`
5. **Run tests** — verify all mapped test files pass
6. **Commit** — using the convention below

---

## Reverse Sync (Code → Skill)

When a fix is discovered in code that changes behavior:

1. **Fix the code** as normal
2. **Update config.yaml** if parameter values changed
3. **Update the skill** to reflect the corrected behavior in Logic / Error states
4. **Bump version** — update `skill_version` in `config.yaml` and `mapping.toml`
5. **Document the divergence** — add a note:
    ```
    reverse-sync note: {date} — {description of code fix}
    Skill updated to match corrected behavior.
    ```
6. **Commit** — using the convention below

---

## AI Agent Sync Rules

When an AI agent performs the sync, it MUST follow these hard constraints:

| Rule | Detail |
|------|--------|
| **Never change the capability interface** | Inputs, outputs, and capability names are stable. Only the implementation inside each capability changes. |
| **Never add source code to the skill** | The generated skill is MD, YAML, TOML, JSON only. CLI helper scripts (bash/PowerShell) may live in `resources/`. No `.ts`, `.js`, `.py`, `.rs`, `.kt`, `.java`, or any compiled language files. |
| **Update config.yaml first** | Config is the primary sync target. Changes to logic descriptions in SKILL.md are secondary. |
| **Bump version** | Update `skill_version` in both `config.yaml` and `mapping.toml` to the new upstream version. |
| **Never hardcode a value in the skill markdown** | If the change requires a new constant, add it to `config.yaml` and reference it from the skill by config path. |
| **Update mapping.toml** | If a new section was added to the skill, add a new `[[capabilities.sections]]` entry. If a mapped file no longer exists, remove the entry. |
| **Check research mode** (if active) | Compare lockfile hashes before build. Fixed-layer mismatch = full rebuild. Open-layer-only = lightweight re-theme. |

---

## Commit Convention

Use this commit message pattern:

```
skill-sync({project-name}): v{old} → v{new} — {brief description}

Config changes:
- {config key}: {old value} → {new value}
- ...

Mapped files updated:
- {file}: {function} — {what changed}

Reverse sync: {yes/no}
```

Examples:
```
skill-sync(cafe-ordering): v1.0.0 → v1.1.0 — increased max_order_items to 100

Config changes:
- thresholds.max_order_items: 50 → 100

Mapped files updated:
- src/services/orderService.ts: validateOrder — updated max items check
- src/routes/orders.ts: createOrder — updated error message
```

---

## Sync Verification Checklist

After every sync:

- [ ] `skill_version` matches between `config.yaml` and `mapping.toml`
- [ ] Skill capability inputs/outputs still match webapp inputs/outputs
- [ ] Every changed config key has a corresponding update in the mapped `impl_files`
- [ ] No stale mappings (all mapped files and functions still exist)
- [ ] All test files in mapping still pass
- [ ] No hardcoded values embedded in skill markdown — everything configurable is in `config.yaml`
- [ ] `mapping.toml` updated if new sections were added or removed
- [ ] `codebase_version` and/or `skill_version` bumped
- [ ] Commit message follows convention
- [ ] No source code files (.ts, .js, .py, .rs, .kt, .java) in the skillified project directory

---

## Detecting Drift

If code and skill diverge (e.g., hotfix in production, AI-generated change that bypassed the skill):

1. **Check version mismatch** — if `skill_version` in `config.yaml` differs from `mapping.toml`, drift has occurred
2. **Run capability tests** — execute each capability's inputs and compare outputs against actual webapp behavior
3. **If mismatch found**, decide: is the code correct (reverse-sync) or is the skill correct (forward-sync)?
4. **Execute the appropriate sync direction**
5. **Update version** in both `config.yaml` and `mapping.toml`
