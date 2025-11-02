# 🔐 GitHub Secrets Setup Guide for CI/CD

This guide walks you through setting up all required GitHub Secrets for automated CI/CD deployment.

---

## 📍 **WHERE TO ADD SECRETS**

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret listed below

---

## 🤖 **ANDROID SECRETS**

### 1. ANDROID_KEYSTORE_BASE64

**Description:** Base64-encoded Android keystore file (.jks)

**How to generate:**
```bash
# Run the provided script (after creating keystore)
bash scripts/generate-keystore-base64.sh

# OR manually:
base64 -i android/keystore.jks | tr -d '\n'
```

**Value:** Copy the entire base64 string (no line breaks)

**Required:** ✅ Yes (for automated Android deployment)

---

### 2. ANDROID_KEYSTORE_PASSWORD

**Description:** Password for the Android keystore file

**Value:** The password you set when creating the keystore

**Security:** Store in a password manager, never commit to code

**Required:** ✅ Yes (for automated Android deployment)

---

### 3. ANDROID_KEY_ALIAS

**Description:** Alias name of the signing key

**Default Value:** `atitia-release`

**Required:** ✅ Yes (for automated Android deployment)

---

### 4. ANDROID_KEY_PASSWORD

**Description:** Password for the signing key (may be same as keystore password)

**Value:** The key password you set when creating the keystore

**Required:** ✅ Yes (for automated Android deployment)

---

### 5. GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

**Description:** JSON content of Google Play Console Service Account for API access

**How to create:**
1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Setup** → **API access**
3. Click **Create new service account**
4. Follow the wizard to create service account
5. Download the JSON key file
6. Copy the entire JSON content (including all braces)

**Value:** Full JSON content (one line or multi-line, GitHub handles both)

**Required:** ✅ Yes (for automated Play Store upload)

---

## 🍎 **iOS SECRETS**

### 6. APP_STORE_CONNECT_API_KEY_ID

**Description:** App Store Connect API Key ID

**How to create:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys** → **App Store Connect API**
3. Click the **+** button to create a new key
4. Select **App Manager** role (or appropriate role)
5. Copy the **Key ID** (starts with a letter, e.g., `ABC123DEF4`)

**Value:** The Key ID (alphanumeric string)

**Required:** ✅ Yes (for automated iOS deployment)

---

### 7. APP_STORE_CONNECT_API_ISSUER

**Description:** App Store Connect API Issuer ID

**Where to find:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to **Users and Access** → **Keys** → **App Store Connect API**
3. Copy the **Issuer ID** (UUID format, e.g., `12345678-1234-1234-1234-123456789012`)

**Value:** The Issuer ID (UUID format)

**Required:** ✅ Yes (for automated iOS deployment)

---

### 8. APP_STORE_CONNECT_API_KEY

**Description:** App Store Connect API Key (private key .p8 file content)

**How to create:**
1. When creating the API key in App Store Connect, download the `.p8` file
2. Open the `.p8` file in a text editor
3. Copy the entire content (including `-----BEGIN PRIVATE KEY-----` and `-----END PRIVATE KEY-----`)

**Value:** Full private key content

**Security:** ⚠️ **CRITICAL** - This is a private key, keep it secure!

**Required:** ✅ Yes (for automated iOS deployment)

---

### 9. APPLE_ID

**Description:** Your Apple Developer account email

**Value:** Your Apple ID email (e.g., `yourname@example.com`)

**Required:** ⚠️ Optional (only if using password-based authentication instead of API key)

---

### 10. APPLE_APP_SPECIFIC_PASSWORD

**Description:** App-specific password for Apple ID (if using password auth)

