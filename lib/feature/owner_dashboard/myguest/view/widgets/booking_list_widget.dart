// lib/features/owner_dashboard/myguest/view/widgets/booking_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/styles/spacing.dart';
import '../../data/models/owner_guest_model.dart';

/// Widget displaying booking list with status and payment information
/// Shows comprehensive booking details with visual indicators
class BookingListWidget extends StatelessWidget {
  final List<OwnerBookingModel> bookings;

  const BookingListWidget({
    required this.bookings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(
        title: 'No Bookings',
        message: 'Booking list will appear here once bookings are created',
        icon: Icons.book_online_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: _buildBookingCard(context, booking),
        );
      },
    );
  }

  /// Builds individual booking card
  Widget _buildBookingCard(BuildContext context, OwnerBookingModel booking) {
    return AdaptiveCard(
      onTap: () => _showBookingDetails(context, booking),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with room/bed and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingSmall(text: booking.roomBedDisplay),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: booking.statusDisplay,
                    color: _getStatusColor(booking.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // Booking dates
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text:
                      '${booking.formattedStartDate} - ${booking.formattedEndDate}',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Duration
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                CaptionText(
                  text: '${booking.durationInDays} days',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // Payment information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CaptionText(
                      text: 'Rent',
                      color: Colors.grey.shade600,
                    ),
                    BodyText(
                      text: booking.formattedRent,
                      medium: true,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CaptionText(
                      text: 'Deposit',
                      color: Colors.grey.shade600,
                    ),
                    BodyText(
                      text: booking.formattedDeposit,
                      medium: true,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CaptionText(
                      text: 'Paid',
                      color: Colors.grey.shade600,
                    ),
                    BodyText(
                      text: booking.formattedPaid,
                      medium: true,
                      color: Colors.green,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Gets status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Shows booking details dialog
  void _showBookingDetails(BuildContext context, OwnerBookingModel booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: 'Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Room/Bed', booking.roomBedDisplay),
              _buildDetailRow('Start Date', booking.formattedStartDate),
              _buildDetailRow('End Date', booking.formattedEndDate),
              _buildDetailRow('Duration', '${booking.durationInDays} days'),
              _buildDetailRow('Rent', booking.formattedRent),
              _buildDetailRow('Deposit', booking.formattedDeposit),
              _buildDetailRow('Paid', booking.formattedPaid),
              _buildDetailRow('Remaining', booking.formattedRemaining),
              _buildDetailRow('Status', booking.statusDisplay),
              _buildDetailRow('Payment Status', booking.paymentStatusDisplay),
              if (booking.notes != null && booking.notes!.isNotEmpty)
                _buildDetailRow('Notes', booking.notes!),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: '$label:', color: Colors.grey.shade600),
          Expanded(
            child: BodyText(
              text: value,
              medium: true,
              align: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
