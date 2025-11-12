#!/bin/bash
# ==================================================
# 🔥 FIREBASE SETUP
# ==================================================
# Auto-link Firebase configs for all platforms
# Usage: bash scripts/firebase_setup.sh [platform]
# Platforms: android, ios, macos, web, all (default: all)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

PLATFORM="${1:-all}"

echo "🔥 Setting up Firebase for $PLATFORM"

# Check Firebase CLI
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not installed"
    echo "   Install: npm install -g firebase-tools"
    exit 1
fi

# Login check
if ! firebase projects:list &>/dev/null; then
    echo "🔐 Logging in to Firebase..."
    firebase login
fi

# Setup function
setup_platform() {
    local platform=$1
    
    case $platform in
        android)
            echo "🤖 Setting up Android Firebase..."
            GOOGLE_SERVICES="$PROJECT_ROOT/.secrets/common/google-services.json"
            if [ -f "$GOOGLE_SERVICES" ]; then
                cp "$GOOGLE_SERVICES" "$PROJECT_ROOT/android/app/google-services.json"
                echo "✅ Google Services JSON copied"
            else
                echo "⚠️  google-services.json not found in .secrets/common/"
                echo "   Download from Firebase Console and place it there"
            fi
            ;;
        ios)
            echo "🍎 Setting up iOS Firebase..."
            GOOGLE_SERVICE_INFO="$PROJECT_ROOT/.secrets/common/GoogleService-Info.plist"
            if [ -f "$GOOGLE_SERVICE_INFO" ]; then
                cp "$GOOGLE_SERVICE_INFO" "$PROJECT_ROOT/ios/Runner/GoogleService-Info.plist"
                echo "✅ GoogleService-Info.plist copied"
            else
                echo "⚠️  GoogleService-Info.plist not found in .secrets/common/"
                echo "   Download from Firebase Console and place it there"
            fi
            ;;
        macos)
            echo "💻 Setting up macOS Firebase..."
            GOOGLE_SERVICE_INFO="$PROJECT_ROOT/.secrets/common/GoogleService-Info-macos.plist"
            if [ -f "$GOOGLE_SERVICE_INFO" ]; then
                cp "$GOOGLE_SERVICE_INFO" "$PROJECT_ROOT/macos/Runner/GoogleService-Info.plist"
                echo "✅ GoogleService-Info.plist copied"
            else
                echo "⚠️  GoogleService-Info-macos.plist not found in .secrets/common/"
            fi
            ;;
        web)
            echo "🌐 Setting up Web Firebase..."
            # Web Firebase config is typically in lib/firebase_options.dart
            # or can be generated using FlutterFire CLI
            if [ -f "$FIREBASE_CONFIG_PATH" ]; then
                echo "✅ Firebase config found: $FIREBASE_CONFIG_PATH"
            else
                echo "⚠️  Firebase config not found"
                echo "   Generate using: flutterfire configure"
            fi
            ;;
        *)
            echo "❌ Unknown platform: $platform"
            exit 1
            ;;
    esac
}

# Setup based on platform
if [ "$PLATFORM" = "all" ]; then
    setup_platform android
    setup_platform ios
    setup_platform macos
    setup_platform web
else
    setup_platform "$PLATFORM"
fi

echo "✅ Firebase setup complete!"

