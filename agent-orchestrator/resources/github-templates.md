# GitHub Templates

Use these templates for orchestrator-to-human communication on GitHub issues and PRs.

## Triage Comment (Blocked Issue)

Post this comment on an issue classified as human-blocked during Phase 1 triage. State the dependency and the concrete action that unblocks it.

```
⛔ **Triage: blocked — needs human action**

**Classification:** human-blocked (requires human input; no agent will be spawned)
**Blocking dependency:** <blocking category — credentials / external access / business decision / ordering constraint / production approval>
**What unblocks it:** <concrete action the human must take>
**Next step:** Once unblocked, this issue will be re-triaged and picked up by an agent automatically.

_Automated triage by the agent-orchestrator. Reply on this issue or via Slack to unblock._
```
