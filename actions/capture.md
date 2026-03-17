# Capture Action

> **Part of the SC skill.** Captures tasks with collaborative questioning, prompt rephrasing, and codebase-aware planning. Understand intent before creating requests.

## CRITICAL: Capture Does NOT Implement

**This action ONLY captures tasks. It does NOT implement them.**

**NEVER do any of the following during capture:**
- Write code
- Create project files (except pp/ files)
- Install dependencies
- Run commands (except mkdir for pp/ folder)
- Start building features

**ONLY do these during capture:**
- Load codebase context (CLAUDE.md, CODEBASE_MAP.md)
- Rephrase the user's prompt (using an agent)
- Ask clarifying questions
- Match vague terms to UI Element Index
- Enter plan mode and create a plan
- Create `pp/REQ-*.md` files
- Create `pp/rephrased/` and `pp/plans/` files
- Create `pp/user-requests/UR-*/` folders
- Set up test config (if first time)
- Update `pp/STATE.md`

**After capture is complete, tell the user:**
```
Captured: [task summary]

Ready to implement? Run `/sc work`
```

**DO NOT automatically start implementation. Wait for `/sc work`.**

---

## MANDATORY CAPTURE CHECKLIST

**Before capturing ANY task, complete this checklist in order:**

- [ ] **Step 0:** Load codebase context (CLAUDE.md + CODEBASE_MAP.md)
- [ ] **Step 0b:** If Playwright testing enabled AND `pp/config/test-env.json` doesn't exist → Ask for test credentials FIRST
- [ ] **Step 1:** Rephrase the user's prompt into an optimized, detailed prompt using an agent
- [ ] **Step 2:** Show rephrased prompt to user and save to `pp/rephrased/`
- [ ] **Step 3:** Ask clarifying questions (ALWAYS — both Normal and Overnight modes)
- [ ] **Step 4:** Check for existing similar requests
- [ ] **Step 5:** Assess complexity (simple vs complex)
- [ ] **Step 6:** Enter plan mode — create a detailed plan for the task
- [ ] **Step 7:** Save plan to `pp/plans/` and show to user
- [ ] **Step 8:** Create REQ file(s) with rephrased prompt + plan references, update STATE.md

**DO NOT SKIP any step.** Every step is mandatory for every task.

---

## IMPORTANT: ALWAYS Ask Questions — Both Modes

**Clarifying questions are MANDATORY in BOTH Normal and Overnight modes.**

During capture, **ALWAYS ask clarifying questions** regardless of session mode, unless:
- User explicitly says "just capture it" or "figure it out"

Even detailed/long requests (500+ words) still need questions about:
- Success criteria: "How will you know it's working?"
- Priority: "Which part matters most?"
- Scope boundaries: "Should this include X or just Y?"

**Overnight mode only affects the WORK phase.** Capture behavior is identical in both modes.

---

## Test Environment (Once Per Session)

**If user selected "No" for Playwright testing:** Skip this section entirely.

**If Playwright testing is enabled**, check if `pp/config/test-env.json` exists:

```bash
cat pp/config/test-env.json 2>/dev/null
```

### If Config EXISTS → Use It

Proceed to capture. Optionally mention: "Using saved test environment."

### If Config DOESN'T EXIST → Ask Once

```
[AskUserQuestion]
header: "Test Config"
question: "I need test environment details for automated testing. Do you have a .env file with credentials?"
options:
- "Yes, I have .env" — I'll provide the path
- "No .env file" — I'll provide credentials directly
- "No login yet" — Skip for now
```

**If user has .env:** Read it, extract login URL, username, password, base URL.
**If manual:** Ask for each credential.
**If no login yet:** Create placeholder config, note in REQ file.

**Create config file:**
```bash
mkdir -p pp/config
```

