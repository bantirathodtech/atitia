// lib/features/owner_dashboard/myguest/viewmodel/owner_guest_viewmodel.dart

import 'dart:async';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/repositories/bed_change_request_repository.dart';
import '../data/models/owner_guest_model.dart';
import '../data/repository/owner_guest_repository.dart';
import '../data/repository/owner_booking_request_repository.dart';

/// ViewModel for managing owner's guests, bookings, and payments
/// Extends BaseProviderState for automatic service access and state management
/// Handles real-time data streaming and business logic with analytics tracking
class OwnerGuestViewModel extends BaseProviderState {
  final OwnerGuestRepository _repository = OwnerGuestRepository();
  final _analyticsService = getIt.analytics;

  List<String> _pgIds = [];
  List<OwnerGuestModel> _guests = [];
  List<OwnerBookingModel> _bookings = [];
  List<OwnerPaymentModel> _payments = [];
  OwnerGuestModel? _selectedGuest;
  OwnerBookingModel? _selectedBooking;
  String _selectedFilter = 'All'; // All, Active, Pending, Inactive
  String _searchQuery = '';
  Timer? _searchDebounceTimer;
  bool _selectionMode = false;
  final Set<String> _selectedGuestIds = {};
  Map<String, dynamic> _guestStats = {};

  StreamSubscription? _guestSubscription;
  StreamSubscription? _bookingSubscription;
  StreamSubscription? _paymentSubscription;

  /// Read-only access to guests list for UI consumption
  List<OwnerGuestModel> get guests => _guests;

  /// Read-only access to bookings list for UI consumption
  List<OwnerBookingModel> get bookings => _bookings;

  /// Read-only access to payments list for UI consumption
  List<OwnerPaymentModel> get payments => _payments;

  /// Get list of PG IDs that owner manages
  List<String> get pgIds => _pgIds;

  /// Currently selected guest
  OwnerGuestModel? get selectedGuest => _selectedGuest;

  /// Currently selected booking
  OwnerBookingModel? get selectedBooking => _selectedBooking;

  /// Current filter selection
  String get selectedFilter => _selectedFilter;

  /// Current search query
  String get searchQuery => _searchQuery;

  /// Bulk selection mode
  bool get selectionMode => _selectionMode;

  /// Selected guest IDs for bulk actions
  Set<String> get selectedGuestIds => _selectedGuestIds;

  /// Number of selected guests
  int get selectedCount => _selectedGuestIds.length;

  /// Guest statistics
  Map<String, dynamic> get guestStats => _guestStats;

