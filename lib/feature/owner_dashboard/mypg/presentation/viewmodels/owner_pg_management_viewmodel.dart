// lib/features/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/services/booking/guest_info_service.dart';
import '../../data/models/owner_pg_management_model.dart';
import '../../data/repositories/owner_pg_management_repository.dart';
import '../../../../../../feature/owner_dashboard/myguest/data/models/owner_guest_model.dart';

/// ViewModel for PG management with real-time Firestore streams
/// Extends BaseProviderState for automatic service access and state management
/// Handles beds, rooms, floors, bookings, and revenue tracking with analytics
class OwnerPgManagementViewModel extends BaseProviderState {
  final OwnerPgManagementRepository _repository;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;
  final GuestInfoService _guestInfoService = GuestInfoService();

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  OwnerPgManagementViewModel({
    OwnerPgManagementRepository? repository,
  }) : _repository = repository ?? OwnerPgManagementRepository();

  List<OwnerBed> _beds = [];
  List<OwnerRoom> _rooms = [];
  List<OwnerFloor> _floors = [];
  List<OwnerBooking> _bookings = [];
  OwnerRevenueReport? _revenueReport;
  OwnerOccupancyReport? _occupancyReport;
  Map<String, dynamic>? _pgDetails; // Full PG document from Firebase
  Map<String, OwnerGuestModel> _guestsMap = {}; // Guest UID -> Guest Model map for bed map widget

  // Cached filtered lists to avoid expensive recalculations
  List<OwnerBooking>? _cachedPendingBookings;
  List<OwnerBooking>? _cachedApprovedBookings;
  List<OwnerBooking>? _cachedActiveBookings;
  List<OwnerBooking>? _cachedRejectedBookings;
  bool _bookingsChanged = false;

  StreamSubscription? _bedsSubscription;
  StreamSubscription? _roomsSubscription;
  StreamSubscription? _floorsSubscription;
  StreamSubscription? _bookingsSubscription;
  StreamSubscription? _pgDetailsSubscription;

  String? _pgId;
  String _selectedFilter = 'All'; // All, Occupied, Vacant, Pending

  /// Read-only data access for UI
  List<OwnerBed> get beds => _beds;
  List<OwnerRoom> get rooms => _rooms;
  List<OwnerFloor> get floors => _floors;
  List<OwnerBooking> get bookings => _bookings;
  OwnerRevenueReport? get revenueReport => _revenueReport;
  OwnerOccupancyReport? get occupancyReport => _occupancyReport;
  Map<String, dynamic>? get pgDetails => _pgDetails; // Expose PG details to UI
  Map<String, OwnerGuestModel> get guestsMap => _guestsMap; // Guest map for bed map widget
  String get selectedFilter => _selectedFilter;

  /// Helper getters for PG details
  String get pgName =>
      _pgDetails?['pgName'] ?? _text('ownerPgUnknownName', 'Unknown PG');
  String get pgAddress => _pgDetails?['address'] ?? '';
  String get pgCity => _pgDetails?['city'] ?? '';
  String get pgState => _pgDetails?['state'] ?? '';
  List<dynamic> get pgAmenities => _pgDetails?['amenities'] ?? [];
  List<dynamic> get pgPhotos => _pgDetails?['photos'] ?? [];
  String get pgContactNumber => _pgDetails?['contactNumber'] ?? '';
  String get pgType => _pgDetails?['pgType'] ?? '';
  List<dynamic> get floorStructure => _pgDetails?['floorStructure'] ?? [];

