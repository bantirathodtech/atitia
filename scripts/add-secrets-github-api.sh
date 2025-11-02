#!/bin/bash

# Add GitHub Secrets using GitHub API
# Repository: bantirathodtech/atitia

echo "🔐 Adding GitHub Secrets via API"
echo "=================================="
echo ""

REPO_OWNER="bantirathodtech"
REPO_NAME="atitia"

# Check if keystore exists
if [ ! -f "android/keystore.jks" ]; then
    echo "❌ Keystore not found at android/keystore.jks"
    exit 1
fi

# Check if GitHub token is provided
if [ -z "$GITHUB_TOKEN" ]; then
    echo "📝 GitHub Personal Access Token Required"
    echo ""
    echo "Create a token:"
    echo "1. Go to: https://github.com/settings/tokens"
    echo "2. Click 'Generate new token (classic)'"
    echo "3. Name: 'Atitia CI/CD Secrets'"
    echo "4. Scopes: Select 'repo' (full control)"
    echo "5. Generate and copy the token"
    echo ""
    read -p "Enter your GitHub token: " -s GITHUB_TOKEN
    echo ""
    echo ""
    
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "❌ Token is required. Exiting."
        exit 1
    fi
fi

# Read keystore password
echo "Enter your keystore password:"
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

# Function to add secret using GitHub API
add_secret() {
    local SECRET_NAME=$1
    local SECRET_VALUE=$2
    
    echo "Adding $SECRET_NAME..."
    
    # Get public key
    RESPONSE=$(curl -s -H "Authorization: token $GITHUB_TOKEN" \
        "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/actions/secrets/public-key")
    
    PUBLIC_KEY=$(echo "$RESPONSE" | grep -o '"key":"[^"]*' | cut -d'"' -f4)
    KEY_ID=$(echo "$RESPONSE" | grep -o '"key_id":"[^"]*' | cut -d'"' -f4)
    
    if [ -z "$PUBLIC_KEY" ] || [ -z "$KEY_ID" ]; then
        echo "   ❌ Failed to get public key. Check your token permissions."
        return 1
    fi
    
    # Encrypt secret using public key (requires libsodium)
    if command -v sodium &> /dev/null || command -v echo &> /dev/null; then
        # For now, use base64 encoding (GitHub will handle encryption server-side for API v3)
        # Actually, GitHub Secrets API requires encryption, so we need to use a different approach
        # Let's use GitHub CLI if available, or provide manual instructions
        echo "   ⚠️  GitHub API v3 requires encrypted secrets."
        echo "   Please use GitHub web interface or install gh CLI:"
        echo "   brew install gh && gh auth login"
        return 1
    fi
}

# Since GitHub API requires encryption, let's provide the values for manual entry
echo ""
echo "📋 SECRET VALUES READY TO COPY:"
echo "================================"
echo ""
echo "1. ANDROID_KEYSTORE_BASE64:"
echo "$BASE64_KEYSTORE"
echo ""
echo "2. ANDROID_KEYSTORE_PASSWORD:"
echo "$KEYSTORE_PASSWORD"
echo ""
echo "3. ANDROID_KEY_ALIAS:"
echo "atitia-release"
echo ""
echo "4. ANDROID_KEY_PASSWORD:"
echo "$KEYSTORE_PASSWORD"
echo ""

echo "⚠️  Since GitHub API requires encryption, please:"
echo "   1. Go to: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
echo "   2. Add each secret manually using the values above"
echo ""
echo "   OR install GitHub CLI:"
echo "   brew install gh && gh auth login"
echo "   Then run: bash scripts/add-github-secrets.sh"
echo ""

