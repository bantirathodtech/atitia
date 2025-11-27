# 🔐 Service Accounts Inventory

Complete inventory of all service accounts in the Google Cloud project `atitia-87925`, their purposes, and how to manage them.

---

## 📋 Service Accounts Overview

| Email | Type | Status | Description | Editable? |
|-------|------|--------|-------------|-----------|
| `atitia-87925@appspot.gserviceaccount.com` | Google-managed | Enabled | App Engine default service account | ✅ Yes |
| `665010238088-compute@developer.gserviceaccount.com` | Google-managed | Enabled | Default compute service account | ✅ Yes |
| `firebase-adminsdk-fbsvc@atitia-87925.iam.gserviceaccount.com` | Firebase-managed | Enabled | Firebase Admin SDK Service Agent | ❌ No |
| `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com` | User-created | Enabled | Firebase Hosting deployments (CI/CD for Web) | ✅ Yes |
| `play-store-upload@atitia-87925.iam.gserviceaccount.com` | User-created | Enabled | Google Play Store uploads (CI/CD for Android) | ✅ Yes |

---

## 📝 Detailed Descriptions

### 1. App Engine Default Service Account

**Email:** `atitia-87925@appspot.gserviceaccount.com`  
**Type:** Google-managed (Auto-created by App Engine)  
**Purpose:** Default service account for App Engine applications  
**Use Case:** Used by App Engine to access other Google Cloud services  
**Roles:** Editor (full project access)  
**Can Edit Description:** ✅ Yes (Description field is editable in the UI)  
**Can Delete:** ❌ No (Required for App Engine)  
**Key Management:** No keys (managed by Google)

**Recommended Description (short & clear):**
> App Engine default service account - Used by App Engine runtime for accessing Google Cloud services. Auto-managed by Google.

---

### 2. Default Compute Service Account

**Email:** `665010238088-compute@developer.gserviceaccount.com`  
**Type:** Google-managed (Auto-created by Compute Engine)  
**Purpose:** Default service account for Compute Engine VMs and instances  
**Use Case:** Used by Compute Engine instances to access other Google Cloud services  
**Roles:** Editor (full project access)  
**Can Edit Description:** ✅ Yes (Description field is editable in the UI)  
**Can Delete:** ❌ No (Required for Compute Engine)  
**Key Management:** No keys (managed by Google)

**Recommended Description (short & clear):**
> Default compute service account - Used by Compute Engine VMs and instances for accessing Google Cloud services. Auto-managed by Google.

---

### 3. Firebase Admin SDK Service Agent

**Email:** `firebase-adminsdk-fbsvc@atitia-87925.iam.gserviceaccount.com`  
**Type:** Firebase-managed (Auto-created by Firebase)  
**Purpose:** Firebase Admin SDK operations and backend services  
**Use Case:** Used by Firebase for Admin SDK operations, Authentication, App Check, and other Firebase backend services  
**Roles:** 
- Firebase Admin SDK Administrator Service Agent
- Firebase App Check Admin
- Firebase Authentication Admin
- Service Account Token Creator
**Can Edit Description:** ❌ No (Firebase-managed)  
**Can Delete:** ❌ No (Required for Firebase)  
**Key Management:** Has key (Key ID: `f6306444e5d720f5951381943250a2b69a0794ae`)

**Description (already set):**
> Firebase Admin SDK Service Agent

**Description to use (for documentation):**
> Firebase Admin SDK Service Agent - Used by Firebase for Admin SDK operations, Authentication, App Check, and backend services. Automatically created and managed by Firebase. Used for server-side Firebase operations.

---

### 4. Firebase Hosting Deploy (CI/CD)

**Email:** `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`  
**Type:** User-created (CI/CD account)  
**Purpose:** Firebase Hosting deployments via CI/CD pipeline  
**Use Case:** Used by GitHub Actions to deploy web app to Firebase Hosting  
**Roles:** Firebase Hosting Admin  
**Can Edit Description:** ✅ Yes  
**Current Description:** `Firebase Hosting deployments (CI/CD for Web)`  
**Can Delete:** ✅ Yes (if no longer needed)  
**Key Management:** No keys yet (needs to be created)

**How to Update Description:**
1. Go to: https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925
2. Click on: `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`
3. Click "EDIT" button (top right)
4. Update "Description" field
5. Click "SAVE"

