// lib/features/guest_dashboard/pgs/view/screens/guest_booking_requests_screen.dart

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/containers/section_container.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';
import '../../../../../feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/guest_pg_selector_dropdown.dart';
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
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        leadingActions: [
          const GuestPgSelectorDropdown(compact: true),
        ],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBookingRequests,
            tooltip: loc?.refresh ?? _text('refresh', 'Refresh'),
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
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
      return EmptyState(
        title: loc?.bookingRequestsErrorTitle ??
            _text('bookingRequestsErrorTitle', 'Error Loading Requests'),
        message: _error!,
        icon: Icons.error_outline,
        actionLabel: loc?.tryAgain ?? _text('tryAgain', 'Try Again'),
        onAction: _loadBookingRequests,
      );
    }

    // Always show structured UI - stats and placeholder rows even when empty
    return SingleChildScrollView(
      child: Column(
        children: [
          // User Location Display
          Padding(
            padding: EdgeInsets.fromLTRB(
              context.responsivePadding.left,
              context.responsivePadding.top,
              context.responsivePadding.right,
              context.responsivePadding.top * 0.5,
            ),
            child: const UserLocationDisplay(),
          ),
          _buildStatsCard(),
          SizedBox(height: context.responsivePadding.top * 0.5),
          _bookingRequests.isEmpty
              ? _buildZeroStateContent()
              : Padding(
                  padding: EdgeInsets.all(context.responsivePadding.top),
                  child: Column(
                    children: [
                      ..._bookingRequests.map((request) => Padding(
                            padding: EdgeInsets.only(
                                bottom: context.responsivePadding.top),
                            child: _buildRequestCard(request),
                          )),
                    ],
                  ),
                ),
        ],
      ),
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
    final totalCount = _bookingRequests.length;
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: context.responsiveMargin,
      child: SectionContainer(
        title: loc?.bookingRequestSummary ??
            _text('bookingRequestSummary', 'Booking Request Summary'),
        icon: Icons.book_online,
        child: Column(
          children: [
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    loc?.total ?? _text('total', 'Total'),
                    totalCount,
                    AppColors.info,
                    Icons.book_online,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildStatItem(
                    loc?.bookingRequestPending ??
                        _text('bookingRequestPending', 'Pending'),
                    pendingCount,
                    AppColors.statusOrange,
                    Icons.pending,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsivePadding.top),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    loc?.bookingRequestApproved ??
                        _text('bookingRequestApproved', 'Approved'),
                    approvedCount,
                    AppColors.success,
                    Icons.check_circle,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildStatItem(
                    loc?.bookingRequestRejected ??
                        _text('bookingRequestRejected', 'Rejected'),
                    rejectedCount,
                    AppColors.statusRed,
                    Icons.cancel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem(String label, int count, Color color, IconData icon) {
    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile
          ? context.responsivePadding.top * 0.5
          : context.responsivePadding.top),
      backgroundColor: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      hasShadow: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: context.isMobile ? 18 : 24,
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: context.isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          // Row 2: Text below
          Text(
            label,
            style: TextStyle(
              fontSize: context.isMobile ? 10 : 12,
              color: (context.textTheme.bodySmall?.color ??
                      context.colors.onSurface)
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Builds structured zero-state content with hints and placeholder rows
  Widget _buildZeroStateContent() {
    final loc = AppLocalizations.of(context);

    return _buildPlaceholderRequestStructure(context, loc);
  }

  /// Builds placeholder request structure
  Widget _buildPlaceholderRequestStructure(
      BuildContext context, AppLocalizations? loc) {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: context.responsiveMargin.left,
        right: context.responsiveMargin.right,
        bottom: context.responsiveMargin.bottom,
      ),
      child: SectionContainer(
        title: _text(
            'recentBookingRequestsPreview', 'Recent Booking Requests Preview'),
        icon: Icons.book_online,
        child: Column(
          children: [
            // Placeholder request cards
            ...List.generate(
                3, (index) => _buildPlaceholderRequestCard(context)),
          ],
        ),
      ),
    );
  }

  /// Builds placeholder request card
  Widget _buildPlaceholderRequestCard(BuildContext context) {
    return AdaptiveCard(
      margin: EdgeInsets.only(bottom: context.responsivePadding.top),
      padding: EdgeInsets.all(context.isMobile
          ? context.responsivePadding.top * 0.5
          : context.responsivePadding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: context.isMobile ? 12 : 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeColors.getTextTertiary(context)
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              SizedBox(width: context.responsivePadding.left),
              Container(
                width: context.isMobile ? 60 : 80,
                height: context.isMobile ? 20 : 24,
                decoration: BoxDecoration(
                  color: ThemeColors.getDivider(context),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsivePadding.top * 0.5),
          // Location placeholder
          Row(
            children: [
              Icon(Icons.location_on,
                  size: context.isMobile ? 12 : 14,
                  color: ThemeColors.getTextTertiary(context)),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Container(
                height: context.isMobile ? 10 : 12,
                width: context.isMobile ? 120 : 150,
                decoration: BoxDecoration(
                  color: ThemeColors.getDivider(context),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? 4 : AppSpacing.paddingXS),
          // Date placeholder
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: context.isMobile ? 12 : 14,
                  color: ThemeColors.getTextTertiary(context)),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Container(
                height: context.isMobile ? 10 : 12,
                width: context.isMobile ? 100 : 120,
                decoration: BoxDecoration(
                  color: ThemeColors.getDivider(context),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
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
        padding: EdgeInsets.all(context.responsivePadding.top),
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
                    size: 14, color: ThemeColors.getTextTertiary(context)),
                SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: BodyText(
                    text: request.pgName,
                    color: ThemeColors.getTextTertiary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Request date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: ThemeColors.getTextTertiary(context)),
                SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: loc?.bookingRequestRequestedOn(
                        _formatDate(requestDate),
                      ) ??
                      _text('bookingRequestRequestedOn', 'Requested: {date}',
                          parameters: {'date': _formatDate(requestDate)}),
                  color: ThemeColors.getTextTertiary(context),
                ),
              ],
            ),
            // Response date if available
            if (respondedAt != null) ...[
              const SizedBox(height: AppSpacing.paddingXS),
              Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 14, color: ThemeColors.getTextTertiary(context)),
                  SizedBox(width: AppSpacing.paddingXS),
                  BodyText(
                    text: loc?.bookingRequestRespondedOn(
                          _formatDate(respondedAt),
                        ) ??
                        _text('bookingRequestRespondedOn', 'Responded: {date}',
                            parameters: {'date': _formatDate(respondedAt)}),
                    color: ThemeColors.getTextTertiary(context),
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
                color: ThemeColors.getTextTertiary(context),
              ),
            ],
            // Response message preview
            if (request.responseMessage != null &&
                request.responseMessage!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              AdaptiveCard(
                padding: EdgeInsets.all(context.isMobile
                    ? context.responsivePadding.top * 0.5
                    : AppSpacing.paddingS),
                backgroundColor: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                hasShadow: false,
                child: Row(
                  children: [
                    Icon(Icons.message, size: 16, color: statusColor),
                    SizedBox(width: AppSpacing.paddingS),
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
