#!/bin/bash

# Generate Base64 encoded keystore for GitHub Secrets
# This is needed for CI/CD automated deployment

echo "🔐 Generate Keystore Base64 for GitHub Secrets"
echo "================================================"
echo ""

if [ ! -f "android/keystore.jks" ]; then
    echo "❌ Keystore file not found at android/keystore.jks"
    echo "   Please run scripts/setup-android-signing.sh first"
    exit 1
fi

echo "Generating base64 encoded keystore..."
echo ""
echo "Copy the output below and add it as ANDROID_KEYSTORE_BASE64 in GitHub Secrets:"
echo "---"
base64 -i android/keystore.jks | tr -d '\n'
echo ""
echo "---"
echo ""
echo "✅ Base64 encoding complete!"
echo ""
echo "⚠️  SECURITY WARNING:"
echo "   - This base64 string contains your keystore"
echo "   - Only add it to GitHub Secrets (never commit to code)"
echo "   - Keep it secure and don't share publicly"

