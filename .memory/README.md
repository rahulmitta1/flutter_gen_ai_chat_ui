# Centralized Progress Tracking System

This directory provides persistent context and progress tracking across all AI coding tools (Claude Code, Cursor, etc.).

## Quick Start

### Daily Workflow
1. **Session Start**: Read `CURRENT_STATUS.md`
2. **During Work**: Context is maintained automatically
3. **Session End**: Run `./update-progress.sh`

### Files Overview
- `PROJECT_CONTEXT.md` - Core project information and architecture
- `CURRENT_STATUS.md` - What you're currently working on  
- `DECISIONS.md` - Technical decisions and reasoning
- `NEXT_STEPS.md` - What to do next session
- `SESSION_LOG.md` - Complete session history
- `progress.json` - Machine-readable progress data
- `TOOLS_CONTEXT.md` - Tool-specific integration details
- `update-progress.sh` - Interactive progress update script

## Setup for New Project

1. Copy this `.memory/` directory to your project root
2. Update `PROJECT_CONTEXT.md` with your project details
3. Run `./update-progress.sh` to initialize
4. Configure your AI tools to read from `.memory/`

## Tool Integration

### Claude Code
- MCP Memory Keeper maintains persistent context
- Reads `.memory/` files automatically
- Updates context throughout session

### Cursor  
- Add to `.cursor/rules/memory-bank.md`:
```markdown
Always read .memory/CURRENT_STATUS.md at session start
Reference .memory/PROJECT_CONTEXT.md for project understanding
Update .memory/ files when making significant progress
```

### Other Tools
- Read `.memory/CURRENT_STATUS.md` for current context
- Update `.memory/SESSION_LOG.md` with progress
- Use `progress.json` for automated integrations

## Benefits
- ✅ No more "what was I doing?" moments
- ✅ Seamless context between different AI tools
- ✅ Persistent project memory across sessions
- ✅ Team collaboration with shared context
- ✅ Automated progress tracking and logging

## Usage Tips
- Update progress frequently during active development
- Use descriptive commit messages referencing progress
- Share `.memory/` directory with team for synchronized context
- Backup important decisions in `DECISIONS.md`