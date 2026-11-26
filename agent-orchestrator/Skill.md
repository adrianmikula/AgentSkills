---
name: agent-orchestrator
description: Prescribe how orchestrator agents should manage tasks and delegate work to local subagents and/or cloud agents using GitHub repos, issues, branches, worktrees, and pull requests with Slack integration for 2-way communication. Subagents run asynchronously in the background by default. Orchestrators manage resources (disk space, RAM, cloud credits), optimize for cost over speed (free Devin models by default), and handle task dependencies and production impact.
---

## Overview

This skill defines the standard process for orchestrator agents to manage software development work through GitHub-centric workflows. Orchestrators coordinate work by:

- Using GitHub issues to define tasks
- Creating GitHub branches or local worktrees (or cloud agents) to isolate work
- Running subagents asynchronously in the background by default
- Raising pull requests for human review before merging
- Polling open pull requests for merge conflicts and CI/deployment failures and fixing or escalating them via a dedicated subagent
- Using Slack for 2-way communication (status updates and clarifying questions)
- Managing resource constraints (disk space, RAM, cloud credits)
- Optimizing for cost over speed (free Devin models by default)
- Respecting task dependencies and production impact windows

---

## Core Principles

### 1. GitHub-Centric Workflow

All work flows through GitHub as the single source of truth:

- **Issues** = Tasks/requirements with clear acceptance criteria
- **Branches/Worktrees** = Isolated work environments
- **Pull Requests** = Human review gates before merge
- **Commits** = Atomic, reviewed changes with clear messages

### 2. Async Background Work

Subagents run asynchronously in the background by default:
- **Orchestrator stays available**: The orchestrator can respond to new instructions while subagents work
- **Parallel execution**: Multiple subagents can run simultaneously without blocking each other
- **Notifications**: Subagents report back when complete; orchestrator can check status anytime
- **Long tasks allowed**: Subagents can take as long as needed to complete their work

### 3. Slack Integration

Slack is the bidirectional communication channel:
- **Orchestrator → Human**: Status updates (work started, completed, blocked)
- **Human → Subagent**: Answers to clarifying scope/design/architectural questions
- **Subagent → Human**: Questions during work, surfaced via Slack for human response

### 4. Resource Mindfulness

Orchestrators run on consumer-grade hardware and must respect constraints:

- **Disk space**: Monitor and prevent worktree bloat
- **RAM memory**: Limit concurrent local subagents to avoid exhaustion
- **Cloud credits**: Prioritize free models; only use paid models for high-value or high-priority tasks
- **Timeouts**: Set reasonable timeouts only to detect hung threads; subagents can take as long as needed to complete their work

### 5. Permission Management

Orchestrators must ensure subagents have the permissions they need to complete their work:

- **Approved commands**: Pre-approve common commands (git operations, package managers, build tools) in the subagent prompt
- **Permission escalation**: If a subagent encounters a permission error, orchestrator should:
  - Identify the command that failed
  - Inform the human about the unapproved command via Slack
  - The human will decide whether to approve it and update the approved command list
- **Scope control**: Subagents should only have access to commands needed for their specific task
- **Security boundary**: Never approve destructive commands (rm -rf, DROP TABLE, etc.) without explicit human confirmation
- **Human authority**: Orchestrators must NEVER modify the approved command list directly; only the human can add/remove approved commands
- **Universal blacklist**: Inline bash, powershell, python, or cmd commands are always blacklisted. Additionally, the following risky commands are always blacklisted:
  - **Destructive system commands**: `rm -rf`, `rm -fr`, `rm -r`, `rm -f` with wildcards (e.g., `rm -rf *`, `rm -rf /`, `rm -rf ~`), `dd`, `mkfs`, `fdisk`, `parted`, any command that could cause data loss or system damage
  - **Risky git commands**: `git push --force`, `git push -f`, `git rebase`, `git branch -d`, `git branch -D`, `git reset --hard`, `git clean -fd`, `git clean -fdx`, or any command that would rewrite public history or delete branches without human approval
