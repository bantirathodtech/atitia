# 🎯 PRODUCTION READINESS AUDIT PROMPT
## Atitia Flutter App - Role-Based Guest & Owner Platform

**Purpose:** Comprehensive, reusable audit prompt for checking production readiness before App Store/Play Store deployment.

**When to use:** After significant feature updates, before merging dev → staging → main, or before release builds.

---

## 📋 TASK: Full File-by-File Audit for Production Readiness

### CONTEXT
- **Project:** Atitia Flutter App (PG Management Platform)
- **Architecture:** MVVM with feature-based organization (`lib/feature/`)
- **State Management:** Provider (`provider: ^6.1.5+1`)
- **Navigation:** GoRouter (`go_router: ^16.2.4`) with route guards
- **Authentication:** Firebase Auth (Phone OTP, Google Sign-In, Apple Sign-In)
- **Database:** Firebase Firestore + Supabase Storage
- **Local Storage:** FlutterSecureStorage + SharedPreferences
- **Dependency Injection:** GetIt (`get_it: ^8.2.0`)
- **Roles:** `'guest'` and `'owner'` (string-based)
- **CI/CD:** Codemagic (`codemagic.yaml`)
- **Environment Config:** `lib/common/constants/environment_config.dart`

### PRIMARY FOCUS
1. **Role-Based Functionality:** Verify guest and owner flows end-to-end
2. **Production Readiness:** Security, performance, error handling, accessibility
3. **Store Compliance:** Privacy policy, terms, permissions, configurations

---

## 🔍 OBJECTIVES

1. ✅ **UI/UX Flows:** Verify guest and owner dashboards, navigation, and feature completeness
2. ✅ **Authentication & Authorization:** Firebase Auth integration, role-based access control (RBAC), token security
3. ✅ **Data Management:** Firestore queries, Supabase storage, local persistence, offline handling
4. ✅ **Route Guards:** Verify `RouteGuard` prevents unauthorized access between roles
5. ✅ **Build & Configuration:** Android/iOS configs, environment variables, Firebase setup
6. ✅ **Security:** Secret scanning, secure storage, API key protection, data encryption
7. ✅ **Tests & CI:** Test coverage, CI pipeline, linting, type safety
8. ✅ **Performance:** 60fps budget, lazy loading, image optimization, memory leaks
9. ✅ **Accessibility:** Semantic labels, text scaling, contrast, keyboard navigation
10. ✅ **Internationalization:** ARB files, locale support, RTL handling

---

## 📁 PROJECT STRUCTURE REFERENCE

### Key Directories
```
lib/
├── main.dart                          # App entry point
├── common/                            # Shared utilities, widgets, constants
│   ├── constants/
│   │   └── environment_config.dart    # ⚠️ CRITICAL: All config values
│   ├── utils/
│   │   ├── constants/
│   │   │   ├── routes.dart            # Route definitions
│   │   │   ├── firestore.dart         # Firestore collection names
│   │   │   └── storage.dart           # Storage paths
│   │   └── security/                  # Security services
│   └── widgets/                       # Reusable widgets
├── core/
│   ├── navigation/
│   │   ├── app_router.dart            # GoRouter configuration
│   │   └── guards/
│   │       └── route_guard.dart       # ⚠️ RBAC implementation
│   ├── services/
│   │   ├── firebase/                  # Firebase services
│   │   ├── payment/
│   │   │   └── razorpay_service.dart  # Payment gateway
│   │   ├── security/
│   │   │   └── security_hardening_service.dart
│   │   └── deployment/
│   │       └── deployment_optimization_service.dart
│   ├── di/
│   │   ├── firebase/
│   │   │   └── di/
│   │   │       └── firebase_service_locator.dart
│   │   └── rest/
│   │       └── di/
│   │           └── rest_api_service_locator.dart
│   └── models/                        # Core data models
└── feature/
    ├── auth/                          # Authentication flow
    │   ├── logic/
    │   │   └── auth_provider.dart     # ⚠️ Auth state management
    │   ├── view/
    │   │   └── screen/
    │   │       ├── splash/
    │   │       ├── signin/
    │   │       ├── signup/
    │   │       └── role_selection/
    │   └── data/
    │       └── model/
    │           └── user_model.dart
    ├── guest_dashboard/               # Guest features
    │   ├── guest_dashboard.dart      # Main dashboard
    │   ├── pgs/                      # PG listings
    │   ├── payments/                 # Payment management
    │   ├── complaints/               # Complaint system
    │   ├── foods/                    # Food menu
    │   ├── profile/                  # Profile management
    │   ├── settings/                 # Settings
    │   ├── help/                     # Help & support
    │   └── notifications/            # Notifications
    └── owner_dashboard/               # Owner features
        ├── owner_dashboard.dart       # Main dashboard
        ├── overview/                 # Business overview
        ├── mypg/                    # PG management
        ├── guests/                   # Guest management
        ├── foods/                    # Food management
        ├── analytics/                # Analytics
        ├── reports/                  # Reports
        ├── profile/                  # Profile & payment details
        ├── settings/                 # Settings
        ├── help/                     # Help & support
        └── notifications/             # Notifications
```

