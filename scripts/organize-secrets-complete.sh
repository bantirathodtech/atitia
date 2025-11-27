#!/bin/bash

# 🔄 Complete Secrets Organization Script
# Organizes all secrets into proper structure with correct file names

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECRETS_DIR="$PROJECT_ROOT/.secrets"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 COMPLETE SECRETS ORGANIZATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Create all required directories
echo "📁 Creating directory structure..."
mkdir -p "$SECRETS_DIR/android"
mkdir -p "$SECRETS_DIR/ios"
mkdir -p "$SECRETS_DIR/macos"
mkdir -p "$SECRETS_DIR/web"
mkdir -p "$SECRETS_DIR/api-keys"
mkdir -p "$SECRETS_DIR/common"
mkdir -p "$SECRETS_DIR/backups"
echo -e "${GREEN}✅${NC} Directory structure ready"
echo ""

# ============================================================================
# ANDROID: Organize and rename files
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 Organizing Android Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

ANDROID_DIR="$SECRETS_DIR/android"

# Move/copy keystore file (if exists)
if [ -f "$ANDROID_DIR/ANDROID_KEYSTORE_BASE64" ] && [ -s "$ANDROID_DIR/ANDROID_KEYSTORE_BASE64" ]; then
    echo "📝 Found keystore base64 - creating keystore.jks from base64..."
    base64 -d "$ANDROID_DIR/ANDROID_KEYSTORE_BASE64" > "$ANDROID_DIR/keystore.jks" 2>/dev/null || {
        echo -e "${YELLOW}⚠️${NC}  Could not decode base64 - keep as is"
    }
fi

# Create keystore.properties from individual files
echo "📝 Creating keystore.properties from individual files..."
cat > "$ANDROID_DIR/keystore.properties.template" << 'EOF'
storeFile=keystore.jks
storePassword=YOUR_KEYSTORE_PASSWORD_HERE
keyAlias=YOUR_KEY_ALIAS_HERE
keyPassword=YOUR_KEY_PASSWORD_HERE
EOF

# If individual files exist, merge them
if [ -f "$ANDROID_DIR/ANDROID_KEYSTORE_PASSWORD" ] && [ -s "$ANDROID_DIR/ANDROID_KEYSTORE_PASSWORD" ]; then
    STORE_PASSWORD=$(cat "$ANDROID_DIR/ANDROID_KEYSTORE_PASSWORD")
    sed -i.bak "s/storePassword=.*/storePassword=$STORE_PASSWORD/" "$ANDROID_DIR/keystore.properties.template" 2>/dev/null || \
    sed -i '' "s/storePassword=.*/storePassword=$STORE_PASSWORD/" "$ANDROID_DIR/keystore.properties.template"
fi

if [ -f "$ANDROID_DIR/ANDROID_KEY_ALIAS" ] && [ -s "$ANDROID_DIR/ANDROID_KEY_ALIAS" ]; then
    KEY_ALIAS=$(cat "$ANDROID_DIR/ANDROID_KEY_ALIAS")
    sed -i.bak "s/keyAlias=.*/keyAlias=$KEY_ALIAS/" "$ANDROID_DIR/keystore.properties.template" 2>/dev/null || \
    sed -i '' "s/keyAlias=.*/keyAlias=$KEY_ALIAS/" "$ANDROID_DIR/keystore.properties.template"
fi

if [ -f "$ANDROID_DIR/ANDROID_KEY_PASSWORD" ] && [ -s "$ANDROID_DIR/ANDROID_KEY_PASSWORD" ]; then
    KEY_PASSWORD=$(cat "$ANDROID_DIR/ANDROID_KEY_PASSWORD")
    sed -i.bak "s/keyPassword=.*/keyPassword=$KEY_PASSWORD/" "$ANDROID_DIR/keystore.properties.template" 2>/dev/null || \
    sed -i '' "s/keyPassword=.*/keyPassword=$KEY_PASSWORD/" "$ANDROID_DIR/keystore.properties.template"
fi

# Rename template to actual if it has real values
if grep -q "YOUR_" "$ANDROID_DIR/keystore.properties.template"; then
    echo "📝 Created keystore.properties.template - fill in values"
else
    mv "$ANDROID_DIR/keystore.properties.template" "$ANDROID_DIR/keystore.properties" 2>/dev/null || true
    echo -e "${GREEN}✅${NC} Created keystore.properties with values"
fi
rm -f "$ANDROID_DIR/keystore.properties.template.bak" 2>/dev/null || true

# Move service account JSON
if [ -f "$ANDROID_DIR/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON" ] && [ -s "$ANDROID_DIR/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON" ]; then
    cp "$ANDROID_DIR/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON" "$ANDROID_DIR/service_account.json"
    echo -e "${GREEN}✅${NC} Copied Google Play service account to service_account.json"