- **Script preference**: If system scripting is needed that cannot be achieved with simple allowlist commands, subagents must write a dedicated, reusable Linux .sh script for the task
- **Script documentation**: The existence and purpose of any reusable .sh script must be documented for future agents to reuse

### 6. Script Management

For system scripting needs that cannot be met with simple allowlist commands:

- **Create reusable scripts**: Write dedicated Linux .sh scripts for complex operations
- **Document scripts**: Include script name, purpose, and usage instructions in a central location (e.g., `scripts/README.md` or similar)
- **Share scripts**: Make scripts available to all subagents for reuse
- **Avoid inline scripting**: Never use inline bash/powershell/python/cmd commands - always create a script file instead
- **Version control**: Commit scripts to the repository so they persist and can be reviewed

### 7. Cost Optimization

Default to free operations:

- Use free Devin models unless task is high-value or high-priority
- Prefer slower, free execution over faster, paid execution
- Only escalate to paid models when explicitly justified
- **Cloud agent rationing**: Default to local agents. Only use cloud agents for:
  - Urgent tasks requiring faster completion
  - Tasks that exceed local resource constraints (RAM, disk)
  - Tasks requiring specialized cloud-only capabilities
  - Cloud agents typically have more resources and complete faster, so ration them for high-value scenarios

### 8. Dependency Awareness

Orchestrators must understand and respect:

- **Task dependencies**: Order work correctly based on what blocks what
- **Production impact**: Identify tasks requiring DB migrations, env var changes, or service restarts
- **Outage windows**: Schedule production-impacting work for approved times (e.g., after business hours)

### 9. Task Tracking and Deduplication

Orchestrators must track subagent state and prevent duplicate work:

- **State tracking**: Maintain a list of active subagents, their assigned issues, and their current status
- **Deduplication**: Never create multiple subagents for the same GitHub issue
- **Status monitoring**: Check subagent status periodically to detect completion, failure, or blocking issues
- **Cleanup**: Remove completed subagents from the active list to free resources
- **Idempotency**: If a subagent fails and is retried, ensure it doesn't duplicate work already done
- **PR-maintenance deduplication**: Never run more than one PR-maintenance subagent (merge conflicts + CI/deploy failures) at a time, and never assign the same PR item to it twice while it is still active

### 10. Helper Scripts

Orchestrators should use reusable helper scripts for common operations:

- **Polling**: Use a polling script to check for new GitHub issues every minute and open PRs for merge conflicts and CI/deployment failures every 5 minutes
- **Status checks**: Use scripts to check subagent status, resource usage, and system health
- **Git operations**: Use scripts for common git workflows (branch creation, worktree management)
- **Documentation**: All helper scripts must be documented and stored in the `resources/` folder for reuse

### 11. Real-World Orchestration Patterns

Based on proven orchestration runs, follow these patterns:

#### Worktree Isolation
- **Use `.worktrees/` directory**: Create worktrees inside the repo at `.worktrees/<slug>`
- **Use `info/exclude`**: Add `.worktrees/` to `.git/info/exclude` (not `.gitignore`) to keep `git status` clean without committing the exclude rule
- **Never share main checkout**: The main checkout may be on a feature branch with uncommitted work; always isolate agents in worktrees
- **Pre-flight environment**: Verify `origin/main`, `package-lock.json`, and exclude rules before spawning agents

#### Worktree Reuse for Multi-PR Issues
- **Reuse one worktree**: For issues requiring multiple PRs, reuse the same worktree
- **Switch branches**: Use `git checkout -b <branch> origin/main` between PRs to keep `node_modules` warm
- **Save install time**: This avoids repeated `npm ci`/`yarn install` runs

