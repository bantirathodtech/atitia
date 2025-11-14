# 🚀 Atitia Deployment Flow - Permanent Reference

**Project:** Atitia  
**Purpose:** Production deployment flow for iOS and Android app stores  
**Status:** ✅ Permanent - Do Not Modify

---

## 🎯 Deployment Strategy Overview

### Key Principle
**Main branch publishes to App Store and Play Store. Staging is for testing only.**

---

## 📊 Branch Deployment Matrix

| Branch | CI/CD | Firebase | App Store | Play Store | Purpose |
|--------|-------|----------|-----------|------------|---------|
| **dev** | ❌ None | ❌ None | ❌ None | ❌ None | Development |
| **staging** | ✅ Full | ✅ Staging | ❌ **NO** | ❌ **NO** | Testing |
| **main** | ✅ Deploy | ✅ Production | ✅ **YES** | ✅ **YES** | Production |

---

## 🔄 Complete Deployment Flow

### Step-by-Step Process

```
┌─────────────────────────────────────────────────────────────┐
│ 1. DEVELOPMENT (dev branch)                                 │
│    - Developer commits code                                  │
│    - No CI/CD checks                                         │
│    - No deployments                                          │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓ [Direct Merge]
┌─────────────────────────────────────────────────────────────┐
│ 2. TESTING (staging branch)                                 │
│    - Full CI/CD pipeline runs automatically                 │
│      • Code quality checks                                  │
│      • All tests (unit, widget, integration)                │
│      • Platform builds (Android, iOS, Web)                  │
│      • Security audits                                      │
│    - Firebase deployment (staging environment)              │
│    - Test complete app                                      │
│    - ❌ NO App Store deployment                             │
│    - ❌ NO Play Store deployment                            │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓ [PR + Approval + CI/CD Passes]
┌─────────────────────────────────────────────────────────────┐
│ 3. PRODUCTION (main branch)                                 │
│    - Protected branch                                        │
│    - Requires approval                                      │
│    - CI/CD must pass                                         │
│    - Tag release: v1.0.0                                     │
│    - Push tag triggers deployment                            │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ↓ [Tag Push: git push origin main --tags]
┌─────────────────────────────────────────────────────────────┐
│ 4. PRODUCTION DEPLOYMENT                                    │
│    ✅ Apple App Store                                        │
│    ✅ Google Play Store                                      │
│    ✅ Firebase Hosting (production)                          │
└─────────────────────────────────────────────────────────────┘
```

---

## 📱 App Store Deployment Details

### iOS - Apple App Store

**Trigger:** Tag push on `main` branch (`v*.*.*`)

**Workflow:** `.github/workflows/deploy.yml`

**Process:**
1. Tag created on `main`: `git tag v1.0.0`
2. Tag pushed: `git push origin main --tags`
3. `deploy.yml` workflow triggers automatically
4. Builds iOS IPA with code signing
5. Uploads to App Store Connect
6. Available for TestFlight/Production

**Configuration:**
- Requires: `IOS_CERTIFICATE_BASE64` secret
- Requires: `IOS_PROVISIONING_PROFILE_BASE64` secret
- Requires: `APP_STORE_CONNECT_API_KEY_ID` secret (optional, for automated upload)

---

### Android - Google Play Store

**Trigger:** Tag push on `main` branch (`v*.*.*`)

**Workflow:** `.github/workflows/deploy.yml`

**Process:**
1. Tag created on `main`: `git tag v1.0.0`
2. Tag pushed: `git push origin main --tags`
3. `deploy.yml` workflow triggers automatically
4. Builds Android App Bundle (AAB)
5. Signs with production keystore
6. Uploads to Google Play Console

**Configuration:**
- Requires: `ANDROID_KEYSTORE_BASE64` secret
- Requires: `ANDROID_KEYSTORE_PASSWORD` secret
- Requires: `ANDROID_KEY_ALIAS` secret
- Requires: `ANDROID_KEY_PASSWORD` secret
- Requires: `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` secret (optional, for automated upload)

---

## 🌐 Firebase Deployment Details

### Staging Environment

