# 🧪 Automatic Test Mode Detection Guide

## Overview

The app now automatically detects test phone numbers and switches to **test mode** for Firebase and Razorpay credentials. This eliminates the need to manually set environment variables or switch configurations.

## How It Works

### Test Phone Numbers

The following phone numbers automatically enable test mode:

- **Guest Test Phone**: `9876543210` (or `+91 98765 43210`)
- **Owner Test Phone**: `7020797849` (or `+91 70207 97849`)

The system normalizes phone numbers (removes spaces, `+`, dashes) before checking, so these formats all work:
- `9876543210`
- `+919876543210`
- `919876543210`
- `+91 98765 43210`
- `98765 43210`

### Automatic Detection Points

Test mode is automatically detected and enabled at these points:

1. **When sending OTP** (`AuthProvider.sendOTP()`)
   - Phone number is checked before sending OTP
   - Test mode is enabled if phone number matches test numbers

2. **When sending OTP via `sendOTPToPhone()`**
   - Alternative OTP method also checks phone number

3. **When verifying OTP** (`AuthProvider.verifyOTP()`)
   - Phone number from verified user is checked
   - Ensures test mode is set even if missed earlier

4. **After successful authentication** (`_handleSuccessfulAuthentication()`)
   - Phone number from Firebase user is checked
   - Covers all authentication methods (OTP, Google, Apple)

### What Gets Switched

When test mode is detected:

✅ **Razorpay Keys**:
- Automatically switches to test keys (`rzp_test_*`)
- Production keys (`rzp_live_*`) are used for all other phone numbers

✅ **Firebase Project**:
- Flag is set for test Firebase (`useTestFirebase = true`)
- ⚠️ **Note**: Firebase is initialized at app start, so switching Firebase projects at runtime requires app restart
- If you have test phone numbers in the same Firebase project, this works seamlessly
- If you have a separate test Firebase project, you'll need to handle Firebase initialization separately

### Test Mode Reset

Test mode is automatically reset when:
- User logs out (`AuthProvider.signOut()`)
- This ensures production mode is used for the next user

## Implementation Details

### EnvironmentConfig Changes

```dart
// Test phone numbers are defined here
static const List<String> _testPhoneNumbers = [
  '9876543210', // Guest
  '7020797849', // Owner
  // ... with various formats
];

// Runtime flag (set based on phone number)
static bool _isTestModeActive = false;

// Check if phone number is test phone
static bool isTestPhoneNumber(String phoneNumber) { ... }

// Set test mode from phone number
static void setTestModeFromPhoneNumber(String phoneNumber) { ... }

// Reset test mode
static void resetTestMode() { ... }
```

### Priority Order

For `useTestFirebase` and `useTestRazorpay`:

1. **Runtime test mode** (if user logged in with test phone) ← **Highest Priority**
2. Environment variable (`USE_TEST_FIREBASE=true` or `USE_TEST_RAZORPAY=true`)
3. Default: `false` (production)

## Usage Examples

### Testing with Test Phone Numbers

1. **Login with test phone number**:
   ```
   Phone: 9876543210
   OTP: 123456
   ```

2. **App automatically**:
   - Detects test phone number
   - Enables test mode
   - Uses test Razorpay keys
   - Sets Firebase test flag

3. **All payments/transactions**:
   - Use test Razorpay keys
   - No real money is charged

### Testing with Production Phone Numbers

1. **Login with any other phone number**:
   ```
   Phone: 1234567890
   OTP: [actual OTP]
   ```

2. **App automatically**:
   - Detects production phone number
   - Uses production mode
   - Uses production Razorpay keys
   - Uses production Firebase

## Debugging

### Check Test Mode Status

```dart
// Check if test mode is active
bool isTestMode = EnvironmentConfig.isTestModeActive;

// Check if phone number is test phone
bool isTest = EnvironmentConfig.isTestPhoneNumber('9876543210');
```

### Debug Logs

The system logs test mode changes:
```
🧪 EnvironmentConfig: Test mode ENABLED for phone: 9876543210
🧪 EnvironmentConfig: Test mode DISABLED for phone: 1234567890
🧪 EnvironmentConfig: Test mode RESET
```

## Important Notes

### Firebase Limitations

⚠️ **Firebase is initialized at app start** (`main.dart`), so:
- Switching Firebase projects at runtime requires app restart
- If test phone numbers are in the **same Firebase project**, this works seamlessly
- If you have a **separate test Firebase project**, you'll need to:
  - Use environment variables (`USE_TEST_FIREBASE=true`) before app start
  - Or handle Firebase initialization separately

### Razorpay Switching

✅ **Razorpay keys can be switched at runtime**:
- Keys are read from `EnvironmentConfig` when needed
- No app restart required
- Works immediately after test mode is detected

## Testing Checklist

- [ ] Login with Guest test phone (`9876543210`) → Test mode enabled
- [ ] Login with Owner test phone (`7020797849`) → Test mode enabled
- [ ] Login with production phone → Production mode
- [ ] Logout → Test mode reset
- [ ] Verify Razorpay uses test keys in test mode
- [ ] Verify Razorpay uses production keys in production mode

## Support

For issues or questions:
1. Check debug logs for test mode status
2. Verify phone number format matches test numbers
3. Ensure test phone numbers are configured in Firebase Console
4. Check that Razorpay keys are correctly set in `EnvironmentConfig`

