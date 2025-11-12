#!/bin/bash
# ==================================================
# 🤖 ANDROID RELEASE BUILD
# ==================================================
# Build Android AAB/APK with release signing
# Usage: bash scripts/release_android.sh [aab|apk|both]
# Default: both

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

BUILD_TYPE="${1:-both}"
COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE=$(date +%Y%m%d_%H%M%S)

echo "🤖 Building Android release ($BUILD_TYPE)"

# Verify signing setup
echo "🔍 Verifying signing configuration..."
bash "$SCRIPTS_ROOT/signing/android_sign.sh" verify || {
    echo "❌ Signing setup incomplete. Run: bash scripts/signing/android_sign.sh configure"
    exit 1
}

# Clean and get dependencies
echo "🧹 Cleaning and preparing..."
flutter clean
flutter pub get

# Build AAB (App Bundle) - preferred for Play Store
if [ "$BUILD_TYPE" = "aab" ] || [ "$BUILD_TYPE" = "both" ]; then
    echo "📦 Building Android App Bundle (AAB)..."
    flutter build appbundle --release
    
    # Rename with commit hash and date
    AAB_PATH="$PROJECT_ROOT/build/app/outputs/bundle/release/app-release.aab"
    if [ -f "$AAB_PATH" ]; then
        NEW_AAB_PATH="$PROJECT_ROOT/build/app-release-${COMMIT_HASH}-${BUILD_DATE}.aab"
        cp "$AAB_PATH" "$NEW_AAB_PATH"
        echo "✅ AAB built: $NEW_AAB_PATH"
    fi
fi

# Build APK (for direct distribution)
if [ "$BUILD_TYPE" = "apk" ] || [ "$BUILD_TYPE" = "both" ]; then
    echo "📦 Building Android APK..."
    flutter build apk --release
    
    # Rename with commit hash and date
    APK_PATH="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"
    if [ -f "$APK_PATH" ]; then
        NEW_APK_PATH="$PROJECT_ROOT/build/app-release-${COMMIT_HASH}-${BUILD_DATE}.apk"
        cp "$APK_PATH" "$NEW_APK_PATH"
        echo "✅ APK built: $NEW_APK_PATH"
    fi
    
    # Also build split APKs for smaller downloads
    echo "📦 Building split APKs..."
    flutter build apk --release --split-per-abi
    
    echo "✅ Split APKs built in build/app/outputs/flutter-apk/"
fi

echo "✅ Android release build complete!"
echo "   Artifacts location: $PROJECT_ROOT/build/app/outputs/"

