# Example Orchestrator Session

This is an example of how an orchestrator agent might respond to a user request.

## User Prompt

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo, and create a subagent for each issue. Each subagent should raise a new PR which fixes the issue.
```

## Orchestrator Response

```
I'll act as an orchestrator agent. Let me start by fetching the GitHub issues for this repository.

[Fetching issues...]

Found 5 open issues:
1. #42: Fix login bug on mobile devices (Priority: High, No dependencies)
2. #43: Add user profile page (Priority: Medium, Depends on #42)
3. #44: Migrate user sessions to new DB schema (Priority: High, Production impact: Medium)
4. #45: Update API rate limits (Priority: Low, No dependencies)
5. #46: Add dark mode (Priority: Low, No dependencies)

Building dependency graph:
- #42 (no deps) → #43 (depends on #42)
- #44 (no deps, but requires outage window)
- #45 (no deps)
- #46 (no deps)

Resource check:
- Disk space: 50GB available
- RAM: 8GB available
- Cloud credits: Sufficient

Execution plan:
Batch 1 (parallel, 3 subagents max):
- #42: Fix login bug (local subagent)
- #44: Migrate sessions (local subagent, will ask for outage window approval)
- #45: Update rate limits (local subagent)

Batch 2 (after #42 merges):
- #43: Add user profile (local subagent)

Batch 3 (anytime):
- #46: Add dark mode (local subagent, free model)

Starting Batch 1...
[Creating branches/worktrees for #42, #44, #45]
[Launching 3 subagents]
[Notifying via Slack]

Monitoring progress...
```
