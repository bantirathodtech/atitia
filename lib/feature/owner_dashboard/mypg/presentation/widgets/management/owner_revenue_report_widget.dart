// lib/features/owner_dashboard/mypg/presentation/widgets/owner_revenue_report_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/styles/spacing.dart';
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
    final collectedCountText =
        numberFormatter.format(report.collectedPayments);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet_rounded,
                    color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                HeadingMedium(
                  text: loc?.ownerRevenueReportTitle ??
                      _text('ownerRevenueReportTitle', 'Revenue Report'),
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    loc?.ownerRevenueReportCollectedLabel ??
                        _text('ownerRevenueReportCollectedLabel', 'Collected'),
                    collectedText,
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    loc?.ownerRevenueReportPendingLabel ??
                        _text('ownerRevenueReportPendingLabel', 'Pending'),
                    pendingText,
                    Icons.schedule,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    loc?.ownerRevenueReportTotalPaymentsLabel ??
                        _text('ownerRevenueReportTotalPaymentsLabel',
                            'Total Payments'),
                    totalPaymentsText,
                    Icons.receipt,
                    AppColors.info,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
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
      ),
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(text: value, medium: true, color: color),
          CaptionText(text: label, color: color),
        ],
      ),
    );
  }
}
