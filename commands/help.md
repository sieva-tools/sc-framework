---
name: sc:help
description: Show help documentation for all SC commands
---

<objective>
Display comprehensive help for all SC (SievaTeam-Claude) commands.
</objective>

<process>

<step name="display">
## Show Help

**READ [help action](./actions/help.md) for full content.**

Display:

```
SC (SievaTeam-Claude) v1.0 — Help

SETUP:
  /sc:map                    Deep codebase analysis (run once per project)

TASK MANAGEMENT:
  /sc:add <task>              Capture task with questions + planning
  /sc:work                    Process all pending tasks
  /sc:batch                   PRD mode — multiple tasks with dependency planning
  /sc:status                  Show queue, progress, team sessions
  /sc:resume                  Continue after context reset

UTILITIES:
  /sc:update                  Refresh codebase memory after changes
  /sc:mode <normal|overnight> Switch session mode
  /sc:help                    Show this help

WORKFLOW:
  1. /sc:map      → Analyze codebase (once)
  2. /sc:add task   → Capture + plan (repeatable)
  3. /sc:work       → Implement + test (processes queue)

SESSION MODES:
  Normal    — Interactive, asks at decision points
  Overnight — Autonomous, logs decisions

TEAM FEATURES:
  - Session locking (warns about concurrent sessions)
  - Shared task history (.claude-team/history/tasks.jsonl)
  - Batch/PRD mode for multi-task planning

FOLDER STRUCTURE:
  .claude-team/    — Team state, codebase map, history
  pp/              — Task queue, plans, research, archive
  tests/pp/        — Playwright tests and screenshots
```
</step>

</process>
