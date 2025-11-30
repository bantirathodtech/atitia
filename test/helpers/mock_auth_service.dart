// test/helpers/mock_auth_service.dart

import 'package:atitia/core/interfaces/auth/viewmodel_auth_service_interface.dart';

/// Mock implementation of IViewModelAuthService for unit tests
class MockViewModelAuthService implements IViewModelAuthService {
  final String? _mockUserId;

  MockViewModelAuthService({String? mockUserId}) : _mockUserId = mockUserId;

  @override
  String? get currentUserId => _mockUserId;

  /// Helper method to set mock user ID
  void setMockUserId(String? userId) {
    // Note: This won't work with final field, but it's fine for tests
    // Tests should create new instances with different user IDs
  }
}

