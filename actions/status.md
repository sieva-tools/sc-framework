# Status Action

> **Part of the SC skill.** Displays current state, queue, team sessions, and recent completions.

## Gather State

Read all relevant state files:

```bash
echo $USER
cat pp/$USER/STATE.md 2>/dev/null || echo "NO_STATE"
ls pp/$USER/REQ-*.md 2>/dev/null || echo "NO_REQUESTS"
ls pp/$USER/working/REQ-*.md 2>/dev/null || echo "NO_WORKING"
ls .claude-team/sessions/*.lock 2>/dev/null || echo "NO_LOCKS"
cat .claude-team/initialized 2>/dev/null || echo "NOT_INITIALIZED"
```

For each pending REQ, read the title from frontmatter.
For each lock file, read the session info.

---

## Display Formats

### Not Initialized, No Tasks

```
sc Status (v1.0)

Codebase: Not initialized
No pending tasks.

Run /sc:init to analyze your codebase first.
Then /sc:add <task> to capture a task.
```

### Initialized, No State, Has Tasks

```
sc Status (v1.0)

Codebase: Initialized ([date])
Session: [Normal/Overnight] | Auto-commit: [Yes/No] | Playwright: [Yes/No]

Queue: [N] pending tasks
  1. REQ-XXX: [title]
  2. REQ-XXX: [title]

Active Sessions: None

Run /sc:work to start processing.
```

### Idle with Recent Completions

```
sc Status (v1.0)

Codebase: Initialized ([date])
Status: Idle
Session: [Normal/Overnight] | Auto-commit: [Yes/No] | Playwright: [Yes/No]

Queue: [N] pending tasks
  1. REQ-XXX: [title]

Active Sessions: None

Recent Completions:
  REQ-XXX: [title] → [commit hash] ([date])
  REQ-XXX: [title] → [commit hash] ([date])

Run /sc:work to start processing.
```

### Currently Working

```
sc Status (v1.0)

Codebase: Initialized ([date])
Status: Working (paused)
Session: [Normal/Overnight]

Current: REQ-XXX-[slug]
Step: [claim|research|explore|implement|test|screenshot-review|archive]
Last activity: [timestamp]

[If testing:]
Func Tests: [X]/[Y] passed
UI Screenshots: [X]/[Y] reviewed
UI Issues: [N] found, [M] fixed
Attempt: [N]

Active Sessions:
  - [session info from lock files]

Queue: [N] remaining tasks

Run /sc:resume to continue.
```

---

## Team History (optional, if user asks)

If user requests detailed history:

```bash
tail -10 .claude-team/history/tasks.jsonl 2>/dev/null
```

Display as table:
```
Recent History:
| Date | Member | Task | Type | Tests |
|------|--------|------|------|-------|
| [date] | [user] | [task] | [type] | [X/Y] |
```
