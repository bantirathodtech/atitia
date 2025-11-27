# 🔐 Secret Verification Guide

This guide explains how secret verification works in the CI/CD pipeline.

---

## 📋 Table of Contents

1. [How Secret Verification Works](#how-secret-verification-works)
2. [Local Secrets Folder Structure](#local-secrets-folder-structure)
3. [Mapping: Local Files → GitHub Secrets](#mapping-local-files--github-secrets)
4. [Verification Methods](#verification-methods)
5. [Running Verification](#running-verification)

---

## 🔍 How Secret Verification Works

### Method 1: GitHub Actions Automatic Check

In the `verify-deployment-secrets` job, we check each secret using:

```bash
if [ -n "${{ secrets.SECRET_NAME }}" ]; then
  # Secret exists (non-empty string)
  SECRET_COUNT=$((SECRET_COUNT + 1))
else
  # Secret missing (empty string)
  echo "❌ SECRET_NAME not configured"
fi
```

**How it works:**
- `${{ secrets.SECRET_NAME }}` is evaluated by GitHub Actions
- **If secret EXISTS**: Returns the actual value (non-empty string)
- **If secret MISSING**: Returns `""` (empty string)
- We check: `[ -n "$value" ]` to see if it's non-empty

**Example:**
```bash
# Secret exists in GitHub
${{ secrets.ANDROID_KEYSTORE_BASE64 }}
→ Returns: "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDXGxf..."

# Secret missing in GitHub
${{ secrets.ANDROID_KEYSTORE_BASE64 }}
→ Returns: "" (empty)
```

---

## 📁 Local Secrets Folder Structure

Your `.secrets/` folder is organized as:

```
.secrets/
├── android/
│   ├── keystore.jks              # Android signing keystore
│   ├── keystore.properties       # Keystore passwords and alias
│   └── service_account.json      # Google Play Console API key
│
├── ios/                          # iOS certificates (future)
│   ├── Certificates.p12
│   ├── ProvisionProfile.mobileprovision
│   └── AppStoreConnect_APIKey.p8
│
└── common/
    ├── firebase_service_account.json  # Firebase service account
    └── .env                            # Environment variables
```

---

## 🔗 Mapping: Local Files → GitHub Secrets

### 🤖 Android Secrets (5 required)

| Local File | GitHub Secret | How to Add |
|------------|---------------|------------|
| `.secrets/android/keystore.jks` | `ANDROID_KEYSTORE_BASE64` | Base64 encode the file:<br>`base64 -i .secrets/android/keystore.jks \| tr -d '\n'` |
| `.secrets/android/keystore.properties`<br>`storePassword=xxx` | `ANDROID_KEYSTORE_PASSWORD` | Copy the password value |
| `.secrets/android/keystore.properties`<br>`keyAlias=xxx` | `ANDROID_KEY_ALIAS` | Copy the alias value |
| `.secrets/android/keystore.properties`<br>`keyPassword=xxx` | `ANDROID_KEY_PASSWORD` | Copy the password value |
| `.secrets/android/service_account.json` | `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` | Copy entire JSON content |

### 🍎 iOS Secrets (6 required - for future)

| Local File | GitHub Secret | How to Add |
|------------|---------------|------------|
| `.secrets/ios/Certificates.p12` | `IOS_CERTIFICATE_BASE64` | Base64 encode the file |
| Certificate password | `IOS_CERTIFICATE_PASSWORD` | Copy the password |
| `.secrets/ios/ProvisionProfile.mobileprovision` | `IOS_PROVISIONING_PROFILE_BASE64` | Base64 encode the file |
| `.secrets/ios/AppStoreConnect_APIKey.p8` (Key ID) | `APP_STORE_CONNECT_API_KEY_ID` | Extract key ID |
| `.secrets/ios/AppStoreConnect_APIKey.p8` (Issuer) | `APP_STORE_CONNECT_API_ISSUER` | Extract issuer |
| `.secrets/ios/AppStoreConnect_APIKey.p8` (Content) | `APP_STORE_CONNECT_API_KEY` | Copy key content |

### 🌐 Web/Firebase Secrets (2 required)

| Local File | GitHub Secret | How to Add |
|------------|---------------|------------|
| `.secrets/common/firebase_service_account.json` | `FIREBASE_SERVICE_ACCOUNT` | Copy entire JSON content |
| `.secrets/common/.env`<br>`FIREBASE_PROJECT_ID=xxx`<br>OR<br>`config/firebase.json` | `FIREBASE_PROJECT_ID` | Copy the project ID value |

---

## ✅ Verification Methods

### 1. Local Verification (Before Adding to GitHub)

**Run the verification script:**
```bash
bash scripts/verify-secrets-local.sh
```

**What it does:**
- ✅ Checks if files exist in `.secrets/` folder
- ✅ Maps local files to GitHub Secrets names
- ✅ Shows what you have locally vs what's needed
- ✅ Provides next steps

**Example output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 LOCAL SECRETS VERIFICATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🤖 ANDROID SECRETS (Required: 5)
✅ keystore.jks found (2.5K)
   → GitHub Secret: ANDROID_KEYSTORE_BASE64
❌ service_account.json NOT FOUND
   → GitHub Secret: GOOGLE_PLAY_SERVICE_ACCOUNT_JSON

Android Summary: 4/5 secrets found locally
```

### 2. GitHub Actions Verification (Automatic)

**When it runs:**
- After: `test`, `code-quality`, `security-audit` jobs
- Before: Build jobs start
- In: `verify-deployment-secrets` job

**What it does:**
- ✅ Checks all required secrets in GitHub
- ✅ Counts how many are configured
- ✅ Sets outputs: `android_deploy_enabled`, `ios_deploy_enabled`, `web_deploy_enabled`
- ✅ Provides clear skip messages for missing secrets

**Example output:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 VERIFYING DEPLOYMENT SECRETS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Android: 5/5 secrets configured
   → android_deploy_enabled = true

❌ iOS: 0/6 secrets configured
   → ios_deploy_enabled = false
   → Message: "Skipping iOS deployment - secrets not configured"

✅ Web/Firebase: 2/2 secrets configured
   → web_deploy_enabled = true
```

---

## 🚀 Running Verification

### Step 1: Check Local Secrets

```bash
# Navigate to project root
cd /path/to/atitia

# Run local verification script
bash scripts/verify-secrets-local.sh
```

### Step 2: Add Missing Secrets to GitHub

1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Click **New repository secret**
3. Add each secret following the mapping table above

### Step 3: Verify in Production Pipeline

When you trigger the production pipeline (via tag), the `verify-deployment-secrets` job will automatically:
- ✅ Check all secrets
- ✅ Enable/disable platform deployments
- ✅ Show clear status messages

---

## 📝 Complete Secret Checklist

### ✅ Android (5 secrets)
- [ ] `ANDROID_KEYSTORE_BASE64` - Base64 encoded keystore
- [ ] `ANDROID_KEYSTORE_PASSWORD` - Keystore password
- [ ] `ANDROID_KEY_ALIAS` - Key alias name
- [ ] `ANDROID_KEY_PASSWORD` - Key password
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Service account JSON

### ✅ Web/Firebase (2 secrets)
- [ ] `FIREBASE_SERVICE_ACCOUNT` - Firebase service account JSON
- [ ] `FIREBASE_PROJECT_ID` - Firebase project ID

### ⏸️ iOS (6 secrets - optional for now)
- [ ] `IOS_CERTIFICATE_BASE64` - Base64 encoded certificate
- [ ] `IOS_CERTIFICATE_PASSWORD` - Certificate password
- [ ] `IOS_PROVISIONING_PROFILE_BASE64` - Base64 encoded profile
- [ ] `APP_STORE_CONNECT_API_KEY_ID` - API key ID
- [ ] `APP_STORE_CONNECT_API_ISSUER` - API issuer
- [ ] `APP_STORE_CONNECT_API_KEY` - API key content

---

## 💡 Key Points

1. **Local `.secrets/` folder** is your backup/reference, never commit it
2. **GitHub Secrets** are what the CI/CD pipeline actually uses
3. **Verification job** runs automatically in production pipeline
4. **Missing secrets** = platform deployment skipped (pipeline doesn't fail)
5. **All secrets configured** = platform deployment enabled

---

## 🔗 Related Documentation

- [GitHub Secrets Setup Guide](../GITHUB_SECRETS_SETUP.md)
- [CI/CD Enterprise Guide](../CI_CD_ENTERPRISE_GUIDE.md)
- [Production Pipeline](../.github/workflows/production-pipeline.yml)

