// lib/features/guest_dashboard/pgs/view/screens/guest_booking_requests_screen.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';
import '../../../../../feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/user_location_display.dart';

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
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

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
    final loc = AppLocalizations.of(context);
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
        debugPrint(_text('bookingRequestAuthDebug',
            '⚠️ No Firebase Auth user found - user might not be authenticated'));
        setState(() {
          _error = loc?.bookingRequestUserNotAuthenticated ??
              _text('bookingRequestUserNotAuthenticated',
                  'User not authenticated. Please sign in again.');
          _loading = false;
        });
        return;
      }

      debugPrint(_text('bookingRequestLoadingDebug',
          '🔑 Loading booking requests for guestId: {guestId}',
          parameters: {'guestId': finalGuestId}));

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
          debugPrint(_text('bookingRequestStreamErrorDebug',
              'Booking requests stream error: {error}',
              parameters: {'error': error.toString()}));
          if (mounted) {
            String errorMessage = loc?.bookingRequestLoadFailed ??
                _text('bookingRequestLoadFailed',
                    'Failed to load booking requests');

            // Provide user-friendly error messages
            if (error.toString().contains('permission') ||
                error.toString().contains('Missing or insufficient')) {
              errorMessage = loc?.bookingRequestPermissionDenied ??
                  _text('bookingRequestPermissionDenied',
                      'Permission denied. Please ensure you are logged in correctly.');
            } else if (error.toString().contains('network') ||
                error.toString().contains('unavailable')) {
              errorMessage = loc?.bookingRequestNetworkError ??
                  _text('bookingRequestNetworkError',
                      'Network error. Please check your connection and try again.');
            } else {
              errorMessage =
                  loc?.bookingRequestGeneralError(error.toString()) ??
                      _text('bookingRequestGeneralError',
                          'Failed to load booking requests: {error}',
                          parameters: {'error': error.toString()});
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
      debugPrint(_text('bookingRequestExceptionDebug',
          'Exception loading booking requests: {error}',
          parameters: {'error': e.toString()}));
      if (mounted) {
        setState(() {
          _error = loc?.bookingRequestGeneralError(e.toString()) ??
              _text('bookingRequestGeneralError',
                  'Failed to load booking requests: {error}',
                  parameters: {'error': e.toString()});
          _loading = false;
        });
      }
    }
  }

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
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc?.myBookingRequests ??
            _text('myBookingRequests', 'My Booking Requests'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookingRequests,
            tooltip: loc?.refresh ?? _text('refresh', 'Refresh'),
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
    final loc = AppLocalizations.of(context);
    if (_loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: loc?.loadingBookingRequests ??
                  _text(
                      'loadingBookingRequests', 'Loading booking requests...'),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingMedium(
              text: loc?.bookingRequestsErrorTitle ??
                  _text('bookingRequestsErrorTitle', 'Error Loading Requests'),
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: _error!,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: _loadBookingRequests,
              label: loc?.tryAgain ?? _text('tryAgain', 'Try Again'),
            ),
          ],
        ),
      );
    }

    // Always show structured UI - stats and placeholder rows even when empty
    return Column(
      children: [
        // User Location Display
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.paddingM,
            AppSpacing.paddingM,
            AppSpacing.paddingM,
            AppSpacing.paddingS,
          ),
          child: const UserLocationDisplay(),
        ),
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
    final loc = AppLocalizations.of(context);

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
          HeadingMedium(
            text: loc?.bookingRequestSummary ??
                _text('bookingRequestSummary', 'Booking Request Summary'),
            color: AppColors.textOnPrimary,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                loc?.bookingRequestPending ??
                    _text('bookingRequestPending', 'Pending'),
                pendingCount,
                AppColors.statusOrange,
              ),
              _buildStatItem(
                loc?.bookingRequestApproved ??
                    _text('bookingRequestApproved', 'Approved'),
                approvedCount,
                AppColors.success,
              ),
              _buildStatItem(
                loc?.bookingRequestRejected ??
                    _text('bookingRequestRejected', 'Rejected'),
                rejectedCount,
                AppColors.statusRed,
              ),
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
    final loc = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding.horizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Info hint card
          InfoCard(
            title: loc?.bookingRequestsIntroTitle ??
                _text('bookingRequestsIntroTitle',
                    'Get Started with Booking Requests'),
            description: loc?.bookingRequestsIntroDescription ??
                _text(
                  'bookingRequestsIntroDescription',
                  'Browse PGs and send booking requests. Owners will review and respond to your requests here.',
                ),
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
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
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
                Icon(Icons.location_on,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.5) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5)),
                const SizedBox(width: AppSpacing.paddingXS),
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
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.5) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5)),
                const SizedBox(width: AppSpacing.paddingXS),
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
    final statusColor = _getStatusColor(context, status);
    final requestDate = request.createdAt;
    final respondedAt = request.respondedAt;
    final loc = AppLocalizations.of(context);
    final statusLabel = _statusLabel(status, loc);

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
                    text: statusLabel,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // PG address (if available from PG info)
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: BodyText(
                    text: request.pgName,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Request date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7)),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: loc?.bookingRequestRequestedOn(
                        _formatDate(requestDate),
                      ) ??
                      _text('bookingRequestRequestedOn', 'Requested: {date}',
                          parameters: {'date': _formatDate(requestDate)}),
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
              ],
            ),
            // Response date if available
            if (respondedAt != null) ...[
              const SizedBox(height: AppSpacing.paddingXS),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 14,
                      color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.7) ??
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7)),
                  const SizedBox(width: AppSpacing.paddingXS),
                  BodyText(
                    text: loc?.bookingRequestRespondedOn(
                          _formatDate(respondedAt),
                        ) ??
                        _text('bookingRequestRespondedOn', 'Responded: {date}',
                            parameters: {'date': _formatDate(respondedAt)}),
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
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
                text: loc?.bookingRequestFrom(request.guestName) ??
                    _text('bookingRequestFrom', 'Request from: {name}',
                        parameters: {'name': request.guestName}),
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.8) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.8),
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
    final loc = AppLocalizations.of(context);
    final statusLabel = _statusLabel(request.status, loc);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(
          text: loc?.bookingRequestDetailsTitle ??
              _text('bookingRequestDetailsTitle', 'Booking Request Details'),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                  loc?.bookingRequestPgName ??
                      _text('bookingRequestPgName', 'PG Name'),
                  request.pgName),
              _buildDetailRow(
                  loc?.bookingRequestStatus ??
                      _text('bookingRequestStatus', 'Status'),
                  statusLabel),
              _buildDetailRow(
                  loc?.bookingRequestDate ??
                      _text('bookingRequestDate', 'Request Date'),
                  _formatDate(request.createdAt)),
              if (request.respondedAt != null)
                _buildDetailRow(
                    loc?.bookingRequestResponseDate ??
                        _text('bookingRequestResponseDate', 'Response Date'),
                    _formatDate(request.respondedAt!)),
              if (request.responseMessage != null &&
                  request.responseMessage!.isNotEmpty)
                _buildDetailRow(
                    loc?.bookingRequestOwnerResponse ??
                        _text('bookingRequestOwnerResponse', 'Owner Response'),
                    request.responseMessage!),
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
  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.statusOrange;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.statusRed;
      default:
        return Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
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

  /// Formats date for display
  String _formatDate(DateTime date) {
    final locale = AppLocalizations.of(context)?.localeName;
    return DateFormat.yMMMd(locale).format(date);
  }
}
