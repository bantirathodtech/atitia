// lib/feature/owner_dashboard/guests/viewmodel/owner_guest_viewmodel.dart

import 'dart:async';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/owner_guest_model.dart';
import '../data/models/owner_complaint_model.dart';
import '../data/models/owner_bike_model.dart';
import '../data/models/owner_service_model.dart';
import '../data/repository/owner_guest_repository.dart';

/// ViewModel for managing owner's guest-related data and operations.
/// Handles guests, complaints, bikes, and services with multi-PG support.
class OwnerGuestViewModel extends BaseProviderState {
  final OwnerGuestRepository _repository;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  OwnerGuestViewModel({
    OwnerGuestRepository? repository,
  }) : _repository = repository ?? OwnerGuestRepository();

  // State variables
  List<OwnerGuestModel> _guests = [];
  List<OwnerComplaintModel> _complaints = [];
  List<OwnerBikeModel> _bikes = [];
  List<OwnerServiceModel> _services = [];
  List<Map<String, dynamic>> _bookingRequests = [];
  Map<String, dynamic> _stats = {};

  // Selected items for detailed view
  OwnerGuestModel? _selectedGuest;
  OwnerComplaintModel? _selectedComplaint;
  OwnerBikeModel? _selectedBike;
  OwnerServiceModel? _selectedService;

  // Filter and search
  String _selectedTab = 'guests';
  String _searchQuery = '';
  String _statusFilter = 'all';
  String _typeFilter = 'all';

  // Stream subscriptions
  StreamSubscription<List<OwnerGuestModel>>? _guestsSubscription;
  StreamSubscription<List<OwnerComplaintModel>>? _complaintsSubscription;
  StreamSubscription<List<OwnerBikeModel>>? _bikesSubscription;
  StreamSubscription<List<OwnerServiceModel>>? _servicesSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _bookingRequestsSubscription;

  // Getters
  List<OwnerGuestModel> get guests => _guests;
  List<OwnerComplaintModel> get complaints => _complaints;
  List<OwnerBikeModel> get bikes => _bikes;
  List<OwnerServiceModel> get services => _services;
  List<Map<String, dynamic>> get bookingRequests => _bookingRequests;

  // Booking request getters
  List<Map<String, dynamic>> get pendingBookingRequests =>
      _bookingRequests.where((req) => req['status'] == 'pending').toList();
  List<Map<String, dynamic>> get approvedBookingRequests =>
      _bookingRequests.where((req) => req['status'] == 'approved').toList();
  List<Map<String, dynamic>> get rejectedBookingRequests =>
      _bookingRequests.where((req) => req['status'] == 'rejected').toList();
  Map<String, dynamic> get stats => _stats;
  String get searchQuery => _searchQuery;
  String get statusFilter => _statusFilter;
  String get typeFilter => _typeFilter;

  OwnerGuestModel? get selectedGuest => _selectedGuest;
  OwnerComplaintModel? get selectedComplaint => _selectedComplaint;
  OwnerBikeModel? get selectedBike => _selectedBike;
  OwnerServiceModel? get selectedService => _selectedService;

  String get selectedTab => _selectedTab;

  // Filtered lists
  List<OwnerGuestModel> get filteredGuests {
    var filtered = _guests;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((guest) =>
              guest.guestName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              guest.phoneNumber.contains(_searchQuery) ||
              guest.roomNumber.contains(_searchQuery))
          .toList();
    }

    if (_statusFilter != 'all') {
      filtered =
          filtered.where((guest) => guest.status == _statusFilter).toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> get filteredBookingRequests {
    var filtered = _bookingRequests;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((request) =>
              request['guestName']
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              request['guestPhone'].toString().contains(_searchQuery))
          .toList();
    }

    if (_statusFilter != 'all') {
      filtered = filtered
          .where((request) =>
              request['status'].toString().toLowerCase() ==
              _statusFilter.toLowerCase())
          .toList();
    }

    return filtered;
  }

  List<OwnerComplaintModel> get filteredComplaints {
    var filtered = _complaints;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((complaint) =>
              complaint.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              complaint.guestName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              complaint.roomNumber.contains(_searchQuery))
          .toList();
    }

    if (_statusFilter != 'all') {
      filtered = filtered
          .where((complaint) => complaint.status == _statusFilter)
          .toList();
    }

