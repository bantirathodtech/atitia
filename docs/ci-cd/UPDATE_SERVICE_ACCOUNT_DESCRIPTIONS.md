# 📝 Update Service Account Descriptions

Quick guide to add/update descriptions for better clarity on what each service account is used for.

---

## 🔧 How to Edit Service Account Descriptions

### Step 1: Open Service Accounts Page

🔗 **Direct Link:** https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925

### Step 2: Edit Each Account

1. **Click on the service account** you want to edit (click the email/name)
2. **Click "EDIT"** button (top right corner)
3. **Update the "Description" field** with the text below
4. **Click "SAVE"**

---

## 📋 Descriptions to Use

### ✅ Editable Service Accounts

#### 1. `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`

**Current Description:**
```
Firebase Hosting deployments (CI/CD for Web)
```

**Recommended Description (if you want more detail):**
```
Firebase Hosting deployments (CI/CD for Web) - Dedicated service account for automated web deployments via GitHub Actions. Only has Firebase Hosting Admin permissions.
```

**Status:** ✅ Already has a good description (can update if needed)

---

#### 2. `play-store-upload@atitia-87925.iam.gserviceaccount.com`

**Current Description:**
```
Google Play Store uploads (CI/CD for Android)
```

**Recommended Description (if you want more detail):**
```
Google Play Store uploads (CI/CD for Android) - Dedicated service account for automated Android app uploads to Google Play Store via GitHub Actions. Permissions managed in Google Play Console.
```

**Status:** ✅ Already has a good description (can update if needed)

---

### ✅ Google-Managed Service Accounts (Description Field Editable)

These accounts are Google-managed, but you **can** add descriptions:

#### 3. `atitia-87925@appspot.gserviceaccount.com`

**Type:** Google-managed (App Engine default)  
**Purpose:** App Engine default service account  
**Recommended Description:**
```
App Engine default service account - Used by App Engine runtime for accessing Google Cloud services. Auto-managed by Google.
```

**Status:** ✅ Description field is editable

---

#### 4. `665010238088-compute@developer.gserviceaccount.com`

**Type:** Google-managed (Compute Engine default)  
**Purpose:** Default compute service account  
**Recommended Description:**
```
Default compute service account - Used by Compute Engine VMs and instances for accessing Google Cloud services. Auto-managed by Google.
```

**Status:** ✅ Description field is editable

---

#### 5. `firebase-adminsdk-fbsvc@atitia-87925.iam.gserviceaccount.com`

**Type:** Firebase-managed  
**Purpose:** Firebase Admin SDK operations  
**Current Description:**
```
Firebase Admin SDK Service Agent
```

**Description (for documentation):**
```
Firebase Admin SDK Service Agent - Used by Firebase for Admin SDK operations, Authentication, App Check, and backend services. Automatically created and managed by Firebase. Used for server-side Firebase operations.
```

**Why you can't edit:** It's a Firebase-managed system account

---

## ✅ Quick Action Checklist

- [ ] Add description to `atitia-87925@appspot.gserviceaccount.com` (App Engine default)
- [ ] Add description to `665010238088-compute@developer.gserviceaccount.com` (Compute Engine default)
- [ ] Review current descriptions for `firebase-hosting-deploy@...` (already has good description)
- [ ] Review current descriptions for `play-store-upload@...` (already has good description)

---

## 📚 Full Documentation

For complete service account inventory, see:
📖 **[Service Accounts Inventory](./SERVICE_ACCOUNTS_INVENTORY.md)**

---

**Last Updated:** 2025-01-27

