---
name: sc:resume
description: Continue work from where you left off after context reset
---

<objective>
Resume SC work from the last saved position in STATE.md. Restores full context including current task, test attempts, skipped tests, and decisions made.
</objective>

<process>

<step name="check_state">
## Check State

```bash
cat pp/STATE.md 2>/dev/null || echo "NO_STATE"
```

If no STATE.md:
```
No saved state found.
Run /sc:status to see the queue, or /sc:work to start processing.
```
</step>

<step name="parse_state">
## Parse and Resume

Read STATE.md and extract:
- Current status (idle/working)
- Working on (REQ file)
- Current step (claim/research/explore/plan-load/implement/test/screenshot-review/archive)
- Test attempt counters
- Skipped tests list
- UI issues found/fixed

Resume from the saved step following `/sc:work` workflow.
</step>

<step name="display">
## Resume Output

```
Resuming [REQ-XXX-slug]...

Last state:
  Step: [step name]
  Progress: [details]
  Last error: [if any]

Continuing from [step]...
```
</step>

</process>
