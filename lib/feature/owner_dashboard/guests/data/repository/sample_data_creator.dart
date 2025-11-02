// lib/feature/owner_dashboard/guests/data/repository/sample_data_creator.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';

/// Helper class to create sample data for testing owner collections
/// This ensures the collections exist and have proper structure
class SampleDataCreator {
  final _firestoreService = getIt.firestore;
  final _analyticsService = getIt.analytics;

  /// Creates sample data for owner collections to test permissions
  Future<void> createSampleData(String ownerId, String pgId) async {
    try {
      await _analyticsService.logEvent(
        name: 'sample_data_creation_start',
        parameters: {'owner_id': ownerId, 'pg_id': pgId},
      );

      // Create sample guest data
      await _createSampleGuest(ownerId, pgId);

      // Create sample complaint data
      await _createSampleComplaint(ownerId, pgId);

      // Create sample bike data
      await _createSampleBike(ownerId, pgId);

      // Create sample service data
      await _createSampleService(ownerId, pgId);

      await _analyticsService.logEvent(
        name: 'sample_data_creation_success',
        parameters: {'owner_id': ownerId, 'pg_id': pgId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'sample_data_creation_error',
        parameters: {'owner_id': ownerId, 'pg_id': pgId, 'error': e.toString()},
      );
    }
  }

  Future<void> _createSampleGuest(String ownerId, String pgId) async {
    final guestData = {
      'ownerId': ownerId,
      'pgId': pgId,
      'guestName': 'Sample Guest',
      'phoneNumber': '+919876543210',
      'email': 'sample@example.com',
      'roomAssignment': 'Room 101',
      'status': 'active',
      'checkInDate': Timestamp.now(),
      'emergencyContact': 'Emergency Contact',
      'emergencyPhone': '+919876543211',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    await _firestoreService.setDocument('owner_guests',
        'sample_guest_${DateTime.now().millisecondsSinceEpoch}', guestData);
  }

  Future<void> _createSampleComplaint(String ownerId, String pgId) async {
    final complaintData = {
      'ownerId': ownerId,
      'pgId': pgId,
      'guestId': 'sample_guest_id',
      'title': 'Sample Complaint',
      'description': 'This is a sample complaint for testing',
      'status': 'new',
      'priority': 'medium',
      'category': 'maintenance',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    await _firestoreService.setDocument(
        'owner_complaints',
        'sample_complaint_${DateTime.now().millisecondsSinceEpoch}',
        complaintData);
  }

  Future<void> _createSampleBike(String ownerId, String pgId) async {
    final bikeData = {
      'ownerId': ownerId,
      'pgId': pgId,
      'guestId': 'sample_guest_id',
      'bikeNumber': 'TS09AB1234',
      'model': 'Honda Activa',
      'color': 'White',
      'status': 'active',
      'parkingSlot': 'A-01',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    await _firestoreService.setDocument('owner_bikes',
        'sample_bike_${DateTime.now().millisecondsSinceEpoch}', bikeData);
  }

  Future<void> _createSampleService(String ownerId, String pgId) async {
    final serviceData = {
      'ownerId': ownerId,
      'pgId': pgId,
      'guestId': 'sample_guest_id',
      'title': 'Sample Service Request',
      'description': 'This is a sample service request for testing',
      'type': 'cleaning',
      'status': 'new',
      'priority': 'medium',
      'roomNumber': '101',
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    await _firestoreService.setDocument('owner_services',
        'sample_service_${DateTime.now().millisecondsSinceEpoch}', serviceData);
  }
}
