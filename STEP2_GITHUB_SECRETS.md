# 🔐 Step 2: Generate Base64 for GitHub Secrets

**Now that your keystore is created, let's prepare it for GitHub CI/CD.**

---

## **Generate Base64 Keystore**

Run this command to generate the base64-encoded keystore:

```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia && bash scripts/generate-keystore-base64.sh
```

This will output a long base64 string. Copy the entire output (it will be one long line).

---

## **Add to GitHub Secrets**

1. Go to your GitHub repository
2. Navigate to: **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

### **Add These Secrets:**

#### **1. ANDROID_KEYSTORE_BASE64**
- **Name:** `ANDROID_KEYSTORE_BASE64`
- **Value:** Paste the base64 string from the script output
- Click **Add secret**

#### **2. ANDROID_KEYSTORE_PASSWORD**
- **Name:** `ANDROID_KEYSTORE_PASSWORD`
- **Value:** Your keystore password (the one you just created)
- Click **Add secret**

#### **3. ANDROID_KEY_ALIAS**
- **Name:** `ANDROID_KEY_ALIAS`
- **Value:** `atitia-release`
- Click **Add secret**

#### **4. ANDROID_KEY_PASSWORD**
- **Name:** `ANDROID_KEY_PASSWORD`
- **Value:** Your key password (same as keystore password if you pressed Enter)
- Click **Add secret**

---

## **Verify Secrets Added**

You should now have 4 Android secrets in GitHub:
- ✅ ANDROID_KEYSTORE_BASE64
- ✅ ANDROID_KEYSTORE_PASSWORD
- ✅ ANDROID_KEY_ALIAS
- ✅ ANDROID_KEY_PASSWORD

---

## **Next Steps**

Once secrets are added, you can:
1. **Test CI/CD:** Push a commit to trigger CI pipeline
2. **Deploy:** Create a version tag to trigger deployment

**Ready for Step 2?** Let me know when you want to generate the base64!

