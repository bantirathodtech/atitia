#!/bin/bash
# ==================================================
# 🍎 iOS SIGNING SETUP
# ==================================================
# Manage certificates, profiles, and Xcode build configs
# Usage: bash scripts/ios_sign.sh [action]
# Actions: setup, verify (default: setup)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

ACTION="${1:-setup}"

# Setup iOS signing
setup_signing() {
    echo "🍎 Setting up iOS signing..."
    
    if [ ! -f "$IOS_CERT_PATH" ]; then
        echo "❌ Certificate not found at $IOS_CERT_PATH"
        echo "   Export your distribution certificate as .p12 from Keychain Access"
        exit 1
    fi
    
    if [ -z "$IOS_CERT_PASSWORD" ]; then
        echo "⚠️  IOS_CERT_PASSWORD not set in .env"
        read -sp "Enter certificate password: " IOS_CERT_PASSWORD
        echo
    fi
    
    # Import certificate to keychain
    echo "📥 Importing certificate to keychain..."
    security import "$IOS_CERT_PATH" \
        -k ~/Library/Keychains/login.keychain-db \
        -P "$IOS_CERT_PASSWORD" \
        -T /usr/bin/codesign \
        -T /usr/bin/security || echo "⚠️  Certificate import failed (may already exist)"
    
    # Install provisioning profile
    if [ -f "$IOS_PROVISION_PROFILE" ]; then
        echo "📥 Installing provisioning profile..."
        mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
        PROFILE_UUID=$(/usr/libexec/PlistBuddy -c "Print UUID" /dev/stdin <<< $(security cms -D -i "$IOS_PROVISION_PROFILE"))
        cp "$IOS_PROVISION_PROFILE" ~/Library/MobileDevice/Provisioning\ Profiles/"$PROFILE_UUID.mobileprovision"
        echo "✅ Provisioning profile installed: $PROFILE_UUID"
    else
        echo "⚠️  Provisioning profile not found at $IOS_PROVISION_PROFILE"
    fi
    
    # Verify code signing identity
    echo "🔍 Verifying code signing identity..."
    security find-identity -v -p codesigning | grep "iPhone Distribution" || echo "⚠️  No distribution identity found"
    
    echo "✅ iOS signing setup complete"
}

# Verify signing setup
verify_signing() {
    echo "🔍 Verifying iOS signing setup..."
    
    local errors=0
    
    if [ ! -f "$IOS_CERT_PATH" ]; then
        echo "❌ Certificate not found: $IOS_CERT_PATH"
        errors=$((errors + 1))
    else
        echo "✅ Certificate found"
    fi
    
    if [ ! -f "$IOS_PROVISION_PROFILE" ]; then
        echo "⚠️  Provisioning profile not found: $IOS_PROVISION_PROFILE"
    else
        echo "✅ Provisioning profile found"
    fi
    
    # Check for code signing identity
    if security find-identity -v -p codesigning | grep -q "iPhone Distribution"; then
        echo "✅ Code signing identity found"
    else
        echo "❌ No distribution code signing identity found"
        errors=$((errors + 1))
    fi
    
    # Check for provisioning profiles
    PROFILE_COUNT=$(ls -1 ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision 2>/dev/null | wc -l)
    if [ "$PROFILE_COUNT" -gt 0 ]; then
        echo "✅ Found $PROFILE_COUNT provisioning profile(s)"
    else
        echo "⚠️  No provisioning profiles installed"
    fi
    
    if [ $errors -eq 0 ]; then
        echo "✅ iOS signing setup verified"
    else
        echo "❌ Found $errors issue(s)"
        exit 1
    fi
}

# Execute action
case $ACTION in
    setup)
        setup_signing
        ;;
    verify)
        verify_signing
        ;;
    *)
        echo "❌ Unknown action: $ACTION"
        echo "   Usage: bash scripts/ios_sign.sh [setup|verify]"
        exit 1
        ;;
esac

