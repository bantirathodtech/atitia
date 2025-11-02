#!/bin/bash

# Script to help extract iOS certificate and provisioning profile for GitHub Secrets
# Run this script on macOS to help convert iOS credentials to base64

echo "🍎 iOS Secrets Setup Helper"
echo "=========================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${BLUE}This script will help you prepare iOS secrets for GitHub Actions.${NC}"
echo ""

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "${YELLOW}⚠️  Warning: This script is designed for macOS${NC}"
    echo "You can still convert files manually using base64 command."
    exit 1
fi

echo "${GREEN}Step 1: Certificate (.p12)${NC}"
echo "-----------------------------------"
echo "1. Open Keychain Access (Cmd+Space → 'Keychain Access')"
echo "2. Select 'Login' keychain"
echo "3. Find certificate: 'Apple Distribution' or 'iPhone Distribution'"
echo "4. Right-click → Export → Choose .p12 format"
echo "5. Enter password when prompted"
echo ""
read -p "Enter path to .p12 certificate file (or press Enter to skip): " CERT_PATH

if [ -n "$CERT_PATH" ] && [ -f "$CERT_PATH" ]; then
    echo ""
    echo "${GREEN}✅ Converting certificate to base64...${NC}"
    CERT_BASE64=$(base64 -i "$CERT_PATH")
    echo "$CERT_BASE64" | pbcopy
    echo "${GREEN}✅ Certificate base64 copied to clipboard!${NC}"
    echo "${BLUE}💡 Paste this into GitHub Secret: IOS_CERTIFICATE_BASE64${NC}"
    echo ""
    read -p "Enter the password you used when exporting the certificate: " CERT_PASSWORD
    echo "${BLUE}💡 Use this password for GitHub Secret: IOS_CERTIFICATE_PASSWORD${NC}"
    echo "${BLUE}   Password: ${CERT_PASSWORD}${NC}"
    echo ""
else
    echo "${YELLOW}⚠️  Skipped certificate conversion${NC}"
    echo ""
fi

echo "${GREEN}Step 2: Provisioning Profile (.mobileprovision)${NC}"
echo "------------------------------------------------------"
echo "1. In Xcode: Preferences → Accounts → Download Manual Profiles"
echo "2. Find profile for: com.avishio.atitia"
echo ""
read -p "Enter path to .mobileprovision file (or press Enter to skip): " PROFILE_PATH

if [ -n "$PROFILE_PATH" ] && [ -f "$PROFILE_PATH" ]; then
    echo ""
    echo "${GREEN}✅ Converting provisioning profile to base64...${NC}"
    PROFILE_BASE64=$(base64 -i "$PROFILE_PATH")
    echo "$PROFILE_BASE64" | pbcopy
    echo "${GREEN}✅ Provisioning profile base64 copied to clipboard!${NC}"
    echo "${BLUE}💡 Paste this into GitHub Secret: IOS_PROVISIONING_PROFILE_BASE64${NC}"
    echo ""
else
    echo "${YELLOW}⚠️  Skipped provisioning profile conversion${NC}"
    echo ""
fi

echo "${GREEN}Step 3: App Store Connect API Key (.p8)${NC}"
echo "------------------------------------------------"
echo "1. Go to: https://appstoreconnect.apple.com"
echo "2. Users and Access → Keys → App Store Connect API"
echo "3. Generate new key and download .p8 file"
echo ""
read -p "Enter path to .p8 API key file (or press Enter to skip): " API_KEY_PATH

if [ -n "$API_KEY_PATH" ] && [ -f "$API_KEY_PATH" ]; then
    echo ""
    echo "${GREEN}✅ Converting API key to base64...${NC}"
    API_KEY_BASE64=$(base64 -i "$API_KEY_PATH")
    echo "$API_KEY_BASE64" | pbcopy
    echo "${GREEN}✅ API key base64 copied to clipboard!${NC}"
    echo "${BLUE}💡 Paste this into GitHub Secret: APP_STORE_CONNECT_API_KEY${NC}"
    echo ""
    echo "${BLUE}💡 Also note down:${NC}"
    echo "   - Key ID: (from App Store Connect, e.g., ABC123DEF4)"
    echo "   - Issuer ID: (from App Store Connect, UUID format)"
    echo ""
else
    echo "${YELLOW}⚠️  Skipped API key conversion${NC}"
    echo ""
fi

echo ""
echo "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "${BLUE}Next Steps:${NC}"
echo "1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo "2. Add all the secrets (values are in clipboard/mentioned above)"
echo "3. Refer to: IOS_WEB_DEPLOYMENT_SETUP.md for complete guide"
echo ""

