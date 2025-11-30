// scripts/verify_production_secrets.dart
// Run with: dart run scripts/verify_production_secrets.dart

import 'dart:io';
import 'package:atitia/common/constants/environment_config.dart';

void main() async {
  print('🔍 PRODUCTION SECRETS VERIFICATION\n');
  print('=' * 60);
  
  final issues = <String>[];
  final warnings = <String>[];
  
  // 1. Firebase Configuration
  print('\n📱 1. FIREBASE CONFIGURATION');
  print('-' * 60);
  
  final firebaseProjectId = EnvironmentConfig.firebaseProjectId;
  final firebaseWebApiKey = EnvironmentConfig.firebaseWebApiKey;
  final firebaseAndroidApiKey = EnvironmentConfig.firebaseAndroidApiKey;
  final firebaseIosApiKey = EnvironmentConfig.firebaseIosApiKey;
  
  if (firebaseProjectId.isEmpty || firebaseProjectId.contains('YOUR_')) {
    issues.add('❌ Firebase Project ID is missing or placeholder');
  } else {
    print('✅ Firebase Project ID: $firebaseProjectId');
  }
  
  if (firebaseWebApiKey.isEmpty || firebaseWebApiKey.contains('YOUR_')) {
    issues.add('❌ Firebase Web API Key is missing or placeholder');
  } else if (firebaseWebApiKey.startsWith('AIza')) {
    print('✅ Firebase Web API Key: ${firebaseWebApiKey.substring(0, 20)}...');
  } else {
    warnings.add('⚠️  Firebase Web API Key format looks unusual');
  }
  
  if (firebaseAndroidApiKey.isEmpty || firebaseAndroidApiKey.contains('YOUR_')) {
    issues.add('❌ Firebase Android API Key is missing or placeholder');
  } else if (firebaseAndroidApiKey.startsWith('AIza')) {
    print('✅ Firebase Android API Key: ${firebaseAndroidApiKey.substring(0, 20)}...');
  }
  
  if (firebaseIosApiKey.isEmpty || firebaseIosApiKey.contains('YOUR_')) {
    issues.add('❌ Firebase iOS API Key is missing or placeholder');
  } else if (firebaseIosApiKey.startsWith('AIza')) {
    print('✅ Firebase iOS API Key: ${firebaseIosApiKey.substring(0, 20)}...');
  }
  
  // 2. Google OAuth Credentials
  print('\n🔐 2. GOOGLE OAUTH CREDENTIALS');
  print('-' * 60);
  
  try {
    final webClientId = await EnvironmentConfig.getGoogleSignInWebClientIdAsync();
    if (webClientId.contains('YOUR_') || webClientId.contains('REPLACE_WITH')) {
      issues.add('❌ Google Sign-In Web Client ID is placeholder');
      print('❌ Google Web Client ID: PLACEHOLDER DETECTED');
    } else if (webClientId.endsWith('.apps.googleusercontent.com')) {
      print('✅ Google Web Client ID: ${webClientId.substring(0, 30)}...');
    } else {
      warnings.add('⚠️  Google Web Client ID format looks unusual');
    }
  } catch (e) {
    issues.add('❌ Google Sign-In Web Client ID: $e');
    print('❌ Google Web Client ID: ERROR - $e');
  }
  
  try {
    final androidClientId = await EnvironmentConfig.getGoogleSignInAndroidClientIdAsync();
    if (androidClientId.contains('YOUR_') || androidClientId.contains('REPLACE_WITH')) {
      issues.add('❌ Google Sign-In Android Client ID is placeholder');
      print('❌ Google Android Client ID: PLACEHOLDER DETECTED');
    } else if (androidClientId.endsWith('.apps.googleusercontent.com')) {
      print('✅ Google Android Client ID: ${androidClientId.substring(0, 30)}...');
    } else {
      warnings.add('⚠️  Google Android Client ID format looks unusual');
    }
  } catch (e) {
    issues.add('❌ Google Sign-In Android Client ID: $e');
    print('❌ Google Android Client ID: ERROR - $e');
  }
  
  try {
    final iosClientId = await EnvironmentConfig.getGoogleSignInIosClientIdAsync();
    if (iosClientId.contains('YOUR_') || iosClientId.contains('REPLACE_WITH')) {
      issues.add('❌ Google Sign-In iOS Client ID is placeholder');
      print('❌ Google iOS Client ID: PLACEHOLDER DETECTED');
    } else if (iosClientId.endsWith('.apps.googleusercontent.com')) {
      print('✅ Google iOS Client ID: ${iosClientId.substring(0, 30)}...');
    } else {
      warnings.add('⚠️  Google iOS Client ID format looks unusual');
    }
  } catch (e) {
    issues.add('❌ Google Sign-In iOS Client ID: $e');
    print('❌ Google iOS Client ID: ERROR - $e');
  }
  
  try {
    final clientSecret = await EnvironmentConfig.getGoogleSignInClientSecretAsync();
    if (clientSecret.contains('YOUR_') || clientSecret.contains('REPLACE_WITH') || clientSecret == 'YOUR_CLIENT_SECRET_HERE') {
      issues.add('❌ Google Sign-In Client Secret is placeholder');
      print('❌ Google Client Secret: PLACEHOLDER DETECTED');
    } else if (clientSecret.length > 20) {
      print('✅ Google Client Secret: ${clientSecret.substring(0, 10)}... (hidden)');
    } else {
      warnings.add('⚠️  Google Client Secret seems too short');
    }
  } catch (e) {
    issues.add('❌ Google Sign-In Client Secret: $e');
    print('❌ Google Client Secret: ERROR - $e');
  }
  
  // 3. Razorpay Configuration
  print('\n💳 3. RAZORPAY CONFIGURATION');
  print('-' * 60);
  
  final razorpayApiKey = EnvironmentConfig.razorpayApiKey;
  final razorpayKeySecret = EnvironmentConfig.razorpayKeySecret;
  
  if (razorpayApiKey.isEmpty) {
    issues.add('❌ Razorpay API Key is missing');
  } else if (razorpayApiKey.startsWith('rzp_test_')) {
    warnings.add('⚠️  Razorpay API Key is a TEST key (rzp_test_*). Use production key (rzp_live_*) for production');
    print('⚠️  Razorpay API Key: TEST KEY DETECTED - $razorpayApiKey');
  } else if (razorpayApiKey.startsWith('rzp_live_')) {
    print('✅ Razorpay API Key: PRODUCTION KEY - ${razorpayApiKey.substring(0, 15)}...');
  } else {
    warnings.add('⚠️  Razorpay API Key format looks unusual');
  }
  
  if (razorpayKeySecret.isEmpty) {
    issues.add('❌ Razorpay Key Secret is missing');
  } else if (razorpayKeySecret.length < 20) {
    warnings.add('⚠️  Razorpay Key Secret seems too short');
  } else {
    print('✅ Razorpay Key Secret: ${razorpayKeySecret.substring(0, 5)}... (hidden)');
  }
  
  // 4. Supabase Configuration
  print('\n🗄️  4. SUPABASE CONFIGURATION');
  print('-' * 60);
  
  final supabaseUrl = EnvironmentConfig.supabaseUrl;
  final supabaseAnonKey = EnvironmentConfig.supabaseAnonKey;
  
  if (supabaseUrl.isEmpty || !supabaseUrl.startsWith('https://')) {
    issues.add('❌ Supabase URL is missing or invalid');
  } else {
    print('✅ Supabase URL: $supabaseUrl');
  }
  
  if (supabaseAnonKey.isEmpty || supabaseAnonKey.length < 50) {
    issues.add('❌ Supabase Anon Key is missing or too short');
  } else {
    print('✅ Supabase Anon Key: ${supabaseAnonKey.substring(0, 30)}...');
  }
  
  // 5. Overall Validation
  print('\n📊 5. OVERALL VALIDATION');
  print('-' * 60);
  
  final isValid = await EnvironmentConfig.validateCredentialsAsync();
  if (isValid) {
    print('✅ Static credentials validation: PASSED');
  } else {
    issues.add('❌ Static credentials validation: FAILED');
    print('❌ Static credentials validation: FAILED');
  }
  
  final missing = EnvironmentConfig.getMissingCredentials();
  if (missing.isEmpty) {
    print('✅ No missing credentials detected');
  } else {
    issues.add('❌ Missing credentials: ${missing.join(", ")}');
    print('❌ Missing credentials: ${missing.join(", ")}');
  }
  
  // Summary
  print('\n' + '=' * 60);
  print('📋 SUMMARY');
  print('=' * 60);
  
  if (issues.isEmpty && warnings.isEmpty) {
    print('\n✅ ALL CHECKS PASSED - Ready for production!');
    exit(0);
  } else {
    if (issues.isNotEmpty) {
      print('\n🔴 CRITICAL ISSUES (Must fix before production):');
      for (final issue in issues) {
        print('  $issue');
      }
    }
    
    if (warnings.isNotEmpty) {
      print('\n🟡 WARNINGS (Should fix before production):');
      for (final warning in warnings) {
        print('  $warning');
      }
    }
    
    print('\n⚠️  NOT READY FOR PRODUCTION - Please fix the issues above');
    exit(1);
  }
}

