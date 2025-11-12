#!/bin/bash
# ==================================================
# 🍎 DEPLOY TO APP STORE
# ==================================================
# Upload IPA to App Store using xcrun altool or fastlane deliver
# Usage: bash scripts/deploy_appstore.sh [ipa-path]

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

IPA_PATH="${1:-$(find "$PROJECT_ROOT/build/ios/ipa" -name "*.ipa" 2>/dev/null | head -n 1)}"

echo "🍎 Deploying to App Store"

# Check if IPA exists
if [ -z "$IPA_PATH" ] || [ ! -f "$IPA_PATH" ]; then
    echo "❌ IPA not found"
    echo "   Building release IPA first..."
    bash "$SCRIPT_DIR/release_ios.sh"
    IPA_PATH=$(find "$PROJECT_ROOT/build/ios/ipa" -name "*.ipa" | head -n 1)
fi

# Check for App Store Connect API key
if [ ! -f "$IOS_APPSTORE_API_KEY" ]; then
    echo "❌ App Store Connect API key not found at $IOS_APPSTORE_API_KEY"
    echo "   Download from App Store Connect and place in .secrets/ios/"
    exit 1
fi

# Method 1: Using fastlane deliver (if installed)
if command -v fastlane &> /dev/null && [ -f "$PROJECT_ROOT/ios/fastlane/Fastfile" ]; then
    echo "🚀 Using fastlane deliver..."
    cd "$PROJECT_ROOT/ios"
    fastlane deliver \
        --ipa "$IPA_PATH" \
        --skip_screenshots \
        --skip_metadata \
        --force \
        --api_key_path "$IOS_APPSTORE_API_KEY" \
        --api_key_id "$IOS_APPSTORE_KEY_ID" \
        --api_issuer "$IOS_APPSTORE_ISSUER_ID"
    echo "✅ Deployment via fastlane complete"
    
# Method 2: Using xcrun altool (deprecated but still works)
elif command -v xcrun &> /dev/null; then
    echo "🚀 Using xcrun altool..."
    
    if [ -z "$IOS_APPSTORE_KEY_ID" ] || [ -z "$IOS_APPSTORE_ISSUER_ID" ]; then
        echo "❌ IOS_APPSTORE_KEY_ID and IOS_APPSTORE_ISSUER_ID must be set"
        exit 1
    fi
    
    xcrun altool --upload-app \
        --type ios \
        --file "$IPA_PATH" \
        --apiKey "$IOS_APPSTORE_KEY_ID" \
        --apiIssuer "$IOS_APPSTORE_ISSUER_ID" \
        || {
        echo "❌ Upload failed"
        exit 1
    }
    echo "✅ Deployment via altool complete"
    
# Method 3: Using Transporter app (macOS only)
elif [ "$(uname)" = "Darwin" ] && [ -d "/Applications/Transporter.app" ]; then
    echo "🚀 Using Transporter app..."
    open -a Transporter "$IPA_PATH"
    echo "✅ IPA opened in Transporter"
    echo "   Complete upload manually in Transporter app"
    
# Method 4: Manual instructions
else
    echo "⚠️  fastlane, xcrun, or Transporter not available"
    echo ""
    echo "📋 Manual deployment steps:"
    echo "   1. Go to App Store Connect: https://appstoreconnect.apple.com"
    echo "   2. Select your app"
    echo "   3. Go to TestFlight or App Store > App Information"
    echo "   4. Upload IPA: $IPA_PATH"
    echo "   5. Or use Transporter app: open -a Transporter"
    echo ""
    echo "   Or install fastlane: gem install fastlane"
    exit 1
fi

echo "✅ App Store deployment complete!"
echo "   IPA: $IPA_PATH"

