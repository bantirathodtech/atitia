# 🚀 Quick Start: Deploy Atitia to App Stores

**Estimated Time:** 30-60 minutes

This is a condensed guide to get you deploying quickly. For detailed instructions, see the full documentation.

---

## ⚡ **QUICK SETUP STEPS**

### 1️⃣ **Android Production Signing** (15 minutes)

```bash
# Run the setup script
bash scripts/setup-android-signing.sh

# Follow the prompts to create keystore
# Script will create android/key.properties automatically
```

**Verify:**
- ✅ `android/keystore.jks` exists
- ✅ `android/key.properties` exists
- ✅ Files are in `.gitignore`

---

### 2️⃣ **Generate GitHub Secrets** (10 minutes)

```bash
# Generate base64 keystore for GitHub
bash scripts/generate-keystore-base64.sh

# Copy the output to GitHub Secrets → ANDROID_KEYSTORE_BASE64
```

**Add to GitHub Secrets:**
1. Go to: GitHub Repo → Settings → Secrets and variables → Actions
2. Add these secrets (see `docs/GITHUB_SECRETS_SETUP.md` for details):
   - `ANDROID_KEYSTORE_BASE64` (from script output)
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS` (usually `atitia-release`)
   - `ANDROID_KEY_PASSWORD`

---

### 3️⃣ **iOS Code Signing** (15 minutes)

```bash
# Open Xcode project
open ios/Runner.xcworkspace
```

**In Xcode:**
1. Select **Runner** target
2. Go to **Signing & Capabilities**
3. Select your **Team**
4. Verify Bundle ID: `com.avishio.atitia`
5. Check "Automatically manage signing"

**Verify:**
- ✅ Team selected shows green checkmark
- ✅ Provisioning profile shows "Valid"

---

### 4️⃣ **Test Builds Locally** (10 minutes)

```bash
# Test Android build
flutter build appbundle --release

# Test iOS build
flutter build ipa --release

# Test web build
flutter build web --release
```

**If builds succeed, you're ready for CI/CD!**

---

## 🎯 **DEPLOY USING CI/CD**

### Option A: Automated Deployment (Recommended)

```bash
# 1. Ensure all GitHub secrets are added (see step 2 above)
# 2. Create version tag
git tag v1.0.0
git push origin v1.0.0

# 3. GitHub Actions will automatically:
#    - Build Android AAB
#    - Build iOS IPA
#    - Build Web
#    - Deploy to stores (if secrets configured)
```

### Option B: Manual Deployment

**Android:**
```bash
# Build
flutter build appbundle --release

# Upload manually to Google Play Console
# Location: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
# Build
flutter build ipa --release

# Upload via Xcode or Transporter
# Location: build/ios/ipa/atitia.ipa
```

---

## 📋 **CHECKLIST BEFORE FIRST DEPLOYMENT**

### Code
- [x] Version set in `pubspec.yaml` (1.0.0+1)
- [x] All features tested
- [x] No critical bugs

### Android
- [ ] Keystore created (`scripts/setup-android-signing.sh`)
- [ ] `android/key.properties` configured
- [ ] GitHub secrets added
- [ ] Test build successful

### iOS
- [ ] Apple Developer account active
- [ ] Xcode signing configured
- [ ] Test build successful
- [ ] App Store Connect API key created (for CI/CD)

### Store Listings
- [ ] App store screenshots prepared
- [ ] App descriptions written (see `docs/STORE_LISTING_TEMPLATE.md`)
- [ ] Privacy policy URL ready
- [ ] Support contact information ready

---

## 📱 **STORE SUBMISSION**

### Google Play Store
1. Create developer account ($25 one-time)
2. Create app in Play Console
3. Fill in store listing (use template)
4. Upload AAB
5. Submit for review

### Apple App Store
1. Create developer account ($99/year)
2. Create app in App Store Connect
3. Fill in store listing (use template)
4. Upload IPA via Xcode
5. Submit for review

---

## 🆘 **NEED HELP?**

**Full Documentation:**
- `DEPLOYMENT_GUIDE.md` - Complete deployment guide
- `docs/GITHUB_SECRETS_SETUP.md` - Secrets configuration
- `docs/IOS_SIGNING_SETUP.md` - iOS signing details
- `docs/STORE_LISTING_TEMPLATE.md` - Store listing templates

**Common Issues:**
- Android signing: Check `android/key.properties` exists
- iOS signing: Verify Team selected in Xcode
- CI/CD fails: Check GitHub secrets are correctly formatted

---

**Ready to deploy? Start with Step 1 above!** 🚀

