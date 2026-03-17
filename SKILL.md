---
name: sc
description: SievaTeam-Claude — Team task queue with codebase analysis, smart questioning, auto-research, batch/PRD mode, and Playwright testing
argument-hint: init | add <task> | work | batch | status | resume | update | help | mode
---

# SC (SievaTeam-Claude) Skill

A team-oriented task management system that combines deep codebase understanding with structured capture→plan→work workflows. Merges team collaboration features with power-pack-style task processing.

**Core Philosophy:** Understand the codebase first. Think before coding. Ask questions when uncertain. Test everything. Track everything.

## CRITICAL: Capture vs Work Separation

**`/sc add` and `/sc work` are SEPARATE actions. Do NOT combine them.**

### `/sc add <task>` — Capture ONLY
- Rephrase prompt into optimized detailed version (using agent)
- Save rephrased prompt to `pp/rephrased/`
- Ask clarifying questions (ALWAYS — both Normal and Overnight modes)
- Match vague terms to UI Element Index from CODEBASE_MAP.md
- Enter plan mode for medium/complex tasks
- Save plan to `pp/plans/`
- Create REQ file(s) with references to rephrased prompt and plan
- **NEVER write code**
- **NEVER implement anything**
- End with: "Ready to implement? Run `/sc work`"

### `/sc work` — Implementation ONLY
- Follow the workflow in [work action](./actions/work.md) step by step
- Check session locks (team feature)
- Move files through: `pp/` → `pp/working/` → `pp/archive/`
- Generate tests, run test loop, create verification
- Log to `.claude-team/history/tasks.jsonl`

**NEVER implement during `/sc add`. NEVER skip file operations during `/sc work`.**

---

## CRITICAL: Follow the Workflow

**When `/sc work` is invoked, you MUST follow the workflow in [work action](./actions/work.md) step by step.**

**NEVER:**
- Implement directly without creating folder structure first
- Skip the claim step (moving REQ to working/)
- Delegate file operations to agents
- Skip test generation (if Playwright enabled)
- Skip archiving completed work

**ALWAYS:**
- Run `mkdir -p pp/{config,research,working,archive,rephrased,plans} .claude-team/{sessions,history} tests/pp tests/pp/screenshots` first
- Move REQ file to `pp/working/` before implementation
- Update STATE.md at each step
- Generate Playwright tests yourself (not via agents)
- Run the test loop until pass/skip
- Move completed work to `pp/archive/`
- Log completion to `.claude-team/history/tasks.jsonl`

---

## Update Check (First-Time Per Session)

On the **first `/sc` command** in a new session, **before asking setup questions**, check for updates:

1. Run this command silently:
```bash
cd ~/.claude/skills/sc && git fetch origin main 2>/dev/null && git rev-list HEAD..origin/main --count 2>/dev/null
```

2. **If count > 0** (updates available):
   - Read the local VERSION file: `cat ~/.claude/skills/sc/VERSION`
   - Read the remote VERSION: `git show origin/main:VERSION 2>/dev/null`
   - **Auto-pull the update:**
   ```bash
   cd ~/.claude/skills/sc && git pull origin main 2>/dev/null
   ```
   - Display to the user:
   ```
   sc updated! v[old] → v[new]
   Restart your Claude Code session to get all changes.
   ```
   - Then continue with session setup as normal

3. **If count = 0 or fetch fails** (up to date or offline):
   - Say nothing, proceed silently to session setup

**This check runs ONCE per session.**

---

## Session Setup (MANDATORY — Every New Session)

**CRITICAL: On the FIRST `/sc` command in a new session, you MUST ask these FOUR questions. NO EXCEPTIONS.**

**Rules:**
- **ALWAYS ask these 4 questions at the start of every new Claude Code session**
- **NEVER skip these questions** because you "already know" the preferences
- **NEVER persist these preferences** to MEMORY.md or any auto-memory file
- Previous session preferences are INVALID — each session starts fresh
- Only skip on subsequent `/sc` commands within the SAME session

Ask these FOUR questions:

### Question 1: Session Mode

```
[AskUserQuestion]
header: "Session Mode"
question: "How will you be using this session?"
options:
- "Normal" — I'm here, ask me at decision points
- "Overnight" — Run autonomously, don't wait for input
```

| Mode | Behavior |
|------|----------|
| **Normal** | Pause at checkpoints, ask for confirmation |
| **Overnight** | Auto-select recommended options, log decisions |

**Overnight mode only affects the WORK phase.** Capture (`/sc add`) ALWAYS asks questions in both modes.

### Question 2: Auto-Commit

```
[AskUserQuestion]
header: "Auto-commit"
question: "Auto-commit changes after each task?"
options:
- "Yes" — Commit automatically after each completed task
- "No" — I'll commit manually
```

### Question 3: Playwright Testing

```
[AskUserQuestion]
header: "Auto-testing"
question: "Automated Playwright tests for this session?"
options:
- "Yes" — Generate and run Playwright tests (functionality + UI screenshots)
- "No" — Skip automated testing
```

### Question 4: Plan Verification

```
[AskUserQuestion]
header: "Plan review"
question: "Review implementation plan before proceeding?"
options:
- "Verify with me" — Show plan, ask for approval
- "Continue directly" — Show plan, proceed automatically
```

**Store all four in memory for this session ONLY.**
**NEVER persist to MEMORY.md, auto-memory, or any cross-session file.**

To switch mode mid-session: `/sc mode normal` or `/sc mode overnight`

---

## Commands

