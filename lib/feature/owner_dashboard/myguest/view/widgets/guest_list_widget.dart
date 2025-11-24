// lib/features/owner_dashboard/myguest/view/widgets/guest_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/booking/guest_status_utils.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/owner_guest_model.dart';

/// Widget displaying guest list with room/bed assignments and booking information
/// Shows comprehensive guest details with visual indicators
/// Supports selection mode for bulk actions
class GuestListWidget extends StatelessWidget {
  final List<OwnerGuestModel> guests;
  final Map<String, String>? guestPaymentStatus; // guestUid -> payment status
  final bool selectionMode;
  final Set<String> selectedGuestIds;
  final Function(OwnerGuestModel)? onGuestTap;

  const GuestListWidget({
    required this.guests,
    this.guestPaymentStatus,
    this.selectionMode = false,
    this.selectedGuestIds = const {},
    this.onGuestTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (guests.isEmpty) {
      return EmptyState(
        title: AppLocalizations.of(context)?.noGuests ?? 'No Guests',
        message: AppLocalizations.of(context)
                ?.guestListWillAppearHereOnceGuestsAreAdded ??
            'Guest list will appear here once guests are added',
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: guests.length,
      cacheExtent: 512,
      addAutomaticKeepAlives: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (context, index) {
        final guest = guests[index];
        return RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
            child: _buildGuestCard(context, guest),
          ),
        );
      },
    );
  }

