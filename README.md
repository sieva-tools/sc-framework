# SC (SievaTeam-Claude)

A team-oriented task management framework for Claude Code. Think before coding, test after coding, track everything.

```
capture → plan → implement → test → archive
```

---

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/sievateam/sc/main/install.sh | bash
```

Then restart Claude Code.

---

## Getting Started (Step by Step)

### Step 1: Install SC

**Option A — One-liner (after repo is on GitHub):**
```bash
curl -fsSL https://raw.githubusercontent.com/sievateam/sc/main/install.sh | bash
```

**Option B — Manual install:**
```bash
git clone https://github.com/sievateam/sc.git ~/.claude/skills/sc
mkdir -p ~/.claude/commands
ln -sf ~/.claude/skills/sc/commands ~/.claude/commands/sc
```

**Option C — Already on the machine:**
If SC is already at `~/.claude/skills/sc/`, just create the symlink:
```bash
ln -sf ~/.claude/skills/sc/commands ~/.claude/commands/sc
```

After install, **restart Claude Code** (close and reopen).

### Step 2: Verify Installation

Open Claude Code and type:
```
/sc:help
```

You should see all available commands. If not, check:
```bash
ls -la ~/.claude/commands/sc
# Should show: sc -> /home/youruser/.claude/skills/sc/commands
```

### Step 3: Initialize Your Project

Navigate to your project folder in Claude Code, then:
```
/sc:init
```

This runs **once per project**. SC will:
- Scan every file in your codebase
- Create `CLAUDE.md` — project knowledge base with UI component map
- Create `.claude-team/CODEBASE_MAP.md` — searchable file/function/UI index
- Create `.claude-team/SYSTEM_PROMPT.md` — task workflow rules

**This takes a few minutes for large codebases.** After this, Claude knows your entire project.

### Step 4: Session Setup

The **first SC command in every new session** triggers 4 setup questions:

| # | Question | Options | What it means |
|---|----------|---------|---------------|
| 1 | **Session Mode** | Normal / Overnight | Normal = interactive. Overnight = autonomous. |
| 2 | **Auto-Commit** | Yes / No | Auto git commit after each task? |
| 3 | **Playwright Testing** | Yes / No | Generate and run automated tests? |
| 4 | **Plan Review** | Verify / Continue | Approve plan before coding? |

These are asked **once per session** and not saved across sessions.

### Step 5: Capture a Task

```
/sc:add fix the search on users page
```

SC will:
1. **Rephrase** your prompt for maximum clarity
2. **Ask 1-3 questions** to understand what you really want
3. **Match** vague terms like "users page" to exact files (from CODEBASE_MAP)
4. **Create a plan** with specific files and steps
5. **Save** everything to `pp/REQ-001-fix-search.md`

**SC does NOT write any code during capture.** It only thinks and plans.

Output:
```
Captured: Fix search functionality on users page

- Rephrased: pp/rephrased/REQ-001-rephrased.md
- Plan: pp/plans/REQ-001-plan.md
- Created: REQ-001-fix-search.md

Ready to implement? Run /sc:work
```

### Step 6: Process the Queue

```
/sc:work
```

SC processes each task in order:

```
Processing REQ-001-fix-search.md...
  Claiming...              [done]
  Loading context...       [done]
  Analyzing...             [done] → no research needed
  Exploring...             [done] → found patterns
  Loading plan...          [done]
  Implementing...          [done] → 2 files changed
  Generating tests...      [done] → 6 tests
  Running tests...
    ✓ func: search returns results (1/1)
    ✓ func: empty search handled (1/1)
    ✓ ui: full page screenshot — clean
    ✓ ui: mobile — clean
  Archiving...             [done]
  Committing...            [done] → abc1234

Queue empty. Done!
```

**That's it.** Capture → Work. Two commands for a full workflow.

---

## All Commands

| Command | What it does |
|---------|-------------|
| `/sc:init` | Analyze codebase, create knowledge base (once per project) |
| `/sc:add <task>` | Capture a task with questions + planning (no coding) |
| `/sc:work` | Process all pending tasks in queue |
| `/sc:batch` | Enter multiple tasks, get PRD with dependency analysis |
| `/sc:status` | Show queue, current progress, team sessions |
| `/sc:resume` | Continue after context reset / session restart |
| `/sc:update` | Refresh codebase memory after big changes |
| `/sc:mode normal` | Switch to interactive mode |
| `/sc:mode overnight` | Switch to autonomous mode |
| `/sc:help` | Show help |

---

## Common Workflows

### Single Task

```
/sc:add add logout button to header
/sc:work
```

### Multiple Tasks (One by One)

```
/sc:add fix login validation
/sc:add add dark mode toggle
/sc:add update footer links
/sc:work                          ← processes all 3 in order
```

### Multiple Tasks (Batch/PRD Mode)

```
/sc:batch
```

Then enter your tasks:
```
1. Add user authentication with OAuth
2. Create admin dashboard
3. Add data export feature
```

SC creates a Product Requirements Document with:
- Detailed specs for each task
- Dependency analysis (which tasks depend on others)
- Priority ordering (HIGH → MEDIUM → LOW)
- Execution plan table

After you approve, it executes them in the correct order.

### Check Progress

```
/sc:status
```

Shows:
```
sc Status (v1.0)

Codebase: Initialized (2026-03-17)
Session: Normal | Auto-commit: Yes | Playwright: Yes

Queue: 2 pending tasks
  1. REQ-002: Add dark mode toggle
  2. REQ-003: Update footer links

Current: Idle

Recent Completions:
  REQ-001: Fix login validation → abc1234

