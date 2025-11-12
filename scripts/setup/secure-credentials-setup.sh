#!/bin/bash
# 🔐 Secure Credentials Setup Script
# Sets up secure storage for Google OAuth client secret JSON file

set -e

echo "🔐 Setting up secure credentials storage..."

# Use project .secrets directory (recommended)
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CREDENTIALS_DIR="$PROJECT_ROOT/.secrets/google-oauth"

# Ensure .secrets directory exists with proper permissions
mkdir -p "$PROJECT_ROOT/.secrets"
chmod 700 "$PROJECT_ROOT/.secrets"
mkdir -p "$CREDENTIALS_DIR"
chmod 700 "$CREDENTIALS_DIR"

echo "✅ Using secure project directory: $CREDENTIALS_DIR"

# Check if JSON file exists in Downloads
DOWNLOADS_DIR="$HOME/Downloads"
JSON_FILE=$(find "$DOWNLOADS_DIR" -name "client_secret_*665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj*" -type f 2>/dev/null | head -1)

if [ -n "$JSON_FILE" ]; then
    echo "📁 Found JSON file: $JSON_FILE"
    
    # Move to secure location
    TARGET_FILE="$CREDENTIALS_DIR/client_secret_google_oauth.json"
    mv "$JSON_FILE" "$TARGET_FILE"
    
    # Set restrictive permissions (owner read/write only)
    chmod 600 "$TARGET_FILE"
    
    echo "✅ Moved to secure location: $TARGET_FILE"
    echo "✅ Set permissions to 600 (owner read/write only)"
    
    # Extract client secret if jq is available
    if command -v jq &> /dev/null; then
        CLIENT_SECRET=$(jq -r '.web.client_secret' "$TARGET_FILE" 2>/dev/null)
        if [ -n "$CLIENT_SECRET" ] && [ "$CLIENT_SECRET" != "null" ]; then
            echo ""
            echo "🔑 Extracted Client Secret:"
            echo "   $CLIENT_SECRET"
            echo ""
            echo "📝 Update this in: lib/common/constants/environment_config.dart:153"
        fi
    else
        echo "💡 Install 'jq' to automatically extract client secret:"
        echo "   brew install jq  # macOS"
        echo "   sudo apt install jq  # Ubuntu/Debian"
    fi
else
    echo "⚠️  JSON file not found in Downloads"
    echo "   Please manually move the file to: $CREDENTIALS_DIR/"
    echo "   File pattern: client_secret_*665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj*"
    echo ""
    echo "   Or run:"
    echo "   mv ~/Downloads/client_secret_*.json $CREDENTIALS_DIR/client_secret_google_oauth.json"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📚 Documentation:"
echo "   - SECURE_CREDENTIALS_SETUP.md (main guide)"
echo "   - .secrets/README.md (directory documentation)"
echo "   - GOOGLE_CLIENT_SECRET_JSON_STORAGE.md"
echo "   - CREDENTIALS_STATUS.md"
echo "   - QUICK_CREDENTIALS_REFERENCE.md"

