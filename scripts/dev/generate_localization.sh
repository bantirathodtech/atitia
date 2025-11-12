#!/bin/bash
# ==================================================
# 🌍 GENERATE LOCALIZATION
# ==================================================
# Run flutter gen-l10n for translations
# Usage: bash scripts/generate_localization.sh

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

echo "🌍 Generating localization files..."

# Check for l10n.yaml
if [ ! -f "$PROJECT_ROOT/l10n.yaml" ]; then
    echo "⚠️  l10n.yaml not found"
    echo "   Creating default l10n.yaml..."
    cat > "$PROJECT_ROOT/l10n.yaml" << EOF
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
EOF
fi

# Check for ARB files
ARB_DIR="$PROJECT_ROOT/lib/l10n"
if [ ! -d "$ARB_DIR" ] && [ -d "$PROJECT_ROOT/assets/localization" ]; then
    ARB_DIR="$PROJECT_ROOT/assets/localization"
fi

if [ ! -d "$ARB_DIR" ]; then
    echo "❌ ARB directory not found"
    echo "   Expected: lib/l10n or assets/localization"
    exit 1
fi

# Generate localization
echo "📝 Running flutter gen-l10n..."
flutter gen-l10n

echo "✅ Localization files generated!"
echo "   Output: .dart_tool/flutter_gen/gen_l10n/"

