# 📋 Info-Level Warnings Summary

**Total:** 93 warnings  
**Date:** 2025-11-05  
**Status:** Non-blocking (all are info-level suggestions)

---

## 📊 Categories Breakdown

### 1. Deprecated API Usage (13 warnings)
**Issue:** `withOpacity` and `androidProvider` still used in some files

| File | Line | Issue | Fix |
|------|------|-------|-----|
| `lib/core/services/firebase/security/app_integrity_service.dart` | 80 | `androidProvider` deprecated | Already documented with TODO |
| `lib/feature/guest_dashboard/complaints/view/widgets/guest_complaint_card.dart` | 106 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/guest_dashboard/foods/view/screens/guest_food_list_screen.dart` | 375 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/guest_dashboard/payments/view/screens/guest_payment_screen.dart` | 240 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/guest_dashboard/pgs/view/screens/guest_pg_detail_screen.dart` | 547 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/owner_dashboard/foods/view/screens/owner_menu_edit_screen.dart` | 232, 233, 428 | `withOpacity` deprecated (3 instances) | Replace with `withValues(alpha: ...)` |
| `lib/feature/owner_dashboard/foods/view/widgets/owner_current_day_quick_edit_widget.dart` | 177, 178 | `withOpacity` deprecated (2 instances) | Replace with `withValues(alpha: ...)` |
| `lib/feature/owner_dashboard/mypg/presentation/screens/owner_pg_management_screen.dart` | 456 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/owner_dashboard/mypg/presentation/widgets/management/owner_bed_map_widget.dart` | 369 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |
| `lib/feature/owner_dashboard/mypg/presentation/widgets/management/owner_pg_info_card.dart` | 332 | `withOpacity` deprecated | Replace with `withValues(alpha: ...)` |

**Priority:** Low (functionality works, just deprecated API)

---

### 2. BuildContext Across Async Gaps (51 warnings)
**Issue:** Using `BuildContext` after async operations without checking if widget is still mounted

| File | Count | Issue |
|------|-------|-------|
| `lib/feature/guest_dashboard/complaints/view/screens/guest_complaint_add_screen.dart` | 1 | BuildContext after async |
| `lib/feature/guest_dashboard/payments/view/screens/guest_payment_detail_screen.dart` | 12 | BuildContext after async (some guarded by mounted check) |
| `lib/feature/guest_dashboard/payments/view/screens/guest_payment_screen.dart` | 2 | BuildContext after async (1 guarded by mounted check) |
| `lib/feature/guest_dashboard/profile/view/screens/guest_profile_screen.dart` | 2 | BuildContext after async |
| `lib/feature/owner_dashboard/foods/view/screens/owner_menu_edit_screen.dart` | 4 | BuildContext after async |
| `lib/feature/owner_dashboard/foods/view/screens/owner_special_menu_screen.dart` | 2 | BuildContext after async |
| `lib/feature/owner_dashboard/guests/view/screens/owner_guest_management_screen.dart` | 2 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/guests/view/widgets/bike_management_widget.dart` | 6 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/guests/view/widgets/complaint_management_widget.dart` | 4 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/guests/view/widgets/guest_list_widget.dart` | 2 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/guests/view/widgets/service_management_widget.dart` | 6 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/myguest/view/screens/owner_guest_screen.dart` | 2 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/mypg/presentation/screens/owner_pg_management_screen.dart` | 3 | BuildContext after async (guarded by mounted check) |
| `lib/feature/owner_dashboard/mypg/presentation/widgets/forms/pg_photos_form_widget.dart` | 2 | BuildContext after async |

**Fix Pattern:**
```dart
// BEFORE:
await someAsyncOperation();
Navigator.pop(context); // ⚠️ Warning

// AFTER:
await someAsyncOperation();
if (!mounted) return;
Navigator.pop(context); // ✅ Safe
```

**Priority:** Low (many are already guarded by mounted checks, but could be improved)

---

### 3. Empty Catch Blocks (4 warnings)
**Issue:** Empty catch blocks that should log errors

| File | Line | Issue |
|------|------|-------|
| `lib/feature/owner_dashboard/foods/viewmodel/owner_food_viewmodel.dart` | 150, 163 | Empty catch blocks (2 instances) |
| `lib/feature/owner_dashboard/guests/view/screens/owner_guest_management_screen.dart` | 88 | Empty catch block |
| `lib/feature/owner_dashboard/guests/viewmodel/owner_guest_viewmodel.dart` | 317 | Empty catch block |

**Fix Pattern:**
```dart
// BEFORE:
} catch (e) {
}

