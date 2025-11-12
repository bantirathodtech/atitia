#!/bin/bash
# ==================================================
# 🎨 GENERATE APP ICONS & SPLASH
# ==================================================
# Auto-generate app icons and splash for all platforms
# Usage: bash scripts/generate_icons.sh [source-image]
# Source: path to 1024x1024 PNG image (default: assets/app_icon.jpeg)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

SOURCE_IMAGE="${1:-$PROJECT_ROOT/assets/app_icon.jpeg}"

echo "🎨 Generating app icons and splash screens..."

# Check for flutter_launcher_icons package
if ! grep -q "flutter_launcher_icons" "$PROJECT_ROOT/pubspec.yaml"; then
    echo "⚠️  flutter_launcher_icons not found in pubspec.yaml"
    echo "   Adding dependency..."
    
    # Add dependency (basic approach - may need manual editing)
    echo "   Please add to pubspec.yaml:"
    echo "   dev_dependencies:"
    echo "     flutter_launcher_icons: ^0.13.1"
    echo ""
    echo "   Then run: flutter pub get"
    exit 1
fi

# Check source image
if [ ! -f "$SOURCE_IMAGE" ]; then
    echo "❌ Source image not found: $SOURCE_IMAGE"
    echo "   Provide a 1024x1024 PNG image"
    exit 1
fi

# Check for flutter_launcher_icons config
if ! grep -q "flutter_launcher_icons:" "$PROJECT_ROOT/pubspec.yaml"; then
    echo "⚠️  flutter_launcher_icons config not found in pubspec.yaml"
    echo "   Add configuration to pubspec.yaml"
    exit 1
fi

# Generate icons
echo "🖼️  Generating icons..."
flutter pub run flutter_launcher_icons

echo "✅ Icons generated!"
echo "   Android: android/app/src/main/res/"
echo "   iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset/"

# Generate splash (if flutter_native_splash is available)
if grep -q "flutter_native_splash" "$PROJECT_ROOT/pubspec.yaml"; then
    echo "🎨 Generating splash screens..."
    flutter pub run flutter_native_splash:create
    echo "✅ Splash screens generated!"
fi

