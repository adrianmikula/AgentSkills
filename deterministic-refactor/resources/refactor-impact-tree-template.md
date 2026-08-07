# Refactor Impact Tree Template

Use this template as the starting point for `refactor-impact-tree.yaml` when a new refactor is scoped.

```yaml
refactor:
  target: ""
  base_commit: ""
  reason: ""
  owner: ""
  branches:
    - test_coverage_gaps:
        - module: ""
          missing_tests: []
          risk_level: ""
    - dependency_changes:
        - current: ""
          proposed: ""
          compatibility: "unknown" # known | unknown | incompatible
    - source_changes:
        - recipe: ""
          files_affected_estimate: 0
          confidence: "high" # high | medium | low
        - manual_patch: ""
          scope: "unknown" # known | unknown
    - downstream_production_impacts:
        - config_files: []
        - data_migrations: []
        - state_changes: []
    - uncertainties:
        - item: ""
          blocker: false
          exit_criterion: ""
```
