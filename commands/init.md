---
name: sc:init
description: Deep codebase analysis — creates CLAUDE.md, CODEBASE_MAP.md, and team structure
---

<objective>
Perform a deep analysis of the current project codebase. Create comprehensive documentation (CLAUDE.md, CODEBASE_MAP.md) that enables intelligent task execution. Run ONCE per project.
</objective>

<enforcement>
## SESSION SETUP CHECK

**If this is the FIRST /sc command in a new session, you MUST ask the 4 session setup questions BEFORE running init.**
See SKILL.md for the 4 questions.

## ALREADY INITIALIZED CHECK

Check if `.claude-team/initialized` exists. If yes, warn:
```
Already initialized. To re-analyze: rm -rf .claude-team && rm CLAUDE.md
Then run /sc:init again.
```
</enforcement>

<process>

<step name="setup">
## Step 1: Create Folder Structure

```bash
mkdir -p .claude-team/{sessions,history}
```
</step>

<step name="analyze">
## Step 2: Analyze Codebase

**READ [init action](./actions/init.md) FIRST** — it contains the full analysis instructions.

The init action will:
1. Count all files by type
2. Explore the entire codebase thoroughly
3. Create CLAUDE.md with project knowledge base + UI Component Map
4. Create .claude-team/CODEBASE_MAP.md with detailed file/function/UI index
5. Create .claude-team/SYSTEM_PROMPT.md with task workflow rules
6. Mark as initialized
</step>

<step name="finalize">
## Step 3: Finalize

```bash
date > .claude-team/initialized
echo '{"date":"'$(date +%Y-%m-%d)'","member":"system","task":"Deep codebase analysis","type":"SETUP","files":["CLAUDE.md","CODEBASE_MAP.md"]}' >> .claude-team/history/tasks.jsonl
```

Report:
```
Codebase analyzed!

Created:
  CLAUDE.md                       — Project knowledge base
  .claude-team/CODEBASE_MAP.md   — Technical file/UI map
  .claude-team/SYSTEM_PROMPT.md  — Task workflow rules

Next: /sc:add <task> to capture a task
```
</step>

</process>
