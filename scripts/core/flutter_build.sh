#!/bin/bash
# ==================================================
# 🏗️ FLUTTER BUILD
# ==================================================
# Build Flutter project for all platforms with proper env
# Usage: bash scripts/flutter_build.sh [platform] [build-type]
# Platforms: android, ios, macos, web, all (default: all)
# Build types: debug, profile, release (default: release)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_env.sh"

# Parse arguments
PLATFORM="${1:-all}"
BUILD_TYPE="${2:-$BUILD_TYPE}"
BUILD_TYPE="${BUILD_TYPE:-release}"

echo "🏗️  Building Flutter app for $PLATFORM ($BUILD_TYPE mode)"

# Ensure clean state
echo "🧹 Cleaning before build..."
flutter clean
flutter pub get

# Build function
build_platform() {
    local platform=$1
    local build_type=$2
    
    case $platform in
        android)
            echo "🤖 Building Android..."
            if [ "$build_type" = "release" ]; then
                flutter build appbundle --release
                flutter build apk --release
            else
                flutter build apk --$build_type
            fi
            echo "✅ Android build complete"
            ;;
        ios)
            echo "🍎 Building iOS..."
            if [ ! -d "$PROJECT_ROOT/ios/Pods" ]; then
                echo "📦 Installing CocoaPods dependencies..."
                cd "$PROJECT_ROOT/ios"
                pod install
                cd "$PROJECT_ROOT"
            fi
            flutter build ios --$build_type --no-codesign
            echo "✅ iOS build complete (unsigned)"
            ;;
        macos)
            echo "💻 Building macOS..."
            if [ ! -d "$PROJECT_ROOT/macos/Pods" ]; then
                echo "📦 Installing CocoaPods dependencies..."
                cd "$PROJECT_ROOT/macos"
                pod install
                cd "$PROJECT_ROOT"
            fi
            flutter build macos --$build_type
            echo "✅ macOS build complete"
            ;;
        web)
            echo "🌐 Building Web..."
            flutter build web --$build_type
            echo "✅ Web build complete"
            ;;
        *)
            echo "❌ Unknown platform: $platform"
            exit 1
            ;;
    esac
}

# Build based on platform argument
if [ "$PLATFORM" = "all" ]; then
    echo "🌍 Building for all platforms..."
    build_platform android "$BUILD_TYPE"
    build_platform ios "$BUILD_TYPE"
    build_platform macos "$BUILD_TYPE"
    build_platform web "$BUILD_TYPE"
else
    build_platform "$PLATFORM" "$BUILD_TYPE"
fi

echo "✅ All builds complete!"

