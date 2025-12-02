// lib/core/services/migration/migration_runner.dart

import 'package:flutter/foundation.dart';
import 'pg_isactive_migration_service.dart';

/// Runner to execute PG migrations
/// Can be called from debug menu or admin screen
class MigrationRunner {
  final PgIsActiveMigrationService _migrationService;

  MigrationRunner({
    PgIsActiveMigrationService? migrationService,
  }) : _migrationService = migrationService ?? PgIsActiveMigrationService();

  /// Runs the isActive migration for all PGs
  /// Returns migration result with details
  Future<MigrationResult> runIsActiveMigration() async {
    debugPrint('[MIGRATION] Starting PG isActive migration...');
    
    try {
      final result = await _migrationService.migrateAllPGs();
      
      debugPrint('[MIGRATION] Migration completed:');
      debugPrint('  Total PGs: ${result.totalPGs}');
      debugPrint('  Updated: ${result.updatedPGs}');
      debugPrint('  Skipped: ${result.skippedPGs}');
      debugPrint('  Errors: ${result.errors.length}');
      
      if (result.hasErrors) {
        debugPrint('[MIGRATION] Errors encountered:');
        for (final error in result.errors) {
          debugPrint('  - $error');
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('[MIGRATION] Migration failed: $e');
      rethrow;
    }
  }

  /// Migrates a specific PG by ID
  Future<bool> migrateSinglePG(String pgId) async {
    debugPrint('[MIGRATION] Migrating single PG: $pgId');
    
    try {
      final success = await _migrationService.migratePG(pgId);
      debugPrint('[MIGRATION] PG $pgId migration ${success ? "succeeded" : "skipped (already migrated)"}');
      return success;
    } catch (e) {
      debugPrint('[MIGRATION] Failed to migrate PG $pgId: $e');
      rethrow;
    }
  }
}

