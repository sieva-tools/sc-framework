#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO="amruthasolutions/sc-framework"
SKILL_DIR="$HOME/.claude/skills/sc"
COMMANDS_DIR="$HOME/.claude/commands"

echo ""
echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}   SC (SievaTeam-Claude) — Installing${NC}"
echo -e "${BLUE}================================================================${NC}"
echo ""

# Check git
command -v git >/dev/null 2>&1 || { echo -e "${RED}git required${NC}"; exit 1; }

# Clone or update
if [ -d "$SKILL_DIR/.git" ]; then
    echo "Updating existing installation..."
    cd "$SKILL_DIR" && git pull origin main
else
    echo "Installing..."
    mkdir -p "$(dirname "$SKILL_DIR")"
    git clone "https://github.com/$REPO.git" "$SKILL_DIR"
fi

# Create commands dir and symlink
mkdir -p "$COMMANDS_DIR"
ln -sf "$SKILL_DIR/commands" "$COMMANDS_DIR/sc"

echo ""
echo -e "${GREEN}================================================================${NC}"
echo -e "${GREEN}   SC installed! (v$(cat "$SKILL_DIR/VERSION"))${NC}"
echo -e "${GREEN}================================================================${NC}"
echo ""
echo "Restart Claude Code, then use:"
echo "  /sc:init    — Analyze your codebase"
echo "  /sc:add     — Capture a task"
echo "  /sc:work    — Process task queue"
echo "  /sc:help    — See all commands"
echo ""
