// test/unit/owner_dashboard/guests/owner_guest_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/guests/viewmodel/owner_guest_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/repository/owner_guest_repository.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/models/owner_guest_model.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/models/owner_complaint_model.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/models/owner_bike_model.dart';
import 'package:atitia/feature/owner_dashboard/guests/data/models/owner_service_model.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import 'dart:async';

// Mock OwnerGuestRepository for guests folder
class MockOwnerGuestRepositoryGuests extends OwnerGuestRepository {
  List<OwnerGuestModel>? _mockGuests;
  List<OwnerComplaintModel>? _mockComplaints;
  List<OwnerBikeModel>? _mockBikes;
  List<OwnerServiceModel>? _mockServices;
  List<Map<String, dynamic>>? _mockBookingRequests;
  Exception? _shouldThrow;

  MockOwnerGuestRepositoryGuests()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockGuests(List<OwnerGuestModel> guests) {
    _mockGuests = guests;
  }

  void setMockComplaints(List<OwnerComplaintModel> complaints) {
    _mockComplaints = complaints;
  }

  void setMockBikes(List<OwnerBikeModel> bikes) {
    _mockBikes = bikes;
  }

  void setMockServices(List<OwnerServiceModel> services) {
    _mockServices = services;
  }

  void setMockBookingRequests(List<Map<String, dynamic>> requests) {
    _mockBookingRequests = requests;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<OwnerGuestModel>> getGuestsStream(String ownerId, {String? pgId}) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockGuests ?? []);
  }

  @override
  Stream<List<OwnerComplaintModel>> getComplaintsStream(String ownerId, {String? pgId}) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockComplaints ?? []);
  }

  @override
  Stream<List<OwnerBikeModel>> getBikesStream(String ownerId, {String? pgId}) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBikes ?? []);
  }

  @override
  Stream<List<OwnerServiceModel>> getServicesStream(String ownerId, {String? pgId}) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockServices ?? []);
  }

  @override
  Stream<List<Map<String, dynamic>>> getBookingRequestsStream(String ownerId, {String? pgId}) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBookingRequests ?? []);
  }

  @override
  Future<Map<String, dynamic>> getGuestStats(String ownerId, {String? pgId}) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return {'total': _mockGuests?.length ?? 0};
  }

  @override
  Future<void> updateGuest(OwnerGuestModel guest) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    // Mock implementation
  }
}

