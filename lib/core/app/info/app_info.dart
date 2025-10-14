/// Core application information used for MaterialApp configuration.
///
/// Responsibility: "Who I am" (App identity)
/// - Provide basic app metadata for MaterialApp setup
/// - Used only in main.dart during app initialization
///
/// Usage in main.dart:
/// ```dart
/// MaterialApp(
///   title: AppInfo.appTitle,
///   debugShowCheckedModeBanner: AppInfo.showDebugBanner,
///   restorationScopeId: AppInfo.restorationScopeId,
/// )
/// ```
class AppInfo {
  static const String appTitle = 'Atitia';
  static const bool showDebugBanner = false;
  static const String restorationScopeId = 'atitia_app';
}
