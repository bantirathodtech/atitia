// lib/features/owner_dashboard/mypg/presentation/widgets/owner_revenue_report_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// Widget displaying revenue report with financial statistics
class OwnerRevenueReportWidget extends StatelessWidget {
  final OwnerRevenueReport report;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const OwnerRevenueReportWidget({
    required this.report,
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
    final currencyFormatter = NumberFormat.currency(
      locale: loc?.localeName,
      symbol: '₹',
      decimalDigits: 0,
    );
    final numberFormatter = NumberFormat.decimalPattern(loc?.localeName);
    final collectedText = currencyFormatter.format(report.collectedAmount);
    final pendingText = currencyFormatter.format(report.pendingAmount);
    final totalPaymentsText = numberFormatter.format(report.totalPayments);
    final collectedCountText = numberFormatter.format(report.collectedPayments);

    return AdaptiveCard(
      padding: EdgeInsets.all(
          context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded,
                  color: AppColors.success, size: context.isMobile ? 18 : 20),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: HeadingMedium(
                  text: loc?.ownerRevenueReportTitle ??
                      _text('ownerRevenueReportTitle', 'Revenue Report'),
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  loc?.ownerRevenueReportCollectedLabel ??
                      _text('ownerRevenueReportCollectedLabel', 'Collected'),
                  collectedText,
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: _buildStatItem(
                  context,
                  loc?.ownerRevenueReportPendingLabel ??
                      _text('ownerRevenueReportPendingLabel', 'Pending'),
                  pendingText,
                  Icons.schedule,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  loc?.ownerRevenueReportTotalPaymentsLabel ??
                      _text('ownerRevenueReportTotalPaymentsLabel',
                          'Total Payments'),
                  totalPaymentsText,
                  Icons.receipt,
                  AppColors.info,
                ),
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: _buildStatItem(
                  context,
                  loc?.ownerRevenueReportCollectedCountLabel ??
                      _text('ownerRevenueReportCollectedCountLabel',
                          'Collected Count'),
                  collectedCountText,
                  Icons.paid,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return AdaptiveCard(
      padding: EdgeInsets.all(
          context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and Number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: context.isMobile ? 18 : 24),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS * 0.5
                      : AppSpacing.paddingXS),
              Flexible(
                child: BodyText(
                  text: value,
                  medium: true,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS * 0.5
                  : AppSpacing.paddingXS),
          // Row 2: Label below
          CaptionText(text: label, color: color),
        ],
      ),
    );
  }
}
