// test/unit/owner_dashboard/myguest/owner_guest_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/myguest/viewmodel/owner_guest_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/myguest/data/repository/owner_guest_repository.dart';
import 'package:atitia/feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import 'package:atitia/feature/owner_dashboard/myguest/data/models/owner_guest_model.dart'
    show OwnerGuestModel, OwnerBookingModel, OwnerPaymentModel;
import 'package:atitia/feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/models/owner_complaint_model.dart';
import 'package:atitia/core/models/bed_change_request_model.dart';
import 'package:atitia/core/repositories/bed_change_request_repository.dart';
import 'package:atitia/core/repositories/notification_repository.dart';
import 'package:atitia/core/services/booking/booking_lifecycle_service.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_transaction_service.dart';
import 'dart:async';

/// Mock OwnerGuestRepository for testing
class MockOwnerGuestRepository extends OwnerGuestRepository {
  List<OwnerGuestModel>? _mockGuests;
  List<OwnerBookingModel>? _mockBookings;
  List<OwnerPaymentModel>? _mockPayments;
  List<OwnerComplaintModel>? _mockComplaints;
  Exception? _shouldThrow;

  MockOwnerGuestRepository()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockGuests(List<OwnerGuestModel> guests) {
    _mockGuests = guests;
  }

  void setMockBookings(List<OwnerBookingModel> bookings) {
    _mockBookings = bookings;
  }

  void setMockPayments(List<OwnerPaymentModel> payments) {
    _mockPayments = payments;
  }

  void setMockComplaints(List<OwnerComplaintModel> complaints) {
    _mockComplaints = complaints;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<OwnerGuestModel>> streamGuests() {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockGuests ?? []);
  }

  @override
  Stream<List<OwnerBookingModel>> streamBookingsForMultiplePGs(
    List<String> pgIds,
  ) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBookings ?? []);
  }

  @override
  Stream<List<OwnerPaymentModel>> streamPaymentsForMultiplePGs(
    List<String> pgIds,
  ) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockPayments ?? []);
  }

  @override
  Stream<List<OwnerComplaintModel>> streamComplaintsForMultiplePGs(
    List<String> pgIds,
  ) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockComplaints ?? []);
  }
}

/// Mock NotificationRepository for testing
class MockNotificationRepository extends NotificationRepository {
  MockNotificationRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );
}

/// Mock BookingLifecycleService for testing
class MockBookingLifecycleService extends BookingLifecycleService {
  MockBookingLifecycleService({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );
}

/// Mock OwnerBookingRequestRepository for testing
class MockOwnerBookingRequestRepository extends OwnerBookingRequestRepository {
  List<OwnerBookingRequestModel>? _mockRequests;
  Exception? _shouldThrow;
  final MockDatabaseService _databaseService;
  final MockAnalyticsService _analyticsService;
  final MockNotificationRepository _notificationRepository;
  final MockTransactionService _transactionService;
  final MockBookingLifecycleService _bookingLifecycleService;

  MockOwnerBookingRequestRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
    MockNotificationRepository? notificationRepository,
    MockTransactionService? transactionService,
    MockBookingLifecycleService? bookingLifecycleService,
  })  : _databaseService = databaseService ?? MockDatabaseService(),
        _analyticsService = analyticsService ?? MockAnalyticsService(),
        _notificationRepository = notificationRepository ??
            MockNotificationRepository(
              databaseService: databaseService ?? MockDatabaseService(),
              analyticsService: analyticsService ?? MockAnalyticsService(),
            ),
        _transactionService = transactionService ?? MockTransactionService(),
        _bookingLifecycleService = bookingLifecycleService ??
            MockBookingLifecycleService(
              databaseService: databaseService ?? MockDatabaseService(),
              analyticsService: analyticsService ?? MockAnalyticsService(),
            ),
        super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
          notificationRepository: notificationRepository ??
              MockNotificationRepository(
                databaseService: databaseService ?? MockDatabaseService(),
                analyticsService: analyticsService ?? MockAnalyticsService(),
              ),
          transactionService: transactionService ?? MockTransactionService(),
          bookingLifecycleService: bookingLifecycleService ??
              MockBookingLifecycleService(
                databaseService: databaseService ?? MockDatabaseService(),
                analyticsService: analyticsService ?? MockAnalyticsService(),
              ),
        );

  void setMockRequests(List<OwnerBookingRequestModel> requests) {
    _mockRequests = requests;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<OwnerBookingRequestModel>> streamBookingRequestsForPGs(
    List<String> pgIds,
  ) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockRequests ?? []);
  }
}

