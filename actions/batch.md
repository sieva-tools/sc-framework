# Batch Action — PRD Mode

> **Part of the SC skill.** Product Requirements Document mode for multiple tasks with dependency analysis and sequential execution.

## Overview

Batch mode lets users enter multiple tasks at once. SC creates a PRD with dependency analysis, priority ordering, and executes them in the correct order after approval.

---

## Phase 1: Gather Requirements

### Option A: User Lists Tasks Directly

Ask the user to list their tasks:

```
[AskUserQuestion]
header: "Tasks"
question: "List your tasks. You can enter them one at a time or as a numbered list."
```

Accept numbered format:
```
1. Add user authentication
2. Create dashboard page
3. Add export feature
```

### Option B: Interactive Capture

For each task:
1. Rephrase with agent (same as /sc:add Step 1)
2. Ask 1-2 clarifying questions
3. Note dependencies mentioned

Continue until user says "done" or "that's all".

---

## Phase 2: Create PRD

For EACH requirement, document:

```markdown
# PRODUCT REQUIREMENTS DOCUMENT

## Requirement 1: [Title]
**Description:** [Clear technical description]
**Acceptance Criteria:**
  - [Criterion 1]
  - [Criterion 2]
**Files Affected:** [List — use CODEBASE_MAP.md if available]
**Technical Notes:** [Implementation details]
**UI Elements:** [From UI Element Index if available]

## Requirement 2: [Title]
...
```

---

## Phase 3: Dependency Analysis

Analyze dependencies between tasks and create execution plan:

```markdown
# EXECUTION PLAN

| # | Task | Priority | Depends On | Status |
|---|------|----------|------------|--------|
| 1 | [Task name] | HIGH | None | PENDING |
| 2 | [Task name] | MEDIUM | Task 1 | PENDING |
| 3 | [Task name] | LOW | Task 1, 2 | PENDING |
```

**Priority Rules:**
- HIGH: Core/foundational features, no dependencies
- MEDIUM: Features that depend on HIGH priority items
- LOW: Features that depend on other features

---

## Phase 4: Wait for Approval

Show the PRD and Execution Plan Table to the user.

```
[AskUserQuestion]
header: "Execute"
question: "Execute this plan?"
options:
- "Yes, execute all" — Process all tasks in dependency order
- "Yes, but let me reorder" — I want to change the order
- "No, let me modify" — I want to change some requirements
```

**WAIT for approval before making ANY changes.**

If user wants to reorder: Show the list, let them specify new order.
If user wants to modify: Let them edit requirements, regenerate plan.

---

## Phase 5: Create REQ Files

After approval, create REQ files for each task:

```bash
mkdir -p pp/$USER pp/$USER/rephrased pp/$USER/plans
```

For each task in the PRD:
1. Create `pp/REQ-XXX-slug.md` with full details
2. Create `pp/rephrased/REQ-XXX-rephrased.md`
3. Create `pp/plans/REQ-XXX-plan.md`
4. Include cross-references to related REQs

---

## Phase 6: Execute with Status

Process each task in dependency order using the `/sc:work` workflow.

After each task completion, show updated status table:

```
| # | Task | Status |
|---|------|--------|
| 1 | [Task name] | COMPLETED |
| 2 | [Task name] | IN PROGRESS |
| 3 | [Task name] | PENDING |
```

**Normal mode:** Pause between tasks, ask to continue.
**Overnight mode:** Auto-continue, log progress.

Log each completed task to `.claude-team/history/tasks.jsonl`.

---

## Final Report

After all tasks complete:

```
PRD Execution Complete!

| # | Task | Status | Tests | Commit |
|---|------|--------|-------|--------|
| 1 | [Task] | COMPLETED | 5/5 | abc1234 |
| 2 | [Task] | COMPLETED | 3/3 | def5678 |
| 3 | [Task] | COMPLETED | 4/4 | ghi9012 |

All [N] tasks completed successfully.
```
