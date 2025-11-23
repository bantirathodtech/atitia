# 📱 Tablet Screenshots Guide for Google Play Store

This guide will help you create tablet screenshots (7-inch and 10-inch) for Google Play Store publishing without needing a physical tablet.

## 🎯 Requirements

**7-inch Tablet Screenshots:**
- Upload up to 8 screenshots
- PNG or JPEG format
- Up to 8 MB each
- 16:9 or 9:16 aspect ratio
- Each side between 320 px and 3,840 px

**10-inch Tablet Screenshots:**
- Upload up to 8 screenshots
- PNG or JPEG format
- Up to 8 MB each
- 16:9 or 9:16 aspect ratio
- Each side between 1,080 px and 7,680 px

---

## 🚀 Method 1: Using Android Studio AVD Manager (Recommended)

### Step 1: Open Android Studio AVD Manager

1. Open **Android Studio**
2. Go to **Tools** → **Device Manager** (or click the Device Manager icon in the toolbar)
3. Click **Create Device**

### Step 2: Create 7-inch Tablet Emulator

1. In the **Virtual Device Configuration** window:
   - Select **Tablet** category
   - Choose **7.0" WSVGA (Tablet)** or **7.0" WXGA (Tablet)**
   - Click **Next**

2. Select a **System Image**:
   - Choose the latest **API Level** (e.g., API 34, API 35)
   - Click **Download** if needed
   - Click **Next**

3. **Verify Configuration**:
   - **AVD Name**: `Tablet_7inch` (or your preferred name)
   - **Startup orientation**: Portrait (recommended for screenshots)
   - Click **Finish**

### Step 3: Create 10-inch Tablet Emulator

1. Repeat Step 2, but this time:
   - Select **10.1" WXGA (Tablet)** or **10.1" WXGA (Tablet)**
   - **AVD Name**: `Tablet_10inch`
   - Click **Finish**

### Step 4: Start the Emulators

1. In **Device Manager**, click the **Play** button (▶️) next to your 7-inch tablet
2. Wait for the emulator to boot (this may take a few minutes the first time)
3. Repeat for the 10-inch tablet

---

## 📸 Method 2: Using Command Line (Alternative)

### Create 7-inch Tablet Emulator

```bash
# List available system images
avdmanager list system-images

# Create 7-inch tablet AVD
avdmanager create avd \
  -n Tablet_7inch \
  -k "system-images;android-34;google_apis;x86_64" \
  -d "7.0in WSVGA (Tablet)"

# Start the emulator
emulator -avd Tablet_7inch &
```

### Create 10-inch Tablet Emulator

```bash
# Create 10-inch tablet AVD
avdmanager create avd \
  -n Tablet_10inch \
  -k "system-images;android-34;google_apis;x86_64" \
  -d "10.1in WXGA (Tablet)"

# Start the emulator
emulator -avd Tablet_10inch &
```

---

## 🎬 Capturing Screenshots

### Option A: Using Existing Screenshot Script

Once your tablet emulators are running:

```bash
# List connected devices
flutter devices

# Capture screenshots on 7-inch tablet
bash scripts/dev/capture_screenshots.sh --device <7inch_emulator_id>

# Capture screenshots on 10-inch tablet
bash scripts/dev/capture_screenshots.sh --device <10inch_emulator_id>
```

### Option B: Manual Screenshot Capture

1. **Run the app on the tablet emulator:**
   ```bash
   # For 7-inch tablet
   flutter run -d <7inch_emulator_id>
   
   # For 10-inch tablet
   flutter run -d <10inch_emulator_id>
   ```

2. **Navigate to key screens:**
   - Guest Dashboard (PG Listings)
   - PG Details Screen
   - Owner Dashboard Overview
   - Booking Request Screen
   - Payment History
   - Food Menu
   - Profile Screen
   - Settings Screen

3. **Take screenshots using ADB:**
   ```bash
   # Take screenshot
   adb -s <device_id> shell screencap -p /sdcard/screenshot.png
   
   # Pull screenshot to your computer
   adb -s <device_id> pull /sdcard/screenshot.png screenshots/tablet_7inch/
   
   # Or use the emulator's built-in screenshot (three-dot menu → Screenshot)
   ```

### Option C: Using Emulator's Built-in Screenshot

1. In the emulator, click the **three-dot menu** (⋮) on the side panel
2. Click **Screenshot**
3. Screenshot will be saved to your Downloads folder
4. Organize them in `screenshots/tablet_7inch/` or `screenshots/tablet_10inch/`

---

## 📁 Organizing Screenshots

Create the following directory structure:

```
screenshots/
├── tablet_7inch/
│   ├── 01_guest_dashboard.png
│   ├── 02_pg_details.png
│   ├── 03_owner_dashboard.png
│   ├── 04_booking_request.png
│   ├── 05_payment_history.png
│   ├── 06_food_menu.png
│   ├── 07_profile.png
│   └── 08_settings.png
└── tablet_10inch/
    ├── 01_guest_dashboard.png
    ├── 02_pg_details.png
    ├── 03_owner_dashboard.png
    ├── 04_booking_request.png
    ├── 05_payment_history.png
    ├── 06_food_menu.png
    ├── 07_profile.png
    └── 08_settings.png
```

---

## ✅ Screenshot Checklist

For each tablet size, capture these screens (in order of priority):

- [ ] **Screenshot 1**: Guest Dashboard - PG Listings
- [ ] **Screenshot 2**: PG Details Screen
- [ ] **Screenshot 3**: Owner Dashboard Overview
- [ ] **Screenshot 4**: Booking Request Screen
- [ ] **Screenshot 5**: Payment History
- [ ] **Screenshot 6**: Food Menu
- [ ] **Screenshot 7**: Profile Screen
- [ ] **Screenshot 8**: Settings Screen

---

## 🎨 Tips for Best Results

1. **Clean State**: Ensure the app shows real data, not loading states
2. **Wait for Animations**: Let all animations complete before capturing
3. **Hide System UI**: Use immersive mode if possible (hide status bar)
4. **Consistent Orientation**: Use portrait mode for all screenshots
5. **High Quality**: Use the highest resolution available on the emulator
6. **No Overlays**: Remove any debug overlays or development tools

---

## 🔧 Troubleshooting

### Emulator is Slow
- Enable hardware acceleration in AVD settings
- Allocate more RAM to the emulator (2GB minimum)
- Use x86_64 system images (faster than ARM)

### Screenshots are Blurry
- Increase emulator resolution in AVD settings
- Use high-DPI system images
- Check screenshot resolution matches requirements

### Can't Find Emulator
```bash
# List all available devices
flutter devices

# List all AVDs
avdmanager list avd
```

---

## 📝 Quick Reference Commands

```bash
# List connected devices
flutter devices

# List AVDs
avdmanager list avd

# Start emulator
emulator -avd Tablet_7inch &

# Take screenshot via ADB
adb -s <device_id> shell screencap -p /sdcard/screenshot.png
adb -s <device_id> pull /sdcard/screenshot.png .

# Run app on specific device
flutter run -d <device_id>
```

---

## 🎯 Next Steps

1. Create both tablet emulators (7-inch and 10-inch)
2. Run the app on each emulator
3. Navigate through key screens
4. Capture 8 screenshots for each tablet size
5. Verify screenshot dimensions meet requirements
6. Upload to Google Play Console

Good luck with your app publishing! 🚀

