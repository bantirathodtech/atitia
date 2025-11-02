#!/bin/bash

# Add Android Secrets to GitHub
# This script uses GitHub CLI (gh) to add secrets

echo "🔐 Adding GitHub Secrets for Android CI/CD"
echo "============================================"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) is not installed."
    echo ""
    echo "Install it first:"
    echo "  macOS: brew install gh"
    echo "  Then run: gh auth login"
    echo ""
    echo "Or add secrets manually via GitHub web interface."
    echo "See STEP2_COMPLETE_INSTRUCTIONS.md for manual steps."
    exit 1
fi

# Check if authenticated
if ! gh auth status &> /dev/null; then
    echo "❌ Not authenticated with GitHub."
    echo "Run: gh auth login"
    exit 1
fi

# Get repository name
REPO=$(gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null)
if [ -z "$REPO" ]; then
    echo "❌ Could not determine GitHub repository."
    echo "Make sure you're in a git repository and it's connected to GitHub."
    exit 1
fi

echo "Repository: $REPO"
echo ""

# Read keystore password
echo "Enter your keystore password (will be used for ANDROID_KEYSTORE_PASSWORD and ANDROID_KEY_PASSWORD):"
read -s KEYSTORE_PASSWORD
echo ""

if [ -z "$KEYSTORE_PASSWORD" ]; then
    echo "❌ Password cannot be empty."
    exit 1
fi

# Generate base64 keystore
echo "Generating base64 keystore..."
BASE64_KEYSTORE=$(base64 -i android/keystore.jks | tr -d '\n')

if [ -z "$BASE64_KEYSTORE" ]; then
    echo "❌ Failed to generate base64 keystore."
    exit 1
fi

echo ""
echo "Adding secrets to GitHub..."
echo ""

# Add ANDROID_KEYSTORE_BASE64
echo "1/4 Adding ANDROID_KEYSTORE_BASE64..."
echo "$BASE64_KEYSTORE" | gh secret set ANDROID_KEYSTORE_BASE64 -R "$REPO"
if [ $? -eq 0 ]; then
    echo "   ✅ Added"
else
    echo "   ❌ Failed"
fi

# Add ANDROID_KEYSTORE_PASSWORD
echo "2/4 Adding ANDROID_KEYSTORE_PASSWORD..."
echo "$KEYSTORE_PASSWORD" | gh secret set ANDROID_KEYSTORE_PASSWORD -R "$REPO"
if [ $? -eq 0 ]; then
    echo "   ✅ Added"
else
    echo "   ❌ Failed"
fi

# Add ANDROID_KEY_ALIAS
echo "3/4 Adding ANDROID_KEY_ALIAS..."
echo "atitia-release" | gh secret set ANDROID_KEY_ALIAS -R "$REPO"
if [ $? -eq 0 ]; then
    echo "   ✅ Added"
else
    echo "   ❌ Failed"
fi

# Add ANDROID_KEY_PASSWORD (same as keystore password)
echo "4/4 Adding ANDROID_KEY_PASSWORD..."
echo "$KEYSTORE_PASSWORD" | gh secret set ANDROID_KEY_PASSWORD -R "$REPO"
if [ $? -eq 0 ]; then
    echo "   ✅ Added"
else
    echo "   ❌ Failed"
fi

echo ""
echo "✅ All secrets added to GitHub!"
echo ""
echo "You can verify by running: gh secret list -R $REPO"
echo ""

