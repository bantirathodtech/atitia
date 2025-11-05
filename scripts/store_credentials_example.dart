// scripts/store_credentials_example.dart
//
// Example script demonstrating how to store Google OAuth credentials
// in secure storage using the CredentialStorageHelper utility.
//
// Usage:
//   dart run scripts/store_credentials_example.dart
//
// Note: This is an example script. Modify with your actual credentials
// before running.

import 'package:atitia/common/utils/security/credential_storage_helper.dart';

/// Example: Store Google OAuth credentials in secure storage
/// 
/// This script demonstrates how to use CredentialStorageHelper
/// to store credentials securely.
void main() async {
  print('🔐 Google OAuth Credential Storage Example');
  print('=' * 50);
  print('');

  // Create helper instance
  final helper = CredentialStorageHelper();

  // Check current stored credentials
  print('📋 Checking current stored credentials...');
  final stored = await helper.checkStoredCredentials();
  
  print('Current Status:');
  print('  Web Client ID: ${stored['web_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  Android Client ID: ${stored['android_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  iOS Client ID: ${stored['ios_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  Client Secret: ${stored['client_secret'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('');

  // Example: Store credentials (replace with your actual values)
  print('💾 Storing credentials...');
  print('   (Replace these with your actual credentials from Google Cloud Console)');
  print('');

  // Example credentials - REPLACE WITH YOUR ACTUAL VALUES
  // Get these from: https://console.cloud.google.com/apis/credentials?project=atitia-87925
  
  // Store Web Client ID
  final webResult = await helper.storeGoogleWebClientId(
    'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // REPLACE THIS
  );
  print('Web Client ID: ${webResult ? "✅ Stored" : "❌ Failed"}');

  // Store Android Client ID
  final androidResult = await helper.storeGoogleAndroidClientId(
    'YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com', // REPLACE THIS
  );
  print('Android Client ID: ${androidResult ? "✅ Stored" : "❌ Failed"}');

  // Store iOS Client ID
  final iosResult = await helper.storeGoogleIosClientId(
    'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com', // REPLACE THIS
  );
  print('iOS Client ID: ${iosResult ? "✅ Stored" : "❌ Failed"}');

  // Store Client Secret (for desktop platforms)
  final secretResult = await helper.storeGoogleClientSecret(
    'GOCSPX-YOUR_CLIENT_SECRET', // REPLACE THIS
  );
  print('Client Secret: ${secretResult ? "✅ Stored" : "❌ Failed"}');
  print('');

  // Verify stored credentials
  print('🔍 Verifying stored credentials...');
  final verified = await helper.checkStoredCredentials();
  
  print('Final Status:');
  print('  Web Client ID: ${verified['web_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  Android Client ID: ${verified['android_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  iOS Client ID: ${verified['ios_client_id'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('  Client Secret: ${verified['client_secret'] == true ? "✅ Stored" : "❌ Not stored"}');
  print('');

  // Example: Store all credentials at once
  print('💡 Alternative: Store all credentials at once');
  print('   Use helper.storeAllGoogleCredentials() for convenience');
  print('');

  print('✅ Example complete!');
  print('');
  print('📝 Next Steps:');
  print('   1. Replace placeholder values with your actual credentials');
  print('   2. Run this script: dart run scripts/store_credentials_example.dart');
  print('   3. Credentials will be automatically loaded when app starts');
  print('   4. See CREDENTIAL_STORAGE_GUIDE.md for detailed instructions');
}

