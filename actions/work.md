# Work Action

> **Part of the SC skill.** Processes pending requests with codebase-aware implementation, auto-research, team features, and automated Playwright testing with fix loops.

## CRITICAL: Orchestrator Responsibilities

The work action is an **orchestrator**. You (the orchestrator) are responsible for ALL file management, folder operations, and team features. Spawned agents do implementation work but do NOT touch request files, folder structure, or test generation.

**You MUST do these yourself (NEVER delegate to agents):**
- Create folder structure
- Move request files between folders
- Update frontmatter status fields
- Manage session locks (.claude-team/sessions/)
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
- Create implementation plans
- Write the actual code implementation
- Fix code when tests fail

---

## Pre-Flight Checks

**[Orchestrator action — do this yourself BEFORE anything else]**

### Check 1: Folder Structure

**IMPORTANT: You MUST create these folders if they don't exist.**

```bash
mkdir -p pp/config pp/research pp/working pp/archive pp/rephrased pp/plans
mkdir -p .claude-team/{sessions,history}
mkdir -p tests/pp tests/pp/screenshots
```

Run this command NOW before proceeding.

### Check 2: Session Preferences

Check if session preferences have been set. If not, ask the 4 questions from SKILL.md.

### Check 3: Team Session Locking

**Check for other active sessions:**
```bash
ls .claude-team/sessions/*.lock 2>/dev/null
```

If other sessions active, warn user:
```
WARNING: Other sessions are active!
  - [session info from lock files]

Continue anyway? This could cause conflicts.
```

Use AskUserQuestion to confirm.

### Check 4: Test Environment (if Playwright enabled)

```bash
cat pp/config/test-env.json 2>/dev/null
```

If missing AND Playwright enabled: STOP and ask for credentials.

### Check 5: Pending Requests

```bash
ls pp/REQ-*.md 2>/dev/null
```

If no REQ files: "Queue empty. Use `/sc add <task>` to capture tasks."

---

## Workflow Steps

### Step 1: Find Next Request

**[Orchestrator action]**

```bash
ls pp/REQ-*.md 2>/dev/null | head -1
```

Pick the first REQ file (sorted by number). If empty, exit.

### Step 2: Claim the Request

**[Orchestrator action — BEFORE spawning any agents]**

1. **Move request file:**
```bash
mkdir -p pp/working
mv pp/REQ-XXX-slug.md pp/working/
```

2. **Update frontmatter:**
```yaml
---
status: claimed
claimed_at: 2026-03-17T10:30:00Z
---
```

3. **Create session lock:**
```bash
echo "Task: REQ-XXX | User: $USER | Started: $(date +%H:%M:%S)" > ".claude-team/sessions/$$.lock"
```

4. **Update STATE.md:**
```markdown
## Current Position

**Status:** working
**Working on:** REQ-XXX-slug
**Step:** claim
**Last activity:** [timestamp]
```

**DO NOT proceed until file is in working/.**

### Step 3: Load Codebase Context

**[Orchestrator action]**

If CLAUDE.md and .claude-team/CODEBASE_MAP.md exist, read them for context.
Match task requirements to specific files using UI Element Index.

### Step 4: Analyze — Needs Research?

**[Orchestrator action]**

Read the task content and determine if research is needed.

**Research triggers (if ANY match → needs research):**
- External APIs: `stripe`, `twilio`, `firebase`, `aws`, `sendgrid`
- Protocols: `oauth`, `jwt`, `websocket`, `graphql`, `grpc`
- Real-time: `real-time`, `realtime`, `live update`, `push notification`
- Payments: `payment`, `checkout`, `billing`, `subscription`
- New tech: unfamiliar libraries, SDKs, frameworks

**Skip research for:** Bug fixes, UI changes, config changes, simple CRUD, refactoring

**Append to request file:**
```markdown
## Analysis

**Needs Research:** Yes/No
**Reason:** [Brief explanation]
**Detected triggers:** [list any matching patterns]
```

