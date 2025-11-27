# 🚀 Create Firebase Hosting Service Account (Option 2)

This guide walks you through creating a dedicated service account **only** for Firebase Hosting deployments.

## 📋 Overview

**Service Account Strategy:**
- `play-store-upload@atitia-87925.iam.gserviceaccount.com` → Google Play Store uploads only
- `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com` → Firebase Hosting deployments only
- `firebase-adminsdk-fbsvc@atitia-87925.iam.gserviceaccount.com` → Firebase backend operations (auto-created, leave as-is)

## 🔧 Step-by-Step Instructions

### Step 1: Create the Service Account

1. Go to Google Cloud Console Service Accounts:
   🔗 **https://console.cloud.google.com/iam-admin/serviceaccounts?project=atitia-87925**

2. Click **"+ CREATE SERVICE ACCOUNT"** (top of the page)

3. Fill in the details:
   - **Service account name:** `firebase-hosting-deploy`
   - **Service account ID:** (auto-filled, e.g., `firebase-hosting-deploy`)
   - **Description:** `Service account for CI/CD Firebase Hosting deployments only`
   - Click **"CREATE AND CONTINUE"**

### Step 2: Grant Firebase Hosting Permissions

1. In the "Grant this service account access to project" section:
   - Click **"SELECT A ROLE"** dropdown
   - Search for: `Firebase Hosting Admin`
   - Select: **Firebase Hosting Admin**
   - Click **"CONTINUE"**

2. (Optional) Skip the "Grant users access to this service account" step
   - Click **"DONE"**

### Step 3: Create and Download JSON Key

1. Find your new service account in the list:
   `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`

2. Click on the service account email/name

3. Go to the **"KEYS"** tab

4. Click **"ADD KEY"** → **"Create new key"**

5. Select **"JSON"** format

6. Click **"CREATE"**

7. The JSON file will download automatically (usually named like `atitia-87925-xxxxx.json`)

### Step 4: Update Local Secrets File

1. Open the downloaded JSON file

2. Copy the **entire JSON content**

3. Replace the content in:
   ```
   .secrets/web/firebase_service_account.json
   ```

4. Verify the JSON contains:
   - `"client_email": "firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com"`
   - `"type": "service_account"`
   - Valid `private_key`

### Step 5: Update GitHub Secret

1. Go to GitHub Secrets:
   🔗 **https://github.com/bantirathodtech/atitia/settings/secrets/actions**

2. Find the secret: **FIREBASE_SERVICE_ACCOUNT**

3. Click **"Update"** (pencil icon)

4. Delete the old JSON content

5. Paste the **entire new JSON** (from the downloaded file)

6. Click **"Update secret"**

## ✅ Verification Checklist

After completing all steps, verify:

- [ ] Service account created: `firebase-hosting-deploy@atitia-87925.iam.gserviceaccount.com`
- [ ] Role assigned: **Firebase Hosting Admin**
- [ ] JSON key downloaded and saved
- [ ] Local file updated: `.secrets/web/firebase_service_account.json`
- [ ] GitHub Secret updated: `FIREBASE_SERVICE_ACCOUNT`
- [ ] JSON contains correct `client_email` (firebase-hosting-deploy, not play-store-upload)

## 🧪 Test the Deployment

1. Create a new tag to trigger the pipeline:
   ```bash
   git tag v1.0.5
   git push origin v1.0.5
   ```

2. Watch the Firebase deployment job in GitHub Actions

3. Check that it succeeds without permission errors

## 📝 Service Account Summary

| Service Account | Purpose | Roles | Used For |
|----------------|---------|-------|----------|
| `play-store-upload@...` | Android CI/CD | Google Play Console permissions | Android app uploads |
| `firebase-hosting-deploy@...` | Web CI/CD | Firebase Hosting Admin | Web deployments |
| `firebase-adminsdk-fbsvc@...` | Firebase backend | Multiple Firebase roles | Firebase internal ops |

## 🔒 Security Notes

- ✅ Each service account has **only** the permissions it needs (principle of least privilege)
- ✅ Separate credentials for different services (better isolation)
- ✅ If one account is compromised, others remain secure
- ⚠️ Keep JSON keys secure (never commit to git)
- ⚠️ Rotate keys periodically

## ❓ Troubleshooting

**Error: "Failed to get Firebase project"**
- Verify the service account has **Firebase Hosting Admin** role
- Check that `FIREBASE_PROJECT_ID` secret is correct

**Error: "Permission denied"**
- Ensure role is assigned in IAM: https://console.cloud.google.com/iam-admin/iam?project=atitia-87925
- Service account should appear in the IAM list with "Firebase Hosting Admin" role

**Deployment still uses old service account**
- Double-check GitHub Secret `FIREBASE_SERVICE_ACCOUNT` has the new JSON
- Verify `client_email` in the JSON matches `firebase-hosting-deploy@...`