  /// Builds individual guest card
  Widget _buildGuestCard(BuildContext context, OwnerGuestModel guest) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7) ??
            theme.colorScheme.onSurface.withValues(alpha: 0.7);
    final isSelected = selectedGuestIds.contains(guest.uid);

    return AdaptiveCard(
      onTap: () {
        if (selectionMode && onGuestTap != null) {
          onGuestTap!(guest);
        } else {
          _showGuestDetails(context, guest);
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 96),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Row(
            children: [
              // Selection checkbox (only in selection mode)
              if (selectionMode) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: (_) {
                    if (onGuestTap != null) onGuestTap!(guest);
                  },
                  activeColor: theme.primaryColor,
                ),
                const SizedBox(width: AppSpacing.paddingS),
              ],
              // Guest Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: guest.statusColor.withValues(alpha: 0.2),
                child: Text(
                  guest.initials,
                  style: TextStyle(
                    color: guest.statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              // Guest Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeadingSmall(text: guest.fullName),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: textSecondary),
                        const SizedBox(width: AppSpacing.paddingXS),
                        Expanded(
                          child: BodyText(
                            text: guest.phoneNumber,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Row(
                      children: [
                        Icon(Icons.bed, size: 14, color: textSecondary),
                        const SizedBox(width: AppSpacing.paddingXS),
                        Expanded(
                          child: CaptionText(
                            text: guest.roomBedDisplay,
                            color: textSecondary,
                          ),
                        ),
                        // Vehicle badge if guest has vehicle
                        if (guest.hasVehicleInfo)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.two_wheeler,
                              size: 16,
                              color: AppColors.info,
                            ),
                          ),
                      ],
                    ),
                    // Payment status indicator
                    if (_getPaymentStatus(guest) != null) ...[
                      const SizedBox(height: AppSpacing.paddingXS),
                      _buildPaymentStatusIndicator(
                        context,
                        guest,
                        _getPaymentStatus(guest)!,
                      ),
                    ],
                  ],
                ),
              ),
              // Status Badge
              Flexible(
                fit: FlexFit.loose,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: guest.statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: BodyText(
                      text: guest.statusDisplay,
                      color: guest.statusColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows guest details dialog
  Future<void> _showGuestDetails(BuildContext context, OwnerGuestModel guest) {
    final loc = AppLocalizations.of(context)!;
    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.guestDetailsTitle),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          context, loc.ownerGuestDetailVehicleNumber, guest.vehicleNo!),
                      if (guest.vehicleName != null && guest.vehicleName!.isNotEmpty)
                        _buildDetailRow(
                            context, loc.ownerGuestDetailVehicle, guest.vehicleName!),
                      if (guest.roomNumber != null)
                        _buildDetailRow(
                          context,
                          loc.ownerGuestDetailRoomBed,
                          guest.roomBedDisplay,
                        ),
                      if (guest.rent != null)
                        _buildDetailRow(
                            context, loc.ownerGuestDetailRent, guest.formattedRent),
                      if (guest.deposit != null)
                        _buildDetailRow(context, loc.ownerGuestDetailDeposit,
                            guest.formattedDeposit),
                      if (guest.joiningDate != null)
                        _buildDetailRow(context, loc.ownerGuestDetailJoined,
                            guest.formattedJoiningDate),
                      _buildDetailRow(
                          context, loc.ownerGuestDetailStatus, guest.statusDisplay),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.close,
                  ),
                  if (guest.roomNumber != null || guest.bedNumber != null) ...[
                    const SizedBox(width: AppSpacing.paddingS),
                    PrimaryButton(
                      label: loc.ownerGuestUpdateRoomBed,
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showUpdateRoomBedDialog(context, guest);
                      },
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final textSecondary =
        theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7) ??
            theme.colorScheme.onSurface.withValues(alpha: 0.7);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: '$label:', color: textSecondary),
          BodyText(text: value, medium: true),
        ],
      ),
    );
  }

  /// Shows dialog to update guest room/bed assignment
  Future<void> _showUpdateRoomBedDialog(
      BuildContext context, OwnerGuestModel guest) {
    final roomController = TextEditingController(text: guest.roomNumber ?? '');
    final bedController = TextEditingController(text: guest.bedNumber ?? '');
    final loc = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.ownerGuestUpdateRoomBedTitle),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: roomController,
                label: loc.ownerGuestRoomNumberLabel,
                hint: loc.ownerGuestRoomNumberHint,
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: bedController,
                label: loc.ownerGuestBedNumberLabel,
                hint: loc.ownerGuestBedNumberHint,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.cancel,
                  ),
          PrimaryButton(
            label: loc.ownerGuestUpdateAction,
            onPressed: () async {
              final viewModel =
                  Provider.of<OwnerGuestViewModel>(context, listen: false);
              final updatedGuest = guest.copyWith(
                roomNumber: roomController.text.trim().isEmpty
                    ? null
                    : roomController.text.trim(),
                bedNumber: bedController.text.trim().isEmpty
                    ? null
                    : bedController.text.trim(),
              );

              final success = await viewModel.updateGuest(updatedGuest);

              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? loc.ownerGuestRoomBedUpdateSuccess
                        : loc.ownerGuestRoomBedUpdateFailure),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
                  ),
                );
              }
            },
          ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Gets payment status for a guest
  String? _getPaymentStatus(OwnerGuestModel guest) {
    // Check guest status first
    if (guest.status == 'payment_pending') {
      return GuestStatusUtils.paymentStatusPending;
    }

    // Check payment status map if provided
    if (guestPaymentStatus != null) {
      return guestPaymentStatus![guest.uid];
    }

    // Default based on guest status
    if (guest.status == 'active') {
      return GuestStatusUtils.paymentStatusCollected;
    }

    return null;
  }

  /// Builds payment status indicator
  Widget _buildPaymentStatusIndicator(
    BuildContext context,
    OwnerGuestModel guest,
    String paymentStatus,
  ) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (paymentStatus.toLowerCase()) {
      case GuestStatusUtils.paymentStatusCollected:
        statusColor = AppColors.success;
        statusText = 'Paid';
        statusIcon = Icons.check_circle;
        break;
      case GuestStatusUtils.paymentStatusPending:
        statusColor = AppColors.warning;
        statusText = 'Payment Pending';
        statusIcon = Icons.pending;
        break;
      case GuestStatusUtils.paymentStatusPartial:
        statusColor = AppColors.info;
        statusText = 'Partial Payment';
        statusIcon = Icons.payments;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 14,
            color: statusColor,
          ),
          const SizedBox(width: 4),
          CaptionText(
            text: statusText,
            color: statusColor,
          ),
        ],
      ),
    );
  }
}