#### Concurrency and Resource Management
- **Scale isolation to disk, not compute**: When disk gets tight, shrink per-workspace footprint before reducing agent count
- **Cap by disk, not compute**: Each worktree needs its own `node_modules` (hundreds of MB)
- **Shrink footprint first**: Before reducing concurrency, apply dependency-sharing strategies:
  - **Shared install cache**: Use `npm ci --prefer-offline`, `yarn install --prefer-offline`, or `pnpm install --prefer-offline` so installs reuse the global/package-manager cache instead of downloading again
  - **Symlinked `node_modules`**: Point a worktree's `node_modules` at a canonical install (e.g., `ln -s ../canonical/node_modules node_modules`) when the dependency tree is identical, or use pnpm's content-addressable store (`pnpm install` shares packages across projects by default via hard links)
  - **Lockfile-driven reuse**: Prefer package managers that deduplicate on disk (pnpm store, npm cache) over duplicating full `node_modules` trees per worktree
- **Safe default**: 2 concurrent agents is proven safe on consumer hardware
- **Optimize installs**: Use `npm ci --prefer-offline` (or the equivalent flag for yarn/pnpm) to share the package-manager cache
- **Monitor disk**: Check available disk space before spawning new agents

#### Authentication Pattern
- **Solve auth once**: Verify authentication works before spawning agents
- **Embed recipe, not secret**: Include the exact auth command in prompts, never the token itself
- **GitHub CLI alternative**: If `gh` CLI is not installed or lacks scopes, use REST API via `~/.git-credentials`
- **Test auth**: Verify auth works with a test API call before spawning agents

#### Failure-State Propagation
- **Learn from early agents**: If an early agent discovers broken state (e.g., lint errors on main), propagate this to later prompts
- **Update prompts**: Add "only lint changed files" or similar constraints to subsequent agent prompts
- **Document caveats**: Record known-broken verification steps in the state file for future reference

#### File-Tool Staleness
- **Verify after checkout**: File read/edit tools can hold stale buffers across `git checkout`
- **Use git status**: After switching branches in a worktree, verify with `git status` or `git show`
- **Prefer shell edits**: At branch-switch boundaries, prefer shell-based edits over file tools

#### Prompt Discipline for Stateless Subagents
- **Embed full context**: Include the complete issue body, constraints, and known state in every prompt
- **Constrain open-ended issues**: Bound scope explicitly ("one small PR", "N sequential branches")
- **Flag shared files**: Warn about files that other in-flight PRs also touch; instruct agents to keep diffs minimal
- **Require uniform report**: Every agent must report: branch name, PR URL, files changed, verification results
- **Include auth recipe**: Embed the exact commands needed for git push and PR creation

#### Long-Running Orchestrator
- **Poll continuously**: Run as a long-running thread, polling every 5 minutes for new issues
- **Auto-spawn agents**: When new issues appear, automatically create worktree agents
- **Follow AGENTS.md**: Adhere to repository-specific orchestration guidelines
- **Stay responsive**: Continue polling even while subagents are running

---

## Orchestrator Workflow

### Phase 1: Discover and Prioritize Tasks

1. **Fetch GitHub issues** for the target repository (use `resources/poll-issues.sh` for polling)
2. **Filter issues** by:
   - Open state
   - Labels (if applicable: priority, type, component)
   - Assignee (if any)
3. **Check for duplicates**: Verify that no active subagent is already working on the issue
4. **Triage** each issue before scheduling it (see Triage Classification below):
   - **Code-actionable**: An agent can make progress with only repo access and approved commands — proceed to prioritization
   - **Human-blocked**: Requires something only a human can provide (credentials, dashboard/external-service access, a business/product decision, an ordering constraint on other work, or production-impact approval) — do NOT spawn a subagent; follow the blocked-issue handling below
5. **Handle human-blocked issues**:
   - Post a triage comment on the issue stating the dependency and what unblocks it (use the template in `resources/github-templates.md`)
   - Record the blocked classification and reason in the state file's `human_blocked` section (see `resources/state-file-example.json`)
   - Notify via Slack using the "Issue Triaged as Blocked" template
   - Exclude the issue from this cycle's queue
6. **Prioritize** the remaining code-actionable issues using:
   - Dependencies (what blocks what)
   - Production impact (require outage window?)
   - Priority labels
   - Resource requirements
7. **Group** into independent batches that can run in parallel

