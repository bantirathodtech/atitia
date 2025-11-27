#!/bin/bash

# 🔐 Local Secrets Verification Script
# This script checks your local .secrets folder and maps to GitHub Secrets

set -e

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 LOCAL SECRETS VERIFICATION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SECRETS_DIR="$PROJECT_ROOT/.secrets"

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
ANDROID_LOCAL=0
ANDROID_REQUIRED=5
IOS_LOCAL=0
IOS_REQUIRED=6
WEB_LOCAL=0
WEB_REQUIRED=2

echo "📁 Checking secrets in: $SECRETS_DIR"
echo ""

# ============================================================================
# ANDROID SECRETS CHECK
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 ANDROID SECRETS (Required: $ANDROID_REQUIRED)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# 1. Check keystore.jks
if [ -f "$SECRETS_DIR/android/keystore.jks" ]; then
    SIZE=$(du -h "$SECRETS_DIR/android/keystore.jks" | cut -f1)
    echo -e "${GREEN}✅${NC} keystore.jks found ($SIZE)"
    echo "   → GitHub Secret: ANDROID_KEYSTORE_BASE64"
    echo "   → Action: base64 encode this file"
    ANDROID_LOCAL=$((ANDROID_LOCAL + 1))
else
    echo -e "${RED}❌${NC} keystore.jks NOT FOUND"
    echo "   → GitHub Secret: ANDROID_KEYSTORE_BASE64"
    echo "   → Expected: .secrets/android/keystore.jks"
fi
echo ""

# 2. Check keystore.properties
if [ -f "$SECRETS_DIR/android/keystore.properties" ]; then
    echo -e "${GREEN}✅${NC} keystore.properties found"
    
    # Extract values
    STORE_PASSWORD=$(grep "^storePassword=" "$SECRETS_DIR/android/keystore.properties" | cut -d'=' -f2- || echo "")
    KEY_ALIAS=$(grep "^keyAlias=" "$SECRETS_DIR/android/keystore.properties" | cut -d'=' -f2- || echo "")
    KEY_PASSWORD=$(grep "^keyPassword=" "$SECRETS_DIR/android/keystore.properties" | cut -d'=' -f2- || echo "")
    
    if [ -n "$STORE_PASSWORD" ]; then
        echo -e "   ${GREEN}✅${NC} storePassword found"
        echo "      → GitHub Secret: ANDROID_KEYSTORE_PASSWORD"
        ANDROID_LOCAL=$((ANDROID_LOCAL + 1))
    else
        echo -e "   ${RED}❌${NC} storePassword NOT FOUND in keystore.properties"
    fi
    
    if [ -n "$KEY_ALIAS" ]; then
        echo -e "   ${GREEN}✅${NC} keyAlias found: $KEY_ALIAS"
        echo "      → GitHub Secret: ANDROID_KEY_ALIAS"
        ANDROID_LOCAL=$((ANDROID_LOCAL + 1))
    else
        echo -e "   ${RED}❌${NC} keyAlias NOT FOUND in keystore.properties"
    fi
    
    if [ -n "$KEY_PASSWORD" ]; then
        echo -e "   ${GREEN}✅${NC} keyPassword found"
        echo "      → GitHub Secret: ANDROID_KEY_PASSWORD"
        ANDROID_LOCAL=$((ANDROID_LOCAL + 1))
    else
        echo -e "   ${RED}❌${NC} keyPassword NOT FOUND in keystore.properties"
    fi
else
    echo -e "${RED}❌${NC} keystore.properties NOT FOUND"
    echo "   → GitHub Secrets: ANDROID_KEYSTORE_PASSWORD, ANDROID_KEY_ALIAS, ANDROID_KEY_PASSWORD"
    echo "   → Expected: .secrets/android/keystore.properties"
fi
echo ""

# 3. Check service_account.json
if [ -f "$SECRETS_DIR/android/service_account.json" ]; then
    SIZE=$(du -h "$SECRETS_DIR/android/service_account.json" | cut -f1)
    echo -e "${GREEN}✅${NC} service_account.json found ($SIZE)"
    echo "   → GitHub Secret: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
    echo "   → Action: Copy entire JSON content"
    ANDROID_LOCAL=$((ANDROID_LOCAL + 1))
else
    echo -e "${RED}❌${NC} service_account.json NOT FOUND"
    echo "   → GitHub Secret: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON"
    echo "   → Expected: .secrets/android/service_account.json"
fi
echo ""

echo "Android Summary: $ANDROID_LOCAL/$ANDROID_REQUIRED secrets found locally"
echo ""

# ============================================================================
# iOS SECRETS CHECK (Optional - for future)
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🍎 iOS SECRETS (Required: $IOS_REQUIRED) - OPTIONAL"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "$SECRETS_DIR/ios/Certificates.p12" ]; then
    SIZE=$(du -h "$SECRETS_DIR/ios/Certificates.p12" | cut -f1)
    echo -e "${GREEN}✅${NC} Certificates.p12 found ($SIZE)"
    echo "   → GitHub Secret: IOS_CERTIFICATE_BASE64"
    IOS_LOCAL=$((IOS_LOCAL + 1))
