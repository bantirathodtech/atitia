// lib/features/owner_dashboard/myguest/viewmodel/owner_guest_viewmodel.dart

import 'dart:async';

import '../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/owner_guest_model.dart';
import '../data/models/owner_booking_request_model.dart';
import '../data/repository/owner_guest_repository.dart';
import '../../../../core/repositories/notification_repository.dart';
import '../../../../core/repositories/bed_change_request_repository.dart';
import '../../../../core/models/bed_change_request_model.dart';
import '../data/repository/owner_booking_request_repository.dart';
import '../../guests/data/models/owner_complaint_model.dart';
import '../../../../core/telemetry/cross_role_telemetry_service.dart';

/// ViewModel for managing owner's guests, bookings, and payments
/// Extends BaseProviderState for automatic service access and state management
/// Handles real-time data streaming and business logic with analytics tracking
class OwnerGuestViewModel extends BaseProviderState
    with LoggingMixin, StreamSubscriptionMixin {
  final OwnerGuestRepository _repository;
  final OwnerBookingRequestRepository _bookingRequestRepository;
  final BedChangeRequestRepository _bedChangeRequestRepository;
  final NotificationRepository _notificationRepository;
  final _analyticsService = getIt.analytics;
  final _telemetry = CrossRoleTelemetryService();

  /// Constructor with dependency injection
  /// If repositories are not provided, creates them with default services
  OwnerGuestViewModel({
    OwnerGuestRepository? repository,
    OwnerBookingRequestRepository? bookingRequestRepository,
    BedChangeRequestRepository? bedChangeRequestRepository,
    NotificationRepository? notificationRepository,
  })  : _repository = repository ?? OwnerGuestRepository(),
        _bookingRequestRepository =
            bookingRequestRepository ?? OwnerBookingRequestRepository(),
        _bedChangeRequestRepository =
            bedChangeRequestRepository ?? BedChangeRequestRepository(),
        _notificationRepository =
            notificationRepository ?? NotificationRepository();

  List<String> _pgIds = [];
  List<OwnerGuestModel> _guests = [];
  List<OwnerBookingModel> _bookings = [];
  List<OwnerPaymentModel> _payments = [];
  List<OwnerComplaintModel> _complaints = [];
  List<OwnerBookingRequestModel> _bookingRequests = [];
  List<BedChangeRequestModel> _bedChangeRequests = [];
  OwnerGuestModel? _selectedGuest;
  OwnerBookingModel? _selectedBooking;
  OwnerBookingRequestModel? _selectedBookingRequest;
  String _selectedFilter = 'All'; // All, Active, Pending, Inactive
  String _searchQuery = '';
  Timer? _searchDebounceTimer;
  bool _selectionMode = false;
  final Set<String> _selectedGuestIds = {};
  Map<String, dynamic> _guestStats = {};

  StreamSubscription? _guestSubscription;
  StreamSubscription? _bookingSubscription;
  StreamSubscription? _paymentSubscription;
  StreamSubscription? _complaintSubscription;
  StreamSubscription? _bookingRequestSubscription;
  StreamSubscription? _bedChangeRequestSubscription;

  /// Read-only access to guests list for UI consumption
  List<OwnerGuestModel> get guests => _guests;

  /// Read-only access to bookings list for UI consumption
  List<OwnerBookingModel> get bookings => _bookings;

  /// Read-only access to payments list for UI consumption
  List<OwnerPaymentModel> get payments => _payments;

  /// Read-only access to booking requests list for UI consumption
  List<OwnerBookingRequestModel> get bookingRequests => _bookingRequests;

  /// Read-only access to bed change requests list for UI consumption
  List<BedChangeRequestModel> get bedChangeRequests => _bedChangeRequests;

  /// Read-only access to complaints list for UI consumption
  List<OwnerComplaintModel> get complaints => _complaints;

  /// Get list of PG IDs that owner manages
  List<String> get pgIds => _pgIds;

  /// Currently selected guest
  OwnerGuestModel? get selectedGuest => _selectedGuest;

  /// Currently selected booking
  OwnerBookingModel? get selectedBooking => _selectedBooking;

  /// Currently selected booking request
  OwnerBookingRequestModel? get selectedBookingRequest =>
      _selectedBookingRequest;

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
    logMethodEntry(
      'initialize',
      parameters: {'pgIds': pgIds},
      feature: 'owner_guest_management',
    );

    try {
      setLoading(true);
      clearError();
      _pgIds = pgIds;
      await _startDataStreams();

      logInfo(
        'Owner guest management initialized successfully',
        feature: 'owner_guest_management',
        metadata: {'pgCount': pgIds.length},
      );

      _analyticsService.logEvent(
        name: 'owner_guest_management_initialized',
        parameters: {'pg_count': pgIds.length},
      );
    } catch (e) {
      logError(
        'Failed to initialize guest management',
        feature: 'owner_guest_management',
        error: e,
        metadata: {'pgIds': pgIds},
      );
      setError(true, 'Failed to initialize guest management: $e');
    } finally {
      setLoading(false);
      logMethodExit('initialize');
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
      if (_guestSubscription != null) addSubscription(_guestSubscription!);

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
        if (_bookingSubscription != null) {
          addSubscription(_bookingSubscription!);
        }

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
        if (_paymentSubscription != null) {
          addSubscription(_paymentSubscription!);
        }

        // Start complaints stream for all PGs
        _complaintSubscription =
            _repository.streamComplaintsForMultiplePGs(_pgIds).listen(
          (complaints) {
            _complaints = complaints;
            notifyListeners();
          },
          onError: (error) {
            setError(true, 'Failed to stream complaints: $error');
          },
        );
        if (_complaintSubscription != null) {
          addSubscription(_complaintSubscription!);
        }

        // Start booking requests stream for all PGs
        _bookingRequestSubscription = _bookingRequestRepository
            .streamBookingRequestsForPGs(_pgIds)
            .listen(
          (requests) {
            _bookingRequests = requests;
            notifyListeners();

            logInfo(
              'Booking requests updated',
              feature: 'owner_guest_management',
              metadata: {
                'requestCount': requests.length,
                'pendingCount': requests.where((r) => r.isPending).length,
              },
            );
          },
          onError: (error) {
            logError(
              'Failed to stream booking requests',
              feature: 'owner_guest_management',
              error: error,
            );
            setError(true, 'Failed to stream booking requests: $error');
          },
        );
        if (_bookingRequestSubscription != null) {
          addSubscription(_bookingRequestSubscription!);
        }

        // Start bed change requests stream for owner
        final ownerId = getIt.auth.currentUser?.uid ?? '';
        if (ownerId.isNotEmpty) {
          _bedChangeRequestSubscription =
              _bedChangeRequestRepository.streamOwnerRequests(ownerId).listen(
            (requests) {
              _bedChangeRequests = requests;
              notifyListeners();

              logInfo(
                'Bed change requests updated',
                feature: 'owner_guest_management',
                metadata: {
                  'requestCount': requests.length,
                  'pendingCount':
                      requests.where((r) => r.status == 'pending').length,
                },
              );
            },
            onError: (error) {
              logError(
                'Failed to stream bed change requests',
                feature: 'owner_guest_management',
                error: error,
              );
              setError(true, 'Failed to stream bed change requests: $error');
            },
          );
          if (_bedChangeRequestSubscription != null) {
            addSubscription(_bedChangeRequestSubscription!);
          }
        }
      }
    } catch (e) {
      logError(
        'Failed to start data streams',
        feature: 'owner_guest_management',
        error: e,
      );
      setError(true, 'Failed to start data streams: $e');
      rethrow;
    }
  }

  /// Stops all active data streams
  Future<void> _stopDataStreams() async {
    cancelAllSubscriptions();

    _guestSubscription = null;
    _bookingSubscription = null;
    _paymentSubscription = null;
    _complaintSubscription = null;
    _bookingRequestSubscription = null;
    _bedChangeRequestSubscription = null;
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

  /// Approves a booking request
  Future<void> approveBookingRequest(
    String requestId, {
    String? responseMessage,
    String? roomNumber,
    String? bedNumber,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    logUserAction(
      'Approve Booking Request',
      feature: 'owner_guest_management',
      metadata: {
        'requestId': requestId,
        'responseMessage': responseMessage,
        'roomNumber': roomNumber,
      },
    );

    try {
      await _bookingRequestRepository.approveBookingRequest(
        requestId,
        responseMessage: responseMessage,
        roomNumber: roomNumber,
        bedNumber: bedNumber,
        startDate: startDate,
        endDate: endDate,
      );

      logInfo(
        'Booking request approved successfully',
        feature: 'owner_guest_management',
        metadata: {'requestId': requestId},
      );
    } catch (e) {
      logError(
        'Failed to approve booking request',
        feature: 'owner_guest_management',
        error: e,
        metadata: {'requestId': requestId},
      );
      setError(true, 'Failed to approve booking request: $e');
    }
  }

  /// Rejects a booking request
  Future<void> rejectBookingRequest(
    String requestId, {
    String? responseMessage,
  }) async {
    logUserAction(
      'Reject Booking Request',
      feature: 'owner_guest_management',
      metadata: {
        'requestId': requestId,
        'responseMessage': responseMessage,
      },
    );

    try {
      await _bookingRequestRepository.rejectBookingRequest(
        requestId,
        responseMessage: responseMessage,
      );

      logInfo(
        'Booking request rejected successfully',
        feature: 'owner_guest_management',
        metadata: {'requestId': requestId},
      );
    } catch (e) {
      logError(
        'Failed to reject booking request',
        feature: 'owner_guest_management',
        error: e,
        metadata: {'requestId': requestId},
      );
      setError(true, 'Failed to reject booking request: $e');
    }
  }

  /// Sets the selected booking request
  void setSelectedBookingRequest(OwnerBookingRequestModel? request) {
    _selectedBookingRequest = request;
    notifyListeners();

    logUserAction(
      'Select Booking Request',
      feature: 'owner_guest_management',
      metadata: {
        'requestId': request?.requestId,
        'guestName': request?.guestName,
        'pgName': request?.pgName,
      },
    );
  }

  /// Gets pending booking requests
  List<OwnerBookingRequestModel> get pendingBookingRequests {
    return _bookingRequests.where((r) => r.isPending).toList();
  }

  /// Gets approved booking requests
  List<OwnerBookingRequestModel> get approvedBookingRequests {
    return _bookingRequests.where((r) => r.isApproved).toList();
  }

  /// Gets rejected booking requests
  List<OwnerBookingRequestModel> get rejectedBookingRequests {
    return _bookingRequests.where((r) => r.isRejected).toList();
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
      case 'vehicles':
        filtered = _guests.where((g) => g.hasVehicleInfo).toList();
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
        final vehicleNo = guest.vehicleNo?.toLowerCase() ?? '';
        final vehicleName = guest.vehicleName?.toLowerCase() ?? '';
        return name.contains(query) ||
            phone.contains(query) ||
            vehicleNo.contains(query) ||
            vehicleName.contains(query);
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

  /// Updates a guest (e.g., room/bed assignment)
  Future<bool> updateGuest(OwnerGuestModel guest) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateGuest(guest);

      logInfo(
        'Guest updated successfully',
        feature: 'owner_guest_management',
        metadata: {
          'guest_uid': guest.uid,
          'room_number': guest.roomNumber,
          'bed_number': guest.bedNumber,
        },
      );

      _analyticsService.logEvent(
        name: 'owner_guest_update_success',
        parameters: {'guest_uid': guest.uid},
      );

      return true;
    } catch (e) {
      logError(
        'Failed to update guest',
        feature: 'owner_guest_management',
        error: e,
        metadata: {'guest_uid': guest.uid},
      );
      setError(true, 'Failed to update guest: $e');
      return false;
    } finally {
      setLoading(false);
    }
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

      // Track cross-role telemetry
      // Get ownerId from booking or use first pgId's owner (we're already in owner context)
      final ownerId = _pgIds.isNotEmpty ? _pgIds.first : payment.pgId;
      await _telemetry.trackPaymentAction(
        action: 'created',
        actorRole: 'owner',
        paymentId: payment.id,
        guestId: payment.guestUid,
        ownerId: ownerId, // Using pgId as proxy for ownerId context
        amount: payment.amountPaid,
        status: payment.status,
        success: true,
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
  /// Sends notification to guest when payment status changes
  Future<bool> updatePayment(OwnerPaymentModel payment) async {
    try {
      setLoading(true);
      clearError();

      // Get old payment status before update
      final oldPayment = _payments.firstWhere(
        (p) => p.id == payment.id,
        orElse: () => payment,
      );

      await _repository.updatePayment(payment);

      // Send notification to guest if status changed
      if (oldPayment.status != payment.status) {
        await _notifyGuestPaymentStatusChange(payment);

        // Track cross-role telemetry for payment status change
        final action = payment.isCollected ? 'collected' : 'rejected';
        final ownerId = _pgIds.isNotEmpty ? _pgIds.first : payment.pgId;
        await _telemetry.trackPaymentAction(
          action: action,
          actorRole: 'owner',
          paymentId: payment.id,
          guestId: payment.guestUid,
          ownerId: ownerId, // Using pgId as proxy for ownerId context
          amount: payment.amountPaid,
          status: payment.status,
          success: true,
        );
      }

      _analyticsService.logEvent(
        name: 'owner_payment_update_success',
        parameters: {
          'payment_id': payment.id,
          'new_status': payment.status,
        },
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to update payment: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Notifies guest about payment status change
  Future<void> _notifyGuestPaymentStatusChange(
      OwnerPaymentModel payment) async {
    try {
      // Send in-app notification to guest
      final isCollected = payment.isCollected;
      await _notificationRepository.sendUserNotification(
        userId: payment.guestUid,
        type: isCollected ? 'payment_collected' : 'payment_rejected',
        title: isCollected ? 'Payment Collected' : 'Payment Rejected',
        body: isCollected
            ? 'Your payment of ₹${payment.amountPaid.toStringAsFixed(0)} was collected.'
            : 'Your payment of ₹${payment.amountPaid.toStringAsFixed(0)} was rejected.',
        data: {
          'paymentId': payment.id,
          'bookingId': payment.bookingId,
          'amount': payment.amountPaid,
          'status': payment.status,
        },
      );
    } catch (e) {
      logError(
        'Failed to notify guest about payment status change',
        feature: 'owner_guest_management',
        error: e,
        metadata: {'payment_id': payment.id},
      );
      // Don't throw - payment update succeeded, notification failure is non-critical
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

  /// Complaints filters/search
  List<OwnerComplaintModel> get filteredComplaints {
    var filtered = _complaints;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      filtered = filtered
          .where((c) =>
              c.title.toLowerCase().contains(q) ||
              c.guestName.toLowerCase().contains(q) ||
              c.roomNumber.toLowerCase().contains(q))
          .toList();
    }
    return filtered;
  }

  int get totalComplaints => _complaints.length;
  int get newComplaints => _complaints.where((c) => c.isNew).length;

  /// Add reply to complaint
  Future<bool> addComplaintReply(
      String complaintId, String message, String senderName) async {
    try {
      setLoading(true);
      clearError();

      final reply = ComplaintMessage(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'owner',
        senderName: senderName,
        senderType: 'owner',
        message: message,
        timestamp: DateTime.now(),
        isReadByGuest: false,
        isReadByOwner: true,
      );

      await _repository.addComplaintReply(complaintId, reply);

      // Notify guest about owner reply
      try {
        final complaint =
            _complaints.firstWhere((c) => c.complaintId == complaintId);
        await _notificationRepository.sendUserNotification(
          userId: complaint.guestId,
          type: 'complaint_reply',
          title: 'Owner replied to your complaint',
          body: message,
          data: {
            'complaintId': complaintId,
            'pgId': complaint.pgId,
            'roomNumber': complaint.roomNumber,
          },
        );

        // Track cross-role telemetry
        await _telemetry.trackComplaintAction(
          action: 'replied',
          actorRole: 'owner',
          complaintId: complaintId,
          guestId: complaint.guestId,
          ownerId: complaint.ownerId,
          success: true,
        );
      } catch (_) {
        // Best-effort notify; don't fail UI if complaint not in cache
      }
      return true;
    } catch (e) {
      setError(true, 'Failed to add reply: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Update complaint status
  Future<bool> updateComplaintStatus(String complaintId, String status,
      {String? resolutionNotes}) async {
    try {
      setLoading(true);
      clearError();
      await _repository.updateComplaintStatus(complaintId, status,
          resolutionNotes: resolutionNotes);

      // Notify guest about status change
      try {
        final complaint =
            _complaints.firstWhere((c) => c.complaintId == complaintId);
        await _notificationRepository.sendUserNotification(
          userId: complaint.guestId,
          type: 'complaint_status',
          title: 'Complaint ${complaint.statusDisplay}',
          body: resolutionNotes ?? 'Status updated to ${complaint.status}',
          data: {
            'complaintId': complaintId,
            'status': status,
            'pgId': complaint.pgId,
          },
        );

        // Track cross-role telemetry
        await _telemetry.trackComplaintAction(
          action: 'resolved',
          actorRole: 'owner',
          complaintId: complaintId,
          guestId: complaint.guestId,
          ownerId: complaint.ownerId,
          status: status,
          success: true,
        );
      } catch (_) {}
      return true;
    } catch (e) {
      setError(true, 'Failed to update complaint status: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Approve a bed change request
  Future<bool> approveBedChangeRequest(String requestId,
      {String? decisionNotes}) async {
    try {
      setLoading(true);
      clearError();

      final request =
          _bedChangeRequests.firstWhere((r) => r.requestId == requestId);
      await _bedChangeRequestRepository.updateStatus(
        requestId,
        'approved',
        decisionNotes: decisionNotes,
        guestId: request.guestId,
      );

      // Update guest room/bed assignment if approved
      if (request.preferredRoomNumber != null &&
          request.preferredBedNumber != null) {
        final guest = _guests.firstWhere((g) => g.uid == request.guestId,
            orElse: () => throw Exception('Guest not found'));
        final updatedGuest = guest.copyWith(
          roomNumber: request.preferredRoomNumber,
          bedNumber: request.preferredBedNumber,
        );
        await _repository.updateGuest(updatedGuest);
      }

      _analyticsService.logEvent(
        name: 'bed_change_request_approved',
        parameters: {'request_id': requestId},
      );

      // Track cross-role telemetry
      await _telemetry.trackBedChangeAction(
        action: 'approved',
        actorRole: 'owner',
        requestId: requestId,
        guestId: request.guestId,
        ownerId: request.ownerId,
        roomNumber: request.preferredRoomNumber,
        bedNumber: request.preferredBedNumber,
        success: true,
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to approve bed change request: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Reject a bed change request
  Future<bool> rejectBedChangeRequest(String requestId,
      {String? decisionNotes}) async {
    try {
      setLoading(true);
      clearError();

      final request =
          _bedChangeRequests.firstWhere((r) => r.requestId == requestId);
      await _bedChangeRequestRepository.updateStatus(
        requestId,
        'rejected',
        decisionNotes: decisionNotes,
        guestId: request.guestId,
      );

      _analyticsService.logEvent(
        name: 'bed_change_request_rejected',
        parameters: {'request_id': requestId},
      );

      // Track cross-role telemetry
      await _telemetry.trackBedChangeAction(
        action: 'rejected',
        actorRole: 'owner',
        requestId: requestId,
        guestId: request.guestId,
        ownerId: request.ownerId,
        success: true,
      );

      return true;
    } catch (e) {
      setError(true, 'Failed to reject bed change request: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  /// Get pending bed change requests
  List<BedChangeRequestModel> get pendingBedChangeRequests {
    return _bedChangeRequests.where((r) => r.status == 'pending').toList();
  }

  @override
  void dispose() {
    _stopDataStreams();
    if (_searchDebounceTimer != null) {
      addTimer(_searchDebounceTimer!);
      _searchDebounceTimer = null;
    }
    disposeAll(); // Clean up all subscriptions and timers
    super.dispose();
  }
}
