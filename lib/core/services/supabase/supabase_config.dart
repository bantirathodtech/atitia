/// Supabase Configuration
///
/// Store your Supabase credentials here
/// Get these from: https://app.supabase.com/project/_/settings/api
class SupabaseConfig {
  /// Supabase Project URL
  /// Example: 'https://your-project-id.supabase.co'
  static const String supabaseUrl = 'https://iteharwqzobkolybqvsl.supabase.co';

  /// Supabase Anon/Public Key
  /// This is safe to use in client-side code
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml0ZWhhcndxem9ia29seWJxdnNsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk5MTUzMjYsImV4cCI6MjA3NTQ5MTMyNn0.AK5HCzXT_wafICarwp0-3nALJxQ0RjB6pPg0j9TbBcA';

  /// Storage bucket name
  static const String storageBucket = 'atitia-storage';

  /// Check if Supabase is configured
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty &&
      supabaseUrl.startsWith('https://') &&
      supabaseAnonKey.isNotEmpty &&
      supabaseAnonKey.length > 50; // Valid JWT tokens are much longer
}