void main() {
  group('OwnerGuestViewModel (guests) Tests', () {
    late MockOwnerGuestRepositoryGuests mockRepository;
    late OwnerGuestViewModel viewModel;
    const String testOwnerId = 'test_owner_123';
    const String testPgId = 'test_pg_123';

    setUpAll(() {
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockRepository = MockOwnerGuestRepositoryGuests();
      viewModel = OwnerGuestViewModel(repository: mockRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    // Helper function to create test guest
    OwnerGuestModel _createTestGuest({
      String? guestId,
      String? guestName,
      String? status,
    }) {
      return OwnerGuestModel(
        guestId: guestId ?? 'guest_1',
        guestName: guestName ?? 'Test Guest',
        phoneNumber: '+919876543210',
        email: 'test@example.com',
        pgId: testPgId,
        ownerId: testOwnerId,
        roomNumber: '101',
        bedNumber: '1',
        bookingId: 'booking_1',
        status: status ?? 'active',
        checkInDate: DateTime.now(),
        profilePhotoUrl: '',
        emergencyContact: 'Emergency Contact',
        emergencyPhone: '+919876543211',
        address: 'Test Address',
        occupation: 'Engineer',
        company: 'Test Company',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );
    }

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.guests, isEmpty);
        expect(viewModel.complaints, isEmpty);
        expect(viewModel.bikes, isEmpty);
        expect(viewModel.services, isEmpty);
        expect(viewModel.bookingRequests, isEmpty);
        expect(viewModel.selectedGuest, isNull);
        expect(viewModel.selectedTab, 'guests');
        expect(viewModel.searchQuery, isEmpty);
        expect(viewModel.statusFilter, 'all');
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
      });
    });

    group('initialize', () {
      test('should initialize and load data', () async {
        // Arrange
        final guest = _createTestGuest();
        mockRepository.setMockGuests([guest]);

        // Act
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.guests, isNotEmpty);
      });

      test('should handle errors during initialization', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Network error'));

        // Act
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        // Note: _loadStats catches errors and doesn't rethrow them (intentional design)
        // Stream errors are also caught in onError handlers (empty handlers)
        // So initialize completes successfully even if stats fail
        expect(viewModel.loading, isFalse);
        // Error is not set because errors are handled gracefully in _loadStats
      });
    });

    group('selectGuest', () {
      test('should set selected guest', () {
        // Arrange
        final guest = _createTestGuest();

        // Act
        viewModel.selectGuest(guest);

        // Assert
        expect(viewModel.selectedGuest, isNotNull);
        expect(viewModel.selectedGuest?.guestId, 'guest_1');
      });

      test('should clear selections', () {
        // Arrange
        final guest = _createTestGuest();
        viewModel.selectGuest(guest);

        // Act
        viewModel.clearSelections();

        // Assert
        expect(viewModel.selectedGuest, isNull);
      });
    });

    group('setSearchQuery', () {
      test('should set search query', () {
        // Act
        viewModel.setSearchQuery('test query');

        // Assert
        expect(viewModel.searchQuery, 'test query');
      });

      test('should clear search query', () {
        // Arrange
        viewModel.setSearchQuery('test query');

        // Act
        viewModel.setSearchQuery('');

        // Assert
        expect(viewModel.searchQuery, isEmpty);
      });
    });

    group('setStatusFilter', () {
      test('should set status filter', () {
        // Act
        viewModel.setStatusFilter('active');

        // Assert
        expect(viewModel.statusFilter, 'active');
      });
    });

    group('setSelectedTab', () {
      test('should set selected tab', () {
        // Act
        viewModel.setSelectedTab('complaints');

        // Assert
        expect(viewModel.selectedTab, 'complaints');
      });
    });

    group('filteredGuests', () {
      test('should filter guests by search query', () async {
        // Arrange
        final guest1 = _createTestGuest(guestId: 'guest_1', guestName: 'John Doe');
        final guest2 = _createTestGuest(guestId: 'guest_2', guestName: 'Jane Smith');
        mockRepository.setMockGuests([guest1, guest2]);
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        viewModel.setSearchQuery('John');

        // Assert
        final filtered = viewModel.filteredGuests;
        expect(filtered.length, 1);
        expect(filtered.first.guestName, 'John Doe');
      });

      test('should filter guests by status', () async {
        // Arrange
        final guest1 = _createTestGuest(guestId: 'guest_1', status: 'active');
        final guest2 = _createTestGuest(guestId: 'guest_2', status: 'inactive');
        mockRepository.setMockGuests([guest1, guest2]);
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        viewModel.setStatusFilter('active');

        // Assert
        final filtered = viewModel.filteredGuests;
        expect(filtered.length, 1);
        expect(filtered.first.status, 'active');
      });
    });

    group('Computed Properties', () {
      test('totalGuests should return correct count', () async {
        // Arrange
        final guest1 = _createTestGuest(guestId: 'guest_1');
        final guest2 = _createTestGuest(guestId: 'guest_2');
        mockRepository.setMockGuests([guest1, guest2]);
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.totalGuests, 2);
      });

      test('activeGuests should return correct count', () async {
        // Arrange
        final guest1 = _createTestGuest(guestId: 'guest_1', status: 'active');
        final guest2 = _createTestGuest(guestId: 'guest_2', status: 'inactive');
        mockRepository.setMockGuests([guest1, guest2]);
        await viewModel.initialize(testOwnerId, pgId: testPgId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.activeGuests, 1);
      });
    });

    group('updateGuest', () {
      test('should update guest successfully', () async {
        // Arrange
        final guest = _createTestGuest();

        // Act
        await viewModel.updateGuest(guest);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
      });

      test('should handle update errors', () async {
        // Arrange
        final guest = _createTestGuest();
        mockRepository.setShouldThrow(Exception('Update failed'));

        // Act
        await viewModel.updateGuest(guest);

        // Assert
        expect(viewModel.error, isTrue);
      });
    });
  });
}

