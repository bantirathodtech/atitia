# 📋 Step-by-Step Guide: Prepare iOS Files for Deployment

Follow these steps **one by one** to prepare all required files, then run the script.

---

## ✅ Checklist

Before running the script, you need:
- [ ] iOS Certificate exported (.p12 file)
- [ ] Provisioning Profile downloaded (.mobileprovision file)
- [ ] App Store Connect API Key created (.p8 file)
- [ ] All file paths noted down

---

## 🔐 Step 1: Export iOS Certificate (.p12)

### Time: ~5 minutes

1. **Open Keychain Access:**
   - Press `Cmd + Space` (Spotlight)
   - Type: `Keychain Access`
   - Press Enter

2. **Select Keychain:**
   - In the left sidebar, select **"Login"** keychain (not "System")

3. **Find Your Certificate:**
   - Look for certificates named:
     - `Apple Distribution: [Your Name]` (most common)
     - OR `iPhone Distribution: [Your Name]`
     - OR `Apple Development: [Your Name]` (if Distribution not found)
   
   **Note:** If you don't see any, you may need to create one first (see Step 1.5 below)

4. **Export Certificate:**
   - Right-click on the certificate
   - Select **"Export [Certificate Name]"**
   - Save as: `atitia-distribution.p12`
   - Choose location: **Desktop** (easy to find)
   - Click **"Save"**