---

## 🔧 INSPECTION COMMANDS

### A. Project Inspection (Run in Terminal)

```bash
# 1. Project structure
ls -la                          # Root files
ls -la lib/                     # Source structure
ls -la test/                    # Test structure

# 2. Flutter environment
flutter --version               # Flutter version
cat pubspec.yaml                # Dependencies
flutter pub outdated            # Outdated packages

# 3. Code quality
flutter analyze                 # Static analysis
flutter analyze --no-fatal-infos # Without info level
dart format --set-exit-if-changed .  # Formatting check

# 4. Tests
flutter test                    # All tests
flutter test test/unit/         # Unit tests
flutter test test/integration/  # Integration tests
flutter test --coverage         # With coverage

# 5. Build verification
flutter build apk --release --target-platform android-arm64  # Android
flutter build ios --release --no-codesign                    # iOS
flutter build web --release                                  # Web

# 6. Role-based search
grep -r "role" lib/ --include="*.dart" | grep -v "test"
grep -r "isOwner\|isGuest" lib/ --include="*.dart"
grep -r "RouteGuard" lib/ --include="*.dart"
grep -r "AppRoutes.isGuestRoute\|AppRoutes.isOwnerRoute" lib/ --include="*.dart"

# 7. Authentication search
grep -r "FirebaseAuth\|currentUser" lib/ --include="*.dart"
grep -r "signIn\|signOut\|signUp" lib/ --include="*.dart"
grep -r "AuthProvider" lib/ --include="*.dart"

# 8. Storage search
grep -r "SharedPreferences\|FlutterSecureStorage" lib/ --include="*.dart"
grep -r "Firestore\|getDocument\|setDocument" lib/ --include="*.dart"
grep -r "SupabaseStorage\|uploadFile" lib/ --include="*.dart"

# 9. Environment config search
grep -r "EnvironmentConfig" lib/ --include="*.dart"
grep -r "firebaseProjectId\|firebaseWebApiKey" lib/ --include="*.dart"
grep -r "REPLACE_WITH\|your_.*_here" lib/ --include="*.dart"

# 10. Navigation search
grep -r "GoRoute\|router.go\|router.push" lib/ --include="*.dart"
grep -r "AppRoutes\." lib/ --include="*.dart"
grep -r "redirect\|RouteGuard" lib/ --include="*.dart"

# 11. State management search
grep -r "Provider\|ChangeNotifier\|Consumer" lib/ --include="*.dart"
grep -r "BaseProviderState\|ViewModels" lib/ --include="*.dart"

# 12. API/Network search
grep -r "http.get\|http.post\|Dio\|fetch" lib/ --include="*.dart"
grep -r "CloudFunctions\|callFunction" lib/ --include="*.dart"
grep -r "timeout\|retry\|error" lib/ --include="*.dart" | head -20

# 13. Security search
grep -r "encrypt\|decrypt\|AES\|crypto" lib/ --include="*.dart"
grep -r "token\|secret\|key\|password" lib/ --include="*.dart" | grep -i "hardcode\|test\|example"
```

