// lib/feature/owner_dashboard/profile/viewmodel/owner_payment_details_viewmodel.dart

import 'package:flutter/foundation.dart';

import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/models/owner_payment_details_model.dart';
import '../../../../core/repositories/owner_payment_details_repository.dart';

/// ViewModel for managing owner payment details
/// Handles bank account, UPI, and QR code information
class OwnerPaymentDetailsViewModel extends ChangeNotifier {
  final OwnerPaymentDetailsRepository _repository = OwnerPaymentDetailsRepository();
  final _analyticsService = getIt.analytics;
  final _storageService = getIt.storage;

  OwnerPaymentDetailsModel? _paymentDetails;
  bool _loading = false;
  bool _saving = false;
  String? _error;

  // Getters
  OwnerPaymentDetailsModel? get paymentDetails => _paymentDetails;
  bool get loading => _loading;
  bool get saving => _saving;
  String? get error => _error;
  bool get hasPaymentDetails => _paymentDetails != null;
  bool get hasBankDetails => _paymentDetails?.hasBankDetails ?? false;
  bool get hasUpiDetails => _paymentDetails?.hasUpiDetails ?? false;

  /// Load payment details for an owner
  Future<void> loadPaymentDetails(String ownerId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _paymentDetails = await _repository.getPaymentDetails(ownerId);

      await _analyticsService.logEvent(
        name: 'owner_payment_details_loaded',
        parameters: {
          'owner_id': ownerId,
          'has_details': _paymentDetails != null ? 'true' : 'false',
        },
      );
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading payment details: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Save or update payment details
  Future<bool> savePaymentDetails(OwnerPaymentDetailsModel details) async {
    _saving = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.savePaymentDetails(details);
      _paymentDetails = details;

      await _analyticsService.logEvent(
        name: 'owner_payment_details_updated',
        parameters: {
          'owner_id': details.ownerId,
          'has_bank': details.hasBankDetails ? 'true' : 'false',
          'has_upi': details.hasUpiDetails ? 'true' : 'false',
        },
      );

      _saving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _saving = false;
      notifyListeners();
      debugPrint('❌ Error saving payment details: $e');
      return false;
    }
  }

  /// Upload UPI QR code image
  Future<String?> uploadQrCode(String ownerId, String filename, dynamic file) async {
    try {
      final folderPath = 'owner_payment_qr/$ownerId';
      final publicUrl = await _storageService.uploadFile(file, folderPath, filename);

      await _analyticsService.logEvent(
        name: 'owner_qr_code_uploaded',
        parameters: {'owner_id': ownerId},
      );

      return publicUrl;
    } catch (e) {
      debugPrint('❌ Error uploading QR code: $e');
      return null;
    }
  }

  /// Delete QR code image
  Future<bool> deleteQrCode(String qrCodeUrl) async {
    try {
      // Extract path from URL and delete from storage
      final uri = Uri.parse(qrCodeUrl);
      final path = uri.pathSegments.last;
      
      // Note: Supabase Storage delete method would go here
      // await _storageService.deleteFile(path);

      await _analyticsService.logEvent(
        name: 'owner_qr_code_deleted',
        parameters: {'url': qrCodeUrl},
      );

      return true;
    } catch (e) {
      debugPrint('❌ Error deleting QR code: $e');
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _paymentDetails = null;
    _loading = false;
    _saving = false;
    _error = null;
    notifyListeners();
  }
}

