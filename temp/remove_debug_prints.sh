#!/bin/bash

# Script to remove debug print statements from production code
echo "🧹 Removing debug print statements..."

# Remove print statements from lib files (but keep them in test files)
find lib -name "*.dart" -type f -exec sed -i '' '/print(/d' {} \;

echo "✅ Removed debug print statements"