**Recommended Description:**
> Firebase Hosting deployments (CI/CD for Web) - Dedicated service account for automated web deployments via GitHub Actions. Only has Firebase Hosting Admin permissions.

**GitHub Secret:** `FIREBASE_SERVICE_ACCOUNT`

---

### 5. Play Store Upload (CI/CD)

**Email:** `play-store-upload@atitia-87925.iam.gserviceaccount.com`  
**Type:** User-created (CI/CD account)  
**Purpose:** Google Play Store app uploads via CI/CD pipeline  
**Use Case:** Used by GitHub Actions to upload Android AAB/APK to Google Play Console  
**Roles:** Google Play Console permissions (granted in Play Console)  
**Can Edit Description:** ✅ Yes  
**Current Description:** `Google Play Store uploads (CI/CD for Android)`  
**Can Delete:** ✅ Yes (if no longer needed)  
**Key Management:** Has key (Key ID: `3e719649a334597a67f7de41b690b92a6a7c6784`)

**How to Update Description:**
1. Go to: https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925
2. Click on: `play-store-upload@atitia-87925.iam.gserviceaccount.com`
3. Click "EDIT" button (top right)
4. Update "Description" field
5. Click "SAVE"

**Recommended Description:**
> Google Play Store uploads (CI/CD for Android) - Dedicated service account for automated Android app uploads to Google Play Store via GitHub Actions. Permissions managed in Google Play Console.

**GitHub Secret:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`

---

## 🔧 How to Add/Update Descriptions

### For User-Created Service Accounts (Editable)

1. **Navigate to Service Accounts:**
   🔗 https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925

2. **Click on the service account** you want to edit

3. **Click "EDIT"** button (top right of the page)

4. **Update the "Description" field:**
   - For `firebase-hosting-deploy`: Use description above
   - For `play-store-upload`: Use description above

5. **Click "SAVE"**

### For Google/Firebase-Managed Accounts (Not Editable)

These accounts cannot have their descriptions changed:
- `atitia-87925@appspot.gserviceaccount.com`
- `665010238088-compute@developer.gserviceaccount.com`
- `firebase-adminsdk-fbsvc@atitia-87925.iam.gserviceaccount.com`

**Solution:** Document their purposes in this file instead.

---

## 📊 Service Account Strategy

### Current Setup (Option 2: Separate Accounts)

| Service Account | Purpose | Used For | Secret Name |
|----------------|---------|----------|-------------|
| `play-store-upload@...` | Android CI/CD | Google Play Store uploads | `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` |
| `firebase-hosting-deploy@...` | Web CI/CD | Firebase Hosting deployments | `FIREBASE_SERVICE_ACCOUNT` |
| `firebase-adminsdk-fbsvc@...` | Firebase backend | Firebase Admin SDK operations | Not used in CI/CD |

### Benefits of This Approach

✅ **Principle of Least Privilege:** Each account has only the permissions it needs  
✅ **Better Security:** If one account is compromised, others remain secure  
✅ **Clear Separation:** Easy to identify which account is used for what  
✅ **Easy Rotation:** Can rotate keys independently  
✅ **Audit Trail:** Clear logs showing which account performed which action

---

## 🔒 Security Best Practices

1. **Regular Key Rotation:**
   - Rotate service account keys every 90 days
   - Delete old keys after rotation

2. **Monitor Usage:**
   - Check Cloud Audit Logs regularly
   - Set up alerts for unusual activity

3. **Least Privilege:**
   - Only grant minimum required permissions
   - Review roles periodically

4. **Key Management:**
   - Never commit keys to Git
   - Store keys securely (GitHub Secrets)
   - Back up keys in `.secrets/backups/`

---

## 📝 Quick Reference

**Service Accounts Console:**
🔗 https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925

**IAM & Admin:**
🔗 https://console.cloud.google.com/iam-admin/iam?project=atitia-87925

**Audit Logs:**
🔗 https://console.cloud.google.com/iam-admin/audit?project=atitia-87925

---

## ✅ Action Items

- [ ] Update description for `firebase-hosting-deploy@...` (if needed)
- [ ] Update description for `play-store-upload@...` (if needed)
- [ ] Create JSON key for `firebase-hosting-deploy@...`
- [ ] Document Google-managed accounts (cannot edit, but document their purpose)

---

**Last Updated:** 2025-01-27  
**Project:** atitia-87925

