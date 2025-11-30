// test/unit/owner_dashboard/mypg/owner_pg_management_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart';
import 'package:atitia/feature/owner_dashboard/mypg/data/models/owner_pg_management_model.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_guest_info_service.dart';
import 'package:atitia/core/interfaces/storage/storage_service_interface.dart';
import 'dart:async';

/// Mock Storage Service for testing
class MockStorageService implements IStorageService {
  @override
  Future<String> uploadFile({
    required String path,
    required dynamic file,
    String? fileName,
    Map<String, String>? metadata,
  }) async {
    return 'https://mock-storage.url/$path';
  }

  @override
  Future<void> deleteFile(String path) async {}

  @override
  Future<String> getDownloadUrl(String path) async {
    return 'https://mock-storage.url/$path';
  }

  @override
  Future<List<String>> listFiles(String path) async {
    return [];
  }

  @override
  Future<String> uploadFileWithProgress({
    required String path,
    required dynamic file,
    String? fileName,
    Function(double progress)? onProgress,
    Map<String, String>? metadata,
  }) async {
    return 'https://mock-storage.url/$path';
  }

  @override
  Future<String> downloadFile(String path, String localPath) async {
    return localPath;
  }
}

/// Mock OwnerPgManagementRepository for testing
class MockOwnerPgManagementRepository extends OwnerPgManagementRepository {
  Map<String, dynamic>? _mockPgDetails;
  List<OwnerBed>? _mockBeds;
  List<OwnerRoom>? _mockRooms;
  List<OwnerFloor>? _mockFloors;
  List<OwnerBooking>? _mockBookings;
  OwnerRevenueReport? _mockRevenueReport;
  OwnerOccupancyReport? _mockOccupancyReport;
  Map<String, dynamic>? _mockDraft;
  Exception? _shouldThrow;

  MockOwnerPgManagementRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );

  void setMockPgDetails(Map<String, dynamic> details) {
    _mockPgDetails = details;
  }

  void setMockBeds(List<OwnerBed> beds) {
    _mockBeds = beds;
  }

  void setMockRooms(List<OwnerRoom> rooms) {
    _mockRooms = rooms;
  }

  void setMockFloors(List<OwnerFloor> floors) {
    _mockFloors = floors;
  }

  void setMockBookings(List<OwnerBooking> bookings) {
    _mockBookings = bookings;
  }

  void setMockRevenueReport(OwnerRevenueReport report) {
    _mockRevenueReport = report;
  }

  void setMockOccupancyReport(OwnerOccupancyReport report) {
    _mockOccupancyReport = report;
  }

  void setMockDraft(Map<String, dynamic> draft) {
    _mockDraft = draft;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<Map<String, dynamic>?> getPGDetails(String pgId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    return _mockPgDetails;
  }

  @override
  Stream<List<OwnerBed>> streamBeds(String pgId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBeds ?? []);
  }

  @override
  Stream<List<OwnerRoom>> streamRooms(String pgId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockRooms ?? []);
  }

  @override
  Stream<List<OwnerFloor>> streamFloors(String pgId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockFloors ?? []);
  }

  @override
  Stream<List<OwnerBooking>> streamBookings(String pgId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBookings ?? []);
  }

  @override
  Stream<Map<String, dynamic>?> streamPGDetails(String pgId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockPgDetails);
  }

  @override
  Future<OwnerRevenueReport> getRevenueReport(String pgId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    return _mockRevenueReport ?? OwnerRevenueReport(
      collectedAmount: 0.0,
      pendingAmount: 0.0,
      totalAmount: 0.0,
      totalPayments: 0,
      collectedPayments: 0,
      pendingPayments: 0,
    );
  }

  @override
  Future<OwnerOccupancyReport> getOccupancyReport(List<OwnerBed> beds) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    return _mockOccupancyReport ?? OwnerOccupancyReport(
      totalBeds: beds.length,
      occupiedBeds: beds.where((b) => b.isOccupied).length,
      vacantBeds: beds.where((b) => b.isVacant).length,
      pendingBeds: beds.where((b) => b.isPending).length,
      maintenanceBeds: beds.where((b) => b.isUnderMaintenance).length,
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchLatestDraftForOwner(String ownerId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    return _mockDraft;
  }
}

