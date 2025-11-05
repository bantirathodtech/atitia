# 🔐 Step-by-Step: Finding Google Sign-In Client Secret

## Starting Point
**URL:** https://console.cloud.google.com/welcome?project=atitia-87925

---

## Step-by-Step Instructions

### Step 1: Sign In to Google Cloud Console
1. If you see the sign-in page, enter your Google account email
2. Click **"Next"**
3. Enter your password if prompted
4. Complete 2-factor authentication if required
5. You should land on the Google Cloud Console dashboard

### Step 2: Navigate to APIs & Services
1. **Look for the hamburger menu** (☰) in the **top-left corner** of the page
2. **Click the hamburger menu** (☰)
3. Scroll down or look for **"APIs & Services"** in the left sidebar menu
4. **Click on "APIs & Services"**
5. A submenu will appear - **Click on "Credentials"**

**Alternative Path:**
- You can also type "credentials" in the search bar at the top
- Or directly navigate to: https://console.cloud.google.com/apis/credentials?project=atitia-87925

### Step 3: Find Your OAuth 2.0 Client
1. On the Credentials page, you'll see different sections:
   - **API Keys**
   - **OAuth 2.0 Client IDs** ← This is what you need
   - **Service Accounts**
2. **Scroll down to "OAuth 2.0 Client IDs"** section
3. **Look for the entry named:** "Web client (auto created by Google Service)"
   - Client ID should start with: `665010238088-md8l...`
4. **Click on that entry** (the name or the pencil/edit icon)

### Step 4: View or Generate Client Secret
Once you click on the OAuth client, you'll see a details page with:

**Option A: If Client Secret is Already Set (Hidden)**
1. Look for the **"Client secret"** field
2. You'll see either:
   - A hidden value with an **eye icon (👁️)** or **"Show"** button
   - Click the **eye icon** or **"Show"** button to reveal it
3. **Copy the secret immediately** (starts with `GOCSPX-`)
4. **Save it securely** - Google only shows it once!

**Option B: If Client Secret Shows "Not set"**
1. Look for the **"Client secret"** field
2. If it says **"Not set"** or is empty:
   - Click the **"ADD SECRET"** or **"RESET SECRET"** button
   - A new secret will be generated
3. **Copy the secret immediately** (Google only shows it once!)
4. The secret will start with `GOCSPX-`

### Step 5: Update Your Code
1. Open: `lib/common/constants/environment_config.dart`
2. Find **line 147**:
   ```dart
   static const String googleSignInClientSecret =
       'GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET';
   ```
3. Replace `'GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET'` with your actual secret:
   ```dart
   static const String googleSignInClientSecret =
       'GOCSPX-<paste-your-actual-secret-here>';
   ```
4. **Save the file**

---

## Visual Guide (Text-Based Navigation)

```
Google Cloud Console Dashboard
│
├─ ☰ (Hamburger Menu - Top Left)
│  │
│  └─ APIs & Services
│     │
│     └─ Credentials
│        │
│        └─ OAuth 2.0 Client IDs
│           │
│           └─ "Web client (auto created by Google Service)"
│              │
│              └─ Client secret field
│                 │
│                 ├─ [Show] button → Reveal secret
│                 └─ [ADD SECRET] button → Generate new secret
```

---

## Quick Direct Links

### Direct Link to Credentials Page:
https://console.cloud.google.com/apis/credentials?project=atitia-87925

### Direct Link to OAuth Clients:
https://console.cloud.google.com/apis/credentials/consent?project=atitia-87925

---

## Important Notes

⚠️ **Security Warning:**
- The Client Secret is **only shown once** when generated/reset
- **Copy it immediately** and save it in a password manager
- If you lose it, you'll need to reset it (which invalidates the old one)

✅ **What the Secret Looks Like:**
- Format: `GOCSPX-` followed by a long string
- Example: `GOCSPX-abcdefghijklmnopqrstuvwxyz123456`
- Length: Usually 40-50 characters total

🔍 **If You Can't Find It:**
1. Make sure you're signed in with the correct Google account
2. Verify you're in the correct project: `atitia-87925`
3. Check the project selector at the top of the page
4. The Client Secret might be hidden - look for the eye icon

---

## Troubleshooting

### "I don't see OAuth 2.0 Client IDs"
- Make sure you have the correct permissions
- Try refreshing the page
- Check if you're in the right project

### "Client Secret field is missing"
- This might mean you need to enable OAuth consent screen first
- Go to: APIs & Services → OAuth consent screen
- Complete the setup, then return to Credentials

### "I clicked 'Show' but nothing happened"
- Try clicking directly on the value field
- Some browsers block auto-reveal - try a different browser
- Check if JavaScript is enabled

---

## Verification

After updating the code:

1. **Save the file**
2. **Run the app:**
   ```bash
   flutter run -d macos
   # or
   flutter run -d windows
   # or  
   flutter run -d linux
   ```
3. **Test Google Sign-In** - it should work without "invalid_client" errors

---

**Last Updated:** 2025-01-27  
**Project:** atitia-87925  
**Client ID:** 665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com

