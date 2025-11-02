# 🔐 Create iOS Distribution Certificate - Quick Guide

**Current Status:**
- ✅ Development certificate found
- ❌ Distribution certificate needed (for App Store)
- ❌ Provisioning profiles need to be downloaded

---

## 🚀 Easiest Method: Use Xcode (5 minutes)

### Step 1: Open Xcode Project

```bash
open ios/Runner.xcworkspace
```

### Step 2: Configure Signing in Xcode

1. **In Xcode:**
   - Click on **Runner** project (blue icon) in left sidebar
   - Select **Runner** target under "TARGETS"
   - Click **"Signing & Capabilities"** tab

2. **Enable Automatic Signing:**
   - ✅ Check **"Automatically manage signing"**
   - Select your **Team**: "bantirathod123@gmail.com (HLP6DJ67VT)" or your team name
   - **Bundle Identifier** should show: `com.avishio.atitia`

3. **Xcode will automatically:**
   - ✅ Create Distribution certificate (if needed)
   - ✅ Create App Store provisioning profile
   - ✅ Configure everything for you!

4. **Wait for Xcode to finish:**
   - Look for green checkmark (✓)
   - If you see errors, let me know and I'll help fix them

---

### Step 3: Verify Certificate Created

After Xcode finishes, run this command:

```bash
security find-identity -v -p codesigning | grep -i distribution
```

You should now see:
```
"Apple Distribution: [Your Name]"
```

---

### Step 4: Download Provisioning Profiles

**Still in Xcode:**

1. **Go to Preferences:**
   - Xcode menu → **Preferences** (or `Cmd + ,`)
   - Click **Accounts** tab
   - Select your Apple ID: `bantirathod123@gmail.com`
   - Click **"Download Manual Profiles"** button
   - Wait 1-2 minutes for download

2. **Verify Profiles Downloaded:**
   ```bash
   ls ~/Library/MobileDevice/Provisioning\ Profiles/
   ```
   You should see files like: `[UUID].mobileprovision`

---

## ✅ After Xcode Setup

Once Xcode has created everything:

1. **Certificate is ready** - You can now export it (see Step 1 in PREPARE_IOS_FILES_GUIDE.md)
2. **Provisioning profile is ready** - Already downloaded to your Mac
3. **Next:** Export certificate and note file paths, then run the script

---

## 🔄 Alternative: Manual Certificate Creation

If Xcode doesn't work, you can create manually:

1. Go to: https://developer.apple.com/account
2. Certificates, Identifiers & Profiles → Certificates
3. Click "+" → App Store and Ad Hoc
4. Follow wizard to create and download
5. Double-click to install in Keychain

---

## 📝 Next Steps

After Xcode creates the certificate:

1. **Export Certificate** (.p12):
   - Open Keychain Access
   - Find "Apple Distribution: [Your Name]"
   - Export as `.p12` → Save to Desktop
   - Set password

2. **Find Provisioning Profile Path:**
   ```bash
   ls ~/Library/MobileDevice/Provisioning\ Profiles/ | grep -i atitia
   ```

3. **Run the script:**
   ```bash
   ./scripts/setup-ios-secrets.sh
   ```

---

**Ready?** Open Xcode now and follow Step 2 above! 🚀

