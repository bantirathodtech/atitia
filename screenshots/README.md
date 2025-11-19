# 📸 Screenshots Directory

This directory contains automated screenshots captured for app store listings and documentation.

## 📁 Directory Structure

```
screenshots/
├── play_store/              # Google Play Store screenshots
│   └── YYYYMMDD_HHMMSS/     # Timestamped capture sessions
│       ├── *.png            # Screenshot files
│       ├── capture.log      # Capture session log
│       └── README.md        # Session summary
├── app_store/               # Apple App Store screenshots (future)
└── README.md                # This file
```

## 🎯 Purpose

Screenshots are automatically captured using Flutter's `integration_test` framework to:
- Generate consistent, high-quality screenshots for app stores
- Document app features and UI states
- Support marketing and promotional materials
- Maintain visual consistency across releases

## 📋 Screenshot Categories

### Guest Flow Screenshots (7 total)
1. **01_guest_dashboard_pg_listings** - Guest Dashboard - PG Listings Tab
2. **02_pg_details_screen** - PG Details Screen
3. **03_guest_booking_requests** - Guest Booking Requests Screen
4. **04_guest_payment_history** - Guest Payment History Screen
5. **05_guest_food_menu** - Guest Food Menu Screen
6. **06_guest_complaints** - Guest Complaints Screen
7. **07_guest_profile** - Guest Profile Screen

### Owner Flow Screenshots (6 total)
1. **01_owner_dashboard_overview** - Owner Dashboard Overview with Analytics
2. **02_owner_pg_management** - Owner PG Management Screen
3. **03_owner_guest_management** - Owner Guest Management Screen
4. **04_owner_food_management** - Owner Food Management Screen
5. **05_owner_analytics** - Owner Analytics Screen
6. **06_owner_profile** - Owner Profile Screen

## 🚀 Usage

### Capture Screenshots

```bash
# Capture all screenshots (Guest + Owner)
bash scripts/dev/capture_screenshots.sh --device <device_id>

# Capture only guest flow
bash scripts/dev/capture_screenshots.sh --guest-only

# Capture only owner flow
bash scripts/dev/capture_screenshots.sh --owner-only
```

### Pull Screenshots from Device

If screenshots weren't automatically pulled:

```bash
# Pull screenshots from device
bash scripts/dev/pull_screenshots.sh --device <device_id> --output screenshots/play_store/<session_dir>
```

## 📐 Screenshot Specifications

- **Format**: PNG
- **Resolution**: Device native resolution (typically 1080x1920 for phones)
- **Theme**: System theme mode (adapts to device settings)
- **Quality**: Maximum (1.0)

### Google Play Store Requirements
- **Phone**: 1080x1920 minimum
- **Tablet**: 1200x1920 minimum
- **Format**: PNG or JPEG
- **Max file size**: 8MB

## 🔧 Configuration

Screenshot definitions and settings are configured in:
- `integration_test/config/screenshot_config.dart` - Screenshot definitions
- `integration_test/services/screenshot_service.dart` - Capture service
- `scripts/dev/capture_screenshots.sh` - Capture automation script

## 📝 Notes

- Screenshots are automatically captured in **system theme mode**
- All screenshots are captured on a **physical Android device**
- Screenshots are stored in timestamped directories for organization
- Screenshot files are gitignored (see `.gitignore`) to avoid committing large binary files
- Logs and metadata are kept for reference

## 🗂️ File Organization

Each capture session creates a directory with:
- **Screenshot files** (`*.png`) - The actual screenshots
- **capture.log** - Detailed capture session log
- **README.md** - Session summary and metadata (auto-generated)

## 🔍 Troubleshooting

### Screenshots Not Found
1. Check if test completed successfully (see `capture.log`)
2. Run pull script manually: `bash scripts/dev/pull_screenshots.sh --device <device_id>`
3. Check device storage: `adb shell ls -la /sdcard/Pictures/AtitiaScreenshots/`
4. Check app's private files: `adb shell run-as com.avishio.atitia ls -la files/screenshots/`

### Screenshots Not Pulling
- Ensure device is connected: `adb devices`
- Check device permissions for external storage
- Try pulling manually from different locations (see pull script)

## 📚 Related Documentation

- [Screenshot Automation Guide](../docs/SCREENSHOT_AUTOMATION_GUIDE.md)
- [Google Play Screenshots Guide](../docs/GOOGLE_PLAY_SCREENSHOTS_GUIDE.md)
- [Integration Test README](../integration_test/README.md)
