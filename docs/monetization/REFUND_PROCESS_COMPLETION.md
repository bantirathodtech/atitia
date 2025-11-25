# Refund Process - Final Integration Steps

## ⚠️ Remaining Integration (5 minutes)

### 1. **Add Routes to Router** ⚠️
**File:** `lib/core/navigation/app_router.dart`

Add these routes under owner routes (around line 303):
```dart
// Refund routes
GoRoute(
  path: 'refunds/request',
  name: AppRoutes.ownerRefundRequest,
  builder: (context, state) => const OwnerRefundRequestScreen(),
),
GoRoute(
  path: 'refunds/history',
  name: AppRoutes.ownerRefundHistory,
  builder: (context, state) => const OwnerRefundHistoryScreen(),
),
```

Add this route under admin routes (around line 329):
```dart
GoRoute(
  path: 'refunds',
  name: AppRoutes.adminRefundApproval,
  builder: (context, state) => const AdminRefundApprovalScreen(),
),
```

Add imports at top:
```dart
import '../../../feature/owner_dashboard/refunds/view/screens/owner_refund_request_screen.dart';
import '../../../feature/owner_dashboard/refunds/view/screens/owner_refund_history_screen.dart';
import '../../../feature/admin_dashboard/refunds/view/screens/admin_refund_approval_screen.dart';
```

### 2. **Register ViewModels in Providers** ⚠️
**File:** `lib/core/providers/firebase/firebase_app_providers.dart`

Add to imports:
```dart
import '../../../feature/owner_dashboard/refunds/viewmodel/owner_refund_viewmodel.dart';
import '../../../feature/admin_dashboard/refunds/viewmodel/admin_refund_viewmodel.dart';
```

Add to OWNER PROVIDERS section (around line 140):
```dart
ChangeNotifierProvider<OwnerRefundViewModel>(
  create: (_) => OwnerRefundViewModel(),
),
```

Add to ADMIN PROVIDERS section (if exists, or create):
```dart
ChangeNotifierProvider<AdminRefundViewModel>(
  create: (_) => AdminRefundViewModel(),
),
```

### 3. **Add Firestore Security Rules** ⚠️
**File:** `config/firestore.rules`

Add after revenue_records rules:
```javascript
// Refund requests collection
match /refund_requests/{refundRequestId} {
  // Owners can create and read their own refund requests
  allow create: if request.auth != null 
    && request.resource.data.ownerId == request.auth.uid;
  
  allow read: if request.auth != null 
    && (resource.data.ownerId == request.auth.uid 
        || get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
  
  // Only admins can update refund requests
  allow update: if request.auth != null 
    && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
  
  // No deletions (refunds are permanent records)
  allow delete: if false;
}
```

### 4. **Add Firestore Indexes** ⚠️
**File:** `config/firestore.indexes.json`

Add composite indexes if needed:
```json
{
  "collectionGroup": "refund_requests",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "status", "order": "ASCENDING" },
    { "fieldPath": "requestedAt", "order": "DESCENDING" }
  ]
},
{
  "collectionGroup": "refund_requests",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "ownerId", "order": "ASCENDING" },
    { "fieldPath": "status", "order": "ASCENDING" },
    { "fieldPath": "requestedAt", "order": "DESCENDING" }
  ]
}
```

---

## ✅ Completed (95%)

1. ✅ Refund request model
2. ✅ Refund repository
3. ✅ Refund service
4. ✅ Admin refund ViewModel
5. ✅ Admin refund approval screen
6. ✅ Owner refund ViewModel
7. ✅ Owner refund request screen
8. ✅ Owner refund history screen
9. ✅ Routes added to constants

---

## 📝 Quick Checklist

- [ ] Add routes to `app_router.dart`
- [ ] Register ViewModels in `firebase_app_providers.dart`
- [ ] Add Firestore security rules
- [ ] Add Firestore indexes (if needed)
- [ ] Test refund request flow
- [ ] Test admin approval flow
- [ ] Test refund processing

---

**After completing these steps, the refund process will be 100% complete!**

