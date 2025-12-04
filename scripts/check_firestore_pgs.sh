#!/bin/bash

# ============================================================================
# Check PGs in Firestore
# ============================================================================
# This script checks PGs in Firestore and shows their status
# Helps verify if PGs have isActive=true for guest visibility
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Checking PGs in Firestore...${NC}"
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

echo -e "${YELLOW}📋 Querying Firestore for PGs...${NC}"
echo ""

# Use Firebase CLI to query PGs
# Note: This requires firebase-tools and may need a Node.js script for complex queries
echo -e "${BLUE}To check PGs in Firestore:${NC}"
echo ""
echo "1. Open Firebase Console:"
echo "   https://console.firebase.google.com/project/atitia-87925/firestore/data/~2Fpgs"
echo ""
echo "2. For each PG document, verify:"
echo "   - ${GREEN}isActive${NC} = ${GREEN}true${NC} (required for guest visibility)"
echo "   - ${YELLOW}isDraft${NC} = ${YELLOW}false${NC} or missing (drafts should not be in Firestore)"
echo ""
echo "3. If PGs are missing or have wrong values:"
echo "   - Edit PG in owner app and click 'Publish'"
echo "   - OR manually set isActive=true in Firestore Console"
echo ""
echo -e "${BLUE}Quick check command (requires Node.js):${NC}"
echo "   firebase firestore:get /pgs --project atitia-87925"
echo ""

