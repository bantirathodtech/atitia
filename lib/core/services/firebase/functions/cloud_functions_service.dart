import 'package:cloud_functions/cloud_functions.dart';

/// Firebase Cloud Functions service for server-side logic.
///
/// Responsibility:
/// - Call cloud functions from the app
/// - Handle server-side business logic
/// - Process complex operations
class CloudFunctionsServiceWrapper {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  CloudFunctionsServiceWrapper._privateConstructor();
  static final CloudFunctionsServiceWrapper _instance =
      CloudFunctionsServiceWrapper._privateConstructor();
  factory CloudFunctionsServiceWrapper() => _instance;

  /// Initialize Cloud Functions service
  Future<void> initialize() async {
    // Cloud Functions initializes automatically
    await Future.delayed(Duration.zero);
  }

  /// Set functions emulator for development
  void useEmulator({String host = 'localhost', int port = 5001}) {
    _functions.useFunctionsEmulator(host, port);
  }

  /// Call a cloud function with parameters
  Future<HttpsCallableResult> callFunction(
    String name, {
    Map<String, dynamic>? parameters,
  }) async {
    final callable = _functions.httpsCallable(name);
    return await callable.call(parameters);
  }

  /// Call user creation function
  Future<HttpsCallableResult> createUserProfile(
      Map<String, dynamic> userData) async {
    return await callFunction('createUserProfile', parameters: userData);
  }

  /// Call property verification function
  Future<HttpsCallableResult> verifyProperty(String propertyId) async {
    return await callFunction('verifyProperty',
        parameters: {'propertyId': propertyId});
  }

  /// Call payment processing function
  Future<HttpsCallableResult> processPayment(
      Map<String, dynamic> paymentData) async {
    return await callFunction('processPayment', parameters: paymentData);
  }
}
