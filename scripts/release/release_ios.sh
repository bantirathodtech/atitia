#!/bin/bash
# ==================================================
# 🍎 iOS RELEASE BUILD
# ==================================================
# Build iOS IPA using Xcode CLI + exportOptions.plist
# Usage: bash scripts/release_ios.sh

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

COMMIT_HASH=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE=$(date +%Y%m%d_%H%M%S)

echo "🍎 Building iOS release"

# Verify signing setup
echo "🔍 Verifying signing configuration..."
bash "$SCRIPTS_ROOT/signing/ios_sign.sh" verify || {
    echo "❌ Signing setup incomplete. Run: bash scripts/signing/ios_sign.sh setup"
    exit 1
}

# Clean and get dependencies
echo "🧹 Cleaning and preparing..."
flutter clean
flutter pub get

# Install CocoaPods dependencies
echo "📦 Installing CocoaPods dependencies..."
cd "$PROJECT_ROOT/ios"
pod install
cd "$PROJECT_ROOT"

# Build iOS archive
echo "🏗️  Building iOS archive..."
flutter build ios --release --no-codesign

# Create archive using xcodebuild
echo "📦 Creating Xcode archive..."
WORKSPACE="$PROJECT_ROOT/ios/Runner.xcworkspace"
SCHEME="Runner"
ARCHIVE_PATH="$PROJECT_ROOT/build/ios/archive/Runner.xcarchive"

xcodebuild clean archive \
    -workspace "$WORKSPACE" \
    -scheme "$SCHEME" \
    -configuration Release \
    -archivePath "$ARCHIVE_PATH" \
    CODE_SIGN_IDENTITY="iPhone Distribution" \
    CODE_SIGNING_REQUIRED=YES \
    CODE_SIGNING_ALLOWED=YES \
    PROVISIONING_PROFILE_SPECIFIER="" \
    || {
    echo "❌ Archive creation failed"
    exit 1
}

# Export IPA
echo "📦 Exporting IPA..."
if [ ! -f "$IOS_EXPORT_OPTIONS" ]; then
    echo "❌ exportOptions.plist not found at $IOS_EXPORT_OPTIONS"
    exit 1
fi

EXPORT_PATH="$PROJECT_ROOT/build/ios/ipa"
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportOptionsPlist "$IOS_EXPORT_OPTIONS" \
    -exportPath "$EXPORT_PATH" \
    || {
    echo "❌ IPA export failed"
    exit 1
}

# Rename IPA with commit hash and date
IPA_FILE=$(find "$EXPORT_PATH" -name "*.ipa" | head -n 1)
if [ -f "$IPA_FILE" ]; then
    NEW_IPA_PATH="$PROJECT_ROOT/build/app-release-${COMMIT_HASH}-${BUILD_DATE}.ipa"
    cp "$IPA_FILE" "$NEW_IPA_PATH"
    echo "✅ IPA built: $NEW_IPA_PATH"
fi

echo "✅ iOS release build complete!"
echo "   IPA location: $EXPORT_PATH"

