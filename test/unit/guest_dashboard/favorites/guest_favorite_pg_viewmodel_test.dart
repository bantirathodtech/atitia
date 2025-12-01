// test/unit/guest_dashboard/favorites/guest_favorite_pg_viewmodel_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:atitia/feature/guest_dashboard/pgs/viewmodel/guest_favorite_pg_viewmodel.dart';
import 'package:atitia/feature/guest_dashboard/pgs/data/repository/guest_favorite_pg_repository.dart';
import '../../../helpers/viewmodel_test_setup.dart';
import '../../../helpers/mock_repositories.dart';
import 'dart:async';

// Mock GuestFavoritePgRepository
class MockGuestFavoritePgRepository extends GuestFavoritePgRepository {
  Set<String> _mockFavoritePgIds = {};
  Exception? _shouldThrow;
  bool _shouldStreamError = false;

  MockGuestFavoritePgRepository()
      : super(
          databaseService: MockDatabaseService(),
        );

  void setMockFavoritePgIds(List<String> pgIds) {
    _mockFavoritePgIds = pgIds.toSet();
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  void setShouldStreamError(bool shouldError) {
    _shouldStreamError = shouldError;
  }

  @override
  Future<void> addToFavorites(String guestId, String pgId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    _mockFavoritePgIds.add(pgId);
  }

  @override
  Future<void> removeFromFavorites(String guestId, String pgId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    _mockFavoritePgIds.remove(pgId);
  }

  @override
  Future<bool> isFavorite(String guestId, String pgId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockFavoritePgIds.contains(pgId);
  }

  @override
  Stream<List<String>> streamFavoritePgIds(String guestId) {
    if (_shouldStreamError) {
      return Stream.error(Exception('Stream error'));
    }
    return Stream.value(_mockFavoritePgIds.toList());
  }

  @override
  Future<List<String>> getFavoritePgIds(String guestId) async {
    if (_shouldThrow != null) {
      throw _shouldThrow!;
    }
    return _mockFavoritePgIds.toList();
  }
}

void main() {
  group('GuestFavoritePgViewModel Tests', () {
    late MockGuestFavoritePgRepository mockRepository;
    late GuestFavoritePgViewModel viewModel;
    const String testGuestId = 'test_guest_123';
    const String testPgId1 = 'pg_1';
    const String testPgId2 = 'pg_2';

    setUpAll(() {
      ViewModelTestSetup.initialize();
    });

    setUp(() {
      mockRepository = MockGuestFavoritePgRepository();
      viewModel = GuestFavoritePgViewModel(repository: mockRepository);
    });

    tearDown(() {
      viewModel.dispose();
    });

    tearDownAll(() {
      ViewModelTestSetup.reset();
    });

    group('Initialization', () {
      test('should initialize with default values', () {
        expect(viewModel.favoritePgIds, isEmpty);
        expect(viewModel.isFavorite(testPgId1), isFalse);
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
      });
    });

    group('initializeFavorites', () {
      test('should initialize favorites and stream updates', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1, testPgId2]);

        // Act
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.favoritePgIds, containsAll([testPgId1, testPgId2]));
        expect(viewModel.isFavorite(testPgId1), isTrue);
        expect(viewModel.isFavorite(testPgId2), isTrue);
      });

      test('should not reinitialize if same guestId', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.favoritePgIds, isNotEmpty);

        // Act - Initialize again with same guestId
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 50));

        // Assert - Should not throw or cause issues, favorites should still be there
        expect(viewModel.favoritePgIds, isNotEmpty);
      });

      test('should handle stream errors', () async {
        // Arrange
        mockRepository.setShouldStreamError(true);

        // Act
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.error, isTrue);
      });
    });

    group('toggleFavorite', () {
      test('should add PG to favorites when not favorite', () async {
        // Arrange
        expect(viewModel.isFavorite(testPgId1), isFalse);

        // Act
        await viewModel.toggleFavorite(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isTrue);
        expect(viewModel.favoritePgIds, contains(testPgId1));
      });

      test('should remove PG from favorites when already favorite', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.isFavorite(testPgId1), isTrue);

        // Act
        await viewModel.toggleFavorite(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isFalse);
        expect(viewModel.favoritePgIds, isNot(contains(testPgId1)));
      });

      test('should handle errors during toggle', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Network error'));

        // Act
        try {
          await viewModel.toggleFavorite(testGuestId, testPgId1);
        } catch (e) {
          // Expected to throw
        }

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isTrue);
      });

      test('should set loading state during toggle', () async {
        // Arrange
        expect(viewModel.isFavorite(testPgId1), isFalse);

        // Act
        final future = viewModel.toggleFavorite(testGuestId, testPgId1);
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });
    });

    group('addToFavorites', () {
      test('should add PG to favorites', () async {
        // Arrange
        expect(viewModel.isFavorite(testPgId1), isFalse);

        // Act
        await viewModel.addToFavorites(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isTrue);
        expect(viewModel.favoritePgIds, contains(testPgId1));
      });

      test('should not add if already favorite', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.isFavorite(testPgId1), isTrue);

        // Act
        await viewModel.addToFavorites(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isTrue);
      });

      test('should handle errors during add', () async {
        // Arrange
        mockRepository.setShouldThrow(Exception('Add failed'));

        // Act
        try {
          await viewModel.addToFavorites(testGuestId, testPgId1);
        } catch (e) {
          // Expected to throw
        }

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isTrue);
      });

      test('should set loading state during add', () async {
        // Arrange
        expect(viewModel.isFavorite(testPgId1), isFalse);

        // Act
        final future = viewModel.addToFavorites(testGuestId, testPgId1);
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });
    });

    group('removeFromFavorites', () {
      test('should remove PG from favorites', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.isFavorite(testPgId1), isTrue);

        // Act
        await viewModel.removeFromFavorites(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isFalse);
        expect(viewModel.favoritePgIds, isNot(contains(testPgId1)));
      });

      test('should not remove if not favorite', () async {
        // Arrange
        expect(viewModel.isFavorite(testPgId1), isFalse);

        // Act
        await viewModel.removeFromFavorites(testGuestId, testPgId1);

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isFalse);
        expect(viewModel.isFavorite(testPgId1), isFalse);
      });

      test('should handle errors during remove', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        mockRepository.setShouldThrow(Exception('Remove failed'));

        // Act
        try {
          await viewModel.removeFromFavorites(testGuestId, testPgId1);
        } catch (e) {
          // Expected to throw
        }

        // Assert
        expect(viewModel.loading, isFalse);
        expect(viewModel.error, isTrue);
      });

      test('should set loading state during remove', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        final future = viewModel.removeFromFavorites(testGuestId, testPgId1);
        expect(viewModel.loading, isTrue);
        await future;

        // Assert
        expect(viewModel.loading, isFalse);
      });
    });

    group('clearFavorites', () {
      test('should clear all favorites', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1, testPgId2]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));
        expect(viewModel.favoritePgIds, isNotEmpty);

        // Act
        viewModel.clearFavorites();

        // Assert
        expect(viewModel.favoritePgIds, isEmpty);
        expect(viewModel.isFavorite(testPgId1), isFalse);
        expect(viewModel.isFavorite(testPgId2), isFalse);
      });
    });

    group('isFavorite', () {
      test('should return true when PG is favorite', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.isFavorite(testPgId1), isTrue);
      });

      test('should return false when PG is not favorite', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.isFavorite(testPgId2), isFalse);
      });
    });

    group('favoritePgIds', () {
      test('should return correct set of favorite PG IDs', () async {
        // Arrange
        mockRepository.setMockFavoritePgIds([testPgId1, testPgId2]);
        viewModel.initializeFavorites(testGuestId);
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(viewModel.favoritePgIds, containsAll([testPgId1, testPgId2]));
        expect(viewModel.favoritePgIds.length, 2);
      });

      test('should return empty set when no favorites', () {
        // Assert
        expect(viewModel.favoritePgIds, isEmpty);
      });
    });
  });
}
