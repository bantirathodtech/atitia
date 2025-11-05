// lib/core/services/payment/razorpay_service.dart

import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../../common/utils/logging/logging_mixin.dart';

/// Razorpay payment service
/// Handles Razorpay payment processing
class RazorpayService with LoggingMixin {
  Razorpay? _razorpay;
  String? _currentOrderId;
  Function(String, PaymentSuccessResponse)? _onSuccess;
  Function(PaymentFailureResponse)? _onFailure;
  Function(ExternalWalletResponse)? _onExternalWallet;

  /// Initialize Razorpay
  /// Note: Razorpay key should be stored in environment config
  Future<void> initialize() async {
    try {
      // Get Razorpay key from environment config or Firestore
      // For now, using a placeholder - should be fetched from owner's PG settings
      _razorpay = Razorpay();
      _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

      logInfo(
        'Razorpay initialized successfully',
        feature: 'payment',
      );
    } catch (e) {
      logError(
        'Failed to initialize Razorpay',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  /// Open Razorpay payment
  /// [amount] - Payment amount in paise (e.g., 10000 = ₹100)
  /// [orderId] - Unique order ID
  /// [description] - Payment description
  /// [userName] - User name
  /// [userEmail] - User email
  /// [userPhone] - User phone
  /// [onSuccess] - Success callback
  /// [onFailure] - Failure callback
  Future<void> openPayment({
    required int amount,
    required String orderId,
    String? description,
    String? userName,
    String? userEmail,
    String? userPhone,
    Function(String, PaymentSuccessResponse)? onSuccess,
    Function(PaymentFailureResponse)? onFailure,
    Function(ExternalWalletResponse)? onExternalWallet,
  }) async {
    if (_razorpay == null) {
      await initialize();
    }

    _currentOrderId = orderId;
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onExternalWallet = onExternalWallet;

    try {
      // TODO: Get Razorpay key from owner's payment settings
      const razorpayKey = 'rzp_test_1DP5mmOlF5G5ag';

      final options = {
        'key': razorpayKey,
        'amount': amount, // Amount in paise
        'name': userName ?? 'Atitia PG',
        'description': description ?? 'PG Payment',
        'prefill': {
          'contact': userPhone ?? '',
          'email': userEmail ?? '',
        },
        'external': {
          'wallets': ['paytm'],
        },
      };

      _razorpay!.open(options);

      logInfo(
        'Razorpay payment opened',
        feature: 'payment',
        metadata: {
          'order_id': orderId,
          'amount': amount,
        },
      );
    } catch (e) {
      logError(
        'Failed to open Razorpay payment',
        feature: 'payment',
        error: e,
      );
      rethrow;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    logInfo(
      'Razorpay payment successful',
      feature: 'payment',
      metadata: {
        'payment_id': response.paymentId,
        'order_id': _currentOrderId,
        'signature': response.signature,
      },
    );

    if (_onSuccess != null && _currentOrderId != null) {
      _onSuccess!(_currentOrderId!, response);
    }

    _clearCallbacks();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    logError(
      'Razorpay payment failed',
      feature: 'payment',
      error: Exception(response.message),
      metadata: {
        'code': response.code.toString(),
        'message': response.message,
        'order_id': _currentOrderId,
      },
    );

    _onFailure?.call(response);
    _clearCallbacks();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    logInfo(
      'Razorpay external wallet selected',
      feature: 'payment',
      metadata: {
        'wallet_name': response.walletName,
        'order_id': _currentOrderId,
      },
    );

    _onExternalWallet?.call(response);
  }

  void _clearCallbacks() {
    _currentOrderId = null;
    _onSuccess = null;
    _onFailure = null;
    _onExternalWallet = null;
  }

  /// Dispose Razorpay instance
  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _clearCallbacks();
  }
}

