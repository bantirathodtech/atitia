// lib/features/guest_dashboard/pgs/view/screens/guest_room_bed_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/drawers/guest_drawer.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import 'dart:async';
import '../../../../../core/repositories/booking_repository.dart';
import '../../../../../core/repositories/bed_change_request_repository.dart';
import '../../../../../core/models/bed_change_request_model.dart';
import '../../../../../core/models/booking_model.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../common/utils/logging/logging_mixin.dart';

/// Screen for guests to view their assigned room/bed and request changes
class GuestRoomBedScreen extends StatefulWidget {
  const GuestRoomBedScreen({super.key});

  @override
  State<GuestRoomBedScreen> createState() => _GuestRoomBedScreenState();
}

class _GuestRoomBedScreenState extends State<GuestRoomBedScreen>
    with LoggingMixin {
  final BookingRepository _bookingRepository = BookingRepository();
  final BedChangeRequestRepository _bedChangeRequestRepository =
      BedChangeRequestRepository();
  BookingModel? _booking;
  List<BedChangeRequestModel> _bedChangeRequests = [];
  StreamSubscription<List<BedChangeRequestModel>>?
      _bedChangeRequestSubscription;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoomBedInfo();
  }

  @override
  void dispose() {
    _bedChangeRequestSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadRoomBedInfo() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final guestId = authProvider.user?.userId ?? '';

      if (guestId.isEmpty) {
        setState(() {
          _error = 'User not authenticated';
          _loading = false;
        });
        return;
      }

      final booking = await _bookingRepository.getGuestActiveBooking(guestId);

      if (mounted) {
        setState(() {
          _booking = booking;
          _loading = false;
        });

        // Load bed change requests if booking exists
        if (booking != null) {
          _loadBedChangeRequests(guestId);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Failed to load room/bed information: $e';
          _loading = false;
        });
      }
    }
  }

  void _loadBedChangeRequests(String guestId) {
    _bedChangeRequestSubscription?.cancel();
    _bedChangeRequestSubscription =
        _bedChangeRequestRepository.streamGuestRequests(guestId).listen(
      (requests) {
        if (mounted) {
          setState(() {
            _bedChangeRequests = requests;
          });
        }
      },
      onError: (error) {
        logError('Failed to load bed change requests: $error');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'My Room & Bed',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRoomBedInfo,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: const GuestDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: AdaptiveLoader());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(text: 'Error'),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(text: _error!, align: TextAlign.center),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              label: 'Retry',
              onPressed: _loadRoomBedInfo,
            ),
          ],
        ),
      );
    }

    if (_booking == null) {
      return const Center(
        child: EmptyState(
          title: 'No Active Booking',
          message:
              'You don\'t have an active booking yet. Book a PG to get assigned a room and bed.',
          icon: Icons.bed_outlined,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomBedCard(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildBookingInfoCard(context),
          if (_bedChangeRequests.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingL),
            _buildBedChangeRequestsCard(context),
          ],
          const SizedBox(height: AppSpacing.paddingL),
          _buildRequestChangeSection(context),
        ],
      ),
    );
  }

  Widget _buildRoomBedCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AdaptiveCard(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.darkCard,
                    AppColors.darkCard.withValues(alpha: 0.8)
                  ]
                : [
                    theme.primaryColor,
                    theme.primaryColor.withValues(alpha: 0.7)
                  ],
          ),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Column(
          children: [
            Icon(
              Icons.hotel,
              size: 64,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            if (_booking!.roomNumber.isNotEmpty)
              HeadingMedium(
                text: 'Room ${_booking!.roomNumber}',
                color: AppColors.textOnPrimary,
              ),
            if (_booking!.bedNumber.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              HeadingMedium(
                text: 'Bed ${_booking!.bedNumber}',
                color: AppColors.textOnPrimary,
              ),
            ],
            if (_booking!.roomNumber.isEmpty && _booking!.bedNumber.isEmpty)
              HeadingMedium(
                text: 'Not Assigned',
                color: AppColors.textOnPrimary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfoCard(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmall(text: 'Booking Information'),
            const SizedBox(height: AppSpacing.paddingM),
            _buildInfoRow('PG Name', _booking!.pgName),
            _buildInfoRow('Start Date', _formatDate(_booking!.startDate)),
            if (_booking!.endDate != null)
              _buildInfoRow('End Date', _formatDate(_booking!.endDate!)),
            _buildInfoRow('Status', _booking!.status.toUpperCase()),
            if (_booking!.roomNumber.isNotEmpty)
              _buildInfoRow('Room', _booking!.roomNumber),
            if (_booking!.bedNumber.isNotEmpty)
              _buildInfoRow('Bed', _booking!.bedNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: '$label:', color: Colors.grey[600]),
          BodyText(text: value, medium: true),
        ],
      ),
    );
  }

  Widget _buildRequestChangeSection(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmall(text: 'Request Bed/Room Change'),
            const SizedBox(height: AppSpacing.paddingS),
            const BodyText(
              text:
                  'Need to change your room or bed? Submit a request and the owner will review it.',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(
              label: 'Request Change',
              icon: Icons.swap_horiz,
              onPressed: () => _showChangeRequestDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeRequestDialog(BuildContext context) {
    final reasonController = TextEditingController();
    final newRoomController = TextEditingController();
    final newBedController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Request Room/Bed Change'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText(
                text: 'Current Assignment:',
                medium: true,
              ),
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: _booking!.roomNumber.isNotEmpty &&
                        _booking!.bedNumber.isNotEmpty
                    ? 'Room ${_booking!.roomNumber}, Bed ${_booking!.bedNumber}'
                    : 'Not assigned',
              ),
              const SizedBox(height: AppSpacing.paddingL),
              TextField(
                controller: newRoomController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Room Number (Optional)',
                  hintText: 'Enter preferred room...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.door_front_door),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextField(
                controller: newBedController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Bed Number (Optional)',
                  hintText: 'Enter preferred bed...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason *',
                  hintText: 'Why do you need to change room/bed?',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Submit Request',
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for the change'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }

              final auth = Provider.of<AuthProvider>(context, listen: false);
              final guestId = auth.user?.userId ?? '';
              if (guestId.isEmpty || _booking == null) {
                return;
              }
              final request = BedChangeRequestModel(
                requestId:
                    '${guestId}_${DateTime.now().millisecondsSinceEpoch}',
                guestId: guestId,
                ownerId: _booking!.ownerId,
                pgId: _booking!.pgId,
                currentRoomNumber: _booking!.roomNumber,
                currentBedNumber: _booking!.bedNumber,
                preferredRoomNumber: newRoomController.text.trim().isEmpty
                    ? null
                    : newRoomController.text.trim(),
                preferredBedNumber: newBedController.text.trim().isEmpty
                    ? null
                    : newBedController.text.trim(),
                reason: reasonController.text.trim(),
              );
              final repo = BedChangeRequestRepository();
              await repo.createRequest(request);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Change request submitted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBedChangeRequestsCard(BuildContext context) {
    // Get the most recent request
    final recentRequest = _bedChangeRequests.first;
    final status = recentRequest.status.toLowerCase();
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusText = 'Approved';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = 'Rejected';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Pending';
        statusIcon = Icons.pending;
    }

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(text: 'Bed Change Request Status'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: BodyText(
                    text: statusText.toUpperCase(),
                    color: statusColor,
                    medium: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            if (recentRequest.preferredRoomNumber != null ||
                recentRequest.preferredBedNumber != null) ...[
              BodyText(
                text: 'Preferred:',
                medium: true,
                color: Colors.grey[700],
              ),
              const SizedBox(height: AppSpacing.paddingXS),
              BodyText(
                text: recentRequest.preferredRoomNumber != null &&
                        recentRequest.preferredBedNumber != null
                    ? 'Room ${recentRequest.preferredRoomNumber}, Bed ${recentRequest.preferredBedNumber}'
                    : recentRequest.preferredRoomNumber != null
                        ? 'Room ${recentRequest.preferredRoomNumber}'
                        : 'Bed ${recentRequest.preferredBedNumber}',
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],
            BodyText(
              text: 'Reason:',
              medium: true,
              color: Colors.grey[700],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            BodyText(text: recentRequest.reason),
            if (recentRequest.decisionNotes != null &&
                recentRequest.decisionNotes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: 'Owner Response:',
                      medium: true,
                      color: statusColor,
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    BodyText(
                      text: recentRequest.decisionNotes!,
                      color: statusColor,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: 'Requested: ${_formatDate(recentRequest.createdAt)}',
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
