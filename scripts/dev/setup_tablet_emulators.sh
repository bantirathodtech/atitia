#!/bin/bash
# scripts/dev/setup_tablet_emulators.sh
#
# Helper script to create 7-inch and 10-inch tablet emulators for screenshot capture
#
# Usage:
#   bash scripts/dev/setup_tablet_emulators.sh
#
# Prerequisites:
#   - Android SDK installed
#   - AVD Manager available
#   - System images downloaded

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}📱 Tablet Emulator Setup for Screenshot Capture${NC}"
echo ""

# Check if avdmanager is available
if ! command -v avdmanager &> /dev/null; then
    echo -e "${RED}❌ Error: avdmanager not found${NC}"
    echo "Please ensure Android SDK is installed and added to PATH"
    echo ""
    echo "You can also use Android Studio's Device Manager GUI instead:"
    echo "  Tools → Device Manager → Create Device"
    exit 1
fi

# Check if emulator is available
if ! command -v emulator &> /dev/null; then
    echo -e "${RED}❌ Error: emulator not found${NC}"
    echo "Please ensure Android SDK is installed and added to PATH"
    exit 1
fi

echo -e "${BLUE}Checking available system images...${NC}"
echo ""

# List available system images
SYSTEM_IMAGES=$(avdmanager list system-images 2>/dev/null | grep -E "system-images.*google_apis.*x86_64" | head -1)

if [ -z "$SYSTEM_IMAGES" ]; then
    echo -e "${YELLOW}⚠️  No system images found.${NC}"
    echo ""
    echo "Please download a system image first:"
    echo "  1. Open Android Studio"
    echo "  2. Go to Tools → SDK Manager"
    echo "  3. SDK Platforms tab"
    echo "  4. Check Android 13 (API 33) or Android 14 (API 34)"
    echo "  5. SDK Tools tab"
    echo "  6. Check Android SDK Build-Tools"
    echo "  7. Click Apply"
    echo ""
    echo "Or use Android Studio's Device Manager GUI:"
    echo "  Tools → Device Manager → Create Device"
    exit 1
fi

echo -e "${GREEN}✓ System images found${NC}"
echo ""

# Extract API level and system image path
API_LEVEL=$(echo "$SYSTEM_IMAGES" | grep -oE "android-[0-9]+" | head -1 | sed 's/android-//')
SYSTEM_IMAGE_PATH=$(echo "$SYSTEM_IMAGES" | awk '{print $1}')

echo -e "${BLUE}Using: $SYSTEM_IMAGE_PATH${NC}"
echo ""

# Function to create AVD
create_avd() {
    local avd_name=$1
    local device_name=$2
    
    echo -e "${CYAN}Creating $avd_name emulator...${NC}"
    
    # Check if AVD already exists
    if avdmanager list avd | grep -q "$avd_name"; then
        echo -e "${YELLOW}⚠️  AVD '$avd_name' already exists${NC}"
        read -p "Do you want to delete and recreate it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            avdmanager delete avd -n "$avd_name"
            echo -e "${GREEN}✓ Deleted existing AVD${NC}"
        else
            echo -e "${BLUE}Skipping $avd_name${NC}"
            return
        fi
    fi
    
    # Create AVD
    echo "no" | avdmanager create avd \
        -n "$avd_name" \
        -k "$SYSTEM_IMAGE_PATH" \
        -d "$device_name" \
        2>&1 | grep -v "Do you want to create a custom hardware profile"
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Created $avd_name successfully${NC}"
    else
        echo -e "${RED}❌ Failed to create $avd_name${NC}"
        return 1
    fi
    
    echo ""
}

# Create 7-inch tablet
create_avd "Tablet_7inch" "7.0in WSVGA (Tablet)"

# Create 10-inch tablet
create_avd "Tablet_10inch" "10.1in WXGA (Tablet)"

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${CYAN}Next steps:${NC}"
echo "1. Start the emulators:"
echo "   emulator -avd Tablet_7inch &"
echo "   emulator -avd Tablet_10inch &"
echo ""
echo "2. Wait for emulators to boot (may take a few minutes)"
echo ""
echo "3. List connected devices:"
echo "   flutter devices"
echo ""
echo "4. Run the app on a tablet:"
echo "   flutter run -d <tablet_device_id>"
echo ""
echo "5. Capture screenshots using:"
echo "   bash scripts/dev/capture_screenshots.sh --device <tablet_device_id>"
echo ""
echo "Or use Android Studio's Device Manager GUI for easier setup:"
echo "  Tools → Device Manager → Create Device"
echo ""

