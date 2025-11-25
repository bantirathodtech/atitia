// lib/feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/di/common/unified_service_locator.dart';
import '../../../../common/utils/constants/firestore.dart';
import '../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../core/interfaces/analytics/analytics_service_interface.dart';

/// Provider for managing selected PG across owner dashboard
/// Loads PGs from Firebase and manages selection state
class SelectedPgProvider extends ChangeNotifier {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  String? _selectedPgId;
  String? _ownerId;
  List<Map<String, dynamic>> _pgs = [];
  bool _isLoading = false;
  String? _error;

  SelectedPgProvider({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  String? get selectedPgId => _selectedPgId;
  String? get ownerId => _ownerId;
  bool get hasPgs => _pgs.isNotEmpty;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Map<String, dynamic>> get pgs => List.unmodifiable(_pgs);
  Map<String, dynamic>? get selectedPg {
    if (_selectedPgId == null || _pgs.isEmpty) return null;
    try {
      return _pgs.firstWhere(
        (pg) => pg['pgId'] == _selectedPgId || pg['id'] == _selectedPgId,
      );
    } catch (e) {
      return null;
    }
  }

  /// Initialize for owner and load PGs from Firebase
  Future<void> initializeForOwner(String ownerId) async {
    if (_ownerId == ownerId && _pgs.isNotEmpty) {
      // Already initialized with this owner
      return;
    }

    _ownerId = ownerId;
    _error = null;
    await loadPgsFromFirebase();
  }

  /// Load PGs from Firebase for the current owner
  Future<void> loadPgsFromFirebase() async {
    if (_ownerId == null || _ownerId!.isEmpty) {
      _error = 'Owner ID not set';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Fetch PGs from Firestore using ownerUid filter
      // Try ownerUid first (standard field), fallback to ownerId if needed
      // COST OPTIMIZATION: Limit to 50 PGs per owner
      Stream<QuerySnapshot> stream;
      try {
        stream = _databaseService.getCollectionStreamWithFilter(
            FirestoreConstants.pgs, 'ownerUid', _ownerId!,
            limit: 50);
      } catch (e) {
        // Fallback: try ownerId field name
        stream = _databaseService.getCollectionStreamWithFilter(
            FirestoreConstants.pgs, 'ownerId', _ownerId!,
            limit: 50);
      }

      final snapshot = await stream.first;

      final List<Map<String, dynamic>> loadedPgs = [];
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Verify this PG belongs to the owner (double check)
        final docOwnerUid = data['ownerUid'] as String?;
        final docOwnerId = data['ownerId'] as String?;

        // Exclude drafts from selection dropdown
        final isDraft = (data['isDraft'] == true);
        if ((docOwnerUid == _ownerId || docOwnerId == _ownerId) && !isDraft) {
          loadedPgs.add({
            ...data,
            'id': doc.id, // Document ID
            'pgId': doc.id, // Also store as pgId for consistency
          });
        }
      }

      _pgs = loadedPgs;

      // Auto-select first PG if none selected and PGs exist
      if (_selectedPgId == null && _pgs.isNotEmpty) {
        _selectedPgId =
            _pgs.first['pgId'] as String? ?? _pgs.first['id'] as String?;
      }

      // If selected PG is no longer in list, clear selection
      if (_selectedPgId != null &&
          !_pgs.any((pg) =>
              (pg['pgId'] == _selectedPgId || pg['id'] == _selectedPgId))) {
        _selectedPgId = _pgs.isNotEmpty
            ? (_pgs.first['pgId'] as String? ?? _pgs.first['id'] as String?)
            : null;
      }

      await _analyticsService.logEvent(
        name: 'owner_pgs_loaded',
        parameters: {
          'owner_id': _ownerId!,
          'pgs_count': _pgs.length,
          'has_selection': _selectedPgId != null,
        },
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load PGs: $e';
      _isLoading = false;

      await _analyticsService.logEvent(
        name: 'owner_pgs_load_error',
        parameters: {
          'owner_id': _ownerId ?? 'unknown',
          'error': e.toString(),
        },
      );

      notifyListeners();
    }
  }

  /// Set selected PG
  void setSelectedPg(String pgId) {
    // Validate that the PG exists in our list
    if (_pgs.any((pg) => pg['pgId'] == pgId || pg['id'] == pgId)) {
      _selectedPgId = pgId;
      notifyListeners();
    }
  }

  /// Set PGs list (for testing or manual updates)
  void setPgs(List<Map<String, dynamic>> pgs) {
    _pgs = pgs;
    notifyListeners();
  }

  /// Refresh PGs from Firebase
  Future<void> refreshPgs() async {
    await loadPgsFromFirebase();
  }

  /// Get PG name by ID
  String? getPgName(String? pgId) {
    if (pgId == null) return null;
    try {
      final pg = _pgs.firstWhere(
        (p) => p['pgId'] == pgId || p['id'] == pgId,
      );
      return pg['pgName'] as String? ?? pg['name'] as String? ?? 'Unknown PG';
    } catch (e) {
      return null;
    }
  }
}
