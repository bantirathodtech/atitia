#!/bin/bash
# ==================================================
# 📈 VERSION BUMP
# ==================================================
# Auto-increment app version + build number
# Usage: bash scripts/version_bump.sh [type] [custom-version]
# Types: major, minor, patch, build (default: build)
# Custom: specify exact version (e.g., "1.2.3+5")

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

BUMP_TYPE="${1:-build}"
CUSTOM_VERSION="${2:-}"

echo "📈 Bumping version ($BUMP_TYPE)"

# Read current version from pubspec.yaml
PUBSPEC="$PROJECT_ROOT/pubspec.yaml"
if [ ! -f "$PUBSPEC" ]; then
    echo "❌ pubspec.yaml not found"
    exit 1
fi

CURRENT_VERSION=$(grep "^version:" "$PUBSPEC" | sed 's/version: //' | tr -d ' ')
VERSION_NAME=$(echo "$CURRENT_VERSION" | cut -d'+' -f1)
BUILD_NUMBER=$(echo "$CURRENT_VERSION" | cut -d'+' -f2)

echo "   Current version: $VERSION_NAME+$BUILD_NUMBER"

# Bump version
if [ -n "$CUSTOM_VERSION" ]; then
    NEW_VERSION="$CUSTOM_VERSION"
    NEW_VERSION_NAME=$(echo "$NEW_VERSION" | cut -d'+' -f1)
    NEW_BUILD_NUMBER=$(echo "$NEW_VERSION" | cut -d'+' -f2)
elif [ "$BUMP_TYPE" = "build" ]; then
    NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
    NEW_VERSION_NAME="$VERSION_NAME"
    NEW_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
elif [ "$BUMP_TYPE" = "patch" ]; then
    MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
    MINOR=$(echo "$VERSION_NAME" | cut -d'.' -f2)
    PATCH=$(echo "$VERSION_NAME" | cut -d'.' -f3)
    NEW_PATCH=$((PATCH + 1))
    NEW_VERSION_NAME="$MAJOR.$MINOR.$NEW_PATCH"
    NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
    NEW_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
elif [ "$BUMP_TYPE" = "minor" ]; then
    MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
    MINOR=$(echo "$VERSION_NAME" | cut -d'.' -f2)
    NEW_MINOR=$((MINOR + 1))
    NEW_VERSION_NAME="$MAJOR.$NEW_MINOR.0"
    NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
    NEW_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
elif [ "$BUMP_TYPE" = "major" ]; then
    MAJOR=$(echo "$VERSION_NAME" | cut -d'.' -f1)
    NEW_MAJOR=$((MAJOR + 1))
    NEW_VERSION_NAME="$NEW_MAJOR.0.0"
    NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))
    NEW_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
else
    echo "❌ Unknown bump type: $BUMP_TYPE"
    echo "   Usage: bash scripts/version_bump.sh [major|minor|patch|build|custom] [version]"
    exit 1
fi

# Update pubspec.yaml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
else
    # Linux
    sed -i "s/^version: .*/version: $NEW_VERSION/" "$PUBSPEC"
fi

echo "   New version: $NEW_VERSION_NAME+$NEW_BUILD_NUMBER"

# Update Android version (if needed)
ANDROID_MANIFEST="$PROJECT_ROOT/android/app/src/main/AndroidManifest.xml"
if [ -f "$ANDROID_MANIFEST" ]; then
    # Android version is typically managed by build.gradle.kts
    echo "✅ Android version will be updated via build.gradle.kts"
fi

# Update iOS version (if needed)
IOS_INFO_PLIST="$PROJECT_ROOT/ios/Runner/Info.plist"
if [ -f "$IOS_INFO_PLIST" ]; then
    # iOS version is typically managed by pubspec.yaml via flutter build
    echo "✅ iOS version will be updated via pubspec.yaml"
fi

# Commit version bump (optional)
if [ -d "$PROJECT_ROOT/.git" ]; then
    read -p "Commit version bump? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add "$PUBSPEC"
        git commit -m "chore: bump version to $NEW_VERSION" || echo "⚠️  Commit failed or no changes"
    fi
fi

echo "✅ Version bumped to $NEW_VERSION"

