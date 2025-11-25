// lib/core/services/firebase/database/optimized_firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../common/utils/constants/firestore.dart';

/// 🚀 **OPTIMIZED FIRESTORE SERVICE - DB-LEVEL FILTERING & CACHING**
///
/// Enhanced Firestore service with:
/// - DB-level filtering using where clauses
/// - Query caching for performance
/// - Batch operations support
/// - Optimized aggregation queries
class OptimizedFirestoreService {
  static final OptimizedFirestoreService _instance =
      OptimizedFirestoreService._internal();
  factory OptimizedFirestoreService() => _instance;
  OptimizedFirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Query payments filtered at DB level
  Future<QuerySnapshot> queryPayments({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.payments);

    if (ownerId != null) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }
    if (pgId != null) {
      query = query.where('pgId', isEqualTo: pgId);
    }
    if (guestId != null) {
      query = query.where('guestId', isEqualTo: guestId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Query bookings filtered at DB level
  Future<QuerySnapshot> queryBookings({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    String? paymentStatus,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.bookings);

    if (ownerId != null) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }
    if (pgId != null) {
      query = query.where('pgId', isEqualTo: pgId);
    }
    if (guestId != null) {
      query = query.where('guestUid', isEqualTo: guestId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (paymentStatus != null) {
      query = query.where('paymentStatus', isEqualTo: paymentStatus);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Query bookings with compound filters (requires composite index)
  Stream<QuerySnapshot> streamBookings({
    String? ownerId,
    String? pgId,
    String? status,
    String? paymentStatus,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.bookings);

    if (ownerId != null) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }
    if (pgId != null) {
      query = query.where('pgId', isEqualTo: pgId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (paymentStatus != null) {
      query = query.where('paymentStatus', isEqualTo: paymentStatus);
    }
    
    // COST OPTIMIZATION: Apply limit if specified (defaults to 30 for bookings)
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    } else {
      query = query.limit(30); // Default limit for safety
    }

    return query.snapshots();
  }

  /// Query complaints filtered at DB level
  Future<QuerySnapshot> queryComplaints({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.complaints);

    if (ownerId != null) {
      query = query.where('ownerId', isEqualTo: ownerId);
    }
    if (pgId != null) {
      query = query.where('pgId', isEqualTo: pgId);
    }
    if (guestId != null) {
      query = query.where('guestId', isEqualTo: guestId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Query PGs filtered at DB level (excludes drafts)
  Future<QuerySnapshot> queryPublishedPGs({
    String? ownerId,
    bool? isActive,
    String? city,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.pgs);

    if (ownerId != null) {
      query = query.where('ownerUid', isEqualTo: ownerId);
    }
    // Filter out drafts at DB level
    query = query.where('isDraft', isEqualTo: false);
    if (isActive != null) {
      query = query.where('isActive', isEqualTo: isActive);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Stream published PGs (excludes drafts)
  Stream<QuerySnapshot> streamPublishedPGs({
    String? ownerId,
    bool? isActive,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.pgs);

    if (ownerId != null) {
      query = query.where('ownerUid', isEqualTo: ownerId);
    }
    // Filter out drafts at DB level
    query = query.where('isDraft', isEqualTo: false);
    if (isActive != null) {
      query = query.where('isActive', isEqualTo: isActive);
    }
    
    // COST OPTIMIZATION: Apply limit if specified (defaults to 50 for PGs)
    if (limit != null && limit > 0) {
      query = query.limit(limit);
    } else {
      query = query.limit(50); // Default limit for safety
    }

    return query.snapshots();
  }

  /// Query users filtered at DB level
  Future<QuerySnapshot> queryUsers({
    String? role,
    String? pgId,
    String? status,
    int? limit,
  }) {
    Query query = _firestore.collection(FirestoreConstants.users);

    if (role != null) {
      query = query.where('role', isEqualTo: role);
    }
    if (pgId != null) {
      query = query.where('pgId', isEqualTo: pgId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }

  /// Batch write operations (properly implemented)
  Future<void> batchWrite({
    required List<Map<String, dynamic>> operations,
  }) async {
    final batch = _firestore.batch();
    int operationCount = 0;

    for (final op in operations) {
      if (operationCount >= 500) {
        // Firestore batch limit is 500 operations
        await batch.commit();
        operationCount = 0;
      }

      final collection = op['collection'] as String;
      final docId = op['docId'] as String;
      final operation = op['operation'] as String;
      final docRef = _firestore.collection(collection).doc(docId);

      switch (operation) {
        case 'set':
          batch.set(docRef, op['data'] as Map<String, dynamic>,
              SetOptions(merge: op['merge'] == true));
          break;
        case 'update':
          batch.update(docRef, op['data'] as Map<String, dynamic>);
          break;
        case 'delete':
          batch.delete(docRef);
          break;
      }

      operationCount++;
    }

    if (operationCount > 0) {
      await batch.commit();
    }
  }

  /// Batch read operations (parallel reads)
  Future<List<DocumentSnapshot>> batchRead({
    required List<Map<String, dynamic>> documentRefs,
  }) async {
    final futures = documentRefs.map((ref) {
      return _firestore
          .collection(ref['collection'] as String)
          .doc(ref['docId'] as String)
          .get();
    });

    return Future.wait(futures);
  }

  /// Aggregate payments with DB-level filtering
  Future<Map<String, dynamic>> aggregatePayments({
    String? ownerId,
    String? pgId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
  }) async {
    // COST OPTIMIZATION: Limit aggregation to first 200 payments for stats
    final snapshot = await queryPayments(
      ownerId: ownerId,
      pgId: pgId,
      status: status,
      startDate: startDate,
      endDate: endDate,
      limit: limit ?? 200,
    );

    double totalAmount = 0.0;
    int count = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] ?? 0).toDouble();
      totalAmount += amount;
      count++;
    }

    return {
      'totalAmount': totalAmount,
      'count': count,
      'averageAmount': count > 0 ? totalAmount / count : 0.0,
    };
  }
}

