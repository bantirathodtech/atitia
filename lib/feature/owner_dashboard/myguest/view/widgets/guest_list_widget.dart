// lib/features/owner_dashboard/myguest/view/widgets/guest_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/styles/spacing.dart';
import '../../data/models/owner_guest_model.dart';

/// Widget displaying guest list with room/bed assignments and booking information
/// Shows comprehensive guest details with visual indicators
/// Supports selection mode for bulk actions
class GuestListWidget extends StatelessWidget {
  final List<OwnerGuestModel> guests;
  final bool selectionMode;
  final Set<String> selectedGuestIds;
  final Function(OwnerGuestModel)? onGuestTap;

  const GuestListWidget({
    required this.guests,
    this.selectionMode = false,
    this.selectedGuestIds = const {},
    this.onGuestTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (guests.isEmpty) {
      return const EmptyState(
        title: 'No Guests',
        message: 'Guest list will appear here once guests are added',
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: guests.length,
      cacheExtent: 512,
      addAutomaticKeepAlives: false,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      prototypeItem: const SizedBox(height: 112),
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
    final isDarkMode = theme.brightness == Brightness.dark;
    final textSecondary = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey.shade700;
    final isSelected = selectedGuestIds.contains(guest.uid);
    
    return AdaptiveCard(
      onTap: () {
        if (selectionMode && onGuestTap != null) {
          onGuestTap!(guest);
        } else {
          _showGuestDetails(context, guest);
        }
      },
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
              radius: 30,
              backgroundColor: guest.statusColor.withOpacity(0.2),
              child: Text(
                guest.initials,
                style: TextStyle(
                  color: guest.statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            // Guest Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSmall(text: guest.fullName),
                  const SizedBox(height: AppSpacing.paddingXS),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      BodyText(
                        text: guest.phoneNumber,
                        color: textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingXS),
                  Row(
                    children: [
                      Icon(Icons.bed, size: 14, color: textSecondary),
                      const SizedBox(width: 4),
                      CaptionText(
                        text: guest.roomBedDisplay,
                        color: textSecondary,
                      ),
                    ],
                  ),
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
                color: guest.statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
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
    );
  }

  /// Shows guest details dialog
  void _showGuestDetails(BuildContext context, OwnerGuestModel guest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: guest.fullName),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(context, 'Phone', guest.phoneNumber),
              if (guest.email != null) _buildDetailRow(context, 'Email', guest.email!),
              if (guest.roomNumber != null)
                _buildDetailRow(context, 'Room/Bed', guest.roomBedDisplay),
              if (guest.rent != null) _buildDetailRow(context, 'Rent', guest.formattedRent),
              if (guest.deposit != null)
                _buildDetailRow(context, 'Deposit', guest.formattedDeposit),
              if (guest.joiningDate != null)
                _buildDetailRow(context, 'Joined', guest.formattedJoiningDate),
              _buildDetailRow(context, 'Status', guest.statusDisplay),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textSecondary = isDarkMode ? const Color(0xFFB0B0B0) : Colors.grey.shade700;
    
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
}