### Step 5: Research (If Needed)

**[Spawn agents for research]**

**If `needs_research: false`:** Skip to Step 6.

**If `needs_research: true`:**

1. Create research file at `pp/research/REQ-XXX-RESEARCH.md`:
```markdown
# Research: REQ-XXX [Title]

**Generated:** [timestamp]
**Topic:** [technology]

## Recommended Stack
| Component | Choice | Version | Reason |
|-----------|--------|---------|--------|

## Implementation Patterns
[Code examples]

## Common Pitfalls
| Pitfall | Prevention |
|---------|------------|

## References
- [sources]
```

2. Update STATE.md: `Step: researched`

### Step 6: Explore Codebase

**[Spawn Explore agent]**

```
Task(prompt="
For this request:

## Request
[Full content of request file]

## Codebase Context
[Key info from CLAUDE.md / CODEBASE_MAP.md]

## Research (if exists)
[Summary from RESEARCH.md]

Find the relevant files and patterns:
1. Where should this change be made?
2. What existing patterns should we follow?
3. Related types/interfaces
4. Testing patterns

Return specific file paths and code patterns.
", subagent_type="Explore")
```

**Append exploration output to request file.**
Update STATE.md: `Step: explored`

### Step 7: Load Plan from Capture Phase

**[Orchestrator action]**

Load the existing plan:
```bash
cat pp/plans/REQ-XXX-plan.md
```

Append plan summary to request file.

**If plan file missing (old REQ without plan):** Enter plan mode now, create the plan.

### Step 8: Implement the Feature

**[Spawn general-purpose agent]**

```
Task(prompt="
Implement this feature:

## Request
[Full content of request file]

## Research Context (if exists)
[From RESEARCH.md]

## Codebase Context
[From Explore agent + CODEBASE_MAP.md]

## Implementation Plan
[From plan file]

## Instructions
- Follow the plan and patterns
- Focus on 'Done When' criteria
- Make minimal, focused changes
- Follow existing code patterns from this codebase

When complete, provide a summary of files changed.
", subagent_type="general-purpose")
```

**After implementation:**
- Capture summary of changes
- Update STATE.md: `Step: implemented`
- Append `## Implementation Summary` to request file

### Step 9: Generate Playwright Tests

**[Orchestrator action — do this yourself]**

**SKIP this step if Playwright testing disabled.**

```bash
mkdir -p tests/pp tests/pp/screenshots
```

Read test config:
```bash
cat pp/config/test-env.json
```

**Create test file** at `tests/pp/REQ-XXX-slug.spec.js`:

```javascript
const { test, expect } = require('@playwright/test');
const path = require('path');

const config = {
  loginUrl: '[from test-env.json]',
  username: '[from test-env.json]',
  password: '[from test-env.json]',
  baseUrl: '[from test-env.json]',
  testUrl: '[from REQ frontmatter or determine from feature]'
};

const screenshotDir = path.join(__dirname, 'screenshots', 'REQ-XXX');

test.describe('REQ-XXX: [Title]', () => {

  test.beforeEach(async ({ page }) => {
    // Login
    await page.goto(config.loginUrl);
    await page.locator('[name="username"], [name="email"], #username, #email').first().fill(config.username);
    await page.locator('[name="password"], #password').first().fill(config.password);
    await page.locator('button[type="submit"], input[type="submit"]').first().click();
    await page.waitForURL(url => !url.pathname.includes('login'), { timeout: 10000 });

    // Navigate to test page
    await page.goto(config.testUrl);
    await page.waitForLoadState('domcontentloaded');
  });

  // FUNCTIONALITY TESTS — one per "Done When" criterion + edge cases
  test('functionality: [criterion 1]', async ({ page }) => {
    // assertion
    await page.screenshot({ path: path.join(screenshotDir, 'func-criterion1.png'), fullPage: true });
  });

  // Edge case tests
  test('functionality: [edge case - empty input]', async ({ page }) => {
    await page.screenshot({ path: path.join(screenshotDir, 'func-edge-empty.png'), fullPage: true });
  });

  // UI SCREENSHOT TESTS
  test('ui: initial render - full page', async ({ page }) => {
    await page.screenshot({ path: path.join(screenshotDir, 'ui-initial-fullpage.png'), fullPage: true });
  });

  test('ui: feature element', async ({ page }) => {
    const element = page.locator('[selector-for-feature]');
    await element.screenshot({ path: path.join(screenshotDir, 'ui-feature-element.png') });
  });

  test('ui: responsive - mobile', async ({ page }) => {
    await page.setViewportSize({ width: 375, height: 812 });
    await page.screenshot({ path: path.join(screenshotDir, 'ui-mobile.png'), fullPage: true });
  });

  test('ui: responsive - tablet', async ({ page }) => {
    await page.setViewportSize({ width: 768, height: 1024 });
    await page.screenshot({ path: path.join(screenshotDir, 'ui-tablet.png'), fullPage: true });
  });

});
```

