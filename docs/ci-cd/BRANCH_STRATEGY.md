# 🌿 Branch Strategy & Workflow Guide

## 📋 Branch Roles & Responsibilities

### 1. `dev` Branch - Development Playground
**Purpose:** Active development, experimental code, all commits preserved

**Characteristics:**
- ✅ **No CI/CD checks** - Completely free, no restrictions
- ✅ **All commits preserved** - Full history maintained
- ✅ **Frequent commits** - Daily/hourly updates allowed
- ✅ **Experimental code** - Try new features, refactor freely
- ✅ **No deployments** - No automatic builds or deployments

**Workflow:**
```
Developer → dev branch (commit freely)
```

**Best Practices:**
- Commit often, even incomplete features
- Use descriptive commit messages
- No need to keep code stable
- Can force push if needed (cleanup)

---

### 2. `staging` Branch - Testing & Backup
**Purpose:** Integration testing, stable backup, pre-production validation

**Characteristics:**
- ✅ **Full CI/CD pipeline** - All tests, builds, security checks
- ✅ **Direct merges from dev** - No PR reviews required
- ✅ **Testing environment** - Full app testing before production
- ✅ **Backup of working code** - Stable point to revert to
- ✅ **Firebase deployment** - Automatic deployment for testing

**Workflow:**
```
dev → staging (direct merge, no PR)
    ↓
Full CI/CD runs automatically
    ↓
Firebase deployment (staging environment)
    ↓
Test complete app
```

**Best Practices:**
- Merge from dev when feature is complete
- Test thoroughly on staging before moving to main
- Keep staging stable enough for testing
- Use staging as backup point

**CI/CD Triggers:**
- Code quality checks (analyze, format)
- All tests (unit, widget, integration)
- Platform builds (Android, iOS, Web)
- Security audits
- Firebase deployment (staging environment)

---

### 3. `main` Branch - Production Ready
**Purpose:** Production releases, protected and stable code

**Characteristics:**
- 🔒 **Protected branch** - Requires approval/validation
- 🔒 **Only merges from staging** - Maintains clean history
- 🔒 **Production-ready code** - Fully tested and validated
- 🔒 **Tagged releases** - Semantic versioning (v1.0.0)
- 🚀 **Production deployments** - All platforms (Play Store, App Store, Firebase)

**Workflow:**
```
staging → main (after validation)
    ↓
Tag release (v1.0.0)
    ↓
Production deployment triggered automatically
    ↓
Deploy to:
  - Google Play Store
  - Apple App Store
  - Firebase Hosting (production)
```

**Best Practices:**
- Only merge tested code from staging
- Always tag releases (semantic versioning)
- Never commit directly (except critical hotfixes - see below)
- Keep main always deployable

**Protection Rules:**
- ✅ Require PR reviews (at least 1 approval)
- ✅ Require CI/CD to pass
- ✅ Require up-to-date branches
- ✅ Block force push
- ✅ Restrict who can push (admin/maintainers only)

---

## 🔥 Hotfix Workflow (Critical Production Fixes)

### Standard Hotfix Process (Recommended)

For critical production bugs that need immediate fixing:

```
1. Create hotfix branch from main
   git checkout main
   git pull origin main
   git checkout -b hotfix/critical-bug-fix

2. Fix the issue
   # Make minimal changes to fix the bug
   git commit -m "fix: Critical production bug fix"

3. Merge to staging for validation
   git checkout staging
   git merge hotfix/critical-bug-fix
   # CI/CD runs automatically
   # Test on staging environment

4. If staging passes, merge to main
   git checkout main
   git merge hotfix/critical-bug-fix
   # Or create PR: hotfix → main

5. Tag and deploy
   git tag v1.0.1
   git push origin main --tags
   # Production deployment triggered automatically

6. Merge back to dev (keep dev updated)
   git checkout dev
   git merge hotfix/critical-bug-fix
```

### Emergency Hotfix (Rare Exception)

**Only for:** Critical security vulnerabilities or data loss issues

