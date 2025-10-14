// lib/features/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/lifecycle/state/provider_state.dart';
import '../../../auth/logic/auth_provider.dart';
import '../data/models/guest_complaint_model.dart';
import '../data/repository/guest_complaint_repository.dart';

/// ViewModel for managing guest complaints UI state and business logic
/// Extends BaseViewModel for automatic service access and state management
/// Coordinates between UI layer and Repository layer
class GuestComplaintViewModel extends BaseProviderState {
  final GuestComplaintRepository _repository = GuestComplaintRepository();

  List<GuestComplaintModel> _complaints = [];

  /// Read-only list of guest complaints for UI consumption
  List<GuestComplaintModel> get complaints => _complaints;

  /// Loads complaints for the current authenticated guest user
  /// Uses BuildContext to access AuthProvider for guestId
  /// Sets up real-time stream listener for complaint updates
  void loadComplaints(BuildContext context) {
    // Get guestId from AuthProvider
    final guestId =
        Provider.of<AuthProvider>(context, listen: false).user?.userId ?? '';

    if (guestId.isEmpty) {
      _complaints = [];
      notifyListeners();
      return;
    }

    setLoading(true);

    // Listen to real-time complaint updates
    _repository.getComplaintsForGuest(guestId).listen(
      (complaintList) {
        _complaints = complaintList;
        setLoading(false);
      },
      onError: (error) {
        setError(true, 'Failed to load complaints: $error');
        setLoading(false);
      },
    );
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
      return await _repository.uploadComplaintImage(guestId, complaintId, file);
    } catch (e) {
      setError(true, 'Failed to upload image: $e');
      rethrow;
    }
  }
}