**Output**: A prioritized task queue with dependency graph and deduplication check, plus a list of human-blocked issues with triage comments posted

### Triage Classification

Before any issue is scheduled, classify it as **code-actionable** or **human-blocked**. An issue is human-blocked when progress requires a human-only input that no agent can supply:

| Blocking Category | Examples |
|-------------------|----------|
| Credentials/secrets | API keys, tokens, SSH access, cloud account credentials |
| External access | Dashboard or SaaS admin access, production consoles, third-party accounts |
| Business decision | Product direction, pricing, scope trade-offs only the human can make |
| Ordering constraint | Must wait for another issue/PR to merge or a specific sequence of work |
| Production approval | Outage window sign-off, manual prod verification, rollback authority |

For human-blocked issues:

1. **Post a triage comment** on the GitHub issue explaining the blocking dependency and the concrete action that unblocks it (template in `resources/github-templates.md`)
2. **Record it in the state file** under `human_blocked` with: issue number, blocking category/reason, what unblocks it, triage timestamp, and last re-check timestamp
3. **Notify via Slack** so the human knows action is needed
4. **Do not burn agent resources**: never spawn a subagent for a human-blocked issue

**Re-check behavior**: On each polling cycle, re-evaluate `human_blocked` issues when blocking conditions may have changed — e.g., a human replies on the issue or via Slack, a prerequisite issue/PR is merged or closed, or credentials/access are confirmed available. When the block clears, remove the entry from `human_blocked` and return the issue to the normal Phase 1 queue.

### Phase 2: Allocate Resources

For each task or batch:

1. **Assess resource needs**:
   - Estimated disk space for worktree
   - RAM for subagent(s)
   - Cloud model requirement (free vs paid)
2. **Check available resources**:
   - Disk space on host
   - Available RAM
   - Cloud credit balance
3. **Decide execution strategy** (default to local agents):
   - **Local subagent**: Default choice for most tasks if resources allow
   - **Cloud agent**: Only for urgent tasks, resource-constrained scenarios, or when local agents are unavailable
   - **Sequential processing**: If resources would be exhausted by parallel execution
4. **Limit concurrency**: Set a safe maximum (e.g., 2-3 local subagents max) based on hardware
5. **Prepare approved commands**:
   - Identify common commands needed for this task type (git, npm/yarn/pnpm, build tools, test runners)
   - Create an approved commands list for the subagent
   - Include in the subagent prompt
   - The approved commands list is managed by the human; orchestrator does not modify it

**Output**: Execution plan with resource allocation per task

### Phase 3: Delegate to Subagents

For each task:

1. **Check for existing subagent**: Verify no active subagent is already working on this issue
2. **Create work environment**:
   - Create a new branch from main: `git checkout -b feature/issue-123-description`
   - OR create a worktree: `git worktree add ../repo-issue-123 feature/issue-123-description`
   - OR spin up a cloud agent with the branch checked out
3. **Prepare approved commands**:
   - Identify common commands needed for this task type (git, npm/yarn/pnpm, build tools, test runners)
   - Create an approved commands list for the subagent
   - Include in the subagent prompt
   - The approved commands list is managed by the human; orchestrator does not modify it
4. **Launch subagent** with a refined prompt (see Subagent Prompt Template below)
5. **Track subagent state**: Add to active subagent list with issue number, branch name, and start time
6. **Notify via Slack**: "Started work on issue #123: [title]"
7. **Monitor execution**:
   - If subagent asks clarifying questions, surface to human via Slack
   - If human answers via Slack, relay to subagent
   - Track progress and detect blocking issues
   - Check subagent status periodically (use `resources/check-subagent-status.sh`)
8. **Comment on issue at PR open**: When the subagent reports its pull request is open, post a status comment on the GitHub issue with the PR link and current status (use the PR-open template in `resources/slack-templates.md`)

**Output**: Subagent running in isolated environment, with communication bridge to human and state tracking

### Phase 4: Review and Merge

When subagent completes work:

1. **Inspect results**:
   - Review code changes in the branch/worktree
   - Run tests (if test infrastructure exists)
   - Check for production impact (migrations, env vars, etc.)
