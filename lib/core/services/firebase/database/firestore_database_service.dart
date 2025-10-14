import 'package:cloud_firestore/cloud_firestore.dart';

/// Generic Firestore service providing reusable CRUD and stream operations.
///
/// Responsibility:
/// - Provide generic document operations (CRUD)
/// - Handle real-time data streams
/// - Maintain singleton pattern for consistent Firestore access
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
  Future<void> initialize() async {
    // Firestore initializes automatically with Firebase.initializeApp()
    await Future.delayed(Duration.zero);
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
