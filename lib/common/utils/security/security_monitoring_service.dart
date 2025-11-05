// lib/common/utils/security/security_monitoring_service.dart

import 'package:flutter/foundation.dart';

import '../../../core/di/firebase/di/firebase_service_locator.dart';

/// Security monitoring service for threat detection and security event logging
class SecurityMonitoringService {
  static final SecurityMonitoringService _instance =
      SecurityMonitoringService._internal();
  factory SecurityMonitoringService() => _instance;
  SecurityMonitoringService._internal();

  final List<SecurityEvent> _securityEvents = [];
  final List<SecurityAlert> _securityAlerts = [];
  final Map<String, int> _failedAttempts = {};
  final Map<String, DateTime> _lastFailedAttempt = {};

  // Security thresholds
  static const int _maxFailedAttempts = 5;
  // TODO: Implement rate limiting using these thresholds
  // ignore: unused_field
  static const Duration _failedAttemptWindow = Duration(minutes: 15);
  // ignore: unused_field
  static const Duration _alertCooldown = Duration(minutes: 5);

  /// Log a security event
  void logSecurityEvent({
    required String eventType,
    required String description,
    String? userId,
    String? deviceId,
    Map<String, dynamic>? metadata,
    SecurityLevel level = SecurityLevel.info,
  }) {
    final event = SecurityEvent(
      id: _generateEventId(),
      eventType: eventType,
      description: description,
      userId: userId,
      deviceId: deviceId,
      timestamp: DateTime.now(),
      level: level,
      metadata: metadata ?? {},
    );

    _securityEvents.add(event);

    // Check if this event should trigger an alert
    _checkForSecurityAlerts(event);

    // Log to console in debug mode
    if (kDebugMode) {}

    // In production, this should send to a security monitoring service
    _sendToSecurityService(event);
  }

  /// Log authentication failure
  void logAuthenticationFailure({
    required String userId,
    required String failureReason,
    String? deviceId,
    String? ipAddress,
  }) {
    final key = '$userId:$deviceId:$ipAddress';
    _failedAttempts[key] = (_failedAttempts[key] ?? 0) + 1;
    _lastFailedAttempt[key] = DateTime.now();

    logSecurityEvent(
      eventType: 'authentication_failure',
      description: 'Authentication failed for user $userId: $failureReason',
      userId: userId,
      deviceId: deviceId,
      level: SecurityLevel.warning,
      metadata: {
        'failure_reason': failureReason,
        'failed_attempts': _failedAttempts[key],
        'ip_address': ipAddress,
      },
    );

    // Check if this should trigger a security alert
    if (_failedAttempts[key]! >= _maxFailedAttempts) {
      _triggerSecurityAlert(
        alertType: 'multiple_failed_attempts',
        description:
            'Multiple failed authentication attempts detected for user $userId',
        userId: userId,
        deviceId: deviceId,
        severity: SecuritySeverity.high,
        metadata: {
          'failed_attempts': _failedAttempts[key],
          'ip_address': ipAddress,
        },
      );
    }
  }

