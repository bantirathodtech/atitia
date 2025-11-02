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
  Stream<QuerySnapshot> getCollectionStream(String collection) {
    return _firestoreService.getCollectionStream(collection);
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithFilter(
    String collection,
    String field,
    dynamic value,
  ) {
    return _firestoreService.getCollectionStreamWithFilter(
        collection, field, value);
  }

  @override
  Stream<QuerySnapshot> getCollectionStreamWithCompoundFilter(
    String collection,
    List<Map<String, dynamic>> filters,
  ) {
    return _firestoreService.getCollectionStreamWithCompoundFilter(
      collection,
      filters,
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
    // Use FirestoreServiceWrapper's batch capabilities if available
    // For now, delegate to individual operations
    for (final op in operations) {
      final collection = op['collection'] as String;
      final docId = op['docId'] as String;
      final operation = op['operation'] as String;

      switch (operation) {
        case 'set':
          await _firestoreService.setDocument(
            collection,
            docId,
            op['data'] as Map<String, dynamic>,
          );
          break;
        case 'update':
          await _firestoreService.updateDocument(
            collection,
            docId,
            op['data'] as Map<String, dynamic>,
          );
          break;
        case 'delete':
          await _firestoreService.deleteDocument(collection, docId);
          break;
      }
    }
  }

  @override
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    required String field,
    required dynamic isEqualTo,
  }) {
    return _firestoreService.queryDocuments(
      collection,
      field: field,
      isEqualTo: isEqualTo,
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
    // Use compound filter stream and get first snapshot
    // This is a simplified implementation
    return getCollectionStreamWithCompoundFilter(collection, conditions).first;
  }
}
