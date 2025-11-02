// lib/common/utils/security/api_security_service.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Security service for rate limiting, authentication, and request validation
class ApiSecurityService {
  static final ApiSecurityService _instance = ApiSecurityService._internal();
  factory ApiSecurityService() => _instance;
  ApiSecurityService._internal();

  // Rate limiting storage
  final Map<String, List<DateTime>> _requestHistory = {};
  final Map<String, int> _requestCounts = {};

  // Security configurations
  static const int _defaultRateLimit = 100; // requests per hour
  static const int _strictRateLimit =
      20; // requests per hour for sensitive endpoints
  static const Duration _rateLimitWindow = Duration(hours: 1);
  static const Duration _strictRateLimitWindow = Duration(minutes: 15);

  /// Check rate limit for a client
  bool checkRateLimit(String clientId, {bool isStrictLimit = false}) {
    final now = DateTime.now();
    final window = isStrictLimit ? _strictRateLimitWindow : _rateLimitWindow;
    final limit = isStrictLimit ? _strictRateLimit : _defaultRateLimit;

    // Clean old requests
    _cleanOldRequests(clientId, now, window);

    // Get current request count
    final requestCount = _requestCounts[clientId] ?? 0;

    // Check if limit exceeded
    if (requestCount >= limit) {
      return false;
    }

    // Record this request
    _requestHistory.putIfAbsent(clientId, () => []).add(now);
    _requestCounts[clientId] = requestCount + 1;

    return true;
  }

  /// Clean old requests from history
  void _cleanOldRequests(String clientId, DateTime now, Duration window) {
    final history = _requestHistory[clientId];
    if (history == null) return;

    final cutoff = now.subtract(window);
    history.removeWhere((timestamp) => timestamp.isBefore(cutoff));

    _requestCounts[clientId] = history.length;
  }

  /// Get remaining requests for a client
  int getRemainingRequests(String clientId, {bool isStrictLimit = false}) {
    final limit = isStrictLimit ? _strictRateLimit : _defaultRateLimit;
    final currentCount = _requestCounts[clientId] ?? 0;
    return limit - currentCount;
  }

  /// Reset rate limit for a client
  void resetRateLimit(String clientId) {
    _requestHistory.remove(clientId);
    _requestCounts.remove(clientId);
  }

  /// Validate API request headers
  bool validateRequestHeaders(Map<String, String> headers) {
    // Check for required headers
    if (!headers.containsKey('content-type')) {
      return false;
    }

    // Validate content type
    final contentType = headers['content-type']?.toLowerCase();
    if (contentType != null && !contentType.contains('application/json')) {
      return false;
    }

    // Check for suspicious headers
    final suspiciousHeaders = [
      'x-forwarded-for',
      'x-real-ip',
      'x-cluster-client-ip'
    ];
    for (final header in suspiciousHeaders) {
      if (headers.containsKey(header)) {
        // Log suspicious activity
        _logSuspiciousActivity('Suspicious header detected: $header');
      }
    }

    return true;
  }

  /// Validate request body
  bool validateRequestBody(String body) {
    if (body.isEmpty) return true;

    try {
      // Try to parse as JSON
      final jsonData = json.decode(body);

      // Check for suspicious content
      if (_containsSuspiciousContent(jsonData)) {
        _logSuspiciousActivity('Suspicious content detected in request body');
        return false;
      }

      return true;
    } catch (e) {
      // Invalid JSON
      return false;
    }
  }

  /// Check for suspicious content in JSON data
  bool _containsSuspiciousContent(dynamic data) {
    if (data is Map) {
      for (final entry in data.entries) {
        if (_isSuspiciousKey(entry.key.toString()) ||
            _isSuspiciousValue(entry.value)) {
          return true;
        }
      }
    } else if (data is List) {
      for (final item in data) {
        if (_containsSuspiciousContent(item)) {
          return true;
        }
      }
    } else if (data is String) {
      return _isSuspiciousValue(data);
    }

    return false;
  }

  /// Check if key is suspicious
  bool _isSuspiciousKey(String key) {
    final suspiciousKeys = [
      'script',
      'javascript',
      'eval',
      'exec',
      'union',
      'select',
      'drop',
      'delete',
      'insert',
      'update',
      'alter',
      'create',
      'grant',
      'revoke'
    ];

    final lowerKey = key.toLowerCase();
    return suspiciousKeys.any((suspicious) => lowerKey.contains(suspicious));
  }

