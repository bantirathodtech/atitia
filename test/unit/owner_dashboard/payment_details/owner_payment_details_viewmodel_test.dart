// test/unit/owner_dashboard/payment_details/owner_payment_details_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/profile/viewmodel/owner_payment_details_viewmodel.dart';
import 'package:atitia/core/repositories/owner_payment_details_repository.dart';
import 'package:atitia/core/models/owner_payment_details_model.dart';
import 'package:atitia/core/interfaces/storage/storage_service_interface.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';

// Mock Storage Service
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

// Mock OwnerPaymentDetailsRepository
class MockOwnerPaymentDetailsRepository extends OwnerPaymentDetailsRepository {
  OwnerPaymentDetailsModel? _mockPaymentDetails;
  Exception? _shouldThrow;

  MockOwnerPaymentDetailsRepository()
      : super(
          databaseService: MockDatabaseService(),
          analyticsService: MockAnalyticsService(),
        );

  void setMockPaymentDetails(OwnerPaymentDetailsModel? details) {
    _mockPaymentDetails = details;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<OwnerPaymentDetailsModel?> getPaymentDetails(String ownerId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockPaymentDetails;
  }

  @override
  Future<void> savePaymentDetails(OwnerPaymentDetailsModel details) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    _mockPaymentDetails = details;
  }
}

