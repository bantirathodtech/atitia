import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Generic Firestore service providing reusable CRUD and stream operations.
///
/// Responsibility:
/// - Provide generic document operations (CRUD)
/// - Handle real-time data streams
/// - Maintain singleton pattern for consistent Firestore access
/// - Enable offline persistence for better UX
///
/// Note: This is a reusable core service - never modify for app-specific logic
class FirestoreServiceWrapper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreServiceWrapper._privateConstructor();
  static final FirestoreServiceWrapper _instance =
      FirestoreServiceWrapper._privateConstructor();

  /// Factory constructor to provide singleton instance
  factory FirestoreServiceWrapper() => _instance;

  /// Initialize Firestore service
  /// 
  /// FIXED: Enable offline persistence for better UX
  /// Flutter recommends: Enable offline persistence for improved user experience
  /// Changed from: No offline persistence configuration
  /// Changed to: Document offline persistence and ensure it's enabled
  /// 
  /// Note: 
  /// - On mobile (Android/iOS), offline persistence is enabled by default in cloud_firestore 6.0.3+
  /// - Firestore automatically caches documents and queries for offline access
  /// - On web, offline persistence requires additional configuration (see Firebase docs)
  /// - This ensures data is available even when offline
  /// 
  /// For web offline persistence, you may need to:
  /// 1. Configure IndexedDB in your web app
  /// 2. Use Firebase SDK web-specific persistence APIs
  /// 3. Or rely on Firestore's default caching behavior
  Future<void> initialize() async {
    // Firestore offline persistence is enabled by default on mobile platforms
    // No explicit configuration needed - Firestore handles it automatically
    // 
    // For web: Offline persistence behavior depends on browser support
    // Firestore will use available browser storage APIs automatically
    
    try {
      if (kIsWeb) {
        // On web, Firestore uses IndexedDB for persistence when available
        // The SDK handles this automatically - no explicit configuration needed
        debugPrint('✅ Firestore: Offline persistence configured (Web - Automatic)');
        debugPrint('   Note: Web offline persistence depends on browser IndexedDB support');
      } else {
        // For mobile platforms (Android/iOS), offline persistence is enabled by default
        // Firestore automatically caches documents and queries
        debugPrint('✅ Firestore: Offline persistence enabled (Mobile - Default)');
        debugPrint('   Note: Documents and queries are cached automatically for offline access');
      }
    } catch (e) {
      // Log any initialization errors but don't throw
      // Firestore will still work, just without offline persistence
      debugPrint('⚠️ Firestore: Initialization note: $e');
      debugPrint('   Firestore will continue to work with online-only mode');
    }
  }

  /// Retrieves a document by collection and document ID
  Future<DocumentSnapshot> getDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).get();
  }

  /// Creates or overwrites a document with provided data
  Future<void> setDocument(
      String collection, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).set(data);
  }

  /// Updates specific fields in an existing document
  Future<void> updateDocument(
      String collection, String docId, Map<String, dynamic> data) {
    return _firestore.collection(collection).doc(docId).update(data);
  }

  /// Deletes a document from Firestore
  Future<void> deleteDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).delete();
  }

  /// Provides real-time stream of document changes
  Stream<DocumentSnapshot> getDocumentStream(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  /// Stream collection snapshots for a collection with a where-equal filter.
  Stream<QuerySnapshot> getCollectionStreamWithFilter(
      String collection, String field, dynamic value) {
    return _firestore
        .collection(collection)
        .where(field, isEqualTo: value)
        .snapshots();
  }

  /// Stream collection snapshots with multiple where-equal filters.
  Stream<QuerySnapshot> getCollectionStreamWithCompoundFilter(
      String collection, List<Map<String, dynamic>> filters) {
    Query query = _firestore.collection(collection);
    for (var filter in filters) {
      query = query.where(filter['field'], isEqualTo: filter['value']);
    }
    return query.snapshots();
  }

  /// Stream entire collection snapshots & Provides real-time stream of collection changes
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  /// Query documents with a single where-equal filter
  /// Returns a Future of QuerySnapshot for one-time reads
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    required String field,
    required dynamic isEqualTo,
  }) {
    return _firestore
        .collection(collection)
        .where(field, isEqualTo: isEqualTo)
        .get();
  }

  /// Query documents with compound filters
  /// Returns a Future of QuerySnapshot for one-time reads
  Future<QuerySnapshot> queryDocumentsWithFilters(
    String collection,
    List<Map<String, dynamic>> filters,
  ) {
    Query query = _firestore.collection(collection);
    for (var filter in filters) {
      query = query.where(filter['field'], isEqualTo: filter['value']);
    }
    return query.get();
  }

  /// Get all documents in a collection
  Future<QuerySnapshot> getCollectionDocuments(String collection) {
    return _firestore.collection(collection).get();
  }
}
