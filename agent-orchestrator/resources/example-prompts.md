# Example Orchestrator Prompts

## Basic Orchestrator

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo, and create a subagent for each issue. Each subagent should raise a new PR which fixes the issue.
```

## Orchestrator with Priority Filtering

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues with the "high-priority" label for this repo, and create a subagent for each issue. Each subagent should raise a new PR which fixes the issue. Use free models by default.
```

## Orchestrator with Dependency Awareness

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo, build a dependency graph, and process issues in dependency order. Create a subagent for each issue. Each subagent should raise a new PR which fixes the issue. Notify me via Slack when work starts and completes.
```

## Orchestrator for Production Changes

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo, and identify which ones have production impact (DB migrations, env var changes, service restarts). For production-impacting issues, ask me for an approved outage window before starting work. For each issue, create a subagent that raises a PR.
```

## Orchestrator with Resource Constraints

```
I want you to act as an orchestrator agent. I have limited disk space (10GB free) and RAM (4GB free). Iterate through the list of GitHub issues for this repo, and create subagents for up to 2 issues in parallel. Monitor resources and reduce concurrency if needed. Each subagent should raise a new PR which fixes the issue.
```

## Orchestrator for Specific Issue

```
I want you to act as an orchestrator agent. Focus on GitHub issue #123: [issue title]. Create a subagent to fix this issue. The subagent should work in a new branch and raise a PR for review. Notify me via Slack when work starts and when the PR is ready.
```

## Orchestrator with Manual Approval

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo. For each issue, ask me for approval before creating a subagent. Once approved, create the subagent, which should raise a PR. Notify me via Slack at each step.
```

## Orchestrator with Testing Requirement

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo. For each issue, create a subagent that must run the test suite before raising a PR. If tests fail, the subagent should fix them before creating the PR. Notify me via Slack of test results.
```

## Tips for Writing Orchestrator Prompts

- **Be specific about scope**: "all issues" vs "high-priority issues" vs "specific issue #123"
- **Specify resource constraints**: If you have limited disk/RAM, mention it
- **Specify model preference**: "Use free models by default" or "Use paid models for speed"
- **Specify communication channel**: "Notify me via Slack" or "Use GitHub comments"
- **Specify production handling**: "Ask for outage window approval" or "No production changes without explicit approval"
- **Specify testing requirements**: "Run tests before PR" or "No tests required"
- **Specify concurrency**: "Process in parallel" or "Process sequentially" or "Max 2 in parallel"
