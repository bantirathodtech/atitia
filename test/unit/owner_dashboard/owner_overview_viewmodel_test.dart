// test/unit/owner_dashboard/owner_overview_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/overview/viewmodel/owner_overview_view_model.dart';
import 'package:atitia/feature/owner_dashboard/overview/data/models/owner_overview_model.dart';
import 'package:atitia/common/utils/exceptions/exceptions.dart';
import '../../helpers/viewmodel_test_setup.dart';
import '../../helpers/mock_repositories.dart';

void main() {
  group('OwnerOverviewViewModel Tests', () {
    late MockOwnerOverviewRepository mockRepository;
    late OwnerOverviewViewModel viewModel;
    const String testOwnerId = 'test_owner_123';
    const String testPgId = 'test_pg_123';

    setUpAll(() {
      // Initialize GetIt with mock services
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockRepository = MockOwnerOverviewRepository();
      viewModel = OwnerOverviewViewModel(repository: mockRepository);
    });

    tearDown(() {
      // Clean up if needed
    });

    tearDownAll(() {
      // Reset GetIt after all tests
      ViewModelTestSetup.reset();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.overviewData, isNull);
        expect(viewModel.monthlyBreakdown, isNull);
        expect(viewModel.propertyBreakdown, isNull);
        expect(viewModel.paymentStatusBreakdown, isNull);
        expect(viewModel.recentlyUpdatedGuests, isNull);
        expect(viewModel.selectedYear, DateTime.now().year);
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
      });
    });

    group('loadOverviewData', () {
      test('should load overview data successfully', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalProperties: 2,
          totalRevenue: 100000.0,
          activeTenants: 10,
          totalBeds: 20,
          occupiedBeds: 10,
        );
        mockRepository.setMockOverviewData(mockData);

        // Act
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.overviewData, isNotNull);
        expect(viewModel.overviewData?.ownerId, testOwnerId);
        expect(viewModel.overviewData?.totalProperties, 2);
        expect(viewModel.overviewData?.totalRevenue, 100000.0);
        expect(viewModel.overviewData?.activeTenants, 10);
      });

      test('should set loading state during data fetch', () async {
        // Arrange
        final mockData = OwnerOverviewModel(ownerId: testOwnerId);
        mockRepository.setMockOverviewData(mockData);

        // Act
        final future = viewModel.loadOverviewData(testOwnerId);
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should handle errors gracefully', () async {
        // Arrange
        mockRepository.setShouldThrow(
          AppException(message: 'Network error'),
        );

        // Act
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isTrue);
        expect(viewModel.errorMessage, contains('Network error'));
        expect(viewModel.overviewData, isNull);
      });

      test('should load data for specific PG when pgId provided', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalProperties: 1,
        );
        mockRepository.setMockOverviewData(mockData);

        // Act
        await viewModel.loadOverviewData(testOwnerId, pgId: testPgId);

        // Assert
        expect(viewModel.overviewData, isNotNull);
        expect(viewModel.overviewData?.totalProperties, 1);
      });
    });

    group('loadMonthlyBreakdown', () {
      test('should load monthly revenue breakdown successfully', () async {
        // Arrange
        final mockBreakdown = {
          'month_1': 10000.0,
          'month_2': 15000.0,
          'month_3': 12000.0,
        };
        mockRepository.setMockMonthlyBreakdown(mockBreakdown);

        // Act
        await viewModel.loadMonthlyBreakdown(testOwnerId, 2024);

        // Assert
        expect(viewModel.monthlyBreakdown, isNotNull);
        expect(viewModel.monthlyBreakdown?['month_1'], 10000.0);
        expect(viewModel.monthlyBreakdown?['month_2'], 15000.0);
        expect(viewModel.monthlyBreakdown?['month_3'], 12000.0);
      });

      test('should not set error state on failure (secondary data)', () async {
        // Arrange
        mockRepository.setShouldThrow(
          AppException(message: 'Failed to load'),
        );

        // Act
        await viewModel.loadMonthlyBreakdown(testOwnerId, 2024);

        // Assert
        // Should not set error state for secondary data
        expect(viewModel.error, isFalse);
      });
    });

    group('loadPropertyBreakdown', () {
      test('should load property revenue breakdown successfully', () async {
        // Arrange
        final mockBreakdown = {
          'pg_1': 50000.0,
          'pg_2': 75000.0,
        };
        mockRepository.setMockPropertyBreakdown(mockBreakdown);

        // Act
        await viewModel.loadPropertyBreakdown(testOwnerId);

        // Assert
        expect(viewModel.propertyBreakdown, isNotNull);
        expect(viewModel.propertyBreakdown?['pg_1'], 50000.0);
        expect(viewModel.propertyBreakdown?['pg_2'], 75000.0);
      });
    });

    group('loadPaymentStatusBreakdown', () {
      test('should load payment status breakdown successfully', () async {
        // Arrange
        final mockBreakdown = {
          'paid': {'count': 10, 'amount': 50000.0},
          'pending': {'count': 5, 'amount': 25000.0},
        };
        mockRepository.setMockPaymentStatusBreakdown(mockBreakdown);

        // Act
        await viewModel.loadPaymentStatusBreakdown(testOwnerId);

        // Assert
        expect(viewModel.paymentStatusBreakdown, isNotNull);
        expect(
          viewModel.paymentStatusBreakdown?['paid']?['count'],
          10,
        );
        expect(
          viewModel.paymentStatusBreakdown?['paid']?['amount'],
          50000.0,
        );
      });
    });

    group('loadRecentlyUpdatedGuests', () {
      test('should load recently updated guests successfully', () async {
        // Arrange
        final mockGuests = [
          {
            'guestId': 'guest_1',
            'name': 'Guest 1',
            'updatedAt': DateTime.now()
          },
          {
            'guestId': 'guest_2',
            'name': 'Guest 2',
            'updatedAt': DateTime.now()
          },
        ];
        mockRepository.setMockRecentlyUpdatedGuests(mockGuests);

        // Act
        await viewModel.loadRecentlyUpdatedGuests(testOwnerId);

        // Assert
        expect(viewModel.recentlyUpdatedGuests, isNotNull);
        expect(viewModel.recentlyUpdatedGuests?.length, 2);
      });
    });

    group('setSelectedYear', () {
      test('should update selected year', () {
        // Act
        viewModel.setSelectedYear(2023);

        // Assert
        expect(viewModel.selectedYear, 2023);
      });

      test('should notify listeners when year changes', () {
        var notified = false;
        viewModel.addListener(() {
          notified = true;
        });

        // Act
        viewModel.setSelectedYear(2023);

        // Assert
        expect(notified, isTrue);
      });
    });

    group('refreshOverviewData', () {
      test('should refresh all overview data', () async {
        // Arrange
        final mockData = OwnerOverviewModel(ownerId: testOwnerId);
        mockRepository.setMockOverviewData(mockData);
        final mockBreakdown = {'month_1': 10000.0};
        mockRepository.setMockMonthlyBreakdown(mockBreakdown);

        // Act
        await viewModel.refreshOverviewData(testOwnerId);

        // Assert
        expect(viewModel.overviewData, isNotNull);
        // Secondary data loaded in parallel
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.monthlyBreakdown, isNotNull);
      });
    });

    group('Computed Properties', () {
      test('occupancyRate should return correct value', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalBeds: 20,
          occupiedBeds: 15,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.occupancyRate, 75.0); // 15/20 = 75% (percentage)
      });

      test('hasProperties should return true when properties exist', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalProperties: 2,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.hasProperties, isTrue);
      });

      test('hasProperties should return false when no properties', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalProperties: 0,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.hasProperties, isFalse);
      });

      test('totalProperties should return correct count', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          totalProperties: 5,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.totalProperties, 5);
      });

      test('activeTenants should return correct count', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          activeTenants: 12,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.activeTenants, 12);
      });

      test('pendingBookings should return correct count', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          pendingBookings: 3,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.pendingBookings, 3);
      });

      test('pendingComplaints should return correct count', () async {
        // Arrange
        final mockData = OwnerOverviewModel(
          ownerId: testOwnerId,
          pendingComplaints: 2,
        );
        mockRepository.setMockOverviewData(mockData);
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.pendingComplaints, 2);
      });
    });

    group('Error Handling', () {
      test('should clear error on successful load after error', () async {
        // Arrange - First fail
        mockRepository.setShouldThrow(
          AppException(message: 'Error'),
        );
        await viewModel.loadOverviewData(testOwnerId);
        expect(viewModel.error, isTrue);

        // Arrange - Then succeed
        mockRepository.clearError();
        final mockData = OwnerOverviewModel(ownerId: testOwnerId);
        mockRepository.setMockOverviewData(mockData);

        // Act
        await viewModel.loadOverviewData(testOwnerId);

        // Assert
        expect(viewModel.error, isFalse);
        expect(viewModel.errorMessage, isNull);
      });
    });
  });
}
