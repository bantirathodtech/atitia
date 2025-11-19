# 📸 Screenshot Retrieval Guide

This guide explains how to retrieve screenshots captured by Flutter's `integration_test` framework from Android devices.

## 🔍 Where Integration Test Saves Screenshots

Flutter's `integration_test` framework saves screenshots to:
- **Android**: `/data/data/<package>/files/screenshots/` (app's private directory)
- **iOS**: App's documents directory

These locations are **not directly accessible** via ADB without root or special permissions.

## 🚀 Retrieval Methods

### Method 1: Automatic Pull (Recommended)

The capture script automatically attempts to pull screenshots after the test completes:

```bash
bash scripts/dev/capture_screenshots.sh --device <device_id>
```

This runs the pull script automatically at the end of the capture process.

### Method 2: Manual Pull Script

If screenshots weren't automatically pulled, use the dedicated pull script:

```bash
bash scripts/dev/pull_screenshots.sh --device <device_id> --output screenshots/play_store/<session_dir>
```

The script attempts multiple methods:
1. Copy from app's private files to external storage
2. Pull from external storage (`/sdcard/Pictures/AtitiaScreenshots/`)
3. Pull from Android/data directory
4. Search for recent PNG files on device

### Method 3: Manual ADB Commands

If automated methods fail, try these manual commands:

#### Step 1: Copy to External Storage
```bash
# Copy screenshots from private directory to external storage
adb -s <device_id> shell "run-as com.avishio.atitia sh -c 'mkdir -p /sdcard/Pictures/AtitiaScreenshots && cp -r files/screenshots/* /sdcard/Pictures/AtitiaScreenshots/ 2>/dev/null || true'"
```

#### Step 2: Pull from External Storage
```bash
# Pull screenshots from external storage
adb -s <device_id> pull /sdcard/Pictures/AtitiaScreenshots/ screenshots/play_store/<session_dir>/
```

#### Step 3: Verify
```bash
# Check if screenshots were pulled
ls -lh screenshots/play_store/<session_dir>/*.png
```

## 📁 Project Structure

Screenshots are organized in the following structure:

```
screenshots/
└── play_store/
    └── YYYYMMDD_HHMMSS/          # Timestamped session
        ├── *.png                  # Screenshot files
        ├── capture.log            # Capture session log
        └── README.md              # Session summary
```

## 🔧 Troubleshooting

### Issue: "No screenshots found"

**Possible causes:**
1. Test didn't complete successfully
2. Screenshots weren't saved to device
3. Device permissions issue

**Solutions:**
1. Check `capture.log` for errors
2. Verify test completed: `grep "All tests passed" capture.log`
3. Check device storage manually:
   ```bash
   adb -s <device_id> shell "run-as com.avishio.atitia ls -la files/screenshots/ 2>/dev/null"
   ```

### Issue: "Permission denied" when pulling

**Solution:**
- Ensure device is connected and authorized: `adb devices`
- Try copying to external storage first (see Method 3)
- Check if device has external storage permissions

### Issue: Screenshots in wrong location

**Solution:**
- Integration test saves to app's private directory
- Use the pull script to copy to accessible location
- Check build output directory: `build/app/outputs/`

## 📝 Best Practices

1. **Always use the capture script** - It handles pulling automatically
2. **Check logs first** - Review `capture.log` for any errors
3. **Verify count** - Ensure all expected screenshots were captured
4. **Organize by session** - Keep screenshots in timestamped directories
5. **Document issues** - Note any problems in the session README

## 🔄 Future Improvements

Planned enhancements:
- [ ] Automatic screenshot copying to external storage during capture
- [ ] Better error handling and retry logic
- [ ] Support for iOS screenshot retrieval
- [ ] Automatic screenshot organization and naming
- [ ] Integration with CI/CD for automated screenshot updates

## 📚 Related Documentation

- [Screenshot Automation Guide](./SCREENSHOT_AUTOMATION_GUIDE.md)
- [Integration Test README](../integration_test/README.md)
- [Screenshots README](../screenshots/README.md)

