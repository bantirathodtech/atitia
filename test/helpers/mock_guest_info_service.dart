// test/helpers/mock_guest_info_service.dart

import 'package:atitia/core/services/booking/guest_info_service.dart';
import 'package:atitia/feature/owner_dashboard/myguest/data/models/owner_guest_model.dart';

/// Mock implementation of GuestInfoService for unit tests
class MockGuestInfoService extends GuestInfoService {
  OwnerGuestModel? _mockGuest;
  Exception? _shouldThrow;

  MockGuestInfoService({
    super.databaseService,
  });

  void setMockGuest(OwnerGuestModel? guest) {
    _mockGuest = guest;
  }

  void setShouldThrow(Exception? error) {
    _shouldThrow = error;
  }

  @override
  Future<OwnerGuestModel?> getGuestByUid(String guestUid) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    return _mockGuest;
  }

  @override
  Future<Map<String, OwnerGuestModel>> getGuestsByUids(
      List<String> guestUids) async {
    if (_shouldThrow != null) throw _shouldThrow!;
    if (_mockGuest != null) {
      return {for (var uid in guestUids) uid: _mockGuest!};
    }
    return {};
  }
}
