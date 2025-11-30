// test/helpers/mock_transaction_service.dart

import 'package:atitia/core/interfaces/transaction/transaction_service_interface.dart';

/// Mock Transaction Service for testing
/// Implements ITransactionService without requiring Firebase initialization
class MockTransactionService implements ITransactionService {
  @override
  Future<T> runTransaction<T>(
    Future<T> Function(dynamic transaction) updateFunction, {
    int maxAttempts = 5,
  }) async {
    // Mock implementation - execute the function with a mock transaction
    try {
      return await updateFunction(_MockTransaction());
    } catch (e) {
      // If the function expects a real transaction, return a default value
      return null as T;
    }
  }

  @override
  Future<void> approveBookingRequestTransactionally({
    required String requestId,
    required String collection,
    required Map<String, dynamic> requestUpdate,
    required Map<String, dynamic>? guestUpdate,
    required Map<String, dynamic>? bookingData,
    String? bookingCollection,
    String? bookingId,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  dynamic get firestore => _MockFirestore();
}

/// Mock Transaction for testing
class _MockTransaction {
  Future<dynamic> get(dynamic ref) async {
    return _MockDocumentSnapshot();
  }
}

/// Mock DocumentSnapshot for testing
class _MockDocumentSnapshot {
  bool get exists => true;
  Map<String, dynamic>? data() => {};
}

/// Mock Firestore object for testing
class _MockFirestore {
  dynamic collection(String path) => _MockCollectionReference();
}

/// Mock CollectionReference for testing
class _MockCollectionReference {
  dynamic doc(String path) => _MockDocumentReference();
}

/// Mock DocumentReference for testing
class _MockDocumentReference {
  // Mock methods that might be called
}

