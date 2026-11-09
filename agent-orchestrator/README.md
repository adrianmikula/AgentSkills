# Agent Orchestrator Skill

A Claude skill that defines the standard process for orchestrator agents to manage software development work through GitHub-centric workflows.

## Features

- **GitHub-centric workflow**: Issues → Branches/Worktrees → Pull Requests → Merge
- **Async background work**: Subagents run in the background by default, orchestrator stays available
- **Slack integration**: Bidirectional communication for status updates and clarifying questions
- **Resource management**: Disk space, RAM, and cloud credit awareness
- **Permission management**: Pre-approve commands to prevent subagents from getting blocked; human maintains the approved command list. Inline scripting, destructive system commands (rm -rf, dd, mkfs, etc.), and risky git commands (force push, rebase, branch deletion, etc.) are forbidden
- **Script management**: Inline scripting is forbidden; reusable .sh scripts are created and documented for complex operations
- **State tracking**: Track active subagents, prevent duplicates, and monitor status
- **Helper scripts**: Reusable scripts for polling GitHub issues, checking subagent status, cleaning up worktrees, and long-running orchestration
- **Real-world patterns**: Proven orchestration patterns including worktree isolation, worktree reuse, auth recipes, failure-state propagation, and prompt discipline
- **Cloud agent rationing**: Default to local agents, use cloud agents only for urgent tasks or when local agents aren't available
- **Cost optimization**: Free Devin models by default, paid models only for high-value tasks
- **Dependency handling**: Respects task dependencies and production impact windows
- **Production safety**: Outage window approval for production-impacting changes
- **Failure detection**: Clear failure conditions (resource exhaustion, infinite loops, broken dev env, etc.)

## Usage

Invoke this skill when you need an orchestrator agent to:

- Coordinate multiple GitHub issues across a repository
- Scale development work through parallel subagents
- Ensure human review before code merges
- Track work status via Slack
- Manage work on resource-constrained hardware
- Optimize for cost over speed

## Quick Start

```
I want you to act as an orchestrator agent. Iterate through the list of GitHub issues for this repo, and create a subagent for each issue. Each subagent should raise a new PR which fixes the issue.
```

The orchestrator will:

1. Fetch and prioritize GitHub issues
2. Build a dependency graph
3. Check available resources (disk, RAM, credits)
4. Launch subagents in isolated branches/worktrees
5. Monitor progress and relay questions via Slack
6. Create pull requests for human review
7. Merge after approval

## Documentation

See [Skill.md](./Skill.md) for the complete specification including:

- Detailed workflow phases
- Subagent prompt templates
- Resource management rules
- Dependency management
- Slack communication patterns
- Error handling and recovery
- Example orchestrator session

## Variations

The skill includes variations for different scenarios:

- **Minimal Orchestrator**: For simple repositories with low complexity
- **High-Priority Orchestrator**: For urgent, deadline-driven work
- **Production-First Orchestrator**: For production-critical repositories

## License

Part of the AgentSkills repository.
