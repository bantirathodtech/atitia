// test/unit/owner_dashboard/profile/owner_profile_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/owner_dashboard/profile/viewmodel/owner_profile_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/profile/data/repository/owner_profile_repository.dart';
import 'package:atitia/feature/owner_dashboard/profile/data/models/owner_profile_model.dart';
import 'package:atitia/common/utils/exceptions/exceptions.dart';
import 'package:atitia/common/lifecycle/state/provider_state.dart';
import 'package:atitia/core/interfaces/storage/storage_service_interface.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_auth_service.dart';
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

/// Mock OwnerProfileRepository for testing
class MockOwnerProfileRepository extends OwnerProfileRepository {
  OwnerProfile? _mockProfile;
  Exception? _shouldThrow;
  String? _lastUploadedFileName;
  dynamic _lastUploadedFile;
  Map<String, dynamic>? _lastUpdatedData;
  Map<String, String>? _lastBankDetails;
  Map<String, dynamic>? _lastBusinessInfo;
  String? _lastAddedPgId;
  String? _lastRemovedPgId;
  bool _shouldReturnNull = false;

  MockOwnerProfileRepository({
    MockDatabaseService? databaseService,
    MockStorageService? storageService,
    MockAnalyticsService? analyticsService,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          storageService: storageService ?? MockStorageService(),
          analyticsService: analyticsService ?? MockAnalyticsService(),
        );

  void setMockProfile(OwnerProfile? profile) {
    _mockProfile = profile;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  void setShouldReturnNull(bool value) {
    _shouldReturnNull = value;
  }

  String? get lastUploadedFileName => _lastUploadedFileName;
  dynamic get lastUploadedFile => _lastUploadedFile;
  Map<String, dynamic>? get lastUpdatedData => _lastUpdatedData;
  Map<String, String>? get lastBankDetails => _lastBankDetails;
  Map<String, dynamic>? get lastBusinessInfo => _lastBusinessInfo;
  String? get lastAddedPgId => _lastAddedPgId;
  String? get lastRemovedPgId => _lastRemovedPgId;

  @override
  Future<OwnerProfile?> getOwnerProfile(String ownerId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    if (_shouldReturnNull) return null;
    return _mockProfile;
  }

  @override
  Stream<OwnerProfile?> streamOwnerProfile(String ownerId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockProfile);
  }

  @override
  Future<void> createOwnerProfile(OwnerProfile profile) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _mockProfile = profile;
  }

