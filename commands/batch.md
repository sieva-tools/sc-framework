---
name: sc:batch
description: PRD mode — enter multiple tasks with dependency planning and sequential execution
---

<objective>
Product Requirements Document mode. Capture multiple tasks, analyze dependencies, create priority-ordered execution plan, then process sequentially after approval.
</objective>

<enforcement>
## SESSION SETUP CHECK

**If this is the FIRST /sc command in a new session, you MUST ask the 4 session setup questions FIRST.**

**READ the full action file BEFORE doing anything:**
```bash
cat ~/.claude/skills/sc/actions/batch.md
```
</enforcement>

<process>

<step name="gather">
## Phase 1: Gather Requirements

Ask user to list their tasks. Use AskUserQuestion for each task or accept numbered list:
```
1. Add user authentication
2. Create dashboard page
3. Add export feature
```

For each task:
- Rephrase with agent
- Ask 1-2 clarifying questions
- Create REQ files
</step>

<step name="prd">
## Phase 2: Create PRD

For each requirement:
- Description, acceptance criteria, files affected, technical notes

Create dependency analysis:
```
| # | Task | Priority | Depends On | Status |
|---|------|----------|------------|--------|
| 1 | Auth | HIGH | None | PENDING |
| 2 | Dashboard | MEDIUM | Task 1 | PENDING |
```
</step>

<step name="approve">
## Phase 3: Wait for Approval

Show PRD + execution plan table. Ask: "Execute plan? [yes/no]"
**WAIT for approval before making ANY changes.**
</step>

<step name="execute">
## Phase 4: Execute

Process each task in dependency order using the /sc:work workflow.
Show progress table after each completion.
Log all to `.claude-team/history/tasks.jsonl`.
</step>

</process>
