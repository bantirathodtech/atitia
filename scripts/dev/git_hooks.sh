#!/bin/bash
# ==================================================
# 🪝 GIT HOOKS SETUP
# ==================================================
# Pre-commit hooks for formatting, linting, and test validation
# Usage: bash scripts/git_hooks.sh [install|uninstall]

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

ACTION="${1:-install}"

HOOKS_DIR="$PROJECT_ROOT/.git/hooks"
PRE_COMMIT_HOOK="$HOOKS_DIR/pre-commit"

install_hooks() {
    echo "🪝 Installing git hooks..."
    
    mkdir -p "$HOOKS_DIR"
    
    # Create pre-commit hook
    cat > "$PRE_COMMIT_HOOK" << 'EOF'
#!/bin/bash
# Pre-commit hook for Flutter project

set -e

PROJECT_ROOT="$(git rev-parse --show-toplevel)"
cd "$PROJECT_ROOT"

echo "🔍 Running pre-commit checks..."

# Format code
echo "📝 Formatting code..."
dart format . --set-exit-if-changed

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze

# Run tests (optional - uncomment to enable)
# echo "🧪 Running tests..."
# flutter test

echo "✅ Pre-commit checks passed!"
EOF
    
    chmod +x "$PRE_COMMIT_HOOK"
    
    echo "✅ Git hooks installed!"
    echo "   Pre-commit hook: $PRE_COMMIT_HOOK"
}

uninstall_hooks() {
    echo "🗑️  Uninstalling git hooks..."
    
    if [ -f "$PRE_COMMIT_HOOK" ]; then
        rm "$PRE_COMMIT_HOOK"
        echo "✅ Pre-commit hook removed"
    else
        echo "⚠️  No hooks found"
    fi
}

case $ACTION in
    install)
        install_hooks
        ;;
    uninstall)
        uninstall_hooks
        ;;
    *)
        echo "❌ Unknown action: $ACTION"
        echo "   Usage: bash scripts/git_hooks.sh [install|uninstall]"
        exit 1
        ;;
esac

