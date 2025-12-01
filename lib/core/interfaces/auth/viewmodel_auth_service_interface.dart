// lib/core/interfaces/auth/viewmodel_auth_service_interface.dart

/// Simple interface for ViewModels that only need current user ID
/// This allows ViewModels to be testable without Firebase initialization
///
/// Usage in ViewModels:
/// ```dart
/// class MyViewModel {
///   final IViewModelAuthService _authService;
///
///   MyViewModel({IViewModelAuthService? authService})
///     : _authService = authService ?? AuthenticationServiceWrapperAdapter();
///
///   String? get currentUserId => _authService.currentUserId;
/// }
/// ```
abstract class IViewModelAuthService {
  /// Gets current authenticated user ID
  /// Returns null if no user is signed in
  String? get currentUserId;
}
