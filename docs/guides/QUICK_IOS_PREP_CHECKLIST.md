# ✅ Quick iOS Files Preparation Checklist

**Follow in order - Check off as you complete each step**

---

## 🔐 Certificate (.p12)

- [ ] Opened Keychain Access
- [ ] Selected "Login" keychain
- [ ] Found certificate (Apple Distribution or iPhone Distribution)
  - If NOT found: Use Xcode to create (see guide)
- [ ] Exported certificate as `.p12` format
- [ ] Saved to Desktop: `atitia-distribution.p12`
- [ ] Set password (remember it!)
- [ ] **File path noted:**

---

## 📦 Provisioning Profile (.mobileprovision)

- [ ] Opened Xcode → Preferences → Accounts
- [ ] Selected Apple ID
- [ ] Clicked "Download Manual Profiles"
- [ ] Waited for download to complete
- [ ] **File path found:**
  ```bash
  ls ~/Library/MobileDevice/Provisioning\ Profiles/ | grep -i atitia
  ```
- [ ] **OR** Downloaded from Apple Developer Portal
- [ ] **File path noted:**

---

## 🔑 App Store Connect API Key (.p8)

- [ ] Went to: https://appstoreconnect.apple.com
- [ ] Navigated: Users and Access → Keys → App Store Connect API
- [ ] **Copied Issuer ID:** (UUID format)
  - [ ] Value: ___________________
- [ ] Clicked "+" to generate new key
- [ ] Named: "Atitia CI/CD"
- [ ] Selected: App Manager role
- [ ] **Copied Key ID:** (e.g., ABC123DEF4)
  - [ ] Value: ___________________
- [ ] Downloaded `.p8` file
- [ ] Saved to Desktop: `AuthKey_[KEY_ID].p8`
- [ ] **File path noted:**

---

## 📝 Info to Remember

- [ ] **Certificate Password:** ___________________
- [ ] **Key ID:** ___________________
- [ ] **Issuer ID:** ___________________

---

## ✅ Ready to Run Script?

Once all files are prepared and paths noted:

```bash
./scripts/setup-ios-secrets.sh
```

**Enter paths when prompted:**
1. Certificate (.p12) path
2. Certificate password
3. Provisioning profile (.mobileprovision) path
4. API key (.p8) path

---

**Status**: ⏸️ **Preparing files...**