  /// Initializes ViewModel by loading PG IDs and starting data streams
  Future<void> initialize(List<String> pgIds) async {
    try {
      setLoading(true);
      clearError();
      _pgIds = pgIds;
      await _startDataStreams();

      _analyticsService.logEvent(
        name: 'owner_guest_management_initialized',
        parameters: {'pg_count': pgIds.length},
      );
    } catch (e) {
      setError(true, 'Failed to initialize guest management: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Starts all real-time data streams for guests, bookings, and payments
  Future<void> _startDataStreams() async {
    await _stopDataStreams();

    try {
      // Start guest stream
      _guestSubscription = _repository.streamGuests().listen(
        (guests) {
          _guests = guests;
          _loadGuestStats();
          notifyListeners();
        },
        onError: (error) {
          setError(true, 'Failed to stream guests: $error');
        },
      );

      // Start bookings stream for all PGs
      if (_pgIds.isNotEmpty) {
        _bookingSubscription =
            _repository.streamBookingsForMultiplePGs(_pgIds).listen(
          (bookings) {
            _bookings = bookings;
            notifyListeners();
          },
          onError: (error) {
            setError(true, 'Failed to stream bookings: $error');
          },
        );

        // Start payments stream for all PGs
        _paymentSubscription =
            _repository.streamPaymentsForMultiplePGs(_pgIds).listen(
          (payments) {
            _payments = payments;
            notifyListeners();
          },
          onError: (error) {
            setError(true, 'Failed to stream payments: $error');
          },
        );
      }
    } catch (e) {
      setError(true, 'Failed to start data streams: $e');
      rethrow;
    }
  }

  /// Stops all active data streams
  Future<void> _stopDataStreams() async {
    await _guestSubscription?.cancel();
    await _bookingSubscription?.cancel();
    await _paymentSubscription?.cancel();

    _guestSubscription = null;
    _bookingSubscription = null;
    _paymentSubscription = null;
  }

  /// Loads guest statistics
  Future<void> _loadGuestStats() async {
    final activeGuests =
        _guests.where((g) => g.status.toLowerCase() == 'active').length;
    final pendingGuests =
        _guests.where((g) => g.status.toLowerCase() == 'pending').length;

    _guestStats = {
      'totalGuests': _guests.length,
      'activeGuests': activeGuests,
      'pendingGuests': pendingGuests,
      'inactiveGuests': _guests.length - activeGuests - pendingGuests,
      'totalBookings': _bookings.length,
      'activeBookings': activeBookings.length,
      'pendingPayments': pendingPayments.length,
      'totalRevenue': _calculateTotalRevenue(),
    };
  }

  /// Calculates total revenue from collected payments
  double _calculateTotalRevenue() {
    return _payments
        .where((p) => p.isCollected)
        .fold(0.0, (sum, payment) => sum + payment.amountPaid);
  }

  /// Sets the selected filter
  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_guest_filter_changed',
      parameters: {'filter': filter},
    );
  }

  /// Gets filtered and searched guests based on current filter and search query
  List<OwnerGuestModel> get filteredGuests {
    // First apply status filter
    List<OwnerGuestModel> filtered;
    switch (_selectedFilter.toLowerCase()) {
      case 'active':
        filtered = _guests.where((g) => g.isActive).toList();
        break;
      case 'pending':
        filtered = _guests.where((g) => g.isPending).toList();
        break;
      case 'inactive':
        filtered = _guests.where((g) => !g.isActive && !g.isPending).toList();
        break;
      default:
        filtered = _guests;
    }

    // Then apply search query if exists
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((guest) {
        final name = guest.fullName.toLowerCase();
        final phone = guest.phoneNumber.toLowerCase();
        return name.contains(query) || phone.contains(query);
      }).toList();
    }

    return filtered;
  }

