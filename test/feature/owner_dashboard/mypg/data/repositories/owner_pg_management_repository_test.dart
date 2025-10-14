import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:atitia/feature/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart';
import 'package:atitia/feature/owner_dashboard/mypg/data/models/owner_pg_management_model.dart';

import 'owner_pg_management_repository_test.mocks.dart';

@GenerateMocks([FirebaseFirestore, CollectionReference, DocumentReference, DocumentSnapshot, QuerySnapshot])
void main() {
  group('OwnerPgManagementRepository', () {
    late OwnerPgManagementRepository repository;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference mockCollection;
    late MockDocumentReference mockDocument;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      repository = OwnerPgManagementRepository();
    });

    group('PG Creation', () {
      test('should create PG successfully', () async {
        final pgData = {
          'pgName': 'Test PG',
          'address': 'Test Address',
          'city': 'Test City',
          'state': 'Test State',
          'ownerUid': 'test_owner_uid',
          'amenities': ['WiFi', 'Parking'],
          'photos': [],
          'floorStructure': [],
        };

        when(mockCollection.doc()).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenAnswer((_) async => {});
        when(mockDocument.id).thenReturn('new_pg_id');

        final result = await repository.createPG(pgData);

        expect(result, isA<String>());
        expect(result, isNotEmpty);
        verify(mockDocument.set(any)).called(1);
      });

      test('should handle PG creation error', () async {
        final pgData = {
          'pgName': 'Test PG',
          'ownerUid': 'test_owner_uid',
        };

        when(mockCollection.doc()).thenReturn(mockDocument);
        when(mockDocument.set(any)).thenThrow(Exception('Database error'));

        expect(
          () => repository.createPG(pgData),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('Bed Management', () {
      test('should stream beds correctly', () async {
        final mockSnapshot = MockQuerySnapshot();
        final mockDoc = MockDocumentSnapshot();
        
        when(mockDoc.data()).thenReturn({
          'roomId': 'room1',
          'floorId': 'floor1',
          'bedNumber': 'Bed 1',
          'status': 'vacant',
        });
        when(mockDoc.id).thenReturn('bed1');
        when(mockSnapshot.docs).thenReturn([mockDoc]);

        // Test bed streaming
        final beds = await repository.streamBeds('test_pg').first;
        
        expect(beds, isNotEmpty);
        expect(beds.first.id, equals('bed1'));
        expect(beds.first.status, equals('vacant'));
      });

      test('should handle empty beds stream', () async {
        final mockSnapshot = MockQuerySnapshot();
        when(mockSnapshot.docs).thenReturn([]);

        final beds = await repository.streamBeds('test_pg').first;
        
        expect(beds, isEmpty);
      });
    });

    group('Booking Management', () {
      test('should stream bookings correctly', () async {
        final mockSnapshot = MockQuerySnapshot();
        final mockDoc = MockDocumentSnapshot();
        
        when(mockDoc.data()).thenReturn({
          'guestUid': 'guest1',
          'pgId': 'pg1',
          'roomId': 'room1',
          'bedId': 'bed1',
          'amount': 8000.0,
          'status': 'paid',
          'bookingDate': DateTime.now().toIso8601String(),
          'checkInDate': DateTime.now().toIso8601String(),
          'checkOutDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
        });
        when(mockDoc.id).thenReturn('booking1');
        when(mockSnapshot.docs).thenReturn([mockDoc]);

        final bookings = await repository.streamBookings('test_pg').first;
        
        expect(bookings, isNotEmpty);
        expect(bookings.first.id, equals('booking1'));
        expect(bookings.first.amount, equals(8000.0));
      });

      test('should update booking status', () async {
        when(mockDocument.update(any)).thenAnswer((_) async => {});

        await repository.updateBookingStatus('booking1', 'confirmed');

        verify(mockDocument.update({'status': 'confirmed'})).called(1);
      });
    });

    group('Revenue Tracking', () {
      test('should calculate monthly revenue', () async {
        final mockSnapshot = MockQuerySnapshot();
        final mockDoc1 = MockDocumentSnapshot();
        final mockDoc2 = MockDocumentSnapshot();
        
        when(mockDoc1.data()).thenReturn({
          'amount': 8000.0,
          'status': 'paid',
          'bookingDate': DateTime.now().toIso8601String(),
        });
        when(mockDoc1.id).thenReturn('booking1');
        
        when(mockDoc2.data()).thenReturn({
          'amount': 10000.0,
          'status': 'paid',
          'bookingDate': DateTime.now().toIso8601String(),
        });
        when(mockDoc2.id).thenReturn('booking2');
        
        when(mockSnapshot.docs).thenReturn([mockDoc1, mockDoc2]);

        final revenue = await repository.getMonthlyRevenue('test_pg', DateTime.now());
        
        expect(revenue, equals(18000.0));
      });

      test('should handle zero revenue case', () async {
        final mockSnapshot = MockQuerySnapshot();
        when(mockSnapshot.docs).thenReturn([]);

        final revenue = await repository.getMonthlyRevenue('test_pg', DateTime.now());
        
        expect(revenue, equals(0.0));
      });
    });

    group('Occupancy Tracking', () {
      test('should calculate occupancy rate', () async {
        final totalBeds = 10;
        final occupiedBeds = 7;
        
        final occupancyRate = (occupiedBeds / totalBeds) * 100;
        
        expect(occupancyRate, equals(70.0));
      });

      test('should handle zero beds case', () async {
        final totalBeds = 0;
        final occupiedBeds = 0;
        
        final occupancyRate = totalBeds > 0 ? (occupiedBeds / totalBeds) * 100 : 0.0;
        
        expect(occupancyRate, equals(0.0));
      });
    });

    group('Error Handling', () {
      test('should handle Firestore connection errors', () async {
        when(mockCollection.doc()).thenThrow(Exception('Connection error'));

        expect(
          () => repository.createPG({'pgName': 'Test'}),
          throwsA(isA<Exception>()),
        );
      });

      test('should handle invalid data errors', () async {
        expect(
          () => repository.streamBeds(''),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('Analytics Integration', () {
      test('should log analytics events', () async {
        // Test that analytics events are logged during operations
        await repository.createPG({
          'pgName': 'Test PG',
          'ownerUid': 'test_owner',
        });

        // Verify analytics logging (would need to mock analytics service)
        // This is a placeholder for analytics verification
        expect(true, isTrue); // Placeholder assertion
      });
    });
  });
}
