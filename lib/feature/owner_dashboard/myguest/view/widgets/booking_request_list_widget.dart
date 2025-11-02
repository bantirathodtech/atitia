// lib/feature/owner_dashboard/myguest/view/widgets/booking_request_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(text: title),
        const SizedBox(height: 16),
        if (requests.isEmpty)
          const BodyText(text: 'No requests found')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return AdaptiveCard(
                child: ListTile(
                  title:
                      BodyText(text: request['guestName'] ?? 'Unknown Guest'),
                  subtitle:
                      CaptionText(text: request['pgName'] ?? 'Unknown PG'),
                  trailing: TextButton(
                    onPressed: () => _showActionDialog(context, request),
                    child: const Text('Action'),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Guest: ${request['guestName'] ?? 'Unknown'}'),
            Text('PG: ${request['pgName'] ?? 'Unknown'}'),
            Text('Date: ${request['requestDate'] ?? 'Unknown'}'),
            Text('Status: ${request['status'] ?? 'Unknown'}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              // Handle approval
              Navigator.pop(context);
            },
            child: const Text('Approve'),
          ),
          TextButton(
            onPressed: () {
              // Handle rejection
              Navigator.pop(context);
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
