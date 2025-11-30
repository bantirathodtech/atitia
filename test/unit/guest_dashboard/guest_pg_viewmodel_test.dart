// test/unit/guest_dashboard/guest_pg_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart';
import 'package:atitia/feature/guest_dashboard/pgs/data/repository/guest_pg_repository.dart';
import 'package:atitia/feature/guest_dashboard/pgs/data/models/guest_pg_model.dart';
import 'package:atitia/core/repositories/featured/featured_listing_repository.dart';
import 'package:atitia/core/interfaces/storage/storage_service_interface.dart';
import '../../helpers/viewmodel_test_setup.dart';
import '../../helpers/mock_repositories.dart';

/// Mock FeaturedListingRepository for testing
class MockFeaturedListingRepository extends FeaturedListingRepository {
  Set<String>? _mockFeaturedIds;
  Exception? _shouldThrow;

  MockFeaturedListingRepository({
    MockDatabaseService? databaseService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );

  void setMockFeaturedIds(Set<String> ids) {
    _mockFeaturedIds = ids;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<Set<String>> getFeaturedPGIds() async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockFeaturedIds ?? {};
  }
}

/// Mock GuestPgRepository for testing
class MockGuestPgRepository extends GuestPgRepository {
  List<GuestPgModel>? _mockPGs;
  Exception? _shouldThrow;

  MockGuestPgRepository()
      : super(
          databaseService: MockDatabaseService(),
          storageService: MockStorageService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockPGs(List<GuestPgModel> pgs) {
    _mockPGs = pgs;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<GuestPgModel>> getAllPGsStream() {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockPGs ?? []);
  }
}

/// Mock Storage Service
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

/// Helper to create test GuestPgModel
GuestPgModel _createTestPG({
  String? pgId,
  String? pgName,
  String? city,
  double? monthlyRent,
}) {
  return GuestPgModel(
    pgId: pgId ?? 'test_pg_1',
    ownerUid: 'test_owner_1',
    pgName: pgName ?? 'Test PG',
    address: 'Test Address',
    state: 'Test State',
    city: city ?? 'Test City',
    area: 'Test Area',
    amenities: ['WiFi', 'AC'],
    photos: [],
    bankDetails: {},
    pricing: monthlyRent != null ? {'monthly': monthlyRent} : null,
    isActive: true,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

void main() {
  group('GuestPgViewModel Tests', () {
    late MockGuestPgRepository mockRepository;
    late MockFeaturedListingRepository mockFeaturedRepo;
    late GuestPgViewModel viewModel;

    setUpAll(() async {
      await ViewModelTestSetup.initialize();
    });

    setUp(() {
      final mockDatabase = MockDatabaseService();
      final mockAnalytics = MockAnalyticsService();
      mockRepository = MockGuestPgRepository();
      mockFeaturedRepo = MockFeaturedListingRepository(
        databaseService: mockDatabase,
        analyticsService: mockAnalytics,
      );
      viewModel = GuestPgViewModel(
        repository: mockRepository,
        featuredRepo: mockFeaturedRepo,
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
        expect(viewModel.pgList, isEmpty);
        expect(viewModel.filteredPGs, isEmpty);
        expect(viewModel.hasPGs, isFalse);
      });
    });

    group('setSearchQuery', () {
      test('should update search query and notify listeners', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setSearchQuery('Test Query');

        // Assert
        expect(notified, isTrue);
        expect(viewModel.searchQuery, 'Test Query');
      });

      test('should clear search query when empty string provided', () {
        // Arrange
        viewModel.setSearchQuery('Test');

        // Act
        viewModel.setSearchQuery('');

        // Assert
        expect(viewModel.searchQuery, isEmpty);
      });
    });

    group('setSelectedPG', () {
      test('should set selected PG', () {
        // Arrange
        final pg = _createTestPG(pgId: 'pg_1', pgName: 'Test PG 1');

        // Act
        viewModel.setSelectedPG(pg);

        // Assert
        expect(viewModel.selectedPG, isNotNull);
        expect(viewModel.selectedPG?.pgId, 'pg_1');
      });
    });

    group('clearSelectedPG', () {
      test('should clear selected PG', () {
        // Arrange
        final pg = _createTestPG(pgId: 'pg_1', pgName: 'Test PG 1');
        viewModel.setSelectedPG(pg);

        // Act
        viewModel.clearSelectedPG();

        // Assert
        expect(viewModel.selectedPG, isNull);
      });
    });

    group('Computed Properties', () {
      test('hasPGs should return false when no PGs', () {
        // Assert
        expect(viewModel.hasPGs, isFalse);
      });

      test('totalPGCount should return zero when no PGs', () {
        // Assert
        expect(viewModel.totalPGCount, 0);
      });

      test('filteredPGCount should return zero when no PGs', () {
        // Assert
        expect(viewModel.filteredPGCount, 0);
      });
    });
  });
}
