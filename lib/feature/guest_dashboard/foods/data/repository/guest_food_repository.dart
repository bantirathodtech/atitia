// lib/features/guest_dashboard/foods/repository/guest_food_repository.dart
import 'package:atitia/core/di/firebase/di/firebase_service_locator.dart'
    hide getIt;

import '../../../../../common/utils/constants/firestore.dart';
import '../../../../../core/di/firebase/container/firebase_dependency_container.dart';
import '../models/guest_food_model.dart';

/// Repository layer for guest food data operations
/// Uses GetIt service locator for Firebase service access
/// Handles Firestore operations for food menu items
class GuestFoodRepository {
  // Get Firestore service through GetIt service locator
  final _firestoreService = getIt.firestore;

  /// Streams all available food items with real-time updates
  /// Returns a stream of food lists for reactive UI updates
  Stream<List<GuestFoodModel>> getAllFoodsStream() {
    return _firestoreService
        .getCollectionStream(FirestoreConstants.foods)
        .map((snapshot) => snapshot.docs
            .map((doc) => GuestFoodModel.fromMap(
                  doc.data()! as Map<String, dynamic>,
                ))
            .toList());
  }

  /// Retrieves a specific food item by its document ID
  /// Returns null if the food item doesn't exist
  Future<GuestFoodModel?> getFoodById(String foodId) async {
    final doc = await _firestoreService.getDocument(
      FirestoreConstants.foods,
      foodId,
    );

    if (!doc.exists) return null;

    return GuestFoodModel.fromMap(
      doc.data()! as Map<String, dynamic>,
    );
  }
}