### B. File-by-File Checklist Template

For each file/module, provide:

1. **Path:** Relative to repo root (e.g., `lib/feature/auth/logic/auth_provider.dart`)
2. **Purpose:** What it should do (e.g., "Manages authentication state and user session")
3. **Role Relevance:** Guest / Owner / Both / Backend-only
4. **Implemented?** Yes / No / Partial
5. **Key Issues:** Exact lines or code snippets where possible
6. **Severity:** Critical / High / Medium / Low
7. **Suggested Fix:** Concise code snippet or precise edit instructions
8. **Tests:** Unit / Widget / Integration tests to add
9. **PR Title:** One-line suggestion (e.g., `fix(auth): secure token storage in FlutterSecureStorage`)

---

## 🔐 SPECIFIC CHECKS

### 1. UI/UX Flows

#### Guest Flows
- [ ] **Splash → Phone Auth → OTP → Role Selection → Registration → Guest Dashboard**
- [ ] **Guest Dashboard Tabs:** PGs, Foods, Payments, Complaints, Requests
- [ ] **PG Listings:** Browse, filter, search, view details, book
- [ ] **Payments:** View history, send payment, Razorpay integration
- [ ] **Complaints:** Add, view list, status tracking
- [ ] **Profile:** Edit profile, view bookings, settings
- [ ] **Navigation:** Bottom nav works, drawer accessible, back navigation

#### Owner Flows
- [ ] **Splash → Phone Auth → OTP → Role Selection → Registration → Owner Dashboard**
- [ ] **Owner Dashboard Tabs:** Overview, My PG, Guests, Foods, Analytics, Reports
- [ ] **PG Management:** Create, edit, view, manage rooms/beds
- [ ] **Guest Management:** View guests, manage bookings, handle complaints
- [ ] **Payments:** View payment notifications, manage payment details (Razorpay keys)
- [ ] **Reports:** Generate reports, export data
- [ ] **Navigation:** Bottom nav works, drawer accessible, back navigation

#### Cross-Role Checks
- [ ] Guest cannot access owner routes (redirect to guest dashboard)
- [ ] Owner cannot access guest routes (redirect to owner dashboard)
- [ ] Unauthenticated users redirected to splash/phone auth
- [ ] Error screens show appropriate messages
- [ ] Empty states implemented (no PGs, no payments, etc.)
- [ ] Loading states implemented (shimmer, spinners)
- [ ] Network error handling with retry options

### 2. Authentication & Authorization

#### Firebase Auth Integration
- [ ] **Phone OTP:** Send OTP, verify OTP, handle errors
- [ ] **Google Sign-In:** Platform-specific implementation (Android/iOS/Web)
- [ ] **Apple Sign-In:** iOS/macOS implementation
- [ ] **Token Management:** Stored in FlutterSecureStorage (not SharedPreferences)
- [ ] **Token Refresh:** Handled automatically by Firebase
- [ ] **Session Validation:** `RouteGuard.isAuthenticated()` checks Firebase Auth session

#### Role-Based Access Control (RBAC)
- [ ] **Route Guards:** `RouteGuard.getUserRole()` fetches from Firestore `users` collection
- [ ] **Route Protection:** `app_router.dart` redirects use `RouteGuard.getRedirectPath()`
- [ ] **Role Validation:** Only 'guest' and 'owner' roles allowed
- [ ] **Role Storage:** Role stored in Firestore `users/{userId}/role`
- [ ] **Client-Side Gating:** UI elements hidden/disabled based on role
- [ ] **Server-Side Assumptions:** Code handles missing/invalid roles gracefully

