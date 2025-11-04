// Test helpers for CI/CD environment

/// Check if running in CI environment
bool get isCI =>
    const bool.fromEnvironment('CI', defaultValue: false) ||
    const String.fromEnvironment('GITHUB_ACTIONS', defaultValue: '') == 'true';

/// Skip test if Firebase is required but not available
void skipIfNoFirebase() {
  if (isCI) {
    // In CI, Firebase typically isn't available without emulators
    // Skip tests that require Firebase
  }
}
