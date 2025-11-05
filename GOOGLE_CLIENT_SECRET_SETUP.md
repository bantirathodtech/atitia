# 🔐 Google Sign-In Client Secret Setup Guide

## Current Status
Your Google Cloud Console shows the OAuth 2.0 Client IDs, but the **Client Secret** may not be visible or may need to be generated.

## Step-by-Step Instructions

### Option 1: If Client Secret is Already Set (Hidden)

1. **Navigate to OAuth Client:**
   - Go to: https://console.cloud.google.com/apis/credentials
   - Find: **"Web client (auto created by Google Service)"**
   - Client ID: `665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj`

2. **Click on the Web client** to open its details

3. **Check for Client Secret:**
   - Look for a field labeled **"Client secret"**
   - If it shows "Not set" → Go to Option 2
   - If it shows a value but is hidden → Click "Show" or "Reveal" button
   - Copy the secret (starts with `GOCSPX-`)

### Option 2: If Client Secret Shows "Not set" or is Missing

1. **Generate a New Client Secret:**
   - Click on the **"Web client"** entry
   - Look for **"ADD SECRET"** or **"RESET SECRET"** button
   - Click it to generate a new secret

2. **Copy the Secret Immediately:**
   - ⚠️ **IMPORTANT:** Google only shows the secret **once**
   - Copy the entire secret value (starts with `GOCSPX-`)
   - Save it securely (password manager recommended)

3. **Update the Code:**
   - Open: `lib/common/constants/environment_config.dart`
   - Find line: `static const String googleSignInClientSecret =`
   - Replace: `'GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET'`
   - With: `'GOCSPX-<your-actual-secret-here>'`

### Option 3: Alternative - Create a Separate Desktop OAuth Client

If you prefer to keep the web client secret-free (for security), you can create a separate OAuth client specifically for desktop platforms:

1. **Create New OAuth Client:**
   - In Google Cloud Console → APIs & Services → Credentials
   - Click **"+ CREATE CREDENTIALS"** → **"OAuth client ID"**
   - Application type: **"Desktop app"**
   - Name: `Atitia Desktop Client`

2. **Copy the Credentials:**
   - Copy the **Client ID** and **Client Secret**
   - Use these for desktop platforms only

3. **Update Code (if using separate client):**
   - Add new constants for desktop client ID and secret
   - Update `firebase_service_initializer.dart` to use desktop credentials

## Verification

After updating the secret:

1. **Test on Desktop Platform:**
   ```bash
   flutter run -d macos
   # or
   flutter run -d windows
   # or
   flutter run -d linux
   ```

2. **Try Google Sign-In:**
   - The sign-in should work without errors
   - If you see "invalid_client" errors, the secret is incorrect

## Security Notes

- ✅ **Client Secret is safe to include in code** for desktop apps (it's bundled with the app)
- ⚠️ **Never commit secrets to public repositories** (use environment variables for CI/CD)
- 🔒 **Keep secrets in version control private** if your repo is private
- 📝 **Document where secrets are stored** for team members

## Current Configuration

- **Project:** atitia-87925
- **Web Client ID:** 665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com
- **Location:** `lib/common/constants/environment_config.dart:147`

## Need Help?

If you're still having issues:
1. Check Google Cloud Console → APIs & Services → OAuth consent screen (must be configured)
2. Verify the OAuth client is enabled
3. Ensure the project has Google Sign-In API enabled

