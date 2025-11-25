// lib/core/repositories/food_feedback_repository.dart

import '../di/common/unified_service_locator.dart';
import '../interfaces/analytics/analytics_service_interface.dart';
import '../interfaces/database/database_service_interface.dart';

/// Repository to record and aggregate simple food feedback (like/dislike)
/// Schema: collection `food_feedback`
///   - doc id: auto
///   - fields: pgId, date (yyyy-MM-dd), meal (breakfast|lunch|dinner),
///             guestId, value (+1 like, -1 dislike), createdAt
/// Uses interface-based services for dependency injection (swappable backends)
class FoodFeedbackRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  static const String collection = 'food_feedback';

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  FoodFeedbackRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  Future<void> submitFeedback({
    required String pgId,
    required String guestId,
    required String dateKey,
    required String meal,
    required int value, // +1 or -1
  }) async {
    final docId = DateTime.now().millisecondsSinceEpoch.toString();
    await _databaseService.setDocument(collection, docId, {
      'pgId': pgId,
      'guestId': guestId,
      'dateKey': dateKey, // formatted yyyy-MM-dd
      'meal': meal,
      'value': value,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    });

    await _analyticsService.logEvent(
      name: 'food_feedback_submitted',
      parameters: {
        'pg_id': pgId,
        'meal': meal,
        'value': value,
      },
    );
  }

  /// Returns a stream of aggregate likes/dislikes per meal for a given date
  Stream<Map<String, Map<String, int>>> streamAggregates({
    required String pgId,
    required String dateKey,
  }) {
    // COST OPTIMIZATION: Limit to 200 feedback entries per stream (covers multiple days)
    return _databaseService.getCollectionStream(collection, limit: 200).map((snapshot) {
      final entries =
          snapshot.docs.map((d) => d.data() as Map<String, dynamic>).where(
                (m) => m['pgId'] == pgId && m['dateKey'] == dateKey,
              );

      final Map<String, Map<String, int>> agg = {
        'breakfast': {'likes': 0, 'dislikes': 0},
        'lunch': {'likes': 0, 'dislikes': 0},
        'dinner': {'likes': 0, 'dislikes': 0},
      };

      for (final m in entries) {
        final meal = (m['meal'] ?? '').toString();
        final val = (m['value'] ?? 0) as int;
        if (agg.containsKey(meal)) {
          if (val >= 1) {
            agg[meal]!['likes'] = (agg[meal]!['likes'] ?? 0) + 1;
          } else if (val <= -1) {
            agg[meal]!['dislikes'] = (agg[meal]!['dislikes'] ?? 0) + 1;
          }
        }
      }

      return agg;
    });
  }
}
