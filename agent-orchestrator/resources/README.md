# Agent Orchestrator Helper Scripts

This folder contains reusable helper scripts for the agent-orchestrator skill.

## Scripts

### poll-issues.sh
Poll GitHub issues for a repository every 60 seconds.

**Usage:**
```bash
./poll-issues.sh <owner> <repo> [state]
```

**Example:**
```bash
./poll-issues.sh adrianmikula AgentSkills open
```

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated

### check-subagent-status.sh
Check the status of active subagents and detect stale ones.

**Usage:**
```bash
./check-subagent-status.sh [state-file]
```

**Example:**
```bash
./check-subagent-status.sh .orchestrator-state.json
```

**Requirements:**
- `jq` installed
- State file exists (default: `.orchestrator-state.json`)

### cleanup-worktrees.sh
Clean up old git worktrees to free disk space.

**Usage:**
```bash
./cleanup-worktrees.sh [repo-path] [days-old]
```

**Example:**
```bash
./cleanup-worktrees.sh /path/to/repo 7
```

**Requirements:**
- Run from within a git repository or specify the repo path

## State File Format

The orchestrator should maintain a state file (default: `.orchestrator-state.json`) to track active subagents:

```json
{
  "active_subagents": [
    {
      "issue_number": 123,
      "branch_name": "feature/issue-123-description",
      "worktree_path": "/path/to/worktree",
      "start_time": "2026-11-09T12:00:00Z",
      "status": "running",
      "last_check": "2026-11-09T12:05:00Z"
    }
  ],
  "last_poll": "2026-11-09T12:00:00Z"
}
```

## Polling Strategy

- **GitHub issues**: Poll every 60 seconds using `poll-issues.sh`
- **Subagent status**: Check every 60 seconds using `check-subagent-status.sh`
- **Worktree cleanup**: Run `cleanup-worktrees.sh` periodically (e.g., daily) to free disk space

## Adding New Scripts

When adding new helper scripts:

1. Make the script executable (`chmod +x script.sh`)
2. Add documentation to this README
3. Update the main Skill.md to reference the new script
4. Follow the same naming convention: `verb-noun.sh` (e.g., `poll-issues.sh`, `check-status.sh`)
