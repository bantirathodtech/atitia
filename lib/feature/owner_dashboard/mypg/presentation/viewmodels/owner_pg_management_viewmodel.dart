// lib/features/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart

import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../data/models/owner_pg_management_model.dart';
import '../../data/repositories/owner_pg_management_repository.dart';

/// ViewModel for PG management with real-time Firestore streams
/// Extends BaseProviderState for automatic service access and state management
/// Handles beds, rooms, floors, bookings, and revenue tracking with analytics
class OwnerPgManagementViewModel extends BaseProviderState {
  final OwnerPgManagementRepository _repository = OwnerPgManagementRepository();
  final _analyticsService = getIt.analytics;

  List<OwnerBed> _beds = [];
  List<OwnerRoom> _rooms = [];
  List<OwnerFloor> _floors = [];
  List<OwnerBooking> _bookings = [];
  OwnerRevenueReport? _revenueReport;
  OwnerOccupancyReport? _occupancyReport;
  Map<String, dynamic>? _pgDetails; // Full PG document from Firebase

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
  String get selectedFilter => _selectedFilter;

  /// Helper getters for PG details
  String get pgName => _pgDetails?['pgName'] ?? 'Unknown PG';
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
      setError(true, 'Failed to initialize PG management: $e');
    } finally {
      setLoading(false);
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
          notifyListeners();
        },
        onError: (error) {
          // Don't fail if bookings stream has permission issues
          _bookings = [];
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

      debugPrint(
          '✅ Parsed PG structure: ${_floors.length} floors, ${_rooms.length} rooms, ${_beds.length} beds');

      // Update occupancy report based on parsed beds
      _updateOccupancyReport();
    } catch (e) {
      // If parsing fails, keep empty lists
      debugPrint('⚠️ Failed to parse floor structure: $e');
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
      setError(true, 'Failed to approve booking: $e');
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
      setError(true, 'Failed to reject booking: $e');
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
      setError(true, 'Failed to reschedule booking: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update bed status
  Future<bool> updateBedStatus(String bedId, String status) async {
    if (_pgId == null) {
      setError(true, 'PG ID not initialized');
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
      setError(true, 'Failed to update bed status: $e');
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

  /// Get pending booking requests
  List<OwnerBooking> get pendingBookings {
    return _bookings.where((b) => b.isPending).toList();
  }

  /// Get approved bookings
  List<OwnerBooking> get approvedBookings {
    return _bookings.where((b) => b.isApproved).toList();
  }

  /// Get active bookings
  List<OwnerBooking> get activeBookings {
    return _bookings.where((b) => b.isActive).toList();
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
      setError(true, 'Failed to refresh data: $e');
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

      await _repository.createOrUpdatePG(pgModel);

      _analyticsService.logEvent(
        name: 'owner_pg_created',
        parameters: {
          'pg_id': pgModel.pgId,
          'pg_name': pgModel.pgName,
          'city': pgModel.city,
        },
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to save PG: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update basic PG details (partial updates)
  Future<bool> updatePGDetails(
      String pgId, Map<String, dynamic> updates) async {
    if (pgId.isEmpty) {
      setError(true, 'PG ID not provided');
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
      setError(true, 'Failed to update PG: $e');
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
      setError(true, 'Failed to delete PG: $e');
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
