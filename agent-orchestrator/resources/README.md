# Agent Orchestrator Helper Scripts and Resources

This folder contains reusable helper scripts, templates, and examples for the agent-orchestrator skill.

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

### long-running-orchestrator.sh
Long-running orchestrator that polls for new GitHub issues every 5 minutes (configurable).

**Usage:**
```bash
./long-running-orchestrator.sh <owner> <repo> [interval-seconds]
```

**Example:**
```bash
./long-running-orchestrator.sh adrianmikula AgentSkills 300
```

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- `jq` installed
- State files will be created: `.orchestrator-state.json` and `.processed-issues.txt`

**Features:**
- Polls for new issues at configurable intervals (default: 5 minutes)
- Tracks processed issues to avoid duplicates
- Maintains state file for active subagents
- Detects new issues and prepares for subagent spawning
- Graceful shutdown on Ctrl+C

## Templates and Examples

### subagent-prompt-template.md
Template for creating subagent prompts with all required sections:
- Context (repository, branch, worktree, known issues)
- Task description and scope constraints
- Constraints and approved commands
- Authentication recipe
- Command restrictions
- Failure conditions
- Expected output format

### slack-templates.md
Slack notification templates for:
- Work started/completed/blocked/failed
- Permission requests
- Production change notifications
- Human-to-subagent question relay

### example-session.md
Complete example of an orchestrator session showing:
- Issue discovery and prioritization
- Dependency graph building
- Resource checking
- Execution planning
- Subagent spawning and monitoring

### state-file-example.json
Example state file format for tracking active subagents:
- Issue number, branch name, worktree path
- Start time, status, last check timestamp
- Last poll timestamp

## State File Format

The orchestrator should maintain a state file (default: `.orchestrator-state.json`) to track active subagents. See `state-file-example.json` for the format.

## Polling Strategy

- **GitHub issues**: Poll every 60 seconds using `poll-issues.sh`
- **Subagent status**: Check every 60 seconds using `check-subagent-status.sh`
- **Worktree cleanup**: Run `cleanup-worktrees.sh` periodically (e.g., daily) to free disk space
- **Long-running orchestration**: Use `long-running-orchestrator.sh` for continuous polling (default: 5 minutes)

## Adding New Scripts and Resources

When adding new helper scripts or resources:

1. Make scripts executable (`chmod +x script.sh`)
2. Add documentation to this README
3. Update the main Skill.md to reference the new resource
4. Follow naming conventions:
   - Scripts: `verb-noun.sh` (e.g., `poll-issues.sh`, `check-status.sh`)
   - Templates: `*-template.md` (e.g., `subagent-prompt-template.md`)
   - Examples: `example-*.md` (e.g., `example-session.md`)
   - Data: `*-example.json` (e.g., `state-file-example.json`)
