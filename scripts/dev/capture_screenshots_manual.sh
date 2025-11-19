#!/bin/bash
# scripts/dev/capture_screenshots_manual.sh
#
# Manual screenshot capture helper script
#
# This script helps you capture screenshots manually by:
# 1. Starting the app
# 2. Providing navigation instructions
# 3. Pulling screenshots from device
#
# Usage:
#   bash scripts/dev/capture_screenshots_manual.sh

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SCREENSHOT_DIR="$PROJECT_ROOT/screenshots/play_store/manual_$(date +"%Y%m%d_%H%M%S")"

mkdir -p "$SCREENSHOT_DIR"

echo -e "${BLUE}📸 Manual Screenshot Capture Helper${NC}"
echo "=========================================="
echo ""

# Get device ID
DEVICE_ID=$(adb devices | grep -v "List" | grep "device" | head -1 | cut -f1)
if [ -z "$DEVICE_ID" ]; then
  echo -e "${YELLOW}⚠️  No device connected. Please connect a device.${NC}"
  exit 1
fi

echo -e "${GREEN}✓ Using device: $DEVICE_ID${NC}"
echo ""

# Start the app
echo -e "${YELLOW}Starting the app...${NC}"
cd "$PROJECT_ROOT"
flutter run --device-id="$DEVICE_ID" &
FLUTTER_PID=$!

echo ""
echo -e "${BLUE}📱 App is starting...${NC}"
echo ""
echo -e "${YELLOW}Instructions:${NC}"
echo "   1. Wait for the app to load"
echo "   2. Navigate to each screen listed below"
echo "   3. Take a screenshot using: Power + Volume Down"
echo "   4. Press Enter after each screenshot"
echo ""
echo -e "${BLUE}Screenshots to capture:${NC}"
echo ""
echo "   [1] Guest Dashboard - PG Listings"
echo "   [2] PG Details Screen"
echo "   [3] Owner Dashboard Overview"
echo "   [4] Booking Request/Status"
echo "   [5] Payment Management"
echo "   [6] Food Menu"
echo "   [7] Owner PG Management"
echo "   [8] Profile/Settings"
echo ""

screenshots=(
  "01_guest_dashboard_pg_listings"
  "02_pg_details_screen"
  "03_owner_dashboard_overview"
  "04_booking_request_status"
  "05_payment_management"
  "06_food_menu"
  "07_owner_pg_management"
  "08_profile_settings"
)

for i in "${!screenshots[@]}"; do
  num=$((i + 1))
  name="${screenshots[$i]}"
  
  echo -e "${YELLOW}[$num/$(( ${#screenshots[@]} ))] Navigate to: $name${NC}"
  echo "   Take screenshot, then press Enter..."
  read -r
  
  # Pull latest screenshot from device
  echo "   Pulling screenshot from device..."
  adb -s "$DEVICE_ID" pull /sdcard/Pictures/ "$SCREENSHOT_DIR/" 2>/dev/null || true
  adb -s "$DEVICE_ID" pull /storage/emulated/0/Pictures/ "$SCREENSHOT_DIR/" 2>/dev/null || true
  
  # Find the most recent screenshot and rename it
  latest=$(find "$SCREENSHOT_DIR" -name "Screenshot_*.png" -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -d' ' -f2-)
  if [ -n "$latest" ] && [ -f "$latest" ]; then
    mv "$latest" "$SCREENSHOT_DIR/$name.png"
    echo -e "${GREEN}   ✓ Saved: $name.png${NC}"
  else
    echo -e "${YELLOW}   ⚠️  Could not find screenshot. Please save manually.${NC}"
  fi
  echo ""
done

# Kill flutter process
kill $FLUTTER_PID 2>/dev/null || true

echo -e "${GREEN}✅ Screenshot capture complete!${NC}"
echo ""
echo -e "${BLUE}📁 Screenshots saved to:${NC}"
echo "   $SCREENSHOT_DIR"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "   1. Review screenshots"
echo "   2. Resize to 1080x1920 if needed"
echo "   3. Upload to Google Play Console"

