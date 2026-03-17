# Init Action — Deep Codebase Analysis

> **Part of the SC skill.** Analyzes the entire codebase and creates comprehensive documentation for intelligent task execution.

## Pre-Checks

1. Check if already initialized:
```bash
cat .claude-team/initialized 2>/dev/null
```
If exists, warn and exit.

2. Create folder structure:
```bash
mkdir -p .claude-team/{sessions,history}
```

---

## Step 1: Count Files

Scan the project to understand its scope:

```bash
# Count by type (exclude node_modules, vendor, .git)
find . -name "*.php" -type f ! -path "*/node_modules/*" ! -path "*/vendor/*" ! -path "*/.git/*" | wc -l
find . -name "*.js" -type f ! -path "*/node_modules/*" ! -path "*/vendor/*" ! -path "*/.git/*" | wc -l
find . \( -name "*.html" -o -name "*.htm" \) -type f ! -path "*/node_modules/*" | wc -l
find . -name "*.css" -type f ! -path "*/node_modules/*" ! -path "*/vendor/*" | wc -l
find . -name "*.sql" -type f | wc -l
find . -name "*.py" -type f ! -path "*/node_modules/*" ! -path "*/vendor/*" | wc -l
find . -name "*.ts" -type f ! -path "*/node_modules/*" | wc -l
```

Report counts to user.

---

## Step 2: Deep Analysis

Use Glob and Read tools to explore the ENTIRE codebase thoroughly. Don't rush this.

### What to Explore:
- Directory structure and purpose of each folder
- Entry points (index.php, app.js, main.py, etc.)
- Config files (database, environment, framework)
- Authentication/authorization files
- API routes and endpoints
- Database models/schemas/migrations
- Frontend structure (JS, CSS, templates)
- Key libraries and dependencies
- Common patterns (how DB queries work, AJAX patterns, form handling)

---

## Step 3: Create CLAUDE.md

Create `CLAUDE.md` in the project root with:

```markdown
## Project Overview
- What does this application do?
- What is the main purpose?
- Tech stack summary

## Architecture
- Directory structure with PURPOSE of each folder
- How requests flow through the app
- MVC pattern? Custom structure?

## Database
- Tables found (from SQL files, config, or model files)
- Key relationships
- Connection details location

## Key Files (CRITICAL - read these before any task)
List the most important files with their purpose:
- Entry points
- Config files
- Core libraries
- Authentication

## API Endpoints
List all endpoints found with their purpose

## Frontend Structure
- Main JS files and what they do
- CSS organization
- Common patterns used (jQuery, React, Vue, etc.)

## UI Component Map (CRITICAL for UI tasks)
Map ALL user-facing elements to their source files:

### Pages/Views
List each page with its file(s):
- [Page Name]: [file.php] - [brief description]

### Forms and Fields
For EACH form in the app:
- Form: [form name/purpose]
  - File: [path]
  - Fields: [field1], [field2], [field3]...
  - Submit handler: [function/endpoint]

### Tables/Grids
For EACH data table:
- Table: [table name/purpose]
  - File: [path]
  - Columns: [col1], [col2], [col3]...
  - Data source: [API endpoint or query]

### Buttons and Actions
Key action buttons with their handlers:
- [Button label]: [file:function] - [what it does]

### Modals/Dialogs
- [Modal name]: [file] - [trigger and purpose]

### Navigation
- Menu structure and which files render each section

## Code Patterns In This Codebase
Show ACTUAL patterns from this codebase:
- How DB queries are done here
- How AJAX calls are structured here
- How forms are handled here
- How authentication works here

## Common Components
- Reusable functions/classes
- Shared includes
- Helper utilities

## Gotchas and Issues
- Deprecated code patterns found
- Security concerns noticed
- Inconsistencies to be aware of

## Recent Activity
(Leave empty - updated by tasks)
```

---

## Step 4: Create CODEBASE_MAP.md

Create `.claude-team/CODEBASE_MAP.md` with:

```markdown
## File Index
List ALL files with one-line descriptions

## Function/Class Index
Key functions and classes with locations

## UI Element Index (CRITICAL - enables finding UI by name)

### Field Name to File Map
| Field/Element Name | File Path | Form/Context |
|---|---|---|
| search | users.php:45 | User list filter |
| email | profile.php:23 | Profile form |

### Page/View Index
| Page Name | Primary File | Related Files |
|---|---|---|
| Users | users.php | js/users.js, css/users.css |
| Dashboard | index.php | js/dashboard.js |

### Component to File Map
| Component | Type | File Path |
|---|---|---|
| User Table | table | users.php:100-150 |
| Login Form | form | login.php:20-80 |

## Database Schema
Full table structures if discoverable

## Dependencies
External libraries, includes

## Non-UI Components (if applicable)
- Service classes and methods
- API route handlers
- Background jobs/workers
- CLI commands
```

---

## Step 5: Create SYSTEM_PROMPT.md

Create `.claude-team/SYSTEM_PROMPT.md` with:

```markdown
# SIEVATEAM-CLAUDE INSTRUCTIONS

When given a task:

1. READ FIRST (silently):
   - CLAUDE.md (project knowledge)
   - .claude-team/CODEBASE_MAP.md (technical details)
   - .claude-team/history/tasks.jsonl (past tasks)

2. MATCH vague terms to specific UI elements:
   - "the search" → look up "search" in Field Name to File Map
   - "users page" → look up "Users" in Page/View Index
   - "the table" → identify from Component to File Map
   - "that button" → find in Buttons and Actions section

3. GENERATE EXECUTION PLAN:
   **Task:** [Title]
   **Type:** [CRUD/BUG_FIX/UI_FEATURE/API/REFACTOR/SECURITY]
   **UI Elements:** [from CODEBASE_MAP lookups]
   **Files:** [list]
   **Steps:**
   1. [step]
   2. [step]

   Execute? (yes/no)

4. WAIT for YES before making any changes

5. EXECUTE step by step with progress updates

6. LOG to .claude-team/history/tasks.jsonl when done
```

---

## Step 6: Finalize

```bash
date > .claude-team/initialized
```

Create initial history entry:
```bash
echo '{"date":"'$(date +%Y-%m-%d)'","member":"system","task":"Deep codebase analysis","type":"SETUP","files":["CLAUDE.md","CODEBASE_MAP.md"]}' >> .claude-team/history/tasks.jsonl
```

Report completion:
```
Codebase analyzed!

Stats: [X] PHP, [Y] JS, [Z] HTML, [W] CSS files

Created:
  CLAUDE.md                       — Project knowledge base + UI Component Map
  .claude-team/CODEBASE_MAP.md   — Technical file/UI element index
  .claude-team/SYSTEM_PROMPT.md  — Task workflow rules

Claude now knows your entire codebase!

Next: /sc:add <task> to capture a task
```
