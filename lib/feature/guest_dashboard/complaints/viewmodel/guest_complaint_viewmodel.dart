// lib/features/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart

import 'dart:async';
import 'dart:io';

import '../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';
import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../data/models/guest_complaint_model.dart';
import '../data/repository/guest_complaint_repository.dart';
import '../../../../core/interfaces/auth/viewmodel_auth_service_interface.dart';
import '../../../../core/adapters/auth/authentication_service_wrapper_adapter.dart';

/// ViewModel for managing guest complaints UI state and business logic
/// Extends BaseProviderState for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestComplaintViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final GuestComplaintRepository _repository;
  final IViewModelAuthService _authService;
  final _analyticsService = getIt.analytics;

  /// Constructor with dependency injection
  /// If repository is not provided, creates it with default services
  GuestComplaintViewModel({
    GuestComplaintRepository? repository,
    IViewModelAuthService? authService,
  })  : _repository = repository ?? GuestComplaintRepository(),
        _authService = authService ?? AuthenticationServiceWrapperAdapter();

  List<GuestComplaintModel> _complaints = [];
  StreamSubscription<List<GuestComplaintModel>>? _complaintsSubscription;

  /// Read-only list of guest complaints for UI consumption
  List<GuestComplaintModel> get complaints => _complaints;

  /// Loads complaints for the current authenticated guest user
  /// Sets up real-time stream listener for complaint updates
  void loadComplaints([String? guestId]) {
    // Cancel existing subscription if any
    _complaintsSubscription?.cancel();

    // Get guestId from auth service if not provided
    final userId = guestId ?? _authService.currentUserId ?? '';

    if (userId.isEmpty) {
      _complaints = [];
      notifyListeners();
      return;
    }

    setLoading(true);
    clearError();

    // Listen to real-time complaint updates
    _complaintsSubscription = _repository.getComplaintsForGuest(userId).listen(
      (complaintList) {
        _complaints = complaintList;
        setLoading(false);
        notifyListeners();
      },
      onError: (error) {
        setError(true, 'Failed to load complaints: ${error.toString()}');
        setLoading(false);
        notifyListeners();
        _analyticsService.logEvent(
          name: 'complaint_load_error',
          parameters: {'error': error.toString()},
        );
      },
    );

    // Register subscription for automatic cleanup
    if (_complaintsSubscription != null) {
      addSubscription(_complaintsSubscription!);
    }
  }

  /// Submits a new complaint to the repository
  /// Handles loading state during submission process
  Future<void> submitComplaint(GuestComplaintModel complaint) async {
    try {
      setLoading(true);
      await _repository.addComplaint(complaint);
    } catch (e) {
      setError(true, 'Failed to submit complaint: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Updates an existing complaint in the repository
  /// Used for status changes or complaint modifications
  Future<void> updateComplaint(GuestComplaintModel complaint) async {
    try {
      setLoading(true);
      await _repository.updateComplaint(complaint);
    } catch (e) {
      setError(true, 'Failed to update complaint: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Uploads a complaint image and returns the download URL
  /// Handles image upload to Cloud Storage with proper path organization
  Future<String> uploadComplaintImage(
    String guestId,
    String complaintId,
    File file,
  ) async {
    try {
      setLoading(true);
      clearError();
      final url =
          await _repository.uploadComplaintImage(guestId, complaintId, file);
      _analyticsService.logEvent(
        name: 'complaint_image_uploaded',
        parameters: {'complaintId': complaintId},
      );
      return url;
    } catch (e) {
      setError(true, 'Failed to upload image: ${e.toString()}');
      _analyticsService.logEvent(
        name: 'complaint_image_upload_failed',
        parameters: {'error': e.toString()},
      );
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  /// Refreshes complaints list
  void refreshComplaints([String? guestId]) {
    loadComplaints(guestId);
  }

  @override
  void dispose() {
    disposeAll(); // Clean up all subscriptions and timers
    super.dispose();
  }
}