fi

# Remove Firebase service account from android (wrong location)
if [ -f "$ANDROID_DIR/FIREBASE_SERVICE_ACCOUNT" ]; then
    echo -e "${YELLOW}⚠️${NC}  Found FIREBASE_SERVICE_ACCOUNT in android/ - will move to web/"
fi

echo ""

# ============================================================================
# FIREBASE/WEB: Consolidate from multiple locations
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 Organizing Web/Firebase Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

WEB_DIR="$SECRETS_DIR/web"

# Consolidate Firebase service account (check multiple locations)
FIREBASE_SA_SOURCE=""
for path in "$ANDROID_DIR/FIREBASE_SERVICE_ACCOUNT" \
            "$SECRETS_DIR/firebase/FIREBASE_SERVICE_ACCOUNT" \
            "$WEB_DIR/FIREBASE_SERVICE_ACCOUNT"; do
    if [ -f "$path" ] && [ -s "$path" ]; then
        FIREBASE_SA_SOURCE="$path"
        break
    fi
done

if [ -n "$FIREBASE_SA_SOURCE" ]; then
    cp "$FIREBASE_SA_SOURCE" "$WEB_DIR/firebase_service_account.json"
    echo -e "${GREEN}✅${NC} Copied Firebase service account to web/firebase_service_account.json"
