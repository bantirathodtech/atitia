#!/bin/bash

# ============================================================================
# Firestore Indexes Deployment Script
# ============================================================================
# Deploys Firestore composite indexes to Firebase
# 
# Usage:
#   ./scripts/deploy/firestore_deploy_indexes.sh
#
# Prerequisites:
#   - Firebase CLI installed: npm install -g firebase-tools
#   - Firebase project configured: firebase login && firebase use <project-id>
#   - Firebase project ID in .firebaserc
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Deploying Firestore Indexes...${NC}"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI not found!${NC}"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if firebase.json exists
if [ ! -f "config/firebase.json" ]; then
    echo -e "${RED}❌ config/firebase.json not found!${NC}"
    exit 1
fi

# Check if firestore.indexes.json exists
if [ ! -f "config/firestore.indexes.json" ]; then
    echo -e "${RED}❌ config/firestore.indexes.json not found!${NC}"
    exit 1
fi

# Get project ID
PROJECT_ID=$(grep -o '"default": "[^"]*"' .firebaserc | cut -d'"' -f4)

if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}❌ Could not determine Firebase project ID from .firebaserc${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Project: ${PROJECT_ID}${NC}"
echo ""

# Deploy indexes (must run from config directory where firebase.json is located)
echo -e "${GREEN}📤 Deploying Firestore indexes...${NC}"
cd config || exit 1
firebase deploy --only firestore:indexes --project "$PROJECT_ID"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Firestore indexes deployed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}ℹ️  Note: Index creation can take several minutes.${NC}"
    echo -e "${YELLOW}   Check status at: https://console.firebase.google.com/project/${PROJECT_ID}/firestore/indexes${NC}"
else
    echo ""
    echo -e "${RED}❌ Failed to deploy Firestore indexes${NC}"
    exit 1
fi

