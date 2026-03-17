---
name: sc:status
description: Show current state, queue, and recent completions
---

<objective>
Display the current SC status including queue count, current task, progress, team sessions, and recent completions.
</objective>

<enforcement>
## SESSION SETUP CHECK

**If this is the FIRST /sc command in a new session, you MUST ask the 4 session setup questions BEFORE showing status.**
See SKILL.md for the 4 questions.
</enforcement>

<process>

<step name="check">
## Gather State

```bash
cat pp/STATE.md 2>/dev/null || echo "NO_STATE"
ls pp/REQ-*.md 2>/dev/null || echo "NO_REQUESTS"
ls .claude-team/sessions/*.lock 2>/dev/null || echo "NO_LOCKS"
cat .claude-team/initialized 2>/dev/null || echo "NOT_INITIALIZED"
```

**READ [status action](./actions/status.md) for full display logic.**
</step>

<step name="display">
## Display Format

```
sc Status (v1.0)

Codebase: [Initialized/Not initialized]
Session Mode: [Normal/Overnight]
Auto-commit: [Yes/No]
Playwright: [Yes/No]

Active Sessions: [N]
  - [session info from lock files]

Queue: [N] pending tasks
  1. REQ-XXX: [title]
  2. REQ-XXX: [title]

Current: [REQ-XXX if working, or Idle]
Step: [current step if working]

Recent Completions:
  - REQ-XXX: [title] → [commit hash]

Run /sc:work to start processing.
```
</step>

</process>
