---
name: sc:work
description: Process all pending tasks in the queue with research, implementation, and testing
---

<objective>
Process pending requests with auto-research, implementation, and zero-tolerance Playwright testing (functionality + UI screenshot verification). Includes team features: session locking and history logging.
</objective>

<enforcement>
## STRICT COMPLIANCE REQUIRED

**You MUST follow EVERY step below in EXACT order. DO NOT skip, reorder, or combine steps.**

**READ the full action file BEFORE doing anything:**
```bash
cat ~/.claude/skills/sc/actions/work.md
```

**Follow the action file instructions step by step. The steps below are a summary.**
</enforcement>

<orchestrator_rules>
**You are the orchestrator. You MUST do these yourself (NEVER delegate to agents):**
- Create folder structure
- Move request files between folders
- Update frontmatter status
- Manage session locks
- Generate Playwright test files
- Run the test loop
- Review screenshots for UI issues
- Create VERIFICATION.md reports
- Archive completed work
- Create git commits
- Log to .claude-team/history/tasks.jsonl

**Agents do:**
- Research (web search)
- Explore codebase patterns
- Write actual code
- Fix code when tests fail
</orchestrator_rules>

<process>

<step name="preflight">
## Pre-Flight Checks

1. Create ALL folders:
```bash
mkdir -p pp/{config,research,working,archive,rephrased,plans} .claude-team/{sessions,history} tests/pp tests/pp/screenshots
```

2. Check session preferences (if not set, ask the 4 questions)
3. If Playwright enabled, check test-env.json
4. Check for pending requests: `ls pp/REQ-*.md 2>/dev/null`
5. Check for other active sessions (team locking):
```bash
ls .claude-team/sessions/*.lock 2>/dev/null
```
</step>

<step name="claim">
## Step 1-2: Find and Claim Request

Pick first REQ file, move to `pp/working/`, update frontmatter, create session lock.
</step>

<step name="research">
## Step 3-4: Analyze and Research

Check if task needs research (external APIs, unfamiliar tech).
If yes, create `pp/research/REQ-XXX-RESEARCH.md`.
</step>

<step name="explore">
## Step 5: Explore Codebase

Spawn Explore agent. Read CODEBASE_MAP.md for context. Find relevant files and patterns.
</step>

<step name="plan">
## Step 6: Load Plan

Load plan from `pp/plans/REQ-XXX-plan.md` (created during /sc:add).
If missing, enter plan mode now.
</step>

<step name="implement">
## Step 7: Implement

Spawn general-purpose agent with all context (request, research, codebase, plan).
</step>

<step name="test">
## Step 8-9: Generate and Run Tests

**SKIP if Playwright testing disabled.**

Create test file at `tests/pp/REQ-XXX.spec.js` with functionality + UI screenshot tests.
Run zero-tolerance test loop. Review screenshots for UI issues.
</step>

<step name="finalize">
## Step 10-13: Verify, Archive, Commit, Loop

Create VERIFICATION.md. Move to archive. Commit if enabled. Log to history. Check for more REQs.
</step>

</process>

<checklist>
## Orchestrator Checklist

```
□ Pre-flight: Create folders, check locks, check queue
□ Step 2: mv REQ to working/, create session lock
□ Step 3: Analyze for research needs
□ Step 4: (if needed) Create RESEARCH.md
□ Step 5: Spawn Explore agent
□ Step 6: Load plan from capture phase
□ Step 7: Spawn implementation agent
□ Step 8: (if Playwright) Create test file
□ Step 9: (if Playwright) Run test loop + screenshot review
□ Step 10: (if Playwright) Create VERIFICATION.md
□ Step 11: Archive, update STATE.md
□ Step 12: (if auto-commit) Git commit
□ Step 13: Log to tasks.jsonl, remove session lock, loop or exit
```
</checklist>
