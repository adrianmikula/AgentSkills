# Agent Orchestrator Helper Scripts and Resources

This folder contains reusable helper scripts, templates, and examples for the agent-orchestrator skill.

## Scripts

### poll-issues.sh
Poll GitHub issues for a repository on an interval and report deltas (new / changed / closed) against a persisted baseline snapshot. Prints a `[heartbeat]` line every cycle.

**Usage:**
```bash
./poll-issues.sh <owner> <repo> [state] [interval-seconds]
```

**Example:**
```bash
./poll-issues.sh adrianmikula AgentSkills open 60
```

**Delta tracking:**
- The first run establishes a baseline snapshot in `.poll-issues-state.json` (override with `POLL_STATE_FILE`) and reports no deltas.
- Each later poll diffs the live API response against the snapshot and prints `delta:` lines for new issues, updated issues (`updatedAt` changed: new comments, labels, edits), and closed/disappeared issues.
- Failed API calls or non-JSON responses are logged as warnings and skipped; they never overwrite the snapshot, so outages or machine sleep cannot be mistaken for "no issues".

**Requirements:**
- GitHub CLI (`gh`) installed and authenticated (`gh auth login` or `GH_TOKEN` env var)
- `jq` installed

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
Clean up old git worktrees to free disk space. Before removing an old worktree it verifies that the worktree's checked-out branch has zero unpushed commits (`git log origin/<branch>..<branch>`); worktrees with unpushed work, no upstream, or detached HEAD are kept (fail-safe). Branches are left intact for the human/orchestrator to delete after merge.

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

### log-event.sh
Append a timestamped event to the append-only orchestrator event log (JSON Lines).

**Usage:**
```bash
./log-event.sh <type> <message> [details-json]
```

**Example:**
```bash
./log-event.sh detection "new issue detected" '{"issue": 42, "title": "Add feature"}'
./log-event.sh action "subagent spawned" '{"issue": 42, "branch": "feature/issue-42"}'
./log-event.sh error "poll-issues.sh failed" '{"exit_code": 1}'
```

**Event types:** `detection` (new issue/PR/comment, PR health problem), `action` (spawn, merge, cleanup, escalate, production change), `error` (poll failures, script/subagent failures, escalations).

**Event log format:** one JSON object per line — `{"timestamp":"<ISO8601 UTC>","type":"<type>","message":"<description>","details":{...}}` — appended to `.orchestrator-events.log` in the working directory. The log is append-only: never rewrite or truncate it.

**Requirements:**
- `jq` installed

**Notes:**
- Override the log file location with the `ORCHESTRATOR_EVENTS_LOG` environment variable
- See the "Event Log" section in `Skill.md` for the full convention

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
- GitHub CLI (`gh`) installed and authenticated (`gh auth login` or `GH_TOKEN` env var)
- `jq` installed
- State files will be created: `.orchestrator-state.json`, `.processed-issues.txt`, `.issue-snapshot.json`, and `.pr-health.json`

**Features:**
- Polls for issue deltas at configurable intervals (default: 5 minutes), diffing the live issue set against `.issue-snapshot.json` rather than an ever-growing processed list
- Re-baselines the issue snapshot from the live API on startup, so restarts, network outages, or machine sleep cannot silently skip or misreport deltas
- Reports new, changed (updatedAt differs: re-triage on new comments/labels), and closed issues each cycle
- Failed issue or PR-health API calls are logged and skipped; they never overwrite the snapshot or `.pr-health.json`, so errors are never indistinguishable from "no issues"
- Prints a `[heartbeat]` line every poll cycle for transparency
- Polls PR health (conflicts, failing checks, failed deployments) on a separate interval (default: 5 minutes)
- Tracks processed issues to avoid duplicate subagent spawns
- Maintains state file for active subagents and the PR-maintenance agent
- Graceful shutdown on Ctrl+C

### sync-main-checkout.sh
Fast-forward the primary (main) checkout to its upstream after a merge, so running dev servers pick up the newly merged code. Run this from Phase 4 of the orchestrator skill after a PR is merged.

**Usage:**
```bash
./sync-main-checkout.sh [--path <dir>] [--remote <name>] [--allow-diverged]
```

**Example:**
```bash
./sync-main-checkout.sh
```

**Defaults:**
- `--path`: primary checkout directory (defaults to the main worktree of the repository containing the current directory)
- `--remote`: remote name (defaults to the branch's configured remote, falling back to `origin`)

**Behavior:**
- Fetches the remote, reports ahead/behind counts, then runs `git pull --ff-only --autostash` so uncommitted work is stashed and restored automatically
- Verifies the resulting HEAD equals upstream before reporting success
- Aborts safely (never discards work or rewrites history) on:
  - Detached HEAD — check out a branch and re-run
  - Diverged local commits — re-run with `--allow-diverged` to merge upstream with `--no-rebase`, or resolve manually
  - Missing upstream — configure `branch.<name>.remote`/`merge` first

**Requirements:**
- Run inside (or pointed at) a git repository
- Git >= 2.6 for `--autostash` support

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
- Issue triaged as human-blocked
- Work started/completed/blocked/failed
- Permission requests
- Production change notifications
- PR health issues detected/resolved/needs-human-decision
- PR review started/complete
- Human-to-subagent question relay
- GitHub issue comment templates: PR-open status comment and merge closing summary (branch, files changed, verification results, deviations)

### github-templates.md
GitHub issue/PR templates for:
- Triage comment posted on human-blocked issues (blocking dependency + unblock path)

### example-session.md
Complete example of an orchestrator session showing:
- Issue discovery and prioritization
- Dependency graph building
- Resource checking
- Execution planning
- Subagent spawning and monitoring

### state-file-example.json
Example state file format for reconstructing full orchestration context on session start/restart:
- Active subagents: issue number, branch name, worktree path, start time, status, last check timestamp
- `human_blocked` items blocked on human action: issue/PR number, blocking reason, what unblocks it, triage and last re-check timestamps, escalation channel
- PR-maintenance agent items and blocked items
- PR-review agent PR numbers and the `reviewed_prs` list (prevents duplicate reviews across restarts)
- Last unreviewed-PRs-poll timestamp
- Open-issue snapshot: number, title, labels, status, assigned-subagent flag, blockers
- In-flight PRs: PR/issue numbers, branch, worktree, URL, status, head SHA, last check
- Merge→cleanup action map: pending actions (delete-branch, remove-worktree, remove-from-state) per merged PR
- Resolved items: recently merged/closed/fixed work with resolution and timestamp
- Worktree inventory: path, branch, linked issue, purpose, last-seen timestamp
- Disk headroom: available GB, warn-below threshold, last check
- Human-blocked items: type, PR/issue number, reason, detail, since, escalation channel
- Last poll and last PR-health-poll timestamps

The file is updated on every orchestration event; see "State Management" in `../Skill.md` for semantics.

## State File Format

The orchestrator should maintain a single state file (default: `.orchestrator-state.json`) as the source of truth for all orchestration context. See `state-file-example.json` for the full schema. Update it immediately on every event (issue discovered, subagent spawned/completed, PR opened/merged, cleanup queued/done, worktree created/removed, disk check, human escalation) and reconcile it against live GitHub/worktree state on session start.

## Polling Strategy

- **GitHub issues**: Poll every 60 seconds using `poll-issues.sh` (reports new/changed/closed deltas against a persisted baseline snapshot)
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
