#!/bin/bash
# scripts/dev/capture_screenshots.sh
#
# Professional automated screenshot capture script for Google Play Store
#
# This script provides a production-ready solution for capturing app screenshots
# with proper error handling, logging, and organization.
#
# Usage:
#   bash scripts/dev/capture_screenshots.sh [options]
#
# Options:
#   --guest-only      Capture only guest flow screenshots
#   --owner-only      Capture only owner flow screenshots
#   --required-only   Capture only required screenshots
#   --device <id>     Specify device ID
#   --help            Show this help message
#
# Prerequisites:
#   - Device/emulator connected
#   - App built and installed
#   - Flutter SDK installed

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCREENSHOT_DIR="$PROJECT_ROOT/screenshots/play_store"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="$SCREENSHOT_DIR/$TIMESTAMP"
LOG_FILE="$OUTPUT_DIR/capture.log"

# Test selection
TEST_MODE="all"  # all, guest, owner, required
DEVICE_ID=""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ============================================================================
# Functions
# ============================================================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$LOG_FILE"
}

log_step() {
    echo -e "${CYAN}📸 $1${NC}" | tee -a "$LOG_FILE"
}

show_help() {
    cat << EOF
${BLUE}Atitia - Automated Screenshot Capture${NC}
==========================================

${GREEN}Usage:${NC}
  bash scripts/dev/capture_screenshots.sh [options]

${GREEN}Options:${NC}
  --guest-only      Capture only guest flow screenshots
  --owner-only      Capture only owner flow screenshots
  --required-only   Capture only required screenshots
  --device <id>     Specify device ID (default: auto-detect)
  --help            Show this help message

${GREEN}Examples:${NC}
  # Capture all screenshots (guest + owner)
  bash scripts/dev/capture_screenshots.sh

  # Capture only guest flow
  bash scripts/dev/capture_screenshots.sh --guest-only

  # Capture only owner flow
  bash scripts/dev/capture_screenshots.sh --owner-only

  # Capture only required screenshots
  bash scripts/dev/capture_screenshots.sh --required-only

  # Specify device
  bash scripts/dev/capture_screenshots.sh --device emulator-5554

${GREEN}Prerequisites:${NC}
  - Device/emulator connected (check with: adb devices)
  - App built and installed
  - Flutter SDK installed

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --guest-only)
                TEST_MODE="guest"
                shift
                ;;
            --owner-only)
                TEST_MODE="owner"
                shift
                ;;
            --required-only)
                TEST_MODE="required"
                shift
                ;;
            --device)
                DEVICE_ID="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

check_prerequisites() {
    log_info "Checking prerequisites..."

    # Check Flutter
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter SDK not found. Please install Flutter."
        exit 1
    fi
    log_success "Flutter SDK found"

    # Check ADB
    if ! command -v adb &> /dev/null; then
        log_error "ADB not found. Please install Android SDK platform-tools."
        exit 1
    fi
    log_success "ADB found"

    # Check device
    detect_device
    log_success "Device detected: $DEVICE_ID"

    # Check app installation
    PACKAGE_NAME="com.charyatani.atitia"
    if ! adb -s "$DEVICE_ID" shell pm list packages | grep -q "$PACKAGE_NAME"; then
        log_warning "App not installed. Will build and install..."
    else
        log_success "App is installed"
    fi
}

detect_device() {
    if [ -n "$DEVICE_ID" ]; then
        return
    fi

    local device_count
    device_count=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')

    if [ "$device_count" -eq 0 ]; then
        log_error "No devices connected. Please connect a device or start an emulator."
        log_info "Run: adb devices"
        exit 1
    elif [ "$device_count" -gt 1 ]; then
        log_warning "Multiple devices found. Using first device."
        log_info "To specify a device, use: --device <device_id>"
        DEVICE_ID=$(adb devices | grep -v "List" | grep "device" | head -1 | cut -f1)
    else
        DEVICE_ID=$(adb devices | grep -v "List" | grep "device" | head -1 | cut -f1)
    fi
}

build_and_install() {
    log_info "Building app in profile mode..."
    cd "$PROJECT_ROOT"

    if flutter build apk --profile --device-id="$DEVICE_ID" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "Build complete"
    else
        log_error "Build failed. Check the log: $LOG_FILE"
        exit 1
    fi

    log_info "Installing app..."
    if flutter install --device-id="$DEVICE_ID" 2>&1 | tee -a "$LOG_FILE"; then
        log_success "App installed"
    else
        log_error "Installation failed. Check the log: $LOG_FILE"
        exit 1
    fi
}

determine_test_file() {
    case $TEST_MODE in
        guest)
            echo "integration_test/screenshots/guest_flow_screenshots_test.dart"
            ;;
        owner)
            echo "integration_test/screenshots/owner_flow_screenshots_test.dart"
            ;;
        required)
            # Use guest test with required-only mode (can be enhanced)
            echo "integration_test/screenshots/guest_flow_screenshots_test.dart"
            ;;
        all)
            echo "integration_test/screenshots/all_screenshots_test.dart"
            ;;
        *)
            echo "integration_test/screenshots/all_screenshots_test.dart"
            ;;
    esac
}

run_screenshot_test() {
    local test_file
    test_file=$(determine_test_file)

    log_info "Running screenshot capture test..."
    log_info "Test file: $test_file"
    log_info "Mode: $TEST_MODE"

    cd "$PROJECT_ROOT"

    if flutter test "$test_file" \
        --device-id="$DEVICE_ID" \
        --reporter expanded \
        2>&1 | tee -a "$LOG_FILE"; then
        log_success "Screenshot capture completed"
        return 0
    else
        log_error "Screenshot capture failed. Check the log: $LOG_FILE"
        return 1
    fi
}