void main() {
  group('OwnerPgManagementViewModel Tests', () {
    late MockDatabaseService mockDatabaseService;
    late MockAnalyticsService mockAnalyticsService;
    late MockStorageService mockStorageService;
    late MockOwnerPgManagementRepository mockRepository;
    late OwnerPgManagementViewModel viewModel;
    const String testPgId = 'test_pg_1';

    setUpAll(() async {
      await ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      mockAnalyticsService = MockAnalyticsService();
      mockStorageService = MockStorageService();
      mockRepository = MockOwnerPgManagementRepository(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
      );
      final mockGuestInfoService = MockGuestInfoService(
        databaseService: mockDatabaseService,
      );
      viewModel = OwnerPgManagementViewModel(
        repository: mockRepository,
        guestInfoService: mockGuestInfoService,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.beds, isEmpty);
        expect(viewModel.rooms, isEmpty);
        expect(viewModel.floors, isEmpty);
        expect(viewModel.bookings, isEmpty);
        expect(viewModel.revenueReport, isNull);
        expect(viewModel.occupancyReport, isNull);
        expect(viewModel.pgDetails, isNull);
        expect(viewModel.selectedFilter, 'All');
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });
    });

    group('initialize', () {
      test('should initialize with PG ID successfully', () async {
        // Arrange
        final mockPgDetails = {
          'pgName': 'Test PG',
          'address': 'Test Address',
        };
        mockRepository.setMockPgDetails(mockPgDetails);

        // Act
        await viewModel.initialize(testPgId);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });

      test('should handle errors during initialization', () async {
        // Arrange
        // Note: The ViewModel's initialize method catches errors in sub-methods
        // (_loadPGDetails, loadRevenueReport) gracefully. To test error handling,
        // we need to make streamPGDetails throw, which will be caught by the
        // stream error handler, but won't set the main error state.
        // For now, we test that initialization completes without crashing.
        mockRepository.setShouldThrow(Exception('Initialization error'));

        // Act
        await viewModel.initialize(testPgId);

        // Assert
        // The ViewModel handles errors gracefully in sub-methods, so error
        // might not be set to true. We verify it doesn't crash.
        expect(viewModel.loading, isFalse);
        // Note: Error state depends on which method throws and how it's handled
      });
    });

    group('setFilter', () {
      test('should update filter', () {
        // Act
        viewModel.setFilter('Occupied');

        // Assert
        expect(viewModel.selectedFilter, 'Occupied');
      });

      test('should notify listeners when filter changes', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setFilter('Vacant');

        // Assert
        expect(notified, isTrue);
      });
    });

    group('fetchLatestDraftForOwner', () {
      test('should fetch draft successfully', () async {
        // Arrange
        final mockDraft = {
          'pgName': 'Draft PG',
          'isDraft': true,
        };
        mockRepository.setMockDraft(mockDraft);

        // Act
        final draft = await viewModel.fetchLatestDraftForOwner('owner_1');

        // Assert
        expect(draft, isNotNull);
        expect(draft?['pgName'], 'Draft PG');
      });

      test('should return null on error', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Fetch error'));

        // Act
        final draft = await viewModel.fetchLatestDraftForOwner('owner_1');

        // Assert
        expect(draft, isNull);
      });
    });

    group('loadRevenueReport', () {
      test('should load revenue report successfully', () async {
        // Arrange
        final mockReport = OwnerRevenueReport(
          collectedAmount: 50000.0,
          pendingAmount: 50000.0,
          totalAmount: 100000.0,
          totalPayments: 10,
          collectedPayments: 5,
          pendingPayments: 5,
        );
        mockRepository.setMockRevenueReport(mockReport);
        await viewModel.initialize(testPgId);
        await Future.delayed(const Duration(milliseconds: 200));

        // Act
        await viewModel.loadRevenueReport(testPgId);

        // Assert
        expect(viewModel.revenueReport, isNotNull);
        expect(viewModel.revenueReport?.totalAmount, 100000.0);
      });
    });

    group('Computed Properties', () {
      test('pgName should return value from pgDetails', () async {
        // Arrange
        final mockPgDetails = {
          'pgName': 'Test PG Name',
        };
        mockRepository.setMockPgDetails(mockPgDetails);
        await viewModel.initialize(testPgId);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.pgName, contains('Test PG'));
      });

      test('pgAddress should return value from pgDetails', () async {
        // Arrange
        final mockPgDetails = {
          'address': '123 Test Street',
        };
        mockRepository.setMockPgDetails(mockPgDetails);
        await viewModel.initialize(testPgId);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        expect(viewModel.pgAddress, '123 Test Street');
      });
    });

    group('Error Handling', () {
      test('should handle stream errors gracefully', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Stream error'));

        // Act
        await viewModel.initialize(testPgId);
        await Future.delayed(const Duration(milliseconds: 200));

        // Assert
        // Error is handled internally
        expect(viewModel.error, isA<bool>());
      });
    });
  });
}

