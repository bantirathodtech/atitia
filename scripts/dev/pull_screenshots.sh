#!/bin/bash
# scripts/dev/pull_screenshots.sh
#
# Pull screenshots from Android device after integration test
# Retrieves screenshots captured by integration_test framework
#
# Usage:
#   bash scripts/dev/pull_screenshots.sh [--device <device_id>] [--output <dir>]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
OUTPUT_DIR="${PROJECT_ROOT}/screenshots/play_store/$(date +"%Y%m%d_%H%M%S")"
DEVICE_ID=""
APP_PACKAGE="com.avishio.atitia"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --device)
            DEVICE_ID="$2"
            shift 2
            ;;
        --output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        *)
            log_warning "Unknown option: $1"
            shift
            ;;
    esac
done

# Detect device if not specified
if [ -z "$DEVICE_ID" ]; then
    device_count=$(adb devices | grep -v "List" | grep "device" | wc -l | tr -d ' ')
    if [ "$device_count" -eq 0 ]; then
        log_warning "No devices connected"
        exit 1
    elif [ "$device_count" -gt 1 ]; then
        DEVICE_ID=$(adb devices | grep -v "List" | grep "device" | head -1 | cut -f1)
        log_info "Multiple devices found, using: $DEVICE_ID"
    else
        DEVICE_ID=$(adb devices | grep -v "List" | grep "device" | head -1 | cut -f1)
    fi
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
log_info "Output directory: $OUTPUT_DIR"

# Method 1: Try to pull from app's private files (requires run-as)
log_info "Attempting to pull from app's private files..."
# First, check if screenshots directory exists
screenshot_dir_check=$(adb -s "$DEVICE_ID" shell "run-as $APP_PACKAGE sh -c 'if [ -d files/screenshots ]; then echo \"exists\"; else echo \"not_exists\"; fi' 2>&1" | grep -v "run-as")

if echo "$screenshot_dir_check" | grep -q "exists"; then
    log_info "Screenshots directory found, copying to external storage..."
    # Create external storage directory
    adb -s "$DEVICE_ID" shell "mkdir -p /sdcard/Pictures/AtitiaScreenshots" 2>/dev/null || true
    
    # Copy all screenshots to external storage
    adb -s "$DEVICE_ID" shell "run-as $APP_PACKAGE sh -c 'cp -r files/screenshots/* /sdcard/Pictures/AtitiaScreenshots/ 2>/dev/null || true' 2>&1" | grep -v "run-as" || true
    
    # Also try copying individual files
    adb -s "$DEVICE_ID" shell "run-as $APP_PACKAGE sh -c 'find files/screenshots -name \"*.png\" -exec cp {} /sdcard/Pictures/AtitiaScreenshots/ \\; 2>/dev/null || true' 2>&1" | grep -v "run-as" || true
    
    log_info "Copied screenshots to external storage"
else
    log_warning "Screenshots directory not found in app's private files"
fi

# Method 2: Pull from external storage Pictures directory (PRIMARY METHOD)
log_info "Pulling from external storage (device gallery location)..."
mkdir -p "$OUTPUT_DIR"
adb -s "$DEVICE_ID" pull /sdcard/Pictures/AtitiaScreenshots/ "$OUTPUT_DIR/" 2>/dev/null || true

# Move all PNG files from subdirectories to main output directory
if [ -d "$OUTPUT_DIR/AtitiaScreenshots" ]; then
    mv "$OUTPUT_DIR/AtitiaScreenshots"/*.png "$OUTPUT_DIR/" 2>/dev/null || true
    rmdir "$OUTPUT_DIR/AtitiaScreenshots" 2>/dev/null || true
fi

# Method 3: Pull from Android/data directory
log_info "Pulling from Android/data..."
adb -s "$DEVICE_ID" pull /sdcard/Android/data/$APP_PACKAGE/files/ "$OUTPUT_DIR/android_data/" 2>/dev/null || true

# Method 4: Search for recent PNG files on device
log_info "Searching for recent screenshot files..."
adb -s "$DEVICE_ID" shell "find /sdcard -name '*.png' -mmin -15 -type f 2>/dev/null" | while read -r file; do
    if [ -n "$file" ]; then
        filename=$(basename "$file")
        log_info "Found: $filename"
        adb -s "$DEVICE_ID" pull "$file" "$OUTPUT_DIR/" 2>/dev/null || true
    fi
done

# Method 5: Use Flutter's integration_test screenshot location
# Integration test saves to /data/data/<package>/files/screenshots/
# We need to copy them to external storage first
log_info "Copying integration_test screenshots to external storage..."
adb -s "$DEVICE_ID" shell "run-as $APP_PACKAGE sh -c 'mkdir -p /sdcard/Pictures/AtitiaScreenshots && cp -r files/screenshots/* /sdcard/Pictures/AtitiaScreenshots/ 2>/dev/null || true'" || true

# Pull again after copying
adb -s "$DEVICE_ID" pull /sdcard/Pictures/AtitiaScreenshots/ "$OUTPUT_DIR/integration_test/" 2>/dev/null || true

# Count and organize screenshots
final_count=$(find "$OUTPUT_DIR" -maxdepth 1 -name "*.png" -type f 2>/dev/null | wc -l | tr -d ' ')

if [ "$final_count" -gt 0 ]; then
    log_success "Retrieved $final_count screenshot(s)"
    
    # List screenshots with details
    echo ""
    log_info "Screenshots retrieved:"
    ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null | awk '{print "  ✅ " $9 " (" $5 ")"}' || true
    
    # Create a summary file
    echo "# Screenshots Retrieved - $(date)" > "$OUTPUT_DIR/SCREENSHOTS.txt"
    echo "" >> "$OUTPUT_DIR/SCREENSHOTS.txt"
    echo "Total: $final_count screenshots" >> "$OUTPUT_DIR/SCREENSHOTS.txt"
    echo "" >> "$OUTPUT_DIR/SCREENSHOTS.txt"
    ls -1 "$OUTPUT_DIR"/*.png 2>/dev/null | xargs -n1 basename >> "$OUTPUT_DIR/SCREENSHOTS.txt" || true
else
    log_warning "No screenshots found in output directory"
    log_info "Screenshots may still be on device. Check:"
    log_info "  📱 Device Gallery: Pictures/AtitiaScreenshots/"
    log_info "  💻 Or run: adb -s $DEVICE_ID pull /sdcard/Pictures/AtitiaScreenshots/ $OUTPUT_DIR/"
fi

log_success "Screenshot retrieval complete!"
echo "📁 Screenshots saved to: $OUTPUT_DIR"