/// Mock BedChangeRequestRepository for testing
class MockBedChangeRequestRepository extends BedChangeRequestRepository {
  List<BedChangeRequestModel>? _mockBedChangeRequests;
  Exception? _shouldThrow;

  MockBedChangeRequestRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
    MockNotificationRepository? notificationRepository,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
          notificationRepository: notificationRepository ??
              MockNotificationRepository(
                databaseService: databaseService ?? MockDatabaseService(),
                analyticsService: analyticsService ?? MockAnalyticsService(),
              ),
        );

  void setMockBedChangeRequests(List<BedChangeRequestModel> requests) {
    _mockBedChangeRequests = requests;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<BedChangeRequestModel>> streamOwnerRequests(String ownerId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBedChangeRequests ?? []);
  }
}

/// Helper to create test OwnerGuestModel
OwnerGuestModel _createTestGuest({
  String? uid,
  String? fullName,
  String? pgId,
  String? status,
}) {
  return OwnerGuestModel(
    uid: uid ?? 'test_guest_1',
    fullName: fullName ?? 'Test Guest',
    phoneNumber: '+919876543210',
    email: 'test@example.com',
    joiningDate: DateTime.now(),
    status: status ?? 'active',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// Helper to create test OwnerBookingRequestModel
OwnerBookingRequestModel _createTestBookingRequest({
  String? requestId,
  String? guestId,
  String? pgId,
  String? status,
}) {
  return OwnerBookingRequestModel(
    requestId: requestId ?? 'test_request_1',
    guestId: guestId ?? 'test_guest_1',
    guestName: 'Test Guest',
    guestPhone: '+919876543210',
    guestEmail: 'test@example.com',
    pgId: pgId ?? 'test_pg_1',
    pgName: 'Test PG',
    ownerId: 'test_owner_1',
    ownerUid: 'test_owner_1',
    status: status ?? 'pending',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    metadata: {},
  );
}

void main() {
  group('OwnerGuestViewModel (myguest) Tests', () {
    late MockDatabaseService mockDatabaseService;
    late MockAnalyticsService mockAnalyticsService;
    late MockNotificationRepository mockNotificationRepository;
    late MockTransactionService mockTransactionService;
    late MockBookingLifecycleService mockBookingLifecycleService;
    late MockOwnerGuestRepository mockRepository;
    late MockOwnerBookingRequestRepository mockBookingRequestRepository;
    late MockBedChangeRequestRepository mockBedChangeRequestRepository;
    late OwnerGuestViewModel viewModel;
    const String testOwnerId = 'test_owner_123';
    const List<String> testPgIds = ['pg_1', 'pg_2'];

    setUpAll(() async {
      await ViewModelTestSetup.initialize(mockUserId: testOwnerId);
    });

    setUp(() {
      // Create shared service instances to avoid circular dependencies
      mockDatabaseService = MockDatabaseService();
      mockAnalyticsService = MockAnalyticsService();
      mockNotificationRepository = MockNotificationRepository(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
      );
      mockTransactionService = MockTransactionService();
      mockBookingLifecycleService = MockBookingLifecycleService(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
      );

      // Create repositories with shared services
      mockRepository = MockOwnerGuestRepository();
      mockBookingRequestRepository = MockOwnerBookingRequestRepository(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
        notificationRepository: mockNotificationRepository,
        transactionService: mockTransactionService,
        bookingLifecycleService: mockBookingLifecycleService,
      );
      mockBedChangeRequestRepository = MockBedChangeRequestRepository(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
        notificationRepository: mockNotificationRepository,
      );

      viewModel = OwnerGuestViewModel(
        repository: mockRepository,
        bookingRequestRepository: mockBookingRequestRepository,
        bedChangeRequestRepository: mockBedChangeRequestRepository,
        notificationRepository: mockNotificationRepository,
      );
    });

    tearDown(() {
      // Clean up if needed
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.guests, isEmpty);
        expect(viewModel.bookings, isEmpty);
        expect(viewModel.payments, isEmpty);
        expect(viewModel.bookingRequests, isEmpty);
        expect(viewModel.complaints, isEmpty);
        expect(viewModel.selectedGuest, isNull);
        expect(viewModel.selectedCount, 0);
        expect(viewModel.pgIds, isEmpty);
      });
    });

    group('initialize', () {
      test('should initialize with PG IDs successfully', () async {
        // Arrange
        final mockGuests = [
          _createTestGuest(uid: 'guest_1', pgId: 'pg_1'),
        ];
        mockRepository.setMockGuests(mockGuests);

        // Act
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.pgIds, testPgIds);
      });

      test('should handle errors during initialization', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Initialization error'));

        // Act
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        // Error state is handled internally by BaseProviderState
        expect(viewModel.pgIds, testPgIds);
      });

      test('should start data streams after initialization', () async {
        // Arrange
        final mockGuests = [
          _createTestGuest(uid: 'guest_1'),
        ];
        mockRepository.setMockGuests(mockGuests);

        // Act
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.guests.length, 1);
      });
    });

    group('setSelectedGuest', () {
      test('should set selected guest', () {
        // Arrange
        final guest = _createTestGuest(uid: 'guest_1', fullName: 'Test Guest');

        // Act
        viewModel.setSelectedGuest(guest);

        // Assert
        expect(viewModel.selectedGuest, isNotNull);
        expect(viewModel.selectedGuest?.uid, 'guest_1');
        expect(viewModel.selectedGuest?.fullName, 'Test Guest');
      });

      test('should notify listeners when guest is selected', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setSelectedGuest(_createTestGuest());

        // Assert
        expect(notified, isTrue);
      });
    });

    group('setSelectedBookingRequest', () {
      test('should set selected booking request', () {
        // Arrange
        final request = _createTestBookingRequest(
          requestId: 'request_1',
          status: 'pending',
        );

        // Act
        viewModel.setSelectedBookingRequest(request);

        // Assert
        expect(viewModel.selectedBookingRequest, isNotNull);
        expect(viewModel.selectedBookingRequest?.requestId, 'request_1');
      });

      test('should notify listeners when booking request is selected', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setSelectedBookingRequest(_createTestBookingRequest());

        // Assert
        expect(notified, isTrue);
      });
    });

    group('setFilter', () {
      test('should update filter', () {
        // Act
        viewModel.setFilter('active');

        // Assert
        expect(viewModel.selectedFilter, 'active');
      });

      test('should notify listeners when filter changes', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setFilter('inactive');

        // Assert
        expect(notified, isTrue);
      });
    });

    group('setSearchQuery', () {
      test('should update search query', () async {
        // Act
        viewModel.setSearchQuery('Test Query');
        // Wait for debounce timer (300ms)
        await Future.delayed(const Duration(milliseconds: 350));

        // Assert
        expect(viewModel.searchQuery, 'Test Query');
      });

      test('should notify listeners when search query changes', () async {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setSearchQuery('New Query');
        // Wait for debounce timer (300ms)
        await Future.delayed(const Duration(milliseconds: 350));

        // Assert
        expect(notified, isTrue);
      });

      test('should clear search query when empty string provided', () async {
        // Arrange
        viewModel.setSearchQuery('Test');
        await Future.delayed(const Duration(milliseconds: 350));

        // Act
        viewModel.setSearchQuery('');
        await Future.delayed(const Duration(milliseconds: 350));

        // Assert
        expect(viewModel.searchQuery, isEmpty);
      });
    });

    group('Computed Properties', () {
      test('selectedCount should return zero initially', () {
        // Assert
        expect(viewModel.selectedCount, 0);
      });

      test('guestStats should return empty map initially', () {
        // Assert
        expect(viewModel.guestStats, isEmpty);
      });

      test('pgIds should return empty list initially', () {
        // Assert
        expect(viewModel.pgIds, isEmpty);
      });

      test('selectedFilter should return default value', () {
        // Assert
        expect(viewModel.selectedFilter, 'All');
      });

      test('searchQuery should return empty string initially', () {
        // Assert
        expect(viewModel.searchQuery, isEmpty);
      });
    });

    group('filteredGuests', () {
      test('should return all guests when filter is All', () async {
        // Arrange
        final mockGuests = [
          _createTestGuest(uid: 'guest_1', status: 'active'),
          _createTestGuest(uid: 'guest_2', status: 'inactive'),
        ];
        mockRepository.setMockGuests(mockGuests);
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        viewModel.setFilter('All');

        // Assert
        expect(viewModel.filteredGuests.length, 2);
      });

      test('should filter guests by active status', () async {
        // Arrange
        final mockGuests = [
          _createTestGuest(uid: 'guest_1', status: 'active'),
          _createTestGuest(uid: 'guest_2', status: 'inactive'),
        ];
        mockRepository.setMockGuests(mockGuests);
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        viewModel.setFilter('active');

        // Assert
        expect(viewModel.filteredGuests.length, 1);
        expect(viewModel.filteredGuests.first.status, 'active');
      });
    });

    group('Error Handling', () {
      test('should handle stream errors gracefully', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Stream error'));

        // Act
        await viewModel.initialize(testPgIds);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        // Error is handled internally, streams continue to work
        expect(viewModel.pgIds, testPgIds);
      });
    });
  });
}
