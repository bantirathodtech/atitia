# 🚀 Quick Google Play Store Setup (TL;DR Version)

## ⏱️ Total Time: 30-45 minutes

---

## Step-by-Step Checklist

### Step 1: Create Account (10 min)
- [ ] Go to: https://play.google.com/console
- [ ] Sign in with Google account
- [ ] Click "Create account"
- [ ] Pay $25 registration fee
- [ ] Complete account details

### Step 2: Create App (5 min)
- [ ] Click "Create app"
- [ ] App name: `Atitia`
- [ ] Language: English
- [ ] Type: App
- [ ] Free/Paid: Your choice
- [ ] Click "Create app"

### Step 3: Fill Listing (15 min)
- [ ] Go to: Store presence → Main store listing
- [ ] Enter app name: `Atitia`
- [ ] Enter short description (80 chars)
- [ ] Enter full description (can be simple)
- [ ] Upload app icon (512x512)
- [ ] Upload feature graphic (1024x500)
- [ ] Upload 2+ screenshots
- [ ] Complete content rating questionnaire

### Step 4: Create Service Account (15 min)
- [ ] Go to: Setup → API access
- [ ] Click "Create new service account"
- [ ] Click "Google Cloud Console" link
- [ ] Create service account: `atitia-play-uploader`
- [ ] Create JSON key → Download file
- [ ] Go back to Play Console
- [ ] Grant access to service account
- [ ] Select permissions: View app, Manage releases

### Step 5: Add to GitHub (2 min)
- [ ] Open downloaded JSON file
- [ ] Copy entire content
- [ ] Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
- [ ] New secret: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
- [ ] Paste JSON content
- [ ] Save

### Step 6: Publish! (1 min)
```bash
git tag v1.0.0
git push origin v1.0.0
```

**Done!** Your app will be built and uploaded automatically.

---

## 📋 Quick Links

- **Play Console:** https://play.google.com/console
- **Create Account:** https://play.google.com/console/signup
- **GitHub Secrets:** https://github.com/bantirathodtech/atitia/settings/secrets/actions

---

## 💰 Cost

- **One-time:** $25 USD (Google Play Developer registration)
- **No monthly fees**

---

## ⏱️ Timeline

- **Setup:** 30-45 minutes
- **First Review:** 1-7 days
- **App Live:** After review approval

---

**Ready? Start with Step 1!** 🚀

