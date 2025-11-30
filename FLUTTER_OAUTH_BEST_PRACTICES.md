# 🔐 Flutter OAuth Credentials - Best Practices

## ✅ What's Safe to Commit

### OAuth Client IDs (PUBLIC - Safe to Commit)
- ✅ **Web Client ID** - Public by design
- ✅ **Android Client ID** - Public by design  
- ✅ **iOS Client ID** - Public by design

**Why:** OAuth Client IDs are meant to be public. They're embedded in client apps and visible to users. GitHub may flag them, but they're safe to allow.

---

## ⚠️ What Should NOT Be Committed

### OAuth Client Secret (SENSITIVE - Use Environment Variable)
- ❌ **Client Secret** - Should use environment variable

**Why:** Client Secret is sensitive and should be:
1. Set via environment variable: `GOOGLE_SIGN_IN_CLIENT_SECRET`
2. Or loaded from secure storage at runtime
3. **NOT** hardcoded in production code

**Note:** Client Secret is only needed for desktop platforms (macOS, Windows, Linux). Mobile/web apps don't need it.

---

## 🎯 Current Implementation

### ✅ Client IDs (Hardcoded - Safe)
```dart
// Safe to commit - these are public
static const String googleSignInWebClientId = '665010238088-md8l...';
static const String googleSignInAndroidClientId = '665010238088-27a0...';
static const String googleSignInIosClientId = '665010238088-b381...';
```

### ✅ Client Secret (Environment Variable - Secure)
```dart
// Uses environment variable - empty default
static const String googleSignInClientSecret = String.fromEnvironment(
  'GOOGLE_SIGN_IN_CLIENT_SECRET',
  defaultValue: '', // Empty - use env var
);
```

---

## 🚀 How to Use

### For Mobile/Web (Android, iOS, Web):
```bash
# Client IDs are in code (safe)
# Client Secret not needed (returns null)
flutter run
```

### For Desktop (macOS, Windows, Linux):
```bash
# Set Client Secret via environment variable
export GOOGLE_SIGN_IN_CLIENT_SECRET="GOCSPX-your-secret-here"
flutter run
```

---

## 🔒 GitHub Secret Scanning

### When GitHub Flags Client IDs:
1. **Click "Allow"** - Client IDs are public and safe
2. Or use the unblock URL provided by GitHub
3. These are false positives - Client IDs are meant to be public

### When GitHub Flags Client Secret:
1. **Don't commit it** - Use environment variable instead
2. Current code uses empty default - safe ✅
3. Set via `GOOGLE_SIGN_IN_CLIENT_SECRET` environment variable

---

## ✅ Summary

| Credential | Type | Safe to Commit? | Current Status |
|------------|------|-----------------|----------------|
| Web Client ID | Public | ✅ Yes | Hardcoded (safe) |
| Android Client ID | Public | ✅ Yes | Hardcoded (safe) |
| iOS Client ID | Public | ✅ Yes | Hardcoded (safe) |
| Client Secret | Sensitive | ❌ No | Environment variable (secure) |

---

**Status:** ✅ Following Flutter best practices!