Write `pp/config/test-env.json`:
```json
{
  "loginUrl": "https://example.com/login",
  "username": "test_user",
  "password": "***",
  "baseUrl": "https://example.com",
  "createdAt": "2026-03-17T10:00:00Z"
}
```

**Add to .gitignore:**
```bash
echo "pp/config/test-env.json" >> .gitignore
```

---

## Workflow

### Step 0: Load Codebase Context

**Before anything else, check if codebase has been analyzed:**

```bash
cat CLAUDE.md 2>/dev/null | head -5
cat .claude-team/CODEBASE_MAP.md 2>/dev/null | head -5
```

If both exist:
- Read CLAUDE.md — especially the UI Component Map section
- Read .claude-team/CODEBASE_MAP.md — especially the UI Element Index
- Use the Field Name to File Map to find exact file locations
- Use the Page/View Index to identify which page user refers to
- Use the Component to File Map to find tables, forms, buttons

**Match user's vague terms to specific UI elements:**
- "the search" → look up "search" in Field Name to File Map
- "users page" → look up "Users" in Page/View Index
- "the table" → identify which table from Component to File Map
- "that button" → find in Buttons and Actions section

If not initialized, proceed without context and note: "Run `/sc:init` for better results."

---

### Step 1: Rephrase the Prompt (MANDATORY)

1. **Create rephrased folder:**
```bash
mkdir -p pp/rephrased
```

2. **Spawn a general-purpose agent** to rephrase:

```
Agent(prompt="
You are an expert prompt engineer. Take this raw task description and rephrase it into the BEST possible prompt for a coding assistant.

## Raw User Prompt:
[paste user's exact input here]

## Codebase Context (if available):
[relevant info from CLAUDE.md / CODEBASE_MAP.md]

## Your Task:
Rephrase into a detailed, actionable prompt that:
- Clearly states the objective
- Breaks down requirements into specific, concrete items
- Specifies expected behavior and edge cases
- Includes success criteria
- Mentions quality standards (accessibility, responsiveness, error handling)
- References specific files/components if codebase context available

## Rules:
- Do NOT add fictional requirements — only expand and clarify what the user intended
- Do NOT change the user's intent
- Keep the scope the same
- Return ONLY the rephrased prompt
", subagent_type="general-purpose")
```

3. **Save the rephrased prompt** to `pp/rephrased/REQ-XXX-rephrased.md`:

```markdown
---
id: REQ-XXX
original_prompt: "[user's raw input]"
rephrased_at: [timestamp]
---

# Rephrased Prompt: [Brief Title]

[Rephrased prompt from agent]

---
*Original: "[user's raw input]"*
*Rephrased by prompt engineering agent*
```

4. **Show the rephrased prompt to the user.**

---

### Step 2: Read and Understand

Read the rephrased prompt. Before doing anything:
- What are they trying to accomplish?
- Is it clear enough to capture?
- What's still ambiguous even after rephrasing?

**Quick mental checklist:**
- [ ] What they want (concrete enough to explain to a stranger)
- [ ] Why it matters (the problem or desire driving it)
- [ ] What done looks like (observable outcome)

---

### Step 3: Question (ALWAYS — Both Modes)

**ALWAYS ask clarifying questions regardless of session mode.**

1. Pick the most important gap
2. Ask ONE focused question using AskUserQuestion
3. Build on their answer
4. Repeat until clear (usually 1-3 questions max)

**Follow the energy:** Whatever they emphasized, dig into that.
**Know when to stop:** When you understand what, why, and done looks like — proceed.

#### Question Types (pick what's relevant):

**Motivation:** "What prompted this?" / "What problem are you solving?"
**Concreteness:** "Walk me through using this" / "Give me an example"
**Clarification:** "When you say Z, do you mean A or B?"
**Success:** "How will you know this is working?" / "What does done look like?"

#### Anti-Patterns (What NOT to Do):
- Checklist walking — going through question types regardless of context
- Interrogation — firing questions without building on answers
- Over-questioning — asking 10 questions for a simple task
- Technical probing — asking about implementation (that's for the builder)

---

### Step 4: Check for Existing Requests

Check for duplicates:
```bash
ls pp/REQ-*.md pp/working/REQ-*.md pp/archive/REQ-*.md 2>/dev/null
```

| Location | Action |
|----------|--------|
| Queue | Ask: update existing or create new? |
| Working | Create addendum REQ |
| Archive | Create new REQ |

---

### Step 5: Assess Complexity

**Simple** (1-2 features, <200 words, clear scope): Quick capture, lean format.
**Complex** (3+ features, >500 words, detailed): Full UR folder, multiple REQs.

---

### Step 6: Plan the Task

**Skip for simple tasks** (single-line fixes, typo fixes, color changes).
**Enter plan mode for medium and complex tasks.**

1. Create plans folder:
```bash
mkdir -p pp/plans
```

2. Enter plan mode using EnterPlanMode. In plan mode:
   - Explore the codebase thoroughly
   - Understand existing patterns
   - Design the implementation approach
   - Identify files to create/modify
   - Consider edge cases

3. Save the plan to `pp/plans/REQ-XXX-plan.md`:

```markdown
---
id: REQ-XXX
title: [Brief Title]
planned_at: [timestamp]
files_to_modify: [list]
estimated_complexity: simple | moderate | complex
---

# Implementation Plan: [Title]

## Objective
[What this plan achieves]

## Codebase Analysis
[Key findings from exploring]

## Implementation Steps
1. [Step 1 — specific file + what to change]
2. [Step 2 — specific file + what to change]

## Files to Create/Modify
| File | Action | Description |
|------|--------|-------------|

## Edge Cases & Considerations

## Testing Strategy
```

4. **Check plan verification preference:**
   - "Verify with me" → Show plan, ask for approval
   - "Continue directly" → Show plan, proceed

---

### Step 7: Create Request Files

**Create folder structure:**
```bash
mkdir -p pp pp/user-requests
```

**Determine next REQ number:**
```bash
ls pp/REQ-*.md pp/working/REQ-*.md pp/archive/REQ-*.md 2>/dev/null | wc -l
```
Next number = count + 1.

**Create slug** from title (lowercase, hyphens, max 40 chars).

**Simple Request Format:**
```markdown
---
id: REQ-001
title: Brief descriptive title
status: pending
created_at: 2026-03-17T10:00:00Z
user_request: UR-001
rephrased_prompt: pp/rephrased/REQ-001-rephrased.md
plan: pp/plans/REQ-001-plan.md
test_url: https://example.com/dashboard
---

# [Brief Title]

## What
[1-3 sentences from rephrased prompt]

## Why
[The problem this solves — from questioning]

## Done When
[Observable outcome — these become Playwright test assertions]

## Context
[Additional context, constraints, details]

## UI Elements Identified
[From CODEBASE_MAP.md lookups]
- [Element name] in [file:line]

## Rephrased Prompt
See [pp/rephrased/REQ-001-rephrased.md]

## Implementation Plan
See [pp/plans/REQ-001-plan.md]

---
*Captured after [N] clarifying questions*
```

**Complex Request Format** (same + Detailed Requirements, Constraints, Dependencies, Open Questions sections, plus multiple REQ files with cross-references).

---

### Step 8: Update STATE.md and Report

Update `pp/STATE.md`:
```markdown
## Current Position

**Status:** idle
**Last captured:** REQ-XXX-slug
**Last activity:** [timestamp]

## Queue
- REQ-XXX: [title] (pending)
```

Report:
```
Captured: [task summary]

- UI Elements: [matched from codebase]
- Rephrased: pp/rephrased/REQ-XXX-rephrased.md
- Plan: pp/plans/REQ-XXX-plan.md
- Created: REQ-XXX-slug.md

Ready to implement? Run `/sc work`
```

**DO NOT automatically start implementation.**
