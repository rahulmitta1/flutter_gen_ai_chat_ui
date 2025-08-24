# Tools Context

## Claude Code Integration
- **MCP Memory Keeper**: ✅ Installed and configured globally
- **Location**: Available across all projects via user scope
- **Usage**: Maintains persistent context across Claude sessions
- **Files**: All .memory/ files are readable by Claude Code

## Cursor Integration
- **Status**: 🔄 Ready for setup
- **Memory Bank Location**: `.cursor/rules/memory-bank.md`
- **Setup Required**: Create cursor rules that reference .memory/ files
- **Integration**: Point cursor memory bank to read from .memory/CURRENT_STATUS.md

## Other AI Tools
- **Universal Access**: All tools can read .memory/ directory
- **Standard Format**: Markdown for humans, JSON for machines
- **Extensible**: Easy to add new tools by reading standard files

## File Access Patterns

### For Claude Code:
1. Start session: Read .memory/CURRENT_STATUS.md
2. During work: Update context via MCP Memory Keeper
3. End session: Update .memory/ files

### For Cursor:
1. Setup: Configure memory bank to reference .memory/
2. Auto-load: Cursor reads context on workspace open
3. Maintain: Update .memory/ files through cursor rules

### For Any Tool:
1. Read .memory/PROJECT_CONTEXT.md for project overview
2. Read .memory/CURRENT_STATUS.md for current state
3. Update .memory/SESSION_LOG.md with progress
4. Use update-progress.sh script for easy updates

## MCP Servers Available
- memory-keeper: npx mcp-memory-keeper ✅
- firebase: firebase experimental:mcp ✅  
- github: npx @modelcontextprotocol/server-github ✅
- playwright: npx @playwright/mcp ✅
- web-fetch: uvx mcp-server-fetch ✅
- browser-tools: npx @agentdeskai/browser-tools-mcp@latest ✅