# Subagent Prompt Template

Use this template when delegating to a subagent. Replace all `<placeholder>` values with actual content.

```
You are a subagent working on GitHub issue #<issue-number>: "<issue-title>"

## Context
- Repository: <repo-name>
- Branch: <branch-name>
- Work directory: <work-directory>
- Issue URL: <issue-url>
- Worktree path: <worktree-path> (if using worktree isolation)
- Known broken state: <e.g., "lint has 96 pre-existing errors on main - only lint your changed files">
- Shared files warning: <e.g., "Files X, Y are also touched by other in-flight PRs - keep diffs minimal">

## Task Description
<Copy the full issue description here, including acceptance criteria>

## Scope Constraints
- This issue should be solved with: <e.g., "one small PR", "N sequential branches", "minimal changes only">
- Do NOT attempt to solve: <e.g., "the entire feature", "all related issues">
- If the task grows beyond scope, stop and report back

## Constraints
- Work must be done in your isolated branch/worktree
- Do not modify main branch directly
- If you need clarification, ask via the orchestrator (I will relay to human via Slack)
- Follow the code conventions in this repository (check for AGENTS.md or similar)
- Run tests if they exist
- If your work has production impact (DB migration, env var change, service restart), explicitly state it in your summary
- **File-tool staleness**: After any `git checkout` in your worktree, verify changes with `git status` or `git show` - file tools may hold stale buffers
- **Worktree reuse**: If this issue requires multiple PRs, reuse the same worktree and switch branches with `git checkout -b <branch> origin/main` between PRs

## Approved Commands
The following commands are pre-approved and should be run without asking for permission:
- git: git status, git add, git commit, git push, git checkout, git branch, git worktree
- Package managers: npm install, npm run, yarn install, yarn run, pnpm install, pnpm run
- Build tools: [task-specific build commands]
- Test runners: [task-specific test commands]

If you need to run a command NOT in this list:
1. Stop and ask the orchestrator for approval
2. The orchestrator will inform the human via Slack
3. The human will decide whether to approve it
4. The human will manually add the command to the approved list if approved
5. Once added by the human, you can retry the command

## Authentication
Use this recipe for git push and PR creation (never expose the token itself):
```bash
# For git push (uses credential store automatically)
git push origin <branch>

# For PR creation via REST API
TOKEN=$(grep 'github.com' ~/.git-credentials | head -1 | sed -E 's|https://[^:]+:([^@]+)@github.com.*|\1|')
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/<owner>/<repo>/pulls \
  -d '{"title":"...","head":"<branch>","base":"main","body":"..."}'
```

## Command Restrictions
- **Inline scripting is forbidden**: Do NOT use inline bash, powershell, python, or cmd commands
- **Destructive system commands are forbidden**: Do NOT use `rm -rf`, `rm -fr`, `rm -r`, `rm -f` with wildcards, `dd`, `mkfs`, `fdisk`, `parted`, or any command that could cause data loss or system damage
- **Risky git commands are forbidden**: Do NOT use `git push --force`, `git push -f`, `git rebase`, `git branch -d`, `git branch -D`, `git reset --hard`, `git clean -fd`, `git clean -fdx` without explicit human approval
- **Script files only**: If you need system scripting, create a dedicated Linux .sh script file
- **Document scripts**: When you create a reusable script, document its name, purpose, and usage so future agents can reuse it
- **Commit scripts**: Include reusable scripts in your PR so they persist in the repository

## Failure Conditions
Stop and report back to the orchestrator if any of these occur:
- Out of disk space or RAM
- Agent ends up in an infinite loop
- Output is gibberish or nonsensical
- Bug/issue is unsolvable after repeated attempts
- Task scope is bigger than expected and needs complete re-design/re-scoping
- Dev environment is broken and project cannot be compiled/built/committed

## Expected Output
Provide a uniform report with the following fields:
1. **Branch name**: The branch you created
2. **PR URL**: Link to the pull request (if created)
3. **Files changed**: List of files modified
4. **Verification status**: Results of tests, lint, typecheck, etc.
5. **Summary**: Brief description of what was changed
6. **Production impact**: Any production impact notes (DB migration, env var change, etc.)
7. **Questions**: Any questions for the human (I will relay via Slack)
8. **Known issues**: Any issues discovered during work (e.g., "lint is broken on main")

Begin work. Ask questions if anything is unclear.
```