**Process:**
1. Create hotfix branch from main
2. Fix the issue
3. **Skip staging** (emergency only)
4. Create PR: `hotfix → main`
5. Get emergency approval
6. Merge and tag immediately
7. Deploy to production
8. **Immediately merge back to staging and dev**

**Important:** This should be extremely rare (< 1% of releases)

---

## 📊 Branch Comparison

| Feature | `dev` | `staging` | `main` |
|---------|-------|-----------|--------|
| **CI/CD Checks** | ❌ None | ✅ Full Pipeline | ✅ Production Deploy |
| **Direct Commits** | ✅ Allowed | ✅ Allowed | ❌ Blocked |
| **PR Reviews** | ❌ Not Required | ❌ Not Required | ✅ Required |
| **Force Push** | ✅ Allowed | ❌ Blocked | ❌ Blocked |
| **Deployments** | ❌ None | ✅ Firebase (Staging) | ✅ All Platforms |
| **Stability** | 🔴 Unstable | 🟡 Stable | 🟢 Production Ready |
| **Purpose** | Development | Testing | Production |

---

## 🔄 Typical Development Flow

### Feature Development
```
1. Developer works on dev branch
   git checkout dev
   git commit -m "feat: New feature"
   git push origin dev

2. Feature complete → Merge to staging
   git checkout staging
   git merge dev
   git push origin staging
   # CI/CD runs automatically

3. Test on staging
   # Full app testing
   # Verify all features work

4. If stable → Merge to main
   git checkout main
   git merge staging
   git tag v1.1.0
   git push origin main --tags
   # Production deployment triggered
```

### Bug Fix Flow
```
1. Fix bug on dev branch
   git checkout dev
   git commit -m "fix: Bug description"
   git push origin dev

2. Merge to staging
   git checkout staging
   git merge dev
   git push origin staging
   # CI/CD validates fix

3. Test fix on staging
   # Verify bug is fixed
   # Ensure no regressions

4. Merge to main
   git checkout main
   git merge staging
   git tag v1.0.1
   git push origin main --tags
```

---

## 🚨 Emergency Procedures

### Critical Production Bug
1. **Don't panic** - Follow hotfix workflow
2. Create hotfix branch from main
3. Fix with minimal changes
4. Test on staging if time permits
5. Merge to main with approval
6. Tag and deploy immediately
7. Merge back to dev/staging

### Staging Broken
1. Revert last merge from dev
2. Investigate issue on dev branch
3. Fix and re-merge to staging
4. Use staging as backup point

### Main Broken (Rare)
1. Immediately revert last release
2. Create hotfix branch
3. Fix critical issue
4. Deploy emergency patch
5. Post-mortem analysis

---

## ✅ Best Practices Summary

### Do's ✅
- ✅ Commit frequently to dev
- ✅ Merge dev → staging when feature complete
- ✅ Test thoroughly on staging
- ✅ Only merge staging → main when production-ready
- ✅ Always tag releases on main
- ✅ Keep main always deployable
- ✅ Use semantic versioning (v1.0.0)
- ✅ Write descriptive commit messages

### Don'ts ❌
- ❌ Don't commit directly to main (except emergencies)
- ❌ Don't skip staging for regular features
- ❌ Don't merge broken code to staging
- ❌ Don't deploy untested code to production
- ❌ Don't force push to staging/main
- ❌ Don't skip CI/CD checks
- ❌ Don't forget to tag releases

---

## 📝 Commit Message Convention

Use conventional commits for better tracking:

```
feat: Add new feature
fix: Fix bug
docs: Update documentation
style: Code formatting
refactor: Code refactoring
test: Add tests
chore: Maintenance tasks
```

Examples:
- `feat: Add user authentication`
- `fix: Resolve payment processing bug`
- `docs: Update API documentation`
- `chore: Update dependencies`

---

## 🔗 Related Documentation

- [CI/CD Pipeline](./ci.yml) - Full CI/CD configuration
- [Deployment Guide](./deploy.yml) - Production deployment
- [Firebase Deployment](./firebase-deploy.yml) - Staging Firebase deployment
- [Secrets Template](./SECRETS_TEMPLATE.md) - Required secrets

---

**Last Updated:** 2024
**Maintained By:** Development Team