    return filtered;
  }

  List<OwnerBikeModel> get filteredBikes {
    var filtered = _bikes;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((bike) =>
              bike.bikeNumber
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              bike.bikeName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              bike.guestName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              bike.roomNumber.contains(_searchQuery))
          .toList();
    }

    if (_statusFilter != 'all') {
      filtered =
          filtered.where((bike) => bike.status == _statusFilter).toList();
    }

    return filtered;
  }

  List<OwnerServiceModel> get filteredServices {
    var filtered = _services;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((service) =>
              service.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              service.guestName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              service.roomNumber.contains(_searchQuery))
          .toList();
    }

    if (_statusFilter != 'all') {
      filtered =
          filtered.where((service) => service.status == _statusFilter).toList();
    }

    if (_typeFilter != 'all') {
      filtered = filtered
          .where((service) => service.serviceType == _typeFilter)
          .toList();
    }

    return filtered;
  }

  // Statistics getters
  int get totalGuests => _guests.length;
  int get activeGuests => _guests.where((g) => g.isCurrentlyActive).length;
  int get totalComplaints => _complaints.length;
  int get newComplaints => _complaints.where((c) => c.isNew).length;
  int get totalBikes => _bikes.length;
  int get activeBikes => _bikes.where((b) => b.isCurrentlyActive).length;
  int get totalServices => _services.length;
  int get newServices => _services.where((s) => s.isNew).length;

  /// Initialize ViewModel with data streams
  Future<void> initialize(String ownerId, {String? pgId}) async {
    try {
      setLoading(true);
      clearError();

      // Start all data streams
      await _startDataStreams(ownerId, pgId: pgId);

      // Load initial statistics
      await _loadStats(ownerId, pgId: pgId);

      _analyticsService.logEvent(
        name: 'owner_guest_management_initialized',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
        },
      );

      setLoading(false);
    } catch (e) {
      setError(true, 'Failed to initialize guest management: $e');
    }
  }

  /// Start all data streams for real-time updates
  Future<void> _startDataStreams(String ownerId, {String? pgId}) async {
    await _stopDataStreams();

    // Start guests stream
    _guestsSubscription =
        _repository.getGuestsStream(ownerId, pgId: pgId).listen(
      (guests) {
        _guests = guests;
        notifyListeners();
      },
      onError: (error) {},
    );

    // Start complaints stream
    _complaintsSubscription =
        _repository.getComplaintsStream(ownerId, pgId: pgId).listen(
      (complaints) {
        _complaints = complaints;
        notifyListeners();
      },
      onError: (error) {},
    );

    // Start bikes stream
    _bikesSubscription = _repository.getBikesStream(ownerId, pgId: pgId).listen(
      (bikes) {
        _bikes = bikes;
        notifyListeners();
      },
      onError: (error) {},
    );

    // Start services stream
    _servicesSubscription =
        _repository.getServicesStream(ownerId, pgId: pgId).listen(
      (services) {
        _services = services;
        notifyListeners();
      },
      onError: (error) {},
    );

    // Start booking requests stream
    _bookingRequestsSubscription =
        _repository.getBookingRequestsStream(ownerId, pgId: pgId).listen(
      (bookingRequests) {
        _bookingRequests = bookingRequests;
        notifyListeners();
      },
      onError: (error) {},
    );
  }

  /// Stop all data streams
  Future<void> _stopDataStreams() async {
    await _guestsSubscription?.cancel();
    await _complaintsSubscription?.cancel();
    await _bikesSubscription?.cancel();
    await _servicesSubscription?.cancel();
    await _bookingRequestsSubscription?.cancel();

    _guestsSubscription = null;
    _complaintsSubscription = null;
    _bikesSubscription = null;
    _servicesSubscription = null;
    _bookingRequestsSubscription = null;
  }

  /// Load statistics
  Future<void> _loadStats(String ownerId, {String? pgId}) async {
    try {
      _stats = await _repository.getGuestStats(ownerId, pgId: pgId);
      notifyListeners();
    } catch (e) {}
  }

  // ==========================================================================
  // TAB MANAGEMENT
  // ==========================================================================

  /// Set active tab
  void setSelectedTab(String tab) {
    if (_selectedTab != tab) {
      _selectedTab = tab;
      notifyListeners();

      _analyticsService.logEvent(
        name: 'owner_guest_tab_changed',
        parameters: {'tab': tab},
      );
    }
  }

  /// Set search query
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  /// Set status filter
  void setStatusFilter(String status) {
    if (_statusFilter != status) {
      _statusFilter = status;
      notifyListeners();
    }
  }

  /// Set type filter (for services)
  void setTypeFilter(String type) {
    if (_typeFilter != type) {
      _typeFilter = type;
      notifyListeners();
    }
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _statusFilter = 'all';
    _typeFilter = 'all';
    notifyListeners();
  }

  // ==========================================================================
  // SELECTION MANAGEMENT
  // ==========================================================================

  /// Select a guest
  void selectGuest(OwnerGuestModel guest) {
    _selectedGuest = guest;
    notifyListeners();
  }

  /// Select a complaint
  void selectComplaint(OwnerComplaintModel complaint) {
    _selectedComplaint = complaint;
    notifyListeners();
  }

  /// Select a bike
  void selectBike(OwnerBikeModel bike) {
    _selectedBike = bike;
    notifyListeners();
  }

  /// Select a service
  void selectService(OwnerServiceModel service) {
    _selectedService = service;
    notifyListeners();
  }

  /// Clear all selections
  void clearSelections() {
    _selectedGuest = null;
    _selectedComplaint = null;
    _selectedBike = null;
    _selectedService = null;
    notifyListeners();
  }

  // ==========================================================================
  // GUEST OPERATIONS
  // ==========================================================================

  /// Update guest information
  Future<bool> updateGuest(OwnerGuestModel guest) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateGuest(guest);

      _analyticsService.logEvent(
        name: 'owner_guest_updated',
        parameters: {
          'guest_id': guest.guestId,
          'pg_id': guest.pgId,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to update guest: $e');
      setLoading(false);
      return false;
    }
  }

  // ==========================================================================
  // COMPLAINT OPERATIONS
  // ==========================================================================

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

      _analyticsService.logEvent(
        name: 'owner_complaint_reply_added',
        parameters: {'complaint_id': complaintId},
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to add reply: $e');
      setLoading(false);
      return false;
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

      _analyticsService.logEvent(
        name: 'owner_complaint_status_updated',
        parameters: {
          'complaint_id': complaintId,
          'status': status,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to update complaint status: $e');
      setLoading(false);
      return false;
    }
  }

  // ==========================================================================
  // BIKE OPERATIONS
  // ==========================================================================

  /// Update bike information
  Future<bool> updateBike(OwnerBikeModel bike) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateBike(bike);

      _analyticsService.logEvent(
        name: 'owner_bike_updated',
        parameters: {
          'bike_id': bike.bikeId,
          'pg_id': bike.pgId,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to update bike: $e');
      setLoading(false);
      return false;
    }
  }

  /// Create bike movement request
  Future<bool> createBikeMovementRequest(BikeMovementRequest request) async {
    try {
      setLoading(true);
      clearError();

      await _repository.createBikeMovementRequest(request);

      _analyticsService.logEvent(
        name: 'owner_bike_movement_request_created',
        parameters: {
          'request_id': request.requestId,
          'bike_id': request.bikeId,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to create bike movement request: $e');
      setLoading(false);
      return false;
    }
  }

  // ==========================================================================
  // SERVICE OPERATIONS
  // ==========================================================================

  /// Create service request
  Future<bool> createServiceRequest(OwnerServiceModel service) async {
    try {
      setLoading(true);
      clearError();

      await _repository.createServiceRequest(service);

      _analyticsService.logEvent(
        name: 'owner_service_request_created',
        parameters: {
          'service_id': service.serviceId,
          'service_type': service.serviceType,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to create service request: $e');
      setLoading(false);
      return false;
    }
  }

  /// Add reply to service request
  Future<bool> addServiceReply(
      String serviceId, String message, String senderName) async {
    try {
      setLoading(true);
      clearError();

      final reply = ServiceMessage(
        messageId: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'owner',
        senderName: senderName,
        senderType: 'owner',
        message: message,
        timestamp: DateTime.now(),
        isReadByGuest: false,
        isReadByOwner: true,
      );

      await _repository.addServiceReply(serviceId, reply);

      _analyticsService.logEvent(
        name: 'owner_service_reply_added',
        parameters: {'service_id': serviceId},
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to add service reply: $e');
      setLoading(false);
      return false;
    }
  }

  /// Update service status
  Future<bool> updateServiceStatus(String serviceId, String status,
      {String? assignedTo, String? completionNotes}) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateServiceStatus(serviceId, status,
          assignedTo: assignedTo, completionNotes: completionNotes);

      _analyticsService.logEvent(
        name: 'owner_service_status_updated',
        parameters: {
          'service_id': serviceId,
          'status': status,
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to update service status: $e');
      setLoading(false);
      return false;
    }
  }

  // ==========================================================================
  // REFRESH OPERATIONS
  // ==========================================================================

  /// Refresh all data
  Future<void> refreshData(String ownerId, {String? pgId}) async {
    try {
      setLoading(true);
      clearError();

      await _stopDataStreams();
      await _startDataStreams(ownerId, pgId: pgId);
      await _loadStats(ownerId, pgId: pgId);

      _analyticsService.logEvent(
        name: 'owner_guest_data_refreshed',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
        },
      );

      setLoading(false);
    } catch (e) {
      setError(true, 'Failed to refresh data: $e');
      setLoading(false);
    }
  }

  // ==========================================================================
  // BOOKING REQUEST ACTIONS
  // ==========================================================================

  /// Approve a booking request
  Future<bool> approveBookingRequest(String requestId,
      {String? responseMessage}) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateBookingRequestStatus(
        requestId,
        'approved',
        responseMessage: responseMessage,
      );

      _analyticsService.logEvent(
        name: 'owner_booking_request_approved',
        parameters: {
          'request_id': requestId,
          'response_message': responseMessage ?? 'none',
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to approve booking request: $e');
      setLoading(false);
      return false;
    }
  }

  /// Reject a booking request
  Future<bool> rejectBookingRequest(String requestId,
      {String? responseMessage}) async {
    try {
      setLoading(true);
      clearError();

      await _repository.updateBookingRequestStatus(
        requestId,
        'rejected',
        responseMessage: responseMessage,
      );

      _analyticsService.logEvent(
        name: 'owner_booking_request_rejected',
        parameters: {
          'request_id': requestId,
          'response_message': responseMessage ?? 'none',
        },
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError(true, 'Failed to reject booking request: $e');
      setLoading(false);
      return false;
    }
  }
}
