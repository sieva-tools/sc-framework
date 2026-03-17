---
name: sc:mode
description: Switch session mode (normal or overnight)
argument-hint: <normal|overnight>
---

<objective>
Switch the current session mode between Normal (interactive) and Overnight (autonomous).
</objective>

<process>

<step name="switch">
## Parse and Switch

Extract mode from input: `normal` or `overnight`

If no argument or invalid:
```
[AskUserQuestion]
header: "Mode"
question: "Which mode?"
options:
- "Normal" — I'm here, ask me at decision points
- "Overnight" — Run autonomously, don't wait for input
```

**Update session memory (NOT files).**

| Mode | Behavior |
|------|----------|
| **Normal** | Pause at checkpoints, ask for confirmation |
| **Overnight** | Auto-select recommended options, log decisions |

**Overnight mode only affects the WORK phase.** Capture (`/sc:add`) always asks questions.

Report:
```
Mode switched to [Normal/Overnight].
```
</step>

</process>
