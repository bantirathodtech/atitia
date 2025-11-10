// lib/features/owner_dashboard/overview/viewmodel/owner_overview_view_model.dart

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../common/utils/logging/logging_mixin.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../core/services/localization/internationalization_service.dart';
import '../data/models/owner_overview_model.dart';
import '../data/repository/owner_overview_repository.dart';

/// ViewModel for fetching and managing owner overview dashboard data
/// Extends BaseProviderState for automatic service access and state management
/// Handles owner analytics, property statistics, revenue data, and real-time updates
class OwnerOverviewViewModel extends BaseProviderState with LoggingMixin {
  final OwnerOverviewRepository _repository;
  final _analyticsService = getIt.analytics;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

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

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  OwnerOverviewViewModel({
    OwnerOverviewRepository? repository,
  }) : _repository = repository ?? OwnerOverviewRepository();

  OwnerOverviewModel? _overviewData;
  Map<String, double>? _monthlyBreakdown;
  Map<String, double>? _propertyBreakdown;
  int _selectedYear = DateTime.now().year;

  /// Read-only overview data for UI consumption
  OwnerOverviewModel? get overviewData => _overviewData;

  /// Monthly revenue breakdown
  Map<String, double>? get monthlyBreakdown => _monthlyBreakdown;

  /// Property-wise revenue breakdown
  Map<String, double>? get propertyBreakdown => _propertyBreakdown;

  /// Selected year for reports
  int get selectedYear => _selectedYear;

