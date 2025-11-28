#!/bin/bash

# Razorpay Test Keys Setup Script (Shell Wrapper)
# 
# This script wraps the Node.js setup script for easier execution
# 
# Usage (Multiple Options):
#   # Option 1: Environment Variable
#   RAZORPAY_TEST_KEY=rzp_test_xxx ./scripts/setup/setup-razorpay-test-keys.sh <owner-id>
# 
#   # Option 2: Command Line Argument
#   ./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --api-key rzp_test_xxx
# 
#   # Option 3: Interactive Prompt
#   ./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --interactive
# 
# Options:
#   --api-key <key>     Provide Razorpay API key directly
#   --interactive       Prompt for API key interactively
#   --force             Overwrite existing Razorpay configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
NODE_SCRIPT="$SCRIPT_DIR/setup-razorpay-test-keys.js"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
  echo -e "${RED}❌ Error: Node.js is not installed${NC}"
  echo -e "${YELLOW}💡 Please install Node.js (v20 or higher) to run this script${NC}\n"
  exit 1
fi

# Check if Firebase Functions dependencies are installed
if [ ! -d "$PROJECT_ROOT/functions/node_modules" ]; then
  echo -e "${YELLOW}⚠️  Installing Firebase Functions dependencies...${NC}\n"
  cd "$PROJECT_ROOT/functions"
  npm install
  cd "$PROJECT_ROOT"
fi

# Check if firebase-admin is available (try functions/node_modules first, then check global)
if [ ! -d "$PROJECT_ROOT/functions/node_modules/firebase-admin" ]; then
  echo -e "${YELLOW}⚠️  Firebase Admin SDK not found in functions/node_modules${NC}"
  echo -e "${CYAN}💡 Installing firebase-admin...${NC}\n"
  
  # Create a temporary package.json if needed for firebase-admin
  cd "$PROJECT_ROOT"
  if [ ! -f "package.json" ]; then
    cat > package.json << EOF
{
  "name": "atitia-setup-scripts",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "firebase-admin": "^11.11.0"
  }
}
EOF
    npm install
  else
    # Check if firebase-admin is in package.json
    if ! grep -q "firebase-admin" package.json 2>/dev/null; then
      npm install firebase-admin@^11.11.0 --save
    else
      npm install
    fi
  fi
fi

# Run the Node.js script
echo -e "${CYAN}🚀 Running Razorpay test keys setup...${NC}\n"
node "$NODE_SCRIPT" "$@"

