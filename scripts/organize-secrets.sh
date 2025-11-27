#!/bin/bash

# 🔄 Secrets Organization Script
# Helps organize and verify all secrets are in correct locations

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
echo "🔄 SECRETS ORGANIZATION CHECK"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Ensure all required directories exist
echo "📁 Creating directory structure..."
mkdir -p "$SECRETS_DIR/android"
mkdir -p "$SECRETS_DIR/ios"
mkdir -p "$SECRETS_DIR/macos"
mkdir -p "$SECRETS_DIR/web"
mkdir -p "$SECRETS_DIR/api-keys"
mkdir -p "$SECRETS_DIR/common"
mkdir -p "$SECRETS_DIR/backups"
echo "✅ Directory structure ready"
echo ""

# Check for misplaced files
echo "🔍 Checking for misplaced secret files..."
echo ""

MISPLACED=0

# Check for keystore files outside android/
if find "$PROJECT_ROOT" -name "*.jks" -o -name "keystore.properties" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" > /dev/null; then
    echo -e "${YELLOW}⚠️  Found keystore files outside .secrets/android/${NC}"
    find "$PROJECT_ROOT" -name "*.jks" -o -name "keystore.properties" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" | while read -r file; do
        echo "   $file"
        MISPLACED=$((MISPLACED + 1))
    done
    echo ""
fi

# Check for certificate files outside ios/macos/
if find "$PROJECT_ROOT" -name "*.p12" -o -name "*.mobileprovision" -o -name "*.provisionprofile" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" > /dev/null; then
    echo -e "${YELLOW}⚠️  Found certificate files outside .secrets/ios/ or .secrets/macos/${NC}"
    find "$PROJECT_ROOT" -name "*.p12" -o -name "*.mobileprovision" -o -name "*.provisionprofile" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" | while read -r file; do
        echo "   $file"
        MISPLACED=$((MISPLACED + 1))
    done
    echo ""
fi

# Check for service account files outside secrets/
if find "$PROJECT_ROOT" -name "service_account.json" -o -name "*service-account*.json" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" | grep -v "node_modules/" > /dev/null; then
    echo -e "${YELLOW}⚠️  Found service account files outside .secrets/${NC}"
    find "$PROJECT_ROOT" -name "service_account.json" -o -name "*service-account*.json" | grep -v ".secrets" | grep -v ".git" | grep -v "build/" | grep -v "node_modules/" | while read -r file; do
        echo "   $file"
        MISPLACED=$((MISPLACED + 1))
    done
    echo ""
fi

if [ "$MISPLACED" -eq 0 ]; then
    echo -e "${GREEN}✅ No misplaced secret files found${NC}"
    echo ""
fi

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 ORGANIZATION SUMMARY"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

echo "Directory structure:"
echo "  ✅ .secrets/android/"
echo "  ✅ .secrets/ios/"
echo "  ✅ .secrets/macos/"
echo "  ✅ .secrets/web/"
echo "  ✅ .secrets/api-keys/"
echo "  ✅ .secrets/common/"
echo "  ✅ .secrets/backups/"
echo ""

if [ "$MISPLACED" -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Found $MISPLACED misplaced file(s)${NC}"
    echo "   Consider moving them to appropriate .secrets/ subdirectories"
    echo ""
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 Next steps:"
echo "   1. Place all secrets in appropriate .secrets/ subdirectories"
echo "   2. Run: bash scripts/verify-secrets-local.sh"
echo "   3. Run: bash scripts/backup-secrets.sh"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