**Trigger:** Push to `staging` branch

**Workflow:** `.github/workflows/firebase-deploy.yml`

**Process:**
1. Code merged to `staging`
2. CI/CD pipeline runs
3. Firebase deployment triggers automatically
4. Deploys to Firebase Hosting (staging project)

**Purpose:** Testing environment for staging branch

**Configuration:**
- Requires: `FIREBASE_SERVICE_ACCOUNT` secret
- Requires: `FIREBASE_PROJECT_ID` secret (staging project)

---

### Production Environment

**Trigger:** Tag push on `main` branch (`v*.*.*`)

**Workflow:** `.github/workflows/deploy.yml`

**Process:**
1. Tag created on `main`: `git tag v1.0.0`
2. Tag pushed: `git push origin main --tags`
3. `deploy.yml` workflow triggers automatically
4. Builds web for production
5. Deploys to Firebase Hosting (production project)

**Purpose:** Production web deployment

**Configuration:**
- Requires: `FIREBASE_SERVICE_ACCOUNT` secret
- Requires: `FIREBASE_PROJECT_ID` secret (production project)

---

## ✅ Verification Checklist

Before deploying to production, verify:

### Staging Checklist
- [ ] Code merged to `staging` branch
- [ ] CI/CD pipeline passed
- [ ] All tests passed
- [ ] Firebase deployment successful
- [ ] App tested on staging environment
- [ ] No critical bugs found

### Production Checklist
- [ ] Code merged to `main` branch
- [ ] PR approved (if required)
- [ ] CI/CD checks passed
- [ ] Release tag created (`v1.0.0`)
- [ ] Tag pushed to remote
- [ ] Deployment workflow triggered
- [ ] App Store deployment successful
- [ ] Play Store deployment successful
- [ ] Firebase production deployment successful

---

## 🚨 Important Notes

### ⚠️ Critical Rules

1. **NEVER deploy to App Store/Play Store from staging branch**
   - Staging is for testing only
   - Only `main` branch deploys to stores

2. **ALWAYS tag releases on main branch**
   - Use semantic versioning: `v1.0.0`
   - Tags trigger production deployment

3. **ALWAYS test on staging first**
   - Full CI/CD runs on staging
   - Test complete app before production

4. **PROTECT main branch**
   - Require approvals
   - Require CI/CD checks
   - Block direct commits

---

## 📝 Example Deployment Commands

### Standard Release

```bash
# 1. Ensure staging is tested and stable
git checkout staging
git pull origin staging

# 2. Merge staging to main
git checkout main
git pull origin main
git merge staging

# 3. Create and push tag
git tag v1.0.0
git push origin main --tags

# 4. Deployment triggers automatically
# Monitor GitHub Actions for deployment status
```

### Hotfix Release

```bash
# 1. Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-fix

# 2. Fix the issue
git commit -m "fix: Critical production bug"

# 3. Merge to staging for validation
git checkout staging
git merge hotfix/critical-fix
git push origin staging

# 4. After staging validation, merge to main
git checkout main
git merge hotfix/critical-fix

# 5. Tag and deploy
git tag v1.0.1
git push origin main --tags

# 6. Merge back to dev
git checkout dev
git merge hotfix/critical-fix
git push origin dev
```

---

## 🔍 Monitoring Deployments

### GitHub Actions

Monitor deployment status:
1. Go to: `Actions` tab in GitHub
2. Check workflow runs:
   - `🚀 Deploy to Stores - Production` (for App Store/Play Store)
   - `🚀 Firebase Deployment - Staging Only` (for Firebase staging)

### Deployment Status

- ✅ **Success:** App deployed to stores
- ⚠️ **Warning:** Deployment completed with notes
- ❌ **Failure:** Deployment failed - check logs

---

## 📞 Support

If deployment fails:

1. Check GitHub Actions logs
2. Review [Troubleshooting Guide](./TROUBLESHOOTING.md)
3. Verify all secrets are configured
4. Check [Secrets Template](./SECRETS_TEMPLATE.md)

---

**This deployment flow is permanent and should be followed for all Atitia app store updates.**