5. **Set Password:**
   - When prompted, enter a password
   - **Remember this password!** (You'll need it for GitHub Secret: `IOS_CERTIFICATE_PASSWORD`)
   - Click **"OK"**

6. **Security Prompt:**
   - macOS may ask for your admin password to export
   - Enter your password and click **"Allow"**

✅ **Done!** You now have: `atitia-distribution.p12` on your Desktop

---

### 🔧 Step 1.5: Create Certificate (If Not Found)

**If you don't see any distribution certificate:**

#### Option A: Using Xcode (Easiest)

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing:**
   - Select **Runner** project (blue icon)
   - Select **Runner** target
   - Go to **Signing & Capabilities** tab
   - Check **"Automatically manage signing"**
   - Select your **Team** (Apple Developer account)
   - Xcode will automatically create the certificate!

3. **Go back to Keychain Access** - You should now see the certificate

#### Option B: Create in Apple Developer Portal

1. Go to https://developer.apple.com/account
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Certificates** → **+** (Add)
4. Select **App Store and Ad Hoc** → Continue
5. Follow the wizard to create and download certificate
6. Double-click to install in Keychain

---

## 📦 Step 2: Download Provisioning Profile (.mobileprovision)

### Time: ~5 minutes

### Option A: Using Xcode (Recommended)

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Download Profiles:**
   - Go to **Xcode** menu → **Preferences** (or `Cmd + ,`)
   - Click **Accounts** tab
   - Select your Apple ID
   - Click **"Download Manual Profiles"**
   - Wait for download (may take 1-2 minutes)

3. **Find Profile Path:**
   - Profiles are saved in: `~/Library/MobileDevice/Provisioning Profiles/`
   - To see them:
     ```bash
     ls ~/Library/MobileDevice/Provisioning\ Profiles/
     ```
   - Look for file matching `com.avishio.atitia`

✅ **Note the file path** - You'll need this for the script

---

### Option B: Download from Apple Developer Portal

1. Go to https://developer.apple.com/account
2. Navigate to **Certificates, Identifiers & Profiles** → **Profiles**
3. Find profile for: `com.avishio.atitia`
4. Click **Download**
5. Save to Desktop: `atitia-provisioning.mobileprovision`

✅ **Note the file path** - You'll need this for the script

---

## 🔑 Step 3: Create App Store Connect API Key (.p8)

### Time: ~10 minutes

1. **Go to App Store Connect:**
   - Open: https://appstoreconnect.apple.com
   - Sign in with your Apple ID

2. **Navigate to API Keys:**
   - Click your name (top right)
   - Go to **Users and Access**
   - Click **Keys** tab
   - Click **App Store Connect API** section

3. **Check Issuer ID:**
   - At the top, you'll see **Issuer ID** (UUID format)
   - **Copy this now!** You'll need it for: `APP_STORE_CONNECT_API_ISSUER`
   - Example: `12345678-1234-1234-1234-123456789012`

4. **Create API Key:**
   - Click **+** (Generate API Key) button
   - **Name**: `Atitia CI/CD` (or any name you prefer)
   - **Access**: Select **App Manager** (or **Admin** if you have access)
   - Click **Generate**

5. **Save Credentials:**
   - **Key ID**: Copy this (e.g., `ABC123DEF4`) 
     - You'll need it for: `APP_STORE_CONNECT_API_KEY_ID`
   - **Download Key**: Click **Download API Key**
     - File downloads as: `AuthKey_ABC123DEF4.p8`
     - **⚠️ IMPORTANT**: You can only download this once!
     - Save to Desktop

6. **Save the File:**
   - The `.p8` file should be on your Desktop
   - Filename: `AuthKey_[KEY_ID].p8`

✅ **Done!** You now have:
- ✅ Key ID (e.g., `ABC123DEF4`)
- ✅ Issuer ID (UUID)
- ✅ `.p8` file on Desktop

---

## 📝 Step 4: Note All File Paths

Before running the script, note down all file paths:

### File Paths:

1. **Certificate:**
   ```
   /Users/[YOUR_USERNAME]/Desktop/atitia-distribution.p12
   ```
   - Or wherever you saved it

2. **Provisioning Profile:**
   ```
   ~/Library/MobileDevice/Provisioning Profiles/[UUID].mobileprovision
   ```
   - OR if downloaded manually:
   ```
   /Users/[YOUR_USERNAME]/Desktop/atitia-provisioning.mobileprovision
   ```

3. **API Key:**
   ```
   /Users/[YOUR_USERNAME]/Desktop/AuthKey_[KEY_ID].p8
   ```

### Other Info Needed:

4. **Certificate Password:** The password you set when exporting `.p12`
5. **Key ID:** From App Store Connect (e.g., `ABC123DEF4`)
6. **Issuer ID:** From App Store Connect (UUID format)

---

## 🚀 Step 5: Run the Script

Once you have all files ready:

```bash
./scripts/setup-ios-secrets.sh
```

**When prompted:**
1. Enter path to `.p12` certificate file
2. Enter certificate password
3. Enter path to `.mobileprovision` file
4. Enter path to `.p8` API key file

The script will:
- ✅ Convert everything to base64
- ✅ Copy values to clipboard
- ✅ Show you what to paste into GitHub Secrets

---

## ✅ Verification

After running the script, you should have:

- ✅ `IOS_CERTIFICATE_BASE64` - Base64 string (copied to clipboard)
- ✅ `IOS_CERTIFICATE_PASSWORD` - Your password
- ✅ `IOS_PROVISIONING_PROFILE_BASE64` - Base64 string (copied to clipboard)
- ✅ `APP_STORE_CONNECT_API_KEY_ID` - Key ID
- ✅ `APP_STORE_CONNECT_API_ISSUER` - Issuer ID (UUID)
- ✅ `APP_STORE_CONNECT_API_KEY` - Base64 string (copied to clipboard)

---

## 🆘 Troubleshooting

### "No certificate found in Keychain"
- **Solution**: Use Xcode to create certificate (Step 1.5)

### "Can't export certificate"
- **Solution**: 
  - Make sure you selected "Login" keychain (not System)
  - Enter your admin password when prompted
  - Try exporting again

### "Provisioning profile not found"
- **Solution**:
  - Make sure you downloaded profiles in Xcode
  - Check: `ls ~/Library/MobileDevice/Provisioning\ Profiles/`
  - If empty, use Option B (download from Apple Developer Portal)

### "API Key download failed"
- **Solution**:
  - Make sure you have App Manager or Admin access
  - Try refreshing the page
  - Check if you already have maximum API keys (limit is 3)

---

## 📚 Next Steps

After running the script:

1. **Add Secrets to GitHub:**
   - Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
   - Add all 6 secrets (values from script output/clipboard)

2. **Verify Setup:**
   - Check all secrets are added
   - Refer to `IOS_WEB_DEPLOYMENT_SETUP.md` for details

3. **Test Deployment:**
   - Create version tag: `git tag v1.0.2 && git push origin v1.0.2`
   - Monitor: https://github.com/bantirathodtech/atitia/actions

---

**Ready?** Start with Step 1 and work through each step! ✅

