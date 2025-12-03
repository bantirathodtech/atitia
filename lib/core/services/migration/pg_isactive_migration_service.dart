// lib/core/services/migration/pg_isactive_migration_service.dart

import '../../../core/di/common/unified_service_locator.dart';
import '../../../core/interfaces/database/database_service_interface.dart';
import '../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../common/utils/constants/firestore.dart';

/// Migration service to add missing `isActive` field to existing PG documents
/// This fixes PGs created before the isActive field was properly set
class PgIsActiveMigrationService {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  PgIsActiveMigrationService({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Migrates all PG documents to ensure they have the `isActive` field
  /// Sets `isActive: true` for non-draft PGs, `isActive: false` for drafts
  /// Returns migration summary
  Future<MigrationResult> migrateAllPGs() async {
    try {
      // Fetch all PGs from Firestore (no filters - get all documents)
      final snapshot = await _databaseService.queryCollection(
        FirestoreConstants.pgs,
        [], // Empty filters = get all
      );

      if (snapshot.docs.isEmpty) {
        await _analyticsService.logEvent(
          name: 'pg_migration_no_pgs',
          parameters: {},
        );
        return MigrationResult(
          totalPGs: 0,
          updatedPGs: 0,
          skippedPGs: 0,
          errors: [],
        );
      }

      int updatedCount = 0;
      int skippedCount = 0;
      final List<String> errors = [];

      for (final doc in snapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>;
          final pgId = doc.id;

          // Check if isActive field already exists
          if (data.containsKey('isActive')) {
            skippedCount++;
            continue;
          }

          // Determine isActive value based on isDraft
          final isDraft = data['isDraft'] as bool? ?? false;
          final isActive = !isDraft; // Active if not a draft

          // Update the document
          await _databaseService.updateDocument(
            FirestoreConstants.pgs,
            pgId,
            {
              'isActive': isActive,
              'updatedAt': DateTime.now(),
            },
          );

          updatedCount++;

          await _analyticsService.logEvent(
            name: 'pg_migration_updated',
            parameters: {
              'pg_id': pgId,
              'is_active': isActive,
              'was_draft': isDraft,
            },
          );
        } catch (e) {
          final errorMsg = 'Failed to migrate PG ${doc.id}: $e';
          errors.add(errorMsg);

          await _analyticsService.logEvent(
            name: 'pg_migration_error',
            parameters: {
              'pg_id': doc.id,
              'error': e.toString(),
            },
          );
        }
      }

      await _analyticsService.logEvent(
        name: 'pg_migration_complete',
        parameters: {
          'total_pgs': snapshot.docs.length,
          'updated': updatedCount,
          'skipped': skippedCount,
          'errors_count': errors.length,
        },
      );

      return MigrationResult(
        totalPGs: snapshot.docs.length,
        updatedPGs: updatedCount,
        skippedPGs: skippedCount,
        errors: errors,
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'pg_migration_failed',
        parameters: {'error': e.toString()},
      );
      throw Exception('Migration failed: $e');
    }
  }

  /// Migrates a specific PG by ID
  Future<bool> migratePG(String pgId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.pgs,
        pgId,
      );

      if (!doc.exists) {
        return false;
      }

      final data = doc.data() as Map<String, dynamic>;

      // Check if isActive already exists
      if (data.containsKey('isActive')) {
        return false; // Already migrated
      }

      // Determine isActive value
      final isDraft = data['isDraft'] as bool? ?? false;
      final isActive = !isDraft;

      // Update the document
      await _databaseService.updateDocument(
        FirestoreConstants.pgs,
        pgId,
        {
          'isActive': isActive,
          'updatedAt': DateTime.now(),
        },
      );

      await _analyticsService.logEvent(
        name: 'pg_migration_single_updated',
        parameters: {
          'pg_id': pgId,
          'is_active': isActive,
        },
      );

      return true;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'pg_migration_single_error',
        parameters: {
          'pg_id': pgId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to migrate PG $pgId: $e');
    }
  }
}

/// Result of migration operation
class MigrationResult {
  final int totalPGs;
  final int updatedPGs;
  final int skippedPGs;
  final List<String> errors;

  MigrationResult({
    required this.totalPGs,
    required this.updatedPGs,
    required this.skippedPGs,
    required this.errors,
  });

  bool get hasErrors => errors.isNotEmpty;
  bool get isSuccess => !hasErrors && updatedPGs > 0;

  @override
  String toString() {
    return 'MigrationResult(total: $totalPGs, updated: $updatedPGs, skipped: $skippedPGs, errors: ${errors.length})';
  }
}
