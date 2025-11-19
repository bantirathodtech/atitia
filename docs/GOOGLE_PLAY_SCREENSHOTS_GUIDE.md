# 📸 Google Play Store Screenshots Guide for Atitia

This guide provides recommendations for which screens to capture for your Google Play Store listing.

## 📋 Screenshot Requirements

**Technical Specifications:**
- **Minimum:** 2 screenshots
- **Maximum:** 8 screenshots
- **Recommended Size:** 1080 x 1920 pixels (or 1440 x 2560 for high-res)
- **Format:** PNG or JPG
- **Aspect Ratio:** 9:16 (portrait) or 16:9 (landscape) - portrait recommended

**Important:** The first 2-3 screenshots are the most critical as they appear in search results and initial store views.

---

## 🎯 Recommended Screenshot Order (Priority)

### **Screenshot 1: Hero - Guest Dashboard (MUST HAVE) ⭐**
**Screen:** Guest Dashboard - PG Listings Tab
**Why:** This is the primary user experience. Shows the app's main value proposition for guests.

**What to Show:**
- Guest dashboard with bottom navigation visible
- PG listings with search/filter options
- At least 2-3 PG cards with images, pricing, location
- Clean, modern UI showcasing the app's design quality
- Consider showing the search bar and filter options

**Key Message:** "Discover Your Perfect PG"

---

### **Screenshot 2: PG Details Screen (MUST HAVE) ⭐**
**Screen:** Guest PG Detail Screen
**Why:** Shows the depth of information and booking capability.

**What to Show:**
- Detailed PG view with photo gallery
- Amenities list
- Pricing information
- "Book Now" or booking request button
- Location map (if available)
- Room/bed availability status

**Key Message:** "Complete PG Information & Easy Booking"

---

### **Screenshot 3: Owner Dashboard Overview (HIGHLY RECOMMENDED) ⭐**
**Screen:** Owner Overview Dashboard
**Why:** Appeals to PG owners - shows the management capabilities.

**What to Show:**
- Owner dashboard with analytics/statistics
- Revenue overview cards
- Occupancy metrics
- Quick action buttons
- Multi-PG selector (if applicable)
- Clean, professional dashboard design

**Key Message:** "Manage Your PG Business Efficiently"

---

### **Screenshot 4: Booking/Request Flow (RECOMMENDED)**
**Screen:** Guest Booking Request Screen or Booking Status
**Why:** Shows the booking process is simple and transparent.

**What to Show:**
- Booking request form or booking status screen
- Selected PG information
- Booking details (dates, room type, etc.)
- Status indicators (pending/approved/rejected)
- Clear call-to-action buttons

**Key Message:** "Simple Booking Process"

---

### **Screenshot 5: Payment Management (RECOMMENDED)**
**Screen:** Guest Payment History or Owner Payment Tracking
**Why:** Highlights financial transparency and payment features.

**What to Show:**
- Payment history list with transactions
- Payment status indicators
- Amounts and dates
- "Pay Now" button (if applicable)
- Payment method options

**Key Message:** "Transparent Payment Tracking"

---

### **Screenshot 6: Food Menu (OPTIONAL)**
**Screen:** Guest Food Menu List or Owner Food Management
**Why:** Shows additional value-added features.

**What to Show:**
- Weekly food menu with meals
- Meal photos (if available)
- Breakfast, lunch, dinner options
- Clean, appetizing presentation

**Key Message:** "Food Menu at Your Fingertips"

---

### **Screenshot 7: Owner PG Management (OPTIONAL)**
**Screen:** Owner PG Management Screen
**Why:** Shows property management capabilities.

**What to Show:**
- List of managed PG properties
- Property cards with images
- Quick stats (occupancy, revenue)
- Add/Edit property options
- Floor plan or bed map view (if visible)

**Key Message:** "Complete Property Management"

---

### **Screenshot 8: Guest/Owner Profile or Settings (OPTIONAL)**
**Screen:** Profile Screen or Settings Screen
**Why:** Shows customization and user control.

**What to Show:**
- User profile with avatar
- Settings options (theme toggle, language selector)
- Account information
- Help & support options

**Key Message:** "Personalized Experience"

---

## 🎨 Screenshot Best Practices

### Design Guidelines

1. **Use Real Data (Not Placeholders)**
   - Fill screens with realistic, attractive data
   - Use high-quality PG images
   - Show actual pricing and locations

2. **Highlight Key Features**
   - Ensure important UI elements are visible
   - Don't crop out navigation or key buttons
   - Show the app's best UI moments

3. **Consistent Theme**
   - Use the same theme (light or dark) across all screenshots
   - Consider using light theme for better visibility
   - Or showcase both themes if it's a key feature

