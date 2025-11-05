# 🔐 Create New Google Client Secret - Step by Step

## Current Situation
- You have an **Enabled** secret (ends with "B602") from October 20, 2025
- Google no longer allows viewing/downloading existing secrets
- You need to either:
  - Find the saved secret from Oct 20, 2025
  - OR create a new secret

## Option 1: Find Your Saved Secret (Recommended)

If you saved it on October 20, 2025, look for:
- Starts with: `GOCSPX-`
- Ends with: `B602`
- Check your:
  - Password manager
  - Notes/documentation
  - Secure storage
  - Local files

## Option 2: Create a New Secret

### Step-by-Step Instructions:

**From the page you're currently on:**

1. **Scroll down to "Client secrets" section**
   - You should see two secrets listed
   - One is **Enabled** (ends with "B602")

2. **Click the "ADD SECRET" or "RESET SECRET" button**
   - This will be near the "Client secrets" section
   - OR click the three dots (⋮) menu next to the enabled secret
   - Select "Reset secret" or "Add new secret"

3. **A popup/dialog will appear**
   - Google will generate a NEW secret
   - ⚠️ **CRITICAL:** Copy it immediately!
   - The secret will start with `GOCSPX-`
   - Format: `GOCSPX-<long-string-of-characters>`

4. **Copy the entire secret**
   - Select all text
   - Copy to clipboard
   - Save it in a password manager immediately

5. **Click "OK" or "Done"**
   - The secret will be saved
   - The old secret (ending with "B602") may be automatically disabled

6. **Update your code:**
   - Open: `lib/common/constants/environment_config.dart`
   - Go to line 147
   - Replace the placeholder with your new secret

---

## Visual Guide (What You Should See)

```
Client secrets
├─ Client secret
│  ├─ Status: Disabled
│  └─ Ends with: ****obyR
│
├─ Client secret  
│  ├─ Status: Enabled
│  └─ Ends with: ****B602
│
└─ [ADD SECRET] button ← Click this
```

After clicking "ADD SECRET":
```
┌─────────────────────────────────────┐
│ New Client Secret Created           │
│                                     │
│ GOCSPX-abcdefghijklmnopqrstuvwxyz   │
│                                     │
│ ⚠️ Copy this secret now!            │
│    It won't be shown again.         │
│                                     │
│ [COPY] [OK]                         │
└─────────────────────────────────────┘
```

---

## After Getting the Secret

### Update Code:

**File:** `lib/common/constants/environment_config.dart`  
**Line:** 147

```dart
// BEFORE:
static const String googleSignInClientSecret =
    'GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET';

// AFTER:
static const String googleSignInClientSecret =
    'GOCSPX-<paste-your-new-secret-here>';
```

### Save and Test:

1. Save the file
2. Run the app:
   ```bash
   flutter run -d macos
   # or
   flutter run -d windows
   ```
3. Test Google Sign-In - it should work!

---

## Important Notes

- ⚠️ **Google only shows the secret ONCE** when created
- ✅ **Copy it immediately** - you won't see it again
- 🔒 **Save it securely** - use a password manager
- 📝 **The old secret (ending with "B602") will be disabled** after creating a new one
- 🚀 **Your app will need the new secret** to work properly

---

## If You Can't Find the Old Secret

If you can't find the secret from October 20, 2025:
1. Create a new secret (steps above)
2. Update the code immediately
3. Test the app to ensure it works
4. The old secret will be automatically disabled

---

**Last Updated:** 2025-01-27  
**Project:** atitia-87925  
**Client ID:** 665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj

