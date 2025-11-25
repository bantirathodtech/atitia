// lib/core/adapters/firebase/firebase_database_adapter.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../interfaces/database/database_service_interface.dart';
import '../../services/firebase/database/firestore_database_service.dart';

/// Adapter that wraps Firebase FirestoreServiceWrapper to implement IDatabaseService
/// This allows using Firebase implementation through the interface
class FirebaseDatabaseAdapter implements IDatabaseService {
  final FirestoreServiceWrapper _firestoreService;

  FirebaseDatabaseAdapter(this._firestoreService);

  @override
  Future<DocumentSnapshot> getDocument(String collection, String documentId) {
    return _firestoreService.getDocument(collection, documentId);
  }

  @override
  Stream<DocumentSnapshot> getDocumentStream(
      String collection, String documentId) {
    return _firestoreService.getDocumentStream(collection, documentId);
  }

  @override
  Future<void> setDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _firestoreService.setDocument(collection, documentId, data);
  }

  @override
  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  ) {
    return _firestoreService.updateDocument(collection, documentId, data);
  }

  @override
  Future<void> deleteDocument(String collection, String documentId) {
    return _firestoreService.deleteDocument(collection, documentId);
  }

  @override
  Stream<QuerySnapshot> getCollectionStream(String collection, {int? limit}) {
    return _firestoreService.getCollectionStream(collection, limit: limit);
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithFilter(
    String collection,
    String field,
    dynamic value, {
    int? limit,
  }) {
    return _firestoreService
        .getCollectionStreamWithFilter(collection, field, value, limit: limit);
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithCompoundFilter(
    String collection,
    List<Map<String, dynamic>> filters, {
    int? limit,
  }) {
    return _firestoreService.getCollectionStreamWithCompoundFilter(
      collection,
      filters,
      limit: limit,
    );
  }

  @override
  String generateDocumentId() {
    // Generate a Firestore document ID using FirebaseFirestore directly
    // This creates a document reference just to get an auto-generated ID
    return FirebaseFirestore.instance.collection('_temp').doc().id;
  }

  @override
  Future<void> batchWrite(List<Map<String, dynamic>> operations) async {
    // OPTIMIZED: Use proper Firestore batch writes
    if (operations.isEmpty) return;

    final firestore = FirebaseFirestore.instance;
    int batchCount = 0;
    WriteBatch? batch;

    for (final op in operations) {
      // Firestore batch limit is 500 operations
      if (batchCount % 500 == 0) {
        if (batch != null) {
          await batch.commit();
        }
        batch = firestore.batch();
      }

      final collection = op['collection'] as String;
      final docId = op['docId'] as String;
      final operation = op['operation'] as String;
      final docRef = firestore.collection(collection).doc(docId);

      switch (operation) {
        case 'set':
          batch!.set(
            docRef,
            op['data'] as Map<String, dynamic>,
            SetOptions(merge: op['merge'] == true),
          );
          break;
        case 'update':
          batch!.update(docRef, op['data'] as Map<String, dynamic>);
          break;
        case 'delete':
          batch!.delete(docRef);
          break;
      }

      batchCount++;
    }

    // Commit remaining operations
    if (batch != null && batchCount % 500 != 0) {
      await batch.commit();
    }
  }

  @override
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    required String field,
    required dynamic isEqualTo,
    int? limit,
  }) {
    return _firestoreService.queryDocuments(
      collection,
      field: field,
      isEqualTo: isEqualTo,
      limit: limit,
    );
  }

  @override
  Future<QuerySnapshot> queryCollection(
    String collection,
    List<Map<String, dynamic>> conditions, {
    String? orderBy,
    bool descending = false,
    int? limit,
  }) {
    // OPTIMIZED: Use queryDocumentsWithFilters and apply orderBy/limit
    Query query = FirebaseFirestore.instance.collection(collection);

    // Apply filters
    for (var condition in conditions) {
      query = query.where(
        condition['field'] as String,
        isEqualTo: condition['value'],
      );
    }

    // Apply orderBy if specified
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Apply limit if specified
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.get();
  }
}
