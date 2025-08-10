# Technical Decisions

## Architecture Decisions

### Memory Storage Approach
**Decision**: Use hybrid approach with MCP Memory Keeper + file-based .memory/ directory
**Reasoning**: 
- MCP Memory Keeper provides AI-native persistent context for Claude Code
- File-based .memory/ directory ensures cross-tool compatibility
- JSON + Markdown combination serves both machines and humans

### Directory Structure
**Decision**: Use `.memory/` directory in project root
**Reasoning**:
- Hidden directory keeps it out of main codebase
- Standard location across all projects
- Easy to .gitignore if needed

### File Format Strategy
**Decision**: Markdown for human reading, JSON for machine processing
**Reasoning**:
- Markdown is readable and editable by developers
- JSON provides structured data for automation
- Both can be version controlled

### Tool Integration Strategy
**Decision**: Universal .memory/ directory referenced by all tools
**Reasoning**:
- Avoids vendor lock-in to specific tools
- Works with current and future AI coding assistants
- Maintainable by any team member

## Implementation Decisions

### MCP Server Scope
**Decision**: Install MCP Memory Keeper with user scope (global)
**Reasoning**: Ensures availability across all projects and sessions

### Progress Tracking Format
**Decision**: Combination of structured JSON + free-form Markdown
**Reasoning**: Supports both automated processing and human context