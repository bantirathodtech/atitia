// lib/features/owner_dashboard/myguest/view/widgets/booking_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/owner_guest_model.dart';

/// Widget displaying booking list with status and payment information
/// Shows comprehensive booking details with visual indicators
class BookingListWidget extends StatelessWidget {
  final List<OwnerBookingModel> bookings;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const BookingListWidget({
    required this.bookings,
    super.key,
  });

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
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (bookings.isEmpty) {
      return EmptyState(
        title: loc?.ownerNoBookingsTitle ??
            _text('ownerNoBookingsTitle', 'No Bookings'),
        message: loc?.ownerNoBookingsMessage ??
            _text('ownerNoBookingsMessage',
                'Booking list will appear here once bookings are created'),
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
          child: _buildBookingCard(context, booking, loc),
        );
      },
    );
  }

  /// Builds individual booking card
  Widget _buildBookingCard(
    BuildContext context,
    OwnerBookingModel booking,
    AppLocalizations? loc,
  ) {
    return AdaptiveCard(
      onTap: () => _showBookingDetails(context, booking, loc),
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
                    color: _getStatusColor(booking.status).withValues(alpha: 0.2),
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
                  text: loc?.durationDays(booking.durationInDays) ??
                      _text('durationDays', '{count} days',
                          parameters: {'count': booking.durationInDays}),
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
                      text: loc?.rentLabel ??
                          _text('rentLabel', 'Rent'),
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
                      text: loc?.depositLabel ??
                          _text('depositLabel', 'Deposit'),
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
                      text: loc?.paidLabel ?? _text('paidLabel', 'Paid'),
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
  void _showBookingDetails(
    BuildContext context,
    OwnerBookingModel booking,
    AppLocalizations? loc,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            HeadingSmall(
                text: loc?.bookingDetailsTitle ??
                    _text('bookingDetailsTitle', 'Booking Details')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                loc?.roomBedLabel ??
                    _text('roomBedLabel', 'Room/Bed'),
                booking.roomBedDisplay,
              ),
              _buildDetailRow(
                  loc?.startDate ?? _text('startDate', 'Start Date'),
                  booking.formattedStartDate),
              _buildDetailRow(
                  loc?.endDate ?? _text('endDate', 'End Date'),
                  booking.formattedEndDate),
              _buildDetailRow(
                loc?.durationLabel ?? _text('durationLabel', 'Duration'),
                loc?.durationDays(booking.durationInDays) ??
                    _text('durationDays', '{count} days',
                        parameters: {'count': booking.durationInDays}),
              ),
              _buildDetailRow(
                  loc?.rentLabel ?? _text('rentLabel', 'Rent'),
                  booking.formattedRent),
              _buildDetailRow(
                  loc?.depositLabel ?? _text('depositLabel', 'Deposit'),
                  booking.formattedDeposit),
              _buildDetailRow(
                  loc?.paidLabel ?? _text('paidLabel', 'Paid'),
                  booking.formattedPaid),
              _buildDetailRow(
                  loc?.remainingLabel ??
                      _text('remainingLabel', 'Remaining'),
                  booking.formattedRemaining),
              _buildDetailRow(
                  loc?.statusLabel ?? _text('statusLabel', 'Status'),
                  booking.statusDisplay),
              _buildDetailRow(
                loc?.paymentStatusLabel ??
                    _text('paymentStatusLabel', 'Payment Status'),
                booking.paymentStatusDisplay,
              ),
              if (booking.notes != null && booking.notes!.isNotEmpty)
                _buildDetailRow(
                    loc?.notesLabel ?? _text('notesLabel', 'Notes'),
                    booking.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.close ?? _text('close', 'Close')),
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
