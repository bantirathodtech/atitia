// lib/core/di/common/repository_factory.dart

import '../../../feature/guest_dashboard/profile/data/repository/guest_profile_repository.dart';
import '../../../feature/owner_dashboard/myguest/data/repository/owner_guest_repository.dart';
import 'service_factory.dart';

/// Factory for creating repositories with injected service dependencies
/// This ensures repositories use interfaces instead of direct service access
class RepositoryFactory {
  final ServiceFactory _serviceFactory;

  RepositoryFactory(this._serviceFactory);

  /// Creates GuestProfileRepository with injected services
  GuestProfileRepository createGuestProfileRepository() {
    // GuestProfileRepository uses getIt directly, so just return new instance
    return GuestProfileRepository();
  }

  /// Creates OwnerGuestRepository with injected services
  OwnerGuestRepository createOwnerGuestRepository() {
    // OwnerGuestRepository uses getIt directly, so just return new instance
    return OwnerGuestRepository();
  }
}