  /// Log suspicious activity
  void logSuspiciousActivity({
    required String activityType,
    required String description,
    String? userId,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) {
    logSecurityEvent(
      eventType: 'suspicious_activity',
      description: description,
      userId: userId,
      deviceId: deviceId,
      level: SecurityLevel.warning,
      metadata: {
        'activity_type': activityType,
        'ip_address': ipAddress,
        ...?metadata,
      },
    );

    _triggerSecurityAlert(
      alertType: 'suspicious_activity',
      description: description,
      userId: userId,
      deviceId: deviceId,
      severity: SecuritySeverity.medium,
      metadata: {
        'activity_type': activityType,
        'ip_address': ipAddress,
        ...?metadata,
      },
    );
  }

  /// Log data breach attempt
  void logDataBreachAttempt({
    required String description,
    String? userId,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) {
    logSecurityEvent(
      eventType: 'data_breach_attempt',
      description: description,
      userId: userId,
      deviceId: deviceId,
      level: SecurityLevel.critical,
      metadata: {
        'ip_address': ipAddress,
        ...?metadata,
      },
    );

    _triggerSecurityAlert(
      alertType: 'data_breach_attempt',
      description: description,
      userId: userId,
      deviceId: deviceId,
      severity: SecuritySeverity.critical,
      metadata: {
        'ip_address': ipAddress,
        ...?metadata,
      },
    );
  }

  /// Log successful authentication
  void logSuccessfulAuthentication({
    required String userId,
    String? deviceId,
    String? ipAddress,
    String? authMethod,
  }) {
    // Reset failed attempts for this user
    _resetFailedAttempts(userId, deviceId, ipAddress);

    logSecurityEvent(
      eventType: 'authentication_success',
      description: 'Successful authentication for user $userId',
      userId: userId,
      deviceId: deviceId,
      level: SecurityLevel.info,
      metadata: {
        'ip_address': ipAddress,
        'auth_method': authMethod,
      },
    );
  }

  /// Log API security violation
  void logApiSecurityViolation({
    required String violationType,
    required String description,
    String? userId,
    String? deviceId,
    String? ipAddress,
    Map<String, dynamic>? metadata,
  }) {
    logSecurityEvent(
      eventType: 'api_security_violation',
      description: description,
      userId: userId,
      deviceId: deviceId,
      level: SecurityLevel.warning,
      metadata: {
        'violation_type': violationType,
        'ip_address': ipAddress,
        ...?metadata,
      },
    );

    _triggerSecurityAlert(
      alertType: 'api_security_violation',
      description: description,
      userId: userId,
      deviceId: deviceId,
      severity: SecuritySeverity.medium,
      metadata: {
        'violation_type': violationType,
        'ip_address': ipAddress,
        ...?metadata,
      },
    );
  }

  /// Check for security alerts based on events
  void _checkForSecurityAlerts(SecurityEvent event) {
    switch (event.eventType) {
      case 'authentication_failure':
        _checkAuthenticationFailureAlert(event);
        break;
      case 'suspicious_activity':
        _checkSuspiciousActivityAlert(event);
        break;
      case 'data_breach_attempt':
        _checkDataBreachAlert(event);
        break;
      case 'api_security_violation':
        _checkApiSecurityAlert(event);
        break;
    }
  }

  /// Check authentication failure alert
  void _checkAuthenticationFailureAlert(SecurityEvent event) {
    final userId = event.userId;
    if (userId == null) return;

    final failedAttempts = _getFailedAttemptsForUser(userId);
    if (failedAttempts >= _maxFailedAttempts) {
      _triggerSecurityAlert(
        alertType: 'multiple_failed_attempts',
        description: 'Multiple failed authentication attempts for user $userId',
        userId: userId,
        deviceId: event.deviceId,
        severity: SecuritySeverity.high,
      );
    }
  }

  /// Check suspicious activity alert
  void _checkSuspiciousActivityAlert(SecurityEvent event) {
    _triggerSecurityAlert(
      alertType: 'suspicious_activity',
      description: event.description,
      userId: event.userId,
      deviceId: event.deviceId,
      severity: SecuritySeverity.medium,
    );
  }

  /// Check data breach alert
  void _checkDataBreachAlert(SecurityEvent event) {
    _triggerSecurityAlert(
      alertType: 'data_breach_attempt',
      description: event.description,
      userId: event.userId,
      deviceId: event.deviceId,
      severity: SecuritySeverity.critical,
    );
  }

  /// Check API security alert
  void _checkApiSecurityAlert(SecurityEvent event) {
    _triggerSecurityAlert(
      alertType: 'api_security_violation',
      description: event.description,
      userId: event.userId,
      deviceId: event.deviceId,
      severity: SecuritySeverity.medium,
    );
  }

  /// Trigger a security alert
  void _triggerSecurityAlert({
    required String alertType,
    required String description,
    String? userId,
    String? deviceId,
    SecuritySeverity severity = SecuritySeverity.medium,
    Map<String, dynamic>? metadata,
  }) {
    final alert = SecurityAlert(
      id: _generateAlertId(),
      alertType: alertType,
      description: description,
      userId: userId,
      deviceId: deviceId,
      timestamp: DateTime.now(),
      severity: severity,
      metadata: metadata ?? {},
      status: AlertStatus.active,
    );

    _securityAlerts.add(alert);

    // In production, this should send to a security monitoring service
    _sendAlertToSecurityService(alert);
  }

  /// Reset failed attempts for a user
  void _resetFailedAttempts(
      String userId, String? deviceId, String? ipAddress) {
    final keys = [
      '$userId:$deviceId:$ipAddress',
      '$userId:$deviceId:',
      '$userId::',
    ];

    for (final key in keys) {
      _failedAttempts.remove(key);
      _lastFailedAttempt.remove(key);
    }
  }

  /// Get failed attempts for a user
  int _getFailedAttemptsForUser(String userId) {
    int totalAttempts = 0;
    for (final entry in _failedAttempts.entries) {
      if (entry.key.startsWith('$userId:')) {
        totalAttempts += entry.value;
      }
    }
    return totalAttempts;
  }

  /// Generate unique event ID
  String _generateEventId() {
    return 'event_${DateTime.now().millisecondsSinceEpoch}_${_securityEvents.length}';
  }

  /// Generate unique alert ID
  String _generateAlertId() {
    return 'alert_${DateTime.now().millisecondsSinceEpoch}_${_securityAlerts.length}';
  }

  /// Send event to security service
  void _sendToSecurityService(SecurityEvent event) {
    // Send security events to Firebase Analytics for monitoring
    try {
      final analytics = getIt.analytics;

      // Log security event to analytics
      analytics.logEvent(
        name: 'security_event',
        parameters: {
          'event_type': event.eventType,
          'description': event.description,
          'level': event.level.toString(),
          'timestamp': event.timestamp.toIso8601String(),
          if (event.userId != null) 'user_id': event.userId!,
          if (event.deviceId != null) 'device_id': event.deviceId!,
          ...event.metadata,
        },
      );

      // In debug mode, also log to console
      if (kDebugMode) {
        debugPrint('Security Event: ${event.eventType} - ${event.description}');
      }
    } catch (e) {
      // If analytics fails, at least log to console in debug mode
      if (kDebugMode) {
        debugPrint('Failed to send security event to analytics: $e');
      }
    }
  }

  /// Send alert to security service
  void _sendAlertToSecurityService(SecurityAlert alert) {
    // Send security alerts to Firebase Analytics and Crashlytics
    try {
      final analytics = getIt.analytics;
      final crashlytics = getIt.crashlytics;

      // Log security alert to analytics
      analytics.logEvent(
        name: 'security_alert',
        parameters: {
          'alert_type': alert.alertType,
          'description': alert.description,
          'severity': alert.severity.toString(),
          'timestamp': alert.timestamp.toIso8601String(),
          if (alert.userId != null) 'user_id': alert.userId!,
          if (alert.deviceId != null) 'device_id': alert.deviceId!,
          ...alert.metadata,
        },
      );

      // Log to Crashlytics for high-severity alerts
      if (alert.severity == SecuritySeverity.high ||
          alert.severity == SecuritySeverity.critical) {
        crashlytics.log(
          'Security Alert: ${alert.alertType} - ${alert.description}',
        );

        // Set custom key for tracking
        crashlytics.setCustomKey('security_alert_type', alert.alertType);
        crashlytics.setCustomKey(
            'security_alert_severity', alert.severity.toString());
      }

      // In debug mode, also log to console
      if (kDebugMode) {
        debugPrint(
          'Security Alert [${alert.severity}]: ${alert.alertType} - ${alert.description}',
        );
      }
    } catch (e) {
      // If services fail, at least log to console in debug mode
      if (kDebugMode) {
        debugPrint('Failed to send security alert to services: $e');
      }
    }
  }

  /// Get security events
  List<SecurityEvent> getSecurityEvents({
    String? eventType,
    SecurityLevel? level,
    DateTime? since,
  }) {
    var events = _securityEvents;

    if (eventType != null) {
      events = events.where((e) => e.eventType == eventType).toList();
    }

    if (level != null) {
      events = events.where((e) => e.level == level).toList();
    }

    if (since != null) {
      events = events.where((e) => e.timestamp.isAfter(since)).toList();
    }

    return events.reversed.toList(); // Most recent first
  }

  /// Get security alerts
  List<SecurityAlert> getSecurityAlerts({
    String? alertType,
    SecuritySeverity? severity,
    AlertStatus? status,
    DateTime? since,
  }) {
    var alerts = _securityAlerts;

    if (alertType != null) {
      alerts = alerts.where((a) => a.alertType == alertType).toList();
    }

    if (severity != null) {
      alerts = alerts.where((a) => a.severity == severity).toList();
    }

    if (status != null) {
      alerts = alerts.where((a) => a.status == status).toList();
    }

    if (since != null) {
      alerts = alerts.where((a) => a.timestamp.isAfter(since)).toList();
    }

    return alerts.reversed.toList(); // Most recent first
  }

  /// Get security metrics
  Map<String, dynamic> getSecurityMetrics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final last7Days = now.subtract(const Duration(days: 7));

    final events24h =
        _securityEvents.where((e) => e.timestamp.isAfter(last24Hours)).length;
    final events7d =
        _securityEvents.where((e) => e.timestamp.isAfter(last7Days)).length;
    final alerts24h =
        _securityAlerts.where((a) => a.timestamp.isAfter(last24Hours)).length;
    final alerts7d =
        _securityAlerts.where((a) => a.timestamp.isAfter(last7Days)).length;

    return {
      'totalEvents': _securityEvents.length,
      'totalAlerts': _securityAlerts.length,
      'events24h': events24h,
      'events7d': events7d,
      'alerts24h': alerts24h,
      'alerts7d': alerts7d,
      'failedAttempts': _failedAttempts.length,
      'activeAlerts':
          _securityAlerts.where((a) => a.status == AlertStatus.active).length,
    };
  }

  /// Clear old security events (older than 30 days)
  void clearOldEvents() {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    _securityEvents.removeWhere((e) => e.timestamp.isBefore(cutoff));
  }

  /// Clear old security alerts (older than 7 days)
  void clearOldAlerts() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    _securityAlerts.removeWhere((a) => a.timestamp.isBefore(cutoff));
  }
}

