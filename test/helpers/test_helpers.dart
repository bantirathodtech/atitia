// test/helpers/test_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'package:atitia/common/lifecycle/state/provider_state.dart';
import 'package:atitia/feature/auth/data/model/user_model.dart';

/// Test helpers and utilities for Atitia app testing
class TestHelpers {
  /// Creates a test widget with necessary providers
  static Widget createTestWidget({
    required Widget child,
    List<ChangeNotifierProvider> providers = const [],
  }) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: Scaffold(body: child),
        theme: ThemeData.light(),
      ),
    );
  }

  /// Creates a test widget with theme support
  static Widget createThemedTestWidget({
    required Widget child,
    ThemeData? theme,
    List<ChangeNotifierProvider> providers = const [],
  }) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        home: Scaffold(body: child),
        theme: theme ?? ThemeData.light(),
      ),
    );
  }

  /// Waits for a widget to appear with timeout
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle();
    expect(finder, findsOneWidget);
  }

  /// Pumps widget with proper timing for animations
  static Future<void> pumpWidgetWithTiming(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }

  /// Creates a mock user model for testing
  static UserModel createMockUser({
    String? userId,
    String? role,
    String? phoneNumber,
  }) {
    return UserModel(
      userId: userId ?? 'test_user_123',
      phoneNumber: phoneNumber ?? '+919876543210',
      role: role ?? 'guest',
      fullName: 'Test User',
      email: 'test@example.com',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Creates a mock owner user model for testing
  static UserModel createMockOwnerUser({
    String? userId,
    String? phoneNumber,
  }) {
    return UserModel(
      userId: userId ?? 'test_owner_123',
      phoneNumber: phoneNumber ?? '+919876543211',
      role: 'owner',
      fullName: 'Test Owner',
      email: 'owner@example.com',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Creates a mock guest user model for testing
  static UserModel createMockGuestUser({
    String? userId,
    String? phoneNumber,
  }) {
    return UserModel(
      userId: userId ?? 'test_guest_123',
      phoneNumber: phoneNumber ?? '+919876543212',
      role: 'guest',
      fullName: 'Test Guest',
      email: 'guest@example.com',
      isActive: true,
      isVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastLoginAt: DateTime.now(),
    );
  }

  /// Resets GetIt service locator for testing
  static void resetGetIt() {
    if (GetIt.instance.isRegistered<GetIt>()) {
      GetIt.instance.reset();
    }
  }

  /// Creates a mock BaseProviderState for testing
  static BaseProviderState createMockProviderState({
    bool isLoading = false,
    bool hasError = false,
    String? errorMessage,
  }) {
    return _MockBaseProviderState(
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: errorMessage,
    );
  }
}

/// Mock implementation of BaseProviderState for testing
class _MockBaseProviderState extends BaseProviderState {
  final bool _isLoading;
  final bool _hasError;
  final String? _errorMessage;

  _MockBaseProviderState({
    required bool isLoading,
    required bool hasError,
    String? errorMessage,
  })  : _isLoading = isLoading,
        _hasError = hasError,
        _errorMessage = errorMessage;

  @override
  bool get loading => _isLoading;

  @override
  bool get error => _hasError;

  @override
  String? get errorMessage => _errorMessage;

  @override
  void setLoading(bool loading) {
    super.setLoading(loading);
  }

  @override
  void setError(bool hasError, [String? message]) {
    super.setError(hasError, message);
  }

  @override
  void clearError() {
    super.clearError();
  }
}
