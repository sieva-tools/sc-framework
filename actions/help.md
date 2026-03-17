# Help Action

> **Part of the SC skill.** Displays comprehensive help documentation.

## Display Help

```
SC (SievaTeam-Claude) v1.0
Team task management with codebase analysis, smart capture, and automated testing.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SETUP
  /sc:map                     Deep codebase analysis (run once per project)
                               Creates CLAUDE.md + CODEBASE_MAP.md
                               Enables intelligent UI element matching

TASK MANAGEMENT
  /sc:add <task>               Capture task with smart questioning
                               Rephrases prompt, asks questions, creates plan
                               Does NOT implement — captures only

  /sc:work                     Process all pending tasks in queue
                               Research → Explore → Implement → Test → Archive
                               Zero-tolerance Playwright testing (if enabled)

  /sc:batch                    PRD mode for multiple tasks
                               Dependency analysis, priority ordering
                               Sequential execution after approval

  /sc:status                   Show queue, progress, team sessions
  /sc:resume                   Continue after context reset

UTILITIES
  /sc:update                   Refresh codebase memory after big changes
  /sc:upgrade                  Update SC framework to latest version
  /sc:mode <normal|overnight>  Switch session mode mid-session
  /sc:help                     Show this help

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WORKFLOW
  Step 1: /sc:map              Analyze codebase (once per project)
  Step 2: /sc:add <task>        Capture + question + plan (repeatable)
  Step 3: /sc:work              Implement + test + archive (processes queue)

TYPICAL SESSION
  1. Start Claude Code in your project
  2. /sc:status → see queue, answer 4 setup questions
  3. /sc:add fix the search on users page → captured
  4. /sc:add add export button to reports → captured
  5. /sc:work → processes both tasks in order

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SESSION MODES
  Normal      Interactive — pauses at decision points, asks you
  Overnight   Autonomous — auto-selects recommended options, logs decisions

  Note: Capture (/sc:add) ALWAYS asks questions in both modes.
  Overnight only affects the work phase.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SESSION SETUP (asked once per session)
  1. Session Mode    — Normal or Overnight
  2. Auto-Commit     — Yes or No
  3. Playwright      — Yes or No
  4. Plan Review     — Verify with me or Continue directly

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

TEAM FEATURES
  Session Locking    Detects concurrent sessions, warns about conflicts
  Shared History     All tasks logged to .claude-team/history/tasks.jsonl
  Batch/PRD Mode     Multi-task planning with dependency analysis

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FOLDER STRUCTURE (in your project)
  .claude-team/                 Team state, codebase map, history
    ├── CODEBASE_MAP.md         File/function/UI element index
    ├── sessions/               Session locks
    └── history/tasks.jsonl     Task history

  pp/                           Task queue and state
    ├── REQ-*.md                Pending tasks
    ├── STATE.md                Current progress
    ├── rephrased/              Optimized prompts
    ├── plans/                  Implementation plans
    ├── research/               Auto-research docs
    ├── working/                In-progress tasks
    └── archive/                Completed tasks

  tests/pp/                     Playwright tests
    ├── *.spec.js               Test files
    └── screenshots/            UI screenshots

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FEATURES FROM POWER-PACK
  Prompt Rephrasing    Agent rewrites your input for maximum clarity
  Clarifying Questions Collaborative questioning before building
  Plan Mode            Implementation plan before coding
  Auto-Research        Detects unfamiliar tech, researches before building
  Playwright Testing   Functionality + UI screenshots, zero-tolerance fix loop
  Screenshot Review    Reads screenshots, fixes alignment/spacing issues
  State Tracking       STATE.md enables resume after context reset

FEATURES FROM TEAM-CLAUDE
  Codebase Analysis    Deep scan → CLAUDE.md + CODEBASE_MAP.md
  UI Element Matching  Matches vague terms to specific files/components
  Batch/PRD Mode       Multi-task with dependency analysis
  Session Locking      Team-safe concurrent session detection
  Task History         Shared log of all completed tasks
  Memory Refresh       Incremental re-analysis after changes
```