#### Security Checks
- [ ] No hardcoded API keys in code (check `EnvironmentConfig`)
- [ ] No tokens in logs or debug output
- [ ] Secure storage used for sensitive data (FlutterSecureStorage)
- [ ] Auth errors handled gracefully (network, invalid OTP, etc.)

### 3. API Integration & Backend

#### Firebase Firestore
- [ ] **Collections:** `users`, `pgs`, `payments`, `complaints`, `bookings`, etc.
- [ ] **Queries:** Proper indexing, error handling, offline support
- [ ] **Security Rules:** Firestore rules checked (client-side assumptions documented)
- [ ] **Data Models:** All models have `fromMap`/`toMap` with null safety

#### Supabase Storage
- [ ] **Upload:** Profile photos, Aadhaar, payment screenshots, review photos
- [ ] **Paths:** Structured paths (`profile_photos/{userId}/`, `review_photos/{pgId}/{guestId}/`)
- [ ] **Error Handling:** Upload failures handled, retry logic
- [ ] **Download URLs:** Generated and stored in Firestore

#### Cloud Functions
- [ ] **Functions:** `createUserProfile`, `verifyProperty`, `processPayment`
- [ ] **Error Handling:** Timeout, retry, error mapping
- [ ] **Emulator Support:** Development emulator configuration

#### REST API (if used)
- [ ] **Base URL:** Environment-based (dev/staging/prod)
- [ ] **Headers:** Authorization headers included
- [ ] **Timeout:** 30 seconds default (check `PlatformConstants.apiTimeout`)
- [ ] **Retry Logic:** Network failures retried

### 4. Data Persistence

#### Local Storage
- [ ] **FlutterSecureStorage:** Tokens, user IDs, sensitive data
- [ ] **SharedPreferences:** Theme, locale, user preferences (non-sensitive)
- [ ] **Schema:** No migrations needed (key-value storage)
- [ ] **Cleanup:** Logout clears all local data

#### Firestore Data
- [ ] **User Document:** `users/{userId}` with `role`, `name`, `phone`, etc.
- [ ] **PG Document:** `pgs/{pgId}` with owner reference
- [ ] **Payment Document:** `payments/{paymentId}` with guest/owner references
- [ ] **Offline Support:** Firestore cache enabled

### 5. State Management & Architecture

#### Provider Pattern
- [ ] **AuthProvider:** Extends `BaseProviderState`, manages auth state
- [ ] **ViewModels:** Feature-specific ViewModels (e.g., `GuestPaymentViewModel`)
- [ ] **State Updates:** `notifyListeners()` called appropriately
- [ ] **Memory Leaks:** Dispose methods clean up listeners

#### Dependency Injection (GetIt)
- [ ] **Firebase Services:** Registered in `firebase_service_locator.dart`
- [ ] **REST Services:** Registered in `rest_api_service_locator.dart`
- [ ] **Service Access:** Using `getIt.auth`, `getIt.firestore`, etc.
- [ ] **Initialization:** `FirebaseServiceInitializer.initialize()` called in `main.dart`

### 6. Route Guards & Navigation

#### Route Guard Implementation
- [ ] **File:** `lib/core/navigation/guards/route_guard.dart`
- [ ] **Methods:**
  - `isAuthenticated()`: Validates Firebase Auth session
  - `getUserRole()`: Fetches role from Firestore
  - `requiresAuth()`: Checks if route needs auth
  - `requiresRole()`: Checks if route needs specific role
  - `getRedirectPath()`: Returns redirect path based on auth/role
- [ ] **Error Handling:** Null checks, try-catch, debug logging

#### GoRouter Configuration
- [ ] **File:** `lib/core/navigation/app_router.dart`
- [ ] **Redirects:** Guest routes redirect owners, owner routes redirect guests
- [ ] **Route Definitions:** All routes in `AppRoutes` class
- [ ] **Nested Routes:** Payment details, complaint details nested properly
- [ ] **Route Guards:** Applied to all protected routes

