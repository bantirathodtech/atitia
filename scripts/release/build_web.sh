#!/bin/bash
# ==================================================
# 🌐 WEB BUILD & DEPLOY
# ==================================================
# Build Flutter web and optionally deploy to Firebase Hosting
# Usage: bash scripts/build_web.sh [deploy]
# Deploy: yes, no (default: no)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

DEPLOY="${1:-no}"

echo "🌐 Building Flutter web app"

# Clean and get dependencies
echo "🧹 Cleaning and preparing..."
flutter clean
flutter pub get

# Build web
echo "🏗️  Building web release..."
flutter build web --release --web-renderer canvaskit

WEB_BUILD_DIR="$PROJECT_ROOT/build/web"
if [ ! -d "$WEB_BUILD_DIR" ]; then
    echo "❌ Web build failed"
    exit 1
fi

echo "✅ Web build complete!"
echo "   Build directory: $WEB_BUILD_DIR"

# Deploy to Firebase Hosting (if requested)
if [ "$DEPLOY" = "yes" ] || [ "$DEPLOY" = "y" ]; then
    echo "🚀 Deploying to Firebase Hosting..."
    
    if ! command -v firebase &> /dev/null; then
        echo "❌ Firebase CLI not installed"
        echo "   Install: npm install -g firebase-tools"
        exit 1
    fi
    
    # Check if logged in
    if ! firebase projects:list &>/dev/null; then
        echo "🔐 Logging in to Firebase..."
        firebase login
    fi
    
    # Deploy
    firebase deploy --only hosting --project "$FIREBASE_PROJECT_ID"
    
    echo "✅ Web deployment complete!"
    echo "   Site: https://${FIREBASE_HOSTING_SITE:-$FIREBASE_PROJECT_ID}.web.app"
else
    echo "💡 To deploy, run: bash scripts/build_web.sh yes"
    echo "   Or serve locally: cd build/web && python3 -m http.server 8000"
fi

