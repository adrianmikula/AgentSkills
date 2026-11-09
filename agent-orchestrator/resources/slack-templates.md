# Slack Communication Templates

Use these templates for orchestrator-to-human and human-to-subagent communication via Slack.

## Orchestrator → Human Notifications

### Work Started
```
🚀 Started work on issue #<number>: <title>
Branch: <branch-name>
Estimated completion: <time estimate>
```

### Work Completed
```
✅ Completed work on issue #<number>: <title>
PR: <pr-url>
Ready for review
```

### Work Blocked
```
⚠️ Blocked on issue #<number>: <title>
Reason: <why blocked>
Needs: <what is needed from human>
```

### Work Failed
```
❌ Failed on issue #<number>: <title>
Reason: <failure reason>
```

### Permission Request
```
🔐 Permission request for issue #<number>: <title>
Command: <command that needs approval>
Reason: <why this command is needed>
```

The human should respond with either:
- "Approved" - then manually add the command to the approved list
- "Denied" - then provide guidance on how to proceed

### Production Change Scheduled
```
📅 Production change scheduled for <datetime>
Issue: #<number> <title>
Impact: <impact description>
Expected downtime: <duration>
```

### Production Change Complete
```
✅ Production change complete
Issue: #<number> <title>
Result: <success/failure and details>
```

## Human → Subagent Questions

When human answers a question via Slack:

1. Orchestrator relays the answer to the subagent
2. Subagent continues work
3. Subagent may ask follow-up questions
4. Loop until subagent completes
