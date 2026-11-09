Minimal Improvements (Optional)
1. Add failure conditions to the subagent prompt template

Just add one field: "Failure conditions: When to give up and report back"
No complex logic, just clearer expectations
2. Mention async background work as an option

Add a note that subagents can run in the background (async) if supported
Keep the current synchronous approach as default
One paragraph, no new tools or complexity
3. Add a simple timeout note

Just mention setting reasonable timeouts for subagent tasks
One sentence in the resource management section
These are all documentation-level changes that add clarity without adding complexity or new systems.


yes, lets add the following minimal improvements: async background work (by default), timeouts (only for hung threads, subagents can take as long as they need to complete tasks.  failure conditions should be basic (out of disk space/ram, agent ends up in an infinite loop, gibberish output, bug/issue is unsolvable after repeated attempts, task scope is bigger than expected and needs a complete re-design/re-scoping, dev env is broken and project can't be compiled/built/committed etc. 