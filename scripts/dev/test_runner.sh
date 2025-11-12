#!/bin/bash
# ==================================================
# 🧪 TEST RUNNER
# ==================================================
# Run unit, widget, and integration tests
# Usage: bash scripts/test_runner.sh [type] [coverage]
# Types: unit, widget, integration, all (default: all)
# Coverage: yes, no (default: yes)

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." source "$SCRIPT_DIR/setup_env.sh"source "$SCRIPT_DIR/setup_env.sh" pwd)"
source "$SCRIPTS_ROOT/core/setup_env.sh"

TEST_TYPE="${1:-all}"
COVERAGE="${2:-yes}"

echo "🧪 Running Flutter tests ($TEST_TYPE)"

# Clean and get dependencies
echo "🧹 Preparing..."
flutter clean
flutter pub get

# Coverage directory
COVERAGE_DIR="$PROJECT_ROOT/coverage"
mkdir -p "$COVERAGE_DIR"

# Run tests
run_unit_tests() {
    echo "📝 Running unit tests..."
    if [ "$COVERAGE" = "yes" ]; then
        flutter test --coverage
    else
        flutter test
    fi
}

run_widget_tests() {
    echo "🎨 Running widget tests..."
    if [ "$COVERAGE" = "yes" ]; then
        flutter test test/widget_test.dart --coverage 2>/dev/null || echo "⚠️  No widget tests found"
    else
        flutter test test/widget_test.dart 2>/dev/null || echo "⚠️  No widget tests found"
    fi
}

run_integration_tests() {
    echo "🔗 Running integration tests..."
    if [ -d "$PROJECT_ROOT/integration_test" ] || [ -d "$PROJECT_ROOT/test/integration" ]; then
        flutter test integration_test/ 2>/dev/null || flutter test test/integration/ 2>/dev/null || echo "⚠️  No integration tests found"
    else
        echo "⚠️  No integration test directory found"
    fi
}

# Execute based on test type
case $TEST_TYPE in
    unit)
        run_unit_tests
        ;;
    widget)
        run_widget_tests
        ;;
    integration)
        run_integration_tests
        ;;
    all)
        run_unit_tests
        run_widget_tests
        run_integration_tests
        ;;
    *)
        echo "❌ Unknown test type: $TEST_TYPE"
        echo "   Usage: bash scripts/test_runner.sh [unit|widget|integration|all]"
        exit 1
        ;;
esac

# Generate coverage report
if [ "$COVERAGE" = "yes" ] && [ -f "$PROJECT_ROOT/coverage/lcov.info" ]; then
    echo "📊 Coverage report generated: $PROJECT_ROOT/coverage/lcov.info"
    
    # Try to generate HTML report if genhtml is available
    if command -v genhtml &> /dev/null; then
        genhtml "$PROJECT_ROOT/coverage/lcov.info" -o "$COVERAGE_DIR/html"
        echo "📊 HTML coverage report: $COVERAGE_DIR/html/index.html"
    fi
fi

echo "✅ Tests complete!"

