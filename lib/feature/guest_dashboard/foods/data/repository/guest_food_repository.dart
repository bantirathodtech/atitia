// lib/features/guest_dashboard/foods/repository/guest_food_repository.dart
import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../models/guest_food_model.dart';

/// Repository layer for guest food data operations
/// Uses interface-based services for dependency injection (swappable backends)
/// Handles Firestore operations for food menu items
class GuestFoodRepository {
  final IDatabaseService _databaseService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  GuestFoodRepository({
    IDatabaseService? databaseService,
  }) : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database;

  /// Streams all available food items with real-time updates
  /// Returns a stream of food lists for reactive UI updates
  Stream<List<GuestFoodModel>> getAllFoodsStream() {
    // COST OPTIMIZATION: Limit to 50 food items per stream
    return _databaseService
        .getCollectionStream(FirestoreConstants.foods, limit: 50)
        .map((snapshot) => snapshot.docs
            .map((doc) => GuestFoodModel.fromMap(
                  doc.data()! as Map<String, dynamic>,
                ))
            .toList());
  }

  /// Retrieves a specific food item by its document ID
  /// Returns null if the food item doesn't exist
  Future<GuestFoodModel?> getFoodById(String foodId) async {
    final doc = await _databaseService.getDocument(
      FirestoreConstants.foods,
      foodId,
    );

    if (!doc.exists) return null;

    return GuestFoodModel.fromMap(
      doc.data()! as Map<String, dynamic>,
    );
  }
}