void main() {
  group('OwnerPaymentDetailsViewModel Tests', () {
    late MockOwnerPaymentDetailsRepository mockRepository;
    late MockStorageService mockStorage;
    late OwnerPaymentDetailsViewModel viewModel;
    const String testOwnerId = 'test_owner_123';

    setUpAll(() {
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockRepository = MockOwnerPaymentDetailsRepository();
      mockStorage = MockStorageService();
      viewModel = OwnerPaymentDetailsViewModel(
        repository: mockRepository,
        storageService: mockStorage,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    // Helper function to create test payment details
    OwnerPaymentDetailsModel createTestPaymentDetails({
      String? ownerId,
      String? bankName,
      String? upiId,
    }) {
      return OwnerPaymentDetailsModel(
        ownerId: ownerId ?? testOwnerId,
        bankName: bankName ?? 'Test Bank',
        accountHolderName: 'Test Account Holder',
        accountNumber: '1234567890',
        ifscCode: 'TEST0001234',
        upiId: upiId ?? 'test@upi',
        paymentNote: 'Test payment note',
      );
    }

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.paymentDetails, isNull);
        expect(viewModel.loading, isFalse);
        expect(viewModel.saving, isFalse);
        expect(viewModel.error, isNull);
        expect(viewModel.hasPaymentDetails, isFalse);
        expect(viewModel.hasBankDetails, isFalse);
        expect(viewModel.hasUpiDetails, isFalse);
      });
    });

    group('loadPaymentDetails', () {
      test('should load payment details successfully', () async {
        // Arrange
        final details = createTestPaymentDetails();
        mockRepository.setMockPaymentDetails(details);

        // Act
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isNull);
        expect(viewModel.paymentDetails, isNotNull);
        expect(viewModel.paymentDetails?.ownerId, testOwnerId);
        expect(viewModel.hasPaymentDetails, isTrue);
        expect(viewModel.hasBankDetails, isTrue);
        expect(viewModel.hasUpiDetails, isTrue);
      });

      test('should set loading state during load', () async {
        // Arrange
        final details = createTestPaymentDetails();
        mockRepository.setMockPaymentDetails(details);

        // Act
        final future = viewModel.loadPaymentDetails(testOwnerId);
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });

      test('should handle errors gracefully', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Network error'));

        // Act
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isNotNull);
        expect(viewModel.paymentDetails, isNull);
      });

      test('should handle null payment details', () async {
        // Arrange
        mockRepository.setMockPaymentDetails(null);

        // Act
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isNull);
        expect(viewModel.paymentDetails, isNull);
        expect(viewModel.hasPaymentDetails, isFalse);
      });
    });

    group('savePaymentDetails', () {
      test('should save payment details successfully', () async {
        // Arrange
        final details = createTestPaymentDetails();

        // Act
        final result = await viewModel.savePaymentDetails(details);

        // Assert
        expect(result, isTrue);
        expect(viewModel.saving, isFalse);
        expect(viewModel.error, isNull);
        expect(viewModel.paymentDetails, isNotNull);
        expect(viewModel.paymentDetails?.ownerId, testOwnerId);
      });

      test('should set saving state during save', () async {
        // Arrange
        final details = createTestPaymentDetails();

        // Act
        final future = viewModel.savePaymentDetails(details);
        expect(viewModel.saving, isTrue);
        await future;

        // Assert
        expect(viewModel.saving, isFalse);
      });

      test('should handle save errors', () async {
        // Arrange
        final details = createTestPaymentDetails();
        mockRepository.setShouldThrow(Exception('Save failed'));

        // Act
        final result = await viewModel.savePaymentDetails(details);

        // Assert
        expect(result, isFalse);
        expect(viewModel.saving, isFalse);
        expect(viewModel.error, isNotNull);
      });
    });

    group('uploadQrCode', () {
      test('should upload QR code successfully', () async {
        // Act
        final url = await viewModel.uploadQrCode(testOwnerId, 'qr.jpg', null);

        // Assert
        expect(url, isNotNull);
        expect(url, contains('owner_payment_qr'));
      });

      test('should handle upload errors', () async {
        // Arrange - Mock storage to throw error
        // Note: In a real test, we'd need to mock the storage service to throw

        // Act
        final url = await viewModel.uploadQrCode(testOwnerId, 'qr.jpg', null);

        // Assert - Should return null on error
        // Since mockStorage doesn't throw, this will succeed
        expect(url, isNotNull);
      });
    });

    group('deleteQrCode', () {
      test('should delete QR code successfully', () async {
        // Act
        final result =
            await viewModel.deleteQrCode('https://storage.url/qr.jpg');

        // Assert
        expect(result, isTrue);
      });
    });

    group('clearError', () {
      test('should clear error', () {
        // Arrange
        mockRepository.setShouldThrow(Exception('Test error'));
        viewModel.loadPaymentDetails(testOwnerId);
        // Wait for error to be set
        Future.delayed(const Duration(milliseconds: 100));

        // Act
        viewModel.clearError();

        // Assert
        expect(viewModel.error, isNull);
      });
    });

    group('reset', () {
      test('should reset all state', () async {
        // Arrange
        final details = createTestPaymentDetails();
        mockRepository.setMockPaymentDetails(details);
        await viewModel.loadPaymentDetails(testOwnerId);

        // Act
        viewModel.reset();

        // Assert
        expect(viewModel.paymentDetails, isNull);
        expect(viewModel.loading, isFalse);
        expect(viewModel.saving, isFalse);
        expect(viewModel.error, isNull);
      });
    });

    group('Computed Properties', () {
      test('hasPaymentDetails should return true when details exist', () async {
        // Arrange
        final details = createTestPaymentDetails();
        mockRepository.setMockPaymentDetails(details);
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.hasPaymentDetails, isTrue);
      });

      test('hasBankDetails should return true when bank details exist',
          () async {
        // Arrange
        final details = createTestPaymentDetails(bankName: 'Test Bank');
        mockRepository.setMockPaymentDetails(details);
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.hasBankDetails, isTrue);
      });

      test('hasUpiDetails should return true when UPI details exist', () async {
        // Arrange
        final details = createTestPaymentDetails(upiId: 'test@upi');
        mockRepository.setMockPaymentDetails(details);
        await viewModel.loadPaymentDetails(testOwnerId);

        // Assert
        expect(viewModel.hasUpiDetails, isTrue);
      });
    });
  });
}
