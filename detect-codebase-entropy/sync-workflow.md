# Sync Workflow — skillified-slopguard

## Initial Skillification

1. Analyzed SlopGuard codebase → built functional inventory (3 capabilities)
2. Extracted all configurable parameters → `config.yaml`
3. Generated `SKILL.md` with matching inputs/outputs
4. Created `mapping.toml` with granular section-level map (15 section entries)
5. Verified: each capability maps to real code files

## Forward Sync (Skill → Code)

When SlopGuard's detection logic changes upstream:

1. Update capability in `SKILL.md` (inputs/outputs/logic/errors)
2. Edit `config.yaml` — update affected parameter values
3. Apply file mapping — navigate to each `impl_file` in mapping.toml
4. Run tests: `bash gradlew test`
5. Commit with convention below

## Reverse Sync (Code → Skill)

When a fix is discovered in SlopGuard code:

1. Fix the code as normal
2. Update `config.yaml` if parameter values changed
3. Update `SKILL.md` to reflect corrected behavior
4. Document divergence in commit message

## Commit Convention

```
skill-sync(slopguard): v{old} → v{new} — {brief description}

Config changes:
- thresholds.max_nesting_depth: 3 → 4
- ...

Mapped files updated:
- src/main/kotlin/.../ASTAnalyzer.kt: analyzeAST — updated nesting check

Reverse sync: no
```

## Verification Checklist

- [ ] Skill capability inputs/outputs still match plugin inputs/outputs
- [ ] Every changed config path has a corresponding update in mapped `impl_files`
- [ ] No stale mappings (all mapped files and functions still exist)
- [ ] All tests pass (`bash gradlew test`)
- [ ] `mapping.toml` updated if sections were added or removed
- [ ] `codebase_version` and/or `skill_version` bumped
