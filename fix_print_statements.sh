#!/bin/bash

# Script to fix print statements causing compilation errors
echo "🔧 Fixing print statements..."

# Remove problematic print statements that are causing compilation errors
find lib -name "*.dart" -type f -exec sed -i '' '/print(/d' {} \;

# Remove orphaned print statements (lines that start with spaces and contain only print content)
find lib -name "*.dart" -type f -exec sed -i '' '/^[[:space:]]*.*[✅❌🔄⚠️].*);$/d' {} \;

echo "✅ Fixed print statements"
