#!/bin/bash
# ==================================================
# 🎯 FLUTTER AUTOMATION CLI
# ==================================================
# Central CLI wrapper for all automation scripts
# Usage: bash scripts/cli.sh [command] [args...]

set -e

# Source environment setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
source "$SCRIPT_DIR/setup_env.sh"

COMMAND="${1:-help}"

show_help() {
    cat << EOF
🎯 Flutter Automation CLI

Usage: bash scripts/cli.sh [command] [args...]

Commands:
  setup          Setup environment and verify configuration
  clean          Clean all build artifacts
  build          Build for platform [android|ios|macos|web|all]
  test           Run tests [unit|widget|integration|all]
  release        Release build [android|ios|web|all]
  deploy         Deploy to stores [playstore|appstore|web|all]
  version        Bump version [major|minor|patch|build]
  diagnose       Run diagnostics and verification
  icons          Generate app icons and splash
  localize       Generate localization files
  firebase       Setup Firebase configs [android|ios|macos|web|all]
  hooks          Install git hooks [install|uninstall]
  help           Show this help message

Examples:
  bash scripts/cli.sh build android
  bash scripts/cli.sh release all
  bash scripts/cli.sh deploy playstore
  bash scripts/cli.sh version patch
  bash scripts/cli.sh diagnose

EOF
}

case $COMMAND in
    setup)
        bash "$SCRIPT_DIR/setup_env.sh"
        bash "$SCRIPT_DIR/diagnostics.sh"
        ;;
    clean)
        bash "$SCRIPT_DIR/flutter_clean.sh"
        ;;
    build)
        PLATFORM="${2:-all}"
        BUILD_TYPE="${3:-release}"
        bash "$SCRIPT_DIR/flutter_build.sh" "$PLATFORM" "$BUILD_TYPE"
        ;;
    test)
        TEST_TYPE="${2:-all}"
        COVERAGE="${3:-yes}"
        bash "$SCRIPTS_ROOT/dev/test_runner.sh" "$TEST_TYPE" "$COVERAGE"
        ;;
    release)
        PLATFORM="${2:-all}"
        case $PLATFORM in
            android)
                bash "$SCRIPTS_ROOT/release/release_android.sh"
                ;;
            ios)
                bash "$SCRIPTS_ROOT/release/release_ios.sh"
                ;;
            web)
                bash "$SCRIPTS_ROOT/release/build_web.sh"
                ;;
            all)
                bash "$SCRIPTS_ROOT/release/release_all.sh"
                ;;
            *)
                echo "❌ Unknown platform: $PLATFORM"
                exit 1
                ;;
        esac
        ;;
    deploy)
        PLATFORM="${2:-all}"
        case $PLATFORM in
            playstore|android)
                bash "$SCRIPTS_ROOT/deploy/deploy_playstore.sh"
                ;;
            appstore|ios)
                bash "$SCRIPTS_ROOT/deploy/deploy_appstore.sh"
                ;;
            web)
                bash "$SCRIPTS_ROOT/release/build_web.sh" yes
                ;;
            all)
                bash "$SCRIPTS_ROOT/release/release_all.sh" yes
                ;;
            *)
                echo "❌ Unknown platform: $PLATFORM"
                exit 1
                ;;
        esac
        ;;
    version)
        BUMP_TYPE="${2:-build}"
        CUSTOM_VERSION="${3:-}"
        bash "$SCRIPTS_ROOT/dev/version_bump.sh" "$BUMP_TYPE" "$CUSTOM_VERSION"
        ;;
    diagnose)
        bash "$SCRIPT_DIR/diagnostics.sh"
        ;;
    icons)
        SOURCE_IMAGE="${2:-}"
        bash "$SCRIPTS_ROOT/dev/generate_icons.sh" "$SOURCE_IMAGE"
        ;;
    localize)
        bash "$SCRIPTS_ROOT/dev/generate_localization.sh"
        ;;
    firebase)
        PLATFORM="${2:-all}"
        bash "$SCRIPTS_ROOT/setup/firebase_setup.sh" "$PLATFORM"
        ;;
    hooks)
        ACTION="${2:-install}"
        bash "$SCRIPTS_ROOT/dev/git_hooks.sh" "$ACTION"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;
esac

