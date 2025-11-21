// ============================================================================
// Owner Reports Screen
// ============================================================================
// Comprehensive reports screen for owner users with real-time Firestore data
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../overview/viewmodel/owner_overview_view_model.dart';
import '../../../myguest/viewmodel/owner_guest_viewmodel.dart';
import '../../../overview/view/widgets/owner_chart_widget.dart';

/// Owner Reports Screen - Comprehensive reports and analytics
/// Displays detailed reports for revenue, bookings, guests, payments, and complaints
class OwnerReportsScreen extends StatefulWidget {
  const OwnerReportsScreen({super.key});

  @override
  State<OwnerReportsScreen> createState() => _OwnerReportsScreenState();
}

class _OwnerReportsScreenState extends State<OwnerReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lastLoadedPgId;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  String _formatCurrency(double value, AppLocalizations loc) {
    final localeCurrency = NumberFormat.simpleCurrency(locale: loc.localeName);
    return NumberFormat.currency(
      locale: loc.localeName,
      symbol: localeCurrency.currencySymbol,
      decimalDigits: 0,
    ).format(value);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportsData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportsData() async {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final overviewVM = context.read<OwnerOverviewViewModel>();
    final ownerId = authProvider.user?.userId ?? '';
    final pgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty) {
      _lastLoadedPgId = pgId;
      await overviewVM.loadOverviewData(ownerId, pgId: pgId);
      await overviewVM.loadMonthlyBreakdown(ownerId, _endDate.year);
    }
  }

  Future<void> _refreshReports() async {
    await _loadReportsData();
  }

  Future<void> _selectDateRange() async {
    final loc = AppLocalizations.of(context)!;
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      helpText: loc.ownerReportsSelectPeriod,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      await _loadReportsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final currentPgId = selectedPgProvider.selectedPgId;

    // Auto-reload when PG changes
    if (_lastLoadedPgId != currentPgId) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadReportsData();
      });
    }

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,
        showDrawer: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
            tooltip: loc.ownerReportsSelectDateRange,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(
                  icon: const Icon(Icons.attach_money),
                  text: loc.ownerReportsTabRevenue),
              Tab(
                  icon: const Icon(Icons.book),
                  text: loc.ownerReportsTabBookings),
              Tab(
                  icon: const Icon(Icons.people),
                  text: loc.ownerReportsTabGuests),
              Tab(
                  icon: const Icon(Icons.payment),
                  text: loc.ownerReportsTabPayments),
              Tab(
                  icon: const Icon(Icons.report_problem),
                  text: loc.ownerReportsTabComplaints),
            ],
          ),
        ),
        showBackButton: false,
        showThemeToggle: false,
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
      body: _buildBody(context, loc),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations loc) {
    // Use read to avoid unnecessary rebuilds - only access data when needed
    final overviewVM = context.read<OwnerOverviewViewModel>();
    final guestVM = context.read<OwnerGuestViewModel>();

    if (overviewVM.loading && overviewVM.overviewData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdaptiveLoader(),
            SizedBox(height: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
            BodyText(text: loc.ownerReportsLoading),
          ],
        ),
      );
    }

    if (overviewVM.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
            HeadingMedium(
              text: loc.ownerReportsErrorTitle,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: overviewVM.errorMessage ?? loc.unknownErrorOccurred,
              align: TextAlign.center,
            ),
            SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
            PrimaryButton(
              onPressed: _refreshReports,
              label: loc.tryAgain,
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRevenueReport(context, overviewVM, loc),
        _buildBookingsReport(context, guestVM, loc),
        _buildGuestsReport(context, guestVM, loc),
        _buildPaymentsReport(context, guestVM, loc),
        _buildComplaintsReport(context, guestVM, loc),
      ],
    );
  }

  Widget _buildRevenueReport(BuildContext context,
      OwnerOverviewViewModel viewModel, AppLocalizations loc) {
    final overview = viewModel.overviewData;
    final monthlyBreakdown = viewModel.monthlyBreakdown;
    final propertyBreakdown = viewModel.propertyBreakdown;

    if (overview == null) {
      return EmptyState(
        icon: Icons.assessment,
        title: loc.ownerReportsNoRevenueData,
        message: loc.ownerReportsRevenuePlaceholder,
      );
    }

    final totalRevenue = monthlyBreakdown != null && monthlyBreakdown.isNotEmpty
        ? monthlyBreakdown.values.fold(0.0, (a, b) => a + b)
        : overview.totalRevenue;
    final averageRevenue =
        monthlyBreakdown != null && monthlyBreakdown.values.isNotEmpty
            ? totalRevenue / monthlyBreakdown.values.where((v) => v > 0).length
            : 0.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date Range Display
          _buildDateRangeCard(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  title: loc.totalRevenue,
                  description: _formatCurrency(totalRevenue, loc),
                  icon: Icons.attach_money,
                  iconColor: AppColors.success,
                ),
              ),
              SizedBox(width: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: loc.ownerReportsAveragePerMonth,
                  description: _formatCurrency(averageRevenue, loc),
                  icon: Icons.trending_up,
                  iconColor: AppColors.info,
                ),
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Monthly Revenue Chart
          if (monthlyBreakdown != null && monthlyBreakdown.isNotEmpty)
            OwnerChartWidget(
              title: loc.ownerReportsMonthlyRevenueBreakdown,
              data: monthlyBreakdown,
            ),
          if (monthlyBreakdown != null && monthlyBreakdown.isNotEmpty)
            SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Property Breakdown
          if (propertyBreakdown != null && propertyBreakdown.isNotEmpty)
            _buildPropertyRevenueCard(context, propertyBreakdown, loc),
        ],
      ),
    );
  }

  Widget _buildBookingsReport(BuildContext context,
      OwnerGuestViewModel viewModel, AppLocalizations loc) {
    final bookings = viewModel.bookings;
    final bookingRequests = viewModel.bookingRequests;
    final bedChangeRequests = viewModel.bedChangeRequests;

    final totalBookings = bookings.length;
    final activeBookings = bookings.where((b) => b.isActive).length;
    final pendingRequests = bookingRequests.where((r) => r.isPending).length;
    final approvedRequests =
        bookingRequests.where((r) => r.status == 'approved').length;
    final rejectedRequests =
        bookingRequests.where((r) => r.status == 'rejected').length;
    final pendingBedChanges =
        bedChangeRequests.where((r) => r.status == 'pending').length;

    // Filter by date range
    final filteredBookings = bookings.where((b) {
      final bookingDate = b.startDate;
      return bookingDate
              .isAfter(_startDate.subtract(const Duration(days: 1))) &&
          bookingDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: loc.ownerReportsTotalBookings,
                description: totalBookings.toString(),
                icon: Icons.book,
                iconColor: AppColors.info,
              ),
              InfoCard(
                title: loc.active,
                description: activeBookings.toString(),
                icon: Icons.check_circle,
                iconColor: AppColors.success,
              ),
              InfoCard(
                title: loc.ownerReportsPendingRequests,
                description: pendingRequests.toString(),
                icon: Icons.pending,
                iconColor: AppColors.warning,
              ),
              InfoCard(
                title: loc.approved,
                description: approvedRequests.toString(),
                icon: Icons.thumb_up,
                iconColor: AppColors.success,
              ),
              InfoCard(
                title: loc.rejected,
                description: rejectedRequests.toString(),
                icon: Icons.thumb_down,
                iconColor: AppColors.error,
              ),
              InfoCard(
                title: loc.bedChanges,
                description: pendingBedChanges.toString(),
                icon: Icons.bed,
                iconColor: AppColors.purple,
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Booking Trends
          _buildBookingTrendsCard(context, filteredBookings, loc),
        ],
      ),
    );
  }

  Widget _buildGuestsReport(BuildContext context, OwnerGuestViewModel viewModel,
      AppLocalizations loc) {
    final guests = viewModel.guests;
    final guestStats = viewModel.guestStats;

    final totalGuests = guests.length;
    final activeGuests = guests.where((g) => g.status == 'Active').length;
    final inactiveGuests = guests.where((g) => g.status == 'Inactive').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  title: loc.totalGuests,
                  description: totalGuests.toString(),
                  icon: Icons.people,
                  iconColor: AppColors.info,
                ),
              ),
              SizedBox(width: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: loc.active,
                  description: activeGuests.toString(),
                  icon: Icons.check_circle,
                  iconColor: AppColors.success,
                ),
              ),
              SizedBox(width: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: loc.inactive,
                  description: inactiveGuests.toString(),
                  icon: Icons.cancel,
                  iconColor: AppColors.error,
                ),
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Guest Statistics
          if (guestStats.isNotEmpty)
            _buildGuestStatsCard(context, guestStats, loc),
        ],
      ),
    );
  }

  Widget _buildPaymentsReport(BuildContext context,
      OwnerGuestViewModel viewModel, AppLocalizations loc) {
    final payments = viewModel.payments;

    // Filter by date range
    final filteredPayments = payments.where((p) {
      final paymentDate = p.date;
      return paymentDate
              .isAfter(_startDate.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    final totalAmount = filteredPayments
        .where((p) => p.status == 'collected')
        .fold(0.0, (sum, p) => sum + p.amountPaid);
    final pendingAmount = filteredPayments
        .where((p) => p.status == 'pending')
        .fold(0.0, (sum, p) => sum + p.amountPaid);
    final paidCount =
        filteredPayments.where((p) => p.status == 'collected').length;
    final pendingCount =
        filteredPayments.where((p) => p.status == 'pending').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: loc.ownerReportsTotalReceived,
                description: _formatCurrency(totalAmount, loc),
                icon: Icons.attach_money,
                iconColor: AppColors.success,
              ),
              InfoCard(
                title: loc.pendingPayments,
                description: _formatCurrency(pendingAmount, loc),
                icon: Icons.pending,
                iconColor: AppColors.warning,
              ),
              InfoCard(
                title: loc.ownerReportsPaidCount,
                description: paidCount.toString(),
                icon: Icons.check_circle,
                iconColor: AppColors.info,
              ),
              InfoCard(
                title: loc.ownerReportsPendingCount,
                description: pendingCount.toString(),
                icon: Icons.schedule,
                iconColor: AppColors.error,
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Payment Trends
          _buildPaymentTrendsCard(context, filteredPayments, loc),
        ],
      ),
    );
  }

  Widget _buildComplaintsReport(BuildContext context,
      OwnerGuestViewModel viewModel, AppLocalizations loc) {
    final complaints = viewModel.complaints;

    // Filter by date range
    final filteredComplaints = complaints.where((c) {
      final complaintDate = c.createdAt;
      return complaintDate
              .isAfter(_startDate.subtract(const Duration(days: 1))) &&
          complaintDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    final totalComplaints = filteredComplaints.length;
    final pendingComplaints =
        filteredComplaints.where((c) => c.status == 'new').length;
    final resolvedComplaints =
        filteredComplaints.where((c) => c.status == 'resolved').length;
    final inProgressComplaints =
        filteredComplaints.where((c) => c.status == 'in_progress').length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: loc.totalComplaints,
                description: totalComplaints.toString(),
                icon: Icons.report_problem,
                iconColor: AppColors.error,
              ),
              InfoCard(
                title: loc.pending,
                description: pendingComplaints.toString(),
                icon: Icons.pending,
                iconColor: AppColors.warning,
              ),
              InfoCard(
                title: loc.inProgress,
                description: inProgressComplaints.toString(),
                icon: Icons.schedule,
                iconColor: AppColors.info,
              ),
              InfoCard(
                title: loc.resolved,
                description: resolvedComplaints.toString(),
                icon: Icons.check_circle,
                iconColor: AppColors.success,
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Complaint Trends
          _buildComplaintTrendsCard(context, filteredComplaints, loc),
        ],
      ),
    );
  }

  Widget _buildDateRangeCard(BuildContext context, AppLocalizations loc) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 20),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text:
                  '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}',
              medium: true,
            ),
          ),
          TextButtonWidget(
            onPressed: _selectDateRange,
            text: loc.ownerReportsChangeDateRange,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRevenueCard(BuildContext context,
      Map<String, double> propertyBreakdown, AppLocalizations loc) {
    final totalRevenue =
        propertyBreakdown.values.fold(0.0, (sum, v) => sum + v);

    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.ownerReportsPropertyWiseRevenue,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ...propertyBreakdown.entries.map((entry) {
            final percentage =
                totalRevenue > 0 ? (entry.value / totalRevenue * 100) : 0.0;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: BodyText(text: entry.key),
                      ),
                      BodyText(
                        text: _formatCurrency(entry.value, loc),
                        medium: true,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingXS),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  CaptionText(
                    text: loc.ownerReportsPercentageOfTotal(
                      percentage.toStringAsFixed(1),
                    ),
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            );
          }),
          const Divider(height: AppSpacing.paddingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(text: loc.totalRevenue, medium: true),
              BodyText(
                text: _formatCurrency(totalRevenue, loc),
                medium: true,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingTrendsCard(
      BuildContext context, List<dynamic> bookings, AppLocalizations loc) {
    // Group bookings by month
    final Map<String, int> monthlyBookings = {};
    for (final booking in bookings) {
      final date = booking.startDate;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyBookings[monthKey] = (monthlyBookings[monthKey] ?? 0) + 1;
    }

    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.ownerReportsBookingTrends,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyBookings.isEmpty)
            BodyText(
              text: loc.ownerReportsNoBookingData,
              color: AppColors.textSecondary,
            )
          else
            ...monthlyBookings.entries.map((entry) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: loc.ownerReportsBookingsCount(entry.value),
                      medium: true,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildGuestStatsCard(BuildContext context,
      Map<String, dynamic> guestStats, AppLocalizations loc) {
    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.ownerReportsGuestStatistics,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ...guestStats.entries.map((entry) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(text: entry.key.toString()),
                  BodyText(
                    text: entry.value.toString(),
                    medium: true,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPaymentTrendsCard(
      BuildContext context, List<dynamic> payments, AppLocalizations loc) {
    // Group payments by month
    final Map<String, double> monthlyPayments = {};
    for (final payment in payments.where((p) => p.status == 'collected')) {
      final date = payment.date;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyPayments[monthKey] =
          (monthlyPayments[monthKey] ?? 0.0) + payment.amountPaid;
    }

    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.ownerReportsPaymentTrends,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyPayments.isEmpty)
            BodyText(
              text: loc.ownerReportsNoPaymentData,
              color: AppColors.textSecondary,
            )
          else
            ...monthlyPayments.entries.map((entry) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: _formatCurrency(entry.value, loc),
                      medium: true,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildComplaintTrendsCard(
      BuildContext context, List<dynamic> complaints, AppLocalizations loc) {
    // Group complaints by month
    final Map<String, int> monthlyComplaints = {};
    for (final complaint in complaints) {
      final date = complaint.createdAt;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyComplaints[monthKey] = (monthlyComplaints[monthKey] ?? 0) + 1;
    }

    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? context.responsivePadding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.ownerReportsComplaintTrends,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyComplaints.isEmpty)
            BodyText(
              text: loc.ownerReportsNoComplaintData,
              color: AppColors.textSecondary,
            )
          else
            ...monthlyComplaints.entries.map((entry) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: loc.ownerReportsComplaintsCount(entry.value),
                      medium: true,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