  /// Loads overview data from Firestore via repository
  /// Handles one-time data fetch for dashboard initialization
  /// If pgId is provided, loads data for that specific PG only
  Future<void> loadOverviewData(String ownerId, {String? pgId}) async {
    logMethodEntry(
      'loadOverviewData',
      parameters: {'ownerId': ownerId, 'pgId': pgId},
      feature: 'owner_overview',
    );

    try {
      setLoading(true);
      clearError();

      logInfo(
        'Loading owner overview data',
        feature: 'owner_overview',
        metadata: {'ownerId': ownerId, 'pgId': pgId ?? 'all'},
      );

      _overviewData =
          await _repository.fetchOwnerOverviewData(ownerId, pgId: pgId);

      logInfo(
        'Owner overview data loaded successfully',
        feature: 'owner_overview',
        metadata: {
          'ownerId': ownerId,
          'pgId': pgId ?? 'all',
          'hasProperties': _overviewData?.hasProperties ?? false,
          'totalBeds': _overviewData?.totalBeds ?? 0,
          'occupiedBeds': _overviewData?.occupiedBeds ?? 0,
        },
      );

      _analyticsService.logEvent(
        name: 'owner_overview_loaded',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'has_properties': (_overviewData?.hasProperties ?? false)
              ? 'true'
              : 'false', // Convert boolean to string
          'total_beds': _overviewData?.totalBeds ?? 0,
          'occupied_beds': _overviewData?.occupiedBeds ?? 0,
        },
      );
    } catch (e) {
      final logMessage =
          _text('ownerOverviewLoadFailed', 'Failed to load overview data');
      logError(
        logMessage,
        feature: 'owner_overview',
        error: e,
        metadata: {'ownerId': ownerId, 'pgId': pgId},
      );
      setError(
        true,
        _text(
          'ownerOverviewLoadFailedWithReason',
          'Failed to load overview data: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    } finally {
      setLoading(false);
      logMethodExit('loadOverviewData');
    }
  }

  /// Sets up real-time overview data streaming
  /// Provides live updates for dashboard metrics
  void startOverviewStream(String ownerId) {
    setLoading(true);
    clearError();

    _repository.getOverviewDataStream(ownerId).listen(
      (data) {
        _overviewData = data;
        setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        setError(
          true,
          _text(
            'ownerOverviewStreamFailedWithReason',
            'Failed to stream overview data: {error}',
            parameters: {'error': error.toString()},
          ),
        );
        setLoading(false);
      },
    );
  }

  /// Loads monthly revenue breakdown
  Future<void> loadMonthlyBreakdown(String ownerId, int year) async {
    try {
      setLoading(true);
      clearError();
      _monthlyBreakdown =
          await _repository.getMonthlyRevenueBreakdown(ownerId, year);

      _analyticsService.logEvent(
        name: 'owner_monthly_breakdown_loaded',
        parameters: {
          'owner_id': ownerId,
          'year': year,
        },
      );

      notifyListeners();
    } catch (e) {
      setError(
        true,
        _text(
          'ownerMonthlyBreakdownLoadFailed',
          'Failed to load monthly breakdown: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  /// Loads property-wise revenue breakdown
  Future<void> loadPropertyBreakdown(String ownerId) async {
    try {
      setLoading(true);
      clearError();
      _propertyBreakdown =
          await _repository.getPropertyRevenueBreakdown(ownerId);

      _analyticsService.logEvent(
        name: 'owner_property_breakdown_loaded',
        parameters: {
          'owner_id': ownerId,
          'properties_count': _propertyBreakdown?.length ?? 0,
        },
      );

      notifyListeners();
    } catch (e) {
      setError(
        true,
        _text(
          'ownerPropertyBreakdownLoadFailed',
          'Failed to load property breakdown: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  /// Sets selected year for reports
  void setSelectedYear(int year) {
    _selectedYear = year;
    notifyListeners();

    _analyticsService.logEvent(
      name: 'owner_overview_year_changed',
      parameters: {'year': year},
    );
  }

  /// Refreshes all overview data
  /// If pgId is provided, refreshes data for that specific PG only
  Future<void> refreshOverviewData(String ownerId, {String? pgId}) async {
    await loadOverviewData(ownerId, pgId: pgId);
    await loadMonthlyBreakdown(ownerId, _selectedYear);
    await loadPropertyBreakdown(ownerId);

    _analyticsService.logEvent(
      name: 'owner_overview_refreshed',
      parameters: {
        'owner_id': ownerId,
        'pg_id': pgId ?? 'all',
      },
    );
  }

  /// Calculates occupancy rate based on active tenants and total capacity
  /// Returns occupancy percentage (0-100)
  double get occupancyRate => _overviewData?.occupancyRate ?? 0.0;

  /// Calculates average revenue per property
  /// Returns average revenue or 0 if no properties
  double get averageRevenuePerProperty =>
      _overviewData?.averageRevenuePerProperty ?? 0.0;

  /// Gets formatted revenue string with currency symbol
  String get formattedRevenue => _overviewData?.formattedTotalRevenue ?? '₹0';

  /// Gets formatted monthly revenue
  String get formattedMonthlyRevenue =>
      _overviewData?.formattedMonthlyRevenue ?? '₹0';

  /// Gets formatted occupancy rate
  String get formattedOccupancyRate =>
      _overviewData?.formattedOccupancyRate ?? '0%';

  /// Checks if owner has any properties registered
  bool get hasProperties => _overviewData?.hasProperties ?? false;

  /// Gets performance indicator color based on occupancy rate
  String get performanceIndicator =>
      _overviewData?.performanceIndicator ?? 'N/A';

  /// Checks if owner has pending bookings
  bool get hasPendingBookings => _overviewData?.hasPendingBookings ?? false;

  /// Checks if owner has pending complaints
  bool get hasPendingComplaints => _overviewData?.hasPendingComplaints ?? false;

  /// Gets total properties count
  int get totalProperties => _overviewData?.totalProperties ?? 0;

  /// Gets active tenants count
  int get activeTenants => _overviewData?.activeTenants ?? 0;

  /// Gets pending bookings count
  int get pendingBookings => _overviewData?.pendingBookings ?? 0;

  /// Gets pending complaints count
  int get pendingComplaints => _overviewData?.pendingComplaints ?? 0;
}
