// lib/common/widgets/pagination/firestore_pagination_helper.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'pagination_controller.dart';

/// Helper class for creating pagination controllers with Firestore queries
class FirestorePaginationHelper {
  /// Create a pagination controller for a Firestore query
  static PaginationController<T> createController<T>({
    required Query query,
    required T Function(DocumentSnapshot doc) documentMapper,
    int pageSize = 20,
  }) {
    return PaginationController<T>(
      queryFunction: (q) => q.get(),
      documentMapper: documentMapper,
      pageSize: pageSize,
      baseQuery: query,
    );
  }

  /// Create a pagination controller for a Firestore query with custom query function
  /// Useful for queries that need additional processing
  static PaginationController<T> createControllerWithFunction<T>({
    required Query query,
    required T Function(DocumentSnapshot doc) documentMapper,
    required Future<QuerySnapshot> Function(Query query) queryFunction,
    int pageSize = 20,
  }) {
    return PaginationController<T>(
      queryFunction: queryFunction,
      documentMapper: documentMapper,
      pageSize: pageSize,
      baseQuery: query,
    );
  }

  /// Create a pagination controller that automatically applies limits
  static PaginationController<T> createLimitedController<T>({
    required Query query,
    required T Function(DocumentSnapshot doc) documentMapper,
    int pageSize = 20,
  }) {
    // Ensure query has limit applied
    Query limitedQuery = query.limit(pageSize);

    return PaginationController<T>(
      queryFunction: (q) => q.get(),
      documentMapper: documentMapper,
      pageSize: pageSize,
      baseQuery: limitedQuery,
    );
  }
}
