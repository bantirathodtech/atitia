// lib/core/services/migration/run_pg_migration.dart
//
// Standalone helpers to run PG isActive migration from app code
// or from a debug/admin screen. See README in this directory for
// detailed usage examples.
//
// Pre-commit hook will auto-format this file before commit.

library;

import 'migration_runner.dart';
import 'pg_isactive_migration_service.dart';

/// Runs the PG isActive migration
/// Returns migration result with details
Future<MigrationResult> runPgIsActiveMigration() async {
  final runner = MigrationRunner();
  return await runner.runIsActiveMigration();
}

/// Migrates a specific PG by ID
Future<bool> migrateSinglePG(String pgId) async {
  final runner = MigrationRunner();
  return await runner.migrateSinglePG(pgId);
}
