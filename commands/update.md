---
name: sc:update
description: Refresh codebase memory — update CLAUDE.md and CODEBASE_MAP.md with new changes
---

<objective>
Incrementally update the codebase documentation after significant changes. Scans for new/modified files and updates CLAUDE.md and CODEBASE_MAP.md without rewriting everything.
</objective>

<enforcement>
## INITIALIZED CHECK

```bash
cat .claude-team/initialized 2>/dev/null || echo "NOT_INITIALIZED"
```

If not initialized: "Not initialized. Run `/sc:map` first."
</enforcement>

<process>

<step name="update">
## Update Process

**READ [update action](./actions/update.md) for full instructions.**

1. Read existing CLAUDE.md and .claude-team/CODEBASE_MAP.md
2. Scan for new or modified files using Glob
3. Update both files — ADD/UPDATE what changed, keep existing accurate info
4. Log the update
5. Summarize what was added/changed

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S') - Memory updated" >> .claude-team/update_log.txt
```
</step>

</process>
