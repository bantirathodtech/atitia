// test/security_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:atitia/common/utils/security/encryption_service.dart';
import 'package:atitia/common/utils/security/input_validation_service.dart';
import 'package:atitia/common/utils/security/api_security_service.dart';
import 'package:atitia/common/utils/security/security_monitoring_service.dart';
import 'package:atitia/core/services/firebase/analytics/firebase_analytics_service.dart';
import 'package:atitia/core/services/firebase/crashlytics/firebase_crashlytics_service.dart';

void main() {
  group('Security Tests', () {
    late EncryptionService encryptionService;
    late InputValidationService validationService;
    late ApiSecurityService apiSecurityService;
    late SecurityMonitoringService securityMonitoringService;

    setUpAll(() {
      // Initialize GetIt with mock services for security tests
      final getIt = GetIt.instance;
      
      // Unregister existing services if they exist
      try {
        if (getIt.isRegistered<AnalyticsServiceWrapper>()) {
          getIt.unregister<AnalyticsServiceWrapper>();
        }
      } catch (_) {}
      
      try {
        if (getIt.isRegistered<CrashlyticsServiceWrapper>()) {
          getIt.unregister<CrashlyticsServiceWrapper>();
        }
      } catch (_) {}

      // Register mock analytics service
      getIt.registerLazySingleton<AnalyticsServiceWrapper>(
        () => _MockAnalyticsService(),
      );

      // Register mock crashlytics service
      getIt.registerLazySingleton<CrashlyticsServiceWrapper>(
        () => _MockCrashlyticsService(),
      );
    });

    tearDownAll(() {
      // Clean up GetIt
      final getIt = GetIt.instance;
      try {
        if (getIt.isRegistered<AnalyticsServiceWrapper>()) {
          getIt.unregister<AnalyticsServiceWrapper>();
        }
      } catch (_) {}
      
      try {
        if (getIt.isRegistered<CrashlyticsServiceWrapper>()) {
          getIt.unregister<CrashlyticsServiceWrapper>();
        }
      } catch (_) {}
    });

    setUp(() {
      // Reset InternationalizationService instance
      // This is needed because it's a singleton that caches GetIt.analytics
      // We'll create a new instance for each test
      encryptionService = EncryptionService();
      validationService = InputValidationService();
      apiSecurityService = ApiSecurityService();
      securityMonitoringService = SecurityMonitoringService();

      encryptionService.initialize();
    });

    group('Encryption Service Tests', () {
      test('should encrypt and decrypt data correctly', () {
        const plaintext = 'sensitive_data_123';

        final encrypted = encryptionService.encrypt(plaintext);
        final decrypted = encryptionService.decrypt(encrypted);

        expect(encrypted, isNot(equals(plaintext)));
        expect(decrypted, equals(plaintext));
      });

      test('should hash data correctly', () {
        const data = 'password123';

        final hash1 = encryptionService.hash(data);
        final hash2 = encryptionService.hash(data);

        expect(hash1, equals(hash2));
        expect(hash1, isNot(equals(data)));
      });

      test('should hash with salt correctly', () {
        const data = 'password123';
        const salt = 'random_salt';

        final hash1 = encryptionService.hash(data, salt: salt);
        final hash2 = encryptionService.hash(data, salt: salt);

        expect(hash1, equals(hash2));
        expect(hash1, isNot(equals(data)));
      });

      test('should validate encryption integrity', () {
        const plaintext = 'test_data';

        final isValid = encryptionService.validateEncryption(plaintext);

        expect(isValid, isTrue);
      });

      test('should generate secure salt', () {
        final salt1 = encryptionService.generateSalt();
        final salt2 = encryptionService.generateSalt();

        expect(salt1, isNotEmpty);
        expect(salt2, isNotEmpty);
        expect(salt1, isNot(equals(salt2)));
      });
    });

    group('Input Validation Service Tests', () {
      test('should validate email correctly', () {
        final result1 = validationService.validateEmail('test@example.com');
        expect(result1.isValid, isTrue);
        expect(result1.value, equals('test@example.com'));

        final result2 = validationService.validateEmail('invalid-email');
        expect(result2.isValid, isFalse);
        expect(result2.errorMessage, contains('valid email'));

        final result3 = validationService.validateEmail('');
        expect(result3.isValid, isFalse);
        expect(result3.errorMessage, contains('required'));
      });

      test('should validate phone number correctly', () {
        final result1 = validationService.validatePhone('9876543210');
        expect(result1.isValid, isTrue);
        expect(result1.value, equals('9876543210'));

        final result2 = validationService.validatePhone('123456789');
        expect(result2.isValid, isFalse);
        expect(result2.errorMessage, contains('10 digits'));

        final result3 = validationService.validatePhone('invalid-phone');
        expect(result3.isValid, isFalse);
      });

      test('should validate name correctly', () {
        final result1 = validationService.validateName('John Doe');
        expect(result1.isValid, isTrue);
        expect(result1.value, equals('John Doe'));

        final result2 = validationService.validateName('John123');
        expect(result2.isValid, isFalse);
        expect(result2.errorMessage, contains('letters and spaces'));

        final result3 = validationService.validateName('');
        expect(result3.isValid, isFalse);
        expect(result3.errorMessage, contains('required'));
      });

      test('should validate password correctly', () {
        final result1 = validationService.validatePassword('Password123!');
        expect(result1.isValid, isTrue);

        final result2 = validationService.validatePassword('weak');
        expect(result2.isValid, isFalse);
        expect(result2.errorMessage, contains('at least 8 characters'));

        final result3 = validationService.validatePassword('password123');
        expect(result3.isValid, isFalse);
        expect(result3.errorMessage, contains('uppercase'));
      });

      test('should validate OTP correctly', () {
        final result1 = validationService.validateOTP('123456');
        expect(result1.isValid, isTrue);
        expect(result1.value, equals('123456'));

        final result2 = validationService.validateOTP('12345');
        expect(result2.isValid, isFalse);
        expect(result2.errorMessage, contains('6 digits'));

        final result3 = validationService.validateOTP('abc123');
        expect(result3.isValid, isFalse);
        expect(result3.errorMessage, contains('only digits'));
      });

      test('should sanitize suspicious input', () {
        final result1 =
            validationService.validateText('<script>alert("xss")</script>');
        expect(result1.isValid, isFalse);
        expect(result1.errorMessage, contains('Invalid text format'));

        final result2 = validationService.validateText('normal text');
        expect(result2.isValid, isTrue);
        expect(result2.value, equals('normal text'));
      });
    });

    group('API Security Service Tests', () {
      test('should check rate limit correctly', () {
        const clientId = 'test_client';

        // First request should pass
        expect(apiSecurityService.checkRateLimit(clientId), isTrue);

        // Multiple requests should eventually hit rate limit
        for (int i = 0; i < 10; i++) {
          apiSecurityService.checkRateLimit(clientId);
        }

        final remaining = apiSecurityService.getRemainingRequests(clientId);
        expect(remaining, lessThan(100));
      });

      test('should validate request headers correctly', () {
        final validHeaders = {'content-type': 'application/json'};
        expect(apiSecurityService.validateRequestHeaders(validHeaders), isTrue);

        final invalidHeaders = {'content-type': 'text/html'};
        expect(
            apiSecurityService.validateRequestHeaders(invalidHeaders), isFalse);
      });

      test('should validate request body correctly', () {
        final validBody = '{"key": "value"}';
        expect(apiSecurityService.validateRequestBody(validBody), isTrue);

        final invalidBody = 'invalid json';
        expect(apiSecurityService.validateRequestBody(invalidBody), isFalse);

        final suspiciousBody = '{"key": "<script>alert(\'xss\')</script>"}';
        expect(apiSecurityService.validateRequestBody(suspiciousBody), isFalse);
      });

      test('should generate and validate API token', () {
        final token = apiSecurityService.generateApiToken();
        expect(token, isNotEmpty);

        expect(apiSecurityService.validateApiToken(token), isTrue);
        expect(apiSecurityService.validateApiToken('invalid_token'), isFalse);
      });

      test('should validate IP address format', () {
        expect(
            apiSecurityService.getClientIP({'x-forwarded-for': '192.168.1.1'}),
            equals('192.168.1.1'));
        expect(apiSecurityService.getClientIP({'x-real-ip': '10.0.0.1'}),
            equals('10.0.0.1'));
        expect(
            apiSecurityService.getClientIP({'invalid-header': '192.168.1.1'}),
            isNull);
      });
    });

    group('Security Monitoring Service Tests', () {
      test('should log security events correctly', () {
        securityMonitoringService.logSecurityEvent(
          eventType: 'test_event',
          description: 'Test security event',
          userId: 'test_user',
          level: SecurityLevel.info,
        );

        final events = securityMonitoringService.getSecurityEvents();
        expect(events.length, greaterThan(0));
        expect(events.first.eventType, equals('test_event'));
      });

      test('should log authentication failures correctly', () {
        securityMonitoringService.logAuthenticationFailure(
          userId: 'test_user',
          failureReason: 'invalid_password',
          deviceId: 'test_device',
          ipAddress: '192.168.1.1',
        );

        final events = securityMonitoringService.getSecurityEvents(
            eventType: 'authentication_failure');
        expect(events.length, greaterThan(0));
        expect(events.first.userId, equals('test_user'));
      });

      test('should log suspicious activity correctly', () {
        securityMonitoringService.logSuspiciousActivity(
          activityType: 'suspicious_login',
          description: 'Multiple failed login attempts',
          userId: 'test_user',
          deviceId: 'test_device',
          ipAddress: '192.168.1.1',
        );

        final events = securityMonitoringService.getSecurityEvents(
            eventType: 'suspicious_activity');
        expect(events.length, greaterThan(0));
        expect(events.first.description,
            contains('Multiple failed login attempts'));
      });

      test('should trigger security alerts correctly', () {
        // Log multiple authentication failures to trigger alert
        for (int i = 0; i < 6; i++) {
          securityMonitoringService.logAuthenticationFailure(
            userId: 'test_user',
            failureReason: 'invalid_password',
          );
        }

        final alerts = securityMonitoringService.getSecurityAlerts();
        expect(alerts.length, greaterThan(0));
        expect(alerts.first.alertType, equals('multiple_failed_attempts'));
      });

      test('should get security metrics correctly', () {
        securityMonitoringService.logSecurityEvent(
          eventType: 'test_event',
          description: 'Test event',
        );

        final metrics = securityMonitoringService.getSecurityMetrics();
        expect(metrics['totalEvents'], greaterThan(0));
        expect(metrics['totalAlerts'], greaterThanOrEqualTo(0));
      });
    });

    group('Security Integration Tests', () {
      test('should handle complete security workflow', () {
        // 1. Validate input
        final validationResult =
            validationService.validateEmail('test@example.com');
        expect(validationResult.isValid, isTrue);

        // 2. Encrypt sensitive data
        final encrypted = encryptionService.encrypt(validationResult.value);
        expect(encrypted, isNotEmpty);

        // 3. Log security event
        securityMonitoringService.logSecurityEvent(
          eventType: 'data_encryption',
          description: 'Sensitive data encrypted',
          level: SecurityLevel.info,
        );

        // 4. Check rate limit
        expect(apiSecurityService.checkRateLimit('test_client'), isTrue);

        // Verify all components are working together
        final events = securityMonitoringService.getSecurityEvents();
        expect(events.length, greaterThan(0));
      });

      test('should detect and respond to security threats', () {
        // Simulate suspicious activity
        validationService.validateText('<script>alert("xss")</script>');

        securityMonitoringService.logSuspiciousActivity(
          activityType: 'xss_attempt',
          description: 'XSS attempt detected',
          userId: 'malicious_user',
        );

        // Verify threat detection
        final events = securityMonitoringService.getSecurityEvents(
            eventType: 'suspicious_activity');
        expect(events.length, greaterThan(0));
        expect(events.first.description, contains('XSS attempt'));
      });
    });
  });
}

/// Mock AnalyticsServiceWrapper for security tests
/// Note: Cannot extend due to private constructor, so we use noSuchMethod
class _MockAnalyticsService implements AnalyticsServiceWrapper {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String? userId) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Mock implementation - do nothing
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Mock CrashlyticsServiceWrapper for security tests
/// Note: Cannot extend due to private constructor, so we use noSuchMethod
class _MockCrashlyticsService implements CrashlyticsServiceWrapper {
  @override
  Future<void> log(String message) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> recordError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String userId) async {
    // Mock implementation - do nothing
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
