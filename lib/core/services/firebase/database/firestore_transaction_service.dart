// firestore_transaction_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling Firestore transactions
/// Ensures atomic operations for critical business logic
class FirestoreTransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Access Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Run a transaction with automatic retries
  /// Use this for operations that must be atomic (e.g., booking approval)
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction transaction) updateFunction, {
    int maxAttempts = 5,
  }) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        return await _firestore.runTransaction<T>(
          (transaction) => updateFunction(transaction),
        );
      } catch (e) {
        attempts++;
        // Log error (transaction will be logged by repository if needed)

        if (attempts >= maxAttempts) {
          rethrow;
        }

        // Exponential backoff
        await Future.delayed(Duration(milliseconds: 100 * (1 << attempts)));
      }
    }
    throw Exception('Transaction failed after $maxAttempts attempts');
  }

  /// Approve booking request atomically
  /// Updates request status, creates booking, and updates guest assignment in one transaction
  Future<void> approveBookingRequestTransactionally({
    required String requestId,
    required String collection,
    required Map<String, dynamic> requestUpdate,
    required Map<String, dynamic>? guestUpdate,
    required Map<String, dynamic>? bookingData,
    String? bookingCollection,
    String? bookingId,
  }) async {
    await runTransaction<void>((transaction) async {
      // Get request document
      final requestRef = _firestore.collection(collection).doc(requestId);
      final requestDoc = await transaction.get(requestRef);

      if (!requestDoc.exists) {
        throw Exception('Booking request not found');
      }

      final requestData = requestDoc.data();
      final currentStatus = requestData?['status'] as String?;

      // Check if already approved/rejected (prevent duplicate approvals)
      if (currentStatus != 'pending' && currentStatus != null) {
        throw Exception('Booking request already processed');
      }

      // Update request status
      transaction.update(requestRef, requestUpdate);

      // Update guest assignment if provided
      if (guestUpdate != null &&
          requestData != null &&
          requestData['guestId'] != null) {
        final guestRef = _firestore
            .collection('users')
            .doc(requestData['guestId'] as String);
        transaction.update(guestRef, guestUpdate);
      }

      // Create booking if provided
      if (bookingData != null &&
          bookingCollection != null &&
          bookingId != null) {
        final bookingRef =
            _firestore.collection(bookingCollection).doc(bookingId);
        transaction.set(bookingRef, bookingData);
      }
    });
  }
}
