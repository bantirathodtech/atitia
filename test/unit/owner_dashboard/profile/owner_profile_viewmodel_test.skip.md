# OwnerProfileViewModel Unit Tests - Skipped

## Reason
`OwnerProfileViewModel` requires `AuthenticationServiceWrapper` which depends on Firebase initialization. Firebase cannot be initialized in unit tests because it requires platform channels that aren't available in the test environment.

## Issue
- `OwnerProfileViewModel` constructor accesses `getIt.auth` directly
- `AuthenticationServiceWrapper` requires `FirebaseAuth.instance` which needs Firebase to be initialized
- Firebase initialization fails in unit tests: "Unable to establish connection on channel"

## Solutions (Future)
1. Refactor ViewModel to accept optional auth service via dependency injection
2. Use Firebase emulator for integration tests instead
3. Create a test-specific ViewModel that doesn't require Firebase

## Test File Created
`test/unit/owner_dashboard/profile/owner_profile_viewmodel_test.dart` - Contains comprehensive test structure ready to run once Firebase issue is resolved.

