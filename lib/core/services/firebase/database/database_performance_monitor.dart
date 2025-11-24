// lib/core/services/firebase/database/database_performance_monitor.dart

import 'package:flutter/foundation.dart';
import '../../../monitoring/production_monitoring.dart';
import 'firestore_cache_service.dart';

/// 🚀 **DATABASE PERFORMANCE MONITOR**
///
/// Monitors database query performance and cache statistics
/// Integrates with ProductionMonitoringService
class DatabasePerformanceMonitor {
  static final DatabasePerformanceMonitor _instance =
      DatabasePerformanceMonitor._internal();
  factory DatabasePerformanceMonitor() => _instance;
  DatabasePerformanceMonitor._internal();

  final ProductionMonitoring _monitoring = ProductionMonitoring();
  final FirestoreCacheService _cacheService = FirestoreCacheService();

  /// Log query performance metrics
  void logQueryPerformance({
    required String collection,
    required String operation,
    required Duration duration,
    bool fromCache = false,
    int? documentCount,
    Map<String, dynamic>? metadata,
  }) {
    _monitoring.log(
      'Database',
      'Query: $collection.$operation',
      LogLevel.info,
      metadata: {
        'collection': collection,
        'operation': operation,
        'duration_ms': duration.inMilliseconds,
        'duration_seconds': duration.inSeconds,
        'from_cache': fromCache,
        if (documentCount != null) 'document_count': documentCount,
        ...?metadata,
      },
    );

    // Track performance metric
    _monitoring.trackEvent('database_query', parameters: {
      'collection': collection,
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'from_cache': fromCache,
      if (documentCount != null) 'document_count': documentCount,
    });
  }

  /// Log cache statistics
  void logCacheStats() {
    final stats = _cacheService.getCacheStats();
    
    _monitoring.log(
      'DatabaseCache',
      'Cache Statistics',
      LogLevel.info,
      metadata: stats,
    );
    
    if (kDebugMode) {
      debugPrint('📊 Database Cache Stats:');
      debugPrint('  Cache Size: ${stats['memoryCacheSize']}/${stats['maxCacheSize']}');
      debugPrint('  Hit Rate: ${stats['hitRate']}%');
      debugPrint('  Cache Hits: ${stats['cacheHits']}');
      debugPrint('  Cache Misses: ${stats['cacheMisses']}');
      // Note: averageQueryDurationMs removed as it requires query timing
    }
  }

  /// Log batch operation performance
  void logBatchOperation({
    required String operation,
    required int operationCount,
    required Duration duration,
    Map<String, dynamic>? metadata,
  }) {
    _monitoring.log(
      'Database',
      'Batch Operation: $operation',
      LogLevel.info,
      metadata: {
        'operation': operation,
        'operation_count': operationCount,
        'duration_ms': duration.inMilliseconds,
        'duration_seconds': duration.inSeconds,
        'operations_per_second': (operationCount / duration.inSeconds).toStringAsFixed(2),
        ...?metadata,
      },
    );

    _monitoring.trackEvent('database_batch_operation', parameters: {
      'operation': operation,
      'operation_count': operationCount,
      'duration_ms': duration.inMilliseconds,
    });
  }

  /// Log index usage warning
  void logIndexWarning({
    required String collection,
    required String query,
    String? message,
  }) {
    _monitoring.logWarning(
      'Database',
      'Index Warning: $collection',
      metadata: {
        'collection': collection,
        'query': query,
        if (message != null) 'message': message,
      },
    );
  }

  /// Get comprehensive database performance metrics
  Map<String, dynamic> getPerformanceMetrics() {
    final cacheStats = _cacheService.getCacheStats();
    
    return {
      'cache': cacheStats,
      'monitoring_enabled': true,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}