Update STATE.md: `Step: tests_generated`

### Step 10: Run Test Loop — ZERO TOLERANCE

**[Orchestrator action]**

**SKIP if Playwright testing disabled.**

```
test_attempts = {}
max_attempts = 10

WHILE non-passed tests remain:

  1. Run: npx playwright test tests/pp/REQ-XXX-*.spec.js --reporter=list

  2. IF all pass → Proceed to Step 10b (screenshot review)

  3. FOR each failed test:
     - Infrastructure error (403, 401, CORS, connection refused, SSL)
       → SKIP immediately (server-side issue)
     - Playwright crash (browser closed, target closed)
       → Fix test setup, retry
     - Code error (500, assertion failed, element not found)
       → MUST FIX, increment attempt counter
       → If attempts >= 10 → SKIP as "needs manual investigation"
       → If stuck after 5 attempts → try completely different approach

  4. RERUN all non-skipped tests
```

Update STATE.md after each iteration.

### Step 10b: Screenshot Review — ZERO TOLERANCE UI CHECK

**After all functionality tests pass, review EVERY screenshot for UI issues.**

1. Read each screenshot using Read tool (which can read images)

2. For EACH screenshot, check for:
   - **Layout:** Alignment, spacing, overlapping, margins
   - **Visual:** Text readability, colors, cut-off elements, icons
   - **Responsive:** Content overflow, touch targets, text size, layout adaptation
   - **Interactive:** Hover states, active states, focus indicators

3. If ANY UI issue found:
   - Fix the code
   - Re-run affected tests
   - Re-review screenshots
   - Repeat until PERFECT

### Step 11: Generate Verification Report

**[Orchestrator action]**

**SKIP if Playwright testing disabled.**

Create `pp/working/REQ-XXX-VERIFICATION.md`:
```markdown
# Verification Report: REQ-XXX [Title]

**Status:** [PASS | PARTIAL | FAIL]
**Date:** [timestamp]
**Test File:** tests/pp/REQ-XXX-slug.spec.js
**Screenshots:** tests/pp/screenshots/REQ-XXX/

## Functionality Test Results
| Test | Status | Attempts | Notes |
|------|--------|----------|-------|

## UI Screenshot Review Results
| Screenshot | Status | Issues Found | Issues Fixed |
|------------|--------|-------------|-------------|

## Summary
- Functionality: X/Y passed
- UI Screenshots: X/Y clean
- Skipped: Z tests (infrastructure)
- Auto-fixed: N issues
```

### Step 12: Archive

**[Orchestrator action]**

1. Update request frontmatter:
```yaml
---
status: completed
completed_at: 2026-03-17T11:00:00Z
tests_passed: X
tests_skipped: Y
tests_total: Z
---
```

2. Move files to archive:
```bash
mkdir -p pp/archive
mv pp/working/REQ-XXX-*.md pp/archive/
```

