#!/bin/bash

# ============================================================================
# Deploy Firestore Rules and Indexes
# ============================================================================
# This script deploys Firestore security rules and indexes to Firebase
# 
# Usage:
#   ./scripts/deploy_firestore.sh
#   ./scripts/deploy_firestore.sh --only-rules
#   ./scripts/deploy_firestore.sh --only-indexes
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

cd "$PROJECT_ROOT"

echo -e "${GREEN}🚀 Deploying Firestore Rules and Indexes${NC}"
echo ""

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI is not installed${NC}"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

# Check if user is logged in
if ! firebase projects:list &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not logged in to Firebase${NC}"
    echo "Logging in..."
    firebase login
fi

# Check if firebase.json exists
if [ ! -f "firebase.json" ]; then
    echo -e "${RED}❌ firebase.json not found${NC}"
    exit 1
fi

# Parse arguments
DEPLOY_RULES=true
DEPLOY_INDEXES=true

if [ "$1" == "--only-rules" ]; then
    DEPLOY_INDEXES=false
elif [ "$1" == "--only-indexes" ]; then
    DEPLOY_RULES=false
fi

# Deploy Firestore Rules
if [ "$DEPLOY_RULES" = true ]; then
    echo -e "${GREEN}📋 Deploying Firestore Rules...${NC}"
    if firebase deploy --only firestore:rules; then
        echo -e "${GREEN}✅ Firestore rules deployed successfully${NC}"
    else
        echo -e "${RED}❌ Failed to deploy Firestore rules${NC}"
        exit 1
    fi
    echo ""
fi

# Deploy Firestore Indexes
if [ "$DEPLOY_INDEXES" = true ]; then
    echo -e "${GREEN}📊 Deploying Firestore Indexes...${NC}"
    if firebase deploy --only firestore:indexes; then
        echo -e "${GREEN}✅ Firestore indexes deployed successfully${NC}"
        echo -e "${YELLOW}ℹ️  Note: Index creation may take a few minutes${NC}"
        echo -e "${YELLOW}   Check status at: https://console.firebase.google.com/project/atitia-87925/firestore/indexes${NC}"
    else
        echo -e "${RED}❌ Failed to deploy Firestore indexes${NC}"
        exit 1
    fi
    echo ""
fi

echo -e "${GREEN}✨ Deployment complete!${NC}"

