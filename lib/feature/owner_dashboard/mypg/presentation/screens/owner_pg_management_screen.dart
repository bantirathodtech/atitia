// ============================================================================
// Owner PG Management Screen - Complete PG Dashboard (Presentation Layer)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../data/models/owner_pg_management_model.dart';
import '../screens/new_pg_setup_screen.dart';
import '../viewmodels/owner_pg_management_viewmodel.dart';
import '../widgets/management/owner_bed_map_widget.dart';
import '../widgets/management/owner_booking_request_list_widget.dart';
import '../widgets/management/owner_occupancy_report_widget.dart';
import '../widgets/management/owner_pg_info_card.dart';
import '../widgets/management/owner_revenue_report_widget.dart';
import '../widgets/management/owner_upcoming_vacating_widget.dart';

class OwnerPgManagementScreen extends StatefulWidget {
  const OwnerPgManagementScreen({super.key});

  @override
  State<OwnerPgManagementScreen> createState() =>
      _OwnerPgManagementScreenState();
}

class _OwnerPgManagementScreenState extends State<OwnerPgManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lastLoadedPgId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeViewModel();
  }

  Future<void> _initializeViewModel() async {
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final viewModel = context.read<OwnerPgManagementViewModel>();

    final pgId = selectedPgProvider.selectedPgId;
    if (pgId != null && pgId.isNotEmpty) {
      _lastLoadedPgId = pgId;
      await viewModel.initialize(pgId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerPgManagementViewModel>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final currentPgId = selectedPgProvider.selectedPgId;

    if (_lastLoadedPgId != currentPgId &&
        currentPgId != null &&
        currentPgId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initialize(currentPgId);
      });
    }

    return Scaffold(
      appBar: AdaptiveAppBar(
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.home_rounded,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ],
        titleWidget: const PgSelectorDropdown(compact: false),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () => _navigateToCreatePG(context),
            tooltip: 'List New PG',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.loading ? null : viewModel.refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
        showThemeToggle: true,
        showBackButton: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Dashboard', icon: Icon(Icons.dashboard, size: 16)),
            Tab(text: 'Bed Map', icon: Icon(Icons.bed, size: 16)),
            Tab(text: 'Bookings', icon: Icon(Icons.book_online, size: 16)),
          ],
        ),
      ),
      body: _buildBody(context, viewModel, selectedPgProvider),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'owner_new_pg_fab',
        onPressed: () => _navigateToCreatePG(context),
        icon: const Icon(Icons.add_business),
        label: const Text('New PG'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildBody(BuildContext context, OwnerPgManagementViewModel viewModel,
      SelectedPgProvider selectedPgProvider) {
    if (!selectedPgProvider.hasPgs) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: AppSpacing.paddingM),
            const HeadingMedium(text: 'No PGs Listed Yet'),
            const SizedBox(height: AppSpacing.paddingS),
            const BodyText(text: 'Tap the button below to list your first PG'),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => _navigateToCreatePG(context),
              label: 'List Your First PG',
              icon: Icons.add_business,
            ),
          ],
        ),
      );
    }

    if (viewModel.loading && !viewModel.hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(text: 'Loading PG data...'),
          ],
        ),
      );
    }

    if (viewModel.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            const HeadingMedium(
              text: 'Error Loading Data',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: viewModel.errorMessage ?? 'Unknown error occurred',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: viewModel.refreshData,
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
        _buildDashboardTab(context, viewModel),
        _buildBedMapTab(context, viewModel),
        _buildBookingsTab(context, viewModel),
      ],
    );
  }

  Widget _buildDashboardTab(
      BuildContext context, OwnerPgManagementViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerPgInfoCard(pgDetails: viewModel.pgDetails),
          const SizedBox(height: AppSpacing.paddingM),
          if (viewModel.occupancyReport != null)
            OwnerOccupancyReportWidget(report: viewModel.occupancyReport!),
          const SizedBox(height: AppSpacing.paddingM),
          if (viewModel.revenueReport != null)
            OwnerRevenueReportWidget(report: viewModel.revenueReport!),
          const SizedBox(height: AppSpacing.paddingM),
          if (viewModel.pendingBookings.isNotEmpty)
            OwnerBookingRequestListWidget(bookings: viewModel.pendingBookings),
          const SizedBox(height: AppSpacing.paddingM),
          if (viewModel.upcomingVacating.isNotEmpty)
            OwnerUpcomingVacatingWidget(bookings: viewModel.upcomingVacating),
        ],
      ),
    );
  }

  Widget _buildBedMapTab(
      BuildContext context, OwnerPgManagementViewModel viewModel) {
    return Column(
      children: [
        _buildFilterChips(context, viewModel),
        Expanded(
          child: OwnerBedMapWidget(
            beds: viewModel.filteredBeds,
            rooms: viewModel.rooms,
            floors: viewModel.floors,
          ),
        ),
      ],
    );
  }

  Widget _buildBookingsTab(
      BuildContext context, OwnerPgManagementViewModel viewModel) {
    if (viewModel.bookings.isEmpty) {
      return const EmptyState(
        title: 'No Bookings',
        message: 'Booking list will appear here once bookings are created',
        icon: Icons.book_online_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: viewModel.bookings.length,
      itemBuilder: (context, index) {
        final booking = viewModel.bookings[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: _buildBookingCard(context, booking, viewModel),
        );
      },
    );
  }

  Widget _buildFilterChips(
      BuildContext context, OwnerPgManagementViewModel viewModel) {
    final filters = ['All', 'Occupied', 'Vacant', 'Pending', 'Maintenance'];

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = viewModel.selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.paddingS),
            child: CustomFilterChip(
              label: filter,
              selected: isSelected,
              onSelected: (selected) {
                viewModel.setFilter(filter);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, OwnerBooking booking,
      OwnerPgManagementViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyText(text: booking.roomBedDisplay, medium: true),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: BodyText(
                    text: booking.status,
                    color: _getStatusColor(booking.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text:
                  '${booking.formattedStartDate} - ${booking.formattedEndDate}',
              color: Colors.grey.shade600,
            ),
            if (booking.isPending) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => viewModel.approveBooking(booking.id),
                      label: 'Approve',
                      icon: Icons.check,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => viewModel.rejectBooking(booking.id),
                      label: 'Reject',
                      icon: Icons.close,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _navigateToCreatePG(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewPgSetupScreen(),
      ),
    );

    if (result == true && mounted) {
      final authProvider = context.read<AuthProvider>();
      final selectedPgProvider = context.read<SelectedPgProvider>();
      final viewModel = context.read<OwnerPgManagementViewModel>();
      final ownerId = authProvider.user?.userId ?? '';

      await viewModel.refreshData();
      if (ownerId.isNotEmpty) {
        await selectedPgProvider.refreshPgs(ownerId);
      }
    }
  }
}
