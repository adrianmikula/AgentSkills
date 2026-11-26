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

### check-pr-health.sh
Check open pull requests for health issues: merge conflicts, failing checks/CI, and failed deployments. Poll on a slower cadence than issues (every 5 minutes by default).

**Usage:**
```bash
./check-pr-health.sh <owner> <repo>
```

**Example:**
```bash
./check-pr-health.sh adrianmikula AgentSkills
```

**Output:** JSON object with three arrays: `conflicts`, `failing_checks`, `failed_deployments` (all empty when healthy).

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- `jq` installed

**Notes:**
- `mergeable=UNKNOWN` is treated as "still computing", not a conflict
- In-progress/pending checks are not reported as failures
- Failed deployments are matched back to open PRs by head branch or head SHA where possible

### check-unreviewed-prs.sh
List open pull requests that have not yet been reviewed by the PR-review subagent (description reasoning check + serious-issues-only code review). Read-only; never posts comments or mutates state. If the state file is missing or has no `reviewed_prs` key, ALL open PRs are reported - this is the backfill path for PRs opened while the orchestrator was down.

**Usage:**
```bash
./check-unreviewed-prs.sh <owner> <repo> [state-file]
```

**Example:**
```bash
./check-unreviewed-prs.sh adrianmikula AgentSkills .orchestrator-state.json
```

**Output:** JSON object with one array: `unreviewed_prs` (empty when every open PR has been reviewed). A PR counts as reviewed when its number appears in the state file's `reviewed_prs` array.

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- `jq` installed

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
Long-running orchestrator that polls for new GitHub issues and PR health issues (merge conflicts, failing checks, failed deployments) at configurable intervals.

**Usage:**
```bash
./long-running-orchestrator.sh <owner> <repo> [issue-interval-seconds] [pr-interval-seconds]
```

**Example:**
```bash
./long-running-orchestrator.sh adrianmikula AgentSkills 60 300
```

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated
- `jq` installed
- State files will be created: `.orchestrator-state.json`, `.processed-issues.txt`, and `.pr-health.json`

**Features:**
- Polls for new issues at configurable intervals (default: 5 minutes)
- Polls PR health (conflicts, failing checks, failed deployments) on a separate interval (default: 5 minutes)
- Tracks processed issues to avoid duplicates
- Maintains state file for active subagents and the PR-maintenance agent
- Detects new issues and PR health problems and prepares for subagent spawning
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

### pr-maintenance-prompt-template.md
Template for the single PR-maintenance subagent that handles merge conflicts, failing checks/CI, and failed deployments sequentially:
- Work item list grouped by PR
- Auto-fix only when obvious/unambiguous; escalate ambiguous items with diagnosis
- Git rules (merge base into branch, never rebase/force-push)
- Worktree rules, approved commands, authentication recipe
- Command restrictions and failure conditions
- Uniform per-item report format (resolved / needs-human / failed / skipped)

### pr-review-prompt-template.md
Template for the dedicated PR-review subagent spawned for each newly opened pull request:
- Task 1: checks the PR body for a reasoning section (why this approach, trade-offs, risks, follow-ups) and comments if missing or inadequate
- Task 2: serious-issues-only code review (logic, security, stability - explicitly not style), one comment per finding
- Hard rules: NEVER approve, merge, close, or modify the PR; comments only; no style nitpicks
- Approved commands (read-only gh/git plus PR-comment writes only), authentication recipe, uniform report format

### slack-templates.md
Slack notification templates for:
- Work started/completed/blocked/failed
- Permission requests
- Production change notifications
- PR health issues detected/resolved/needs-human-decision
- PR review started/complete
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
- PR-maintenance agent items and blocked items
- PR-review agent PR numbers and the `reviewed_prs` list (prevents duplicate reviews across restarts)
- Last poll, last PR-health-poll, and last unreviewed-PRs-poll timestamps

## State File Format

The orchestrator should maintain a state file (default: `.orchestrator-state.json`) to track active subagents. See `state-file-example.json` for the format.

## Polling Strategy

- **GitHub issues**: Poll every 60 seconds using `poll-issues.sh`
- **PR health**: Poll every 5 minutes using `check-pr-health.sh` (merge conflicts, failing checks, failed deployments)
- **Unreviewed PRs**: Poll every 5 minutes using `check-unreviewed-prs.sh`; spawn PR-review subagents per `pr-review-prompt-template.md` (Phase 7 in Skill.md)
- **Subagent status**: Check every 60 seconds using `check-subagent-status.sh`
- **Worktree cleanup**: Run `cleanup-worktrees.sh` periodically (e.g., daily) to free disk space
- **Long-running orchestration**: Use `long-running-orchestrator.sh` for continuous polling (issues and PR health on separate intervals, both defaulting to 5 minutes)

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
