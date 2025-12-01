// lib/core/interfaces/transaction/transaction_service_interface.dart

/// Abstract interface for transaction services
/// Allows swapping between Firebase Firestore transactions and other implementations
/// This enables unit testing without Firebase initialization
abstract class ITransactionService {
  /// Run a transaction with automatic retries
  Future<T> runTransaction<T>(
    Future<T> Function(dynamic transaction) updateFunction, {
    int maxAttempts = 5,
  });

  /// Approve booking request atomically
  Future<void> approveBookingRequestTransactionally({
    required String requestId,
    required String collection,
    required Map<String, dynamic> requestUpdate,
    required Map<String, dynamic>? guestUpdate,
    required Map<String, dynamic>? bookingData,
    String? bookingCollection,
    String? bookingId,
  });

  /// Access to underlying firestore instance (if needed)
  dynamic get firestore;
}