  /// Sets search query with debouncing to avoid excessive filtering
  void setSearchQuery(String query) {
    _searchDebounceTimer?.cancel();
    
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _searchQuery = query;
      notifyListeners();

      _analyticsService.logEvent(
        name: 'owner_guest_search',
        parameters: {
          'query_length': query.length,
          'results_count': filteredGuests.length,
        },
      );
    });
  }

  /// Clears search query
  void clearSearch() {
    _searchQuery = '';
    _searchDebounceTimer?.cancel();
    notifyListeners();
  }

  /// Toggle selection mode for bulk actions
  void toggleSelectionMode() {
    _selectionMode = !_selectionMode;
    if (!_selectionMode) {
      _selectedGuestIds.clear();
    }
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_guest_selection_mode_toggled',
      parameters: {'enabled': _selectionMode ? 'true' : 'false'},
    );
  }

  /// Toggle guest selection in bulk mode
  void toggleGuestSelection(String guestUid) {
    if (_selectedGuestIds.contains(guestUid)) {
      _selectedGuestIds.remove(guestUid);
    } else {
      _selectedGuestIds.add(guestUid);
    }
    notifyListeners();
  }

  /// Select all filtered guests
  void selectAllFilteredGuests() {
    _selectedGuestIds.addAll(filteredGuests.map((g) => g.uid));
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_guests_select_all',
      parameters: {'count': _selectedGuestIds.length},
    );
  }

  /// Deselect all guests
  void deselectAllGuests() {
    _selectedGuestIds.clear();
    notifyListeners();
  }

  /// Check if a guest is selected
  bool isGuestSelected(String guestUid) {
    return _selectedGuestIds.contains(guestUid);
  }

  /// Bulk delete selected guests
  Future<bool> bulkDeleteGuests() async {
    if (_selectedGuestIds.isEmpty) return false;

    try {
      setLoading(true);
      clearError();

      final deleteCount = _selectedGuestIds.length;
      
      // Delete each selected guest from repository
      for (final guestUid in _selectedGuestIds) {
        await _repository.deleteGuest(guestUid);
      }

      _analyticsService.logEvent(
        name: 'owner_guests_bulk_deleted',
        parameters: {'count': deleteCount},
      );

      _selectedGuestIds.clear();
      _selectionMode = false;
      return true;
    } catch (e) {
      setError(true, 'Failed to bulk delete guests: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Bulk update guest status
  Future<bool> bulkUpdateGuestStatus(String newStatus) async {
    if (_selectedGuestIds.isEmpty) return false;

    try {
      setLoading(true);
      clearError();

      final updateCount = _selectedGuestIds.length;
      
      // Update status for each selected guest
      for (final guestUid in _selectedGuestIds) {
        final guest = _guests.firstWhere((g) => g.uid == guestUid);
        final updatedGuest = guest.copyWith(status: newStatus);
        await _repository.updateGuest(updatedGuest);
      }

      _analyticsService.logEvent(
        name: 'owner_guests_bulk_status_updated',
        parameters: {
          'count': updateCount,
          'new_status': newStatus,
        },
      );

      _selectedGuestIds.clear();
      _selectionMode = false;
      return true;
    } catch (e) {
      setError(true, 'Failed to bulk update guest status: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Sets selected guest
  void setSelectedGuest(OwnerGuestModel guest) {
    _selectedGuest = guest;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_guest_selected',
      parameters: {
        'guest_uid': guest.uid,
        'guest_name': guest.fullName,
      },
    );
  }

  /// Sets selected booking
  void setSelectedBooking(OwnerBookingModel booking) {
    _selectedBooking = booking;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_booking_selected',
      parameters: {
        'booking_id': booking.id,
        'guest_uid': booking.guestUid,
      },
    );
  }

  /// Clears selected guest
  void clearSelectedGuest() {
    _selectedGuest = null;
    notifyListeners();
  }

  /// Clears selected booking
  void clearSelectedBooking() {
    _selectedBooking = null;
    notifyListeners();
  }

  /// Creates a new booking
  Future<bool> createBooking(OwnerBookingModel booking) async {
    try {
      setLoading(true);
      clearError();
      await _repository.createBooking(booking);

      _analyticsService.logEvent(
        name: 'owner_booking_create_success',
        parameters: {'booking_id': booking.id},
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to create booking: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Updates an existing booking
  Future<bool> updateBooking(OwnerBookingModel booking) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateBooking(booking);

      _analyticsService.logEvent(
        name: 'owner_booking_update_success',
        parameters: {'booking_id': booking.id},
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to update booking: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Deletes a booking
  Future<bool> deleteBooking(String bookingId) async {
    try {
      setLoading(true);
      clearError();
      await _repository.deleteBooking(bookingId);

      _analyticsService.logEvent(
        name: 'owner_booking_delete_success',
        parameters: {'booking_id': bookingId},
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to delete booking: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Creates a new payment record
  Future<bool> createPayment(OwnerPaymentModel payment) async {
    try {
      setLoading(true);
      clearError();
      await _repository.createPayment(payment);

      _analyticsService.logEvent(
        name: 'owner_payment_create_success',
        parameters: {'payment_id': payment.id},
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to create payment: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Updates an existing payment
  Future<bool> updatePayment(OwnerPaymentModel payment) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updatePayment(payment);

      _analyticsService.logEvent(
        name: 'owner_payment_update_success',
        parameters: {'payment_id': payment.id},
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to update payment: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Calculates total payments collected for a specific booking
  double totalPaidForBooking(String bookingId) {
    return _payments
        .where(
            (payment) => payment.bookingId == bookingId && payment.isCollected)
        .fold(0.0, (sum, payment) => sum + payment.amountPaid);
  }

  /// Gets all bookings for a specific guest
  List<OwnerBookingModel> getBookingsForGuest(String guestUid) {
    return _bookings.where((booking) => booking.guestUid == guestUid).toList();
  }

  /// Gets all active bookings (current date within booking period)
  List<OwnerBookingModel> get activeBookings {
    return _bookings.where((booking) => booking.isActive).toList();
  }

  /// Gets all pending bookings
  List<OwnerBookingModel> get pendingBookings {
    return _bookings.where((booking) => booking.isPending).toList();
  }

  /// Gets all approved bookings
  List<OwnerBookingModel> get approvedBookings {
    return _bookings.where((booking) => booking.isApproved).toList();
  }

  /// Gets all pending payments across all bookings
  List<OwnerPaymentModel> get pendingPayments {
    return _payments.where((payment) => payment.isPending).toList();
  }

  /// Gets all collected payments
  List<OwnerPaymentModel> get collectedPayments {
    return _payments.where((payment) => payment.isCollected).toList();
  }

  /// Gets payments for a specific booking
  List<OwnerPaymentModel> getPaymentsForBooking(String bookingId) {
    return _payments.where((p) => p.bookingId == bookingId).toList();
  }

  /// Refreshes all data by restarting streams
  Future<void> refreshData() async {
    try {
      setLoading(true);
      clearError();
      await _stopDataStreams();
      await _startDataStreams();

      _analyticsService.logEvent(
        name: 'owner_guest_data_refreshed',
        parameters: {},
      );
    } catch (e) {
      setError(true, 'Failed to refresh data: $e');
    } finally {
      setLoading(false);
    }
  }

  /// Gets guest by ID
  Future<OwnerGuestModel?> getGuestById(String guestUid) async {
    try {
      return await _repository.getGuestById(guestUid);
    } catch (e) {
      setError(true, 'Failed to fetch guest: $e');
      return null;
    }
  }

  /// Gets booking by ID
  Future<OwnerBookingModel?> getBookingById(String bookingId) async {
    try {
      return await _repository.getBookingById(bookingId);
    } catch (e) {
      setError(true, 'Failed to fetch booking: $e');
      return null;
    }
  }

  /// Checks if any guests are available
  bool get hasGuests => _guests.isNotEmpty;

  /// Checks if any bookings are available
  bool get hasBookings => _bookings.isNotEmpty;

  /// Checks if any payments are available
  bool get hasPayments => _payments.isNotEmpty;

  /// Gets total guests count
  int get totalGuests => _guests.length;

  /// Gets total bookings count
  int get totalBookings => _bookings.length;

  /// Gets total payments count
  int get totalPayments => _payments.length;

  /// Approves a bed change request
  Future<bool> approveBedChangeRequest(
    String requestId, {
    String? decisionNotes,
  }) async {
    try {
      final repository = BedChangeRequestRepository();
      await repository.updateStatus(
        requestId,
        'approved',
        decisionNotes: decisionNotes,
        guestId: '', // Will be extracted from request
      );
      _analyticsService.logEvent(
        name: 'bed_change_request_approved',
        parameters: {'request_id': requestId},
      );
      return true;
    } catch (e) {
      setError(true, 'Failed to approve bed change request: $e');
      return false;
    }
  }

  /// Rejects a bed change request
  Future<bool> rejectBedChangeRequest(
    String requestId, {
    String? decisionNotes,
  }) async {
    try {
      final repository = BedChangeRequestRepository();
      await repository.updateStatus(
        requestId,
        'rejected',
        decisionNotes: decisionNotes,
        guestId: '', // Will be extracted from request
      );
      _analyticsService.logEvent(
        name: 'bed_change_request_rejected',
        parameters: {'request_id': requestId},
      );
      return true;
    } catch (e) {
      setError(true, 'Failed to reject bed change request: $e');
      return false;
    }
  }

  /// Approves a booking request
  Future<bool> approveBookingRequest(
    String requestId, {
    String? responseMessage,
    String? roomNumber,
    String? bedNumber,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final repository = OwnerBookingRequestRepository();
      await repository.approveBookingRequest(
        requestId,
        responseMessage: responseMessage,
        roomNumber: roomNumber,
        bedNumber: bedNumber,
        startDate: startDate,
        endDate: endDate,
      );
      _analyticsService.logEvent(
        name: 'booking_request_approved',
        parameters: {'request_id': requestId},
      );
      return true;
    } catch (e) {
      setError(true, 'Failed to approve booking request: $e');
      return false;
    }
  }

  /// Rejects a booking request
  Future<bool> rejectBookingRequest(
    String requestId, {
    String? responseMessage,
  }) async {
    try {
      final repository = OwnerBookingRequestRepository();
      await repository.rejectBookingRequest(
        requestId,
        responseMessage: responseMessage,
      );
      _analyticsService.logEvent(
        name: 'booking_request_rejected',
        parameters: {'request_id': requestId},
      );
      return true;
    } catch (e) {
      setError(true, 'Failed to reject booking request: $e');
      return false;
    }
  }

  @override
  void dispose() {
    _stopDataStreams();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
