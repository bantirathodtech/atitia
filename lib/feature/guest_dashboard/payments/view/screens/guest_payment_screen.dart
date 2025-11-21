// lib/features/guest_dashboard/payments/view/screens/guest_payment_screen.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/containers/section_container.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/models/owner_payment_details_model.dart';
import '../../../../../core/repositories/owner_payment_details_repository.dart';
import '../../../../../core/viewmodels/payment_notification_viewmodel.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../feature/owner_dashboard/myguest/data/models/owner_booking_request_model.dart';
import '../../../../../feature/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart';
import '../../../../../core/services/payment/razorpay_service.dart';
import '../../view/widgets/payment_method_selection_dialog.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../shared/viewmodel/guest_pg_selection_provider.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/guest_pg_selector_dropdown.dart';
import '../../../shared/widgets/user_location_display.dart';

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
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

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
    final pgProvider =
        Provider.of<GuestPgSelectionProvider>(context, listen: false);
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
      final details =
          await _ownerPaymentRepo.getPaymentDetails(selectedPg.ownerUid);
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
            onPressed: () => _refreshData(),
            tooltip: AppLocalizations.of(context)?.refresh ??
                _text('refresh', 'Refresh'),
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Tab Bar
          _buildTabBar(context, context.isDarkMode),
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

  /// 📊 Tab Bar
  Widget _buildTabBar(BuildContext context, bool isDarkMode) {
    final loc = AppLocalizations.of(context);

    return Container(
      color: ThemeColors.getCardBackground(context),
      child: TabBar(
        controller: _tabController,
        indicatorColor: context.primaryColor,
        labelColor: context.primaryColor,
        unselectedLabelColor: ThemeColors.getTextTertiary(context),
        tabs: [
          Tab(
            icon: const Icon(Icons.history),
            text: loc?.history ?? _text('history', 'History'),
          ),
          Tab(
            icon: const Icon(Icons.send),
            text: loc?.sendPayment ?? _text('sendPayment', 'Send Payment'),
          ),
        ],
      ),
    );
  }

  /// 📜 Payment History Tab
  Widget _buildPaymentHistoryTab(BuildContext context) {
    final paymentVM = Provider.of<PaymentNotificationViewModel>(context);
    final loc = AppLocalizations.of(context);

    if (paymentVM.loading && paymentVM.notifications.isEmpty) {
      return _buildLoadingState(context, loc);
    }

    if (paymentVM.notifications.isEmpty) {
      return _buildEmptyState(context, loc);
    }

    return ListView(
      padding: EdgeInsets.all(context.responsivePadding.top),
      children: [
        // User Location Display
        Padding(
          padding: EdgeInsets.only(bottom: context.responsivePadding.top),
          child: const UserLocationDisplay(),
        ),
        ...paymentVM.notifications.map(
            (notification) => _buildPaymentCard(context, notification, loc)),
      ],
    );
  }

  /// 💳 Payment Card
  Widget _buildPaymentCard(
      BuildContext context, dynamic notification, AppLocalizations? loc) {
    final statusColor = _getStatusColor(notification.status);
    final statusIcon = _getStatusIcon(notification.status);
    final statusLabel = _notificationStatusLabel(notification.status, loc);
    final paymentMethodLabel = notification.paymentMethod != null
        ? _notificationPaymentMethodLabel(notification.paymentMethod!, loc)
        : null;
    final formattedDate = _formatDate(notification.timestamp, loc);
    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: loc?.localeName,
      name: 'INR',
    );
    final formattedAmount = currencyFormatter.format(notification.amount);

    return Container(
      margin: EdgeInsets.only(bottom: context.responsivePadding.top),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(
              alpha: context.isDarkMode ? 0.3 : 0.05,
            ),
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
                        formattedAmount,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: ThemeColors.getTextTertiary(context),
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
                    statusLabel,
                    style: context.textTheme.bodySmall?.copyWith(
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
                    loc?.paymentMethod ??
                        _text('paymentMethod', 'Payment Method'),
                    paymentMethodLabel ?? notification.paymentMethod!,
                    Icons.payment,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (notification.transactionId != null) ...[
                  _buildDetailRow(
                    context,
                    loc?.transactionId ??
                        _text('transactionId', 'Transaction ID'),
                    notification.transactionId!,
                    Icons.tag,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (notification.message != null) ...[
                  _buildDetailRow(
                    context,
                    loc?.message ?? _text('message', 'Message'),
                    notification.message!,
                    Icons.message,
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
                      color: context.theme.inputDecorationTheme.fillColor,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.message,
                                size: 16, color: context.primaryColor),
                            const SizedBox(width: AppSpacing.paddingS),
                            Text(
                              loc?.ownerResponse ??
                                  _text('ownerResponse', 'Owner Response'),
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.paddingS),
                        Text(
                          notification.ownerResponse!,
                          style: context.textTheme.bodyMedium,
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
          // User Location Display
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: UserLocationDisplay(),
          ),
          _buildOwnerPaymentDetails(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildSendPaymentForm(context),
        ],
      ),
    );
  }

  /// 🏦 Owner Payment Details
  Widget _buildOwnerPaymentDetails(BuildContext context) {
    final loc = AppLocalizations.of(context);

    if (_loadingOwnerDetails) {
      return ShimmerLoader(
        width: double.infinity,
        height: 200,
        borderRadius: AppSpacing.borderRadiusL,
      );
    }

    if (_ownerPaymentDetails == null) {
      return _buildOwnerPaymentDetailsEmptyState(context, loc);
    }

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: context.primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: loc?.ownerPaymentDetails ??
                      _text('ownerPaymentDetails', 'Owner Payment Details'),
                  color: context.textTheme.headlineSmall?.color,
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
                  BodyText(
                      text: loc?.upiId ?? _text('upiId', 'UPI ID'),
                      color: ThemeColors.getTextTertiary(context)),
                  const SizedBox(height: AppSpacing.paddingXS),
                  Text(
                    _ownerPaymentDetails!.upiId!,
                    style: context.textTheme.titleMedium?.copyWith(
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
                  BodyText(
                      text: loc?.upiQrCode ?? _text('upiQrCode', 'UPI QR Code'),
                      color: ThemeColors.getTextTertiary(context)),
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
    final loc = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      padding: EdgeInsets.all(context.responsivePadding.top * 1.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.sendPaymentNotification ??
                _text('sendPaymentNotification', 'Send Payment Notification'),
            color: context.textTheme.headlineSmall?.color,
          ),
          SizedBox(height: context.responsivePadding.top),
          BodyText(
            text: loc?.afterMakingPaymentUploadScreenshot ??
                _text('afterMakingPaymentUploadScreenshot',
                    'After making payment, upload screenshot and notify owner'),
            color: ThemeColors.getTextTertiary(context),
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PrimaryButton(
            onPressed: () => _showSendPaymentDialog(context),
            label: loc?.sendPaymentNotification ??
                _text('sendPaymentNotification', 'Send Payment Notification'),
            icon: Icons.send,
          ),
        ],
      ),
    );
  }

  /// Helper: Detail row
  Widget _buildDetailRow(
      BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: ThemeColors.getTextTertiary(context),
        ),
        const SizedBox(width: AppSpacing.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaptionText(
                text: label,
                color: ThemeColors.getTextTertiary(context),
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

  String _notificationStatusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return loc?.confirmed ?? _text('confirmed', 'Confirmed');
      case 'rejected':
        return loc?.rejected ?? _text('rejected', 'Rejected');
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      default:
        return status;
    }
  }

  String _notificationPaymentMethodLabel(String method, AppLocalizations? loc) {
    switch (method.toLowerCase()) {
      case 'razorpay':
        return loc?.paymentMethodRazorpay ??
            _text('paymentMethodRazorpay', 'Razorpay');
      case 'upi':
        return loc?.paymentMethodUpi ?? _text('paymentMethodUpi', 'UPI');
      case 'cash':
        return loc?.paymentMethodCash ?? _text('paymentMethodCash', 'Cash');
      case 'bank_transfer':
        return loc?.paymentMethodBankTransfer ??
            _text('paymentMethodBankTransfer', 'Bank Transfer');
      default:
        return loc?.paymentMethodOther ?? _text('paymentMethodOther', 'Other');
    }
  }

  /// Helper: Format date
  String _formatDate(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName;
    final datePart = DateFormat.yMMMd(locale).format(date);
    final timePart = DateFormat.jm(locale).format(date);
    return '$datePart • $timePart';
  }

  /// ⏳ Loading state
  Widget _buildLoadingState(BuildContext context, AppLocalizations? loc) {
    return ListView.builder(
      padding: EdgeInsets.all(context.responsivePadding.top),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: context.responsivePadding.top),
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
  Widget _buildEmptyState(BuildContext context, AppLocalizations? loc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Zero-state stats section
          _buildPaymentZeroStateStats(context, loc, false),

          // Small gap between stats and placeholder
          SizedBox(height: context.responsivePadding.top * 0.5),

          // Placeholder payment structure
          _buildPlaceholderPaymentStructure(context, loc, false),
        ],
      ),
    );
  }

  /// 📊 Payment zero-state stats section
  Widget _buildPaymentZeroStateStats(
      BuildContext context, AppLocalizations? loc, bool isDarkMode) {
    return Padding(
      padding: context.responsiveMargin,
      child: SectionContainer(
        title: loc?.paymentStatistics ??
            _text('paymentStatistics', 'Payment Statistics'),
        icon: Icons.payment,
        child: Column(
          children: [
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.totalPayments ??
                        _text('totalPayments', 'Total Payments'),
                    '0',
                    Icons.payment,
                    AppColors.info,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.pending ?? _text('pending', 'Pending'),
                    '0',
                    Icons.pending,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsivePadding.top),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.completed ?? _text('completed', 'Completed'),
                    '0',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.failed ?? _text('failed', 'Failed'),
                    '0',
                    Icons.error,
                    AppColors.error,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsivePadding.top),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.totalAmount ?? _text('totalAmount', 'Total Amount'),
                    '₹0',
                    Icons.currency_rupee,
                    AppColors.purple,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildPaymentStatCard(
                    context,
                    loc?.thisMonth ?? _text('thisMonth', 'This Month'),
                    '₹0',
                    Icons.calendar_month,
                    AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ),
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
  ) {
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
                value,
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

  /// 💳 Placeholder payment structure
  Widget _buildPlaceholderPaymentStructure(
      BuildContext context, AppLocalizations? loc, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: context.responsiveMargin.left,
        right: context.responsiveMargin.right,
        bottom: context.responsiveMargin.bottom,
      ),
      child: SectionContainer(
        title: loc?.recentPaymentsPreview ??
            _text('recentPaymentsPreview', 'Recent Payments Preview'),
        icon: Icons.payment,
        child: Column(
          children: [
            // Placeholder payment cards
            ...List.generate(
                3,
                (index) => _buildPlaceholderPaymentCard(
                      context,
                      loc,
                      false, // isDarkMode not needed
                    )),
          ],
        ),
      ),
    );
  }

  /// 💳 Placeholder payment card
  Widget _buildPlaceholderPaymentCard(
      BuildContext context, AppLocalizations? loc, bool isDarkMode) {
    return AdaptiveCard(
      margin: EdgeInsets.only(bottom: context.responsivePadding.top),
      padding: EdgeInsets.all(context.isMobile
          ? context.responsivePadding.top * 0.5
          : context.responsivePadding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.payment,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: context.isMobile ? 10 : 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 6 : 8,
                      width: context.isMobile ? 80 : 100,
                      decoration: BoxDecoration(
                        color: ThemeColors.getDivider(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: context.isMobile ? 60 : 80,
                height: context.isMobile ? 20 : 24,
                decoration: BoxDecoration(
                  color: ThemeColors.getDivider(context),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Center(
                  child: Container(
                    height: context.isMobile ? 6 : 8,
                    width: context.isMobile ? 40 : 60,
                    decoration: BoxDecoration(
                      color: ThemeColors.getTextTertiary(context)
                          .withValues(alpha: 0.4),
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
                      loc?.amount ?? _text('amount', 'Amount'),
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 60 : 80,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
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
                      loc?.status ?? _text('status', 'Status'),
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 50 : 60,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
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
                      loc?.date ?? _text('date', 'Date'),
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 60 : 70,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
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

  /// 🏦 Owner payment details empty state
  Widget _buildOwnerPaymentDetailsEmptyState(
      BuildContext context, AppLocalizations? loc) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.account_balance, color: context.primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: loc?.ownerPaymentDetails ??
                      _text('ownerPaymentDetails', 'Owner Payment Details'),
                  color: context.textTheme.headlineSmall?.color,
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
                  size: context.isMobile ? 48 : 64,
                  color: ThemeColors.getTextTertiary(context),
                ),
                SizedBox(height: context.responsivePadding.top),
                HeadingSmall(
                  text: loc?.paymentDetailsNotAvailable ??
                      _text('paymentDetailsNotAvailable',
                          'Payment Details Not Available'),
                  color: context.textTheme.bodyLarge?.color ??
                      context.colors.onSurface,
                ),
                SizedBox(
                    height: context.isMobile
                        ? AppSpacing.paddingS
                        : context.responsivePadding.top * 0.5),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.responsivePadding.left),
                  child: Text(
                    loc?.ownerPaymentDetailsNotConfigured ??
                        _text(
                          'ownerPaymentDetailsNotConfigured',
                          'Owner payment details are not configured yet. Please contact your PG owner to set up payment information.',
                        ),
                    style: TextStyle(
                      color: ThemeColors.getTextTertiary(context),
                      fontSize: context.isMobile ? 12 : 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: context.responsivePadding.top * 1.5),

                // Placeholder payment methods
                Container(
                  padding: EdgeInsets.all(context.isMobile
                      ? context.responsivePadding.top * 0.5
                      : context.responsivePadding.top),
                  decoration: BoxDecoration(
                    color: context.theme.inputDecorationTheme.fillColor,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc?.paymentMethodsPreview ??
                            _text('paymentMethodsPreview',
                                'Payment Methods Preview:'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.textTheme.bodyLarge?.color ??
                              context.colors.onSurface,
                        ),
                      ),
                      SizedBox(height: context.responsivePadding.top),
                      _buildPlaceholderPaymentMethod(
                          context,
                          loc?.upiId ?? _text('upiId', 'UPI ID'),
                          loc?.notAvailable ??
                              _text('notAvailable', 'Not Available')),
                      SizedBox(
                          height: context.isMobile
                              ? AppSpacing.paddingS
                              : context.responsivePadding.top * 0.5),
                      _buildPlaceholderPaymentMethod(
                          context,
                          loc?.bankAccount ??
                              _text('bankAccount', 'Bank Account'),
                          loc?.notAvailable ??
                              _text('notAvailable', 'Not Available')),
                      SizedBox(
                          height: context.isMobile
                              ? AppSpacing.paddingS
                              : context.responsivePadding.top * 0.5),
                      _buildPlaceholderPaymentMethod(
                          context,
                          loc?.phoneNumber ??
                              _text('phoneNumber', 'Phone Number'),
                          loc?.notAvailable ??
                              _text('notAvailable', 'Not Available')),
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
      BuildContext context, String label, String value) {
    return Row(
      children: [
        Container(
          width: context.isMobile ? 6 : 8,
          height: context.isMobile ? 6 : 8,
          decoration: BoxDecoration(
            color: ThemeColors.getTextTertiary(context).withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
            width:
                context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
        Text(
          label,
          style: TextStyle(
            fontSize: context.isMobile ? 10 : 12,
            color: ThemeColors.getTextTertiary(context),
          ),
        ),
        const Spacer(),
        Container(
          height: context.isMobile ? 10 : 12,
          width: context.isMobile ? 60 : 80,
          decoration: BoxDecoration(
            color: ThemeColors.getDivider(context),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  /// Dialog: Send payment
  void _showSendPaymentDialog(BuildContext context) async {
    // Get owner payment details to check if Razorpay is enabled
    final pgProvider = context.read<GuestPgSelectionProvider>();
    final selectedPg = pgProvider.selectedPg;

    bool razorpayEnabled = false;
    if (selectedPg != null && selectedPg.ownerUid.isNotEmpty) {
      try {
        final paymentDetails =
            await _ownerPaymentRepo.getPaymentDetails(selectedPg.ownerUid);
        razorpayEnabled = paymentDetails?.razorpayEnabled ?? false;
      } catch (e) {
        // If error fetching, default to false
        razorpayEnabled = false;
      }
    }

    // Show payment method selection first
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Store context before async operations
    // Changed from: Using context after await without proper mounted check
    // Changed to: Store context before await, check mounted after before using
    // Note: Analyzer flags passing context to async methods, but this is safe as methods check mounted internally
    if (!mounted) return;
    final currentContext = context;
    final selectedMethod = await PaymentMethodSelectionDialog.show(
      // ignore: use_build_context_synchronously
      currentContext,
      razorpayEnabled: razorpayEnabled,
    );

    if (selectedMethod == null || !mounted) return;

    // Show payment form based on selected method
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Check mounted immediately before using context after async gap
    // Changed from: Using context after await with unrelated mounted check
    // Changed to: Check mounted immediately before context usage
    // Note: showDialog is safe to use after async when mounted check is performed, analyzer flags as false positive
    if (!mounted) return;
    final dialogContext = context;
    showDialog(
      // ignore: use_build_context_synchronously
      context: dialogContext,
      builder: (context) => SendPaymentDialog(
        paymentMethod: selectedMethod,
      ),
    );
  }
}

/// Dialog for sending payment notification
class SendPaymentDialog extends StatefulWidget {
  final PaymentMethodType paymentMethod;

  const SendPaymentDialog({
    super.key,
    required this.paymentMethod,
  });

  @override
  State<SendPaymentDialog> createState() => _SendPaymentDialogState();
}

class _SendPaymentDialogState extends State<SendPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _messageController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _bookingRequestRepo = OwnerBookingRequestRepository();
  final _razorpayService = RazorpayService();
  dynamic _screenshotFile;
  bool _sending = false;
  bool _processingRazorpay = false;
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

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
  void initState() {
    super.initState();
    if (widget.paymentMethod == PaymentMethodType.razorpay) {
      _razorpayService.initialize();
    }
  }

  @override
  void dispose() {
    if (widget.paymentMethod == PaymentMethodType.razorpay) {
      _razorpayService.dispose();
    }
    _amountController.dispose();
    _messageController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(_getDialogTitle(loc)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount field (required for all methods)
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: loc?.amount ?? _text('amount', 'Amount'),
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return loc?.pleaseEnterAmount ??
                        _text('pleaseEnterAmount', 'Please enter amount');
                  }
                  if (double.tryParse(value) == null) {
                    return loc?.pleaseEnterValidAmount ??
                        _text('pleaseEnterValidAmount',
                            'Please enter valid amount');
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.paddingM),

              // Method-specific fields
              if (widget.paymentMethod == PaymentMethodType.upi) ...[
                // UPI: Screenshot (required) - Transaction ID is visible in screenshot
                _buildScreenshotUpload(context, theme, loc),
                const SizedBox(height: AppSpacing.paddingM),
                // Transaction ID field is optional - screenshot already contains it
                Builder(
                  builder: (context) {
                    return TextFormField(
                      controller: _transactionIdController,
                      decoration: InputDecoration(
                        labelText: loc?.transactionIdOptional ??
                            _text('transactionIdOptional',
                                'Transaction ID (Optional)'),
                        hintText: loc?.notRequiredAlreadyVisibleInScreenshot ??
                            _text('notRequiredAlreadyVisibleInScreenshot',
                                'Not required - already visible in screenshot'),
                        helperText:
                            loc?.youCanSkipThisTransactionIdIsInScreenshot ??
                                _text(
                                  'youCanSkipThisTransactionIdIsInScreenshot',
                                  'You can skip this - transaction ID is in the screenshot',
                                ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.paddingM),
                BodyText(
                  text: loc?.upiPaymentTip ??
                      _text('upiPaymentTip',
                          '💡 Tip: After making payment via PhonePe, Paytm, Google Pay, etc., upload the payment screenshot. The transaction ID is already visible in the screenshot.'),
                  color: AppColors.textSecondary,
                  small: true,
                ),
              ] else if (widget.paymentMethod == PaymentMethodType.cash) ...[
                // Cash: Message only
                BodyText(
                  text: loc?.cashPaymentNotificationInfo ??
                      _text('cashPaymentNotificationInfo',
                          'You will send a cash payment notification to the owner. Owner will confirm once they receive the cash.'),
                  color: AppColors.textSecondary,
                  small: true,
                ),
                const SizedBox(height: AppSpacing.paddingM),
              ] else if (widget.paymentMethod ==
                  PaymentMethodType.razorpay) ...[
                // Razorpay: No additional fields needed
                BodyText(
                  text: loc?.payViaRazorpayDescription ??
                      _text('payViaRazorpayDescription',
                          'Click "Pay Now" to proceed with secure online payment via Razorpay.'),
                  color: AppColors.textSecondary,
                  small: true,
                ),
                const SizedBox(height: AppSpacing.paddingM),
              ],

              // Message field (optional for all methods)
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  labelText: loc?.messageOptional ??
                      _text('messageOptional', 'Message (Optional)'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: (_sending || _processingRazorpay)
              ? null
              : () => Navigator.pop(context),
          child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
        ),
        PrimaryButton(
          onPressed: (_sending || _processingRazorpay) ? null : _handlePayment,
          label: _getButtonText(loc),
          isLoading: _sending || _processingRazorpay,
          enabled: !(_sending || _processingRazorpay),
        ),
      ],
    );
  }

  String _getDialogTitle(AppLocalizations? loc) {
    switch (widget.paymentMethod) {
      case PaymentMethodType.razorpay:
        return loc?.payViaRazorpay ??
            _text('payViaRazorpay', 'Pay via Razorpay');
      case PaymentMethodType.upi:
        return loc?.upiPaymentConfirmation ??
            _text('upiPaymentConfirmation', 'UPI Payment Confirmation');
      case PaymentMethodType.cash:
        return loc?.cashPaymentNotification ??
            _text('cashPaymentNotification', 'Cash Payment Notification');
    }
  }

  String _getButtonText(AppLocalizations? loc) {
    switch (widget.paymentMethod) {
      case PaymentMethodType.razorpay:
        return loc?.payNow ?? _text('payNow', 'Pay Now');
      case PaymentMethodType.upi:
        return loc?.sendPayment ?? _text('sendPayment', 'Send Payment');
      case PaymentMethodType.cash:
        return loc?.sendNotification ??
            _text('sendNotification', 'Send Notification');
    }
  }

  Widget _buildScreenshotUpload(
      BuildContext context, ThemeData theme, AppLocalizations? loc) {
    if (_screenshotFile != null) {
      return FutureBuilder<Uint8List>(
        future: _screenshotFile.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(color: theme.primaryColor),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusM),
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 150,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: Theme.of(context).colorScheme.onPrimary),
                          onPressed: () {
                            setState(() => _screenshotFile = null);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc?.screenshotUploaded ??
                      _text('screenshotUploaded', 'Screenshot uploaded'),
                  color: AppColors.success,
                  small: true,
                ),
              ],
            );
          }
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: theme.primaryColor),
            ),
            child: const Center(child: AdaptiveLoader()),
          );
        },
      );
    }
    return OutlinedButton.icon(
      onPressed: _pickScreenshot,
      icon: const Icon(Icons.upload_file),
      label: Text(loc?.uploadPaymentScreenshot ??
          _text('uploadPaymentScreenshot', 'Upload Payment Screenshot')),
    );
  }

  Future<void> _pickScreenshot() async {
    final file = await ImagePickerHelper.pickImageFromGallery();
    if (file != null) {
      setState(() => _screenshotFile = file);
    }
  }

  /// Gets the first approved booking request ID for the selected PG
  Future<String> _getApprovedBookingRequestId(
      String guestId, String pgId) async {
    try {
      // Use stream to get booking requests, then take first value
      final requestsStream =
          _bookingRequestRepo.streamGuestBookingRequests(guestId);
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

  /// Handle payment based on selected method
  Future<void> _handlePayment() async {
    switch (widget.paymentMethod) {
      case PaymentMethodType.razorpay:
        await _processRazorpayPayment();
        break;
      case PaymentMethodType.upi:
        await _sendUpiPayment();
        break;
      case PaymentMethodType.cash:
        await _sendCashPayment();
        break;
    }
  }

  /// Process Razorpay payment
  Future<void> _processRazorpayPayment() async {
    if (!_formKey.currentState!.validate()) return;

    // Get PG selection and validate
    final pgProvider = context.read<GuestPgSelectionProvider>();
    final selectedPg = pgProvider.selectedPg;
    final selectedPgId = pgProvider.selectedPgId;

    if (selectedPg == null || selectedPgId == null || selectedPgId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.pleaseSelectPgFirst ??
                _text('pleaseSelectPgFirst', 'Please select a PG first')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (selectedPg.ownerUid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.invalidPgSelectionOwnerInfoNotAvailable ??
                _text('invalidPgSelectionOwnerInfoNotAvailable',
                    'Invalid PG selection. Owner information not available.')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _processingRazorpay = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final guestId = authProvider.user!.userId;
      final amount = double.parse(_amountController.text);
      final orderId =
          'order_${guestId}_${DateTime.now().millisecondsSinceEpoch}';

      // Open Razorpay payment
      await _razorpayService.openPayment(
        amount: (amount * 100).toInt(), // Convert to paise
        orderId: orderId,
        ownerId: selectedPg.ownerUid, // Pass owner ID to fetch Razorpay key
        description: _messageController.text.isEmpty
            ? (AppLocalizations.of(context)?.pgPayment ??
                _text('pgPayment', 'PG Payment'))
            : _messageController.text,
        userName: authProvider.user?.fullName ??
            (AppLocalizations.of(context)?.guest ?? _text('guest', 'Guest')),
        userEmail: authProvider.user?.email,
        userPhone: authProvider.user?.phoneNumber,
        onSuccess: (orderId, response) async {
          // Payment successful - create payment record and notification
          await _sendPaymentNotification(
            paymentMethod: 'razorpay',
            transactionId: response.paymentId ?? '',
            razorpayOrderId: orderId,
            razorpayPaymentId: response.paymentId ?? '',
          );

          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)
                        ?.paymentSuccessfulOwnerWillBeNotified ??
                    _text('paymentSuccessfulOwnerWillBeNotified',
                        'Payment successful! Owner will be notified.')),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        onFailure: (response) {
          if (mounted) {
            final errorMessage = response.message ?? 'Unknown error';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context)?.paymentFailed(errorMessage) ??
                        _text('paymentFailed', 'Payment failed: {message}',
                            parameters: {'message': errorMessage})),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.failedToProcessPayment(e.toString()) ??
                _text('failedToProcessPayment',
                    'Failed to process payment: {error}',
                    parameters: {'error': e.toString()})),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processingRazorpay = false);
      }
    }
  }

  /// Send UPI payment notification with screenshot
  Future<void> _sendUpiPayment() async {
    if (!_formKey.currentState!.validate()) return;

    // For UPI, screenshot is required as it contains the transaction ID
    // Transaction ID field is optional - owner can extract it from screenshot if needed
    if (_screenshotFile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.pleaseUploadPaymentScreenshot ??
                _text('pleaseUploadPaymentScreenshot',
                    'Please upload payment screenshot. Transaction ID is visible in the screenshot.')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    await _sendPaymentNotification(
      paymentMethod: 'upi',
      transactionId: _transactionIdController.text.isEmpty
          ? null
          : _transactionIdController.text,
      paymentScreenshot: _screenshotFile,
    );
  }

  /// Send cash payment notification
  Future<void> _sendCashPayment() async {
    if (!_formKey.currentState!.validate()) return;

    await _sendPaymentNotification(
      paymentMethod: 'cash',
    );
  }

  /// Common method to send payment notification
  Future<void> _sendPaymentNotification({
    required String paymentMethod,
    String? transactionId,
    String? razorpayOrderId,
    String? razorpayPaymentId,
    dynamic paymentScreenshot,
  }) async {
    // Get PG selection and validate
    final pgProvider = context.read<GuestPgSelectionProvider>();
    final selectedPg = pgProvider.selectedPg;
    final selectedPgId = pgProvider.selectedPgId;
    final loc = AppLocalizations.of(context);

    if (selectedPg == null || selectedPgId == null || selectedPgId.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc?.pleaseSelectPgFirst ??
                _text('pleaseSelectPgFirst', 'Please select a PG first')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (selectedPg.ownerUid.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc?.invalidPgSelectionOwnerInfoNotAvailable ??
                _text('invalidPgSelectionOwnerInfoNotAvailable',
                    'Invalid PG selection. Owner information not available.')),
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
      final bookingId =
          await _getApprovedBookingRequestId(guestId, selectedPgId);

      // Map payment method type to string
      String paymentMethodString;
      switch (widget.paymentMethod) {
        case PaymentMethodType.razorpay:
          paymentMethodString = 'razorpay';
          break;
        case PaymentMethodType.upi:
          paymentMethodString = 'upi';
          break;
        case PaymentMethodType.cash:
          paymentMethodString = 'cash';
          break;
      }

      await paymentVM.sendPaymentNotification(
        guestId: guestId,
        ownerId: selectedPg.ownerUid,
        pgId: selectedPgId,
        bookingId: bookingId,
        amount: double.parse(_amountController.text),
        paymentMethod: paymentMethodString,
        transactionId: transactionId,
        paymentNote:
            _messageController.text.isEmpty ? null : _messageController.text,
        paymentScreenshot: paymentScreenshot,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.paymentMethod == PaymentMethodType.cash
                  ? (loc?.cashPaymentNotificationSent ??
                      _text('cashPaymentNotificationSent',
                          'Cash payment notification sent. Owner will confirm once they receive the payment.'))
                  : (loc?.paymentNotificationSentSuccessfully ??
                      _text('paymentNotificationSentSuccessfully',
                          'Payment notification sent successfully')),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc?.failedToSendNotification(e.toString()) ??
                _text('failedToSendNotification',
                    'Failed to send notification: {error}',
                    parameters: {'error': e.toString()})),
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