/// Security event class
class SecurityEvent {
  final String id;
  final String eventType;
  final String description;
  final String? userId;
  final String? deviceId;
  final DateTime timestamp;
  final SecurityLevel level;
  final Map<String, dynamic> metadata;

  SecurityEvent({
    required this.id,
    required this.eventType,
    required this.description,
    this.userId,
    this.deviceId,
    required this.timestamp,
    required this.level,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'description': description,
      'userId': userId,
      'deviceId': deviceId,
      'timestamp': timestamp.toIso8601String(),
      'level': level.toString(),
      'metadata': metadata,
    };
  }
}

/// Security alert class
class SecurityAlert {
  final String id;
  final String alertType;
  final String description;
  final String? userId;
  final String? deviceId;
  final DateTime timestamp;
  final SecuritySeverity severity;
  final Map<String, dynamic> metadata;
  final AlertStatus status;

  SecurityAlert({
    required this.id,
    required this.alertType,
    required this.description,
    this.userId,
    this.deviceId,
    required this.timestamp,
    required this.severity,
    required this.metadata,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alertType': alertType,
      'description': description,
      'userId': userId,
      'deviceId': deviceId,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.toString(),
      'metadata': metadata,
      'status': status.toString(),
    };
  }
}

/// Security level enum
enum SecurityLevel {
  info,
  warning,
  error,
  critical,
}

/// Security severity enum
enum SecuritySeverity {
  low,
  medium,
  high,
  critical,
}

/// Alert status enum
enum AlertStatus {
  active,
  acknowledged,
  resolved,
  dismissed,
}
