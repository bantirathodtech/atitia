// lib/feature/owner_dashboard/featured/viewmodel/owner_featured_listing_viewmodel.dart

import 'dart:async';

import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/utils/exceptions/exceptions.dart';
import '../../../../../common/utils/logging/logging_mixin.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/models/featured/featured_listing_model.dart';
import '../../../../../core/repositories/featured/featured_listing_repository.dart';
import '../../../../../core/services/payment/app_subscription_payment_service.dart';
import '../../profile/data/repository/owner_profile_repository.dart';
import '../../../../../core/interfaces/auth/viewmodel_auth_service_interface.dart';
import '../../../../../core/adapters/auth/authentication_service_wrapper_adapter.dart';

/// ViewModel for managing featured listings for owner's PGs
/// Handles featured listing purchase, cancellation, and management
class OwnerFeaturedListingViewModel extends BaseProviderState
    with LoggingMixin {
  final FeaturedListingRepository _featuredRepo;
  final OwnerProfileRepository _profileRepo;
  final AppSubscriptionPaymentService _paymentService;
  final IViewModelAuthService _authService;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  /// Constructor with dependency injection
  OwnerFeaturedListingViewModel({
    FeaturedListingRepository? featuredRepo,
    OwnerProfileRepository? profileRepo,
    AppSubscriptionPaymentService? paymentService,
    IViewModelAuthService? authService,
  })  : _featuredRepo = featuredRepo ?? FeaturedListingRepository(),
        _profileRepo = profileRepo ?? OwnerProfileRepository(),
        _paymentService = paymentService ?? AppSubscriptionPaymentService(),
        _authService = authService ?? AuthenticationServiceWrapperAdapter();

  List<FeaturedListingModel> _featuredListings = [];
  final Map<String, FeaturedListingModel?> _pgFeaturedListings =
      {}; // pgId -> active featured listing
  StreamSubscription<List<FeaturedListingModel>>? _featuredListingsStream;
  bool _isProcessingPayment = false;
  bool _isCancelling = false;

  /// Read-only featured listings list
  List<FeaturedListingModel> get featuredListings => _featuredListings;

  /// Get active featured listing for a specific PG
  FeaturedListingModel? getFeaturedListingForPG(String pgId) {
    return _pgFeaturedListings[pgId];
  }

  /// Check if a PG is currently featured
  bool isPGFeatured(String pgId) {
    final listing = _pgFeaturedListings[pgId];
    return listing != null && listing.isActive;
  }

  /// Check if payment is being processed
  bool get isProcessingPayment => _isProcessingPayment;

  /// Check if featured listing is being cancelled
  bool get isCancelling => _isCancelling;

  /// Get current owner ID
  String? get currentOwnerId => _authService.currentUserId;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  void dispose() {
    _featuredListingsStream?.cancel();
    _paymentService.dispose();
    super.dispose();
  }

  /// Initialize ViewModel - load featured listings and start streaming
  Future<void> initialize() async {
    try {
      setLoading(true);
      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      await _loadFeaturedListings(ownerId);
      _startFeaturedListingsStream(ownerId);

      logInfo(
        'Featured listing ViewModel initialized',
        feature: 'featured_listing',
        metadata: {'owner_id': ownerId},
      );
    } catch (e) {
      final exception = AppException(
        message: _text(
            'featuredListingLoadFailed', 'Failed to load featured listings'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to initialize featured listing ViewModel',
        feature: 'featured_listing',
        error: e,
      );
    } finally {
      setLoading(false);
    }
  }

  /// Load all featured listings for owner
  Future<void> _loadFeaturedListings(String ownerId) async {
    try {
      // Get initial featured listings from stream
      final stream = _featuredRepo.streamOwnerFeaturedListings(ownerId);
      _featuredListings = await stream.first;
      _updatePGFeaturedListings();
      notifyListeners();
    } catch (e) {
      logError(
        'Failed to load featured listings',
        feature: 'featured_listing',
        error: e,
      );
      rethrow;
    }
  }

  /// Update map of PG to featured listing
  void _updatePGFeaturedListings() {
    _pgFeaturedListings.clear();
    for (final listing in _featuredListings) {
      if (listing.isActive) {
        _pgFeaturedListings[listing.pgId] = listing;
      }
    }
  }

  /// Start real-time featured listings stream
  void _startFeaturedListingsStream(String ownerId) {
    _featuredListingsStream?.cancel();
    _featuredListingsStream =
        _featuredRepo.streamOwnerFeaturedListings(ownerId).listen(
      (listings) {
        _featuredListings = listings;
        _updatePGFeaturedListings();
        notifyListeners();
      },
      onError: (error) {
        logError(
          'Featured listings stream error',
          feature: 'featured_listing',
          error: error,
        );
      },
    );
  }

  /// Purchase featured listing for a PG
  Future<void> purchaseFeaturedListing({
    required String pgId,
    required int durationMonths,
    Function(String)? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      if (_isProcessingPayment) {
        throw AppException(
          message: _text('paymentInProgress', 'Payment already in progress'),
          severity: ErrorSeverity.medium,
        );
      }

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      // Get owner profile for payment details
      final profile = await _profileRepo.getOwnerProfile(ownerId);
      if (profile == null) {
        throw AppException(
          message: _text('profileNotFound', 'Profile not found'),
          severity: ErrorSeverity.high,
        );
      }

      _isProcessingPayment = true;
      notifyListeners();

      _analyticsService.logEvent(
        name: 'featured_listing_purchase_initiated',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId,
          'duration_months': durationMonths.toString(),
          'amount': FeaturedListingModel.getPriceForDuration(durationMonths)
              .toString(),
        },
      );

      await _paymentService.initialize();

      await _paymentService.processFeaturedListingPayment(
        ownerId: ownerId,
        pgId: pgId,
        durationMonths: durationMonths,
        userName: profile.fullName,
        userEmail: profile.email,
        userPhone: profile.phoneNumber,
        onSuccess: (featuredListingId) async {
          _isProcessingPayment = false;
          notifyListeners();

          _analyticsService.logEvent(
            name: 'featured_listing_purchase_success',
            parameters: {
              'owner_id': ownerId,
              'featured_listing_id': featuredListingId,
              'pg_id': pgId,
            },
          );

          // Reload featured listings
          await _loadFeaturedListings(ownerId);

          onSuccess?.call(featuredListingId);
        },
        onFailure: (error) async {
          _isProcessingPayment = false;
          notifyListeners();

          _analyticsService.logEvent(
            name: 'featured_listing_purchase_failed',
            parameters: {
              'owner_id': ownerId,
              'pg_id': pgId,
              'error': error,
            },
          );

          onFailure?.call(error);
        },
      );
    } catch (e) {
      _isProcessingPayment = false;
      notifyListeners();

      final exception = AppException(
        message: _text('featuredListingPurchaseFailed',
            'Failed to purchase featured listing'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to purchase featured listing',
        feature: 'featured_listing',
        error: e,
      );
      onFailure?.call(exception.toString());
    }
  }

  /// Cancel featured listing
  Future<void> cancelFeaturedListing({
    required String featuredListingId,
    Function()? onSuccess,
    Function(String)? onFailure,
  }) async {
    try {
      if (_isCancelling) {
        throw AppException(
          message: _text(
              'cancellationInProgress', 'Cancellation already in progress'),
          severity: ErrorSeverity.medium,
        );
      }

      final ownerId = currentOwnerId;
      if (ownerId == null || ownerId.isEmpty) {
        throw AppException(
          message: _text('ownerIdNotAvailable', 'Owner ID not available'),
          severity: ErrorSeverity.high,
        );
      }

      final listing = await _featuredRepo.getFeaturedListing(featuredListingId);
      if (listing == null) {
        throw AppException(
          message:
              _text('featuredListingNotFound', 'Featured listing not found'),
          severity: ErrorSeverity.medium,
        );
      }

      if (listing.ownerId != ownerId) {
        throw AppException(
          message: _text('unauthorized',
              'Unauthorized: Featured listing does not belong to you'),
          severity: ErrorSeverity.high,
        );
      }

      _isCancelling = true;
      notifyListeners();

      _analyticsService.logEvent(
        name: 'featured_listing_cancellation_initiated',
        parameters: {
          'owner_id': ownerId,
          'featured_listing_id': featuredListingId,
          'pg_id': listing.pgId,
        },
      );

      final updatedListing = listing.copyWith(
        status: FeaturedListingStatus.cancelled,
      );

      await _featuredRepo.updateFeaturedListing(updatedListing);

      _isCancelling = false;
      notifyListeners();

      // Reload featured listings
      await _loadFeaturedListings(ownerId);

      _analyticsService.logEvent(
        name: 'featured_listing_cancelled',
        parameters: {
          'owner_id': ownerId,
          'featured_listing_id': featuredListingId,
        },
      );

      onSuccess?.call();
    } catch (e) {
      _isCancelling = false;
      notifyListeners();

      final exception = AppException(
        message: _text('featuredListingCancellationFailed',
            'Failed to cancel featured listing'),
        details: e.toString(),
      );
      setError(true, exception.toString());
      logError(
        'Failed to cancel featured listing',
        feature: 'featured_listing',
        error: e,
      );
      onFailure?.call(exception.toString());
    }
  }

  /// Refresh featured listings
  Future<void> refresh() async {
    final ownerId = currentOwnerId;
    if (ownerId != null && ownerId.isNotEmpty) {
      await _loadFeaturedListings(ownerId);
    }
  }

  /// Get featured listings for a specific PG
  List<FeaturedListingModel> getFeaturedListingsForPG(String pgId) {
    return _featuredListings.where((listing) => listing.pgId == pgId).toList()
      ..sort((a, b) {
        final aDate = a.createdAt ?? DateTime(1970);
        final bDate = b.createdAt ?? DateTime(1970);
        return bDate.compareTo(aDate);
      });
  }
}
