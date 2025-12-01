// test/unit/owner_dashboard/refunds/owner_refund_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/refunds/viewmodel/owner_refund_viewmodel.dart';
import 'package:atitia/core/repositories/refund/refund_request_repository.dart';
import 'package:atitia/core/repositories/revenue/revenue_repository.dart';
import 'package:atitia/core/repositories/subscription/owner_subscription_repository.dart';
import 'package:atitia/core/repositories/featured/featured_listing_repository.dart';
import 'package:atitia/core/models/refund/refund_request_model.dart';
import 'package:atitia/core/models/revenue/revenue_record_model.dart';
import 'package:atitia/core/models/subscription/owner_subscription_model.dart';
import 'package:atitia/core/models/featured/featured_listing_model.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_auth_service.dart';
import 'dart:async';

// Mock RefundRequestRepository
class MockRefundRequestRepository extends RefundRequestRepository {
  List<RefundRequestModel>? _mockRefunds;
  RefundRequestModel? _mockRefundByRevenueId;
  Exception? _shouldThrow;

  MockRefundRequestRepository()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockRefunds(List<RefundRequestModel> refunds) {
    _mockRefunds = refunds;
  }

  void setMockRefundByRevenueId(RefundRequestModel? refund) {
    _mockRefundByRevenueId = refund;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<List<RefundRequestModel>> getOwnerRefundRequests(
      String ownerId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockRefunds ?? [];
  }

  @override
  Stream<List<RefundRequestModel>> streamOwnerRefundRequests(String ownerId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockRefunds ?? []);
  }

  @override
  Future<String> createRefundRequest(RefundRequestModel request) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    _mockRefunds ??= [];
    _mockRefunds!.add(request);
    return request.refundRequestId;
  }

  @override
  Future<RefundRequestModel?> getRefundRequestByRevenueRecordId(
      String revenueRecordId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockRefundByRevenueId;
  }
}

// Mock RevenueRepository
class MockRevenueRepository extends RevenueRepository {
  List<RevenueRecordModel>? _mockRevenue;
  Exception? _shouldThrow;

  MockRevenueRepository()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockRevenue(List<RevenueRecordModel> revenue) {
    _mockRevenue = revenue;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<List<RevenueRecordModel>> getOwnerRevenue(String ownerId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockRevenue ?? [];
  }
}

// Mock OwnerSubscriptionRepository
class MockOwnerSubscriptionRepositoryForRefund
    extends OwnerSubscriptionRepository {
  List<OwnerSubscriptionModel>? _mockSubscriptions;
  Exception? _shouldThrow;

  MockOwnerSubscriptionRepositoryForRefund()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockSubscriptions(List<OwnerSubscriptionModel> subscriptions) {
    _mockSubscriptions = subscriptions;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<OwnerSubscriptionModel>> streamAllSubscriptions(String ownerId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockSubscriptions ?? []);
  }
}

// Mock FeaturedListingRepository
class MockFeaturedListingRepositoryForRefund extends FeaturedListingRepository {
  List<FeaturedListingModel>? _mockListings;
  Exception? _shouldThrow;

  MockFeaturedListingRepositoryForRefund()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockListings(List<FeaturedListingModel> listings) {
    _mockListings = listings;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Stream<List<FeaturedListingModel>> streamOwnerFeaturedListings(
      String ownerId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockListings ?? []);
  }
}

void main() {
  group('OwnerRefundViewModel Tests', () {
    late MockRefundRequestRepository mockRefundRepo;
    late MockRevenueRepository mockRevenueRepo;
    late MockOwnerSubscriptionRepositoryForRefund mockSubscriptionRepo;
    late MockFeaturedListingRepositoryForRefund mockFeaturedRepo;
    late MockViewModelAuthService mockAuthService;
    late OwnerRefundViewModel viewModel;
    const String testOwnerId = 'test_owner_123';

    setUpAll(() {
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockRefundRepo = MockRefundRequestRepository();
      mockRevenueRepo = MockRevenueRepository();
      mockSubscriptionRepo = MockOwnerSubscriptionRepositoryForRefund();
      mockFeaturedRepo = MockFeaturedListingRepositoryForRefund();
      mockAuthService = MockViewModelAuthService(mockUserId: testOwnerId);
      viewModel = OwnerRefundViewModel(
        refundRepo: mockRefundRepo,
        revenueRepo: mockRevenueRepo,
        subscriptionRepo: mockSubscriptionRepo,
        featuredRepo: mockFeaturedRepo,
        analyticsService: MockAnalyticsService(),
        authService: mockAuthService,
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
        expect(viewModel.refundRequests, isEmpty);
        expect(viewModel.filteredRefunds, isEmpty);
        expect(viewModel.selectedStatusFilter, 'all');
        expect(viewModel.currentOwnerId, testOwnerId);
      });
    });

    group('initialize', () {
      test('should load refund requests successfully', () async {
        // Arrange
        final refund = RefundRequestModel(
          refundRequestId: 'refund_1',
          type: RefundType.subscription,
          ownerId: testOwnerId,
          revenueRecordId: 'revenue_1',
          amount: 1000.0,
          status: RefundStatus.pending,
          reason: 'Test refund',
          requestedAt: DateTime.now(),
        );
        mockRefundRepo.setMockRefunds([refund]);

        // Act
        await viewModel.initialize();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.refundRequests, isNotEmpty);
      });

      test('should handle errors during initialization', () async {
        // Arrange
        mockRefundRepo.setShouldThrow(Exception('Network error'));

        // Act
        await viewModel.initialize();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.loading, isFalse);
        // Error should be set when initialization fails
        expect(viewModel.error, isTrue);
      });
    });

    group('filteredRefunds', () {
      test('should filter by status', () async {
        // Arrange
        final refund1 = RefundRequestModel(
          refundRequestId: 'refund_1',
          type: RefundType.subscription,
          ownerId: testOwnerId,
          revenueRecordId: 'revenue_1',
          amount: 1000.0,
          status: RefundStatus.pending,
          reason: 'Test refund 1',
          requestedAt: DateTime.now(),
        );
        final refund2 = RefundRequestModel(
          refundRequestId: 'refund_2',
          type: RefundType.subscription,
          ownerId: testOwnerId,
          revenueRecordId: 'revenue_2',
          amount: 2000.0,
          status: RefundStatus.approved,
          reason: 'Test refund 2',
          requestedAt: DateTime.now(),
        );
        mockRefundRepo.setMockRefunds([refund1, refund2]);
        await viewModel.initialize();
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        viewModel.setStatusFilter('pending');

        // Assert
        final filtered = viewModel.filteredRefunds;
        expect(filtered.length, 1);
        expect(filtered.first.status, RefundStatus.pending);
      });
    });

    group('currentOwnerId', () {
      test('should return current owner ID from auth service', () {
        expect(viewModel.currentOwnerId, testOwnerId);
      });
    });
  });
}
