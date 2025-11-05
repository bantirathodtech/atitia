# 🔐 Google OAuth Client Secret JSON File - Secure Storage Guide

**Last Updated:** 2025-01-27

## 📁 File Information

**File Name:**
```
client_secret_2_665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com
```

**File Type:** Google OAuth 2.0 Client Credentials JSON  
**Downloaded:** November 5, 2025, 6:44:43 PM GMT+5  
**Client ID:** `665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com`

---

## 🚨 CRITICAL SECURITY NOTES

- ⚠️ **NEVER commit this file to Git**
- ⚠️ **NEVER share this file publicly**
- ⚠️ **Store securely** (password manager, encrypted storage)
- ⚠️ **This file contains sensitive OAuth credentials**

---

## 📂 Recommended Storage Location

### ✅ **RECOMMENDED: Project `.secrets/` Directory**

**Use the secure, hidden directory inside your project:**

```bash
# Move the JSON file to the secure project directory
mv ~/Downloads/client_secret_2_665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com \
   .secrets/google-oauth/client_secret_google_oauth.json

# Set restrictive permissions
chmod 600 .secrets/google-oauth/client_secret_google_oauth.json
```

**Why this location:**
- ✅ **Hidden from Git** - Protected by `.gitignore`
- ✅ **Hidden from listings** - Starts with `.` (use `ls -la` to see)
- ✅ **All credentials in one place** - Organized structure
- ✅ **Easy to find** - Right in your project
- ✅ **Secure permissions** - `700` for directory, `600` for files
- ✅ **Backup-friendly** - Easy to backup entire directory

**Location:** `.secrets/google-oauth/client_secret_google_oauth.json`

### Alternative: Secure Local Directory (Outside Project)

If you prefer to keep credentials outside the project:

```bash
# Create secure credentials directory
mkdir -p ~/.atitia-credentials

# Move the JSON file there
mv ~/Downloads/client_secret_2_665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com \
   ~/.atitia-credentials/client_secret_google_oauth.json

# Set restrictive permissions (Linux/macOS)
chmod 600 ~/.atitia-credentials/client_secret_google_oauth.json
```

**Why this location:**
- ✅ Outside project directory (won't be accidentally committed)
- ✅ Standard location for credentials (`~/.appname-credentials`)
- ✅ Easy to find and reference
- ✅ Can be backed up separately

**Location:** `~/.atitia-credentials/client_secret_google_oauth.json`

---

## 🔍 What's Inside the JSON File?

The JSON file typically contains:

```json
{
  "web": {
    "client_id": "665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com",
    "project_id": "atitia-87925",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_secret": "GOCSPX-...",
    "redirect_uris": ["http://localhost"]
  }
}
```

**Key Fields:**
- `client_id`: Your OAuth client identifier
- `client_secret`: The secret value (starts with `GOCSPX-`)
- `project_id`: Your Google Cloud project ID

---

## 🔄 Extracting Client Secret from JSON

If you need to update the client secret in code from the JSON file:

```bash
# Extract client secret from JSON file
cat ~/.atitia-credentials/client_secret_google_oauth.json | \
  jq -r '.web.client_secret'
```

Or manually:
1. Open the JSON file in a text editor
2. Find the `"client_secret"` field
3. Copy the value (starts with `GOCSPX-`)
4. Update `lib/common/constants/environment_config.dart:153`

---

## ✅ Verification Checklist

- [ ] File moved to secure location
- [ ] File permissions set to `600` (owner read/write only)
- [ ] File added to `.gitignore` (already done)
- [ ] File location documented
- [ ] Backup stored securely (password manager, encrypted drive)
- [ ] Team members know location (if applicable)

---

## 🔧 Using the JSON File in Code (If Needed)

If you need to load this file programmatically (for desktop builds):

```dart
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

// Load client secret from JSON file (project .secrets directory)
Future<String> loadClientSecretFromJson() async {
  final appDir = await getApplicationDocumentsDirectory();
  final projectRoot = appDir.parent.parent; // Adjust path as needed
  final file = File('${projectRoot.path}/.secrets/google-oauth/client_secret_google_oauth.json');
  final json = jsonDecode(await file.readAsString());
  return json['web']['client_secret'] as String;
}

// Alternative: Load from home directory
Future<String> loadClientSecretFromHome() async {
  final file = File('${Platform.environment['HOME']}/.atitia-credentials/client_secret_google_oauth.json');
  final json = jsonDecode(await file.readAsString());
  return json['web']['client_secret'] as String;
}
```

**Note:** For Flutter mobile apps, the client secret is already hardcoded in `environment_config.dart` and doesn't need the JSON file.

---

## 📚 Related Documentation

- `CREDENTIALS_STATUS.md` - Overall credentials status
- `QUICK_CREDENTIALS_REFERENCE.md` - Quick reference guide
- `GOOGLE_CLIENT_SECRET_SETUP.md` - Setup instructions
- `.gitignore` - Security patterns (already includes this file type)

---

## 🆘 If File is Lost or Compromised

1. **Immediately revoke the client secret** in Google Cloud Console:
   - Go to: https://console.cloud.google.com/apis/credentials?project=atitia-87925
   - Click on the OAuth client
   - Click "RESET SECRET" or "ADD SECRET"
   - Generate a new secret
   - Update `environment_config.dart` with the new value

2. **Update the JSON file** with the new credentials

3. **Review access logs** in Google Cloud Console for suspicious activity

