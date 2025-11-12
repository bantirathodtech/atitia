# 🔐 Add GitHub Secrets - Manual Instructions

**Repository:** `bantirathodtech/atitia`  
**URL:** https://github.com/bantirathodtech/atitia/settings/secrets/actions

---

## 📋 **Quick Steps**

1. **Go to GitHub Secrets page:**
   - Open: https://github.com/bantirathodtech/atitia/settings/secrets/actions
   - Click **"New repository secret"** (4 times, once for each secret)

2. **Add each secret:**

### Secret 1: ANDROID_KEYSTORE_BASE64
- **Name:** `ANDROID_KEYSTORE_BASE64`
- **Value:** See `STEP2_COMPLETE_INSTRUCTIONS.md` (the long base64 string starting with `MIIK1AIBAzCCC...`)

### Secret 2: ANDROID_KEYSTORE_PASSWORD
- **Name:** `ANDROID_KEYSTORE_PASSWORD`
- **Value:** Your keystore password (the one you entered when creating the keystore)

### Secret 3: ANDROID_KEY_ALIAS
- **Name:** `ANDROID_KEY_ALIAS`
- **Value:** `atitia-release`

### Secret 4: ANDROID_KEY_PASSWORD
- **Name:** `ANDROID_KEY_PASSWORD`
- **Value:** Your keystore password (same as Secret 2)

---

## ✅ **After Adding All 4 Secrets**

Once all secrets are added, you should see:
- ✅ ANDROID_KEYSTORE_BASE64
- ✅ ANDROID_KEYSTORE_PASSWORD
- ✅ ANDROID_KEY_ALIAS
- ✅ ANDROID_KEY_PASSWORD

---

## 🎯 **Next Steps**

After secrets are added, we'll:
1. Verify the secrets are set
2. Test CI/CD pipeline
3. Set up iOS signing (Step 3)
4. Prepare for deployment

---

**The base64 keystore string is in:** `STEP2_COMPLETE_INSTRUCTIONS.md`