4. **Text Overlays (Optional)**
   - You can add text overlays on screenshots
   - Keep them minimal and readable
   - Examples: "Easy Booking", "Real-time Updates", "Secure Payments"

5. **Device Frame (Optional)**
   - Google Play allows device frames
   - Consider using modern device frames for professional look
   - Or use clean screenshots without frames

### Content Guidelines

1. **Show Both User Roles**
   - Mix guest and owner screenshots
   - First 2-3 should appeal to both audiences
   - Balance: 60% guest, 40% owner (or based on your target market)

2. **Feature Progression**
   - Start with discovery (PG listings)
   - Show engagement (details, booking)
   - End with management (payments, profile)

3. **Avoid Clutter**
   - Don't show error states
   - Avoid empty states if possible
   - Show screens with meaningful content

---

## 📱 Recommended Screenshot Sequence (8 Screenshots)

If you're using all 8 screenshots, here's the recommended order:

1. **Guest Dashboard - PG Listings** (Hero)
2. **PG Details Screen** (Booking focus)
3. **Owner Overview Dashboard** (Management focus)
4. **Booking Request/Status** (Process transparency)
5. **Payment History** (Financial transparency)
6. **Food Menu Screen** (Additional value)
7. **Owner PG Management** (Property management)
8. **Profile/Settings** (Customization)

---

## 🎯 Alternative: Focused 5-Screenshot Set

If you prefer fewer screenshots (5 is a good balance):

1. **Guest Dashboard - PG Listings** (Hero)
2. **PG Details Screen** (Booking)
3. **Owner Overview Dashboard** (Management)
4. **Payment Management** (Financial)
5. **Booking Status/Flow** (Process)

---

## 🔄 Dual-Role Strategy

Since your app serves two distinct user types, consider this approach:

