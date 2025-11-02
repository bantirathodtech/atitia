#!/usr/bin/env dart

/// Debug script to test Google Sign-In configuration
/// Run this script to verify your OAuth settings

import 'dart:io';

void main() {
  print('🔍 Google Sign-In Configuration Debug');
  print('=====================================');

  // Check if running on web
  print('Platform: ${Platform.operatingSystem}');
  print(
      'Is Web: ${Platform.isWindows || Platform.isLinux || Platform.isMacOS}');

  // Display current configuration
  print('\n📋 Current Configuration:');
  print(
      'Web Client ID: 665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com');
  print(
      'Android Client ID: 665010238088-27a01be236b0ad9d19a53d.apps.googleusercontent.com');
  print(
      'iOS Client ID: 665010238088-76437d681978a96019a53d.apps.googleusercontent.com');

  print('\n⚠️  Missing Configuration:');
  print('Client Secret: GOCSPX-REPLACE_WITH_YOUR_ACTUAL_CLIENT_SECRET');

  print('\n🔧 Required Steps:');
  print('1. Go to Google Cloud Console: https://console.cloud.google.com/');
  print('2. Select project: atitia-87925');
  print('3. Navigate to: APIs & Services → Credentials');
  print(
      '4. Find Web client: 665010238088-md8lcd0vv27l3r63edbaoqjcgokbpggj.apps.googleusercontent.com');
  print('5. Add Authorized JavaScript origins:');
  print('   - http://localhost:8080');
  print('   - http://127.0.0.1:8080');
  print('   - http://localhost:3000');
  print('   - http://127.0.0.1:3000');
  print('   - http://localhost:4173');
  print('   - http://127.0.0.1:4173');
  print('6. Add Authorized redirect URIs (same as above)');
  print('7. Copy the Client Secret and update environment_config.dart');

  print('\n✅ After completing these steps, restart your Flutter app');
  print('   flutter run -d chrome --web-port 8080');
}
