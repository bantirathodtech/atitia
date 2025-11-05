// lib/features/guest_dashboard/payments/view/screens/guest_payment_screen.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/models/owner_payment_details_model.dart';
import '../../../../../core/repositories/owner_payment_details_repository.dart';
import '../../../../../core/viewmodels/payment_notification_viewmodel.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';
import '../../../../../feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import '../../../shared/viewmodel/guest_pg_selection_provider.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';

/// 💰 **GUEST PAYMENT SCREEN - PRODUCTION READY**
///
/// **Features:**
/// - View payment notification history
/// - Send payment notifications to owner
/// - Upload payment screenshot
/// - View owner's payment details (UPI/Bank/QR)
/// - Track payment status
/// - Premium theme-aware UI
class GuestPaymentScreen extends StatefulWidget {
  const GuestPaymentScreen({super.key});

  @override
  State<GuestPaymentScreen> createState() => _GuestPaymentScreenState();
}

class _GuestPaymentScreenState extends State<GuestPaymentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _ownerPaymentRepo = OwnerPaymentDetailsRepository();
  OwnerPaymentDetailsModel? _ownerPaymentDetails;
  bool _loadingOwnerDetails = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final paymentVM =
          Provider.of<PaymentNotificationViewModel>(context, listen: false);

      if (authProvider.user?.userId != null) {
        paymentVM.streamGuestNotifications(authProvider.user!.userId);
        // Load owner details from guest's selected PG
        _loadOwnerPaymentDetailsFromSelectedPg();
      }
    });
  }

  /// Loads owner payment details from guest's selected PG
  Future<void> _loadOwnerPaymentDetailsFromSelectedPg() async {
    final pgProvider = Provider.of<GuestPgSelectionProvider>(context, listen: false);
    final selectedPg = pgProvider.selectedPg;
    
    if (selectedPg == null || selectedPg.ownerUid.isEmpty) {
      // No PG selected, clear payment details
      if (mounted) {
        setState(() {
          _ownerPaymentDetails = null;
          _loadingOwnerDetails = false;
        });
      }
      return;
    }

    setState(() => _loadingOwnerDetails = true);
    try {
      final details = await _ownerPaymentRepo.getPaymentDetails(selectedPg.ownerUid);
      if (mounted) {
        setState(() {
          _ownerPaymentDetails = details;
          _loadingOwnerDetails = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingOwnerDetails = false);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Refresh payment data
  void _refreshData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final paymentVM =
        Provider.of<PaymentNotificationViewModel>(context, listen: false);

    if (authProvider.user?.userId != null) {
      paymentVM.streamGuestNotifications(authProvider.user!.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
            tooltip: 'Refresh',
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Tab Bar
          _buildTabBar(context, theme.brightness == Brightness.dark),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPaymentHistoryTab(context),
                _buildSendPaymentTab(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎨 Premium App Bar (non-sliver version)
  Widget _buildPremiumAppBar(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primary.withValues(alpha: 0.6),
                ]
              : [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.8),
                ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Payments',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      // TODO: Navigate to payment history
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Manage your payments',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🎨 Premium Sliver App Bar (kept for compatibility)
  Widget _buildPremiumSliverAppBar(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: isDarkMode ? AppColors.darkCard : primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: HeadingMedium(
          text: 'Payments',
          color: AppColors.textOnPrimary,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      AppColors.darkCard,
                      AppColors.darkCard.withValues(alpha: 0.9)
                    ]
                  : [primaryColor, primaryColor.withValues(alpha: 0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.account_balance_wallet,
                size: 48,
                color: AppColors.textOnPrimary.withValues(alpha: 0.9),
              ),
              const SizedBox(height: 8),
              Text(
                'Payment Management',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: AppColors.textOnPrimary),
          onPressed: () => _showPaymentInfo(context),
          tooltip: 'Payment Info',
        ),
      ],
    );
  }

  /// 📊 Tab Bar
  Widget _buildTabBar(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);

    return Container(
      color: isDarkMode ? AppColors.darkCard : AppColors.surface,
      child: TabBar(
        controller: _tabController,
        indicatorColor: theme.primaryColor,
        labelColor: theme.primaryColor,
        unselectedLabelColor:
            isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
        tabs: const [
          Tab(
            icon: Icon(Icons.history),
            text: 'History',
          ),
          Tab(
            icon: Icon(Icons.send),
            text: 'Send Payment',
          ),
        ],
      ),
    );
  }

  /// 📜 Payment History Tab
  Widget _buildPaymentHistoryTab(BuildContext context) {
    final paymentVM = Provider.of<PaymentNotificationViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (paymentVM.loading && paymentVM.notifications.isEmpty) {
      return _buildLoadingState(context);
    }

    if (paymentVM.notifications.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: paymentVM.notifications.length,
      itemBuilder: (context, index) {
        final notification = paymentVM.notifications[index];
        return _buildPaymentCard(context, notification, isDarkMode);
      },
    );
  }

  /// 💳 Payment Card
  Widget _buildPaymentCard(
      BuildContext context, dynamic notification, bool isDarkMode) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(notification.status);
    final statusIcon = _getStatusIcon(notification.status);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  statusColor.withValues(alpha: 0.2),
                  statusColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.borderRadiusL),
                topRight: Radius.circular(AppSpacing.borderRadiusL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingS),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${notification.amount.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        _formatDate(notification.timestamp),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDarkMode
                              ? AppColors.textTertiary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Text(
                    notification.status.toUpperCase(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (notification.paymentMethod != null) ...[
                  _buildDetailRow(
                    context,
                    'Payment Method',
                    notification.paymentMethod!,
                    Icons.payment,
                    isDarkMode,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (notification.transactionId != null) ...[
                  _buildDetailRow(
                    context,
                    'Transaction ID',
                    notification.transactionId!,
                    Icons.tag,
                    isDarkMode,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (notification.message != null) ...[
                  _buildDetailRow(
                    context,
                    'Message',
                    notification.message!,
                    Icons.message,
                    isDarkMode,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (notification.screenshotUrl != null) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    child: SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: AdaptiveImage(
                        imageUrl: notification.screenshotUrl!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                if (notification.ownerResponse != null) ...[
                  const SizedBox(height: AppSpacing.paddingM),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.darkInputFill
                          : AppColors.surfaceVariant,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.message,
                                size: 16, color: theme.primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              'Owner Response',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.ownerResponse!,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 📤 Send Payment Tab
  Widget _buildSendPaymentTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOwnerPaymentDetails(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildSendPaymentForm(context),
        ],
      ),
    );
  }

  /// 🏦 Owner Payment Details
  Widget _buildOwnerPaymentDetails(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_loadingOwnerDetails) {
      return ShimmerLoader(
        width: double.infinity,
        height: 200,
        borderRadius: AppSpacing.borderRadiusL,
      );
    }

    if (_ownerPaymentDetails == null) {
      return _buildOwnerPaymentDetailsEmptyState(context, isDarkMode);
    }

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: theme.primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: 'Owner Payment Details',
                  color: theme.textTheme.headlineSmall?.color,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (_ownerPaymentDetails!.upiId != null) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(text: 'UPI ID', color: AppColors.textSecondary),
                  const SizedBox(height: 4),
                  Text(
                    _ownerPaymentDetails!.upiId!,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (_ownerPaymentDetails!.upiQrCodeUrl != null) ...[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(text: 'UPI QR Code', color: AppColors.textSecondary),
                  const SizedBox(height: AppSpacing.paddingS),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    child: AdaptiveImage(
                      imageUrl: _ownerPaymentDetails!.upiQrCodeUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 📝 Send Payment Form
  Widget _buildSendPaymentForm(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Send Payment Notification',
            color: theme.textTheme.headlineSmall?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: 'After making payment, upload screenshot and notify owner',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PrimaryButton(
            onPressed: () => _showSendPaymentDialog(context),
            label: 'Send Payment Notification',
            icon: Icons.send,
          ),
        ],
      ),
    );
  }

  /// Helper: Detail row
  Widget _buildDetailRow(BuildContext context, String label, String value,
      IconData icon, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaptionText(
                text: label,
                color: isDarkMode
                    ? AppColors.textTertiary
                    : AppColors.textSecondary,
              ),
              const SizedBox(height: 2),
              BodyText(text: value),
            ],
          ),
        ),
      ],
    );
  }

  /// Helper: Status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.warning;
    }
  }

  /// Helper: Status icon
  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.pending;
    }
  }

  /// Helper: Format date
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  /// ⏳ Loading state
  Widget _buildLoadingState(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
          child: ShimmerLoader(
            width: double.infinity,
            height: 150,
            borderRadius: AppSpacing.borderRadiusL,
          ),
        );
      },
    );
  }

  /// 💳 Structured empty state with zero-state stats and placeholder data structure
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Zero-state stats section
          _buildPaymentZeroStateStats(context, isDarkMode),

          // Placeholder payment structure
          _buildPlaceholderPaymentStructure(context, isDarkMode),

          // Call to action
          _buildPaymentEmptyStateAction(context),
        ],
      ),
    );
  }

  /// 📊 Payment zero-state stats section
  Widget _buildPaymentZeroStateStats(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Payment Statistics',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'Total Payments',
                  '0',
                  Icons.payment,
                  Colors.blue,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'Pending',
                  '0',
                  Icons.pending,
                  Colors.orange,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'Completed',
                  '0',
                  Icons.check_circle,
                  Colors.green,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'Failed',
                  '0',
                  Icons.error,
                  Colors.red,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'Total Amount',
                  '₹0',
                  Icons.currency_rupee,
                  Colors.purple,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildPaymentStatCard(
                  context,
                  'This Month',
                  '₹0',
                  Icons.calendar_month,
                  Colors.teal,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 Individual payment stat card
  Widget _buildPaymentStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 💳 Placeholder payment structure
  Widget _buildPlaceholderPaymentStructure(
      BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Recent Payments Preview',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Placeholder payment cards
          ...List.generate(
              3, (index) => _buildPlaceholderPaymentCard(context, isDarkMode)),
        ],
      ),
    );
  }

  /// 💳 Placeholder payment card
  Widget _buildPlaceholderPaymentCard(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.payment,
                  color: Colors.grey.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Center(
                  child: Container(
                    height: 8,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔄 Payment empty state action section
  Widget _buildPaymentEmptyStateAction(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.payment,
            size: 48,
            color: isDarkMode ? Colors.white54 : Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(
            text: 'No Payment History',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            'Your payment notifications and history will appear here once you make payments.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Switch to send payment tab
                _tabController.animateTo(1);
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Payment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🏦 Owner payment details empty state
  Widget _buildOwnerPaymentDetailsEmptyState(
      BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: theme.primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: 'Owner Payment Details',
                  color: theme.textTheme.headlineSmall?.color,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 64,
                  color: isDarkMode ? Colors.white54 : Colors.grey[400],
                ),
                const SizedBox(height: AppSpacing.paddingM),
                HeadingMedium(
                  text: 'Payment Details Not Available',
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                const SizedBox(height: AppSpacing.paddingS),
                Text(
                  'Owner payment details are not configured yet. Please contact your PG owner to set up payment information.',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.paddingL),

                // Placeholder payment methods
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.05),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Methods Preview:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.paddingM),
                      _buildPlaceholderPaymentMethod(
                          context, 'UPI ID', 'Not Available', isDarkMode),
                      const SizedBox(height: AppSpacing.paddingS),
                      _buildPlaceholderPaymentMethod(
                          context, 'Bank Account', 'Not Available', isDarkMode),
                      const SizedBox(height: AppSpacing.paddingS),
                      _buildPlaceholderPaymentMethod(
                          context, 'Phone Number', 'Not Available', isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 💳 Placeholder payment method
  Widget _buildPlaceholderPaymentMethod(
      BuildContext context, String label, String value, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingS),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
        const Spacer(),
        Container(
          height: 12,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Dialog: Send payment
  void _showSendPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SendPaymentDialog(),
    );
  }

  /// Dialog: Payment info
  void _showPaymentInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Information'),
        content: const SingleChildScrollView(
          child: Text(
            'To make a payment:\n\n'
            '1. View owner\'s payment details (UPI/Bank)\n'
            '2. Make payment using your preferred method\n'
            '3. Take screenshot of payment confirmation\n'
            '4. Send payment notification with screenshot\n'
            '5. Wait for owner confirmation\n\n'
            'Owner will confirm once they receive the payment.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

/// Dialog for sending payment notification
class SendPaymentDialog extends StatefulWidget {
  const SendPaymentDialog({super.key});

  @override
  State<SendPaymentDialog> createState() => _SendPaymentDialogState();
}

class _SendPaymentDialogState extends State<SendPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _bookingRequestRepo = OwnerBookingRequestRepository();
  String _paymentMethod = 'UPI';
  dynamic _screenshotFile;
  bool _sending = false;

  @override
  void dispose() {
    _amountController.dispose();
    _messageController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Send Payment Notification'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.paddingM),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'UPI', child: Text('UPI')),
                  DropdownMenuItem(
                      value: 'Bank Transfer', child: Text('Bank Transfer')),
                  DropdownMenuItem(value: 'Cash', child: Text('Cash')),
                ],
                onChanged: (value) {
                  setState(() => _paymentMethod = value!);
                },
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextFormField(
                controller: _transactionIdController,
                decoration: const InputDecoration(
                  labelText: 'Transaction ID (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.paddingM),
              if (_screenshotFile != null)
                FutureBuilder<Uint8List>(
                  future: _screenshotFile.readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusM),
                          border: Border.all(color: theme.primaryColor),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusM),
                          child: Image.memory(
                            snapshot.data!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusM),
                        border: Border.all(color: theme.primaryColor),
                      ),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                )
              else
                OutlinedButton.icon(
                  onPressed: _pickScreenshot,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Screenshot'),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _sending ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _sending ? null : _sendPayment,
          child: _sending
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send'),
        ),
      ],
    );
  }

  Future<void> _pickScreenshot() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() => _screenshotFile = file);
    }
  }

  /// Gets the first approved booking request ID for the selected PG
  Future<String> _getApprovedBookingRequestId(String guestId, String pgId) async {
    try {
      // Use stream to get booking requests, then take first value
      final requestsStream = _bookingRequestRepo.streamGuestBookingRequests(guestId);
      final requests = await requestsStream.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => <OwnerBookingRequestModel>[],
      );
      
      // Find the first approved booking request for the selected PG
      final approvedRequest = requests.firstWhere(
        (request) => request.pgId == pgId && request.status == 'approved',
        orElse: () => throw StateError('No approved booking found'),
      );
      return approvedRequest.requestId;
    } catch (e) {
      // If no approved booking found, generate a fallback booking ID
      return 'booking_${guestId}_${pgId}_${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> _sendPayment() async {
    if (!_formKey.currentState!.validate()) return;

    // Get PG selection and validate
    final pgProvider = context.read<GuestPgSelectionProvider>();
    final selectedPg = pgProvider.selectedPg;
    final selectedPgId = pgProvider.selectedPgId;

    if (selectedPg == null || selectedPgId == null || selectedPgId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a PG first to send payment notification'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (selectedPg.ownerUid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid PG selection. Owner information not available.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _sending = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final paymentVM = context.read<PaymentNotificationViewModel>();
      final guestId = authProvider.user!.userId;

      // Get booking ID from approved booking request (or generate fallback)
      final bookingId = await _getApprovedBookingRequestId(guestId, selectedPgId);

      await paymentVM.sendPaymentNotification(
        guestId: guestId,
        ownerId: selectedPg.ownerUid,
        pgId: selectedPgId,
        bookingId: bookingId,
        amount: double.parse(_amountController.text),
        paymentMethod: _paymentMethod,
        transactionId: _transactionIdController.text.isEmpty
            ? null
            : _transactionIdController.text,
        paymentNote:
            _messageController.text.isEmpty ? null : _messageController.text,
        paymentScreenshot: _screenshotFile,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment notification sent successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send notification: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }
}

