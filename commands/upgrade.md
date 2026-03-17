---
name: sc:upgrade
description: Update the SC framework to the latest version
---

<objective>
Pull the latest SC framework from GitHub and report what changed.
</objective>

<process>

<step name="upgrade">
## Upgrade SC Framework

1. **Read current version:**
```bash
cat ~/.claude/skills/sc/VERSION
```

2. **Fetch and check for updates:**
```bash
cd ~/.claude/skills/sc && git fetch origin main 2>/dev/null && git rev-list HEAD..origin/main --count 2>/dev/null
```

3. **If count > 0 (updates available):**
```bash
cd ~/.claude/skills/sc && git pull origin main 2>/dev/null
```

Read new version:
```bash
cat ~/.claude/skills/sc/VERSION
```

Display:
```
sc updated! v[old] → v[new]
Restart your Claude Code session to get all changes.
```

4. **If count = 0 (already up to date):**
```
sc is already up to date (v[current]).
```

5. **If fetch fails (no internet or git error):**
```
Could not check for updates. Check your internet connection.
Manual update: cd ~/.claude/skills/sc && git pull origin main
```
</step>

</process>
