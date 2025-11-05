// ============================================================================
// Owner Reports Screen
// ============================================================================
// Comprehensive reports screen for owner users with real-time Firestore data
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
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
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      helpText: 'Select Report Period',
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
            tooltip: 'Select Date Range',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshReports,
            tooltip: 'Refresh Reports',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: const [
              Tab(icon: Icon(Icons.attach_money), text: 'Revenue'),
              Tab(icon: Icon(Icons.book), text: 'Bookings'),
              Tab(icon: Icon(Icons.people), text: 'Guests'),
              Tab(icon: Icon(Icons.payment), text: 'Payments'),
              Tab(icon: Icon(Icons.report_problem), text: 'Complaints'),
            ],
          ),
        ),
        showBackButton: false,
        showThemeToggle: false,
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final overviewVM = context.watch<OwnerOverviewViewModel>();
    final guestVM = context.watch<OwnerGuestViewModel>();

    if (overviewVM.loading && overviewVM.overviewData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            SizedBox(height: AppSpacing.paddingM),
            BodyText(text: 'Loading reports...'),
          ],
        ),
      );
    }

    if (overviewVM.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            const HeadingMedium(
              text: 'Error Loading Reports',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: overviewVM.errorMessage ?? 'Unknown error occurred',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: _refreshReports,
              label: 'Try Again',
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRevenueReport(context, overviewVM),
        _buildBookingsReport(context, guestVM),
        _buildGuestsReport(context, guestVM),
        _buildPaymentsReport(context, guestVM),
        _buildComplaintsReport(context, guestVM),
      ],
    );
  }

  Widget _buildRevenueReport(
      BuildContext context, OwnerOverviewViewModel viewModel) {
    final overview = viewModel.overviewData;
    final monthlyBreakdown = viewModel.monthlyBreakdown;
    final propertyBreakdown = viewModel.propertyBreakdown;

    if (overview == null) {
      return const EmptyState(
        icon: Icons.assessment,
        title: 'No Revenue Data',
        message: 'Revenue data will appear here once you have bookings',
      );
    }

    final totalRevenue = monthlyBreakdown != null && monthlyBreakdown.isNotEmpty
        ? monthlyBreakdown.values.fold(0.0, (a, b) => a + b)
        : overview.totalRevenue;
    final averageRevenue = monthlyBreakdown != null &&
            monthlyBreakdown.values.isNotEmpty
        ? totalRevenue / monthlyBreakdown.values.where((v) => v > 0).length
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date Range Display
          _buildDateRangeCard(context),
          const SizedBox(height: AppSpacing.paddingL),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  title: 'Total Revenue',
                  description: '₹${NumberFormat('#,##0').format(totalRevenue)}',
                  icon: Icons.attach_money,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: 'Average/Month',
                  description: '₹${NumberFormat('#,##0').format(averageRevenue)}',
                  icon: Icons.trending_up,
                  iconColor: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Monthly Revenue Chart
          if (monthlyBreakdown != null && monthlyBreakdown.isNotEmpty)
            OwnerChartWidget(
              title: 'Monthly Revenue Breakdown',
              data: monthlyBreakdown,
            ),
          if (monthlyBreakdown != null && monthlyBreakdown.isNotEmpty)
            const SizedBox(height: AppSpacing.paddingL),

          // Property Breakdown
          if (propertyBreakdown != null && propertyBreakdown.isNotEmpty)
            _buildPropertyRevenueCard(context, propertyBreakdown),
        ],
      ),
    );
  }

  Widget _buildBookingsReport(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final bookings = viewModel.bookings;
    final bookingRequests = viewModel.bookingRequests;
    final bedChangeRequests = viewModel.bedChangeRequests;

    final totalBookings = bookings.length;
    final activeBookings =
        bookings.where((b) => b.isActive).length;
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
      return bookingDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          bookingDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context),
          const SizedBox(height: AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: 'Total Bookings',
                description: totalBookings.toString(),
                icon: Icons.book,
                iconColor: Colors.blue,
              ),
              InfoCard(
                title: 'Active',
                description: activeBookings.toString(),
                icon: Icons.check_circle,
                iconColor: Colors.green,
              ),
              InfoCard(
                title: 'Pending Requests',
                description: pendingRequests.toString(),
                icon: Icons.pending,
                iconColor: Colors.orange,
              ),
              InfoCard(
                title: 'Approved',
                description: approvedRequests.toString(),
                icon: Icons.thumb_up,
                iconColor: Colors.green,
              ),
              InfoCard(
                title: 'Rejected',
                description: rejectedRequests.toString(),
                icon: Icons.thumb_down,
                iconColor: Colors.red,
              ),
              InfoCard(
                title: 'Bed Changes',
                description: pendingBedChanges.toString(),
                icon: Icons.bed,
                iconColor: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Booking Trends
          _buildBookingTrendsCard(context, filteredBookings),
        ],
      ),
    );
  }

  Widget _buildGuestsReport(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final guests = viewModel.guests;
    final guestStats = viewModel.guestStats;

    final totalGuests = guests.length;
    final activeGuests = guests.where((g) => g.status == 'Active').length;
    final inactiveGuests = guests.where((g) => g.status == 'Inactive').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context),
          const SizedBox(height: AppSpacing.paddingL),

          // Summary Cards
          Row(
            children: [
              Expanded(
                child: InfoCard(
                  title: 'Total Guests',
                  description: totalGuests.toString(),
                  icon: Icons.people,
                  iconColor: Colors.blue,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: 'Active',
                  description: activeGuests.toString(),
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: InfoCard(
                  title: 'Inactive',
                  description: inactiveGuests.toString(),
                  icon: Icons.cancel,
                  iconColor: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Guest Statistics
          if (guestStats.isNotEmpty)
            _buildGuestStatsCard(context, guestStats),
        ],
      ),
    );
  }

  Widget _buildPaymentsReport(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final payments = viewModel.payments;

    // Filter by date range
    final filteredPayments = payments.where((p) {
      final paymentDate = p.date;
      return paymentDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
          paymentDate.isBefore(_endDate.add(const Duration(days: 1)));
    }).toList();

    final totalAmount = filteredPayments
        .where((p) => p.status == 'collected')
        .fold(0.0, (sum, p) => sum + p.amountPaid);
    final pendingAmount = filteredPayments
        .where((p) => p.status == 'pending')
        .fold(0.0, (sum, p) => sum + p.amountPaid);
    final paidCount = filteredPayments.where((p) => p.status == 'collected').length;
    final pendingCount =
        filteredPayments.where((p) => p.status == 'pending').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context),
          const SizedBox(height: AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: 'Total Received',
                description: '₹${NumberFormat('#,##0').format(totalAmount)}',
                icon: Icons.attach_money,
                iconColor: Colors.green,
              ),
              InfoCard(
                title: 'Pending',
                description: '₹${NumberFormat('#,##0').format(pendingAmount)}',
                icon: Icons.pending,
                iconColor: Colors.orange,
              ),
              InfoCard(
                title: 'Paid Count',
                description: paidCount.toString(),
                icon: Icons.check_circle,
                iconColor: Colors.blue,
              ),
              InfoCard(
                title: 'Pending Count',
                description: pendingCount.toString(),
                icon: Icons.schedule,
                iconColor: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Payment Trends
          _buildPaymentTrendsCard(context, filteredPayments),
        ],
      ),
    );
  }

  Widget _buildComplaintsReport(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final complaints = viewModel.complaints;

    // Filter by date range
    final filteredComplaints = complaints.where((c) {
      final complaintDate = c.createdAt;
      return complaintDate.isAfter(_startDate.subtract(const Duration(days: 1))) &&
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
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDateRangeCard(context),
          const SizedBox(height: AppSpacing.paddingL),

          // Summary Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              InfoCard(
                title: 'Total Complaints',
                description: totalComplaints.toString(),
                icon: Icons.report_problem,
                iconColor: Colors.red,
              ),
              InfoCard(
                title: 'Pending',
                description: pendingComplaints.toString(),
                icon: Icons.pending,
                iconColor: Colors.orange,
              ),
              InfoCard(
                title: 'In Progress',
                description: inProgressComplaints.toString(),
                icon: Icons.schedule,
                iconColor: Colors.blue,
              ),
              InfoCard(
                title: 'Resolved',
                description: resolvedComplaints.toString(),
                icon: Icons.check_circle,
                iconColor: Colors.green,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Complaint Trends
          _buildComplaintTrendsCard(context, filteredComplaints),
        ],
      ),
    );
  }

  Widget _buildDateRangeCard(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
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
          TextButton(
            onPressed: _selectDateRange,
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRevenueCard(
      BuildContext context, Map<String, double> propertyBreakdown) {
    final totalRevenue = propertyBreakdown.values.fold(0.0, (sum, v) => sum + v);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Property-wise Revenue',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ...propertyBreakdown.entries.map((entry) {
            final percentage =
                totalRevenue > 0 ? (entry.value / totalRevenue * 100) : 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
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
                        text: '₹${NumberFormat('#,##0').format(entry.value)}',
                        medium: true,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  CaptionText(
                    text: '${percentage.toStringAsFixed(1)}% of total',
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
              BodyText(text: 'Total Revenue', medium: true),
              BodyText(
                text: '₹${NumberFormat('#,##0').format(totalRevenue)}',
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
      BuildContext context, List<dynamic> bookings) {
    // Group bookings by month
    final Map<String, int> monthlyBookings = {};
    for (final booking in bookings) {
      final date = booking.startDate;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyBookings[monthKey] = (monthlyBookings[monthKey] ?? 0) + 1;
    }

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Booking Trends',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyBookings.isEmpty)
            const BodyText(
              text: 'No booking data available for selected period',
              color: AppColors.textSecondary,
            )
          else
            ...monthlyBookings.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: '${entry.value} bookings',
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

  Widget _buildGuestStatsCard(
      BuildContext context, Map<String, dynamic> guestStats) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Guest Statistics',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ...guestStats.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
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
      BuildContext context, List<dynamic> payments) {
    // Group payments by month
    final Map<String, double> monthlyPayments = {};
    for (final payment in payments.where((p) => p.status == 'collected')) {
      final date = payment.date;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyPayments[monthKey] =
          (monthlyPayments[monthKey] ?? 0.0) + payment.amountPaid;
    }

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Payment Trends',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyPayments.isEmpty)
            const BodyText(
              text: 'No payment data available for selected period',
              color: AppColors.textSecondary,
            )
          else
            ...monthlyPayments.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: '₹${NumberFormat('#,##0').format(entry.value)}',
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
      BuildContext context, List<dynamic> complaints) {
    // Group complaints by month
    final Map<String, int> monthlyComplaints = {};
    for (final complaint in complaints) {
      final date = complaint.createdAt;
      final monthKey = DateFormat('MMM yyyy').format(date);
      monthlyComplaints[monthKey] = (monthlyComplaints[monthKey] ?? 0) + 1;
    }

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Complaint Trends',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (monthlyComplaints.isEmpty)
            const BodyText(
              text: 'No complaint data available for selected period',
              color: AppColors.textSecondary,
            )
          else
            ...monthlyComplaints.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BodyText(text: entry.key),
                    BodyText(
                      text: '${entry.value} complaints',
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
