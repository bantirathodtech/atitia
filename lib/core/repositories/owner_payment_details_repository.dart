// lib/core/repositories/owner_payment_details_repository.dart

import '../di/common/unified_service_locator.dart';
import '../../common/utils/constants/firestore.dart';
import '../interfaces/analytics/analytics_service_interface.dart';
import '../interfaces/database/database_service_interface.dart';
import '../models/owner_payment_details_model.dart';

/// Repository for managing owner payment details
/// Handles bank account, UPI, and QR code information
/// Uses interface-based services for dependency injection (swappable backends)
class OwnerPaymentDetailsRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerPaymentDetailsRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Save or update owner payment details
  Future<void> savePaymentDetails(OwnerPaymentDetailsModel details) async {
    try {
      await _databaseService.setDocument(
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
      final doc = await _databaseService.getDocument(
        FirestoreConstants.ownerPaymentDetails,
        ownerId,
      );

      if (!doc.exists) {
        return null;
      }

      return OwnerPaymentDetailsModel.fromMap(
          doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get payment details: $e');
    }
  }

  /// Stream owner payment details for real-time updates
  Stream<OwnerPaymentDetailsModel?> streamPaymentDetails(String ownerId) {
    return _databaseService
        .getDocumentStream(FirestoreConstants.ownerPaymentDetails, ownerId)
        .map((doc) {
      if (!doc.exists) {
        return null;
      }
      return OwnerPaymentDetailsModel.fromMap(
          doc.data() as Map<String, dynamic>);
    });
  }

  /// Delete owner payment details
  Future<void> deletePaymentDetails(String ownerId) async {
    try {
      await _databaseService.deleteDocument(
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
