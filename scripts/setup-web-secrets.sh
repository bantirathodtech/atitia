#!/bin/bash

# Script to help set up Firebase service account for GitHub Secrets

echo "🌐 Firebase Web Deployment Setup Helper"
echo "======================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "${BLUE}This script will help you prepare Firebase secrets for GitHub Actions.${NC}"
echo ""

echo "${GREEN}Step 1: Get Firebase Service Account JSON${NC}"
echo "---------------------------------------------------"
echo "1. Go to: https://console.firebase.google.com"
echo "2. Select project: ${BLUE}atitia-87925${NC}"
echo "3. Click gear icon (⚙️) → Project Settings"
echo "4. Go to 'Service Accounts' tab"
echo "5. Click 'Generate new private key'"
echo "6. Click 'Generate key' in the dialog"
echo "7. JSON file will download automatically"
echo ""
read -p "Enter path to downloaded Firebase service account JSON file (or press Enter to skip): " JSON_PATH

if [ -n "$JSON_PATH" ] && [ -f "$JSON_PATH" ]; then
    echo ""
    echo "${GREEN}✅ Reading Firebase service account JSON...${NC}"
    
    # Validate JSON
    if ! python3 -m json.tool "$JSON_PATH" > /dev/null 2>&1; then
        echo "${YELLOW}⚠️  Warning: File doesn't appear to be valid JSON${NC}"
    else
        JSON_CONTENT=$(cat "$JSON_PATH")
        echo "$JSON_CONTENT" | pbcopy
        echo "${GREEN}✅ Firebase service account JSON copied to clipboard!${NC}"
        echo "${BLUE}💡 Paste this entire JSON into GitHub Secret: FIREBASE_SERVICE_ACCOUNT${NC}"
        echo ""
        
        # Extract project ID
        PROJECT_ID=$(python3 -c "import json, sys; print(json.load(sys.stdin)['project_id'])" < "$JSON_PATH" 2>/dev/null)
        if [ -n "$PROJECT_ID" ]; then
            echo "${BLUE}💡 Project ID: ${PROJECT_ID}${NC}"
            echo "${BLUE}💡 Use this for GitHub Secret: FIREBASE_PROJECT_ID${NC}"
        fi
    fi
    echo ""
else
    echo "${YELLOW}⚠️  Skipped JSON setup${NC}"
    echo ""
fi

echo "${GREEN}Step 2: Verify Firebase Hosting${NC}"
echo "----------------------------------------"
echo "Checking if Firebase Hosting is initialized..."
echo ""

if [ -f "firebase.json" ]; then
    echo "${GREEN}✅ firebase.json found${NC}"
    
    # Check if hosting is configured
    if grep -q "hosting" firebase.json; then
        echo "${GREEN}✅ Firebase Hosting is configured${NC}"
    else
        echo "${YELLOW}⚠️  Firebase Hosting not configured in firebase.json${NC}"
        echo ""
        read -p "Would you like to initialize Firebase Hosting now? (y/n): " INIT_HOSTING
        if [ "$INIT_HOSTING" = "y" ] || [ "$INIT_HOSTING" = "Y" ]; then
            echo ""
            echo "${BLUE}Running: firebase init hosting${NC}"
            echo "${BLUE}Follow the prompts:${NC}"
            echo "  - Select project: atitia-87925"
            echo "  - Public directory: build/web"
            echo "  - Single-page app: Yes"
            echo ""
            firebase init hosting
        fi
    fi
else
    echo "${YELLOW}⚠️  firebase.json not found${NC}"
    echo ""
    read -p "Would you like to initialize Firebase Hosting now? (y/n): " INIT_HOSTING
    if [ "$INIT_HOSTING" = "y" ] || [ "$INIT_HOSTING" = "Y" ]; then
        echo ""
        echo "${BLUE}Installing Firebase CLI (if needed)...${NC}"
        if ! command -v firebase &> /dev/null; then
            npm install -g firebase-tools
        fi
        echo ""
        echo "${BLUE}Running: firebase init hosting${NC}"
        firebase init hosting
    fi
fi

echo ""
echo "${GREEN}✅ Setup Complete!${NC}"
echo ""
echo "${BLUE}Next Steps:${NC}"
echo "1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions"
echo "2. Add secrets:"
echo "   - FIREBASE_SERVICE_ACCOUNT (entire JSON content from clipboard)"
echo "   - FIREBASE_PROJECT_ID (atitia-87925)"
echo "3. Refer to: IOS_WEB_DEPLOYMENT_SETUP.md for complete guide"
echo ""

