#!/bin/bash

# Script to fix deprecated withOpacity calls across the entire codebase
echo "🔧 Fixing deprecated withOpacity calls..."

# Find all Dart files and replace withOpacity with withValues
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.1)/\.withValues(alpha: 0\.1)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.2)/\.withValues(alpha: 0\.2)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.3)/\.withValues(alpha: 0\.3)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.4)/\.withValues(alpha: 0\.4)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.5)/\.withValues(alpha: 0\.5)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.6)/\.withValues(alpha: 0\.6)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.7)/\.withValues(alpha: 0\.7)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.8)/\.withValues(alpha: 0\.8)/g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(0\.9)/\.withValues(alpha: 0\.9)/g' {} \;

echo "✅ Fixed deprecated withOpacity calls"
