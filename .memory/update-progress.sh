#!/bin/bash

# Progress Update Script for Centralized Development Context
# Usage: ./update-progress.sh

set -e

MEMORY_DIR=".memory"
SESSION_LOG="$MEMORY_DIR/SESSION_LOG.md"
CURRENT_STATUS="$MEMORY_DIR/CURRENT_STATUS.md"
PROGRESS_JSON="$MEMORY_DIR/progress.json"

# Create memory directory if it doesn't exist
mkdir -p "$MEMORY_DIR"

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
ISO_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "🔄 Updating progress for session at $TIMESTAMP"

# Add session entry to log
echo "" >> "$SESSION_LOG"
echo "## Session: $TIMESTAMP" >> "$SESSION_LOG"
echo "" >> "$SESSION_LOG"

# Interactive prompts
echo "What did you accomplish this session?"
read -r accomplished
echo "### Accomplished:" >> "$SESSION_LOG"
echo "- $accomplished" >> "$SESSION_LOG"
echo "" >> "$SESSION_LOG"

echo "What are your next steps?"
read -r next_steps
echo "### Next Steps:" >> "$SESSION_LOG"
echo "- $next_steps" >> "$SESSION_LOG"
echo "" >> "$SESSION_LOG"

echo "Any blockers or issues?"
read -r blockers
if [ -n "$blockers" ]; then
    echo "### Blockers:" >> "$SESSION_LOG"
    echo "- $blockers" >> "$SESSION_LOG"
    echo "" >> "$SESSION_LOG"
fi

echo "Current task/focus?"
read -r current_task

# Update CURRENT_STATUS.md
{
    echo "# Current Status"
    echo ""
    echo "## What We're Working On"
    echo "$current_task"
    echo ""
    echo "## Last Updated"
    echo "$TIMESTAMP"
    echo ""
    echo "## Recent Progress" 
    echo "- $accomplished"
    echo ""
    echo "## Immediate Next Steps"
    echo "- $next_steps"
    echo ""
    if [ -n "$blockers" ]; then
        echo "## Current Blockers"
        echo "- $blockers"
        echo ""
    fi
} > "$CURRENT_STATUS"

# Update progress.json (basic update - can be enhanced)
if [ -f "$PROGRESS_JSON" ]; then
    # Simple timestamp update - you can enhance this with jq for more complex updates
    sed -i.bak "s/\"lastUpdated\": \"[^\"]*\"/\"lastUpdated\": \"$ISO_TIMESTAMP\"/" "$PROGRESS_JSON"
    sed -i.bak "s/\"currentTask\": \"[^\"]*\"/\"currentTask\": \"$current_task\"/" "$PROGRESS_JSON"
    rm -f "$PROGRESS_JSON.bak"
fi

echo "✅ Progress updated successfully!"
echo "📝 Check $SESSION_LOG for session history"
echo "📊 Check $CURRENT_STATUS for current status"

# Optional: Show current status
echo ""
echo "--- Current Status ---"
cat "$CURRENT_STATUS"