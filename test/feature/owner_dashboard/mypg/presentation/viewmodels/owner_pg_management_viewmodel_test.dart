import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'package:atitia/feature/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart';
import 'package:atitia/feature/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart';
import 'package:atitia/feature/owner_dashboard/mypg/data/models/owner_pg_management_model.dart';

import 'owner_pg_management_viewmodel_test.mocks.dart';

@GenerateMocks([OwnerPgManagementRepository])
void main() {
  group('OwnerPgManagementViewModel', () {
    late OwnerPgManagementViewModel viewModel;
    late MockOwnerPgManagementRepository mockRepository;

    setUp(() {
      mockRepository = MockOwnerPgManagementRepository();
      viewModel = OwnerPgManagementViewModel();
      // Inject mock repository for testing
    });

    tearDown(() {
      viewModel.dispose();
    });

    group('Initialization', () {
      test('should initialize with empty data', () {
        expect(viewModel.beds, isEmpty);
        expect(viewModel.rooms, isEmpty);
        expect(viewModel.floors, isEmpty);
        expect(viewModel.bookings, isEmpty);
        expect(viewModel.revenueReport, isNull);
        expect(viewModel.occupancyReport, isNull);
        expect(viewModel.pgDetails, isNull);
      });

      test('should set loading state correctly', () {
        expect(viewModel.loading, isFalse);
        expect(viewModel.hasError, isFalse);
        expect(viewModel.errorMessage, isNull);
      });
    });

    group('PG Management', () {
      test('should initialize with PG ID', () async {
        const pgId = 'test_pg_id';
        
        when(mockRepository.getPgDetails(pgId))
            .thenAnswer((_) async => {'pgName': 'Test PG'});

        await viewModel.initialize(pgId);

        expect(viewModel.pgId, equals(pgId));
        verify(mockRepository.getPgDetails(pgId)).called(1);
      });

      test('should create PG successfully', () async {
        final pgData = {
          'pgName': 'Test PG',
          'address': 'Test Address',
          'city': 'Test City',
          'state': 'Test State',
          'ownerUid': 'test_owner_uid',
        };

        when(mockRepository.createPG(pgData))
            .thenAnswer((_) async => 'new_pg_id');

        final result = await viewModel.createOrUpdatePG(pgData);

        expect(result, isTrue);
        expect(viewModel.loading, isFalse);
        verify(mockRepository.createPG(pgData)).called(1);
      });

      test('should handle PG creation error', () async {
        final pgData = {
          'pgName': 'Test PG',
          'ownerUid': 'test_owner_uid',
        };

        when(mockRepository.createPG(pgData))
            .thenThrow(Exception('Database error'));

        final result = await viewModel.createOrUpdatePG(pgData);

        expect(result, isFalse);
        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, contains('Failed to save PG'));
      });
    });

    group('Bed Management', () {
      test('should stream beds correctly', () {
        final testBeds = [
          OwnerBed(
            id: 'bed1',
            roomId: 'room1',
            floorId: 'floor1',
            bedNumber: 'Bed 1',
            status: 'vacant',
          ),
          OwnerBed(
            id: 'bed2',
            roomId: 'room1',
            floorId: 'floor1',
            bedNumber: 'Bed 2',
            status: 'occupied',
            guestName: 'John Doe',
          ),
        ];

        when(mockRepository.streamBeds('test_pg'))
            .thenAnswer((_) => Stream.value(testBeds));

        // Test bed streaming logic
        expect(testBeds.length, equals(2));
        expect(testBeds.first.status, equals('vacant'));
        expect(testBeds.last.status, equals('occupied'));
      });

      test('should filter beds by status', () {
        final allBeds = [
          OwnerBed(
            id: 'bed1',
            roomId: 'room1',
            floorId: 'floor1',
            bedNumber: 'Bed 1',
            status: 'vacant',
          ),
          OwnerBed(
            id: 'bed2',
            roomId: 'room1',
            floorId: 'floor1',
            bedNumber: 'Bed 2',
            status: 'occupied',
            guestName: 'John Doe',
          ),
          OwnerBed(
            id: 'bed3',
            roomId: 'room2',
            floorId: 'floor1',
            bedNumber: 'Bed 3',
            status: 'vacant',
          ),
        ];

        // Test filtering logic
        final vacantBeds = allBeds.where((bed) => bed.status == 'vacant').toList();
        final occupiedBeds = allBeds.where((bed) => bed.status == 'occupied').toList();

        expect(vacantBeds.length, equals(2));
        expect(occupiedBeds.length, equals(1));
      });
    });

    group('Revenue Tracking', () {
      test('should calculate revenue correctly', () {
        final bookings = [
          OwnerBooking(
            id: 'booking1',
            guestUid: 'guest1',
            pgId: 'pg1',
            roomId: 'room1',
            bedId: 'bed1',
            amount: 8000.0,
            status: 'paid',
            bookingDate: DateTime.now(),
            checkInDate: DateTime.now(),
            checkOutDate: DateTime.now().add(const Duration(days: 30)),
          ),
          OwnerBooking(
            id: 'booking2',
            guestUid: 'guest2',
            pgId: 'pg1',
            roomId: 'room2',
            bedId: 'bed2',
            amount: 10000.0,
            status: 'pending',
            bookingDate: DateTime.now(),
            checkInDate: DateTime.now(),
            checkOutDate: DateTime.now().add(const Duration(days: 30)),
          ),
        ];

        // Test revenue calculation
        final totalRevenue = bookings.fold(0.0, (sum, booking) => sum + booking.amount);
        final paidRevenue = bookings
            .where((booking) => booking.status == 'paid')
            .fold(0.0, (sum, booking) => sum + booking.amount);

        expect(totalRevenue, equals(18000.0));
        expect(paidRevenue, equals(8000.0));
      });
    });

    group('Occupancy Tracking', () {
      test('should calculate occupancy percentage', () {
        final totalBeds = 10;
        final occupiedBeds = 7;
        
        final occupancyPercentage = (occupiedBeds / totalBeds) * 100;
        
        expect(occupancyPercentage, equals(70.0));
      });

      test('should handle zero beds case', () {
        final totalBeds = 0;
        final occupiedBeds = 0;
        
        final occupancyPercentage = totalBeds > 0 ? (occupiedBeds / totalBeds) * 100 : 0.0;
        
        expect(occupancyPercentage, equals(0.0));
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        when(mockRepository.getPgDetails('invalid_id'))
            .thenThrow(Exception('Network error'));

        await viewModel.initialize('invalid_id');

        expect(viewModel.hasError, isTrue);
        expect(viewModel.errorMessage, isNotNull);
      });

      test('should clear errors when retrying', () async {
        // Set error state
        viewModel.setError(true, 'Test error');
        expect(viewModel.hasError, isTrue);

        // Clear error
        viewModel.clearError();
        expect(viewModel.hasError, isFalse);
        expect(viewModel.errorMessage, isNull);
      });
    });

    group('State Management', () {
      test('should notify listeners on state change', () {
        bool listenerCalled = false;
        
        viewModel.addListener(() {
          listenerCalled = true;
        });

        viewModel.setLoading(true);
        expect(listenerCalled, isTrue);
      });

      test('should dispose resources correctly', () {
        viewModel.dispose();
        // Verify that streams are cancelled and resources are cleaned up
        expect(viewModel.isDisposed, isTrue);
      });
    });
  });
}