else
    # Create template
    cat > "$WEB_DIR/firebase_service_account.json.template" << 'EOF'
{
  "type": "service_account",
  "project_id": "atitia-87925",
  "private_key_id": "YOUR_PRIVATE_KEY_ID",
  "private_key": "-----BEGIN PRIVATE KEY-----\nYOUR_PRIVATE_KEY\n-----END PRIVATE KEY-----\n",
  "client_email": "YOUR_CLIENT_EMAIL@atitia-87925.iam.gserviceaccount.com",
  "client_id": "YOUR_CLIENT_ID",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/YOUR_CLIENT_EMAIL%40atitia-87925.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
EOF
    echo "📝 Created firebase_service_account.json.template - fill in values"
fi

# Consolidate Firebase project ID
FIREBASE_PROJECT_ID=""
for path in "$WEB_DIR/FIREBASE_PROJECT_ID" \
            "$SECRETS_DIR/firebase/FIREBASE_PROJECT_ID"; do
    if [ -f "$path" ] && [ -s "$path" ]; then
        FIREBASE_PROJECT_ID=$(cat "$path")
        break
    fi
done

if [ -n "$FIREBASE_PROJECT_ID" ]; then
    echo "$FIREBASE_PROJECT_ID" > "$WEB_DIR/firebase_project_id.txt"
    echo -e "${GREEN}✅${NC} Saved Firebase project ID: $FIREBASE_PROJECT_ID"
else
    # Get from firebase.json if exists
    if [ -f "$PROJECT_ROOT/config/firebase.json" ]; then
        PROJECT_ID=$(grep -o '"projectId": "[^"]*"' "$PROJECT_ROOT/config/firebase.json" | cut -d'"' -f4 | head -1)
        if [ -n "$PROJECT_ID" ]; then
            echo "$PROJECT_ID" > "$WEB_DIR/firebase_project_id.txt"
            echo -e "${GREEN}✅${NC} Found Firebase project ID from config: $PROJECT_ID"
        fi
    else
        echo "atitia-87925" > "$WEB_DIR/firebase_project_id.txt"
        echo "📝 Created firebase_project_id.txt with default: atitia-87925"
    fi
fi

echo ""

# ============================================================================
# iOS: Create proper file structure
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🍎 Organizing iOS Secrets"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

IOS_DIR="$SECRETS_DIR/ios"

# Create placeholder files with proper names
echo "📝 Creating iOS file structure..."

# Certificate password
if [ -f "$IOS_DIR/IOS_CERTIFICATE_PASSWORD" ] && [ -s "$IOS_DIR/IOS_CERTIFICATE_PASSWORD" ]; then
    cp "$IOS_DIR/IOS_CERTIFICATE_PASSWORD" "$IOS_DIR/certificate_password.txt"
    echo -e "${GREEN}✅${NC} Copied certificate password"
else
    cat > "$IOS_DIR/certificate_password.txt.template" << 'EOF'
YOUR_IOS_CERTIFICATE_PASSWORD_HERE
EOF
    echo "📝 Created certificate_password.txt.template"
fi

# Certificate base64 (will be decoded when actual file is added)
if [ -f "$IOS_DIR/IOS_CERTIFICATE_BASE64" ] && [ -s "$IOS_DIR/IOS_CERTIFICATE_BASE64" ]; then
    echo "📝 Found certificate base64 - decode to Certificates.p12 when ready"
fi

# Provisioning profile
if [ -f "$IOS_DIR/IOS_PROVISIONING_PROFILE_BASE64" ] && [ -s "$IOS_DIR/IOS_PROVISIONING_PROFILE_BASE64" ]; then
    echo "📝 Found provisioning profile base64 - decode to ProvisionProfile.mobileprovision when ready"
fi

# App Store Connect API Key
if [ -f "$IOS_DIR/APP_STORE_CONNECT_API_KEY" ] && [ -s "$IOS_DIR/APP_STORE_CONNECT_API_KEY" ]; then
    cp "$IOS_DIR/APP_STORE_CONNECT_API_KEY" "$IOS_DIR/AppStoreConnect_APIKey.p8"
    echo -e "${GREEN}✅${NC} Copied App Store Connect API key"
fi

# API Key ID
if [ -f "$IOS_DIR/APP_STORE_CONNECT_API_KEY_ID" ] && [ -s "$IOS_DIR/APP_STORE_CONNECT_API_KEY_ID" ]; then
    cp "$IOS_DIR/APP_STORE_CONNECT_API_KEY_ID" "$IOS_DIR/appstore_api_key_id.txt"
    echo -e "${GREEN}✅${NC} Saved API key ID"
fi

# API Issuer
if [ -f "$IOS_DIR/APP_STORE_CONNECT_API_ISSUER" ] && [ -s "$IOS_DIR/APP_STORE_CONNECT_API_ISSUER" ]; then
    cp "$IOS_DIR/APP_STORE_CONNECT_API_ISSUER" "$IOS_DIR/appstore_api_issuer.txt"
    echo -e "${GREEN}✅${NC} Saved API issuer"
fi

# Create exportOptions.plist template
cat > "$IOS_DIR/exportOptions.plist.template" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOF
echo "📝 Created exportOptions.plist.template - fill in Team ID"

echo ""

# ============================================================================
# macOS: Create proper file structure
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💻 Creating macOS Secrets Structure"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

MACOS_DIR="$SECRETS_DIR/macos"

# Create placeholder files
cat > "$MACOS_DIR/certificate_password.txt.template" << 'EOF'
YOUR_MACOS_CERTIFICATE_PASSWORD_HERE
EOF

cat > "$MACOS_DIR/exportOptions.plist.template" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>mac-application</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
EOF

echo "📝 Created macOS template files"
echo ""

# ============================================================================
# CLEANUP: Remove old GitHub Secret-named files (keep as backup)
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧹 Cleanup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Move old files to a backup folder instead of deleting
BACKUP_OLD="$SECRETS_DIR/.old-secret-files"
mkdir -p "$BACKUP_OLD"

echo "📦 Moving old GitHub Secret-named files to $BACKUP_OLD/"

# Move Android old files
for file in "$ANDROID_DIR"/ANDROID_*; do
    if [ -f "$file" ]; then
        mv "$file" "$BACKUP_OLD/" 2>/dev/null || true
    fi
done

# Move iOS old files
for file in "$IOS_DIR"/IOS_* "$IOS_DIR"/APP_STORE_*; do
    if [ -f "$file" ]; then
        mv "$file" "$BACKUP_OLD/" 2>/dev/null || true
    fi
done

# Move Firebase old files
if [ -d "$SECRETS_DIR/firebase" ]; then
    mv "$SECRETS_DIR/firebase"/* "$BACKUP_OLD/" 2>/dev/null || true
    rmdir "$SECRETS_DIR/firebase" 2>/dev/null || true
fi

echo -e "${GREEN}✅${NC} Cleanup complete"
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ORGANIZATION COMPLETE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "📁 Current structure:"
echo ""
echo "Android (.secrets/android/):"
echo "  • keystore.jks (if base64 decoded)"
echo "  • keystore.properties / keystore.properties.template"
echo "  • service_account.json"
echo ""
echo "iOS (.secrets/ios/):"
echo "  • Certificates.p12 (add when ready)"
echo "  • certificate_password.txt / .template"
echo "  • ProvisionProfile.mobileprovision (add when ready)"
echo "  • AppStoreConnect_APIKey.p8"
echo "  • exportOptions.plist.template"
echo ""
echo "Web/Firebase (.secrets/web/):"
echo "  • firebase_service_account.json"
echo "  • firebase_project_id.txt"
echo ""
echo "macOS (.secrets/macos/):"
echo "  • Templates created (add files when ready)"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 Next Steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Fill in template files (remove .template extension when done)"
echo "2. Add actual files (keystore.jks, certificates, etc.)"
echo "3. Run: bash scripts/verify-secrets-local.sh"
echo "4. Create backup: bash scripts/backup-secrets.sh"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

