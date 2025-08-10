#!/bin/bash

# Install Git Hooks and Shell Integration for Automatic Context Tracking

set -e

MEMORY_TEMPLATE_DIR="$HOME/.claude/.memory"
SHELL_CONFIG="$HOME/.zshrc"

echo "🔧 Installing automatic context tracking system..."

# Function to install git hooks in current directory
install_git_hooks() {
    if [ ! -d ".git" ]; then
        echo "⚠️  Not a git repository. Skipping git hooks."
        return
    fi
    
    echo "📝 Installing git hooks..."
    
    # Post-commit hook
    cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash
# Auto-sync context after commits

if [ -f ".memory/auto-sync.sh" ]; then
    ./.memory/auto-sync.sh
fi
EOF
    
    # Pre-push hook
    cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
# Update context before push

if [ -f ".memory/auto-sync.sh" ]; then
    ./.memory/auto-sync.sh
    
    # Auto-commit memory updates if changes exist
    if [ -d ".memory" ] && ! git diff --quiet .memory/ 2>/dev/null; then
        git add .memory/
        git commit -m "chore: auto-update development context

🤖 Automated context sync
- Updated progress tracking
- Synced session state
- Preserved development context"
    fi
fi
EOF

    # Make hooks executable
    chmod +x .git/hooks/post-commit .git/hooks/pre-push
    
    echo "✅ Git hooks installed"
}

# Function to set up shell integration
setup_shell_integration() {
    echo "🐚 Setting up shell integration..."
    
    # Add functions to shell config if not already present
    if ! grep -q "# Claude Code Auto Context" "$SHELL_CONFIG" 2>/dev/null; then
        cat >> "$SHELL_CONFIG" << 'EOF'

# Claude Code Auto Context System
# Auto-initializes context tracking in new directories

# Function to auto-setup memory tracking
auto_setup_memory() {
    if [ -d ".git" ] && [ ! -d ".memory" ]; then
        echo "🧠 Auto-initializing context tracking..."
        cp -r ~/.claude/.memory ./ 2>/dev/null || true
        
        # Install git hooks automatically
        if [ -f ".memory/install-hooks.sh" ]; then
            ./.memory/install-hooks.sh --git-only
        fi
    fi
    
    # Auto-sync on directory change
    if [ -f ".memory/auto-sync.sh" ]; then
        ./.memory/auto-sync.sh >/dev/null 2>&1 &
    fi
}

# Hook into cd command
cd() {
    builtin cd "$@"
    auto_setup_memory
}

# Auto-setup on shell start if in git repo
auto_setup_memory

# Alias for manual context updates
alias context-sync='if [ -f ".memory/auto-sync.sh" ]; then ./.memory/auto-sync.sh; else echo "No context tracking in this directory"; fi'
alias context-status='if [ -f ".memory/CURRENT_STATUS.md" ]; then cat .memory/CURRENT_STATUS.md; else echo "No context tracking in this directory"; fi'

EOF
        echo "✅ Shell integration added to $SHELL_CONFIG"
        echo "🔄 Run 'source $SHELL_CONFIG' or restart your terminal"
    else
        echo "✅ Shell integration already configured"
    fi
}

# Function to create global auto-init script
create_global_autoinit() {
    echo "🌍 Creating global auto-initialization..."
    
    cat > "$HOME/.claude/auto-init.sh" << 'EOF'
#!/bin/bash

# Global Auto-Initialization for Claude Code Context
# Automatically sets up context tracking for any git repository

PROJECT_DIR="$1"
if [ -z "$PROJECT_DIR" ]; then
    PROJECT_DIR="$PWD"
fi

cd "$PROJECT_DIR"

# Check if it's a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Context tracking requires git."
    exit 1
fi

# Check if already initialized
if [ -d ".memory" ]; then
    echo "✅ Context tracking already initialized"
    exit 0
fi

echo "🚀 Auto-initializing context tracking in $PROJECT_DIR..."

# Copy memory template
cp -r ~/.claude/.memory ./
chmod +x .memory/*.sh

# Auto-detect project type and update context
if [ -f ".memory/auto-sync.sh" ]; then
    ./.memory/auto-sync.sh
fi

# Install git hooks
if [ -f ".memory/install-hooks.sh" ]; then
    ./.memory/install-hooks.sh --git-only
fi

# Create .gitignore entry if needed
if [ -f ".gitignore" ] && ! grep -q ".memory" .gitignore; then
    echo "" >> .gitignore
    echo "# Claude Code Context (optional - remove this line to version control context)" >> .gitignore
    echo ".memory/.auto-sync.lock" >> .gitignore
fi

echo "✅ Context tracking initialized!"
echo "📊 Run 'context-status' to see current context"
EOF

    chmod +x "$HOME/.claude/auto-init.sh"
    echo "✅ Global auto-init script created"
}

# Function to setup background sync daemon
setup_background_sync() {
    echo "⚡ Setting up background context sync..."
    
    # Create launch agent for macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        PLIST_DIR="$HOME/Library/LaunchAgents"
        PLIST_FILE="$PLIST_DIR/com.claude.context-sync.plist"
        
        mkdir -p "$PLIST_DIR"
        
        cat > "$PLIST_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.context-sync</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>find ~/Dev ~/Projects ~/Code -name ".memory" -type d -exec dirname {} \; 2>/dev/null | while read dir; do cd "\$dir" && if [ -f ".memory/auto-sync.sh" ]; then ./.memory/auto-sync.sh >/dev/null 2>&1; fi; done</string>
    </array>
    <key>StartInterval</key>
    <integer>300</integer>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
        
        # Load the launch agent
        launchctl load "$PLIST_FILE" 2>/dev/null || true
        echo "✅ Background sync daemon configured (5-minute intervals)"
    else
        echo "ℹ️  Background sync setup is macOS-specific (skipped)"
    fi
}

# Main installation
main() {
    case "${1:-}" in
        --git-only)
            install_git_hooks
            ;;
        *)
            install_git_hooks
            setup_shell_integration
            create_global_autoinit
            setup_background_sync
            
            echo ""
            echo "🎉 Automatic context tracking system installed!"
            echo ""
            echo "Features enabled:"
            echo "  ✅ Auto-initializes in new git repositories"
            echo "  ✅ Git hooks for automatic updates"
            echo "  ✅ Shell integration (cd command)"
            echo "  ✅ Background sync daemon"
            echo "  ✅ Context preservation across all tools"
            echo ""
            echo "Usage:"
            echo "  • Just cd into any git repository - context tracking auto-starts"
            echo "  • Run 'context-status' to see current context"
            echo "  • Run 'context-sync' to manually sync"
            echo "  • Everything else is automatic!"
            echo ""
            echo "Next: Restart your terminal or run 'source ~/.zshrc'"
            ;;
    esac
}

main "$@"