2. **Create pull request** with:
   - Clear title referencing the issue
   - Description linking to the issue
   - Summary of changes
   - Production impact notes (if any)
3. **Notify via Slack**: "Ready for review: PR #456 for issue #123"
4. **Wait for human approval**:
   - Human reviews PR in GitHub
   - Human approves or requests changes
   - If changes requested, loop back to subagent with feedback
5. **Merge** after approval:
   - Merge PR via GitHub UI or command
   - Verify zero unpushed commits on the branch (`git log origin/<branch>..<branch>` is empty)
   - Post a closing summary comment on the GitHub issue (use the merge template in `resources/slack-templates.md`; include branch, files changed, verification results, and deviations from the uniform report)
   - Delete branch/worktree after merge
   - **Sync the primary checkout** so running dev servers pick up the merged code:
     - Run `agent-orchestrator/resources/sync-main-checkout.sh` from the primary checkout (or `git fetch` + `git pull --ff-only --autostash` manually)
     - The sync uses autostash so uncommitted work survives, and refuses non-fast-forward updates
     - Verify the resulting HEAD matches upstream (`git rev-parse HEAD` vs `git rev-parse @{u}`)
     - Edge cases abort safely: detached HEAD, diverged local commits, or missing upstream — escalate to the human rather than forcing
   - Notify via Slack: "Merged PR #456 for issue #123; primary checkout synced to <sha>"
6. **Cleanup**: Remove subagent from active list to free resources

**Output**: Code merged to main, environment cleaned up, subagent removed from active list

### Phase 5: Handle Production Impact

For tasks with production impact:

1. **Identify impact type**:
   - DB migration
   - Env var change
   - Service restart
   - Breaking API change
2. **Determine outage requirement**:
   - Is zero-downtime possible?
   - If not, what's the expected downtime?
   - What's the blast radius (affected users, features)?
3. **Schedule approval**:
   - Ask human for approval time window
   - Confirm the window is outside business hours (if required)
   - Get explicit human confirmation before proceeding
4. **Execute in window**:
   - Wait until approved time
   - Execute change
   - Verify success
   - Notify via Slack: "Production change complete: [description]"

**Output**: Production change executed safely within approved window

### Phase 6: Maintain PR Health (Merge Conflicts and CI/Deploy Failures)

Orchestrators must keep open pull requests healthy and mergeable. PR health is polled less frequently than issues (every 5 minutes by default) using `resources/check-pr-health.sh`, which detects three categories of problems:

- **Merge conflicts**: `mergeable: CONFLICTING` or `mergeStateStatus: DIRTY` (treat `UNKNOWN` as "GitHub is still computing" and re-check next poll)
- **Failing checks/CI**: status check rollup entries with failing conclusions (build, test, lint, deploy-preview jobs, etc.); in-progress/pending checks are ignored
- **Failed deployments**: GitHub deployments whose latest status is `failure` or `error`, matched back to PRs by head branch or head SHA where possible

Workflow:

1. **Poll for issues**: Run `resources/check-pr-health.sh` every 5 minutes and collect all detected items.
2. **Deduplicate**: Skip items already assigned to the PR-maintenance subagent, items a human is actively resolving, and drafts if the repository policy excludes them. Never spawn more than one PR-maintenance subagent at a time.
3. **Spawn a single subagent** when one or more items are found. The subagent processes items **sequentially, one PR at a time** (multiple items on the same PR are grouped), using the template in `resources/pr-maintenance-prompt-template.md`.
4. **Resolution policy**:
   - Fix automatically **only when the correct resolution/fix is obvious/unambiguous** (e.g., non-overlapping conflict hunks, generated files or lockfiles that can be regenerated, lint/type errors with a clear fix, transient deploy failures that can be retried)
   - If the correct fix is **not clear**, do NOT guess: leave the branch untouched, record the diagnosis (conflicted files, check logs, deployment logs), and ask the human for clarification or manual resolution via Slack
   - For merge conflicts, prefer merging the base branch into the PR branch (`git merge origin/main`) over rebasing; never force-push or rewrite PR history
   - The subagent may push fix commits to PR branches, but must verify (build/test/lint) before pushing; if verification fails and the cause is unclear, treat it as ambiguous and escalate
