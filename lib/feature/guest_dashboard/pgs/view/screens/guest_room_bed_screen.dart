// lib/features/guest_dashboard/pgs/view/screens/guest_room_bed_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/logging/logging_mixin.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/models/bed_change_request_model.dart';
import '../../../../../core/models/booking_model.dart';
import '../../../../../core/repositories/bed_change_request_repository.dart';
import '../../../../../core/repositories/booking_repository.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';

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
    final loc = AppLocalizations.of(context);
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final guestId = authProvider.user?.userId ?? '';

      if (guestId.isEmpty) {
        setState(() {
          _error = loc?.userNotAuthenticatedRoomBed ??
              _text('userNotAuthenticatedRoomBed', 'User not authenticated');
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
          _error = loc?.failedToLoadRoomBedInformation(e.toString()) ??
              _text(
                'failedToLoadRoomBedInformation',
                'Failed to load room/bed information: {error}',
                parameters: {'error': e.toString()},
              );
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
        logError(
          _text(
            'failedToLoadBedChangeRequests',
            'Failed to load bed change requests: {error}',
            parameters: {'error': error.toString()},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc?.myRoomAndBed ?? _text('myRoomAndBed', 'My Room & Bed'),
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRoomBedInfo,
            tooltip: loc?.refresh ?? _text('refresh', 'Refresh'),
          ),
        ],
      ),
      drawer: const GuestDrawer(),
      body: _buildBody(context, loc),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations? loc) {
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
            HeadingMedium(
              text: loc?.errorTitle ?? _text('errorTitle', 'Error'),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(text: _error!, align: TextAlign.center),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              label: loc?.retry ?? _text('retry', 'Retry'),
              onPressed: _loadRoomBedInfo,
            ),
          ],
        ),
      );
    }

    if (_booking == null) {
      return Center(
        child: EmptyState(
          title: loc?.noActiveBooking ??
              _text('noActiveBooking', 'No Active Booking'),
          message: loc?.noActiveBookingDescription ??
              _text(
                'noActiveBookingDescription',
                'You don\'t have an active booking yet. Book a PG to get assigned a room and bed.',
              ),
          icon: Icons.bed_outlined,
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoomBedCard(context, loc),
          const SizedBox(height: AppSpacing.paddingL),
          _buildBookingInfoCard(context, loc),
          if (_bedChangeRequests.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingL),
            _buildBedChangeRequestsCard(context, loc),
          ],
          const SizedBox(height: AppSpacing.paddingL),
          _buildRequestChangeSection(context, loc),
        ],
      ),
    );
  }

  Widget _buildRoomBedCard(BuildContext context, AppLocalizations? loc) {
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
                text: loc?.roomLabelWithNumber(_booking!.roomNumber) ??
                    _text(
                      'roomLabelWithNumber',
                      'Room {roomNumber}',
                      parameters: {
                        'roomNumber': _booking!.roomNumber,
                      },
                    ),
                color: AppColors.textOnPrimary,
              ),
            if (_booking!.bedNumber.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              HeadingMedium(
                text: loc?.bedLabelWithNumber(_booking!.bedNumber) ??
                    _text(
                      'bedLabelWithNumber',
                      'Bed {bedNumber}',
                      parameters: {
                        'bedNumber': _booking!.bedNumber,
                      },
                    ),
                color: AppColors.textOnPrimary,
              ),
            ],
            if (_booking!.roomNumber.isEmpty && _booking!.bedNumber.isEmpty)
              HeadingMedium(
                text: loc?.notAssigned ?? _text('notAssigned', 'Not assigned'),
                color: AppColors.textOnPrimary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInfoCard(BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(
                text: loc?.bookingInformation ??
                    _text('bookingInformation', 'Booking Information')),
            const SizedBox(height: AppSpacing.paddingM),
            _buildInfoRow(
                loc?.bookingRequestPgName ??
                    _text('bookingRequestPgName', 'PG Name'),
                _booking!.pgName),
            _buildInfoRow(loc?.startDate ?? _text('startDate', 'Start Date'),
                _formatDate(_booking!.startDate)),
            if (_booking!.endDate != null)
              _buildInfoRow(loc?.endDate ?? _text('endDate', 'End Date'),
                  _formatDate(_booking!.endDate!)),
            _buildInfoRow(loc?.status ?? _text('status', 'Status'),
                _statusLabel(_booking!.status, loc)),
            if (_booking!.roomNumber.isNotEmpty)
              _buildInfoRow(
                  loc?.room ?? _text('room', 'Room'), _booking!.roomNumber),
            if (_booking!.bedNumber.isNotEmpty)
              _buildInfoRow(
                  loc?.bed ?? _text('bed', 'Bed'), _booking!.bedNumber),
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

  Widget _buildRequestChangeSection(
      BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(
                text: loc?.requestBedRoomChange ??
                    _text('requestBedRoomChange', 'Request Bed/Room Change')),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc?.requestBedRoomChangeDescription ??
                  _text(
                    'requestBedRoomChangeDescription',
                    'Need to change your room or bed? Submit a request and the owner will review it.',
                  ),
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(
              label: loc?.requestChange ??
                  _text('requestChange', 'Request Change'),
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
    final loc = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(
            text: loc?.requestRoomBedChangeTitle ??
                _text('requestRoomBedChangeTitle', 'Request Room/Bed Change')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: loc?.currentAssignment ??
                    _text('currentAssignment', 'Current Assignment:'),
                medium: true,
              ),
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: _booking!.roomNumber.isNotEmpty &&
                        _booking!.bedNumber.isNotEmpty
                    ? '${loc?.roomLabelWithNumber(_booking!.roomNumber) ?? _text('roomLabelWithNumber', 'Room {roomNumber}', parameters: {
                              'roomNumber': _booking!.roomNumber
                            })}, ${loc?.bedLabelWithNumber(_booking!.bedNumber) ?? _text('bedLabelWithNumber', 'Bed {bedNumber}', parameters: {'bedNumber': _booking!.bedNumber})}'
                    : loc?.notAssigned ?? _text('notAssigned', 'Not assigned'),
              ),
              const SizedBox(height: AppSpacing.paddingL),
              TextField(
                controller: newRoomController,
                decoration: InputDecoration(
                  labelText: loc?.preferredRoomNumberOptional ??
                      _text('preferredRoomNumberOptional',
                          'Preferred Room Number (Optional)'),
                  hintText: loc?.preferredRoomNumberHint ??
                      _text(
                          'preferredRoomNumberHint', 'Enter preferred room...'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.door_front_door),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextField(
                controller: newBedController,
                decoration: InputDecoration(
                  labelText: loc?.preferredBedNumberOptional ??
                      _text('preferredBedNumberOptional',
                          'Preferred Bed Number (Optional)'),
                  hintText: loc?.preferredBedNumberHint ??
                      _text('preferredBedNumberHint', 'Enter preferred bed...'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.bed),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: loc?.reasonRequiredLabel ??
                      _text('reasonRequiredLabel', 'Reason *'),
                  hintText: loc?.reasonRequiredHint ??
                      _text('reasonRequiredHint',
                          'Why do you need to change room/bed?'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.note),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
          ),
          PrimaryButton(
            label:
                loc?.submitRequest ?? _text('submitRequest', 'Submit Request'),
            onPressed: () async {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc?.provideReasonError ??
                        _text('provideReasonError',
                            'Please provide a reason for the change')),
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
                  SnackBar(
                    content: Text(loc?.changeRequestSuccess ??
                        _text('changeRequestSuccess',
                            'Change request submitted successfully')),
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

  Widget _buildBedChangeRequestsCard(
      BuildContext context, AppLocalizations? loc) {
    // Get the most recent request
    final recentRequest = _bedChangeRequests.first;
    final status = recentRequest.status.toLowerCase();
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        statusText = _statusLabel(status, loc);
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = _statusLabel(status, loc);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = _statusLabel(status, loc);
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
                HeadingSmall(
                    text: loc?.bedChangeRequestStatus ??
                        _text('bedChangeRequestStatus',
                            'Bed Change Request Status')),
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
                    text: statusText,
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
                text: loc?.preferredLabel ??
                    _text('preferredLabel', 'Preferred:'),
                medium: true,
                color: Colors.grey[700],
              ),
              const SizedBox(height: AppSpacing.paddingXS),
              BodyText(
                text: recentRequest.preferredRoomNumber != null &&
                        recentRequest.preferredBedNumber != null
                    ? '${loc?.roomLabelWithNumber(recentRequest.preferredRoomNumber!) ?? _text('roomLabelWithNumber', 'Room {roomNumber}', parameters: {
                              'roomNumber':
                                  recentRequest.preferredRoomNumber.toString()
                            })}, ${loc?.bedLabelWithNumber(recentRequest.preferredBedNumber!) ?? _text('bedLabelWithNumber', 'Bed {bedNumber}', parameters: {'bedNumber': recentRequest.preferredBedNumber.toString()})}'
                    : recentRequest.preferredRoomNumber != null
                        ? loc?.roomLabelWithNumber(recentRequest.preferredRoomNumber!) ??
                            _text('roomLabelWithNumber', 'Room {roomNumber}', parameters: {
                              'roomNumber':
                                  recentRequest.preferredRoomNumber.toString(),
                            })
                        : loc?.bedLabelWithNumber(recentRequest.preferredBedNumber!) ??
                            _text('bedLabelWithNumber', 'Bed {bedNumber}', parameters: {
                              'bedNumber':
                                  recentRequest.preferredBedNumber.toString(),
                            }),
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],
            BodyText(
              text: loc?.reasonLabel ?? _text('reasonLabel', 'Reason:'),
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
                      text: loc?.ownerResponseLabel ??
                          _text('ownerResponseLabel', 'Owner Response:'),
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
              text:
                  loc?.requestedOnLabel(_formatDate(recentRequest.createdAt)) ??
                      _text(
                        'requestedLabel',
                        'Requested: {date}',
                        parameters: {
                          'date': _formatDate(recentRequest.createdAt),
                        },
                      ),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'pending':
        return loc?.bookingRequestPending ??
            _text('bookingRequestPending', 'Pending');
      case 'approved':
        return loc?.bookingRequestApproved ??
            _text('bookingRequestApproved', 'Approved');
      case 'rejected':
        return loc?.bookingRequestRejected ??
            _text('bookingRequestRejected', 'Rejected');
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    final locale = AppLocalizations.of(context)?.localeName;
    return DateFormat.yMMMd(locale).format(date);
  }
}
