#!/bin/bash
# ==================================================
# 🚀 RELEASE ALL PLATFORMS
# ==================================================
# Build and deploy for all platforms
# Usage: bash scripts/release_all.sh [deploy]
# Deploy: yes, no (default: no)

set -e

# Source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

DEPLOY="${1:-no}"

echo "🚀 Starting full release process..."
echo ""

# Run diagnostics first
echo "🔍 Running diagnostics..."
bash "$SCRIPTS_ROOT/core/diagnostics.sh" || {
    echo "⚠️  Diagnostics found issues. Continue anyway? (y/N)"
    read -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted"
        exit 1
    fi
}

# Version bump
echo ""
echo "📈 Bumping version..."
bash "$SCRIPTS_ROOT/dev/version_bump.sh" build

# Clean
echo ""
echo "🧹 Cleaning..."
bash "$SCRIPTS_ROOT/core/flutter_clean.sh"

# Build all platforms
echo ""
echo "🏗️  Building all platforms..."
bash "$SCRIPTS_ROOT/release/release_android.sh" both
bash "$SCRIPTS_ROOT/release/release_ios.sh"
bash "$SCRIPTS_ROOT/release/build_web.sh" no

# Deploy (if requested)
if [ "$DEPLOY" = "yes" ] || [ "$DEPLOY" = "y" ]; then
    echo ""
    echo "📱 Deploying to stores..."
    
    # Deploy Android
    echo ""
    echo "🤖 Deploying Android..."
    bash "$SCRIPTS_ROOT/deploy/deploy_playstore.sh" "${PLAY_STORE_TRACK:-internal}"
    
    # Deploy iOS
    echo ""
    echo "🍎 Deploying iOS..."
    bash "$SCRIPTS_ROOT/deploy/deploy_appstore.sh"
    
    # Deploy Web
    echo ""
    echo "🌐 Deploying Web..."
    bash "$SCRIPTS_ROOT/release/build_web.sh" yes
fi

echo ""
echo "✅ Full release process complete!"
echo ""
echo "📦 Artifacts:"
echo "   Android: $PROJECT_ROOT/build/app/outputs/"
echo "   iOS: $PROJECT_ROOT/build/ios/ipa/"
echo "   Web: $PROJECT_ROOT/build/web/"