organize_screenshots() {
    log_info "Organizing screenshots..."

    # Find screenshots in common locations
    local screenshot_sources=(
        "$PROJECT_ROOT/test_driver/screenshots"
        "$PROJECT_ROOT/integration_test/screenshots"
        "$HOME/Pictures"
    )

    local found_count=0

    for source_dir in "${screenshot_sources[@]}"; do
        if [ -d "$source_dir" ]; then
            find "$source_dir" -name "*.png" -mmin -10 -type f 2>/dev/null | while read -r screenshot; do
                local filename
                filename=$(basename "$screenshot")
                cp "$screenshot" "$OUTPUT_DIR/$filename" 2>/dev/null || true
                found_count=$((found_count + 1))
                log_success "Copied: $filename"
            done
        fi
    done

    # Pull from device - integration_test saves screenshots in app's files directory
    log_info "Pulling screenshots from device..."
    
    # Integration test screenshots location
    local app_package="com.avishio.atitia"
    local screenshot_paths=(
        "/data/data/$app_package/files"
        "/sdcard/Android/data/$app_package/files"
        "/sdcard/Pictures"
        "/storage/emulated/0/Pictures"
        "/sdcard/Download"
    )
    
    for path in "${screenshot_paths[@]}"; do
        log_info "Checking: $path"
        adb -s "$DEVICE_ID" pull "$path/" "$OUTPUT_DIR/device_screenshots_$(basename $path)/" 2>/dev/null || true
    done
    
    # Also try to find any PNG files created in last 10 minutes
    log_info "Searching for recent screenshot files..."
    adb -s "$DEVICE_ID" shell "find /sdcard -name '*.png' -mmin -10 -type f 2>/dev/null" | while read -r file; do
        if [ -n "$file" ]; then
            local filename=$(basename "$file")
            log_info "Found: $file"
            adb -s "$DEVICE_ID" pull "$file" "$OUTPUT_DIR/" 2>/dev/null || true
        fi
    done

    # Count final screenshots
    local final_count
    final_count=$(find "$OUTPUT_DIR" -name "*.png" -type f 2>/dev/null | wc -l | tr -d ' ')

    if [ "$final_count" -gt 0 ]; then
        log_success "Found $final_count screenshot(s)"
    else
        log_warning "No screenshots found in expected locations"
        log_info "Screenshots may be in: $OUTPUT_DIR"
    fi
}

generate_summary() {
    log_info "Generating summary report..."

    cat > "$OUTPUT_DIR/README.md" << EOF
# Screenshot Capture Session

**Date:** $(date)
**Device:** $DEVICE_ID
**Mode:** $TEST_MODE
**Output Directory:** $OUTPUT_DIR

## Screenshots Captured

$(find "$OUTPUT_DIR" -name "*.png" -type f -exec basename {} \; 2>/dev/null | sort || echo "No screenshots found")

## Test Configuration

- **Test Mode:** $TEST_MODE
- **Device ID:** $DEVICE_ID
- **Timestamp:** $TIMESTAMP

## Next Steps

1. Review each screenshot for quality
2. Ensure no sensitive data is visible
3. Resize to 1080x1920 pixels if needed
4. Rename according to Play Store requirements
5. Upload to Google Play Console

## Play Store Requirements

- **Minimum:** 2 screenshots
- **Maximum:** 8 screenshots
- **Recommended Size:** 1080 x 1920 pixels
- **Format:** PNG or JPG

See: \`docs/GOOGLE_PLAY_SCREENSHOTS_GUIDE.md\` for detailed recommendations.

## Logs

Check \`capture.log\` for detailed execution logs.
EOF

    log_success "Summary saved to: $OUTPUT_DIR/README.md"
}

# ============================================================================
# Main Execution
# ============================================================================

main() {
    # Parse arguments
    parse_arguments "$@"

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Header
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${CYAN}Atitia - Automated Screenshot Capture${NC}                    ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Check prerequisites
    check_prerequisites
    echo ""

    # Build and install
    build_and_install
    echo ""

    # Run screenshot test
    if run_screenshot_test; then
        echo ""
        # Pull screenshots from device
        log_info "Pulling screenshots from device..."
        bash "$SCRIPT_DIR/pull_screenshots.sh" --device "$DEVICE_ID" --output "$OUTPUT_DIR" 2>&1 | tee -a "$LOG_FILE"
        echo ""
        
        # Organize screenshots
        organize_screenshots
        echo ""

        # Generate summary
        generate_summary
        echo ""

        # Success message
        log_success "Screenshot capture session complete!"
        echo ""
        log_info "📁 Screenshots saved to: $OUTPUT_DIR"
        log_info "📄 Summary: $OUTPUT_DIR/README.md"
        log_info "📋 Logs: $LOG_FILE"
        echo ""
        
        # Count final screenshots
        final_count=$(find "$OUTPUT_DIR" -name "*.png" -type f 2>/dev/null | wc -l | tr -d ' ')
        if [ "$final_count" -gt 0 ]; then
            log_success "Found $final_count screenshot(s) in output directory"
        else
            log_warning "No screenshots found in output directory"
            log_info "Screenshots may be in integration_test output. Check:"
            log_info "  - build/app/outputs/"
            log_info "  - Or run: bash scripts/dev/pull_screenshots.sh --device $DEVICE_ID"
        fi
        
        echo ""
        log_info "Next steps:"
        echo "  1. Review screenshots in: $OUTPUT_DIR"
        echo "  2. Resize to 1080x1920 if needed"
        echo "  3. Upload to Google Play Console"
        echo ""
    else
        log_error "Screenshot capture failed. Check logs: $LOG_FILE"
        exit 1
    fi
}

# Run main function
main "$@"
