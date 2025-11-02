# 🔐 Step 1: Create Android Keystore

**Follow these steps in your terminal to create the production signing keystore.**

---

## **Run This Command**

Copy and paste this into your terminal:

```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia && keytool -genkey -v -keystore android/keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias atitia-release
```

---

## **What You'll Be Prompted For:**

1. **Keystore password**: 
   - Enter a strong password (at least 6 characters)
   - ⚠️ **SAVE THIS PASSWORD SECURELY!** You'll need it for all future updates
   - Recommended: Use a password manager

2. **Re-enter password**: Enter the same password again

3. **What is your first and last name?**
   - Enter: Your name or company name (e.g., "Atitia Team")

4. **What is the name of your organizational unit?**
   - Enter: Development (or press Enter for default)

5. **What is the name of your organization?**
   - Enter: Atitia (or press Enter for default)

6. **What is the name of your City or Locality?**
   - Enter: Your city name

7. **What is the name of your State or Province?**
   - Enter: Your state name

8. **What is the two-letter country code for this unit?**
   - Enter: IN (for India) or your country code (2 letters)

9. **Is CN=..., OU=..., O=..., L=..., ST=..., C=... correct?**
   - Enter: **yes**

10. **Enter key password for <atitia-release>**
    - Press **Enter** to use the same password as keystore
    - Or enter a different password (also save this securely!)

---

## **After Keystore is Created**

The script will create `android/keystore.jks`. Now create the properties file:

```bash
# Replace YOUR_PASSWORD with your actual keystore password
cat > android/key.properties << EOF
storeFile=keystore.jks
storePassword=YOUR_PASSWORD_HERE
keyAlias=atitia-release
keyPassword=YOUR_PASSWORD_HERE
EOF
```

**Or manually create the file:**

```bash
nano android/key.properties
```

Paste this and replace `YOUR_PASSWORD_HERE`:
```properties
storeFile=keystore.jks
storePassword=YOUR_PASSWORD_HERE
keyAlias=atitia-release
keyPassword=YOUR_PASSWORD_HERE
```

---

## **Verify It Worked**

```bash
# Check files exist
ls -la android/keystore.jks android/key.properties

# Test build
flutter build appbundle --release
```

If the build succeeds, **Step 1 is complete!** ✅

---

## **⚠️ IMPORTANT SECURITY NOTES**

- ✅ Never share your keystore password
- ✅ Backup `android/keystore.jks` to a secure location
- ✅ Store passwords in a password manager
- ✅ These files are already in `.gitignore` (won't be committed)

---

## **Next: Step 2**

Once Step 1 is complete, I can help you with:
- Generating base64 for GitHub Secrets
- Setting up the remaining steps

**Let me know when you've completed the keystore creation!**