5. **Push and report**: Push fixes with a regular `git push` (no force) and report per-item results: resolved, escalated, failed, or skipped.
6. **Notify via Slack**: Announce when PR health issues are detected and the subagent starts; report each item outcome; escalate ambiguous items immediately rather than batching them silently.

**Output**: PR health issues either fixed with verified commits or escalated to the human with enough context (diagnosis + logs) to decide

---

## State Management

### State File Schema

Maintain a single persistent state file (e.g., `.orchestrator-state.json`) so a new or restarted session can reconstruct full orchestration context without relying on chat memory. See `resources/state-file-example.json` for the format. The state file is the source of truth; the example file documents every supported section:

- **`active_subagents`**: Running issue subagents — issue number, branch, worktree path, start time, status, last check
- **`pr_maintenance_agent`**: The single PR-maintenance subagent — assigned items, blocked items, status, last check
- **`open_issues`**: Snapshot of open issues from the last issue poll — number, title, labels, status (`open`/`dispatched`/`deferred`/`blocked`), assigned-subagent flag, dependency blockers
- **`in_flight_prs`**: Open PRs under orchestration — PR/issue numbers, branch, worktree path, URL, status (`open`/`checks-failing`/`conflict`/`needs-review`), head SHA, last check
- **`merge_cleanup_actions`**: Merge→cleanup action map — for each recently merged PR, the pending actions (`delete-branch`, `remove-worktree`, `remove-from-state`) and their status
- **`resolved_items`**: Recently resolved work (merged PRs, closed issues, fixed PR-health items) with resolution type, timestamp, and notes — retained briefly for auditability, then pruned
- **`worktree_inventory`**: All known worktrees — path, branch, linked issue, purpose (`subagent`/`pr-maintenance`/`post-merge-cleanup`), last-seen timestamp
- **`disk_headroom`**: Latest disk check — available GB, warn-below threshold, timestamp
- **`human_blocked`**: Items blocked on human action — type, PR/issue number, reason, detail, since-timestamp, escalation channel
- **`last_poll` / `last_pr_health_poll`**: Timestamps of the last issue and PR-health polls

### Update-on-Every-Event Semantics

- Update the state file **immediately on every orchestration event**: issue discovered, subagent spawned/completed/failed, PR opened/updated/merged, cleanup action queued or completed, worktree created/removed, disk check run, item escalated to human
- Never batch state changes across events; a crash between events must not lose context
- On session start, **load the state file first** and reconcile it against live GitHub state (open issues, open PRs, `git worktree list`) before spawning anything new
- On restart, treat `active_subagents`/`in_flight_prs` entries as possibly stale: verify status via `resources/check-subagent-status.sh` and PR health before acting
- Prune `resolved_items` once cleanup actions complete; keep `human_blocked` until the human resolves the item

### Deduplication Rules

- Before creating a new subagent, check the active subagent list
- If an issue number already exists in the active list, skip creating a new subagent
- If a subagent fails and is retried, reuse the same branch/worktree
- Clean up completed subagents from the active list immediately after merge

### Polling Strategy

- Poll GitHub issues every 60 seconds using `resources/poll-issues.sh`
- Poll open PRs for merge conflicts and CI/deployment failures every 5 minutes using `resources/check-pr-health.sh` (less frequent than issue polling)
- Check subagent status every 60 seconds using `resources/check-subagent-status.sh`
- Use `resources/cleanup-worktrees.sh` to clean up old worktrees periodically

### Event Log

Maintain an append-only event log to answer "what happened while I wasn't looking" and to debug the orchestrator itself. Slack notifications are ephemeral and the state file only holds current state; the event log is the history.

