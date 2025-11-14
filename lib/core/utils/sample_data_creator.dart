// lib/core/utils/sample_data_creator.dart

import '../di/firebase/di/firebase_service_locator.dart';
import '../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';
import '../../feature/guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../models/booking_model.dart';

/// Sample data creator for testing and development
/// Creates sample PGs, food menus, and bookings for testing
class SampleDataCreator {
  final _firestoreService = getIt.firestore;
  final _analyticsService = getIt.analytics;

  /// Creates sample data for testing
  /// This should only be called during development/testing
  Future<void> createSampleData(String userId) async {
    try {
      // Create sample PG
      final samplePgId = await _createSamplePG();

      // Create sample food menu for the PG
      await _createSampleFoodMenu(userId, samplePgId);

      // Create sample booking for the user
      await _createSampleBooking(userId, samplePgId);

      _analyticsService.logEvent(
        name: 'sample_data_created',
        parameters: {
          'user_id': userId,
          'pg_id': samplePgId,
        },
      );
    } catch (e) {
      _analyticsService.logEvent(
        name: 'sample_data_creation_failed',
        parameters: {
          'user_id': userId,
          'error': e.toString(),
        },
      );
    }
  }

  /// Creates a sample PG for testing
  Future<String> _createSamplePG() async {
    final pgId = 'sample_pg_${DateTime.now().millisecondsSinceEpoch}';

    final samplePG = GuestPgModel(
      pgId: pgId,
      ownerUid: 'sample_owner_123',
      pgName: 'Premium PG Residence',
      address: '123 Main Street, Downtown',
      city: 'Mumbai',
      state: 'Maharashtra',
      area: 'Andheri West',
      amenities: [
        'WiFi',
        'AC',
        'Parking',
        'Laundry',
        'Security',
        'Power Backup'
      ],
      photos: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500',
      ],
      bankDetails: {
        'accountNumber': '1234567890',
        'ifscCode': 'SBIN0001234',
        'accountHolderName': 'Sample Owner',
      },
      contactNumber: '+91 9876543210',
      description:
          'A premium PG with all modern amenities including WiFi, AC, and delicious food.',
      pgType: 'Boys PG',
      mealType: 'Veg & Non-Veg',
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestoreService.setDocument(
      'pgs',
      pgId,
      samplePG.toMap(),
    );

    return pgId;
  }

  /// Creates a sample food menu for the PG
  Future<void> _createSampleFoodMenu(String ownerId, String pgId) async {
    final menuId = 'sample_menu_${DateTime.now().millisecondsSinceEpoch}';

    final sampleMenu = OwnerFoodMenu(
      menuId: menuId,
      ownerId: ownerId,
      pgId: pgId,
      day: 'Monday',
      breakfast: ['Bread Butter', 'Tea', 'Banana'],
      lunch: ['Rice', 'Dal', 'Sabzi', 'Chapati'],
      dinner: ['Rice', 'Dal', 'Sabzi', 'Chapati'],
      photoUrls: [],
      isActive: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestoreService.setDocument(
      'owner_weekly_menus',
      menuId,
      sampleMenu.toMap(),
    );
  }

  /// Creates a sample booking for the user
  Future<void> _createSampleBooking(String userId, String pgId) async {
    final bookingId = 'sample_booking_${DateTime.now().millisecondsSinceEpoch}';

    final sampleBooking = BookingModel(
      bookingId: bookingId,
      guestId: userId,
      ownerId: 'sample_owner_123',
      pgId: pgId,
      bedId: 'bed_1',
      roomId: 'room_1',
      floorId: 'floor_1',
      pgName: 'Premium PG Residence',
      roomNumber: '101',
      bedNumber: '1',
      sharingType: 2,
      rentPerMonth: 8000.0,
      securityDeposit: 8000.0,
      bookingDate: DateTime.now(),
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 30)),
      status: 'confirmed',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _firestoreService.setDocument(
      'bookings',
      bookingId,
      sampleBooking.toMap(),
    );
  }
}
