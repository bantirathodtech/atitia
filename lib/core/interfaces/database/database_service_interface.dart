// lib/core/interfaces/database/database_service_interface.dart

import 'package:cloud_firestore/cloud_firestore.dart';

/// Abstract interface for database operations
/// Implementations: Firebase (Firestore), Supabase, REST API
/// Allows swapping data sources without changing repository code
abstract class IDatabaseService {
  /// Gets a single document by collection and document ID
  Future<DocumentSnapshot> getDocument(String collection, String documentId);

  /// Streams a single document for real-time updates
  Stream<DocumentSnapshot> getDocumentStream(
      String collection, String documentId);

  /// Sets/creates a document in a collection
  Future<void> setDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  );

  /// Updates an existing document
  Future<void> updateDocument(
    String collection,
    String documentId,
    Map<String, dynamic> data,
  );

  /// Deletes a document
  Future<void> deleteDocument(String collection, String documentId);

  /// Streams a collection with optional filter
  Stream<QuerySnapshot> getCollectionStream(String collection, {int? limit});

  /// Streams a collection filtered by a single field
  Stream<QuerySnapshot> getCollectionStreamWithFilter(
    String collection,
    String field,
    dynamic value, {
    int? limit,
  });

  /// Streams a collection with compound filters
  Stream<QuerySnapshot> getCollectionStreamWithCompoundFilter(
    String collection,
    List<Map<String, dynamic>> filters, {
    int? limit,
  });

  /// Generates a new document ID
  String generateDocumentId();

  /// Batch write operations
  Future<void> batchWrite(List<Map<String, dynamic>> operations);

  /// Query with multiple conditions
  Future<QuerySnapshot> queryCollection(
    String collection,
    List<Map<String, dynamic>> filters, {
    String? orderBy,
    bool descending = false,
    int? limit,
  });

  /// Query documents with a single where-equal filter (legacy support)
  Future<QuerySnapshot> queryDocuments(
    String collection, {
    required String field,
    required dynamic isEqualTo,
    int? limit,
  });
}
