#!/bin/bash
# ==================================================
# 🔍 DIAGNOSTICS & VERIFICATION
# ==================================================
# Verify environment, SDKs, signing, Firebase, and credentials
# Usage: bash scripts/diagnostics.sh

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/setup_env.sh"

echo "🔍 Running diagnostics..."
echo ""

ERRORS=0
WARNINGS=0

# Check function
check() {
    local name=$1
    local condition=$2
    local error_msg=$3
    
    if eval "$condition"; then
        echo "✅ $name"
    else
        echo "❌ $name: $error_msg"
        ERRORS=$((ERRORS + 1))
    fi
}

warn() {
    local name=$1
    local condition=$2
    local warning_msg=$3
    
    if eval "$condition"; then
        echo "⚠️  $name: $warning_msg"
        WARNINGS=$((WARNINGS + 1))
    else
        echo "✅ $name"
    fi
}

# Flutter SDK
echo "📱 Flutter SDK"
check "Flutter installed" "command -v flutter &> /dev/null" "Flutter not found in PATH"
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    echo "   Version: $FLUTTER_VERSION"
    check "Flutter doctor" "flutter doctor &>/dev/null" "Run 'flutter doctor' for details"
fi

# Dart SDK
echo ""
echo "🎯 Dart SDK"
check "Dart installed" "command -v dart &> /dev/null" "Dart not found in PATH"
if command -v dart &> /dev/null; then
    DART_VERSION=$(dart --version 2>/dev/null || echo "unknown")
    echo "   Version: $DART_VERSION"
fi

# Android
echo ""
echo "🤖 Android"
check "Android SDK" "[ -d \"$ANDROID_HOME\" ] || [ -d \"$HOME/Library/Android/sdk\" ]" "ANDROID_HOME not set"
check "Java installed" "command -v java &> /dev/null" "Java not found"
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    echo "   $JAVA_VERSION"
fi
check "Gradle" "[ -f \"$PROJECT_ROOT/android/gradlew\" ]" "Gradle wrapper not found"
check "Android keystore" "[ -f \"$ANDROID_KEYSTORE_PATH\" ]" "Keystore not found"
warn "Android key.properties" "[ -f \"$PROJECT_ROOT/android/key.properties\" ]" "key.properties not found"

# iOS (macOS only)
if [ "$(uname)" = "Darwin" ]; then
    echo ""
    echo "🍎 iOS"
    check "Xcode installed" "command -v xcodebuild &> /dev/null" "Xcode not found"
    if command -v xcodebuild &> /dev/null; then
        XCODE_VERSION=$(xcodebuild -version | head -n 1)
        echo "   $XCODE_VERSION"
    fi
    check "CocoaPods" "command -v pod &> /dev/null" "CocoaPods not installed"
    check "iOS certificate" "[ -f \"$IOS_CERT_PATH\" ]" "Certificate not found"
    warn "iOS provisioning profile" "[ -f \"$IOS_PROVISION_PROFILE\" ]" "Provisioning profile not found"
    warn "Code signing identity" "security find-identity -v -p codesigning | grep -q 'iPhone Distribution'" "No distribution identity found"
else
    echo ""
    echo "🍎 iOS (skipped - not on macOS)"
fi

# macOS (macOS only)
if [ "$(uname)" = "Darwin" ]; then
    echo ""
    echo "💻 macOS"
    check "macOS certificate" "[ -f \"$MACOS_CERT_PATH\" ]" "Certificate not found"
    warn "macOS provisioning profile" "[ -f \"$MACOS_PROVISION_PROFILE\" ]" "Provisioning profile not found"
else
    echo ""
    echo "💻 macOS (skipped - not on macOS)"
fi

# Web
echo ""
echo "🌐 Web"
check "Node.js" "command -v node &> /dev/null" "Node.js not found"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "   Version: $NODE_VERSION"
fi
warn "Firebase CLI" "command -v firebase &> /dev/null" "Firebase CLI not installed"

# Firebase
echo ""
echo "🔥 Firebase"
check "Firebase config" "[ -f \"$FIREBASE_CONFIG_PATH\" ] || [ -f \"$PROJECT_ROOT/lib/firebase_options.dart\" ]" "Firebase config not found"
warn "Firebase project ID" "[ -n \"$FIREBASE_PROJECT_ID\" ]" "FIREBASE_PROJECT_ID not set"

# Secrets
echo ""
echo "🔐 Secrets"
check ".env file" "[ -f \"$PROJECT_ROOT/.secrets/common/.env\" ]" ".env file not found"
check "Android keystore" "[ -f \"$ANDROID_KEYSTORE_PATH\" ]" "Keystore not found"
check "Android service account" "[ -f \"$ANDROID_SERVICE_ACCOUNT\" ]" "Service account JSON not found"
if [ "$(uname)" = "Darwin" ]; then
    check "iOS certificate" "[ -f \"$IOS_CERT_PATH\" ]" "Certificate not found"
    check "iOS API key" "[ -f \"$IOS_APPSTORE_API_KEY\" ]" "App Store Connect API key not found"
fi

# Project structure
echo ""
echo "📁 Project Structure"
check "pubspec.yaml" "[ -f \"$PROJECT_ROOT/pubspec.yaml\" ]" "pubspec.yaml not found"
check "lib directory" "[ -d \"$PROJECT_ROOT/lib\" ]" "lib directory not found"
check "scripts directory" "[ -d \"$PROJECT_ROOT/scripts\" ]" "scripts directory not found"
check ".secrets directory" "[ -d \"$PROJECT_ROOT/.secrets\" ]" ".secrets directory not found"

# Git
echo ""
echo "📦 Git"
check "Git repository" "[ -d \"$PROJECT_ROOT/.git\" ]" "Not a git repository"
if [ -d "$PROJECT_ROOT/.git" ]; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "   Branch: $BRANCH"
    COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")
    echo "   Commit: $COMMIT"
fi

# Summary
echo ""
echo "=========================================="
echo "📊 Summary"
echo "=========================================="
echo "Errors: $ERRORS"
echo "Warnings: $WARNINGS"

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed!"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Some warnings found, but no errors"
    exit 0
else
    echo "❌ Found $ERRORS error(s). Please fix them before proceeding."
    exit 1
fi

