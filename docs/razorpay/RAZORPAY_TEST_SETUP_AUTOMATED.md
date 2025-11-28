# 🚀 Razorpay Test Keys - Automated Setup Guide

This guide shows you how to automatically configure Razorpay test API keys using our setup script.

---

## ✨ Why Automated Setup?

**Benefits:**
- ✅ **Fast & Easy**: One command to set everything up
- ✅ **Repeatable**: Can be run multiple times safely
- ✅ **Verifiable**: Automatically checks and verifies configuration
- ✅ **Version Controlled**: Script is tracked in git
- ✅ **No Manual Steps**: No need to use Firebase Console

---

## 📋 Prerequisites

1. ✅ Razorpay test keys file exists: `.secrets/api-keys/razorpay-test.json`
2. ✅ Firebase service account: `.secrets/web/firebase_service_account.json`
3. ✅ Node.js installed (v20 or higher)
4. ✅ Your Owner User ID (found in Firebase Auth or app logs)

---

## 🚀 Quick Setup (Recommended)

### Step 1: Get Your Owner User ID

You can find your Owner User ID in several ways:

**Option A: From Firebase Console**
1. Go to: https://console.firebase.google.com/
2. Select project: `atitia-87925`
3. Go to **Authentication** → **Users**
4. Find your owner account
5. Copy the **User UID**

**Option B: From App Logs**
- When you login as owner, check console logs
- Look for: `ownerId: <your-user-id>`

**Option C: From Firestore**
- If you already have data in Firestore
- Check any collection with `ownerId` field

### Step 2: Run the Setup Script

**Using Shell Script (Recommended):**
```bash
./scripts/setup/setup-razorpay-test-keys.sh <your-owner-id>
```

**Using Node.js Directly:**
```bash
node scripts/setup/setup-razorpay-test-keys.js <your-owner-id>
```

**Example:**
```bash
./scripts/setup/setup-razorpay-test-keys.sh blg5v21mbvb6U70xUpzrfKVjYh13
```

---

## 📝 Detailed Usage

### Basic Usage

```bash
# Setup Razorpay test keys for an owner
./scripts/setup/setup-razorpay-test-keys.sh <owner-id>
```

### Force Overwrite

If Razorpay keys already exist and you want to overwrite them:

```bash
./scripts/setup/setup-razorpay-test-keys.sh <owner-id> --force
```

---

## 🔍 What the Script Does

1. ✅ **Checks Prerequisites**
   - Verifies Razorpay test keys file exists
   - Verifies Firebase service account exists
   - Checks Node.js installation

2. ✅ **Validates Configuration**
   - Reads test API key from `.secrets/api-keys/razorpay-test.json`
   - Initializes Firebase Admin SDK

3. ✅ **Checks Existing Data**
   - Looks for existing `owner_payment_details` document
   - Warns if keys already exist (unless `--force` is used)

4. ✅ **Creates/Updates Document**
   - Creates new document if it doesn't exist
   - Updates existing document if it exists
   - Sets:
     - `razorpayKey`: Test API key
     - `razorpayEnabled`: `true`
     - `isActive`: `true`
     - `lastUpdated`: Current timestamp

5. ✅ **Verifies Setup**
   - Re-reads document from Firestore
   - Confirms all fields are set correctly

---

## 📊 Example Output

**Successful Setup:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔧 Razorpay Test Keys Setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Created new payment details document
   Owner ID: blg5v21mbvb6U70xUpzrfKVjYh13
   Razorpay Key: rzp_test_RlAOuGGXSx...
   Enabled: true

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Verification Complete
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Configuration:
   Collection: owner_payment_details
   Document ID: blg5v21mbvb6U70xUpzrfKVjYh13
   Razorpay Key: rzp_test_RlAOuGGXSxvL66
   Razorpay Enabled: true
   Active: true

🎉 Razorpay test keys successfully configured!

📝 Next Steps:
   1. Test payment flow in your app
   2. Use Razorpay test cards (no real money)
   3. Check payments in Razorpay Dashboard (Test Mode)
```

**Warning (Keys Already Exist):**
```
⚠️  Warning: Razorpay key already exists for this owner
   Existing key: rzp_test_RlAOuGGXSx...
   Enabled: true

💡 Use --force flag to overwrite existing configuration
```

---

## 🔧 Troubleshooting

### Error: "Razorpay test keys file not found"

**Solution:**
```bash
# Ensure the file exists
ls -la .secrets/api-keys/razorpay-test.json

# Expected structure:
# {
#   "test": {
#     "apiKey": "rzp_test_...",
#     "keySecret": "..."
#   }
# }
```

### Error: "Firebase service account file not found"

**Solution:**
- Ensure `.secrets/web/firebase_service_account.json` exists
- This file should contain your Firebase Admin SDK service account JSON

### Error: "Owner ID is required"

**Solution:**
- Provide your Owner User ID as the first argument:
  ```bash
  ./scripts/setup/setup-razorpay-test-keys.sh <your-owner-id>
  ```

### Error: "permission-denied"

**Solution:**
- Ensure your Firebase service account has Firestore write permissions
- Check IAM roles in Google Cloud Console
- Service account should have: `Cloud Datastore User` or `Firebase Admin` role

### Error: "Node.js is not installed"

**Solution:**
```bash
# Install Node.js (v20 or higher)
# macOS:
brew install node

# Or download from: https://nodejs.org/
```

---

## 🔐 Security Notes

1. ✅ **API Key is Safe for Client-Side**
   - The test API key (`rzp_test_...`) can be stored in Firestore
   - It's designed to be used in client-side code

2. ❌ **Secret Key Must Stay Private**
   - Never add the secret key to Firestore
   - Keep it in `.secrets/api-keys/razorpay-test.json` (already in `.gitignore`)
   - Only use secret key server-side (Cloud Functions) for refunds

3. 🔒 **Test vs Live Keys**
   - Test keys: Safe for development, no real money
   - Live keys: Only use after KYC approval, handle with extra care

---

## 🧪 Testing After Setup

1. **Verify in Firebase Console**
   - Go to Firestore Database
   - Check `owner_payment_details` collection
   - Find your document by Owner ID
   - Verify `razorpayKey` and `razorpayEnabled` fields

2. **Test in App**
   - Login as owner
   - Create or select a PG listing
   - Login as guest (different account)
   - Make a booking
   - Go to payment screen
   - Select "Razorpay" payment method
   - Click "Pay via Razorpay"
   - Use test card: `4111 1111 1111 1111`

3. **Check Razorpay Dashboard**
   - Go to: https://dashboard.razorpay.com/app/payments
   - Switch to **Test Mode**
   - You should see test payment records

---

## 📚 Additional Resources

- **Manual Setup Guide**: `docs/razorpay/RAZORPAY_TEST_SETUP_GUIDE.md`
- **Razorpay Test Cards**: https://razorpay.com/docs/payments/test-cards/
- **Razorpay Dashboard**: https://dashboard.razorpay.com
- **Script Location**: `scripts/setup/setup-razorpay-test-keys.js`

---

## 🎯 Next Steps

After successful setup:

1. ✅ **Test Payment Flow** - Make a test payment in your app
2. ✅ **Verify in Dashboard** - Check Razorpay Dashboard for test payments
3. ✅ **Complete KYC** - Submit KYC documents to Razorpay
4. ✅ **Get Live Keys** - After KYC approval, get live API keys
5. ✅ **Update to Live Keys** - Replace test keys with live keys (same script, different keys file)

---

**Questions?** Check the troubleshooting section or review the script code in `scripts/setup/setup-razorpay-test-keys.js`

