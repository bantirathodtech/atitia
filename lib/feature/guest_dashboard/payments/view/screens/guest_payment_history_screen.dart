// lib/feature/guest_dashboard/payments/view/screens/guest_payment_history_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../feature/guest_dashboard/shared/widgets/user_location_display.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../data/models/guest_payment_model.dart';
import '../../viewmodel/guest_payment_viewmodel.dart';

/// Comprehensive payment history screen
/// Shows all payments with filtering, sorting, and search capabilities
class GuestPaymentHistoryScreen extends StatefulWidget {
  const GuestPaymentHistoryScreen({super.key});

  @override
  State<GuestPaymentHistoryScreen> createState() =>
      _GuestPaymentHistoryScreenState();
}

class _GuestPaymentHistoryScreenState extends State<GuestPaymentHistoryScreen> {
  String _selectedFilter = 'all';
  final List<String> _filters = ['all', 'pending', 'paid', 'overdue', 'failed'];
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paymentVM =
          Provider.of<GuestPaymentViewModel>(context, listen: false);
      paymentVM.loadPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc?.paymentHistory ??
            _text('paymentHistory', 'Payment History'),
        showBackButton: true,
      ),
      body: Column(
        children: [
          // User Location Display
          const Padding(
            padding: EdgeInsets.all(AppSpacing.paddingM),
            child: UserLocationDisplay(),
          ),

          // Filter Chips
          _buildFilterSection(context, isDarkMode, loc),

          // Payment List
          Expanded(
            child: Consumer<GuestPaymentViewModel>(
              builder: (context, paymentVM, _) {
                if (paymentVM.loading && paymentVM.payments.isEmpty) {
                  return const Center(child: AdaptiveLoader());
                }

                if (paymentVM.payments.isEmpty) {
                  return _buildEmptyState(context, loc);
                }

                final filteredPayments = _getFilteredPayments(paymentVM);

                if (filteredPayments.isEmpty) {
                  return _buildEmptyFilterState(
                    context,
                    loc,
                    _selectedFilter,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final payment = filteredPayments[index];
                    return _buildPaymentCard(
                      context,
                      payment,
                      isDarkMode,
                      loc,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            final label = _filterLabel(filter, loc);
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.paddingS),
              child: FilterChip(
                label: Text(label),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  final paymentVM =
                      Provider.of<GuestPaymentViewModel>(context, listen: false);
                  paymentVM.setFilter(filter);
                },
                backgroundColor: isDarkMode
                    ? AppColors.darkCard
                    : AppColors.surface,
                selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : isDarkMode
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context,
    GuestPaymentModel payment,
    bool isDarkMode,
    AppLocalizations? loc,
  ) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(payment.status);
    final statusIcon = _getStatusIcon(payment.status);
    final statusLabel = _statusLabel(payment.status, loc);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        onTap: () {
          context.push(AppRoutes.guestPaymentDetails(payment.paymentId));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingS),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(
                        text: payment.paymentType,
                        color: theme.textTheme.titleMedium?.color,
                      ),
                      CaptionText(
                        text: _formatDate(payment.paymentDate, loc),
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatAmount(payment.amount, loc),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            const Divider(),
            const SizedBox(height: AppSpacing.paddingS),
            // Payment Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    loc?.dueDate ?? _text('dueDate', 'Due Date'),
                    _formatDate(payment.dueDate, loc),
                    Icons.calendar_today,
                  ),
                ),
                if (payment.transactionId != null)
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      loc?.transactionId ??
                          _text('transactionId', 'Transaction ID'),
                      payment.transactionId!.length > 12
                          ? '${payment.transactionId!.substring(0, 12)}...'
                          : payment.transactionId!,
                      Icons.receipt,
                    ),
                  ),
              ],
            ),
            if (payment.paymentMethod.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Row(
                children: [
                  Icon(
                    _getPaymentMethodIcon(payment.paymentMethod),
                    size: 16,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: AppSpacing.paddingXS),
                  BodyText(
                    text: loc?.paymentMethodWithValue(
                          _paymentMethodLabel(payment.paymentMethod, loc),
                        ) ??
                        _text(
                          'paymentMethodWithValue',
                          'Payment Method: {method}',
                          parameters: {
                            'method':
                                _paymentMethodLabel(payment.paymentMethod, loc),
                          },
                        ),
                    small: true,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodySmall?.color),
        const SizedBox(width: AppSpacing.paddingXS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaptionText(
                text: label,
                color: theme.textTheme.bodySmall?.color,
              ),
              BodyText(
                text: value,
                small: true,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations? loc) {
    return EmptyState(
      title: loc?.noPaymentsYet ??
          _text('noPaymentsYet', 'No Payments Yet'),
      message: loc?.noPaymentsYetDescription ??
          _text(
            'noPaymentsYetDescription',
            'You haven\'t made any payments yet. Payments will appear here once you make them.',
          ),
      icon: Icons.account_balance_wallet_outlined,
      actionLabel:
          loc?.makePayment ?? _text('makePayment', 'Make Payment'),
      onAction: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildEmptyFilterState(
    BuildContext context,
    AppLocalizations? loc,
    String filter,
  ) {
    final filterLabel = _filterLabel(filter, loc);
    return EmptyState(
      title: loc?.noPaymentsForFilter(filterLabel) ??
          _text('noPaymentsForFilter', 'No {filter} Payments',
              parameters: {'filter': filterLabel}),
      message: loc?.noPaymentsForFilterDescription(filterLabel) ??
          _text('noPaymentsForFilterDescription',
              'You don\'t have any {filter} payments at the moment.',
              parameters: {'filter': filterLabel}),
      icon: Icons.filter_list_outlined,
    );
  }

  String _filterLabel(String filter, AppLocalizations? loc) {
    switch (filter.toLowerCase()) {
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      case 'paid':
        return loc?.paid ?? _text('paid', 'Paid');
      case 'overdue':
        return loc?.overdue ?? _text('overdue', 'Overdue');
      case 'failed':
        return loc?.failed ?? _text('failed', 'Failed');
      default:
        return loc?.all ?? _text('all', 'All');
    }
  }

  String _statusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'paid':
        return loc?.paid ?? _text('paid', 'Paid');
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      case 'overdue':
        return loc?.overdue ?? _text('overdue', 'Overdue');
      case 'failed':
        return loc?.failed ?? _text('failed', 'Failed');
      case 'refunded':
        return loc?.refunded ?? _text('refunded', 'Refunded');
      default:
        return status;
    }
  }

  String _paymentMethodLabel(String method, AppLocalizations? loc) {
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
        return loc?.paymentMethodOther ??
            _text('paymentMethodOther', 'Other');
    }
  }

  List<GuestPaymentModel> _getFilteredPayments(GuestPaymentViewModel paymentVM) {
    switch (_selectedFilter.toLowerCase()) {
      case 'pending':
        return paymentVM.pendingPayments;
      case 'overdue':
        return paymentVM.overduePayments;
      case 'paid':
        return paymentVM.payments
            .where((p) => p.status.toLowerCase() == 'paid')
            .toList();
      case 'failed':
        return paymentVM.payments
            .where((p) => p.status.toLowerCase() == 'failed')
            .toList();
      default:
        return paymentVM.payments;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'overdue':
        return Icons.warning;
      case 'failed':
        return Icons.error;
      case 'refunded':
        return Icons.refresh;
      default:
        return Icons.help;
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'razorpay':
        return Icons.credit_card;
      case 'upi':
        return Icons.account_balance_wallet;
      case 'cash':
        return Icons.money;
      case 'bank_transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  String _formatDate(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName ?? 'en_IN';
    return DateFormat.yMMMd(locale).format(date);
  }

  String _formatAmount(double amount, AppLocalizations? loc) {
    final locale = loc?.localeName ?? 'en_IN';
    final currencySymbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    return NumberFormat.currency(locale: locale, symbol: currencySymbol).format(amount);
  }
}

