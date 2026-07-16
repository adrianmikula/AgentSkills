# Skill Verification

> **Standard mode.** Use during Phase 7 of skillification to run structural consistency checks.

## Consistency Checks

| # | Check | Detail |
|---|-------|--------|
| 1 | Every major module has a skill | No module from Phase 2 is missing a skill |
| 2 | Every skill has a boundary | No skill lacks a stated boundary |
| 3 | Every skill has an artifact contract | No skill lacks a clear input or output |
| 4 | Orchestrator references all sub-skills | No sub-skill is orphaned |
| 5 | No circular references in related-skills sections | A → B → A is acceptable if roles are distinct, but avoid A → A |
| 6 | README and SKILL_SYNC.md are consistent | Skill names, paths, and descriptions match |
| 7 | Legacy skills are prefixed | Any skill covering old/deprecated functionality is named `legacy-<name>` |

---

## Output Checklist

When skillification is complete, the following must exist:

- [ ] `skills/<orchestrator>/SKILL.md` — top-level orchestrator
- [ ] `skills/<module-1>/SKILL.md` through `skills/<module-n>/SKILL.md` — one per major module
- [ ] `skills/SKILL_SYNC.md` — architecture-aligned skill map, pipeline diagram, layer tables
- [ ] `README.md` — architectural boundaries section, updated skill tables
- [ ] All skills have YAML frontmatter, boundary, artifact contracts, core files, workflow, related skills
- [ ] Legacy skills renamed with `legacy-` prefix
- [ ] Human/AI separation documented for each boundary

---

## Skill Quality Checks

For each generated skill:

- [ ] Has YAML frontmatter with `name` and `description`
- [ ] States its boundary and input/output artifacts prominently
- [ ] Contains the artifact contract (TypeScript interface or JSON schema)
- [ ] Lists core files with responsibilities
- [ ] Provides step-by-step workflow or usage instructions
- [ ] Lists related skills with relationship descriptions
- [ ] Does not contain source code (skills are documentation-only, MD/YAML/JSON)
