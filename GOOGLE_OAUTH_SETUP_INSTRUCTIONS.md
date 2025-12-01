# 🔐 Google OAuth Setup - Quick Instructions

**Current Status from Google Cloud Console:**
- ✅ **Web Client:** `665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com` (Already have)
- ⚠️ **iOS Client:** `665010238088-b381...` (Need full ID)
- ❌ **Android Client:** Not visible (May need to create)

---

## 📋 STEP 1: Get iOS Client ID

1. **Click on** "iOS client for com.avishio.atitia" in Google Cloud Console
2. **Copy the full Client ID** (it will show the complete ID, not truncated)
3. **Format:** Should be like `665010238088-b381xxxxxxxxxxxxxxxx.apps.googleusercontent.com`

**Once you have it, provide it to me and I'll update the code.**

---

## 📋 STEP 2: Check/Create Android Client ID

### Option A: Check if Android Client Exists
1. Scroll down in the OAuth 2.0 Client IDs list
2. Look for "Android client" or similar
3. If found, click it and copy the Client ID

### Option B: Create Android Client (if missing)
1. Click **"+ CREATE CREDENTIALS"** → **"OAuth client ID"**
2. **Application type:** Select **"Android"**
3. **Name:** `Android client for com.avishio.atitia`
4. **Package name:** `com.avishio.atitia`
5. **SHA-1 certificate fingerprint:** `c35426383935af00f2f54b0bb7fc7cb6e8150f15`
6. Click **"CREATE"**
7. **Copy the Client ID** (starts with `665010238088-`)

**Once you have it, provide it to me and I'll update the code.**

---

## 📋 STEP 3: Update Code (I'll do this)

Once you provide:
- ✅ Full iOS Client ID
- ✅ Android Client ID (if created)

I will:
1. Add them to `.secrets/google-oauth/` for backup
2. Update `EnvironmentConfig` with the actual values
3. Verify everything is configured correctly

---

## 🎯 QUICK CHECKLIST

- [ ] Get full iOS Client ID from Google Cloud Console
- [ ] Check if Android Client exists (or create one)
- [ ] Provide both Client IDs to update the code
- [ ] Test authentication after update

---

**Current Status:**
- Web Client ID: ✅ Ready
- Client Secret: ✅ Ready  
- iOS Client ID: ⏳ Waiting for full ID
- Android Client ID: ⏳ Need to check/create

