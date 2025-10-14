// lib/core/repositories/owner_payment_details_repository.dart

import '../di/firebase/di/firebase_service_locator.dart';
import '../../common/utils/constants/firestore.dart';
import '../models/owner_payment_details_model.dart';

/// Repository for managing owner payment details
/// Handles bank account, UPI, and QR code information
class OwnerPaymentDetailsRepository {
  final _firestoreService = getIt.firestore;
  final _analyticsService = getIt.analytics;

  /// Save or update owner payment details
  Future<void> savePaymentDetails(OwnerPaymentDetailsModel details) async {
    try {
      await _firestoreService.setDocument(
        FirestoreConstants.ownerPaymentDetails,
        details.ownerId,
        details.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_payment_details_saved',
        parameters: {
          'owner_id': details.ownerId,
          'has_bank': details.hasBankDetails ? 'true' : 'false',
          'has_upi': details.hasUpiDetails ? 'true' : 'false',
        },
      );
    } catch (e) {
      throw Exception('Failed to save payment details: $e');
    }
  }

  /// Get owner payment details
  Future<OwnerPaymentDetailsModel?> getPaymentDetails(String ownerId) async {
    try {
      final doc = await _firestoreService.getDocument(
        FirestoreConstants.ownerPaymentDetails,
        ownerId,
      );

      if (!doc.exists) {
        return null;
      }

      return OwnerPaymentDetailsModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get payment details: $e');
    }
  }

  /// Stream owner payment details for real-time updates
  Stream<OwnerPaymentDetailsModel?> streamPaymentDetails(String ownerId) {
    return _firestoreService
        .getDocumentStream(FirestoreConstants.ownerPaymentDetails, ownerId)
        .map((doc) {
      if (!doc.exists) {
        return null;
      }
      return OwnerPaymentDetailsModel.fromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Delete owner payment details
  Future<void> deletePaymentDetails(String ownerId) async {
    try {
      await _firestoreService.deleteDocument(
        FirestoreConstants.ownerPaymentDetails,
        ownerId,
      );

      await _analyticsService.logEvent(
        name: 'owner_payment_details_deleted',
        parameters: {'owner_id': ownerId},
      );
    } catch (e) {
      throw Exception('Failed to delete payment details: $e');
    }
  }
}

