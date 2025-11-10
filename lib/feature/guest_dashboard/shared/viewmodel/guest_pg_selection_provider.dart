// ============================================================================
// Guest PG Selection Provider - State Management for Guest PG Selection
// ============================================================================
// Manages the currently selected PG for guest users across all guest dashboard tabs
// Provides centralized state management for PG selection and booking requests
// ============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/repositories/notification_repository.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../../pgs/data/models/guest_pg_model.dart';

/// Provider for managing guest PG selection state
/// Handles PG selection, booking requests, and persistence
class GuestPgSelectionProvider extends ChangeNotifier {
  final _analyticsService = getIt.analytics;
  final _notificationRepository = NotificationRepository();
  final _localStorage = getIt.localStorage;
  final InternationalizationService _i18n = InternationalizationService.instance;
  
  // Storage keys for PG selection persistence
  static const String _storageKeyPgId = 'guest_selected_pg_id';
  static const String _storageKeyPgData = 'guest_selected_pg_data';

  GuestPgModel? _selectedPg;
  String? _selectedPgId;
  bool _isLoading = false;
  String? _error;

  /// Currently selected PG model
  GuestPgModel? get selectedPg => _selectedPg;

  /// Currently selected PG ID
  String? get selectedPgId => _selectedPgId;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error state
  String? get error => _error;

  /// Whether a PG is selected
  bool get hasSelectedPg => _selectedPg != null && _selectedPgId != null;