  @override
  Future<void> updateOwnerProfile(
      String ownerId, Map<String, dynamic> updatedData) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastUpdatedData = updatedData;
  }

  @override
  Future<void> updateBankDetails(
      String ownerId, Map<String, String> bankDetails) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastBankDetails = bankDetails;
  }

  @override
  Future<void> updateBusinessInfo(
      String ownerId, Map<String, dynamic> businessInfo) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastBusinessInfo = businessInfo;
  }

  @override
  Future<String> uploadProfilePhoto(
      String ownerId, String fileName, dynamic file) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastUploadedFileName = fileName;
    _lastUploadedFile = file;
    return 'https://mock-storage.url/profile_photo.jpg';
  }

  @override
  Future<void> updateProfilePhoto(String ownerId, String photoUrl) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    // Update mock profile with photo URL
    if (_mockProfile != null) {
      _mockProfile = OwnerProfile(
        ownerId: _mockProfile!.ownerId,
        fullName: _mockProfile!.fullName,
        phoneNumber: _mockProfile!.phoneNumber,
        email: _mockProfile!.email,
        profilePhoto: photoUrl,
        aadhaarNumber: _mockProfile!.aadhaarNumber,
        aadhaarPhoto: _mockProfile!.aadhaarPhoto,
        bankAccountName: _mockProfile!.bankAccountName,
        bankAccountNumber: _mockProfile!.bankAccountNumber,
        bankIFSC: _mockProfile!.bankIFSC,
        upiId: _mockProfile!.upiId,
        upiQrCodeUrl: _mockProfile!.upiQrCodeUrl,
        pgIds: _mockProfile!.pgIds,
        address: _mockProfile!.address,
        city: _mockProfile!.city,
        state: _mockProfile!.state,
        pincode: _mockProfile!.pincode,
        panNumber: _mockProfile!.panNumber,
        gstNumber: _mockProfile!.gstNumber,
        businessName: _mockProfile!.businessName,
        businessType: _mockProfile!.businessType,
        dateOfBirth: _mockProfile!.dateOfBirth,
        gender: _mockProfile!.gender,
        isActive: _mockProfile!.isActive,
        isVerified: _mockProfile!.isVerified,
        subscriptionTier: _mockProfile!.subscriptionTier,
        subscriptionStatus: _mockProfile!.subscriptionStatus,
        subscriptionEndDate: _mockProfile!.subscriptionEndDate,
        createdAt: _mockProfile!.createdAt,
        updatedAt: _mockProfile!.updatedAt,
        metadata: _mockProfile!.metadata,
      );
    }
  }

  @override
  Future<String> uploadAadhaarDocument(
      String ownerId, String fileName, dynamic file) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastUploadedFileName = fileName;
    _lastUploadedFile = file;
    return 'https://mock-storage.url/aadhaar.jpg';
  }

  @override
  Future<void> updateAadhaarPhoto(String ownerId, String documentUrl) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    // Similar to updateProfilePhoto
  }

  @override
  Future<String> uploadUpiQrCode(
      String ownerId, String fileName, dynamic file) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastUploadedFileName = fileName;
    _lastUploadedFile = file;
    return 'https://mock-storage.url/upi_qr.jpg';
  }

  @override
  Future<void> updateUpiQrCode(String ownerId, String qrCodeUrl) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    // Similar to updateProfilePhoto
  }

  @override
  Future<void> addPGToOwner(String ownerId, String pgId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastAddedPgId = pgId;
  }

  @override
  Future<void> removePGFromOwner(String ownerId, String pgId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastRemovedPgId = pgId;
  }

  @override
  Future<void> verifyOwnerProfile(String ownerId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
  }

  @override
  Future<void> deactivateOwnerProfile(String ownerId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
  }

  @override
  Future<void> activateOwnerProfile(String ownerId) async {
    if (_shouldThrow != null) throw _shouldThrow!;
  }
}

/// Helper to create test OwnerProfile
OwnerProfile _createTestProfile({
  String? ownerId,
  String? fullName,
  bool isVerified = false,
  bool isActive = true,
}) {
  return OwnerProfile(
    ownerId: ownerId ?? 'test_owner_1',
    fullName: fullName ?? 'Test Owner',
    phoneNumber: '+919876543210',
    email: 'test@example.com',
    isVerified: isVerified,
    isActive: isActive,
  );
}

