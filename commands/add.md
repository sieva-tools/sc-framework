---
name: sc:add
description: Capture a new task with smart questioning, prompt rephrasing, and planning
argument-hint: <task description>
---

<objective>
Capture a task with collaborative questioning — understand intent before creating requests. Rephrase the prompt for maximum clarity. Create implementation plan. Never write code.
</objective>

<enforcement>
## SESSION SETUP CHECK

**If this is the FIRST /sc command in a new session, you MUST ask the 4 session setup questions BEFORE capturing.**
See SKILL.md for the 4 questions.

## STRICT COMPLIANCE REQUIRED

**This action ONLY captures tasks. It does NOT implement them.**

**NEVER during capture:**
- Write code
- Create project files (except pp/ files)
- Install dependencies
- Start building features

**READ the full action file BEFORE doing anything:**
```bash
cat ~/.claude/skills/sc/actions/capture.md
```

**Follow the action file instructions step by step.**
</enforcement>

<process>

<step name="codebase_context">
## Step 0: Load Codebase Context

If CLAUDE.md and .claude-team/CODEBASE_MAP.md exist, read them first.
Use the UI Element Index to match vague terms to specific files/components.
</step>

<step name="rephrase">
## Step 1: Rephrase the Prompt

Spawn a general-purpose agent to rephrase the user's raw prompt into an optimized, detailed prompt.
Save to `pp/rephrased/REQ-XXX-rephrased.md`.
Show rephrased version to user.
</step>

<step name="question">
## Step 2: Ask Clarifying Questions

**ALWAYS ask questions — both Normal and Overnight modes.**
Unless user says "just capture it" or "figure it out".

Pick the most important gap, ask ONE focused question using AskUserQuestion.
Build on answers. Usually 1-3 questions max.
</step>

<step name="plan">
## Step 3: Plan the Task

Enter plan mode for medium/complex tasks. Create plan at `pp/plans/REQ-XXX-plan.md`.
Skip for simple single-line fixes.
</step>

<step name="create_req">
## Step 4: Create REQ File

Create `pp/REQ-XXX-slug.md` with:
- Frontmatter (id, title, status, references)
- What / Why / Done When sections
- Links to rephrased prompt and plan

Update `pp/STATE.md`.
</step>

<step name="report">
## Step 5: Report

```
Captured: [task summary]

- Rephrased: pp/rephrased/REQ-XXX-rephrased.md
- Plan: pp/plans/REQ-XXX-plan.md
- Created: REQ-XXX-slug.md

Ready to implement? Run /sc:work
```

**DO NOT automatically start implementation.**
</step>

</process>
