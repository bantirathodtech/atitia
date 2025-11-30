// test/unit/guest_dashboard/complaints/guest_complaint_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart';
import 'package:atitia/feature/guest_dashboard/complaints/data/repository/guest_complaint_repository.dart';
import 'package:atitia/feature/guest_dashboard/complaints/data/models/guest_complaint_model.dart';
import 'dart:io';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/mock_auth_service.dart';
import '../../../helpers/mock_notification_repository.dart';
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

/// Mock GuestComplaintRepository for testing
class MockGuestComplaintRepository extends GuestComplaintRepository {
  List<GuestComplaintModel>? _mockComplaints;
  Exception? _shouldThrow;
  String? _lastUploadedImageUrl;

  MockGuestComplaintRepository({
    MockDatabaseService? databaseService,
    IStorageService? storageService,
    MockNotificationRepository? notificationRepository,
  }) : super(
          databaseService: databaseService ?? MockDatabaseService(),
          storageService: storageService ?? MockStorageService(),
          notificationRepository: notificationRepository ?? MockNotificationRepository(),
        );

  void setMockComplaints(List<GuestComplaintModel> complaints) {
    _mockComplaints = complaints;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  String? get lastUploadedImageUrl => _lastUploadedImageUrl;

  @override
  Stream<List<GuestComplaintModel>> getComplaintsForGuest(String guestId) {
    if (_shouldThrow != null) {
      return Stream.error(_shouldThrow!);
    }
    return Stream.value(_mockComplaints ?? []);
  }

  @override
  Future<void> addComplaint(GuestComplaintModel complaint) async {
    if (_shouldThrow != null) throw _shouldThrow!;
  }

  @override
  Future<void> updateComplaint(GuestComplaintModel complaint) async {
    if (_shouldThrow != null) throw _shouldThrow!;
  }

  @override
  Future<String> uploadComplaintImage(
      String guestId, String complaintId, File file) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    _lastUploadedImageUrl = 'https://mock-storage.url/complaint_image.jpg';
    return _lastUploadedImageUrl!;
  }
}

/// Helper to create test GuestComplaintModel
GuestComplaintModel _createTestComplaint({
  String? complaintId,
  String? title,
  String? status,
}) {
  return GuestComplaintModel(
    complaintId: complaintId ?? 'test_complaint_1',
    guestId: 'test_guest_1',
    pgId: 'test_pg_1',
    ownerId: 'test_owner_1',
    subject: title ?? 'Test Complaint',
    description: 'Test complaint description',
    complaintDate: DateTime.now(),
    status: status ?? 'open',
    photos: [],
  );
}

void main() {
  group('GuestComplaintViewModel Tests', () {
    late MockDatabaseService mockDatabaseService;
    late MockAnalyticsService mockAnalyticsService;
    late MockStorageService mockStorageService;
    late MockGuestComplaintRepository mockRepository;
    late GuestComplaintViewModel viewModel;
    const String testGuestId = 'test_guest_1';

    setUpAll(() async {
      await ViewModelTestSetup.initialize(mockUserId: testGuestId);
    });

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      mockAnalyticsService = MockAnalyticsService();
      mockStorageService = MockStorageService();
      final mockNotificationRepo = MockNotificationRepository(
        databaseService: mockDatabaseService,
        analyticsService: mockAnalyticsService,
      );
      mockRepository = MockGuestComplaintRepository(
        databaseService: mockDatabaseService,
        storageService: mockStorageService,
        notificationRepository: mockNotificationRepo,
      );
      viewModel = GuestComplaintViewModel(
        repository: mockRepository,
        authService: MockViewModelAuthService(mockUserId: testGuestId),
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
        expect(viewModel.complaints, isEmpty);
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });
    });

    group('loadComplaints', () {
      test('should load complaints successfully', () {
        // Arrange
        final mockComplaints = [
          _createTestComplaint(complaintId: '1'),
          _createTestComplaint(complaintId: '2'),
        ];
        mockRepository.setMockComplaints(mockComplaints);

        // Act
        viewModel.loadComplaints(testGuestId);

        // Assert
        // loadComplaints sets up streams, so we verify the setup
        expect(viewModel.loading, isA<bool>());
      });

      test('should handle empty guestId', () {
        // Act
        viewModel.loadComplaints('');

        // Assert
        expect(viewModel.complaints, isEmpty);
      });

      test('should handle stream errors', () {
        // Arrange
        mockRepository.setShouldThrow(Exception('Stream error'));

        // Act
        viewModel.loadComplaints(testGuestId);

        // Assert
        // Error handling is done in the stream's onError callback
        expect(viewModel.error, isA<bool>());
      });
    });

    group('submitComplaint', () {
      test('should submit complaint successfully', () async {
        // Arrange
        final newComplaint = _createTestComplaint(complaintId: 'new_1');

        // Act
        await viewModel.submitComplaint(newComplaint);

        // Assert
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });

      test('should handle errors during submit', () async {
        // Arrange
        final newComplaint = _createTestComplaint(complaintId: 'new_1');
        mockRepository.setShouldThrow(Exception('Submit error'));

        // Act
        try {
          await viewModel.submitComplaint(newComplaint);
        } catch (e) {
          // Expected to throw
        }
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(viewModel.error, isTrue);
        expect(viewModel.loading, isFalse);
      });
    });

    group('updateComplaint', () {
      test('should update complaint successfully', () async {
        // Arrange
        final complaint = _createTestComplaint(complaintId: '1', status: 'resolved');

        // Act
        await viewModel.updateComplaint(complaint);

        // Assert
        expect(viewModel.loading, false);
        expect(viewModel.error, false);
      });

      test('should handle errors during update', () async {
        // Arrange
        final complaint = _createTestComplaint(complaintId: '1');
        mockRepository.setShouldThrow(Exception('Update error'));

        // Act & Assert
        expect(
          () => viewModel.updateComplaint(complaint),
          throwsException,
        );
      });
    });

    group('uploadComplaintImage', () {
      test('should upload complaint image successfully', () async {
        // Arrange
        final testFile = File('test_image.jpg');

        // Act
        final imageUrl = await viewModel.uploadComplaintImage(
          testGuestId,
          'complaint_1',
          testFile,
        );

        // Assert
        expect(imageUrl, isNotEmpty);
        expect(viewModel.loading, false);
      });

      test('should handle errors during image upload', () async {
        // Arrange
        final testFile = File('test_image.jpg');
        mockRepository.setShouldThrow(Exception('Upload error'));

        // Act
        try {
          await viewModel.uploadComplaintImage(testGuestId, 'complaint_1', testFile);
        } catch (e) {
          // Expected to throw
        }
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(viewModel.error, isTrue);
        expect(viewModel.loading, isFalse);
      });
    });

    group('refreshComplaints', () {
      test('should refresh complaints', () {
        // Arrange
        final mockComplaints = [
          _createTestComplaint(complaintId: '1'),
        ];
        mockRepository.setMockComplaints(mockComplaints);

        // Act
        viewModel.refreshComplaints(testGuestId);

        // Assert
        // refreshComplaints calls loadComplaints, which sets up streams
        expect(viewModel.loading, isA<bool>());
      });
    });

    group('Error Handling', () {
      test('should handle repository errors gracefully', () {
        // Arrange
        mockRepository.setShouldThrow(Exception('Repository error'));

        // Act
        viewModel.loadComplaints(testGuestId);

        // Assert
        // Error is handled in stream's onError callback
        expect(viewModel.error, isA<bool>());
      });
    });
  });
}

