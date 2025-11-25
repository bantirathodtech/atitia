// lib/feature/owner_dashboard/myguest/view/widgets/booking_request_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../l10n/app_localizations.dart';

/// Widget for displaying a list of booking requests
class BookingRequestListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> requests;
  final String title;
  final VoidCallback? onRefresh;

  const BookingRequestListWidget({
    super.key,
    required this.requests,
    required this.title,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(text: title),
        const SizedBox(height: AppSpacing.paddingM),
        if (requests.isEmpty)
          BodyText(text: loc?.noRequestsFound ?? 'No requests found')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return AdaptiveCard(
                child: ListTile(
                  title: BodyText(
                    text: request['guestName'] ??
                        (loc?.unknownGuest ?? 'Unknown Guest'),
                  ),
                  subtitle: CaptionText(
                    text: request['pgName'] ?? (loc?.unknownPg ?? 'Unknown PG'),
                  ),
                  trailing: TextButtonWidget(
                    onPressed: () => _showActionDialog(context, request, loc),
                    text: loc?.bookingRequestAction ?? 'Action',
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, Map<String, dynamic> request,
      AppLocalizations? loc) {
    showDialog(
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
              HeadingMedium(
                  text: loc?.bookingRequestDialogTitle ?? 'Booking Request'),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                        text:
                            '${loc?.guestLabel ?? 'Guest'}: ${request['guestName'] ?? (loc?.unknownValue ?? 'Unknown')}',
                      ),
                      const SizedBox(height: AppSpacing.paddingS),
                      BodyText(
                        text:
                            '${loc?.pgLabel ?? 'PG'}: ${request['pgName'] ?? (loc?.unknownPg ?? 'Unknown PG')}',
                      ),
                      const SizedBox(height: AppSpacing.paddingS),
                      BodyText(
                        text:
                            '${loc?.dateLabel ?? 'Date'}: ${request['requestDate'] ?? (loc?.unknownValue ?? 'Unknown')}',
                      ),
                      const SizedBox(height: AppSpacing.paddingS),
                      BodyText(
                        text:
                            '${loc?.statusLabel ?? 'Status'}: ${request['status'] ?? (loc?.unknownValue ?? 'Unknown')}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: loc?.close ?? 'Close',
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    onPressed: () {
                      // Handle approval
                      Navigator.pop(context);
                    },
                    label: loc?.approve ?? 'Approve',
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  TextButtonWidget(
                    onPressed: () {
                      // Handle rejection
                      Navigator.pop(context);
                    },
                    text: loc?.reject ?? 'Reject',
                    color: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