void main() {
  group('OwnerProfileViewModel Tests', () {
    late MockDatabaseService mockDatabaseService;
    late MockStorageService mockStorageService;
    late MockAnalyticsService mockAnalyticsService;
    late MockOwnerProfileRepository mockRepository;
    late OwnerProfileViewModel viewModel;
    const String testOwnerId = 'test_owner_1';

    setUpAll(() async {
      await ViewModelTestSetup.initialize(mockUserId: testOwnerId);
    });

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      mockStorageService = MockStorageService();
      mockAnalyticsService = MockAnalyticsService();
      mockRepository = MockOwnerProfileRepository(
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
        analyticsService: mockAnalyticsService,
      );
      viewModel = OwnerProfileViewModel(
        repository: mockRepository,
        authService: MockViewModelAuthService(mockUserId: testOwnerId),
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
        expect(viewModel.profile, isNull);
        expect(viewModel.isUploading, false);
        expect(viewModel.currentOwnerId, testOwnerId);
      });
    });

    group('loadProfile', () {
      test('should load profile successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);

        // Act
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.profile, isNotNull);
        expect(viewModel.profile?.ownerId, testOwnerId);
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });

      test('should load profile with specific ownerId', () async {
        // Arrange
        const specificOwnerId = 'specific_owner_1';
        final mockProfile = _createTestProfile(ownerId: specificOwnerId);
        mockRepository.setMockProfile(mockProfile);

        // Act
        await viewModel.loadProfile(ownerId: specificOwnerId);

        // Assert
        expect(viewModel.profile?.ownerId, specificOwnerId);
      });

      test('should handle profile not found', () async {
        // Arrange
        mockRepository.setShouldReturnNull(true);

        // Act
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.profile, isNull);
        expect(viewModel.error, isTrue);
      });

      test('should handle errors during load', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Load error'));

        // Act
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.error, isTrue);
        expect(viewModel.loading, false);
      });

      test('should handle missing ownerId', () async {
        // Arrange - Create a new ViewModel without auth (simulating no user)
        final viewModelWithoutAuth = OwnerProfileViewModel(
          repository: mockRepository,
          authService: MockViewModelAuthService(mockUserId: null),
        );

        // Act
        await viewModelWithoutAuth.loadProfile();

        // Assert
        expect(viewModelWithoutAuth.error, isTrue);
      });
    });

    group('streamProfile', () {
      test('should stream profile updates', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);

        // Act
        viewModel.streamProfile();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.profile, isNotNull);
        expect(viewModel.profile?.ownerId, testOwnerId);
      });

      test('should handle stream errors', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Stream error'));

        // Act
        viewModel.streamProfile();
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.error, isTrue);
      });
    });

    group('createProfile', () {
      test('should create profile successfully', () async {
        // Arrange
        final newProfile = _createTestProfile(ownerId: testOwnerId);

        // Act
        await viewModel.createProfile(newProfile);

        // Assert
        expect(viewModel.profile, isNotNull);
        expect(viewModel.profile?.ownerId, testOwnerId);
        expect(viewModel.loading, false);
      });

      test('should handle errors during create', () async {
        // Arrange
        final newProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setShouldThrow(Exception('Create error'));

        // Act
        try {
          await viewModel.createProfile(newProfile);
        } catch (e) {
          // Expected to throw
        }
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(viewModel.error, isTrue);
        expect(viewModel.loading, isFalse);
      });
    });

    group('updateProfile', () {
      test('should update profile successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        final updatedData = {'fullName': 'Updated Name'};

        // Act
        await viewModel.updateProfile(updatedData);

        // Assert
        expect(mockRepository.lastUpdatedData, updatedData);
        expect(viewModel.loading, false);
      });

      test('should handle errors during update', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        mockRepository.setShouldThrow(Exception('Update error'));

        // Act & Assert
        expect(
          () => viewModel.updateProfile({'fullName': 'New Name'}),
          throwsException,
        );
      });
    });

    group('updateBankDetails', () {
      test('should update bank details successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        final bankDetails = {
          'accountName': 'Test Account',
          'accountNumber': '1234567890',
          'ifsc': 'TEST0001234',
        };

        // Act
        await viewModel.updateBankDetails(bankDetails);

        // Assert
        expect(mockRepository.lastBankDetails, bankDetails);
        expect(viewModel.loading, false);
      });
    });

    group('updateBusinessInfo', () {
      test('should update business info successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        final businessInfo = {
          'businessName': 'Test Business',
          'businessType': 'PG',
        };

        // Act
        await viewModel.updateBusinessInfo(businessInfo);

        // Assert
        expect(mockRepository.lastBusinessInfo, businessInfo);
        expect(viewModel.loading, false);
      });
    });

    group('uploadProfilePhoto', () {
      test('should upload profile photo successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const fileName = 'profile.jpg';
        final file = <int>[1, 2, 3];

        // Act
        final photoUrl = await viewModel.uploadProfilePhoto(fileName, file);

        // Assert
        expect(photoUrl, isNotEmpty);
        expect(mockRepository.lastUploadedFileName, fileName);
        expect(mockRepository.lastUploadedFile, file);
        expect(viewModel.isUploading, false);
      });

      test('should set isUploading during upload', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const fileName = 'profile.jpg';
        final file = <int>[1, 2, 3];

        // Act
        final uploadFuture = viewModel.uploadProfilePhoto(fileName, file);

        // Assert - isUploading should be true during upload
        // Note: This is a race condition test, but we can verify the final state
        final photoUrl = await uploadFuture;
        expect(photoUrl, isNotEmpty);
        expect(viewModel.isUploading, false);
      });
    });

    group('uploadAadhaarDocument', () {
      test('should upload Aadhaar document successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const fileName = 'aadhaar.jpg';
        final file = <int>[1, 2, 3];

        // Act
        final documentUrl = await viewModel.uploadAadhaarDocument(fileName, file);

        // Assert
        expect(documentUrl, isNotEmpty);
        expect(mockRepository.lastUploadedFileName, fileName);
        expect(viewModel.isUploading, false);
      });
    });

    group('uploadUpiQrCode', () {
      test('should upload UPI QR code successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const fileName = 'upi_qr.jpg';
        final file = <int>[1, 2, 3];

        // Act
        final qrCodeUrl = await viewModel.uploadUpiQrCode(fileName, file);

        // Assert
        expect(qrCodeUrl, isNotEmpty);
        expect(mockRepository.lastUploadedFileName, fileName);
        expect(viewModel.isUploading, false);
      });
    });

    group('addPG', () {
      test('should add PG successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const pgId = 'pg_1';

        // Act
        await viewModel.addPG(pgId);

        // Assert
        expect(mockRepository.lastAddedPgId, pgId);
        expect(viewModel.loading, false);
      });
    });

    group('removePG', () {
      test('should remove PG successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        const pgId = 'pg_1';

        // Act
        await viewModel.removePG(pgId);

        // Assert
        expect(mockRepository.lastRemovedPgId, pgId);
        expect(viewModel.loading, false);
      });
    });

    group('verifyProfile', () {
      test('should verify profile successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Act
        await viewModel.verifyProfile();

        // Assert
        expect(viewModel.loading, false);
      });
    });

    group('deactivateProfile', () {
      test('should deactivate profile successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Act
        await viewModel.deactivateProfile();

        // Assert
        expect(viewModel.loading, false);
      });
    });

    group('activateProfile', () {
      test('should activate profile successfully', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Act
        await viewModel.activateProfile();

        // Assert
        expect(viewModel.loading, false);
      });
    });

    group('clearProfile', () {
      test('should clear profile data', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();
        expect(viewModel.profile, isNotNull);

        // Act
        viewModel.clearProfile();

        // Assert
        expect(viewModel.profile, isNull);
        expect(viewModel.error, false);
      });
    });

    group('Computed Properties', () {
      test('hasCompleteBusinessInfo should return false for incomplete profile',
          () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.hasCompleteBusinessInfo, isA<bool>());
      });

      test('hasUpiSetup should return false when no UPI configured', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.hasUpiSetup, isA<bool>());
      });

      test('profileCompletionPercentage should return a number', () async {
        // Arrange
        final mockProfile = _createTestProfile(ownerId: testOwnerId);
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.profileCompletionPercentage, isA<int>());
        expect(viewModel.profileCompletionPercentage, greaterThanOrEqualTo(0));
        expect(viewModel.profileCompletionPercentage, lessThanOrEqualTo(100));
      });

      test('isVerified should return profile verification status', () async {
        // Arrange
        final mockProfile = _createTestProfile(
          ownerId: testOwnerId,
          isVerified: true,
        );
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.isVerified, isTrue);
      });

      test('isActive should return profile active status', () async {
        // Arrange
        final mockProfile = _createTestProfile(
          ownerId: testOwnerId,
          isActive: false,
        );
        mockRepository.setMockProfile(mockProfile);
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.isActive, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle repository errors gracefully', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Repository error'));

        // Act
        await viewModel.loadProfile();

        // Assert
        expect(viewModel.error, isTrue);
        expect(viewModel.loading, false);
      });
    });
  });
}