  /// Initialize ViewModel with data streams
  /// Loads selected PG's complete details and all related data from Firebase
  Future<void> initialize(String pgId) async {
    try {
      setLoading(true);
      clearError();

      // Stop previous streams if switching PG
      await _stopDataStreams();

      _pgId = pgId;

      // Load PG details first
      await _loadPGDetails(pgId);

      // Start all data streams
      _startDataStreams(pgId);

      // Load reports
      await loadRevenueReport(pgId);

      _analyticsService.logEvent(
        name: 'owner_pg_management_initialized',
        parameters: {
          'pg_id': pgId,
          'pg_name': pgName,
        },
      );
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgInitializeFailed',
          'Failed to initialize PG management: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  /// Fetch latest draft (isDraft==true) for an owner
  Future<Map<String, dynamic>?> fetchLatestDraftForOwner(String ownerId) async {
    try {
      return await _repository.fetchLatestDraftForOwner(ownerId);
    } catch (_) {
      return null;
    }
  }

  /// Load PG's complete details from Firebase
  Future<void> _loadPGDetails(String pgId) async {
    try {
      _pgDetails = await _repository.fetchPGDetails(pgId);
      notifyListeners();
    } catch (e) {
      // PG details failure shouldn't block main functionality
      _pgDetails = null;
    }
  }

  /// Start all real-time data streams for selected PG
  void _startDataStreams(String pgId) {
    // Stream PG details for real-time updates
    // This contains the complete floorStructure in the main document
    _pgDetailsSubscription = _repository.streamPGDetails(pgId).listen(
      (details) {
        _pgDetails = details;

        // Parse floorStructure from main PG document
        if (details != null) {
          _parseFloorStructureFromPG(details);
        }

        notifyListeners();
      },
      onError: (error) {
        // Don't set error for PG details, it's not critical
        _pgDetails = null;
      },
    );

    // Try to stream bookings (with permission handling)
    try {
      _bookingsSubscription = _repository.streamBookings(pgId).listen(
        (bookings) {
          _bookings = bookings;
          _cachedPendingBookings = null;
          _cachedApprovedBookings = null;
          _cachedActiveBookings = null;
          _cachedRejectedBookings = null;
          _bookingsChanged = true;
          notifyListeners();
        },
        onError: (error) {
          // Don't fail if bookings stream has permission issues
          _bookings = [];
          _cachedPendingBookings = null;
          _cachedApprovedBookings = null;
          _cachedActiveBookings = null;
          _cachedRejectedBookings = null;
          _bookingsChanged = true;
        },
      );
    } catch (e) {
      _bookings = [];
    }
  }

  /// Parse floor structure from PG document
  /// Converts floorStructure array into beds, rooms, floors lists
  void _parseFloorStructureFromPG(Map<String, dynamic> pgData) {
    try {
      final floorStructure = pgData['floorStructure'] as List<dynamic>? ?? [];

      // Clear existing data
      _beds = [];
      _rooms = [];
      _floors = [];

      // Parse each floor
      for (var floorData in floorStructure) {
        final floorNumber = floorData['floorNumber'] ?? 0;
        final floorName = floorData['floorName'] ?? 'Floor $floorNumber';
        final floorId = floorData['floorId'] ?? 'floor_$floorNumber';

        final rooms = floorData['rooms'] as List<dynamic>? ?? [];

        // Create OwnerFloor
        _floors.add(OwnerFloor(
          id: floorId,
          floorName: floorName,
          floorNumber: floorNumber,
          totalRooms: rooms.length,
        ));

        // Parse each room
        for (var roomData in rooms) {
          final roomNumber = roomData['roomNumber'] ?? '?';
          final sharingType = roomData['sharingType'] ?? '';
          final bedsCount = roomData['bedsCount'] ?? 0;
          final pricePerBed = (roomData['pricePerBed'] ?? 0).toDouble();
          final roomId = roomData['roomId'] ?? '${floorId}_$roomNumber';

          // Create OwnerRoom
          _rooms.add(OwnerRoom(
            id: roomId,
            floorId: floorId,
            roomNumber: roomNumber,
            capacity: bedsCount,
            roomType: sharingType,
            rentPerBed: pricePerBed,
          ));

          // Create beds for this room
          final roomBeds = roomData['beds'] as List<dynamic>? ?? [];
          for (var i = 0; i < roomBeds.length; i++) {
            final bedData = roomBeds[i];
            final bedNumber = bedData['bedNumber'] ?? (i + 1);
            final status = bedData['status'] ?? 'vacant';
            final guestUid = bedData['guestId'];
            final bedId = bedData['bedId'] ?? '${roomId}_bed_$bedNumber';

            // Create OwnerBed
            _beds.add(OwnerBed(
              id: bedId,
              bedNumber: bedNumber.toString(),
              roomId: roomId,
              floorId: floorId,
              status: status,
              guestUid: guestUid,
            ));
          }
        }
      }

      debugPrint('Parsed ${_beds.length} beds from floor plan');

      // Update occupancy report based on parsed beds
      _updateOccupancyReport();

      // Load guest details for occupied beds (async, won't block)
      _loadGuestDetailsForBeds();
    } catch (e) {
      // If parsing fails, keep empty lists
      _beds = [];
      _rooms = [];
      _floors = [];
    }
  }

  /// Stop all data streams
  Future<void> _stopDataStreams() async {
    await _bedsSubscription?.cancel();
    await _roomsSubscription?.cancel();
    await _floorsSubscription?.cancel();
    await _bookingsSubscription?.cancel();
    await _pgDetailsSubscription?.cancel();

    _bedsSubscription = null;
    _roomsSubscription = null;
    _floorsSubscription = null;
    _bookingsSubscription = null;
    _pgDetailsSubscription = null;
  }

  /// Load revenue report
  Future<void> loadRevenueReport(String pgId) async {
    try {
      _revenueReport = await _repository.getRevenueReport(pgId);
      notifyListeners();
    } catch (e) {
      // Revenue report failure shouldn't block main functionality
      _revenueReport = null;
    }
  }

  /// Update occupancy report
  Future<void> _updateOccupancyReport() async {
    try {
      _occupancyReport = await _repository.getOccupancyReport(_beds);
      notifyListeners();
    } catch (e) {
      _occupancyReport = null;
    }
  }

  /// Approve booking
  Future<bool> approveBooking(String bookingId) async {
    try {
      setLoading(true);
      clearError();
      await _repository.approveBooking(bookingId);

      _analyticsService.logEvent(
        name: 'owner_booking_approve_success',
        parameters: {'booking_id': bookingId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgApproveBookingFailed',
          'Failed to approve booking: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Reject booking
  Future<bool> rejectBooking(String bookingId) async {
    try {
      setLoading(true);
      clearError();
      await _repository.rejectBooking(bookingId);

      _analyticsService.logEvent(
        name: 'owner_booking_reject_success',
        parameters: {'booking_id': bookingId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgRejectBookingFailed',
          'Failed to reject booking: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Reschedule booking
  Future<bool> rescheduleBooking(
      String bookingId, DateTime newStartDate, DateTime newEndDate) async {
    try {
      setLoading(true);
      clearError();
      await _repository.rescheduleBooking(bookingId, newStartDate, newEndDate);

      _analyticsService.logEvent(
        name: 'owner_booking_reschedule_success',
        parameters: {'booking_id': bookingId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgRescheduleBookingFailed',
          'Failed to reschedule booking: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update bed status
  Future<bool> updateBedStatus(String bedId, String status) async {
    if (_pgId == null) {
      setError(
        true,
        _text('ownerPgIdNotInitialized', 'PG ID not initialized'),
      );
      return false;
    }

    try {
      setLoading(true);
      clearError();
      await _repository.updateBedStatus(_pgId!, bedId, status);

      _analyticsService.logEvent(
        name: 'owner_bed_status_update_success',
        parameters: {
          'bed_id': bedId,
          'status': status,
        },
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgUpdateBedStatusFailed',
          'Failed to update bed status: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Set filter for bed display
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_bed_filter_changed',
      parameters: {'filter': filter},
    );
  }

  /// Get filtered beds based on current filter
  List<OwnerBed> get filteredBeds {
    switch (_selectedFilter.toLowerCase()) {
      case 'occupied':
        return _beds.where((b) => b.isOccupied).toList();
      case 'vacant':
        return _beds.where((b) => b.isVacant).toList();
      case 'pending':
        return _beds.where((b) => b.isPending).toList();
      case 'maintenance':
        return _beds.where((b) => b.isUnderMaintenance).toList();
      default:
        return _beds;
    }
  }

  /// Get pending booking requests (cached)
  List<OwnerBooking> get pendingBookings {
    if (_cachedPendingBookings == null || _bookingsChanged) {
      _cachedPendingBookings = _bookings.where((b) => b.isPending).toList();
      _bookingsChanged = false;
    }
    return _cachedPendingBookings!;
  }

  /// Get approved bookings (cached)
  List<OwnerBooking> get approvedBookings {
    if (_cachedApprovedBookings == null || _bookingsChanged) {
      _cachedApprovedBookings = _bookings.where((b) => b.isApproved).toList();
      _bookingsChanged = false;
    }
    return _cachedApprovedBookings!;
  }

  /// Get active bookings (cached)
  List<OwnerBooking> get activeBookings {
    if (_cachedActiveBookings == null || _bookingsChanged) {
      _cachedActiveBookings = _bookings.where((b) => b.isActive).toList();
      _bookingsChanged = false;
    }
    return _cachedActiveBookings!;
  }

  /// Get rejected bookings (cached)
  List<OwnerBooking> get rejectedBookings {
    if (_cachedRejectedBookings == null || _bookingsChanged) {
      _cachedRejectedBookings = _bookings.where((b) => b.isRejected).toList();
      _bookingsChanged = false;
    }
    return _cachedRejectedBookings!;
  }

  /// Get upcoming vacating bookings (within 7 days)
  List<OwnerBooking> get upcomingVacating {
    final now = DateTime.now();
    final sevenDaysLater = now.add(const Duration(days: 7));
    return _bookings
        .where(
            (b) => b.endDate.isAfter(now) && b.endDate.isBefore(sevenDaysLater))
        .toList();
  }

  /// Get beds by room
  List<OwnerBed> getBedsForRoom(String roomId) {
    return _beds.where((b) => b.roomId == roomId).toList();
  }

  /// Get rooms by floor
  List<OwnerRoom> getRoomsForFloor(String floorId) {
    return _rooms.where((r) => r.floorId == floorId).toList();
  }

  /// Load guest details for all beds that have guestUid
  Future<void> _loadGuestDetailsForBeds() async {
    try {
      // Extract unique guest UIDs from beds
      final guestUids = _beds
          .where((bed) => bed.guestUid != null && bed.guestUid!.isNotEmpty)
          .map((bed) => bed.guestUid!)
          .toSet()
          .toList();

      if (guestUids.isEmpty) {
        _guestsMap = {};
        notifyListeners();
        return;
      }

      // Fetch guest details using GuestInfoService
      _guestsMap = await _guestInfoService.getGuestsByUids(guestUids);
      notifyListeners();

      debugPrint('Loaded ${_guestsMap.length} guest details for bed map');
    } catch (e) {
      debugPrint('Error loading guest details: $e');
      // Don't throw error, just log it - bed map can work without guest details
      _guestsMap = {};
    }
  }

  /// Refresh all data
  Future<void> refreshData() async {
    if (_pgId == null) return;

    try {
      setLoading(true);
      clearError();
      await _stopDataStreams();
      _startDataStreams(_pgId!);
      await loadRevenueReport(_pgId!);

      _analyticsService.logEvent(
        name: 'owner_pg_data_refreshed',
        parameters: {'pg_id': _pgId ?? 'unknown'},
      );
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgRefreshFailed',
          'Failed to refresh data: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  /// Check if any data is available
  bool get hasData =>
      _beds.isNotEmpty || _rooms.isNotEmpty || _floors.isNotEmpty;

  /// Get total beds count
  int get totalBeds => _beds.length;

  /// Get occupied beds count
  int get occupiedBeds => _beds.where((b) => b.isOccupied).length;

  /// Get vacant beds count
  int get vacantBeds => _beds.where((b) => b.isVacant).length;

  /// Creates or updates a PG property
  /// This makes the PG visible to guests in the browse/search section
  Future<bool> createOrUpdatePG(dynamic pgModel) async {
    try {
      setLoading(true);
      clearError();

      // If pgModel is a Map (create flow), call createPG; if it's a model with pgId, upsert
      if (pgModel is Map<String, dynamic>) {
        final String newPgId = await _repository.createPG(pgModel);
        _pgId = newPgId;
      } else {
        await _repository.createOrUpdatePG(pgModel);
        _pgId = pgModel.pgId;
      }

      _analyticsService.logEvent(
        name: 'owner_pg_created',
        parameters: {'pg_id': _pgId ?? 'unknown'},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgSaveFailed',
          'Failed to save PG: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update basic PG details (partial updates)
  Future<bool> updatePGDetails(
      String pgId, Map<String, dynamic> updates) async {
    if (pgId.isEmpty) {
      setError(
        true,
        _text('ownerPgIdNotProvided', 'PG ID not provided'),
      );
      return false;
    }

    try {
      setLoading(true);
      clearError();

      await _repository.updatePGDetails(pgId, updates);

      _analyticsService.logEvent(
        name: 'owner_pg_details_update_success',
        parameters: {
          'pg_id': pgId,
          'updated_fields': updates.keys.join(','),
        },
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgUpdateFailed',
          'Failed to update PG: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes a PG property
  Future<bool> deletePG(String pgId) async {
    try {
      setLoading(true);
      clearError();

      await _repository.deletePG(pgId);

      _analyticsService.logEvent(
        name: 'owner_pg_deleted',
        parameters: {'pg_id': pgId},
      );

      return true;
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPgDeleteFailed',
          'Failed to delete PG: {error}',
          parameters: {'error': e.toString()},
        ),
      );
      return false;
    } finally {
      setLoading(false);
    }
  }

  @override
  void dispose() {
    _stopDataStreams();
    super.dispose();
  }
}
