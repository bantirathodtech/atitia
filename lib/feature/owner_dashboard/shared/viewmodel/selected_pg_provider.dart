// lib/feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart

import 'package:atitia/core/services/firebase/analytics/firebase_analytics_service.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/db/flutter_secure_storage.dart';
import '../../../../core/di/firebase/container/firebase_dependency_container.dart';
import '../../../guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../../mypg/data/repositories/owner_pg_management_repository.dart';

/// Manages the currently selected PG for multi-PG owners
///
/// Responsibilities:
/// - Load all PGs for the current owner
/// - Track which PG is currently selected
/// - Persist selection across app restarts
/// - Notify dependent tabs when PG changes
/// - Handle edge cases (no PGs, single PG, etc.)
class SelectedPgProvider extends ChangeNotifier {
  final OwnerPgManagementRepository _repository =
      getIt<OwnerPgManagementRepository>();
  final LocalStorageService _localStorage = getIt<LocalStorageService>();
  final AnalyticsServiceWrapper _analytics = getIt<AnalyticsServiceWrapper>();

  // State
  List<GuestPgModel> _ownerPgs = [];
  GuestPgModel? _selectedPg;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<GuestPgModel> get ownerPgs => _ownerPgs;
  GuestPgModel? get selectedPg => _selectedPg;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMultiplePgs => _ownerPgs.length > 1;
  bool get hasPgs => _ownerPgs.isNotEmpty;
  String? get selectedPgId => _selectedPg?.pgId;
  String? get selectedPgName => _selectedPg?.pgName;

  /// Initialize and load PGs for owner
  Future<void> initializeForOwner(String ownerId) async {
    if (ownerId.isEmpty) {
      debugPrint('⚠️ SelectedPgProvider: Cannot initialize with empty ownerId');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🏢 SelectedPgProvider: Loading PGs for owner $ownerId');

      // Load owner's PGs from repository
      final pgs = await _repository.fetchOwnerPGs(ownerId);

      // Convert dynamic list to List<GuestPgModel>
      _ownerPgs = pgs.map((pg) {
        if (pg is GuestPgModel) {
          return pg;
        } else if (pg is Map<String, dynamic>) {
          return GuestPgModel.fromMap(pg);
        } else {
          throw Exception('Invalid PG data type: ${pg.runtimeType}');
        }
      }).toList();

      debugPrint('✅ SelectedPgProvider: Loaded ${_ownerPgs.length} PGs');
      _analytics.logEvent(
        name: 'owner_pgs_loaded',
        parameters: {
          'owner_id': ownerId,
          'pgs_count': _ownerPgs.length,
        },
      );

      // Determine which PG to select
      await _autoSelectPg(ownerId);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ SelectedPgProvider: Error loading PGs: $e');
      _error = 'Failed to load PGs: $e';
      _isLoading = false;
      _analytics.logEvent(
        name: 'owner_pgs_load_error',
        parameters: {
          'owner_id': ownerId,
          'error': e.toString(),
        },
      );
      notifyListeners();
    }
  }

  /// Auto-select appropriate PG based on persistence and availability
  Future<void> _autoSelectPg(String ownerId) async {
    if (_ownerPgs.isEmpty) {
      _selectedPg = null;
      debugPrint('ℹ️ SelectedPgProvider: No PGs available, nothing to select');
      return;
    }

    // Try to restore last selected PG from storage
    final lastSelectedPgId =
        await _localStorage.read('selected_pg_id_$ownerId');

    if (lastSelectedPgId != null) {
      // Check if last selected PG still exists
      final lastPg = _ownerPgs.firstWhere(
        (pg) => pg.pgId == lastSelectedPgId,
        orElse: () => _ownerPgs.first,
      );
      _selectedPg = lastPg;
      debugPrint(
          '✅ SelectedPgProvider: Restored last selected PG: ${lastPg.pgName}');
    } else {
      // No previous selection, select first PG
      _selectedPg = _ownerPgs.first;
      debugPrint(
          '✅ SelectedPgProvider: Auto-selected first PG: ${_selectedPg!.pgName}');
    }

    _analytics.logEvent(
      name: 'owner_pg_selected',
      parameters: {
        'owner_id': ownerId,
        'pg_id': _selectedPg!.pgId,
        'pg_name': _selectedPg!.pgName,
        'auto_selected': lastSelectedPgId == null
            ? 'true'
            : 'false', // Convert boolean to string
      },
    );
  }

  /// Manually select a specific PG
  Future<void> selectPg(GuestPgModel pg, String ownerId) async {
    if (_selectedPg?.pgId == pg.pgId) {
      debugPrint('ℹ️ SelectedPgProvider: PG already selected, skipping');
      return;
    }

    _selectedPg = pg;

    // Persist selection
    await _localStorage.write('selected_pg_id_$ownerId', pg.pgId);

    debugPrint('✅ SelectedPgProvider: PG selected: ${pg.pgName}');
    _analytics.logEvent(
      name: 'owner_pg_switched',
      parameters: {
        'owner_id': ownerId,
        'pg_id': pg.pgId,
        'pg_name': pg.pgName,
      },
    );

    notifyListeners();
  }

  /// Refresh PGs list (call after creating/deleting a PG)
  Future<void> refreshPgs(String ownerId) async {
    debugPrint('🔄 SelectedPgProvider: Refreshing PGs list');
    await initializeForOwner(ownerId);
  }

  /// Add a newly created PG and auto-select it
  void addAndSelectPg(GuestPgModel newPg, String ownerId) {
    _ownerPgs.add(newPg);
    _selectedPg = newPg;

    // Persist selection
    _localStorage.write('selected_pg_id_$ownerId', newPg.pgId);

    debugPrint(
        '✅ SelectedPgProvider: New PG added and selected: ${newPg.pgName}');
    _analytics.logEvent(
      name: 'owner_pg_added_and_selected',
      parameters: {
        'owner_id': ownerId,
        'pg_id': newPg.pgId,
        'pg_name': newPg.pgName,
      },
    );

    notifyListeners();
  }

  /// Remove a deleted PG and auto-select another
  Future<void> removePg(String pgId, String ownerId) async {
    _ownerPgs.removeWhere((pg) => pg.pgId == pgId);

    // If deleted PG was selected, select another
    if (_selectedPg?.pgId == pgId) {
      if (_ownerPgs.isNotEmpty) {
        _selectedPg = _ownerPgs.first;
        await _localStorage.write('selected_pg_id_$ownerId', _selectedPg!.pgId);
        debugPrint(
            '✅ SelectedPgProvider: Deleted PG was selected, switched to: ${_selectedPg!.pgName}');
      } else {
        _selectedPg = null;
        await _localStorage.delete('selected_pg_id_$ownerId');
        debugPrint('ℹ️ SelectedPgProvider: No PGs remaining after deletion');
      }
    }

    _analytics.logEvent(
      name: 'owner_pg_removed',
      parameters: {
        'owner_id': ownerId,
        'pg_id': pgId,
        'remaining_pgs': _ownerPgs.length,
      },
    );

    notifyListeners();
  }

  /// Clear all state (call on logout)
  Future<void> clear(String ownerId) async {
    _ownerPgs = [];
    _selectedPg = null;
    _error = null;
    _isLoading = false;
    await _localStorage.delete('selected_pg_id_$ownerId');
    debugPrint('🧹 SelectedPgProvider: Cleared all state');
    notifyListeners();
  }
}