**How to create:**
1. Go to [appleid.apple.com](https://appleid.apple.com)
2. Sign in with your Apple ID
3. Go to **Sign-In and Security** → **App-Specific Passwords**
4. Click **Generate an app-specific password**
5. Copy the generated password (16 characters, no spaces)

**Value:** 16-character password

**Required:** ⚠️ Optional (only if using password-based authentication)

---

## 🔥 **FIREBASE SECRETS**

### 11. FIREBASE_PROJECT_ID

**Description:** Your Firebase project ID

**Where to find:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Project Settings** (gear icon)
4. Copy the **Project ID**

**Value:** Your Firebase project ID (e.g., `atitia-pg-management`)

**Required:** ✅ Yes (for automated web deployment)

---

### 12. FIREBASE_SERVICE_ACCOUNT

**Description:** Firebase Service Account JSON for deployment

**How to create:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Go to **Project Settings** → **Service Accounts**
4. Click **Generate new private key**
5. Download the JSON file
6. Copy the entire JSON content

**Value:** Full JSON content of the service account

**Required:** ✅ Yes (for automated Firebase Hosting deployment)

---

## 📋 **COMPLETE SECRETS CHECKLIST**

### Android Deployment
- [ ] ANDROID_KEYSTORE_BASE64
- [ ] ANDROID_KEYSTORE_PASSWORD
- [ ] ANDROID_KEY_ALIAS
- [ ] ANDROID_KEY_PASSWORD
- [ ] GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

### iOS Deployment
- [ ] APP_STORE_CONNECT_API_KEY_ID
- [ ] APP_STORE_CONNECT_API_ISSUER
- [ ] APP_STORE_CONNECT_API_KEY
- [ ] APPLE_ID (optional, if using password auth)
- [ ] APPLE_APP_SPECIFIC_PASSWORD (optional, if using password auth)

### Web Deployment
- [ ] FIREBASE_PROJECT_ID
- [ ] FIREBASE_SERVICE_ACCOUNT

---

## 🔒 **SECURITY BEST PRACTICES**

1. **Never commit secrets to code**
   - All secrets should be in GitHub Secrets only
   - Double-check `.gitignore` includes sensitive files

2. **Use separate secrets for staging/production**
   - Consider using GitHub Environments for different secrets per environment

3. **Rotate secrets regularly**
   - Update API keys and passwords periodically
   - Revoke unused service accounts

4. **Limit access**
   - Only give access to trusted team members
   - Use principle of least privilege for service accounts

5. **Monitor usage**
   - Check GitHub Actions logs for any exposed secrets
   - Monitor API usage in Google Play Console and App Store Connect

---

## 🧪 **TESTING SECRETS**

After adding secrets, test the CI/CD pipeline:

1. **Create a test tag:**
   ```bash
   git tag v1.0.0-test
   git push origin v1.0.0-test
   ```

2. **Check GitHub Actions:**
   - Go to **Actions** tab in GitHub
   - Watch the workflow run
   - Check for any authentication errors

3. **Verify deployments:**
   - Android: Check Google Play Console → Internal Testing
   - iOS: Check App Store Connect → TestFlight
   - Web: Check Firebase Hosting

---

## 🆘 **TROUBLESHOOTING**

### Android Deployment Fails

**Error: "Signing config not found"**
- ✅ Verify ANDROID_KEYSTORE_BASE64 is correct
- ✅ Check that all password secrets match your keystore
- ✅ Ensure keystore file is valid (try decoding locally)

**Error: "Invalid service account"**
- ✅ Verify GOOGLE_PLAY_SERVICE_ACCOUNT_JSON is valid JSON
- ✅ Check service account has "Release apps" permission in Play Console
- ✅ Ensure service account is linked in Play Console → API access

### iOS Deployment Fails

**Error: "Invalid API key"**
- ✅ Verify APP_STORE_CONNECT_API_KEY_ID matches the key in App Store Connect
- ✅ Check APP_STORE_CONNECT_API_KEY contains full .p8 content
- ✅ Ensure API key has "App Manager" or appropriate role

**Error: "Code signing failed"**
- ✅ Verify provisioning profiles are configured in Xcode
- ✅ Check certificates are valid in Apple Developer Portal
- ✅ Ensure bundle ID matches: `com.avishio.atitia`

### Firebase Deployment Fails

**Error: "Permission denied"**
- ✅ Verify FIREBASE_SERVICE_ACCOUNT has deployment permissions
- ✅ Check FIREBASE_PROJECT_ID is correct
- ✅ Ensure Firebase Hosting is enabled in Firebase Console

---

## 📞 **SUPPORT**

If you encounter issues:
1. Check GitHub Actions logs for detailed error messages
2. Verify all secrets are correctly formatted (no extra spaces, line breaks)
3. Test secrets manually (build locally first)
4. Review service account permissions in respective consoles

---

**Last Updated:** $(date)  
**For:** Atitia v1.0.0+1

