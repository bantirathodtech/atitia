// lib/core/services/booking/guest_info_service.dart

import '../../../common/utils/constants/firestore.dart';
import '../../di/common/unified_service_locator.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../../feature/owner_dashboard/myguest/data/models/owner_guest_model.dart';

/// 🔍 **GUEST INFO SERVICE - REUSABLE CORE SERVICE**
///
/// Fetches guest information and booking details
/// Used for displaying guest info in bed maps, room cards, etc.
class GuestInfoService {
  final IDatabaseService _databaseService;

  GuestInfoService({
    IDatabaseService? databaseService,
  }) : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database;

  /// Fetches guest information by UID
  Future<OwnerGuestModel?> getGuestByUid(String guestUid) async {
    try {
      final guestDoc =
          await _databaseService.getDocument(FirestoreConstants.users, guestUid);

      if (!guestDoc.exists) {
        return null;
      }

      return OwnerGuestModel.fromFirestore(guestDoc);
    } catch (e) {
      return null;
    }
  }

  /// Fetches multiple guests by UIDs
  Future<Map<String, OwnerGuestModel>> getGuestsByUids(
      List<String> guestUids) async {
    final Map<String, OwnerGuestModel> guests = {};

    if (guestUids.isEmpty) {
      return guests;
    }

    try {
      // Fetch guests in parallel
      final futures = guestUids.map((uid) => getGuestByUid(uid));
      final results = await Future.wait(futures);

      for (var i = 0; i < guestUids.length; i++) {
        final guest = results[i];
        if (guest != null) {
          guests[guestUids[i]] = guest;
        }
      }
    } catch (e) {
      // Return partial results if some fail
    }

    return guests;
  }

  /// Fetches active booking for a guest
  /// Returns booking data as Map since OwnerBookingModel is in same file as OwnerGuestModel
  Future<Map<String, dynamic>?> getActiveBookingForGuest(
      String guestUid, String pgId) async {
    try {
      // Get bookings stream and find active booking
      // COST OPTIMIZATION: Limit to 20 bookings (active ones are usually recent)
      final bookingsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.bookings, 'guestUid', guestUid, limit: 20)
          .first;

      if (bookingsSnapshot.docs.isEmpty) {
        return null;
      }

      // Find active booking for this PG
      for (var doc in bookingsSnapshot.docs) {
        try {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null &&
              data['pgId'] == pgId &&
              (data['status'] == 'active' || data['status'] == 'approved')) {
            return data;
          }
        } catch (e) {
          // Skip invalid bookings
          continue;
        }
      }
    } catch (e) {
      // Return null on error
    }

    return null;
  }

  /// Fetches guests for a specific room
  Future<List<OwnerGuestModel>> getGuestsForRoom(
      String pgId, String roomNumber) async {
    try {
      // Get all guests streamed from users collection
      // COST OPTIMIZATION: Limit to 100 guests for room filtering
      final guestsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              FirestoreConstants.users, 'role', 'guest', limit: 100)
          .first;

      final guests = <OwnerGuestModel>[];

      for (var doc in guestsSnapshot.docs) {
        try {
          final guest = OwnerGuestModel.fromFirestore(doc);
          // Filter by PG and room
          if (guest.roomNumber == roomNumber &&
              guest.status == 'active' ||
              guest.status == 'payment_pending') {
            guests.add(guest);
          }
        } catch (e) {
          // Skip invalid guests
          continue;
        }
      }

      return guests;
    } catch (e) {
      return [];
    }
  }
}

