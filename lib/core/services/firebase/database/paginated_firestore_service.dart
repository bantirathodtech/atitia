// lib/core/services/firebase/database/paginated_firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../common/utils/constants/firestore.dart';

/// 🚀 **PAGINATED FIRESTORE SERVICE - EFFICIENT PAGINATION**
///
/// Provides efficient pagination for Firestore queries
/// Prevents loading all documents at once

/// Paginated query result
class PaginatedResult<T> {
  final List<T> items;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;
  final int totalFetched;

  PaginatedResult({
    required this.items,
    this.lastDocument,
    required this.hasMore,
    required this.totalFetched,
  });
}

class PaginatedFirestoreService {
  static final PaginatedFirestoreService _instance =
      PaginatedFirestoreService._internal();
  factory PaginatedFirestoreService() => _instance;
  PaginatedFirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int _defaultPageSize = 20;
  static const int _maxPageSize = 50;

  /// Query with pagination support
  Future<PaginatedResult<DocumentSnapshot>> queryPaginated({
    required String collection,
    List<Map<String, dynamic>>? filters,
    String? orderBy,
    bool descending = false,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? startAfterDocument,
  }) async {
    // Limit page size to prevent memory issues
    final limitedPageSize =
        pageSize > _maxPageSize ? _maxPageSize : pageSize;

    Query query = _firestore.collection(collection);

    // Apply filters
    if (filters != null) {
      for (var filter in filters) {
        query = query.where(
          filter['field'] as String,
          isEqualTo: filter['value'],
        );
      }
    }

    // Apply orderBy
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Apply pagination
    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    // Limit results
    query = query.limit(limitedPageSize + 1); // Fetch one extra to check if more exists

    final snapshot = await query.get();

    final hasMore = snapshot.docs.length > limitedPageSize;
    final items = hasMore
        ? snapshot.docs.take(limitedPageSize).toList()
        : snapshot.docs.toList();
    final lastDocument = items.isNotEmpty ? items.last : null;

    return PaginatedResult<DocumentSnapshot>(
      items: items,
      lastDocument: lastDocument,
      hasMore: hasMore,
      totalFetched: items.length,
    );
  }

  /// Stream paginated results with real-time updates
  Stream<PaginatedResult<DocumentSnapshot>> streamPaginated({
    required String collection,
    List<Map<String, dynamic>>? filters,
    String? orderBy,
    bool descending = false,
    int pageSize = _defaultPageSize,
  }) {
    Query query = _firestore.collection(collection);

    // Apply filters
    if (filters != null) {
      for (var filter in filters) {
        query = query.where(
          filter['field'] as String,
          isEqualTo: filter['value'],
        );
      }
    }

    // Apply orderBy
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Limit results
    query = query.limit(pageSize);

    return query.snapshots().map((snapshot) {
      return PaginatedResult<DocumentSnapshot>(
        items: snapshot.docs,
        lastDocument: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
        hasMore: snapshot.docs.length >= pageSize,
        totalFetched: snapshot.docs.length,
      );
    });
  }

  /// Query payments with pagination
  Future<PaginatedResult<DocumentSnapshot>> queryPaymentsPaginated({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? startAfterDocument,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerId', 'value': ownerId});
    }
    if (pgId != null) {
      filters.add({'field': 'pgId', 'value': pgId});
    }
    if (guestId != null) {
      filters.add({'field': 'guestId', 'value': guestId});
    }
    if (status != null) {
      filters.add({'field': 'status', 'value': status});
    }

    return queryPaginated(
      collection: FirestoreConstants.payments,
      filters: filters.isEmpty ? null : filters,
      orderBy: 'date',
      descending: true,
      pageSize: pageSize,
      startAfterDocument: startAfterDocument,
    );
  }

  /// Query bookings with pagination
  Future<PaginatedResult<DocumentSnapshot>> queryBookingsPaginated({
    String? ownerId,
    String? pgId,
    String? guestId,
    String? status,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? startAfterDocument,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerId', 'value': ownerId});
    }
    if (pgId != null) {
      filters.add({'field': 'pgId', 'value': pgId});
    }
    if (guestId != null) {
      filters.add({'field': 'guestUid', 'value': guestId});
    }
    if (status != null) {
      filters.add({'field': 'status', 'value': status});
    }

    return queryPaginated(
      collection: FirestoreConstants.bookings,
      filters: filters.isEmpty ? null : filters,
      orderBy: 'createdAt',
      descending: true,
      pageSize: pageSize,
      startAfterDocument: startAfterDocument,
    );
  }

  /// Query PGs with pagination
  Future<PaginatedResult<DocumentSnapshot>> queryPGsPaginated({
    String? ownerId,
    String? city,
    bool? isActive,
    int pageSize = _defaultPageSize,
    DocumentSnapshot? startAfterDocument,
  }) async {
    final filters = <Map<String, dynamic>>[];
    if (ownerId != null) {
      filters.add({'field': 'ownerUid', 'value': ownerId});
    }
    if (city != null) {
      filters.add({'field': 'city', 'value': city});
    }
    if (isActive != null) {
      filters.add({'field': 'isActive', 'value': isActive});
    }
    // Always exclude drafts
    filters.add({'field': 'isDraft', 'value': false});

    return queryPaginated(
      collection: FirestoreConstants.pgs,
      filters: filters,
      orderBy: 'createdAt',
      descending: true,
      pageSize: pageSize,
      startAfterDocument: startAfterDocument,
    );
  }
}