### 7. Build & Configuration

#### Environment Configuration
- [ ] **File:** `lib/common/constants/environment_config.dart`
- [ ] **Values Checked:**
  - `firebaseProjectId`: Not placeholder
  - `firebaseWebApiKey`, `firebaseAndroidApiKey`, `firebaseIosApiKey`: Valid keys
  - `googleSignInClientSecret`: Not "REPLACE_WITH"
  - `supabaseUrl`, `supabaseAnonKey`: Not "your_supabase_*_here"
- [ ] **Validation:** `EnvironmentConfig.validateCredentials()` returns true
- [ ] **Production Check:** `EnvironmentConfig.isReleaseMode` used for production flags

#### Android Configuration
- [ ] **File:** `android/app/build.gradle.kts`
- [ ] **Application ID:** `com.avishio.atitia` (from `EnvironmentConfig.packageName`)
- [ ] **Signing:** Release signing configured (keystore, keyAlias)
- [ ] **Manifest:** Permissions declared (INTERNET, CAMERA, etc.)
- [ ] **Firebase:** `google-services.json` present and valid

#### iOS Configuration
- [ ] **File:** `ios/Runner/Info.plist`
- [ ] **Bundle ID:** `com.avishio.atitia` (from `EnvironmentConfig.bundleId`)
- [ ] **Firebase:** `GoogleService-Info.plist` present and valid
- [ ] **Signing:** Code signing configured (certificates, provisioning profiles)
- [ ] **Permissions:** Camera, Photos, Notifications declared

#### Web Configuration
- [ ] **File:** `web/firebase-messaging-sw.js`
- [ ] **Firebase Config:** Values match `EnvironmentConfig` (documented)
- [ ] **Manifest:** `web/manifest.json` configured (PWA settings)

### 8. Security & Deployment

#### Security Hardening Service
- [ ] **File:** `lib/core/services/security/security_hardening_service.dart`
- [ ] **Checks:**
  - `_hasHardcodedSecrets()`: Scans for placeholder patterns
  - Secret scanning for tokens, keys, passwords
- [ ] **Validation:** `EnvironmentConfig.firebaseProjectId` not suspicious

#### Deployment Optimization Service
- [ ] **File:** `lib/core/services/deployment/deployment_optimization_service.dart`
- [ ] **Checks:**
  - `_hasDevelopmentDependencies()`: No debug mode in release
  - `_hasHardcodedValues()`: All values from `EnvironmentConfig`
  - `_hasSecurityIssues()`: Basic security validation
  - `_hasPerformanceIssues()`: Release mode checks
  - `_hasAccessibilityIssues()`: Placeholder for future checks

#### Security Monitoring Service
- [ ] **File:** `lib/common/utils/security/security_monitoring_service.dart`
- [ ] **Features:**
  - Logs security events to Firebase Analytics
  - Sends alerts to Firebase Crashlytics (high/critical severity)
  - Tracks failed auth attempts, unauthorized access

### 9. Tests & CI

#### Test Structure
- [ ] **Unit Tests:** `test/unit/` (auth, viewmodels)
- [ ] **Widget Tests:** `test/widget_test.dart`
- [ ] **Integration Tests:** `test/integration/` (auth flow, booking flow)
- [ ] **Coverage:** `flutter test --coverage` generates report

#### CI/CD (Codemagic)
- [ ] **File:** `codemagic.yaml`
- [ ] **Workflows:**
  - CI: `flutter test`, `flutter analyze`, `dart format`
  - Build: Android APK/AAB, iOS IPA, Web
- [ ] **Secrets:** GitHub secrets configured (if used)

### 10. Performance

#### 60fps Budget
- [ ] **No unnecessary rebuilds:** `const` constructors used
- [ ] **ListView.builder:** Used for long lists (not ListView)
- [ ] **Image Optimization:** `cached_network_image` with `cacheWidth`/`cacheHeight`
- [ ] **Lazy Loading:** Images loaded on demand
- [ ] **RepaintBoundary:** Used for frequently animating areas

