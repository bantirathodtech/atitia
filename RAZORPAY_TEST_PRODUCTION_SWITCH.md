# 💳 Razorpay Test/Production Switch

**Simple toggle between test and production Razorpay keys.**

---

## 🔄 How to Switch

### Use Test Razorpay Keys:
```bash
export USE_TEST_RAZORPAY=true
flutter run
```

### Use Production Razorpay Keys (Default):
```bash
flutter run
# No environment variable needed - uses production by default
```

---

## 📁 Key Files

- **Production:** `.secrets/api-keys/razorpay-production.json`
- **Test:** `.secrets/api-keys/razorpay-test.json`

---

## ✅ That's It!

Just set `USE_TEST_RAZORPAY=true` to use test keys, or leave it unset for production keys.

