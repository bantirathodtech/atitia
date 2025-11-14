# 🚀 Atitia CI/CD & Deployment Documentation

**Project:** Atitia  
**Last Updated:** 2024  
**Status:** ✅ Permanent Setup - Do Not Modify Without Approval

---

## 📋 Overview

This folder contains **permanent CI/CD and deployment documentation** for the Atitia project. This setup is designed to be maintained for many years and should not be modified without careful consideration and team approval.

**⚠️ Important:** This documentation reflects the production-ready CI/CD pipeline that will be used for all iOS and Android app store updates.

---

## 📚 Documentation Index

### Core Documentation

1. **[Branch Strategy](./BRANCH_STRATEGY.md)** - Complete branch roles, workflows, and best practices
2. **[Main Branch Protection](./MAIN_BRANCH_PROTECTION.md)** - GitHub protection rules and hotfix procedures
3. **[CI/CD Pipeline Rating](./CI_CD_RATING.md)** - Current pipeline rating and metrics
4. **[Secrets Template](./SECRETS_TEMPLATE.md)** - Required GitHub secrets for CI/CD
5. **[Troubleshooting Guide](./TROUBLESHOOTING.md)** - Common issues and solutions

### Technical Documentation

6. **[Improvements Summary](./IMPROVEMENTS_SUMMARY.md)** - Historical improvements made to CI/CD
7. **[iOS Build Optimization](./IOS_BUILD_OPTIMIZATION.md)** - iOS-specific optimizations
8. **[CI/CD Scripts Compatibility](./CI_CD_SCRIPTS_COMPATIBILITY.md)** - Script compatibility notes

---

## 🔄 CI/CD Workflow Overview

### Branch Strategy

```
dev (Development)
  ↓ [Direct Merge]
staging (Testing)
  ↓ [PR + Approval]
main (Production)
  ↓ [Tag Release]
App Stores (iOS + Android)
```

### Workflow Files

| File | Purpose | Triggers |
|------|---------|----------|
| `.github/workflows/ci.yml` | Full CI/CD pipeline | `staging` branch |
| `.github/workflows/deploy.yml` | Production deployment | Tags (`v*.*.*`) on `main` |
| `.github/workflows/firebase-deploy.yml` | Firebase staging deployment | `staging` branch |

---

## 🎯 Deployment Strategy

### Staging Branch (`staging`)
- ✅ **Full CI/CD Pipeline** - Tests, builds, security checks
- ✅ **Firebase Deployment** - Testing environment only
- ❌ **NO App Store Deployment** - Staging is for testing only

### Main Branch (`main`)
- ✅ **Production Deployment** - Deploys to App Store & Play Store
- ✅ **Tagged Releases** - Semantic versioning (v1.0.0)
- ✅ **Protected Branch** - Requires approval and CI/CD checks

### Deployment Flow

```
1. Code on dev branch (development)
   ↓
2. Merge to staging (automatic CI/CD runs)
   ↓
3. Test on staging Firebase environment
   ↓
4. Create PR: staging → main
   ↓
5. Get approval + CI/CD passes
   ↓
6. Merge to main
   ↓
7. Tag release: git tag v1.0.0
   ↓
8. Push tag: git push origin main --tags
   ↓
9. Production deployment triggered automatically
   ↓
10. Deploys to:
    - Apple App Store
    - Google Play Store
    - Firebase Hosting (production)
```

---

## ✅ CI/CD Configuration Verification

### Current Setup Status

| Requirement | Status | Details |
|-------------|--------|---------|
| **dev branch** | ✅ Free | No CI/CD, all commits allowed |
| **staging branch** | ✅ Full CI/CD | Tests, builds, security checks |
| **main branch** | ✅ Production | Deploys to App Store & Play Store |
| **Firebase staging** | ✅ Configured | Deploys on staging branch |
| **Firebase production** | ✅ Configured | Deploys on main tags |
| **iOS deployment** | ✅ Configured | Deploys to App Store |
| **Android deployment** | ✅ Configured | Deploys to Play Store |

### Confirmation: ✅ Setup Matches Requirements

**Question:** "main branch code we should publish on app store and play store on staging?"

**Answer:** ❌ **NO** - Here's the correct flow:

- **staging branch** → Firebase deployment only (for testing)
- **main branch** → App Store & Play Store deployment (production)

**Current Configuration:**
- ✅ `deploy.yml` triggers on tags (`v*.*.*`) on `main` branch
- ✅ `deploy.yml` deploys to App Store & Play Store
- ✅ `firebase-deploy.yml` deploys to Firebase on `staging` branch only

**This is correct!** ✅

---

## 🔒 Permanent Setup Guidelines

### Do's ✅
- ✅ Follow the documented branch strategy
- ✅ Use semantic versioning for releases
- ✅ Test thoroughly on staging before production
- ✅ Tag releases on main branch
- ✅ Review documentation before making changes

### Don'ts ❌
- ❌ Don't modify CI/CD workflows without approval
- ❌ Don't deploy to stores from staging branch
- ❌ Don't skip CI/CD checks
- ❌ Don't modify this documentation without team approval
- ❌ Don't bypass protection rules

---

## 📝 Quick Reference

### Common Commands

```bash
# Development workflow
git checkout dev
git commit -m "feat: New feature"
git push origin dev

# Merge to staging
git checkout staging
git merge dev
git push origin staging

# Create release
git checkout main
git merge staging
git tag v1.0.0
git push origin main --tags
```

### Workflow Triggers

- **Push to `staging`** → CI/CD pipeline runs
- **Push to `staging`** → Firebase deployment (staging)
- **Tag on `main`** → Production deployment (App Store + Play Store)

---

## 🆘 Support

If you need to modify this setup:

1. Review all documentation in this folder
2. Understand the impact of changes
3. Get team approval
4. Test changes on staging first
5. Update documentation accordingly

---

## 📅 Maintenance Schedule

- **Monthly:** Review CI/CD performance metrics
- **Quarterly:** Review and update documentation
- **Annually:** Review and optimize workflows

---

**This documentation is permanent and should be maintained for the lifetime of the Atitia project.**

