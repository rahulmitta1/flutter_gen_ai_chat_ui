#!/bin/bash

# Automatic Cursor Integration Setup
# Configures Cursor to work with the automatic context system

set -e

echo "🎯 Setting up Cursor integration..."

# Create Cursor directories
mkdir -p .cursor/rules .vscode

# Create memory bank integration file
cat > .cursor/rules/memory-bank.md << 'EOF'
# Cursor Memory Bank - Auto Context Integration

## System Instructions
- ALWAYS read `.memory/CURRENT_STATUS.md` at session start
- Reference `.memory/PROJECT_CONTEXT.md` for project overview
- Check `.memory/DECISIONS.md` for technical decisions
- Context is automatically maintained via git hooks

## Auto-Context Loading
The following files are automatically synchronized:
- Current work status and progress
- Project architecture and decisions  
- Recent development activity
- Next steps and priorities

## Development Guidelines
Follow patterns established in `.memory/DECISIONS.md`
Maintain consistency with existing project structure
Update significant decisions in the memory system

EOF

# Create Cursor workspace settings
cat > .vscode/settings.json << 'EOF'
{
  "cursor.memoryBank": {
    "enabled": true,
    "autoLoad": true
  },
  "editor.rulers": [80, 120],
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true
}
EOF

# Add Cursor setup to auto-sync script
if [ -f ".memory/auto-sync.sh" ] && ! grep -q "setup-cursor" .memory/auto-sync.sh; then
    # Add cursor integration to the auto-sync process
    cat >> .memory/auto-sync.sh << 'EOF'

# Auto-setup Cursor if not already configured
if [ ! -f ".cursor/rules/memory-bank.md" ] && [ -f ".memory/setup-cursor.sh" ]; then
    ./.memory/setup-cursor.sh >/dev/null 2>&1
fi
EOF
fi

echo "✅ Cursor integration configured"
echo "📝 Memory bank: .cursor/rules/memory-bank.md"  
echo "⚙️  Workspace settings: .vscode/settings.json"
echo ""
echo "Next time you open this project in Cursor, it will automatically:"
echo "  • Load context from .memory/ directory"
echo "  • Understand current project status"  
echo "  • Reference past technical decisions"
echo "  • Stay synchronized with Claude Code sessions"