# Update Action — Codebase Memory Refresh

> **Part of the SC skill.** Incrementally updates CLAUDE.md and CODEBASE_MAP.md after significant codebase changes.

## Pre-Check

```bash
cat .claude-team/initialized 2>/dev/null || echo "NOT_INITIALIZED"
```

If not initialized: "Not initialized. Run `/sc:map` first."

---

## Step 1: Read Existing Documentation

```bash
cat CLAUDE.md
cat .claude-team/CODEBASE_MAP.md
```

Understand what's already documented.

---

## Step 2: Scan for Changes

Use Glob to find new or modified files:

```
Glob("**/*.php")
Glob("**/*.js")
Glob("**/*.html")
Glob("**/*.css")
Glob("**/*.py")
Glob("**/*.ts")
```

Compare against what's documented in CODEBASE_MAP.md's File Index.

Look for:
- **New files** not in the index
- **Deleted files** still in the index
- **New patterns** (new API endpoints, new forms, new tables)
- **Changed structure** (moved files, renamed modules)

---

## Step 3: Read New/Changed Files

For each new or significantly changed file:
- Read the file
- Understand its purpose
- Identify new UI elements, API endpoints, database tables, etc.

---

## Step 4: Update Documentation

### Update CLAUDE.md:
- Add new files to relevant sections
- Add new API endpoints
- Add new UI elements to Component Map
- Update patterns if they've changed
- Remove references to deleted files
- **Keep existing accurate information unchanged**

### Update .claude-team/CODEBASE_MAP.md:
- Add new files to File Index
- Add new functions/classes to Function Index
- Add new UI elements to UI Element Index
- Update Field Name to File Map
- Update Page/View Index
- Update Component to File Map
- Remove entries for deleted files

**DO NOT rewrite everything — only ADD/UPDATE what changed.**

---

## Step 5: Log and Report

```bash
echo "$(date '+%Y-%m-%d %H:%M:%S') - Memory updated" >> .claude-team/update_log.txt
```

Log to team history:
```bash
echo '{"date":"'$(date +%Y-%m-%d)'","member":"'$USER'","task":"Codebase memory refresh","type":"UPDATE","files":["CLAUDE.md","CODEBASE_MAP.md"]}' >> .claude-team/history/tasks.jsonl
```

Report:
```
Memory updated!

Changes:
  Added: [N] new files to index
  Updated: [N] existing entries
  Removed: [N] deleted file references
  New endpoints: [list if any]
  New UI elements: [list if any]

Documentation is current.
```
