// lib/common/utils/pg/pg_price_utils.dart

/// 🎨 **PG PRICE UTILITIES - REUSABLE HELPER**
///
/// Utility functions for extracting and working with PG pricing data
class PgPriceUtils {
  /// Extract minimum rent from rentConfig
  /// Returns the lowest price from all sharing options
  static double? getMinRent(Map<String, dynamic>? rentConfig) {
    if (rentConfig == null || rentConfig.isEmpty) return null;

    final prices = <double>[];
    if (rentConfig['oneShare'] != null) {
      prices.add((rentConfig['oneShare'] as num).toDouble());
    }
    if (rentConfig['twoShare'] != null) {
      prices.add((rentConfig['twoShare'] as num).toDouble());
    }
    if (rentConfig['threeShare'] != null) {
      prices.add((rentConfig['threeShare'] as num).toDouble());
    }
    if (rentConfig['fourShare'] != null) {
      prices.add((rentConfig['fourShare'] as num).toDouble());
    }
    if (rentConfig['fiveShare'] != null) {
      prices.add((rentConfig['fiveShare'] as num).toDouble());
    }

    return prices.isNotEmpty ? prices.reduce((a, b) => a < b ? a : b) : null;
  }

  /// Extract maximum rent from rentConfig
  /// Returns the highest price from all sharing options
  static double? getMaxRent(Map<String, dynamic>? rentConfig) {
    if (rentConfig == null || rentConfig.isEmpty) return null;

    final prices = <double>[];
    if (rentConfig['oneShare'] != null) {
      prices.add((rentConfig['oneShare'] as num).toDouble());
    }
    if (rentConfig['twoShare'] != null) {
      prices.add((rentConfig['twoShare'] as num).toDouble());
    }
    if (rentConfig['threeShare'] != null) {
      prices.add((rentConfig['threeShare'] as num).toDouble());
    }
    if (rentConfig['fourShare'] != null) {
      prices.add((rentConfig['fourShare'] as num).toDouble());
    }
    if (rentConfig['fiveShare'] != null) {
      prices.add((rentConfig['fiveShare'] as num).toDouble());
    }

    return prices.isNotEmpty ? prices.reduce((a, b) => a > b ? a : b) : null;
  }

  /// Calculate overall min and max rent from a list of PGs
  static Map<String, double> getOverallPriceRange(
      List<Map<String, dynamic>?> rentConfigs) {
    final allPrices = <double>[];
    for (final config in rentConfigs) {
      final minPrice = getMinRent(config);
      final maxPrice = getMaxRent(config);
      if (minPrice != null) allPrices.add(minPrice);
      if (maxPrice != null) allPrices.add(maxPrice);
    }

    if (allPrices.isEmpty) {
      return {'min': 0.0, 'max': 100000.0};
    }

    allPrices.sort();
    return {
      'min': allPrices.first,
      'max': allPrices.last,
    };
  }
}
