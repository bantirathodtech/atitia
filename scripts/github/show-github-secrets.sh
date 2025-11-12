#!/bin/bash

# Display all GitHub Secrets values ready to copy
# Reads password from key.properties

echo "🔐 GitHub Secrets - Ready to Copy"
echo "=================================="
echo ""
echo "Repository: bantirathodtech/atitia"
echo "URL: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo ""

# Check files exist
if [ ! -f "android/keystore.jks" ]; then
    echo "❌ Keystore not found at android/keystore.jks"
    exit 1
fi

if [ ! -f "android/key.properties" ]; then
    echo "❌ key.properties not found at android/key.properties"
    exit 1
fi

# Read password from key.properties
KEYSTORE_PASSWORD=$(grep "^storePassword=" android/key.properties | cut -d'=' -f2)
KEY_PASSWORD=$(grep "^keyPassword=" android/key.properties | cut -d'=' -f2)

if [ -z "$KEYSTORE_PASSWORD" ]; then
    echo "❌ Could not read password from key.properties"
    exit 1
fi

# Generate base64
BASE64_KEYSTORE=$(base64 -i android/keystore.jks | tr -d '\n')

if [ -z "$BASE64_KEYSTORE" ]; then
    echo "❌ Failed to generate base64 keystore"
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
echo "$KEY_PASSWORD"
echo ""
echo ""
echo "✅ All values ready!"
echo ""
echo "📝 Next Steps:"
echo "   1. Open: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo "   2. Click 'New repository secret' 4 times"
echo "   3. Add each secret name and value from above"
echo ""