### Option A: Guest-First (Recommended for broader appeal)
- Screenshots 1-2: Guest features (discovery, booking)
- Screenshot 3: Owner dashboard (shows it's for owners too)
- Screenshots 4-5: Shared features (payments, food)
- Screenshots 6-8: Advanced features (management, analytics)

### Option B: Balanced Approach
- Screenshot 1: Guest dashboard
- Screenshot 2: Owner dashboard
- Screenshots 3-4: Guest booking flow
- Screenshots 5-6: Owner management
- Screenshots 7-8: Shared features

---

## 📝 Screenshot Preparation Checklist

Before capturing screenshots:

- [ ] Test on multiple devices (phone, tablet)
- [ ] Ensure all screens have realistic, attractive data
- [ ] Use high-quality PG images
- [ ] Remove any debug indicators or test data
- [ ] Ensure text is readable at small sizes
- [ ] Check that navigation elements are visible
- [ ] Verify theme consistency (or intentional theme showcase)
- [ ] Test both light and dark themes
- [ ] Ensure no personal/sensitive data is visible
- [ ] Add text overlays if needed (keep minimal)
- [ ] Export at correct resolution (1080x1920 minimum)

---

## 🤖 Automated Screenshot Capture

**Yes, screenshot capture can be automated!** We've created automation tools for you.

### Option 1: Automated Integration Test (Recommended)

We've created an integration test that automatically navigates through screens and captures screenshots.

**Prerequisites:**
- Device/emulator connected
- App built and installed
- User logged in (or you'll need to customize the test for authentication)

**Usage:**
```bash
# Run the automated screenshot capture
bash scripts/dev/capture_screenshots.sh

# Or specify a device ID
bash scripts/dev/capture_screenshots.sh <device_id>
```

**What it does:**
1. Checks for connected devices
2. Builds and installs the app
3. Runs the integration test to capture screenshots
4. Organizes screenshots in `screenshots/play_store/` directory
5. Creates a summary report

**Customization:**
Edit `integration_test/screenshot_capture_test.dart` to:
- Add navigation steps for your specific screens
- Handle authentication flow
- Add delays for animations
- Capture additional screens

### Option 2: Manual Capture Helper

For more control, use the manual capture helper:

```bash
bash scripts/dev/capture_screenshots_manual.sh
```

This script:
1. Starts the app
2. Guides you through each screen to capture
3. Automatically pulls screenshots from device
4. Organizes them with proper naming

### Option 3: Direct ADB Commands

For quick manual captures:

```bash
# Take screenshot
adb shell screencap -p /sdcard/screenshot.png

# Pull screenshot
adb pull /sdcard/screenshot.png

# Or use the device's built-in screenshot (Power + Volume Down)
# Then pull from device
adb pull /sdcard/Pictures/Screenshots/
```

## 🎬 Manual Screenshot Capture Tips

### Using Flutter DevTools
```bash
# Run app in profile mode for best performance
flutter run --profile

# Use DevTools screenshot feature
# Or use device screenshot (Power + Volume Down on Android)
```

### Using Android Studio
1. Open Android Studio
2. Run app on emulator/device
3. Use View > Tool Windows > Device File Explorer
4. Navigate to screenshots folder

### Manual Capture Best Practices
- Use device screenshot feature (Power + Volume Down)
- Ensure app is in a clean state
- Hide system UI if possible (immersive mode)
- Wait for all animations to complete
- Ensure data is loaded (not loading states)

---

## 🎨 Post-Processing (Optional)

If you want to enhance screenshots:

1. **Add Text Overlays**
   - Use tools like Canva, Figma, or Photoshop
   - Keep text minimal and readable
   - Use your brand colors

2. **Add Device Frames**
   - Use tools like Screenshot Framer or App Store Screenshot Generator
   - Choose modern device frames
   - Keep it professional

3. **Optimize Images**
   - Compress if needed (but maintain quality)
   - Ensure PNG/JPG format
   - Check file size (should be reasonable)

---

## 📊 A/B Testing Recommendations

Consider testing different screenshot orders:

- **Test 1:** Guest-focused first 3 screenshots
- **Test 2:** Owner-focused first 3 screenshots
- **Test 3:** Balanced mix from the start

Monitor conversion rates and adjust based on performance.

---

## 🚀 Quick Start Checklist

### Automated Capture (Recommended)
- [ ] Review and customize `integration_test/screenshot_capture_test.dart`
- [ ] Ensure device/emulator is connected
- [ ] Run: `bash scripts/dev/capture_screenshots.sh`
- [ ] Review captured screenshots in `screenshots/play_store/`
- [ ] Resize to 1080x1920 if needed
- [ ] Upload to Google Play Console

### Manual Capture
- [ ] Guest Dashboard - PG Listings
- [ ] PG Details Screen
- [ ] Owner Overview Dashboard
- [ ] Payment Management
- [ ] Booking Flow
- [ ] Food Menu Screen (optional)
- [ ] Owner PG Management (optional)
- [ ] Profile/Settings Screen (optional)

### Screenshot Sets

**Minimum Viable Screenshot Set (2 screenshots):**
- [ ] Guest Dashboard - PG Listings
- [ ] PG Details Screen

**Recommended Set (5 screenshots):**
- [ ] Guest Dashboard - PG Listings
- [ ] PG Details Screen
- [ ] Owner Overview Dashboard
- [ ] Payment Management
- [ ] Booking Flow

**Complete Set (8 screenshots):**
- [ ] All 5 from recommended set
- [ ] Food Menu Screen
- [ ] Owner PG Management
- [ ] Profile/Settings Screen

---

## 📞 Need Help?

If you need assistance with:
- Identifying specific screen files in the codebase
- Understanding which screens to capture
- Setting up screenshot automation

Refer to:
- `lib/feature/guest_dashboard/` - Guest screens
- `lib/feature/owner_dashboard/` - Owner screens
- `docs/STORE_LISTING_TEMPLATE.md` - Store listing template
- `integration_test/screenshot_capture_test.dart` - Automation test
- `scripts/dev/capture_screenshots.sh` - Automation script

---

## 📚 Automation Files Reference

### Created Files

1. **`integration_test/screenshot_capture_test.dart`**
   - Integration test for automated screenshot capture
   - Customize navigation steps for your app
   - Handles authentication and screen navigation

2. **`scripts/dev/capture_screenshots.sh`**
   - Automated screenshot capture script
   - Handles device detection, app building, and screenshot organization
   - Creates timestamped directories for each capture session

3. **`scripts/dev/capture_screenshots_manual.sh`**
   - Manual capture helper script
   - Guides you through each screen
   - Automatically pulls screenshots from device

4. **`lib/common/utils/helpers/screenshot_helper.dart`**
   - Utility class for screenshot operations
   - Can be extended for programmatic captures

### Usage Examples

**Automated Capture:**
```bash
# Basic usage
bash scripts/dev/capture_screenshots.sh

# With specific device
bash scripts/dev/capture_screenshots.sh emulator-5554
```

**Manual Capture:**
```bash
bash scripts/dev/capture_screenshots_manual.sh
```

**Direct ADB:**
```bash
# Single screenshot
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png

# Pull all screenshots
adb pull /sdcard/Pictures/Screenshots/ ./screenshots/
```

---

**Last Updated:** 2024
**App Version:** Current production version