#### Memory Management
- [ ] **Dispose:** Controllers, listeners disposed in `dispose()`
- [ ] **No Memory Leaks:** Streams, timers cleaned up
- [ ] **Image Caching:** Proper cache size limits

### 11. Accessibility

#### Semantic Labels
- [ ] **Semantics Widget:** Used for screen readers
- [ ] **Button Labels:** All buttons have semantic labels
- [ ] **Image Labels:** Images have `Semantics` with `label` or `excludeSemantics: true`

#### Text Scaling
- [ ] **MediaQuery.textScaler:** Used (no hardcoded font sizes)
- [ ] **Accessibility Text Scaling:** Tested with system text scaling

#### Contrast & Colors
- [ ] **WCAG AA:** Contrast ratios meet minimum (4.5:1 for text)
- [ ] **Color Blindness:** Not relying solely on color for information

### 12. Internationalization

#### ARB Files
- [ ] **Location:** `assets/localization/`
- [ ] **Files:** `app_en.arb`, `app_te.arb` (English, Telugu)
- [ ] **Generated:** `lib/l10n/` files generated

#### Locale Support
- [ ] **Supported Locales:** English, Telugu
- [ ] **RTL Support:** Tested with `Directionality.rtl`
- [ ] **Localization:** All user-facing strings use `AppLocalizations`

---

## 📊 OUTPUT FORMAT

### 1. Summary (1-2 paragraphs)
Overall health assessment and high-level recommendation.

### 2. Prioritized Issues Table

| ID | File(s) | Severity | Impacted Role(s) | Description | Quick Remediation |
|----|---------|----------|------------------|-------------|-------------------|
| P1 | `lib/core/navigation/guards/route_guard.dart:44` | Critical | Both | Missing null check for `authUser` | Add null check |
| ... | ... | ... | ... | ... | ... |

### 3. File-by-File Audit

For each file touched by guest/owner flows:

```markdown
### lib/feature/auth/logic/auth_provider.dart
- **Purpose:** Manages authentication state and user session
- **Role Relevance:** Both (gateway for both roles)
- **Implemented:** Yes
- **Key Issues:**
  - Line 65: Potential null check missing for `currentFirebaseUser.uid`
- **Severity:** High
- **Suggested Fix:**
  ```dart
  if (currentFirebaseUser.uid.isEmpty || currentFirebaseUser.uid == null) {
    // Handle error
  }
  ```
- **Tests:** `test/unit/auth/auth_provider_test.dart` - Add test for null uid
- **PR Title:** `fix(auth): add null check for Firebase user UID validation`
```

### 4. Missing Items Checklist

- [ ] **REST API Service Implementation** (`lib/core/services/api/api_service.dart` is placeholder)
- [ ] **Supabase Storage Configuration** (URL and key may be placeholders)
- [ ] **Advanced Search Features** (PG search widget incomplete)
- [ ] **Export Functionality** (CSV/Excel export for reports)

### 5. Suggested PRs (3-7 items)

1. **`fix(security): scan and remove hardcoded secrets from EnvironmentConfig`**
   - Description: Validate all credentials are not placeholders
   - Files: `lib/common/constants/environment_config.dart`
   - Priority: Critical

2. **`feat(rbac): enhance route guard with comprehensive role validation`**
   - Description: Add additional role checks and error handling
   - Files: `lib/core/navigation/guards/route_guard.dart`
   - Priority: High

3. **`test(auth): add comprehensive unit and integration tests for auth flows`**
   - Description: Cover phone OTP, Google Sign-In, role selection
   - Files: `test/unit/auth/`, `test/integration/auth_flow_test.dart`
   - Priority: High

### 6. Minimal Code Fixes (Top 3 Critical Issues)

