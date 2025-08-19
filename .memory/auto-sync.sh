#!/bin/bash

# Automatic Context Sync System
# Monitors git activity and automatically updates progress context

set -e

MEMORY_DIR=".memory"
LOCK_FILE="$MEMORY_DIR/.auto-sync.lock"

# Exit if already running
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create lock file
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Function to get git activity
get_git_activity() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        # Get recent commits
        local recent_commits=$(git log --oneline -5 --since="1 hour ago" 2>/dev/null || echo "")
        # Get current branch
        local current_branch=$(git branch --show-current 2>/dev/null || echo "main")
        # Get file changes
        local changed_files=$(git diff --name-only HEAD~1..HEAD 2>/dev/null | head -10 | tr '\n' ', ' | sed 's/,$//' || echo "")
        
        echo "Branch: $current_branch"
        if [ -n "$recent_commits" ]; then
            echo "Recent commits:"
            echo "$recent_commits"
        fi
        if [ -n "$changed_files" ]; then
            echo "Changed files: $changed_files"
        fi
    fi
}

# Function to detect project type
detect_project_type() {
    local project_type="unknown"
    
    if [ -f "package.json" ]; then
        project_type="node"
    elif [ -f "Cargo.toml" ]; then
        project_type="rust"
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        project_type="python"
    elif [ -f "pubspec.yaml" ]; then
        project_type="flutter"
    elif [ -f "go.mod" ]; then
        project_type="go"
    fi
    
    echo "$project_type"
}

# Function to auto-update current status
auto_update_status() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local iso_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local project_type=$(detect_project_type)
    local git_activity=$(get_git_activity)
    local current_dir=$(basename "$PWD")
    
    # Create or update CURRENT_STATUS.md
    cat > "$MEMORY_DIR/CURRENT_STATUS.md" << EOF
# Current Status

## Auto-Updated: $timestamp

## Project Info
- **Directory**: $current_dir
- **Type**: $project_type
- **Last Activity**: $timestamp

## Git Context
$git_activity

## Auto-Detected Activity
$(detect_current_activity)

## Session Context
- **Working Directory**: \`$PWD\`
- **Auto-sync Active**: ✅
- **Last Sync**: $timestamp

EOF

    # Update progress.json
    if [ -f "$MEMORY_DIR/progress.json" ]; then
        # Use simple sed replacements for JSON updates
        sed -i.bak "s/\"lastUpdated\": \"[^\"]*\"/\"lastUpdated\": \"$iso_timestamp\"/" "$MEMORY_DIR/progress.json" 2>/dev/null || true
        rm -f "$MEMORY_DIR/progress.json.bak" 2>/dev/null || true
    fi
    
    # Log the auto-update
    echo "" >> "$MEMORY_DIR/AUTO_SYNC_LOG.md"
    echo "## Auto-Sync: $timestamp" >> "$MEMORY_DIR/AUTO_SYNC_LOG.md"
    echo "$git_activity" >> "$MEMORY_DIR/AUTO_SYNC_LOG.md"
    echo "" >> "$MEMORY_DIR/AUTO_SYNC_LOG.md"
}

# Function to detect current activity
detect_current_activity() {
    local activity=""
    
    # Check for common development activities
    if pgrep -f "npm run dev" >/dev/null 2>&1; then
        activity="$activity\n- Development server running"
    fi
    
    if pgrep -f "flutter run" >/dev/null 2>&1; then
        activity="$activity\n- Flutter app running"
    fi
    
    if git diff --cached --quiet >/dev/null 2>&1; then
        if ! git diff --quiet >/dev/null 2>&1; then
            activity="$activity\n- Unstaged changes detected"
        fi
    else
        activity="$activity\n- Staged changes ready to commit"
    fi
    
    # Check for recent file modifications (last 5 minutes)
    local recent_files=$(find . -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.dart" -o -name "*.go" -o -name "*.rs" | xargs ls -lt 2>/dev/null | head -3 | awk '{print $9}' || echo "")
    
    if [ -n "$recent_files" ]; then
        activity="$activity\n- Recently modified: $recent_files"
    fi
    
    if [ -z "$activity" ]; then
        activity="- No specific activity detected"
    fi
    
    echo -e "$activity"
}

# Main execution
main() {
    # Ensure memory directory exists
    mkdir -p "$MEMORY_DIR"
    
    # Initialize if first run
    if [ ! -f "$MEMORY_DIR/CURRENT_STATUS.md" ]; then
        echo "Initializing auto-sync for new project..."
        cp -r ~/.claude/.memory/* "$MEMORY_DIR/" 2>/dev/null || true
    fi
    
    # Auto-update status
    auto_update_status
    
    echo "Auto-sync completed at $(date)"
}

# Run main function
main