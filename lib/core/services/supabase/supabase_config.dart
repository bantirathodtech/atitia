/// Supabase Configuration
///
/// ⚠️ NOTE: Supabase credentials are now centralized in `EnvironmentConfig`.
/// This class references `EnvironmentConfig` for all credentials.
///
/// Get credentials from: https://app.supabase.com/project/_/settings/api
/// Source: `lib/common/constants/environment_config.dart`
library;

import '../../../common/constants/environment_config.dart';

class SupabaseConfig {
  /// Supabase Project URL
  /// Example: 'https://your-project-id.supabase.co'
  /// ⚠️ NOTE: Now references EnvironmentConfig (single source of truth)
  static String get supabaseUrl => EnvironmentConfig.supabaseUrl;

  /// Supabase Anon/Public Key
  /// This is safe to use in client-side code
  /// ⚠️ NOTE: Now references EnvironmentConfig (single source of truth)
  static String get supabaseAnonKey => EnvironmentConfig.supabaseAnonKey;

  /// Storage bucket name
  /// ⚠️ NOTE: Now references EnvironmentConfig (single source of truth)
  static String get storageBucket => EnvironmentConfig.supabaseStorageBucket;

  /// Check if Supabase is configured
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseUrl.startsWith('https://') &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey.length > 50; // Valid JWT tokens are much longer
}
