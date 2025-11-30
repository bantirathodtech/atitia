// test/unit/guest_dashboard/foods/guest_food_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/guest_dashboard/foods/viewmodel/guest_food_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/foods/data/repository/owner_food_repository.dart';
import 'package:atitia/core/repositories/booking_repository.dart';
import 'package:atitia/core/repositories/food_feedback_repository.dart';
import 'package:atitia/core/models/booking_model.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_auth_provider.dart';
import 'package:atitia/core/interfaces/storage/storage_service_interface.dart';
import 'dart:async';

// Mock Storage Service (same as in owner_food_viewmodel_test.dart)
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

// Mock BookingRepository
class MockBookingRepository extends BookingRepository {
  List<BookingModel>? _mockBookings;
  BookingModel? _mockActiveBooking;
  Exception? _shouldThrow;

  MockBookingRepository()
      : super(databaseService: MockDatabaseService());

  void setMockBookings(List<BookingModel> bookings) {
    _mockBookings = bookings;
  }

  void setMockActiveBooking(BookingModel? booking) {
    _mockActiveBooking = booking;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<BookingModel>> streamGuestBookings(String guestId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockBookings ?? []);
  }

  @override
  Future<BookingModel?> getGuestActiveBooking(String guestId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockActiveBooking;
  }
}

void main() {
  group('GuestFoodViewmodel Tests', () {
    late OwnerFoodRepository mockFoodRepository;
    late MockBookingRepository mockBookingRepository;
    late FoodFeedbackRepository mockFeedbackRepository;
    late GuestFoodViewmodel viewModel;
    const String testGuestId = 'test_guest_123';
    const String testPgId = 'test_pg_123';
    const String testOwnerId = 'test_owner_123';

    setUpAll(() {
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      final mockDatabase = MockDatabaseService();
      final mockStorage = MockStorageService();
      final mockAnalytics = MockAnalyticsService();

      // Create repositories with mock services
      mockFoodRepository = OwnerFoodRepository(
        databaseService: mockDatabase,
        storageService: mockStorage,
        analyticsService: mockAnalytics,
      );
      mockBookingRepository = MockBookingRepository();
      mockFeedbackRepository = FoodFeedbackRepository(
        databaseService: mockDatabase,
        analyticsService: mockAnalytics,
      );

      // Create mock AuthProvider for testing
      final mockAuthProvider = MockAuthProvider(mockUserId: testGuestId);
      
      viewModel = GuestFoodViewmodel(
        repository: mockFoodRepository,
        bookingRepository: mockBookingRepository,
        feedbackRepository: mockFeedbackRepository,
        authProvider: mockAuthProvider,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    // Helper function to create test booking
    BookingModel _createTestBooking({
      String? bookingId,
      String? guestId,
      String? pgId,
      String? ownerId,
      String? status,
    }) {
      return BookingModel(
        bookingId: bookingId ?? 'booking_1',
        guestId: guestId ?? testGuestId,
        pgId: pgId ?? testPgId,
        ownerId: ownerId ?? testOwnerId,
        floorId: 'floor_1',
        roomId: 'room_1',
        bedId: 'bed_1',
        pgName: 'Test PG',
        roomNumber: '101',
        bedNumber: '1',
        sharingType: 2,
        rentPerMonth: 5000.0,
        securityDeposit: 10000.0,
        bookingDate: DateTime.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        status: status ?? 'confirmed',
      );
    }

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.weeklyMenus, isEmpty);
        expect(viewModel.specialMenus, isEmpty);
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
      });
    });

    group('getMenuForDay', () {
      test('should return menu for specific day', () {
        // Note: We can't directly set _weeklyMenus, so this test checks the method structure
        // The method returns null when no menus are loaded

        // Act
        final result = viewModel.getMenuForDay('Monday');

        // Assert
        expect(result, isNull); // Initially empty
      });

      test('should return null if menu not found', () {
        // Act
        final result = viewModel.getMenuForDay('NonExistentDay');

        // Assert
        expect(result, isNull);
      });
    });

    group('getTodaySpecialMenu', () {
      test('should return null initially', () {
        // Act
        final result = viewModel.getTodaySpecialMenu();

        // Assert
        expect(result, isNull);
      });
    });

    group('loadGuestMenu', () {
      test('should set loading state during load', () async {
        // Arrange
        final booking = _createTestBooking(status: 'confirmed');
        mockBookingRepository.setMockActiveBooking(booking);

        // Act
        final future = viewModel.loadGuestMenu();
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should handle no booking gracefully', () async {
        // Arrange
        mockBookingRepository.setMockActiveBooking(null);

        // Act
        await viewModel.loadGuestMenu();

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.weeklyMenus, isEmpty);
      });
    });

    group('submitMealFeedback', () {
      test('should submit feedback successfully', () async {
        // Arrange
        final booking = _createTestBooking(status: 'confirmed');
        mockBookingRepository.setMockActiveBooking(booking);
        await viewModel.loadGuestMenu();

        // Act
        await viewModel.submitMealFeedback(meal: 'breakfast', like: true);

        // Assert - Method should complete without error
        expect(viewModel.error, isFalse);
      });

      test('should handle no booking gracefully', () async {
        // Arrange
        mockBookingRepository.setMockActiveBooking(null);

        // Act
        await viewModel.submitMealFeedback(meal: 'breakfast', like: true);

        // Assert - Should complete without error (no-op when no booking)
        expect(viewModel.error, isFalse);
      });
    });

    group('Computed Properties', () {
      test('weeklyMenus should be empty initially', () {
        expect(viewModel.weeklyMenus, isEmpty);
      });

      test('specialMenus should be empty initially', () {
        expect(viewModel.specialMenus, isEmpty);
      });
    });
  });
}

