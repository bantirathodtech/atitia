#!/bin/bash

# Prepare all GitHub Secrets values for easy copying

echo "🔐 GitHub Secrets - Ready to Copy"
echo "=================================="
echo ""
echo "Repository: bantirathodtech/atitia"
echo "URL: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo ""

# Check if keystore exists
if [ ! -f "android/keystore.jks" ]; then
    echo "❌ Keystore not found. Please create it first."
    exit 1
fi

# Generate base64
BASE64_KEYSTORE=$(base64 -i android/keystore.jks | tr -d '\n')

# Read password
echo "Enter your keystore password (for secrets):"
read -s KEYSTORE_PASSWORD
echo ""
echo ""

if [ -z "$KEYSTORE_PASSWORD" ]; then
    echo "❌ Password required."
    exit 1
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SECRET 1: ANDROID_KEYSTORE_BASE64"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "$BASE64_KEYSTORE"
echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SECRET 2: ANDROID_KEYSTORE_PASSWORD"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "$KEYSTORE_PASSWORD"
echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SECRET 3: ANDROID_KEY_ALIAS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "atitia-release"
echo ""
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  SECRET 4: ANDROID_KEY_PASSWORD"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "$KEYSTORE_PASSWORD"
echo ""
echo ""
echo "✅ All values ready! Copy each value above to GitHub."
echo ""
echo "📝 Quick Steps:"
echo "1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo "2. Click 'New repository secret' for each of the 4 secrets above"
echo ""

