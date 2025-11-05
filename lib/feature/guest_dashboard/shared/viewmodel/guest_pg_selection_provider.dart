// ============================================================================
// Guest PG Selection Provider - State Management for Guest PG Selection
// ============================================================================
// Manages the currently selected PG for guest users across all guest dashboard tabs
// Provides centralized state management for PG selection and booking requests
// ============================================================================

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/repositories/notification_repository.dart';
import '../../pgs/data/models/guest_pg_model.dart';

/// Provider for managing guest PG selection state
/// Handles PG selection, booking requests, and persistence
class GuestPgSelectionProvider extends ChangeNotifier {
  final _analyticsService = getIt.analytics;
  final _notificationRepository = NotificationRepository();

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

      _analyticsService.logEvent(
        name: 'guest_pg_provider_initialized',
        parameters: {
          'has_selected_pg': hasSelectedPg,
          'selected_pg_id': _selectedPgId ?? 'none',
        },
      );
    } catch (e) {
      _setError('Failed to initialize PG selection: $e');
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
        name: 'guest_pg_selected',
        parameters: {
          'pg_id': pg.pgId,
          'pg_name': pg.pgName,
          'owner_uid': pg.ownerUid,
        },
      );

      _setLoading(false);
    } catch (e) {
      _setError('Failed to select PG: $e');
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
        name: 'guest_pg_cleared',
        parameters: {},
      );
    } catch (e) {
      _setError('Failed to clear PG selection: $e');
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
        throw Exception(
            'User not authenticated. Please sign in to send booking requests.');
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
          title: 'New Booking Request',
          body: '$guestName requested to join ${pg.pgName}',
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
          name: 'booking_request_notification_failed',
          parameters: {
            'request_id': requestId,
            'error': e.toString(),
          },
        );
      }

      _analyticsService.logEvent(
        name: 'guest_booking_request_sent',
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
      _setError('Failed to send booking request: $e');
      _setLoading(false);
    }
  }

  /// Loads saved PG selection from local storage
  Future<void> _loadSavedPgSelection() async {
    // TODO: Implement local storage loading when LocalStorageService is available
    // For now, we'll skip this functionality
  }

  /// Saves current PG selection to local storage
  Future<void> _savePgSelection() async {
    // TODO: Implement local storage saving when LocalStorageService is available
    // For now, we'll skip this functionality
  }

  /// Clears saved PG selection from local storage
  Future<void> _clearSavedPgSelection() async {
    // TODO: Implement local storage clearing when LocalStorageService is available
    // For now, we'll skip this functionality
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
