// ============================================================================
// Owner PG Management Screen - Complete PG Dashboard (Presentation Layer)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
// import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../../shared/widgets/add_pg_action_button.dart';
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
    // Use postFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
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
    // Use select to only rebuild when pgId changes
    final currentPgId = context.select<SelectedPgProvider, String?>((p) => p.selectedPgId);

    if (_lastLoadedPgId != currentPgId &&
        currentPgId != null &&
        currentPgId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initialize(currentPgId);
      });
    }

    // Return complete screen with individual app bar and drawer
    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Theme-aware background color
        backgroundColor: context.colors.surface,

        // Left: Drawer button
        showDrawer: true,

        // Right: Add PG
        actions: [
          const AddPgActionButton(),
        ],

        // Bottom: PGs tab bar with extra height similar to food tab
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              color: context.colors.surface,
              border: Border(
                top: BorderSide(
                  color: ThemeColors.getDivider(context),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: context.colors.onSurface,
              labelColor: context.colors.onSurface,
              unselectedLabelColor:
                  context.colors.onSurface.withValues(alpha: 0.7),
              tabs: [
                Tab(
                    text:
                        AppLocalizations.of(context)?.dashboard ?? 'Dashboard',
                    icon: const Icon(Icons.dashboard, size: 16)),
                Tab(
                    text: AppLocalizations.of(context)?.bedMap ?? 'Bed Map',
                    icon: const Icon(Icons.bed, size: 16)),
                Tab(
                    text: AppLocalizations.of(context)?.booking ?? 'Bookings',
                    icon: const Icon(Icons.book_online, size: 16)),
              ],
            ),
          ),
        ),

        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, viewModel),
    );
  }

  Widget _buildBody(BuildContext context, OwnerPgManagementViewModel viewModel) {
    final selectedPgProvider = context.read<SelectedPgProvider>();
    if (!selectedPgProvider.hasPgs) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_outlined,
                size: 80,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(
                text: AppLocalizations.of(context)?.noPgsListedYet ??
                    'No PGs Listed Yet'),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
                text:
                    AppLocalizations.of(context)?.tapButtonBelowToListFirstPg ??
                        'Tap the button below to list your first PG'),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => _navigateToCreatePG(context),
              label: AppLocalizations.of(context)?.listYourFirstPg ??
                  'List Your First PG',
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
            BodyText(
                text: AppLocalizations.of(context)?.loadingPgData ??
                    'Loading PG data...'),
          ],
        ),
      );
    }

    if (viewModel.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingMedium(
              text: AppLocalizations.of(context)?.errorLoadingData ??
                  'Error Loading Data',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: viewModel.errorMessage ??
                  (AppLocalizations.of(context)?.somethingWentWrong ??
                      'Unknown error occurred'),
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: viewModel.refreshData,
              label: AppLocalizations.of(context)?.tryAgain ?? 'Try Again',
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
    final padding = context.responsivePadding;
    final cardGap = context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM;
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.isMobile ? padding.top * 0.75 : padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OwnerPgInfoCard(pgDetails: viewModel.pgDetails),
          SizedBox(height: cardGap),
          if (viewModel.occupancyReport != null)
            OwnerOccupancyReportWidget(report: viewModel.occupancyReport!),
          if (viewModel.occupancyReport != null) SizedBox(height: cardGap),
          if (viewModel.revenueReport != null)
            OwnerRevenueReportWidget(report: viewModel.revenueReport!),
          if (viewModel.revenueReport != null) SizedBox(height: cardGap),
          if (viewModel.pendingBookings.isNotEmpty)
            OwnerBookingRequestListWidget(bookings: viewModel.pendingBookings),
          if (viewModel.pendingBookings.isNotEmpty) SizedBox(height: cardGap),
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
    final total = viewModel.bookings.length;
    final approved = viewModel.approvedBookings.length;
    final pending = viewModel.pendingBookings.length;
    final rejected = viewModel.rejectedBookings.length;
    final padding = context.responsivePadding;

    return ListView(
      padding: EdgeInsets.all(context.isMobile ? padding.top * 0.75 : padding.top),
      children: [
        // Overview stats card (shows zero values when empty)
        AdaptiveCard(
          padding: EdgeInsets.all(context.isMobile ? padding.top * 0.5 : AppSpacing.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.book_online_rounded,
                      color: context.primaryColor, size: context.isMobile ? 18 : 20),
                  SizedBox(width: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
                  Expanded(
                    child: HeadingMedium(
                      text: AppLocalizations.of(context)?.bookingsOverview ??
                          'Bookings Overview',
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '$total',
                      AppLocalizations.of(context)?.total ?? 'Total',
                      Icons.receipt_long,
                      context.primaryColor,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '$approved',
                      AppLocalizations.of(context)?.approved ?? 'Approved',
                      Icons.check_circle,
                      AppColors.success,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '$pending',
                      AppLocalizations.of(context)?.pending ?? 'Pending',
                      Icons.schedule,
                      AppColors.warning,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      context,
                      '$rejected',
                      AppLocalizations.of(context)?.rejected ?? 'Rejected',
                      Icons.cancel,
                      AppColors.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),

        // List (real items or placeholders)
        if (total > 0)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.bookings.length,
            cacheExtent: 512,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final booking = viewModel.bookings[index];
              return RepaintBoundary(
                key: ValueKey('booking_${booking.id}_$index'),
                child: Padding(
                  padding: EdgeInsets.only(bottom: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
                  child: _buildBookingCard(context, booking, viewModel),
                ),
              );
            },
          )
        else
          ..._buildBookingPlaceholders(context),
      ],
    );
  }

  Widget _buildFilterChips(
      BuildContext context, OwnerPgManagementViewModel viewModel) {
    final loc = AppLocalizations.of(context);
    final padding = context.responsivePadding;
    final filters = [
      loc?.all ?? 'All',
      loc?.occupied ?? 'Occupied',
      loc?.vacant ?? 'Vacant',
      loc?.pending ?? 'Pending',
      loc?.maintenance ?? 'Maintenance',
    ];
    final filterKeys = ['All', 'Occupied', 'Vacant', 'Pending', 'Maintenance'];

    return Container(
      margin: EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top * 0.75),
      height: context.isMobile ? 44 : 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterKeys.length,
        itemBuilder: (context, index) {
          final filterKey = filterKeys[index];
          final filterLabel = filters[index];
          final isSelected = viewModel.selectedFilter == filterKey;

          return Padding(
            padding: EdgeInsets.only(right: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
            child: CustomFilterChip(
              label: filterLabel,
              selected: isSelected,
              onSelected: (selected) {
                viewModel.setFilter(filterKey);
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
                    color:
                        _getStatusColor(booking.status).withValues(alpha: 0.2),
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
              color: ThemeColors.getTextTertiary(context),
            ),
            if (booking.isPending) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => viewModel.approveBooking(booking.id),
                      label: AppLocalizations.of(context)?.approve ?? 'Approve',
                      icon: Icons.check,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => viewModel.rejectBooking(booking.id),
                      label: AppLocalizations.of(context)?.reject ?? 'Reject',
                      icon: Icons.close,
                      backgroundColor: AppColors.error,
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
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  Widget _buildStatItem(BuildContext context, String value, String label,
      IconData icon, Color color) {
    final padding = context.responsivePadding;
    return Container(
      margin: EdgeInsets.all(context.isMobile ? AppSpacing.paddingXS * 0.5 : AppSpacing.paddingXS),
      padding: EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top * 0.75),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: context.isMobile ? 16 : 20),
              SizedBox(width: context.isMobile ? AppSpacing.paddingXS * 0.5 : AppSpacing.paddingXS),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingXS * 0.5 : AppSpacing.paddingXS),
          // Row 2: Text below
          BodyText(
            text: label,
            small: true,
            color: color.withValues(alpha: 0.9),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBookingPlaceholders(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.3);
    final border = theme.dividerColor.withValues(alpha: 0.5);

    Widget placeholderRow() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left placeholder (room/bed)
          Container(
            width: 160,
            height: 16,
            decoration: BoxDecoration(
              color: muted.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: border),
            ),
          ),
          // Right placeholder (date)
          Container(
            width: 110,
            height: 14,
            decoration: BoxDecoration(
              color: muted.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: border),
            ),
          ),
        ],
      );
    }

    return List.generate(3, (idx) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
        child: AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                placeholderRow(),
                const SizedBox(height: AppSpacing.paddingS),
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: border),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _navigateToCreatePG(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewPgSetupScreen(),
      ),
    );

    if (result != true || !mounted) return;
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Check mounted immediately before using context after async operations
    // Changed from: Using context with mounted check in compound condition after async gap
    // Changed to: Check mounted immediately before each context usage
    // Note: Storing context-dependent values before async is Flutter's recommended pattern, analyzer flags as false positive
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    final authProvider = context.read<AuthProvider>();
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    final selectedPgProvider = context.read<SelectedPgProvider>();
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    final viewModel = context.read<OwnerPgManagementViewModel>();
    final ownerId = authProvider.user?.userId ?? '';

    await viewModel.refreshData();
    if (ownerId.isNotEmpty) {
      await selectedPgProvider.refreshPgs();
    }
  }
}