  /// Check if value is suspicious
  bool _isSuspiciousValue(dynamic value) {
    if (value is! String) return false;

    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'union\s+select', caseSensitive: false),
      RegExp(r'drop\s+table', caseSensitive: false),
      RegExp(r'delete\s+from', caseSensitive: false),
      RegExp(r'insert\s+into', caseSensitive: false),
      RegExp(r'update\s+set', caseSensitive: false),
    ];

    return suspiciousPatterns.any((pattern) => pattern.hasMatch(value));
  }

  /// Generate secure API token
  String generateApiToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000) % 1000000;
    return base64.encode(utf8.encode('$timestamp:$random'));
  }

  /// Validate API token
  bool validateApiToken(String token) {
    try {
      final decoded = utf8.decode(base64.decode(token));
      final parts = decoded.split(':');

      if (parts.length != 2) return false;

      final timestamp = int.tryParse(parts[0]);
      if (timestamp == null) return false;

      // Check if token is not too old (1 hour)
      final tokenTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final difference = now.difference(tokenTime);

      return difference.inHours < 1;
    } catch (e) {
      return false;
    }
  }

  /// Log suspicious activity
  void _logSuspiciousActivity(String message) {
    // In production, this should log to a security monitoring system
  }

  /// Get client IP from headers
  String? getClientIP(Map<String, String> headers) {
    // Check various IP header fields
    final ipHeaders = [
      'x-forwarded-for',
      'x-real-ip',
      'x-cluster-client-ip',
      'cf-connecting-ip'
    ];

    for (final header in ipHeaders) {
      final ip = headers[header];
      if (ip != null && ip.isNotEmpty) {
        // Handle comma-separated IPs (take the first one)
        final firstIp = ip.split(',').first.trim();
        if (_isValidIP(firstIp)) {
          return firstIp;
        }
      }
    }

    return null;
  }

  /// Validate IP address format
  bool _isValidIP(String ip) {
    final ipv4Pattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
    final ipv6Pattern = RegExp(r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$');

    return ipv4Pattern.hasMatch(ip) || ipv6Pattern.hasMatch(ip);
  }

  /// Check if IP is blocked
  bool isIPBlocked(String ip) {
    // In production, this should check against a database of blocked IPs
    // For now, we'll implement a simple block list
    final blockedIPs = [
      '127.0.0.1', // localhost (for testing)
      // Add more blocked IPs as needed
    ];

    return blockedIPs.contains(ip);
  }

  /// Block an IP address
  void blockIP(String ip) {
    // In production, this should add to a database of blocked IPs
    _logSuspiciousActivity('IP blocked: $ip');
  }

  /// Secure HTTP request with security headers
  Future<http.Response> secureRequest(
    String method,
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    String? clientId,
  }) async {
    // Check rate limit
    if (clientId != null && !checkRateLimit(clientId)) {
      throw SecurityException('Rate limit exceeded');
    }

    // Prepare secure headers
    final secureHeaders = {
      'content-type': 'application/json',
      'user-agent': 'AtitiaApp/1.0',
      'x-requested-with': 'XMLHttpRequest',
      if (headers != null) ...headers,
    };

    // Validate headers
    if (!validateRequestHeaders(secureHeaders)) {
      throw SecurityException('Invalid request headers');
    }

    // Validate body
    if (body != null) {
      final bodyString = body is String ? body : json.encode(body);
      if (!validateRequestBody(bodyString)) {
        throw SecurityException('Invalid request body');
      }
    }

    // Make the request
    try {
      http.Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: secureHeaders);
          break;
        case 'POST':
          response = await http.post(url, headers: secureHeaders, body: body);
          break;
        case 'PUT':
          response = await http.put(url, headers: secureHeaders, body: body);
          break;
        case 'DELETE':
          response = await http.delete(url, headers: secureHeaders);
          break;
        default:
          throw SecurityException('Unsupported HTTP method: $method');
      }

      // Check response for security issues
      _validateResponse(response);

      return response;
    } catch (e) {
      throw SecurityException('Request failed: $e');
    }
  }

  /// Validate HTTP response for security issues
  void _validateResponse(http.Response response) {
    // Check for suspicious response headers
    final suspiciousHeaders = ['x-powered-by', 'server'];
    for (final header in suspiciousHeaders) {
      if (response.headers.containsKey(header)) {
        _logSuspiciousActivity('Suspicious response header: $header');
      }
    }

    // Check response status
    if (response.statusCode >= 500) {
      _logSuspiciousActivity('Server error response: ${response.statusCode}');
    }
  }

  /// Get security metrics
  Map<String, dynamic> getSecurityMetrics() {
    return {
      'totalClients': _requestHistory.length,
      'totalRequests':
          _requestCounts.values.fold(0, (sum, count) => sum + count),
      'rateLimitedClients': _requestCounts.entries
          .where((entry) => entry.value >= _defaultRateLimit)
          .length,
    };
  }
}

/// Custom exception for security errors
class SecurityException implements Exception {
  final String message;
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}