#### Fix #1: [Issue Title]
```dart
// File: lib/path/to/file.dart
// Line: 123

// BEFORE:
if (user.uid) { ... }

// AFTER:
if (user.uid != null && user.uid.isNotEmpty) { ... }
```

### 7. Tests to Add

#### Unit Tests
- `test/unit/auth/auth_provider_test.dart`
  - `should_validate_user_role_from_firestore`
  - `should_handle_null_role_gracefully`
  - `should_clear_cache_on_firebase_auth_mismatch`

#### Widget Tests
- `test/widget_test.dart`
  - `should_render_guest_dashboard_with_correct_tabs`
  - `should_render_owner_dashboard_with_correct_tabs`
  - `should_hide_owner_features_for_guest_role`

#### Integration Tests
- `test/integration/role_based_access_test.dart`
  - `should_prevent_guest_from_accessing_owner_routes`
  - `should_prevent_owner_from_accessing_guest_routes`
  - `should_redirect_unauthenticated_users_to_splash`

### 8. Final Verdict

**Ready to merge dev → staging?** READY / NOT READY

**Reason:** [One-line explanation]

---

## 🚨 CRITICAL PATTERNS TO FLAG

### Security Issues
- **Hardcoded Secrets:** `grep -r "AIza\|GOCSPX\|sk_\|pk_" lib/` (redact actual tokens, show first 4 and last 4 chars only)
- **Insecure Storage:** Tokens in SharedPreferences instead of FlutterSecureStorage
- **Missing Validation:** No null checks for user IDs, roles, or auth tokens

### Role Bypass
- **Direct Navigation:** `router.go(AppRoutes.ownerHome)` without role check
- **Missing Route Guards:** Routes without `redirect` checking role
- **UI Gating Only:** Features hidden in UI but accessible via deep links

### Production Issues
- **Debug Code:** `print()`, `debugPrint()` in production code
- **Placeholder Values:** `"REPLACE_WITH"`, `"your_*_here"` in config
- **Missing Error Handling:** Unhandled exceptions, no try-catch blocks
- **Performance Issues:** No `const` constructors, unnecessary rebuilds

---

## 📝 VERIFICATION CHECKLIST

Before marking as "READY", verify:

- [ ] All critical issues resolved
- [ ] Route guards prevent cross-role access
- [ ] No hardcoded secrets or placeholders
- [ ] All tests pass (`flutter test`)
- [ ] Code analysis clean (`flutter analyze`)
- [ ] Formatting correct (`dart format`)
- [ ] Build succeeds for all platforms (Android, iOS, Web)
- [ ] EnvironmentConfig validated (`EnvironmentConfig.validateCredentials()`)
- [ ] Privacy policy and terms screens accessible
- [ ] Payment gateway (Razorpay) integrated and tested
- [ ] Photo upload (Supabase) working
- [ ] Offline support (Firestore cache) enabled
- [ ] Accessibility basics (semantic labels, text scaling) implemented
- [ ] Internationalization (ARB files) complete

---

## 🔄 USAGE INSTRUCTIONS

1. **Run this audit** after significant feature updates or before release
2. **Copy the entire prompt** into your AI assistant
3. **Review the output** and prioritize fixes
4. **Create PRs** for each critical/high priority issue
5. **Re-run audit** after fixes to verify resolution
6. **Mark as READY** only when all critical issues resolved

---

## 📚 ADDITIONAL REFERENCES

- **Route Definitions:** `lib/common/utils/constants/routes.dart`
- **Firestore Collections:** `lib/common/utils/constants/firestore.dart`
- **Storage Paths:** `lib/common/utils/constants/storage.dart`
- **Environment Config:** `lib/common/constants/environment_config.dart`
- **Route Guard:** `lib/core/navigation/guards/route_guard.dart`
- **App Router:** `lib/core/navigation/app_router.dart`
- **Auth Provider:** `lib/feature/auth/logic/auth_provider.dart`

---

**Last Updated:** 2025-11-05  
**Version:** 1.0.0  
**Maintained By:** Development Team

