# Cursor Integration Guide

## Automatic Cursor Memory Bank Setup

Add this to your Cursor settings to automatically integrate with the context system:

### 1. Create `.cursor/rules/memory-bank.md` in your projects:

```markdown
# Cursor Memory Bank - Auto Context Integration

## System Integration
- Always read `.memory/CURRENT_STATUS.md` at session start for current context
- Reference `.memory/PROJECT_CONTEXT.md` for complete project understanding  
- Check `.memory/DECISIONS.md` for past technical decisions
- Update progress automatically using git hooks

## Auto-Context Rules
- When opening a project, immediately read `.memory/CURRENT_STATUS.md`
- Before making significant changes, understand the context from `.memory/`
- After completing work, the git hooks will auto-update context
- Use the established patterns from `.memory/DECISIONS.md`

## Project Understanding
${PROJECT_CONTEXT_PLACEHOLDER}

## Current Development Status  
${CURRENT_STATUS_PLACEHOLDER}

## Recent Decisions
${RECENT_DECISIONS_PLACEHOLDER}
```

### 2. Cursor Workspace Settings (`.vscode/settings.json`):

```json
{
  "cursor.memoryBank": {
    "enabled": true,
    "autoLoad": true,
    "sources": [
      ".memory/CURRENT_STATUS.md",
      ".memory/PROJECT_CONTEXT.md", 
      ".memory/DECISIONS.md"
    ]
  },
  "cursor.rules": [
    ".cursor/rules/memory-bank.md"
  ]
}
```

## Automatic Setup Script

Create this script to auto-configure Cursor in any project:

```bash
#!/bin/bash
# .memory/setup-cursor.sh

mkdir -p .cursor/rules .vscode

# Create memory bank file
cat > .cursor/rules/memory-bank.md << 'EOF'
# Auto-Generated Memory Bank

Always read context from .memory/ directory:
- Current status: .memory/CURRENT_STATUS.md
- Project context: .memory/PROJECT_CONTEXT.md  
- Technical decisions: .memory/DECISIONS.md

Context is automatically maintained via git hooks.
EOF

# Create workspace settings
cat > .vscode/settings.json << 'EOF'
{
  "cursor.memoryBank": {
    "enabled": true,
    "autoLoad": true
  }
}
EOF

echo "✅ Cursor integration configured"
```

## How It Works

1. **Auto-Load**: Cursor reads `.memory/` files when opening workspace
2. **Git Integration**: Context updates automatically on commits/pushes  
3. **Cross-Tool Sync**: Same context used by Claude Code and Cursor
4. **Zero Manual Work**: Everything happens automatically

The system ensures Cursor always has the latest context without any manual steps!