  /// Initializes the provider and loads saved PG selection
  Future<void> initialize() async {
    try {
      _setLoading(true);
      await _loadSavedPgSelection();
      _setLoading(false);

      final savedPgId = await _localStorage.read(_storageKeyPgId);
      final hasSelectedPg = savedPgId != null && savedPgId.isNotEmpty;

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgProviderInitializedEvent'),
        parameters: {
          'has_selected_pg': hasSelectedPg,
          'selected_pg_id': _selectedPgId ?? 'none',
        },
      );
    } catch (e) {
      _setError(_i18n.translate('failedToInitializeGuestPgSelection', parameters: {
        'error': e.toString(),
      }));
      _setLoading(false);
    }
  }

  /// Selects a PG for the guest
  /// This represents the PG the guest is currently staying at or has booked
  Future<void> selectPg(GuestPgModel pg) async {
    try {
      _setLoading(true);
      _clearError();

      _selectedPg = pg;
      _selectedPgId = pg.pgId;

      // Save to local storage
      await _savePgSelection();

      notifyListeners();

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectedEvent'),
        parameters: {
          'pg_id': pg.pgId,
          'pg_name': pg.pgName,
          'owner_uid': pg.ownerUid,
        },
      );

      _setLoading(false);
    } catch (e) {
      _setError(_i18n.translate('failedToSelectGuestPg', parameters: {
        'error': e.toString(),
      }));
      _setLoading(false);
    }
  }

  /// Clears the current PG selection
  Future<void> clearPgSelection() async {
    try {
      _selectedPg = null;
      _selectedPgId = null;

      // Clear from local storage
      await _clearSavedPgSelection();

      notifyListeners();

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgClearedEvent'),
        parameters: {},
      );
    } catch (e) {
      _setError(_i18n.translate('failedToClearGuestPgSelection', parameters: {
        'error': e.toString(),
      }));
    }
  }

  /// Sends a booking request to join a PG
  Future<void> sendBookingRequest(
    GuestPgModel pg, {
    required String guestName,
    required String guestPhone,
    required String guestEmail,
    String? message,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Create booking request document in Firestore
      final firestoreService = getIt.firestore;
      final requestId = 'request_${DateTime.now().millisecondsSinceEpoch}';

      // CRITICAL: Use Firebase Auth UID to match request.auth.uid in Firestore rules
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null || currentUser.uid.isEmpty) {
        throw Exception(_i18n.translate('bookingRequestUserNotAuthenticated'));
      }
      final guestId = currentUser.uid; // Use Firebase Auth UID

      final bookingRequestData = {
        'requestId': requestId,
        'guestId':
            guestId, // Use actual Firebase Auth UID (matches request.auth.uid)
        'guestName': guestName,
        'guestPhone': guestPhone,
        'guestEmail': guestEmail,
        'pgId': pg.pgId,
        'pgName': pg.pgName,
        'ownerId': pg.ownerUid, // Using ownerUid as ownerId
        'ownerUid': pg.ownerUid,
        'status': 'pending',
        'message': message,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'respondedAt': null,
        'responseMessage': null,
        'metadata': {
          'source': 'guest_app',
          'version': '1.0.0',
        },
      };

      // Save to both guest_booking_requests and owner_booking_requests collections
      await firestoreService.setDocument(
        'guest_booking_requests',
        requestId,
        bookingRequestData,
      );

      await firestoreService.setDocument(
        'owner_booking_requests',
        requestId,
        bookingRequestData,
      );

      // Notify owner about new booking request
      try {
        await _notificationRepository.sendUserNotification(
          userId: pg.ownerUid,
          type: 'booking_request',
          title: _i18n.translate('newBookingRequestTitle'),
          body: _i18n.translate('newBookingRequestBody', parameters: {
            'guestName': guestName,
            'pgName': pg.pgName,
          }),
          data: {
            'requestId': requestId,
            'pgId': pg.pgId,
            'pgName': pg.pgName,
            'guestId': guestId,
            'guestName': guestName,
            'guestPhone': guestPhone,
            'guestEmail': guestEmail,
          },
        );
      } catch (e) {
        // Log but don't fail the booking request if notification fails
        _analyticsService.logEvent(
          name: _i18n.translate('bookingRequestNotificationFailedEvent'),
          parameters: {
            'request_id': requestId,
            'error': e.toString(),
          },
        );
      }

      _analyticsService.logEvent(
        name: _i18n.translate('guestBookingRequestSentEvent'),
        parameters: {
          'pg_id': pg.pgId,
          'pg_name': pg.pgName,
          'owner_uid': pg.ownerUid,
          'guest_name': guestName,
          'guest_phone': guestPhone,
          'guest_email': guestEmail,
          'request_id': requestId,
        },
      );

      _setLoading(false);
    } catch (e) {
      _setError(_i18n.translate('failedToSendBookingRequest', parameters: {
        'error': e.toString(),
      }));
      _setLoading(false);
    }
  }

  /// Loads saved PG selection from local storage
  /// Restores the selected PG from persisted data on app startup
  Future<void> _loadSavedPgSelection() async {
    try {
      // Read saved PG data from local storage
      final savedPgData = await _localStorage.read(_storageKeyPgData);
      
      if (savedPgData == null || savedPgData.isEmpty) {
        // No saved PG selection found
        return;
      }

      // Deserialize JSON to Map
      final pgMap = jsonDecode(savedPgData) as Map<String, dynamic>;
      
      // Create GuestPgModel from saved data
      final savedPg = GuestPgModel.fromMap(pgMap);
      
      // Restore selection (without triggering save to avoid loops)
      _selectedPg = savedPg;
      _selectedPgId = savedPg.pgId;

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionRestoredEvent'),
        parameters: {
          'pg_id': savedPg.pgId,
          'pg_name': savedPg.pgName,
        },
      );
    } catch (e) {
      // If loading fails, clear corrupted data
      await _clearSavedPgSelection();
      
      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionRestoreFailedEvent'),
        parameters: {
          'error': e.toString(),
        },
      );
    }
  }

  /// Saves current PG selection to local storage
  /// Persists the selected PG data for restoration on app restart
  Future<void> _savePgSelection() async {
    try {
      if (_selectedPg == null) {
        // No PG selected, clear saved data
        await _clearSavedPgSelection();
        return;
      }

      // Serialize PG model to JSON
      final pgMap = _selectedPg!.toMap();
      final pgJson = jsonEncode(pgMap);

      // Save both ID and full data for redundancy
      await _localStorage.write(_storageKeyPgId, _selectedPgId!);
      await _localStorage.write(_storageKeyPgData, pgJson);

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionSavedEvent'),
        parameters: {
          'pg_id': _selectedPgId!,
          'pg_name': _selectedPg!.pgName,
        },
      );
    } catch (e) {
      // Log error but don't throw - persistence failure shouldn't break selection
      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionSaveFailedEvent'),
        parameters: {
          'error': e.toString(),
          'pg_id': _selectedPgId ?? 'none',
        },
      );
    }
  }

  /// Clears saved PG selection from local storage
  /// Removes persisted PG data when selection is cleared
  Future<void> _clearSavedPgSelection() async {
    try {
      await _localStorage.delete(_storageKeyPgId);
      await _localStorage.delete(_storageKeyPgData);

      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionClearedStorageEvent'),
        parameters: {},
      );
    } catch (e) {
      // Log error but don't throw - clearing failure is not critical
      _analyticsService.logEvent(
        name: _i18n.translate('guestPgSelectionClearFailedEvent'),
        parameters: {
          'error': e.toString(),
        },
      );
    }
  }

  /// Sets loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Sets error state
  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  /// Clears error state
  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
