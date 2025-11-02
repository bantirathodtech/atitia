# 🚀 Atitia App - Deployment Guide

This guide covers the steps to prepare and deploy the Atitia app to Google Play Store and Apple App Store.

---

## 📋 **PRE-DEPLOYMENT CHECKLIST**

### ✅ Code & Configuration
- [x] All features implemented and tested
- [x] Version number set in `pubspec.yaml` (1.0.0+1)
- [x] App ID configured (`com.avishio.atitia`)
- [x] Firebase configuration files present
- [x] CI/CD workflows created

### ⚠️ **REQUIRED BEFORE DEPLOYMENT**

#### 1. **Android Production Signing**

**Step 1: Generate Keystore**
```bash
keytool -genkey -v -keystore ~/atitia-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias atitia-release
```

**Step 2: Create `android/key.properties`**
```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=atitia-release
storeFile=../keystore.jks  # Path relative to android/app
```

**Step 3: Update `android/app/build.gradle.kts`**
```kotlin
// Add before android block
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // Add proguard rules if needed
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}
```

#### 2. **iOS Code Signing**

**In Xcode:**
1. Open `ios/Runner.xcworkspace`
2. Select Runner target → Signing & Capabilities
3. Select your Team
4. Configure Provisioning Profile for App Store distribution
5. Set Bundle Identifier: `com.avishio.atitia`

#### 3. **GitHub Secrets Setup** (for CI/CD)

Required secrets for automated deployment:

**Android:**
- `ANDROID_KEYSTORE_BASE64` - Base64 encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD` - Keystore password
- `ANDROID_KEY_ALIAS` - Key alias
- `ANDROID_KEY_PASSWORD` - Key password
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Service account JSON

**iOS:**
- `APP_STORE_CONNECT_API_KEY_ID` - API Key ID
- `APP_STORE_CONNECT_API_ISSUER` - API Issuer ID
- `APP_STORE_CONNECT_API_KEY` - API Key (P8 file content)
- `APPLE_ID` - Apple Developer account email
- `APPLE_APP_SPECIFIC_PASSWORD` - App-specific password

**Firebase:**
- `FIREBASE_PROJECT_ID` - Firebase project ID
- `FIREBASE_SERVICE_ACCOUNT` - Service account JSON

---

## 📱 **GOOGLE PLAY STORE DEPLOYMENT**

### 1. **Create Google Play Developer Account**
- Visit: https://play.google.com/console
- Pay $25 one-time registration fee
- Complete account setup

### 2. **Prepare App Listing**
- App name: "Atitia - PG Management"
- Short description (80 chars)
- Full description (4000 chars)
- Screenshots (phone, tablet, 7" tablet, 10" tablet)
- Feature graphic (1024x500)
- Icon (512x512)
- Privacy Policy URL
- Support URL

### 3. **Build Release Bundle**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### 4. **Upload to Play Console**
1. Go to Play Console → Create App
2. Fill in app details
3. Go to Production → Create release
4. Upload `app-release.aab`
5. Complete content rating questionnaire
6. Submit for review

---

## 🍎 **APPLE APP STORE DEPLOYMENT**

### 1. **Create Apple Developer Account**
- Visit: https://developer.apple.com
- Pay $99/year membership
- Complete enrollment

### 2. **Create App ID & Provisioning Profiles**
1. Go to Certificates, Identifiers & Profiles
2. Create App ID: `com.avishio.atitia`
3. Create Distribution Certificate
4. Create App Store Provisioning Profile

### 3. **Configure in Xcode**
```bash
# Open Xcode project
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select Runner target
# 2. Signing & Capabilities
# 3. Select Team
# 4. Choose Provisioning Profile
```

### 4. **Build IPA**
```bash
flutter build ipa --release
```
Output: `build/ios/ipa/atitia.ipa`

### 5. **Upload to App Store Connect**
1. Go to https://appstoreconnect.apple.com
2. Create App → New App
3. Fill in app information
4. Upload build via Xcode or Transporter
5. Complete App Store listing
6. Submit for review

---

## 🌐 **WEB DEPLOYMENT (Firebase Hosting)**

### 1. **Build Web App**
```bash
flutter build web --release
```

### 2. **Deploy to Firebase**
```bash
firebase deploy --only hosting
```

Or use CI/CD workflow (automated on tag push).

---

## 🔄 **CI/CD AUTOMATION**

### Manual Trigger
```bash
# Create version tag
git tag v1.0.0
git push origin v1.0.0
```

### Automated Workflows
- **CI**: Runs on every push/PR (analyze, test, build)
- **Deploy**: Runs on version tags (deploy to stores)

---

## 📝 **VERSION MANAGEMENT**

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # 1.0.0 = version name, +1 = build number
```

For each release:
- Increment version name (1.0.0 → 1.0.1)
- Increment build number (+1 → +2)

---

## ✅ **POST-DEPLOYMENT**

### Monitor
- [ ] Check crash reports (Firebase Crashlytics)
- [ ] Monitor analytics (Firebase Analytics)
- [ ] Review user feedback
- [ ] Monitor app performance

### Updates
- Use same process for updates
- Increment version/build number
- Test thoroughly before submitting

---

## 🆘 **TROUBLESHOOTING**

### Android Build Issues
- **Signing errors**: Verify `key.properties` and keystore path
- **Build fails**: Run `flutter clean && flutter pub get`

### iOS Build Issues
- **Code signing**: Verify Team and Provisioning Profile in Xcode
- **Pod install**: Run `cd ios && pod install`

### Deployment Issues
- **Play Store**: Check bundle size (max 150MB)
- **App Store**: Verify all required screenshots uploaded

---

## 📞 **SUPPORT**

For deployment issues, refer to:
- [Flutter Deployment Docs](https://flutter.dev/docs/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

---

**Last Updated:** $(date)  
**App Version:** 1.0.0+1

