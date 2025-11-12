# 🔐 Quick Credentials Reference

**Last Updated:** 2025-01-27

## ✅ All Credentials Configured

### Google Sign-In Client Secret
- **Location:** `lib/common/constants/environment_config.dart:153`
- **Value:** `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`
- **Status:** ✅ Configured
- **Last 4 chars:** `7HEP`
- **Created:** November 5, 2025, 6:44:43 PM GMT+5
- **Console:** https://console.cloud.google.com/apis/credentials?project=atitia-87925
- **JSON File:** `.secrets/google-oauth/client_secret_google_oauth.json` (see `GOOGLE_CLIENT_SECRET_JSON_STORAGE.md`)

### Supabase Credentials
- **Location:** `lib/core/services/supabase/supabase_config.dart`
- **URL:** `https://iteharwqzobkolybqvsl.supabase.co`
- **Anon Key:** Configured (see file for full value)
- **Status:** ✅ Configured

---

## 🔍 How to Find Credentials Quickly

### Google Client Secret
```bash
# Search in code
grep -r "googleSignInClientSecret" lib/common/constants/environment_config.dart

# Or open file directly
# File: lib/common/constants/environment_config.dart
# Line: 153
```

### Supabase Credentials
```bash
# Search in code
grep -r "supabaseUrl\|supabaseAnonKey" lib/core/services/supabase/supabase_config.dart

# Or open file directly
# File: lib/core/services/supabase/supabase_config.dart
```

---

## 📝 Quick Update Guide

### To Update Google Client Secret:
1. Go to: https://console.cloud.google.com/apis/credentials?project=atitia-87925
2. Click "Web client (auto created by Google Service)"
3. Click "ADD SECRET" or "RESET SECRET"
4. Copy new secret immediately
5. Update: `lib/common/constants/environment_config.dart:153`

### To Update Supabase Credentials:
1. Edit: `lib/core/services/supabase/supabase_config.dart`
2. Update `supabaseUrl` and `supabaseAnonKey` values
3. Save file

---

## 📚 Related Documentation

- `CREDENTIALS_STATUS.md` - Full credentials status
- `GOOGLE_CLIENT_SECRET_SETUP.md` - Setup guide
- `GOOGLE_CLIENT_SECRET_CREATE_NEW.md` - Create new secret guide

