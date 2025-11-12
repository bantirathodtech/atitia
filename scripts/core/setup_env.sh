#!/bin/bash
# ==================================================
# 🔧 SETUP ENVIRONMENT
# ==================================================
# Auto-detect Flutter version, SDK paths, and apply .env configs
# Usage: source scripts/setup_env.sh

set -e

# Get script directory and project root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$SCRIPTS_ROOT/.." && pwd)"

# Export project root
export PROJECT_ROOT

# Detect Flutter SDK path
if command -v flutter &> /dev/null; then
    FLUTTER_PATH=$(which flutter | sed 's|/bin/flutter||')
    export FLUTTER_PATH
    export PATH="$FLUTTER_PATH/bin:$PATH"
else
    echo "❌ Flutter not found in PATH"
    echo "   Please install Flutter or add it to your PATH"
    exit 1
fi

# Detect Flutter version
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1 | awk '{print $2}')
    export FLUTTER_VERSION
    echo "✅ Flutter version: $FLUTTER_VERSION"
fi

# Detect Dart SDK path
if command -v dart &> /dev/null; then
    DART_PATH=$(which dart | sed 's|/bin/dart||')
    export DART_PATH
else
    echo "⚠️  Dart not found in PATH"
fi

# Load .env file if it exists
ENV_FILE="$PROJECT_ROOT/.secrets/common/.env"
if [ -f "$ENV_FILE" ]; then
    echo "📝 Loading environment from $ENV_FILE"
    # Export all variables from .env
    set -a
    source "$ENV_FILE"
    set +a
    echo "✅ Environment variables loaded"
else
    echo "⚠️  .env file not found at $ENV_FILE"
    echo "   Using default values. Create .env.example and copy to .env"
fi

# Set default values if not set
export APP_NAME="${APP_NAME:-Atitia}"
export APP_BUNDLE_ID="${APP_BUNDLE_ID:-com.avishio.atitia}"
export FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"
export BUILD_TYPE="${BUILD_TYPE:-release}"

# Android paths
export ANDROID_KEYSTORE_PATH="${ANDROID_KEYSTORE_PATH:-$PROJECT_ROOT/.secrets/android/keystore.jks}"
export ANDROID_SERVICE_ACCOUNT="${ANDROID_SERVICE_ACCOUNT:-$PROJECT_ROOT/.secrets/android/service_account.json}"

# iOS paths
export IOS_CERT_PATH="${IOS_CERT_PATH:-$PROJECT_ROOT/.secrets/ios/Certificates.p12}"
export IOS_PROVISION_PROFILE="${IOS_PROVISION_PROFILE:-$PROJECT_ROOT/.secrets/ios/ProvisionProfile.mobileprovision}"
export IOS_EXPORT_OPTIONS="${IOS_EXPORT_OPTIONS:-$PROJECT_ROOT/.secrets/ios/exportOptions.plist}"

# macOS paths
export MACOS_CERT_PATH="${MACOS_CERT_PATH:-$PROJECT_ROOT/.secrets/macos/Certificates.p12}"
export MACOS_PROVISION_PROFILE="${MACOS_PROVISION_PROFILE:-$PROJECT_ROOT/.secrets/macos/ProvisionProfile.provisionprofile}"
export MACOS_EXPORT_OPTIONS="${MACOS_EXPORT_OPTIONS:-$PROJECT_ROOT/.secrets/macos/exportOptions.plist}"

# Firebase paths
export FIREBASE_CONFIG_PATH="${FIREBASE_CONFIG_PATH:-$PROJECT_ROOT/.secrets/common/firebase_options.dart}"

# Change to project root
cd "$PROJECT_ROOT"

echo "✅ Environment setup complete"
echo "   Project Root: $PROJECT_ROOT"
echo "   Flutter Path: $FLUTTER_PATH"
echo "   App Name: $APP_NAME"
echo "   Build Type: $BUILD_TYPE"

