# 🚀 Deployment Checklist - Atitia App

## ✅ Pre-Deployment Status

### Code Quality
- ✅ **Zero compilation errors** (0 errors)
- ✅ **App running** on port 8080
- ✅ **All test files** compile successfully
- ✅ **CI/CD pipelines** configured and ready

### Git Status
- ⚠️ **Uncommitted changes** detected
- 📝 **Need to commit** before deployment

---

## 📋 Step-by-Step Deployment Process

### **STEP 1: Commit All Changes** ✅ Required

```bash
# Check current changes
git status

# Add all changes
git add .

# Commit with descriptive message
git commit -m "fix: resolve all compilation errors and test issues

- Fixed all critical errors in core services
- Resolved ViewModel method signatures
- Fixed test mocks and integration tests
- Added missing packages (mockito, integration_test)
- Updated app for production readiness"

# Push to updates branch
git push origin updates
```

**⚠️ Important:** Based on your workflow, create a PR from `updates` to `main` if needed.

---

### **STEP 2: Add GitHub Secrets** 🔐 Required for Automated Deployment

Go to: **GitHub Repository → Settings → Secrets and variables → Actions**

#### **Required Secrets (Minimum for Web Deployment):**

1. **FIREBASE_SERVICE_ACCOUNT_KEY** (for Web deployment)
   - Get from Firebase Console → Project Settings → Service Accounts
   - Download JSON key file
   - Convert to base64: `base64 -i service-account-key.json | tr -d '\n'`
   - Paste as secret value

#### **Additional Secrets (for Android/iOS):**

2. **ANDROID_KEYSTORE_BASE64**
   ```bash
   base64 -i android/keystore.jks | tr -d '\n'
   ```

3. **ANDROID_KEYSTORE_PASSWORD**
   - The password you used when creating the keystore

4. **ANDROID_KEY_ALIAS**
   - Usually: `atitia-release`

5. **ANDROID_KEY_PASSWORD**
   - Usually same as keystore password

6. **IOS_CERTIFICATE_BASE64** (for iOS deployment)
7. **IOS_CERTIFICATE_PASSWORD** (for iOS deployment)
8. **APPLE_ID** (for App Store Connect)
9. **APPLE_APP_SPECIFIC_PASSWORD** (for App Store Connect)

**📖 Detailed Guide:** See `docs/GITHUB_SECRETS_SETUP.md`

---

### **STEP 3: Create Version Tag** 🏷️

```bash
# Check current version
cat pubspec.yaml | grep "^version:"

# Create and push version tag (semantic versioning)
git tag v1.0.0
git push origin v1.0.0

# OR use workflow_dispatch in GitHub Actions UI
```

**Note:** The `deploy.yml` workflow triggers on tags matching `v*.*.*` pattern.

---

### **STEP 4: Trigger Deployment** 🚀

#### **Option A: Automatic (Recommended)**
- Push a version tag: `git push origin v1.0.0`
- Deployment pipeline will automatically start

#### **Option B: Manual Trigger**
1. Go to GitHub → Actions tab
2. Select "🚀 Deploy to Stores - Production"
3. Click "Run workflow"
4. Enter version tag (e.g., `v1.0.0`)
5. Click "Run workflow"

---

### **STEP 5: Monitor Deployment** 📊

1. Go to **GitHub → Actions** tab
2. Watch the deployment workflow progress:
   - ✅ Validate Deployment
   - 📦 Build Android (if secrets configured)
   - 📦 Build iOS (if secrets configured)
   - 🌐 Deploy Web to Firebase Hosting
   - 📱 Upload to Play Store (if configured)
   - 📱 Upload to App Store (if configured)

---

## 🎯 Quick Start (Minimum Setup for Web Only)

If you just want to deploy **Web** to Firebase Hosting:

```bash
# 1. Commit changes
git add .
git commit -m "Ready for web deployment"
git push origin updates

# 2. Add FIREBASE_SERVICE_ACCOUNT_KEY secret in GitHub

# 3. Create tag
git tag v1.0.0
git push origin v1.0.0
```

The web deployment will work with just `FIREBASE_SERVICE_ACCOUNT_KEY`.

---

## 📝 Current Status

- ✅ **Code Ready:** 0 errors, app running
- ⚠️ **Git:** Needs commit
- ⚠️ **Secrets:** Need to add in GitHub
- ⚠️ **Tag:** Need to create version tag

---

## 🔗 Helpful Links

- **GitHub Secrets:** `docs/GITHUB_SECRETS_SETUP.md`
- **Full Deployment Guide:** `DEPLOYMENT_GUIDE.md`
- **Quick Reference:** `QUICK_START_DEPLOYMENT.md`

---

## 🆘 Troubleshooting

### If deployment fails:
1. Check GitHub Actions logs
2. Verify secrets are correctly added
3. Check Firebase project configuration
4. Ensure version tag format is correct (`v1.0.0`)

---

**Ready to deploy?** Follow Step 1-5 above! 🚀

