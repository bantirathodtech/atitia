// lib/common/widgets/pagination/pagination_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Controller for managing pagination state in Firestore queries
/// Handles loading, pagination, and state management
class PaginationController<T> extends ChangeNotifier {
  final Future<QuerySnapshot> Function(Query query) queryFunction;
  final T Function(DocumentSnapshot doc) documentMapper;

  List<T> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String? _error;

  DocumentSnapshot? _lastDocument;
  Query? _baseQuery;
  final int _pageSize;

  PaginationController({
    required this.queryFunction,
    required this.documentMapper,
    int pageSize = 20,
    Query? baseQuery,
  })  : _pageSize = pageSize,
        _baseQuery = baseQuery;

  /// Current list of items
  List<T> get items => List.unmodifiable(_items);

  /// Whether initial loading is in progress
  bool get isLoading => _isLoading;

  /// Whether more data can be loaded
  bool get hasMore => _hasMore;

  /// Whether more data is currently being loaded
  bool get isLoadingMore => _isLoadingMore;

  /// Current error, if any
  String? get error => _error;

  /// Total number of items loaded
  int get itemCount => _items.length;

  /// Whether there are any items
  bool get hasItems => _items.isNotEmpty;

  /// Load initial page of data
  Future<void> loadInitial() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final query = _buildQuery();
      final snapshot = await queryFunction(query);

      _items = snapshot.docs.map((doc) => documentMapper(doc)).toList();
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      _hasMore = snapshot.docs.length >= _pageSize;

      _error = null;
    } catch (e) {
      _error = e.toString();
      _items = [];
      _hasMore = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load next page of data
  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || _isLoading) return;
    if (_lastDocument == null) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final query = _buildQuery(startAfter: _lastDocument);
      final snapshot = await queryFunction(query);

      final newItems = snapshot.docs.map((doc) => documentMapper(doc)).toList();
      _items.addAll(newItems);
      _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      _hasMore = snapshot.docs.length >= _pageSize;

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Refresh data (reload from beginning)
  Future<void> refresh() async {
    _items = [];
    _lastDocument = null;
    _hasMore = true;
    _error = null;
    await loadInitial();
  }

  /// Update base query and reload
  Future<void> updateQuery(Query newQuery) async {
    _baseQuery = newQuery;
    await refresh();
  }

  /// Build query with pagination
  Query _buildQuery({DocumentSnapshot? startAfter}) {
    Query query = _baseQuery ?? FirebaseFirestore.instance.collection('');

    query = query.limit(_pageSize);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    return query;
  }

  /// Clear all data
  void clear() {
    _items = [];
    _lastDocument = null;
    _hasMore = true;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }
}
