# 📸 Integration Test - Screenshot Automation

Professional, production-ready screenshot automation system for Atitia app.

## 📁 Structure

```
integration_test/
├── config/
│   └── screenshot_config.dart      # Screenshot definitions and configuration
├── services/
│   └── screenshot_service.dart     # Screenshot capture service
├── helpers/
│   ├── mock_auth_helper.dart       # Mock authentication helper
│   └── navigation_helper.dart      # Navigation helper
├── screenshots/
│   ├── guest_flow_screenshots_test.dart    # Guest flow test
│   ├── owner_flow_screenshots_test.dart    # Owner flow test
│   └── all_screenshots_test.dart           # Complete test (both flows)
└── README.md                        # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Device/Emulator Connected**
   ```bash
   adb devices
   ```

2. **App Built and Installed**
   ```bash
   flutter build apk --profile
   flutter install
   ```

### Run Screenshot Capture

**Capture All Screenshots (Guest + Owner):**
```bash
bash scripts/dev/capture_screenshots.sh
```

**Capture Only Guest Flow:**
```bash
bash scripts/dev/capture_screenshots.sh --guest-only
```

**Capture Only Owner Flow:**
```bash
bash scripts/dev/capture_screenshots.sh --owner-only
```

**Capture Only Required Screenshots:**
```bash
bash scripts/dev/capture_screenshots.sh --required-only
```

**Specify Device:**
```bash
bash scripts/dev/capture_screenshots.sh --device emulator-5554
```

## 📋 Screenshot Configuration

Screenshots are defined in `config/screenshot_config.dart`. Each screenshot includes:

- **Name**: Unique identifier (e.g., `01_guest_dashboard_pg_listings`)
- **Description**: Human-readable description
- **Route**: App route to navigate to
- **Navigation Steps**: Optional navigation actions
- **Required**: Whether screenshot is required
- **Priority**: Capture order priority

### Guest Screenshots

1. ✅ Guest Dashboard - PG Listings (Required)
2. ✅ PG Details Screen (Required)
3. Guest Booking Requests
4. Guest Payment History
5. Guest Food Menu
6. Guest Complaints
7. Guest Profile

### Owner Screenshots

1. ✅ Owner Dashboard Overview (Required)
2. ✅ Owner PG Management (Required)
3. Owner Guest Management
4. Owner Food Management
5. Owner Analytics
6. Owner Profile

## 🔧 Customization

### Adding New Screenshots

Edit `config/screenshot_config.dart`:

```dart
ScreenshotDefinition(
  name: 'new_screenshot_name',
  description: 'Description of the screen',
  route: '/route/to/screen',
  navigationSteps: {
    'action': 'navigate_to_tab',
    'tab_index': 1,
  },
  required: false,
  priority: 8,
),
```

### Modifying Navigation

Edit `helpers/navigation_helper.dart` to add custom navigation methods.

### Mock Authentication

Edit `helpers/mock_auth_helper.dart` to customize authentication flow.

## 🏗️ Architecture

### Components

1. **ScreenshotConfig**: Centralized configuration
2. **ScreenshotService**: Handles screenshot capture and organization
3. **MockAuthHelper**: Simulates user authentication
4. **NavigationHelper**: Programmatic navigation through app

### Flow

```
1. Start App
   ↓
2. Authenticate (Mock/Real)
   ↓
3. Navigate to Screen
   ↓
4. Wait for Stabilization
   ↓
5. Capture Screenshot
   ↓
6. Save with Metadata
   ↓
7. Generate Report
```

## 📊 Output

Screenshots are saved to:
```
screenshots/play_store/YYYYMMDD_HHMMSS/
├── 01_guest_dashboard_pg_listings_TIMESTAMP.png
├── 02_pg_details_screen_TIMESTAMP.png
├── ...
├── README.md
└── capture.log
```

## 🐛 Troubleshooting

### Screenshots Not Captured

1. **Check Device Connection**
   ```bash
   adb devices
   ```

2. **Check App Installation**
   ```bash
   adb shell pm list packages | grep atitia
   ```

3. **Check Logs**
   ```bash
   cat screenshots/play_store/*/capture.log
   ```

### Navigation Fails

- Ensure routes are correct in `screenshot_config.dart`
- Check if UI elements exist (may need to update finders)
- Verify authentication state

### Authentication Issues

- Update `mock_auth_helper.dart` for your auth flow
- Or manually login before running tests
- Check if test accounts exist

## 📚 Documentation

- **Screenshot Guide**: `docs/GOOGLE_PLAY_SCREENSHOTS_GUIDE.md`
- **Store Listing**: `docs/STORE_LISTING_TEMPLATE.md`
- **Automation Script**: `scripts/dev/capture_screenshots.sh`

## 🔄 Maintenance

### Updating Screenshots

1. Update `screenshot_config.dart` with new screens
2. Test navigation in `navigation_helper.dart`
3. Run capture script
4. Review and adjust

### Adding New Flows

1. Create new test file in `screenshots/`
2. Define screenshots in config
3. Add navigation logic
4. Update automation script

## ✅ Best Practices

1. **Test Before Capture**: Ensure app works correctly
2. **Use Real Data**: Fill screens with realistic content
3. **Check Quality**: Review screenshots before uploading
4. **Version Control**: Don't commit screenshots (gitignored)
5. **Document Changes**: Update config when adding screens

## 📞 Support

For issues or questions:
- Check logs in `screenshots/play_store/*/capture.log`
- Review test output for errors
- Consult `docs/GOOGLE_PLAY_SCREENSHOTS_GUIDE.md`

---

**Last Updated:** 2024
**Version:** 1.0.0

