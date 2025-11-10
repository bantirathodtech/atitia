// lib/feature/owner_dashboard/myguest/view/widgets/booking_request_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
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
        const SizedBox(height: 16),
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
                    text: request['guestName'] ?? (loc?.unknownGuest ?? 'Unknown Guest'),
                  ),
                  subtitle: CaptionText(
                    text: request['pgName'] ?? (loc?.unknownPg ?? 'Unknown PG'),
                  ),
                  trailing: TextButton(
                    onPressed: () => _showActionDialog(context, request, loc),
                    child: Text(loc?.bookingRequestAction ?? 'Action'),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showActionDialog(
      BuildContext context, Map<String, dynamic> request, AppLocalizations? loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc?.bookingRequestDialogTitle ?? 'Booking Request'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${loc?.guestLabel ?? 'Guest'}: ${request['guestName'] ?? (loc?.unknownValue ?? 'Unknown')}',
              ),
              Text(
                '${loc?.pgLabel ?? 'PG'}: ${request['pgName'] ?? (loc?.unknownPg ?? 'Unknown PG')}',
              ),
              Text(
                '${loc?.dateLabel ?? 'Date'}: ${request['requestDate'] ?? (loc?.unknownValue ?? 'Unknown')}',
              ),
              Text(
                '${loc?.statusLabel ?? 'Status'}: ${request['status'] ?? (loc?.unknownValue ?? 'Unknown')}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(loc?.close ?? 'Close'),
          ),
          TextButton(
            onPressed: () {
              // Handle approval
              Navigator.pop(context);
            },
            child: Text(loc?.approve ?? 'Approve'),
          ),
          TextButton(
            onPressed: () {
              // Handle rejection
              Navigator.pop(context);
            },
            child: Text(loc?.reject ?? 'Reject'),
          ),
        ],
      ),
    );
  }
}