else
    echo -e "${YELLOW}⏸️${NC}  Certificates.p12 not found (iOS not configured yet)"
    echo "   → GitHub Secret: IOS_CERTIFICATE_BASE64"
fi
echo ""

echo "iOS Summary: $IOS_LOCAL/$IOS_REQUIRED secrets found locally (not required yet)"
echo ""

# ============================================================================
# WEB/FIREBASE SECRETS CHECK
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 WEB/FIREBASE SECRETS (Required: $WEB_REQUIRED)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check Firebase service account (multiple possible locations)
FIREBASE_SA_FOUND=false
for path in "$SECRETS_DIR/common/firebase_service_account.json" \
            "$SECRETS_DIR/common/firebase-service-account.json" \
            "$SECRETS_DIR/common/firebase.json"; do
    if [ -f "$path" ]; then
        SIZE=$(du -h "$path" | cut -f1)
        echo -e "${GREEN}✅${NC} Firebase service account found: $(basename "$path") ($SIZE)"
        echo "   → GitHub Secret: FIREBASE_SERVICE_ACCOUNT"
        echo "   → Action: Copy entire JSON content"
        WEB_LOCAL=$((WEB_LOCAL + 1))
        FIREBASE_SA_FOUND=true
        break
    fi
done

if [ "$FIREBASE_SA_FOUND" = false ]; then
    echo -e "${RED}❌${NC} Firebase service account NOT FOUND"
    echo "   → GitHub Secret: FIREBASE_SERVICE_ACCOUNT"
    echo "   → Expected: .secrets/common/firebase_service_account.json"
    echo "   → OR check: config/firebase.json"
fi
echo ""

# Check Firebase Project ID
if [ -f "$SECRETS_DIR/common/.env" ]; then
    FIREBASE_PROJECT_ID=$(grep "^FIREBASE_PROJECT_ID=" "$SECRETS_DIR/common/.env" | cut -d'=' -f2- | tr -d '"' || echo "")
    if [ -n "$FIREBASE_PROJECT_ID" ]; then
        echo -e "${GREEN}✅${NC} FIREBASE_PROJECT_ID found in .env: $FIREBASE_PROJECT_ID"
        echo "   → GitHub Secret: FIREBASE_PROJECT_ID"
        WEB_LOCAL=$((WEB_LOCAL + 1))
    else
        echo -e "${YELLOW}⚠️${NC}  FIREBASE_PROJECT_ID not found in .env"
        echo "   → Check config/firebase.json instead"
    fi
elif [ -f "$PROJECT_ROOT/config/firebase.json" ]; then
    if grep -q "projectId" "$PROJECT_ROOT/config/firebase.json"; then
        PROJECT_ID=$(grep -o '"projectId": "[^"]*"' "$PROJECT_ROOT/config/firebase.json" | cut -d'"' -f4 || echo "")
        if [ -n "$PROJECT_ID" ]; then
            echo -e "${GREEN}✅${NC} FIREBASE_PROJECT_ID found in firebase.json: $PROJECT_ID"
            echo "   → GitHub Secret: FIREBASE_PROJECT_ID"
            WEB_LOCAL=$((WEB_LOCAL + 1))
        fi
    fi
else
    echo -e "${RED}❌${NC} FIREBASE_PROJECT_ID source not found"
    echo "   → Check: .secrets/common/.env OR config/firebase.json"
fi
echo ""

echo "Web/Firebase Summary: $WEB_LOCAL/$WEB_REQUIRED secrets found locally"
echo ""

# ============================================================================
# SUMMARY
# ============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ "$ANDROID_LOCAL" -eq "$ANDROID_REQUIRED" ]; then
    echo -e "${GREEN}✅ ANDROID: $ANDROID_LOCAL/$ANDROID_REQUIRED secrets found${NC}"
else
    echo -e "${RED}❌ ANDROID: $ANDROID_LOCAL/$ANDROID_REQUIRED secrets found${NC}"
    echo "   Missing: $((ANDROID_REQUIRED - ANDROID_LOCAL)) secrets"
fi

if [ "$WEB_LOCAL" -eq "$WEB_REQUIRED" ]; then
    echo -e "${GREEN}✅ WEB/FIREBASE: $WEB_LOCAL/$WEB_REQUIRED secrets found${NC}"
else
    echo -e "${RED}❌ WEB/FIREBASE: $WEB_LOCAL/$WEB_REQUIRED secrets found${NC}"
    echo "   Missing: $((WEB_REQUIRED - WEB_LOCAL)) secrets"
fi

echo -e "${YELLOW}⏸️  iOS: $IOS_LOCAL/$IOS_REQUIRED secrets found (optional for now)${NC}"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 NEXT STEPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. Ensure all local secrets are in .secrets/ folder"
echo "2. Add secrets to GitHub:"
echo "   https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo ""
echo "3. After adding, the verify-deployment-secrets job will check them"
echo "   automatically in the production pipeline"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