| Command | Action | Description |
|---------|--------|-------------|
| `/sc init` | init | Deep codebase analysis → CLAUDE.md + CODEBASE_MAP.md |
| `/sc help` | help | Show help documentation with all commands |
| `/sc add <description>` | capture | Capture a new task with smart questioning |
| `/sc work` | work | Process all pending tasks in the queue |
| `/sc batch` | batch | PRD mode — enter multiple tasks with dependency planning |
| `/sc resume` | resume | Continue from where you left off |
| `/sc status` | status | Show current state and pending work |
| `/sc update` | update | Refresh codebase memory after changes |
| `/sc mode <normal\|overnight>` | mode | Switch session mode |

---

## Routing Decision

### Step 1: Parse the Command

Examine what follows `/sc`:

| Pattern | Example | Route |
|---------|---------|-------|
| Empty or `status` | `/sc` or `/sc status` | → status |
| `init` | `/sc init` | → init (deep codebase analysis) |
| `help` | `/sc help` | → help |
| `add <text>` | `/sc add make it faster` | → capture (with text as input) |
| `work` | `/sc work` | → work (process queue) |
| `batch` | `/sc batch` | → batch (PRD mode) |
| `resume` | `/sc resume` | → resume |
| `update` | `/sc update` | → update (refresh memory) |
| `mode normal` | `/sc mode normal` | → set mode to Normal |
| `mode overnight` | `/sc mode overnight` | → set mode to Overnight |

### Step 2: Extract Payload for add

For `/sc add`, everything after `add ` is the task description:

```
/sc add make the dashboard faster
        ^^^^^^^^^^^^^^^^^^^^^^^^
        This is the payload → passed to capture action
```

### Step 3: Handle Ambiguous Input

If input doesn't match a known command but has content:
- Treat it as `/sc add <content>`
- Example: `/sc fix the login bug` → routes to capture with "fix the login bug"

---

## Team Features

### Session Locking

When `/sc work` starts, create a lock file:
```bash
echo "Task: [task] | User: $USER | Started: $(date +%H:%M:%S)" > ".claude-team/sessions/$$.lock"
```

Before starting work, check for other active sessions:
```bash
ls .claude-team/sessions/*.lock 2>/dev/null
```

If other sessions active, warn the user about potential conflicts.

Clean up lock on completion.

### Task History

Log every completed task to `.claude-team/history/tasks.jsonl`:
```json
{"date":"2026-03-17","member":"durga","task":"Dashboard optimization","type":"FEATURE","req":"REQ-001","files":["dashboard.php","js/dashboard.js"],"tests":"5/5","commit":"abc1234"}
```

---

## Action References

**IMPORTANT: You MUST read and follow the detailed instructions in the action file for the command being executed.**

When routing to an action, READ THE FULL ACTION FILE before doing anything:

| Command | Action File to READ |
|---------|---------------------|
| `/sc init` | **READ [init action](./actions/init.md) FIRST** |
| `/sc add` | **READ [capture action](./actions/capture.md) FIRST** |
| `/sc work` | **READ [work action](./actions/work.md) FIRST** |
| `/sc batch` | **READ [batch action](./actions/batch.md) FIRST** |
| `/sc status` | **READ [status action](./actions/status.md) FIRST** |
| `/sc help` | **READ [help action](./actions/help.md) FIRST** |
| `/sc update` | **READ [update action](./actions/update.md) FIRST** |

**DO NOT improvise. DO NOT skip reading the action file.**

---

## Folder Structure

### Team State (in project root)
```
.claude-team/
├── sessions/                    # Session locks (team)
├── history/
│   └── tasks.jsonl             # Task history log
├── CODEBASE_MAP.md             # Detailed file/function/UI index
├── SYSTEM_PROMPT.md            # Task workflow rules
└── initialized                  # Marker file (from /sc init)
```

### Task Queue (in project root)
```
pp/
├── REQ-001-task.md             # Pending queue
├── STATE.md                    # Current state, decisions, blockers
├── config/
│   └── test-env.json           # Test credentials (gitignored)
├── rephrased/                  # Optimized prompts
│   └── REQ-001-rephrased.md
├── plans/                      # Implementation plans
│   └── REQ-001-plan.md
├── research/
│   └── REQ-001-RESEARCH.md     # Auto-generated research docs
├── user-requests/               # Verbatim input preservation
│   └── UR-001/
│       ├── input.md
│       └── assets/
├── working/                     # In progress
└── archive/                     # Completed work
    └── UR-001/
        ├── input.md
        ├── REQ-001-task.md
        └── VERIFICATION.md

tests/
└── pp/                          # Generated Playwright tests
    ├── REQ-001-task.spec.js
    └── screenshots/
        └── REQ-001/
```

---

## What Makes SC Different

| Aspect | Basic Claude | SC (SievaTeam-Claude) |
|--------|-------------|----------------------|
| Codebase knowledge | None | Deep analysis with UI Element Index |
| Prompt quality | As-is | Auto-rephrased for maximum output |
| Questioning | None | Collaborative (both modes) |
| Planning | None | Plan mode for every task |
| Research | None | Auto-detect & research unfamiliar tech |
| Testing | None | Zero-tolerance functionality + UI screenshot tests |
| Test failures | N/A | Fix-retry loop — must reach 100% pass |
| UI verification | None | Screenshot review with alignment/spacing checks |
| State tracking | None | STATE.md for resume |
| Team support | None | Session locking, shared history, batch/PRD |
| Batch mode | None | Multi-task PRD with dependency analysis |
| Memory refresh | None | Incremental codebase re-analysis |