3. Update STATE.md:
```markdown
## Current Position

**Status:** idle
**Working on:** None

## Recent Completions

| REQ | Title | Tests | Result | Commit | Date |
|-----|-------|-------|--------|--------|------|
| REQ-XXX | [title] | X/Y | pass | [hash] | [date] |
```

### Step 13: Commit (If Enabled)

**[Orchestrator action]**

**Only if auto-commit = Yes:**

```bash
git add -A
git commit -m "$(cat <<'EOF'
[REQ-XXX] Title

Implements: pp/archive/REQ-XXX-slug.md
Tests: tests/pp/REQ-XXX-slug.spec.js

- [implementation summary bullets]
- Tests: X/Y passed, Z skipped

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 14: Log and Clean Up

**[Orchestrator action]**

1. Log to team history:
```bash
echo '{"date":"'$(date +%Y-%m-%d)'","member":"'$USER'","task":"[title]","type":"[type]","req":"REQ-XXX","files":["file1","file2"],"tests":"X/Y","commit":"[hash]"}' >> .claude-team/history/tasks.jsonl
```

2. Remove session lock:
```bash
rm -f ".claude-team/sessions/$$.lock"
```

### Step 15: Loop or Exit

```bash
ls pp/REQ-*.md 2>/dev/null
```

- More REQs → Start Step 1 again
- Empty → Report final summary and exit

---

## Orchestrator Checklist (per request)

```
□ Pre-flight: Create all folders
□ Pre-flight: Check session locks
□ Pre-flight: Check test-env.json (if Playwright enabled)
□ Step 1: ls pp/REQ-*.md, pick first one
□ Step 2: mv REQ to pp/working/, create session lock
□ Step 3: Load codebase context (CLAUDE.md, CODEBASE_MAP.md)
□ Step 4: Analyze for research needs, append ## Analysis
□ Step 5: (if needed) Create RESEARCH.md
□ Step 6: Spawn Explore agent, append ## Exploration
□ Step 7: Load plan from pp/plans/REQ-XXX-plan.md
□ Step 8: Spawn implementation agent, append ## Implementation Summary
□ Step 9: (if Playwright) Create tests/pp/REQ-XXX.spec.js
□ Step 10: (if Playwright) Run test loop — ZERO TOLERANCE
□ Step 10b: (if Playwright) Screenshot review — fix ALL UI issues
□ Step 11: (if Playwright) Create VERIFICATION.md
□ Step 12: Update frontmatter: status: completed, mv to archive
□ Step 13: (if auto-commit) git commit
□ Step 14: Log to tasks.jsonl, remove session lock
□ Step 15: Loop or exit
```

---

## Progress Reporting

```
Processing REQ-013-logout-button.md...
  Claiming...              [done] → moved to working/
  Loading context...       [done] → CODEBASE_MAP.md loaded
  Analyzing...             [done] → no research needed
  Exploring...             [done] → found patterns
  Loading plan...          [done] → pp/plans/REQ-013-plan.md
  Implementing...          [done] → 2 files changed
  Generating tests...      [done] → 6 functionality + 5 UI tests
  Running functionality...
    pass func: logout button exists (1/1)
    pass func: logout redirects (3/3) — fixed: redirect path
    pass func: session cleared (2/2) — fixed: cookie clearing
  Screenshot review...
    pass ui-initial-fullpage.png — clean
    pass ui-feature-element.png — fixed: button padding
    pass ui-mobile.png — clean
  Verification...          [done]
  Archiving...             [done]
  Committing...            [done] → abc1234
  Logging...               [done] → tasks.jsonl

All tests passed. 1 UI issue found and fixed.

Checking for more requests...
Queue empty. Done!
```

---

## Checkpoints (Session Mode Dependent)

**Normal mode:** Pause at decision points, ask user
**Overnight mode:** Auto-select recommended option, log decision

Checkpoint triggers:
- Multiple valid approaches (use research recommendation)
- Destructive actions (SKIP in overnight mode)
- External side effects (SKIP in overnight mode)

Log all decisions to STATE.md.
