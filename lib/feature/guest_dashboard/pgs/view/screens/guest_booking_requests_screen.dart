// lib/features/guest_dashboard/pgs/view/screens/guest_booking_requests_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'dart:async';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/drawers/guest_drawer.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import '../../../../../feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';

/// Screen for guests to view their booking request status
/// Shows all booking requests sent by the guest with their current status
class GuestBookingRequestsScreen extends StatefulWidget {
  const GuestBookingRequestsScreen({super.key});

  @override
  State<GuestBookingRequestsScreen> createState() =>
      _GuestBookingRequestsScreenState();
}

class _GuestBookingRequestsScreenState
    extends State<GuestBookingRequestsScreen> {
  final OwnerBookingRequestRepository _repository =
      OwnerBookingRequestRepository();
  List<OwnerBookingRequestModel> _bookingRequests = [];
  StreamSubscription<List<OwnerBookingRequestModel>>? _requestsSubscription;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Wait for Firebase Auth to be ready before loading requests
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add small delay to ensure Firebase Auth is fully initialized
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _loadBookingRequests();
        }
      });
    });
  }

  @override
  void dispose() {
    _requestsSubscription?.cancel();
    super.dispose();
  }

  /// Loads booking requests for the current guest using real repository
  void _loadBookingRequests() {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      // CRITICAL: Use Firebase Auth UID directly (request.auth.uid in Firestore rules)
      // This must match request.auth.uid for security rules to work
      final firebaseAuthUser = firebase_auth.FirebaseAuth.instance.currentUser;
      final finalGuestId = firebaseAuthUser?.uid;

      if (finalGuestId == null || finalGuestId.isEmpty) {
        debugPrint(
            '⚠️ No Firebase Auth user found - user might not be authenticated');
        setState(() {
          _error = 'User not authenticated. Please sign in again.';
          _loading = false;
        });
        return;
      }

      debugPrint('🔑 Loading booking requests for guestId: $finalGuestId');

      // Cancel any existing subscription to prevent memory leaks
      _requestsSubscription?.cancel();

      // Use real repository stream with proper error handling
      // Use Firebase Auth UID which matches request.auth.uid in Firestore rules
      _requestsSubscription =
          _repository.streamGuestBookingRequests(finalGuestId).listen(
        (requests) {
          if (mounted) {
            setState(() {
              _bookingRequests = requests;
              _loading = false;
              _error = null; // Clear any previous errors on success
            });
          }
        },
        onError: (error) {
          debugPrint('Booking requests stream error: $error');
          if (mounted) {
            String errorMessage = 'Failed to load booking requests';

            // Provide user-friendly error messages
            if (error.toString().contains('permission') ||
                error.toString().contains('Missing or insufficient')) {
              errorMessage =
                  'Permission denied. Please ensure you are logged in correctly.';
            } else if (error.toString().contains('network') ||
                error.toString().contains('unavailable')) {
              errorMessage =
                  'Network error. Please check your connection and try again.';
            } else {
              errorMessage =
                  'Failed to load booking requests: ${error.toString()}';
            }

            setState(() {
              _error = errorMessage;
              _loading = false;
            });
          }
        },
        cancelOnError: false, // Keep stream alive even on error
      );
    } catch (e) {
      debugPrint('Exception loading booking requests: $e');
      if (mounted) {
        setState(() {
          _error = 'Failed to load booking requests: ${e.toString()}';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'My Booking Requests',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookingRequests,
            tooltip: 'Refresh',
          ),
        ],
        showBackButton: true,
        showThemeToggle: true,
      ),
      drawer: const GuestDrawer(),
      body: _buildBody(),
    );
  }

  /// Builds the main body content
  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            SizedBox(height: AppSpacing.paddingM),
            BodyText(text: 'Loading booking requests...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            const HeadingMedium(
              text: 'Error Loading Requests',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: _error!,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            ElevatedButton(
              onPressed: _loadBookingRequests,
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }

    // Always show structured UI - stats and placeholder rows even when empty
    return Column(
      children: [
        _buildStatsCard(),
        Expanded(
          child: _bookingRequests.isEmpty
              ? _buildZeroStateContent()
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  itemCount: _bookingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _bookingRequests[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingS),
                      child: _buildRequestCard(request),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Builds stats card showing request summary
  Widget _buildStatsCard() {
    final pendingCount =
        _bookingRequests.where((r) => r.status == 'pending').length;
    final approvedCount =
        _bookingRequests.where((r) => r.status == 'approved').length;
    final rejectedCount =
        _bookingRequests.where((r) => r.status == 'rejected').length;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const HeadingMedium(
            text: 'Booking Request Summary',
            color: AppColors.textOnPrimary,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Pending', pendingCount, Colors.orange),
              _buildStatItem('Approved', approvedCount, Colors.green),
              _buildStatItem('Rejected', rejectedCount, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        CaptionText(
          text: label,
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
        ),
      ],
    );
  }

  /// Builds structured zero-state content with hints and placeholder rows
  Widget _buildZeroStateContent() {
    final padding = context.responsivePadding;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info hint card
          InfoCard(
            title: 'Get Started with Booking Requests',
            description:
                'Browse PGs and send booking requests. Owners will review and respond to your requests here.',
            icon: Icons.info_outline,
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Placeholder request cards showing structure
          ...List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
              child: _buildPlaceholderRequestCard(index),
            );
          }),
        ],
      ),
    );
  }

  /// Builds placeholder request card
  Widget _buildPlaceholderRequestCard(int index) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ShimmerLoader(
                        width: 120,
                        height: 16,
                        borderRadius: 4,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: ShimmerLoader(
                    width: 60,
                    height: 12,
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // Location placeholder
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                ShimmerLoader(
                  width: 150,
                  height: 12,
                  borderRadius: 4,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Date placeholder
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                ShimmerLoader(
                  width: 120,
                  height: 12,
                  borderRadius: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual request card
  Widget _buildRequestCard(OwnerBookingRequestModel request) {
    final status = request.status;
    final statusColor = _getStatusColor(status);
    final requestDate = request.createdAt;
    final respondedAt = request.respondedAt;

    return AdaptiveCard(
      onTap: () => _showRequestDetails(request),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with PG name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HeadingSmall(text: request.pgName),
                ),
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
                  child: CaptionText(
                    text: status.toUpperCase(),
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // PG address (if available from PG info)
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: BodyText(
                    text: request.pgName,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Request date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text: 'Requested: ${_formatDate(requestDate)}',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            // Response date if available
            if (respondedAt != null) ...[
              const SizedBox(height: AppSpacing.paddingXS),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  BodyText(
                    text: 'Responded: ${_formatDate(respondedAt)}',
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ],
            // Message preview (if available)
            // Note: OwnerBookingRequestModel may not have guestMessage field
            // Using guestName as identifier
            if (request.guestName.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: 'Request from: ${request.guestName}',
                color: Colors.grey.shade700,
              ),
            ],
            // Response message preview
            if (request.responseMessage != null &&
                request.responseMessage!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Row(
                  children: [
                    Icon(Icons.message, size: 16, color: statusColor),
                    const SizedBox(width: AppSpacing.paddingS),
                    Expanded(
                      child: BodyText(
                        text: request.responseMessage!,
                        color: statusColor,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Shows detailed request information
  void _showRequestDetails(OwnerBookingRequestModel request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: 'Booking Request Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('PG Name', request.pgName),
              _buildDetailRow('Status', request.status.toUpperCase()),
              _buildDetailRow('Request Date', _formatDate(request.createdAt)),
              if (request.respondedAt != null)
                _buildDetailRow(
                    'Response Date', _formatDate(request.respondedAt!)),
              if (request.responseMessage != null &&
                  request.responseMessage!.isNotEmpty)
                _buildDetailRow('Owner Response', request.responseMessage!),
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

  /// Builds a detail row for the dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: BodyText(
              text: '$label:',
              medium: true,
            ),
          ),
          Expanded(
            child: BodyText(text: value),
          ),
        ],
      ),
    );
  }

  /// Gets color for request status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
