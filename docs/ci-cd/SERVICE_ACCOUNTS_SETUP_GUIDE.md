# 🔐 Service Accounts Setup Guide

Complete guide to organize and configure all service accounts for CI/CD.

---

## 📋 Service Accounts Overview

We have **2 user-created service accounts** for CI/CD:

1. ✅ **`play-store-upload@atitia-87925.iam.gserviceaccount.com`**
   - **Purpose:** Google Play Store uploads (Android CI/CD)
   - **Location:** `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json`
   - **GitHub Secret:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
   - **Status:** ✅ JSON key exists

2. ⏸️ **`firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`**
   - **Purpose:** Firebase Hosting deployments (Web CI/CD)
   - **Location:** `.secrets/web/FIREBASE_SERVICE_ACCOUNT.json`
   - **GitHub Secret:** `FIREBASE_SERVICE_ACCOUNT`
   - **Status:** ⏸️ JSON key needs to be created

---

## 🔧 Step-by-Step Setup

### Step 1: Verify Android Service Account (Already Done ✅)

**File:** `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json`

**Verify it contains:**
- `"client_email": "play-store-upload@atitia-87925.iam.gserviceaccount.com"`

**GitHub Secret:**
- Name: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- Value: Copy entire JSON from `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json`

---

### Step 2: Create Firebase Hosting Service Account JSON Key ⏸️

**Service Account:** `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`

#### 2.1 Go to Service Accounts Page

🔗 **Direct Link:** https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925

#### 2.2 Find and Click the Service Account

1. Find: `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`
2. Click on the service account email/name

#### 2.3 Create JSON Key

1. Go to the **"KEYS"** tab
2. Click **"ADD KEY"** → **"Create new key"**
3. Select **"JSON"** format
4. Click **"CREATE"**
5. The JSON file will download automatically (usually named like `atitia-87925-xxxxx.json`)

#### 2.4 Save to Local Secrets

1. Open the downloaded JSON file
2. Copy the **entire JSON content**
3. Replace the content in:
   ```
   .secrets/web/FIREBASE_SERVICE_ACCOUNT.json
   ```
4. Verify the JSON contains:
   - `"client_email": "firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com"`
   - `"type": "service_account"`
   - Valid `private_key`

---

### Step 3: Add to GitHub Secrets

#### 3.1 Google Play Service Account

1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Find or create secret: **`GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`**
3. Open: `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json`
4. Copy entire JSON content
5. Paste into GitHub Secret
6. Click **"Update secret"** or **"Add secret"**

#### 3.2 Firebase Service Account

1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Find or create secret: **`FIREBASE_SERVICE_ACCOUNT`**
3. Open: `.secrets/web/FIREBASE_SERVICE_ACCOUNT.json`
4. Copy entire JSON content
5. Paste into GitHub Secret
6. Click **"Update secret"** or **"Add secret"**

---

## ✅ Verification Checklist

After completing all steps:

### Local Files
- [ ] `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json` exists
- [ ] `.secrets/android/GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json` contains `play-store-upload@...`
- [ ] `.secrets/web/FIREBASE_SERVICE_ACCOUNT.json` exists
- [ ] `.secrets/web/FIREBASE_SERVICE_ACCOUNT.json` contains `firebase-hosting-deploy@...`
- [ ] Both JSON files are valid (can be parsed as JSON)

### GitHub Secrets
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret exists
- [ ] `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` contains correct JSON
- [ ] `FIREBASE_SERVICE_ACCOUNT` secret exists
- [ ] `FIREBASE_SERVICE_ACCOUNT` contains correct JSON

### Service Account Permissions
- [ ] `play-store-upload@...` has Google Play Console permissions
- [ ] `firebase-hosting-deploy@...` has Firebase Hosting Admin role

---

## 📁 File Structure

```
.secrets/
├── android/
│   └── GOOGLE_PLAY_SERVICE_ACCOUNT_JSON.json  ✅ (play-store-upload)
├── web/
│   └── FIREBASE_SERVICE_ACCOUNT.json          ⏸️ (firebase-hosting-deploy - needs key)
└── backups/
    └── service-accounts/
        └── firebase-adminsdk-fbsvc-backup-*.json  (backup only)
```

---

## 🔒 Security Notes

1. **Never commit JSON keys to Git** (already in `.gitignore`)
2. **Keep backups** in `.secrets/backups/service-accounts/`
3. **Rotate keys periodically** (every 90 days recommended)
4. **Each service account has minimal permissions** (principle of least privilege)

---

## 🚀 Quick Reference

### Service Account Console
🔗 https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925

### GitHub Secrets
🔗 https://github.com/bantirathodtech/atitia/settings/secrets/actions

### Google Play Console
🔗 https://play.google.com/console

---

## 📚 Related Documentation

- [Service Accounts Inventory](./SERVICE_ACCOUNTS_INVENTORY.md)
- [Create Firebase Hosting Service Account](./CREATE_FIREBASE_HOSTING_SERVICE_ACCOUNT.md)
- [Update Service Account Descriptions](./UPDATE_SERVICE_ACCOUNT_DESCRIPTIONS.md)

---

**Last Updated:** 2025-01-27

