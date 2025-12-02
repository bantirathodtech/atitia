# PG isActive Migration Service

## Overview

This migration service fixes existing PG documents in Firestore that are missing the `isActive` field. The guest query filters on `isActive == true`, so PGs without this field won't appear in the guest dashboard.

## Problem

- Guest query requires: `isDraft == false` AND `isActive == true`
- Some existing PGs were created without the `isActive` field
- These PGs won't appear in guest listings until migrated

## Solution

The migration service:
1. Fetches all PG documents from Firestore
2. Checks if `isActive` field exists
3. Sets `isActive: true` for non-draft PGs
4. Sets `isActive: false` for draft PGs
5. Skips PGs that already have `isActive` field

## Usage

### Option 1: Run from Code

```dart
import 'package:atitia/core/services/migration/run_pg_migration.dart';

// Run migration for all PGs
final result = await runPgIsActiveMigration();

print('Migration completed:');
print('  Total PGs: ${result.totalPGs}');
print('  Updated: ${result.updatedPGs}');
print('  Skipped: ${result.skippedPGs}');
print('  Errors: ${result.errors.length}');
```

### Option 2: Run Single PG

```dart
import 'package:atitia/core/services/migration/run_pg_migration.dart';

// Migrate a specific PG
final success = await migrateSinglePG('pg_id_here');
if (success) {
  print('PG migrated successfully');
} else {
  print('PG already has isActive field or not found');
}
```

### Option 3: Add to Debug Menu

You can add a button to your debug/admin screen:

```dart
import 'package:atitia/core/services/migration/run_pg_migration.dart';

ElevatedButton(
  onPressed: () async {
    try {
      final result = await runPgIsActiveMigration();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Migration complete: ${result.updatedPGs} PGs updated',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Migration failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  },
  child: Text('Run PG Migration'),
)
```

## Root Cause Fix

The root cause has been fixed in:
- `lib/feature/owner_dashboard/mypg/presentation/screens/new_pg_setup_screen.dart`
  - Line 1545: Added `'isActive': true` when creating new PGs
  - Line 1324: Added `'isActive': true` when publishing drafts

All new PGs created after this fix will automatically have `isActive: true`.

## Migration Result

The `MigrationResult` class provides:
- `totalPGs`: Total number of PGs found
- `updatedPGs`: Number of PGs that were updated
- `skippedPGs`: Number of PGs that already had `isActive` field
- `errors`: List of error messages (if any)
- `hasErrors`: Boolean indicating if errors occurred
- `isSuccess`: Boolean indicating successful migration

## Safety

- **Idempotent**: Safe to run multiple times
- **Non-destructive**: Only adds missing field, doesn't modify existing values
- **Error handling**: Continues processing even if individual PGs fail
- **Analytics**: Logs all migration events for tracking

## When to Run

Run this migration:
1. **Once** after deploying the fix to update existing PGs
2. **Anytime** if you suspect PGs are missing the `isActive` field
3. **After** importing data from another source

## Notes

- The migration is safe to run multiple times
- PGs that already have `isActive` will be skipped
- Draft PGs (`isDraft: true`) will get `isActive: false`
- Published PGs (`isDraft: false`) will get `isActive: true`