- **Location**: `.orchestrator-events.log` in the working repository root (one JSON object per line, JSON Lines format)
- **Format**: `{"timestamp":"<ISO8601 UTC>","type":"<type>","message":"<description>","details":{<context>}}`
- **Append-only**: never rewrite, truncate, reorder, or rotate the log; it is a plain text file that grows over time
- **Logging**: use `resources/log-event.sh <type> <message> [details-json]` to append entries; override the location with the `ORCHESTRATOR_EVENTS_LOG` env var

Event types:

| Type | When to log |
|------|-------------|
| `detection` | New issue/PR/comment detected by polling; new PR health problem (conflict, failing check, failed deployment) detected |
| `action` | Subagent spawned, PR raised, merge performed, worktree/branch cleanup, escalation to human, production change executed |
| `error` | Poll failures, script errors, subagent failures, permission denials, ambiguous items needing human decision |

Every detection and action the orchestrator performs should produce a log entry with enough detail (issue/PR numbers, branch names, outcomes) to reconstruct what happened without Slack or the state file.

---

## Subagent Prompt Template

When delegating to a subagent, use the template in `resources/subagent-prompt-template.md`. Replace all `<placeholder>` values with actual content.

---

## Slack Communication Patterns

Use the templates in `resources/slack-templates.md` for all Slack notifications and GitHub issue lifecycle comments (PR-open status and merge closing summary).

---

## Example Orchestrator Session

See `resources/example-session.md` for a complete example of an orchestrator session.

---

## Resource Management Rules

### Disk Space

- Before creating worktrees, check available disk space: `df -h`
- Clean up old worktrees regularly: `git worktree prune`
- Prefer branch switching over worktrees if disk space is tight
- **Shrink per-workspace footprint before reducing agent count**: shared install cache, symlinked `node_modules` to a canonical install, or `--prefer-offline` variants per package manager (see Concurrency and Resource Management above)
- Monitor worktree size during subagent execution
- Delete worktrees immediately after merge, but **only after verifying zero unpushed commits** on the worktree's branch (`git log origin/<branch>..<branch>`); never delete a worktree or branch whose work has not been confirmed merged or pushed

### RAM Memory

- Limit concurrent local subagents to 2-3 on consumer hardware
- Monitor RAM usage: `free -h` or equivalent
- If RAM is tight, prefer sequential execution over parallel
- Consider cloud agents for memory-intensive tasks

### Cloud Credits

- Default to free Devin models
- Only use paid models for:
  - High-value tasks (critical path, high business impact)
  - High-priority tasks (urgent, deadline-driven)
  - Tasks requiring advanced capabilities not available in free tier
- Track cloud credit usage
- Alert human if credits are running low

---

## Dependency Management

### Task Dependencies

Before starting work, build a dependency graph:

```
Task A (no deps) → Task B (depends on A) → Task C (depends on B)
               ↘ Task D (depends on A) → Task E (depends on D)
```

- Start with independent tasks (no dependencies)
- Only start dependent tasks after their dependencies are merged
- Use GitHub issue linking to document dependencies
- If dependency is blocked, notify human via Slack

### Production Impact Classification

Classify each task as:

| Impact Type | Description | Requires Outage Window? |
|-------------|-------------|------------------------|
| None | Code-only change, no DB, no config | No |
| Low | Config change with feature flag, backward-compatible DB migration | Maybe (if rollback risk) |
| Medium | Breaking DB migration, env var change, service restart | Yes |
| High | Major schema change, breaking API change, data migration | Yes, extensive planning |

For Medium/High impact tasks:

- Get explicit human approval for outage window
- Schedule outside business hours (if applicable)
- Prepare rollback plan
- Notify stakeholders via Slack before and after

---

## Error Handling and Recovery

### Subagent Failure

If a subagent fails (per the failure conditions in the prompt template):

1. **Capture error logs**
2. **Diagnose the failure**:
   - Resource exhaustion (disk, RAM)?
   - Dependency missing?
   - Permission error?
   - Bug in subagent prompt?
   - Dev environment broken (cannot compile/build/commit)?
   - Task scope too large (needs re-scoping)?
   - Infinite loop or hung thread?
   - Attempted to use inline scripting (should have created a script file)?
   - Attempted to use destructive system command (rm -rf, dd, mkfs, etc.)?
   - Attempted to use risky git command (force push, rebase, branch deletion, etc.)?