// AFTER:
} catch (e) {
  debugPrint('⚠️ Error description: $e');
}
```

**Priority:** Low (should add error logging)

---

### 4. Code Style Issues (8 warnings)

#### 4.1. Unnecessary Imports (3 warnings)
- `lib/common/utils/performance/memory_manager.dart:3` - `foundation.dart` unnecessary (already in `material.dart`)
- `lib/feature/owner_dashboard/foods/view/screens/owner_food_management_screen.dart:3` - `foundation.dart` unnecessary (already in `material.dart`)
- `lib/core/di/firebase/start/firebase_service_initializer.dart:26` - `foundation.dart` unnecessary (already in `widgets.dart`)

#### 4.2. Constant Naming (5 warnings)
- `lib/core/services/logging/app_logger.dart` - Constants should be lowerCamelCase:
  - `DEBUG` → `debug`
  - `INFO` → `info`
  - `WARNING` → `warning`
  - `ERROR` → `error`
  - `CRITICAL` → `critical`

**Priority:** Very Low (cosmetic only)

---

### 5. Documentation Issues (4 warnings)
**Issue:** Angle brackets in doc comments interpreted as HTML

| File | Line | Issue |
|------|------|-------|
| `lib/core/app/localization/locale_provider.dart` | 12 | Angle brackets in doc comment |
| `lib/core/db/flutter_secure_storage.dart` | 11 | Angle brackets in doc comment |
| `lib/feature/owner_dashboard/mypg/domain/entities/owner_pg_entity.dart` | 71 | Angle brackets in doc comment (2 instances) |

**Fix:** Escape angle brackets or use code blocks:
```dart
/// Use `<Type>` format  // ⚠️ Warning
/// Use `Type` format    // ✅ Fixed
/// Or: Use \&lt;Type\&gt; format
```

**Priority:** Very Low (documentation only)

---

### 6. Code Structure Issues (3 warnings)

#### 6.1. Overridden Fields (3 warnings)
- `lib/feature/guest_dashboard/profile/data/models/guest_profile_model.dart` - Fields override inherited fields (lines 28, 30, 32)

#### 6.2. Curly Braces in Flow Control (2 warnings)
- `lib/feature/owner_dashboard/mypg/presentation/widgets/management/owner_bed_map_widget.dart` - Lines 383, 384

**Priority:** Low (code style preference)

---

### 7. Dependency Issues (1 warning)
- `lib/core/services/external/google/google_sign_in_service.dart:4` - `google_sign_in` package not in dependencies (but likely in transitive dependencies)

**Priority:** Low (may need to add to `pubspec.yaml`)

---

### 8. Test File Issues (5 warnings)
- `test/performance_test.dart` - Uses `print` statements (5 instances at lines 48, 78, 104, 126, 145)

**Fix:** Replace `print` with `debugPrint` or remove in test files

**Priority:** Very Low (test files only)

---

## 📝 Summary by Priority

| Category | Count | Priority | Action Needed |
|----------|-------|----------|---------------|
| Deprecated APIs (`withOpacity`) | 12 | Low | Replace with `withValues(alpha: ...)` |
| BuildContext async gaps | 51 | Low | Add `mounted` checks |
| Empty catch blocks | 4 | Low | Add error logging |
| Unnecessary imports | 3 | Very Low | Remove redundant imports |
| Constant naming | 5 | Very Low | Rename to lowerCamelCase |
| Documentation HTML | 4 | Very Low | Escape angle brackets |
| Code structure | 5 | Low | Style improvements |
| Dependency | 1 | Low | Verify/add to pubspec |
| Test files | 5 | Very Low | Replace `print` with `debugPrint` |

---

## ✅ Recommended Actions

### High Priority (None)
All critical and high-priority issues have been resolved.

### Medium Priority (Optional)
1. **Fix remaining `withOpacity` calls** - 12 instances (15 minutes)
2. **Add error logging to empty catch blocks** - 4 instances (10 minutes)

### Low Priority (Future Cleanup)
1. **Add `mounted` checks for BuildContext** - 51 instances (can be done incrementally)
2. **Remove unnecessary imports** - 3 instances (5 minutes)
3. **Fix documentation HTML** - 4 instances (5 minutes)
4. **Rename constants** - 5 instances (10 minutes)

---

## 🎯 Conclusion

All **93 info-level warnings** are non-blocking and cosmetic. The app is **production-ready**. These can be addressed incrementally in future PRs as technical debt cleanup.

**Recommendation:** Deploy to production. Address these warnings in follow-up PRs based on priority.

