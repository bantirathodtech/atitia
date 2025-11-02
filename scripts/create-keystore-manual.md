# 🔐 Manual Android Keystore Creation Guide

Since the interactive script requires secure password input, follow these steps manually:

## **Step 1: Open Terminal**

Navigate to your project directory:
```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia
```

## **Step 2: Generate Keystore**

Run this command (you'll be prompted for passwords):

```bash
keytool -genkey -v \
  -keystore android/keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias atitia-release
```

**When prompted, enter:**
- **Keystore password**: Choose a strong password (at least 6 characters, save it securely!)
- **Re-enter password**: Enter the same password
- **First and last name**: Your name or company name
- **Organizational unit**: Development (or your team name)
- **Organization**: Atitia (or your company name)
- **City**: Your city
- **State**: Your state
- **Country code**: IN (or your 2-letter country code)
- **Confirm**: Type 'yes'
- **Key password**: Enter same as keystore password (or press Enter to use same)

## **Step 3: Create key.properties**

After keystore is created, create `android/key.properties`:

```bash
cat > android/key.properties << 'EOF'
storeFile=keystore.jks
storePassword=YOUR_KEYSTORE_PASSWORD_HERE
keyAlias=atitia-release
keyPassword=YOUR_KEY_PASSWORD_HERE
EOF
```

**Replace:**
- `YOUR_KEYSTORE_PASSWORD_HERE` with your actual keystore password
- `YOUR_KEY_PASSWORD_HERE` with your key password (or same as keystore password)

**Or manually edit the file:**
```bash
nano android/key.properties
```

Paste this content and fill in your passwords:
```properties
storeFile=keystore.jks
storePassword=your_password_here
keyAlias=atitia-release
keyPassword=your_password_here
```

## **Step 4: Verify**

Check that files were created:
```bash
ls -la android/keystore.jks android/key.properties
```

You should see both files.

## **Step 5: Test Build**

Verify the signing works:
```bash
flutter build appbundle --release
```

If it builds successfully, you're done! ✅

## **⚠️ SECURITY REMINDERS**

- ✅ Never commit `keystore.jks` or `key.properties` to git
- ✅ Backup `keystore.jks` to a secure location (you'll need it forever!)
- ✅ Store passwords in a password manager
- ✅ These files are already in `.gitignore`

## **Next Steps**

After completing this:
1. Generate base64 for GitHub: `bash scripts/generate-keystore-base64.sh`
2. Add GitHub secrets (see `docs/GITHUB_SECRETS_SETUP.md`)