Run /sc:work to start processing.
```

### Resume After Context Reset

If Claude Code resets mid-task:
```
/sc:resume
```

Picks up exactly where it left off (claim, research, implement, test, etc.).

### After Adding New Files to Your Project

```
/sc:update
```

Incrementally updates CLAUDE.md and CODEBASE_MAP.md with new files. Does not rewrite everything — only adds/updates what changed.

---

## Session Modes Explained

### Normal Mode (Default)
- **Capture:** Asks clarifying questions (always)
- **Work:** Pauses at decision points, asks you to confirm
- **Best for:** When you're actively working and available

### Overnight Mode
- **Capture:** Asks clarifying questions (always — same as normal)
- **Work:** Auto-selects recommended options, logs decisions, never pauses
- **Best for:** Queue up tasks, let Claude run unattended

Switch mid-session:
```
/sc:mode overnight
/sc:mode normal
```

---

## Playwright Testing

When enabled, SC generates tests for every task:

**Functionality tests:**
- One test per success criterion
- Edge cases (empty input, invalid data, errors)

**UI screenshot tests:**
- Full page screenshot
- Feature element screenshot
- Mobile viewport (375px)
- Tablet viewport (768px)
- Hover/active states

**Zero-tolerance fix loop:**
- If a test fails, SC fixes the code and reruns
- Up to 10 attempts per test
- Reviews every screenshot for alignment, spacing, overflow issues
- Fixes UI issues and reruns until perfect

### Test Credentials

First time Playwright is enabled, SC asks for test environment details:
- Login URL
- Username / Password
- Base URL

Saved to `pp/config/test-env.json` (gitignored).

---

## Team Features

### Session Locking
When someone runs `/sc:work`, a lock file is created. If another team member starts work, they get a warning:

```
WARNING: Other sessions are active!
  - 12345: Task: Fix search | User: durga | Started: 10:30

Continue anyway?
```

### Shared History
Every completed task is logged to `.claude-team/history/tasks.jsonl`:
```json
{"date":"2026-03-17","member":"durga","task":"Fix search","type":"BUG_FIX","req":"REQ-001","tests":"5/5","commit":"abc1234"}
```

### Batch/PRD Mode
Plan multiple tasks together with dependency analysis before executing.

---

## Folder Structure

After setup, your project will have:

```
your-project/
├── CLAUDE.md                        ← Project knowledge base (created by /sc:init)
├── .claude-team/                    ← Team state
│   ├── CODEBASE_MAP.md             ← File/function/UI index
│   ├── SYSTEM_PROMPT.md            ← Task workflow rules
│   ├── initialized                  ← Marker file
│   ├── sessions/                    ← Session locks (team)
│   │   └── 12345.lock
│   └── history/
│       └── tasks.jsonl             ← Task history
├── pp/                              ← Task queue
│   ├── REQ-001-fix-search.md       ← Pending task
│   ├── STATE.md                    ← Current progress
│   ├── config/
│   │   └── test-env.json           ← Test credentials (gitignored)
│   ├── rephrased/                  ← Optimized prompts
│   │   └── REQ-001-rephrased.md
│   ├── plans/                      ← Implementation plans
│   │   └── REQ-001-plan.md
│   ├── research/                   ← Auto-research docs
│   ├── working/                    ← Currently in progress
│   └── archive/                    ← Completed tasks
│       ├── REQ-001-fix-search.md
│       └── REQ-001-VERIFICATION.md
└── tests/
    └── pp/                          ← Playwright tests
        ├── REQ-001-fix-search.spec.js
        └── screenshots/
            └── REQ-001/
                ├── ui-initial-fullpage.png
                ├── ui-mobile.png
                └── ui-tablet.png
```

### What to Gitignore

Add to your `.gitignore`:
```
pp/config/test-env.json
.claude-team/sessions/
```

### What to Commit

These are useful to keep in version control:
```
CLAUDE.md                         ← Team knowledge base
.claude-team/CODEBASE_MAP.md     ← Shared codebase index
.claude-team/history/tasks.jsonl  ← Team history
pp/archive/                       ← Completed task records
```

---

## Updating SC

SC auto-checks for updates on the first command of each session. If updates are available, it auto-pulls and tells you:

```
sc updated! v1.0.0 → v1.1.0
Restart your Claude Code session to get all changes.
```

Manual update:
```bash
cd ~/.claude/skills/sc && git pull origin main
```

---

## Uninstall

```bash
rm -rf ~/.claude/skills/sc
rm -f ~/.claude/commands/sc
```

Restart Claude Code.

---

## Troubleshooting

### Commands not showing up
```bash
# Check symlink exists
ls -la ~/.claude/commands/sc

# If missing, create it
ln -sf ~/.claude/skills/sc/commands ~/.claude/commands/sc

# Restart Claude Code
```

### "Not initialized" error
```
/sc:init
```
Run this in your project folder first.

### Want to re-analyze codebase
```bash
rm -rf .claude-team
rm CLAUDE.md
```
Then run `/sc:init` again.

### Stuck mid-task
```
/sc:resume
```
Or check state:
```
/sc:status
```

### Want to clear the queue
```bash
rm pp/REQ-*.md
```

### Context reset during work
Just run `/sc:resume` — it picks up from STATE.md.

---

## Quick Reference Card

```
SETUP:    /sc:init                  (once per project)
CAPTURE:  /sc:add <task>            (think + plan, no code)
WORK:     /sc:work                  (implement + test)
BATCH:    /sc:batch                 (multi-task PRD)
STATUS:   /sc:status                (see queue)
RESUME:   /sc:resume                (continue after reset)
UPDATE:   /sc:update                (refresh codebase memory)
MODE:     /sc:mode normal|overnight (switch mode)
HELP:     /sc:help                  (show commands)
```
