// scripts/verify_credentials.dart
//
// Verification script to check if Google OAuth credentials are properly stored
// and can be loaded from secure storage.
//
// Usage:
//   dart run scripts/verify_credentials.dart

import 'package:atitia/common/utils/security/credential_storage_helper.dart';
import 'package:atitia/common/constants/environment_config.dart';

/// Verify that Google OAuth credentials are properly configured
///
/// This script checks:
/// 1. If credentials are stored in secure storage
/// 2. If credentials can be loaded from secure storage
/// 3. If credentials are valid (not placeholders)
void main() async {
  print('🔍 Google OAuth Credential Verification');
  print('=' * 50);
  print('');

  final helper = CredentialStorageHelper();
  var allValid = true;

  // Check stored credentials
  print('📋 Checking stored credentials...');
  final stored = await helper.checkStoredCredentials();

  print('Storage Status:');
  print(
      '  Web Client ID: ${stored['web_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print(
      '  Android Client ID: ${stored['android_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print(
      '  iOS Client ID: ${stored['ios_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print(
      '  Client Secret: ${stored['client_secret'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('');

  // Try to load credentials
  print('🔄 Testing credential loading...');

  try {
    final webId = await EnvironmentConfig.getGoogleSignInWebClientIdAsync();
    if (webId.contains('YOUR_') || webId.contains('REPLACE_WITH')) {
      print('  Web Client ID: ❌ Placeholder value detected');
      allValid = false;
    } else {
      print('  Web Client ID: ✅ Loaded successfully');
      print('    Value: ${webId.substring(0, 20)}...');
    }
  } catch (e) {
    print('  Web Client ID: ❌ Failed to load - $e');
    allValid = false;
  }

  try {
    final androidId =
        await EnvironmentConfig.getGoogleSignInAndroidClientIdAsync();
    if (androidId.contains('YOUR_') || androidId.contains('REPLACE_WITH')) {
      print('  Android Client ID: ❌ Placeholder value detected');
      allValid = false;
    } else {
      print('  Android Client ID: ✅ Loaded successfully');
      print('    Value: ${androidId.substring(0, 20)}...');
    }
  } catch (e) {
    print('  Android Client ID: ❌ Failed to load - $e');
    allValid = false;
  }

  try {
    final iosId = await EnvironmentConfig.getGoogleSignInIosClientIdAsync();
    if (iosId.contains('YOUR_') || iosId.contains('REPLACE_WITH')) {
      print('  iOS Client ID: ❌ Placeholder value detected');
      allValid = false;
    } else {
      print('  iOS Client ID: ✅ Loaded successfully');
      print('    Value: ${iosId.substring(0, 20)}...');
    }
  } catch (e) {
    print('  iOS Client ID: ❌ Failed to load - $e');
    allValid = false;
  }

  try {
    final secret = await EnvironmentConfig.getGoogleSignInClientSecretAsync();
    if (secret.contains('YOUR_') || secret.contains('REPLACE_WITH')) {
      print('  Client Secret: ❌ Placeholder value detected');
      allValid = false;
    } else {
      print('  Client Secret: ✅ Loaded successfully');
      print('    Value: ${secret.substring(0, 10)}...');
    }
  } catch (e) {
    print('  Client Secret: ❌ Failed to load - $e');
    allValid = false;
  }

  print('');

  // Test async validation
  print('✅ Testing async credential validation...');
  try {
    final isValid = await EnvironmentConfig.validateCredentialsAsync();
    if (isValid) {
      print('  Async Validation: ✅ All credentials valid');
    } else {
      print('  Async Validation: ❌ Some credentials invalid');
      allValid = false;
    }
  } catch (e) {
    print('  Async Validation: ❌ Failed - $e');
    allValid = false;
  }

  print('');
  print('=' * 50);
  if (allValid) {
    print('✅ All credentials are properly configured!');
    print('');
    print(
        'Your app is ready to use Google Sign-In with secure credential storage.');
  } else {
    print('⚠️ Some credentials are missing or invalid');
    print('');
    print('Next Steps:');
    print(
        '  1. Store credentials using: dart run scripts/store_credentials_example.dart');
    print('  2. Or set environment variables during build');
    print('  3. See CREDENTIAL_STORAGE_GUIDE.md for detailed instructions');
  }
  print('');
}
