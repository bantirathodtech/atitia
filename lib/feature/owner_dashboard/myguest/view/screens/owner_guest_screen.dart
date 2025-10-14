// lib/features/owner_dashboard/myguest/view/screens/owner_guest_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../widgets/booking_list_widget.dart';
import '../widgets/guest_list_widget.dart';
import '../widgets/interactive_bed_map_widget.dart';

/// Owner Guest Management Screen
/// Displays comprehensive view of guests, bookings, payments, and bed occupancy
/// Uses OwnerGuestViewModel for data management and real-time updates
class OwnerGuestScreen extends StatefulWidget {
  const OwnerGuestScreen({super.key});

  @override
  State<OwnerGuestScreen> createState() => _OwnerGuestScreenState();
}

class _OwnerGuestScreenState extends State<OwnerGuestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lastLoadedPgId; // Track which PG we last loaded data for

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeViewModel();
  }

  /// Initializes the ViewModel when screen loads
  Future<void> _initializeViewModel() async {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final viewModel = context.read<OwnerGuestViewModel>();
    
    // Use selected PG from provider
    final pgId = selectedPgProvider.selectedPgId;
    
    if (pgId != null && pgId.isNotEmpty) {
      _lastLoadedPgId = pgId;
      await viewModel.initialize([pgId]);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerGuestViewModel>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final currentPgId = selectedPgProvider.selectedPgId;

    // Auto-reload data when selected PG changes
    if (_lastLoadedPgId != currentPgId && currentPgId != null && currentPgId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initialize([currentPgId]);
      });
    }

    return Scaffold(
      // =======================================================================
      // World-Class App Bar using Enhanced AdaptiveAppBar
      // =======================================================================
      appBar: AdaptiveAppBar(
        // Left: People icon
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.people_rounded,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ],
        // Center: PG Selector Dropdown
        titleWidget: const PgSelectorDropdown(compact: false),
        centerTitle: true,
        // Right: Refresh + Theme Toggle (auto-added)
        actions: [
          IconButton(
            icon: Icon(viewModel.selectionMode ? Icons.close : Icons.checklist),
            onPressed: viewModel.toggleSelectionMode,
            tooltip: viewModel.selectionMode ? 'Exit Selection Mode' : 'Select Multiple',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.loading ? null : viewModel.refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
        showThemeToggle: true,
        showBackButton: false,
        // Bottom: Tab bar for Guests/Bookings/Bed Map
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.textOnPrimary,
          labelColor: AppColors.textOnPrimary,
          unselectedLabelColor: AppColors.textOnPrimary.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Guests', icon: Icon(Icons.people, size: 16)),
            Tab(text: 'Bookings', icon: Icon(Icons.book_online, size: 16)),
            Tab(text: 'Bed Map', icon: Icon(Icons.bed, size: 16)),
          ],
        ),
      ),
      body: _buildBody(context, viewModel),
      floatingActionButton: _buildFAB(context, viewModel),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerGuestViewModel viewModel) {
    if (viewModel.loading && viewModel.guests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(text: 'Loading guest data...'),
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

    return Column(
      children: [
        _buildStatsCard(context, viewModel),
        if (viewModel.selectionMode && viewModel.selectedCount > 0)
          _buildBulkActionBar(context, viewModel),
        _buildSearchBar(context, viewModel),
        _buildFilterChips(context, viewModel),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              GuestListWidget(
                guests: viewModel.filteredGuests,
                selectionMode: viewModel.selectionMode,
                selectedGuestIds: viewModel.selectedGuestIds,
                onGuestTap: (guest) {
                  if (viewModel.selectionMode) {
                    viewModel.toggleGuestSelection(guest.uid);
                  }
                },
              ),
              BookingListWidget(bookings: viewModel.bookings),
              InteractiveBedMapWidget(bookings: viewModel.bookings),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds bulk action bar when guests are selected
  Widget _buildBulkActionBar(BuildContext context, OwnerGuestViewModel viewModel) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Selected count
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingS,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: BodyText(
              text: '${viewModel.selectedCount} selected',
              color: Colors.white,
              medium: true,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          // Select all/deselect all
          TextButton.icon(
            onPressed: () {
              if (viewModel.selectedCount == viewModel.filteredGuests.length) {
                viewModel.deselectAllGuests();
              } else {
                viewModel.selectAllFilteredGuests();
              }
            },
            icon: Icon(
              viewModel.selectedCount == viewModel.filteredGuests.length
                  ? Icons.deselect
                  : Icons.select_all,
              color: Colors.white,
              size: 18,
            ),
            label: BodyText(
              text: viewModel.selectedCount == viewModel.filteredGuests.length
                  ? 'Deselect All'
                  : 'Select All',
              color: Colors.white,
            ),
          ),
          const Spacer(),
          // Bulk actions
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _showBulkStatusDialog(context, viewModel),
            tooltip: 'Change Status',
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () => _confirmBulkDelete(context, viewModel),
            tooltip: 'Delete Selected',
          ),
        ],
      ),
    );
  }

  Future<void> _showBulkStatusDialog(BuildContext context, OwnerGuestViewModel viewModel) async {
    final newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: AppColors.success),
              title: const Text('Active'),
              onTap: () => Navigator.pop(context, 'active'),
            ),
            ListTile(
              leading: const Icon(Icons.pending, color: AppColors.warning),
              title: const Text('Pending'),
              onTap: () => Navigator.pop(context, 'pending'),
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: AppColors.error),
              title: const Text('Inactive'),
              onTap: () => Navigator.pop(context, 'inactive'),
            ),
          ],
        ),
      ),
    );

    if (newStatus != null && mounted) {
      final success = await viewModel.bulkUpdateGuestStatus(newStatus);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated ${viewModel.selectedCount} guests to $newStatus'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Future<void> _confirmBulkDelete(BuildContext context, OwnerGuestViewModel viewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Bulk Delete'),
        content: Text(
          'Are you sure you want to delete ${viewModel.selectedCount} guests? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await viewModel.bulkDeleteGuests();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Guests deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  /// Builds statistics card
  Widget _buildStatsCard(BuildContext context, OwnerGuestViewModel viewModel) {
    final stats = viewModel.guestStats;

    return AdaptiveCard(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Guest Overview',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Total',
                '${stats['totalGuests'] ?? 0}',
                Icons.people,
              ),
              _buildStatItem(
                context,
                'Active',
                '${stats['activeGuests'] ?? 0}',
                Icons.check_circle,
              ),
              _buildStatItem(
                context,
                'Pending',
                '${stats['pendingGuests'] ?? 0}',
                Icons.pending,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  /// Builds filter chips
  /// Builds search bar with debouncing
  Widget _buildSearchBar(BuildContext context, OwnerGuestViewModel viewModel) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: TextField(
              onChanged: viewModel.setSearchQuery,
              style: TextStyle(
                color: isDarkMode ? AppColors.textOnPrimary : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name or phone...',
                hintStyle: TextStyle(
                  color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (viewModel.searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
              ),
              onPressed: viewModel.clearSearch,
              tooltip: 'Clear search',
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final filters = ['All', 'Active', 'Pending', 'Inactive'];
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
          height: 50,
          child: Row(
            children: [
              Expanded(
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
              ),
              // Results count
              if (viewModel.searchQuery.isNotEmpty || viewModel.selectedFilter != 'All')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: AppColors.info),
                      const SizedBox(width: 4),
                      BodyText(
                        text: '${viewModel.filteredGuests.length} found',
                        color: AppColors.info,
                        medium: true,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds floating action button based on current tab
  Widget? _buildFAB(BuildContext context, OwnerGuestViewModel viewModel) {
    switch (_tabController.index) {
      case 0: // Guests tab
        return FloatingActionButton.extended(
          onPressed: () => _showAddGuestDialog(context),
          icon: const Icon(Icons.person_add),
          label: const Text('Add Guest'),
          backgroundColor: Theme.of(context).primaryColor,
        );
      case 1: // Bookings tab
        return FloatingActionButton.extended(
          onPressed: () => _showAddBookingDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('New Booking'),
          backgroundColor: Theme.of(context).primaryColor,
        );
      default:
        return null;
    }
  }

  /// Shows add guest dialog (placeholder)
  void _showAddGuestDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add guest feature coming soon!')),
    );
  }

  /// Shows add booking dialog (placeholder)
  void _showAddBookingDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add booking feature coming soon!')),
    );
  }
}
