#!/bin/bash
# ==================================================
# 🧹 FLUTTER CLEAN
# ==================================================
# Clean Flutter, Gradle, Pods, and derived data (multi-platform clean)
# Usage: bash scripts/flutter_clean.sh

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_env.sh"

echo "🧹 Starting comprehensive clean..."

# Flutter clean
echo "📦 Cleaning Flutter build cache..."
flutter clean

# Remove build directories
echo "🗑️  Removing build directories..."
rm -rf "$PROJECT_ROOT/build"
rm -rf "$PROJECT_ROOT/.dart_tool"
rm -rf "$PROJECT_ROOT/.flutter-plugins"
rm -rf "$PROJECT_ROOT/.flutter-plugins-dependencies"

# Android clean
if [ -d "$PROJECT_ROOT/android" ]; then
    echo "🤖 Cleaning Android build artifacts..."
    cd "$PROJECT_ROOT/android"
    ./gradlew clean 2>/dev/null || echo "⚠️  Gradle clean skipped (gradlew not executable)"
    rm -rf "$PROJECT_ROOT/android/.gradle"
    rm -rf "$PROJECT_ROOT/android/app/build"
    rm -rf "$PROJECT_ROOT/android/build"
    rm -rf "$PROJECT_ROOT/android/.idea"
fi

# iOS clean
if [ -d "$PROJECT_ROOT/ios" ]; then
    echo "🍎 Cleaning iOS build artifacts..."
    rm -rf "$PROJECT_ROOT/ios/Pods"
    rm -rf "$PROJECT_ROOT/ios/.symlinks"
    rm -rf "$PROJECT_ROOT/ios/Flutter/Flutter.framework"
    rm -rf "$PROJECT_ROOT/ios/Flutter/Flutter.podspec"
    rm -rf "$PROJECT_ROOT/ios/Flutter/ephemeral"
    rm -rf "$PROJECT_ROOT/ios/DerivedData"
    rm -rf "$PROJECT_ROOT/ios/build"
    
    # Clean CocoaPods cache (optional, uncomment if needed)
    # pod cache clean --all
fi

# macOS clean
if [ -d "$PROJECT_ROOT/macos" ]; then
    echo "💻 Cleaning macOS build artifacts..."
    rm -rf "$PROJECT_ROOT/macos/Pods"
    rm -rf "$PROJECT_ROOT/macos/.symlinks"
    rm -rf "$PROJECT_ROOT/macos/Flutter/Flutter.framework"
    rm -rf "$PROJECT_ROOT/macos/Flutter/ephemeral"
    rm -rf "$PROJECT_ROOT/macos/DerivedData"
    rm -rf "$PROJECT_ROOT/macos/build"
fi

# Web clean
if [ -d "$PROJECT_ROOT/web" ]; then
    echo "🌐 Cleaning web build artifacts..."
    rm -rf "$PROJECT_ROOT/web/build"
fi

# Clean coverage
if [ -d "$PROJECT_ROOT/coverage" ]; then
    echo "📊 Cleaning coverage reports..."
    rm -rf "$PROJECT_ROOT/coverage"
fi

# Get Flutter packages
echo "📥 Getting Flutter packages..."
cd "$PROJECT_ROOT"
flutter pub get

echo "✅ Clean complete! All build artifacts removed."

