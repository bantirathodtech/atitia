// lib/core/adapters/auth/authentication_service_wrapper_adapter.dart

import '../../interfaces/auth/viewmodel_auth_service_interface.dart';
import '../../services/firebase/auth/firebase_auth_service.dart';

/// Adapter that wraps AuthenticationServiceWrapper to implement IViewModelAuthService
/// This allows ViewModels to use the interface while still using the real auth service
class AuthenticationServiceWrapperAdapter implements IViewModelAuthService {
  final AuthenticationServiceWrapper _authService;

  AuthenticationServiceWrapperAdapter(
      [AuthenticationServiceWrapper? authService])
      : _authService = authService ?? AuthenticationServiceWrapper();

  @override
  String? get currentUserId => _authService.currentUserId;
}