3. **Retry strategy**:
   - If resource issue: reduce concurrency, free resources, retry
   - If dependency issue: install dependency, retry
   - If permission error: ask orchestrator to inform human about the unapproved command, wait for human approval and manual update to the approved list, then retry
   - If bug in prompt: refine prompt, retry
   - If dev environment broken: notify human for manual intervention
   - If task scope too large: notify human for re-scoping
   - If infinite loop: kill subagent and refine prompt with clearer constraints
   - If inline scripting attempted: instruct subagent to create a dedicated .sh script file instead
   - If destructive system command attempted: instruct subagent to stop immediately and ask for human approval
   - If risky git command attempted: instruct subagent to stop and ask for human approval before proceeding
4. **Notify human** via Slack if failure cannot be auto-recovered

### PR Rejection

If human rejects a PR:

1. **Capture feedback** from PR comments
2. **Relay to subagent** with the feedback
3. **Subagent iterates** on the work
4. **Raise new PR** or update existing PR
5. **Loop** until approved

### Ambiguous PR Health Issues

If the PR-maintenance subagent reports an issue it cannot fix unambiguously (merge conflict, failing check, or failed deployment):

1. **Do not retry blindly**: Do not re-dispatch the same item to the subagent until the human responds
2. **Escalate via Slack**: Send the diagnosis (PR number, conflicted files or failing check/deployment logs, and the subagent's analysis) using the "PR Issue Needs Human Decision" template
3. **Wait for human**: The human either fixes manually, provides guidance, or approves a suggested fix
4. **Relay guidance**: Pass the human's answer back to the subagent (or a new PR-maintenance subagent) to continue
5. **Resume polling**: Other PR health items may still be processed; only the ambiguous item is paused

### Production Rollback

If production change fails:

1. **Execute rollback plan** immediately
2. **Notify human** via Slack with failure details
3. **Investigate root cause**
4. **Fix issue** in separate branch
5. **Schedule retry** with human approval

---

## Output Checklist

When orchestrator completes a session:

- [ ] All open issues have been processed (or deferred with reason)
- [ ] Each issue has a corresponding branch/worktree
- [ ] Each issue has a subagent working on it (or completed)
- [ ] Pull requests are raised for completed work
- [ ] Open PRs were checked for merge conflicts and CI/deployment failures (every 5 minutes)
- [ ] Human has been notified via Slack at key milestones
- [ ] Production impact tasks have outage window approval
- [ ] Resources (disk, RAM, credits) were not exhausted
- [ ] Worktrees are cleaned up after merge
- [ ] Dependency graph was respected
- [ ] Free models were used by default

---

## When to Use

- You need to coordinate multiple GitHub issues across a repository
- You want to scale development work through parallel subagents
- You need to ensure human review before code merges
- You want to track work status via Slack
- You're running on resource-constrained hardware
- You need to optimize for cost over speed

---

## When Not to Use

- Single task that doesn't require orchestration
- Repository without GitHub integration
- No Slack integration available
- Human wants direct control over every commit
- Task requires real-time human-in-the-loop iteration (subagent overhead too high)

---

## Variations

### Minimal Orchestrator

For simple repositories with low complexity:

- Skip dependency graph (assume all independent)
- Skip resource checks (assume sufficient)
- Skip Slack integration (use GitHub comments only)
- Use only local subagents, no cloud agents

### High-Priority Orchestrator

For urgent, deadline-driven work:

- Use paid models by default for speed
- Increase concurrency (within resource limits)
- Use cloud agents for parallelism
- Aggressive Slack notifications
- Human-in-the-loop at every milestone

### Production-First Orchestrator

For production-critical repositories:

- Strict outage window enforcement
- Manual approval for all production-impacting changes
- Rollback plans required for all Medium/High impact tasks
- Extensive pre-merge testing
- Human review for every PR, no auto-merge
