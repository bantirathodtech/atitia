// lib/features/owner_dashboard/myguest/view/screens/owner_guest_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../../shared/widgets/add_pg_action_button.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../widgets/booking_list_widget.dart';
import '../widgets/guest_list_widget.dart';
import '../widgets/interactive_bed_map_widget.dart';
import '../widgets/booking_request_action_dialog.dart';
import '../widgets/payment_list_widget.dart';
import '../widgets/record_payment_dialog.dart';
import '../widgets/bed_change_request_widget.dart';
import '../../data/models/owner_booking_request_model.dart';

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
    _tabController = TabController(length: 6, vsync: this);
    // Use postFrameCallback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeViewModel();
    });
  }

  /// Builds the requests tab with booking requests and bed change requests
  Widget _buildBookingRequestsTab(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final bookingRequests = viewModel.bookingRequests;
    final bedChangeRequests = viewModel.bedChangeRequests;
    final pendingBedChangeRequests = viewModel.pendingBedChangeRequests;

    if (bookingRequests.isEmpty && bedChangeRequests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.request_page_outlined, size: 64, color: Colors.grey),
            SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(
              text: 'No Requests',
              align: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: 'Booking and bed change requests will appear here',
              align: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: 'Booking Requests (${bookingRequests.length})',
                icon: const Icon(Icons.book_online, size: 16),
              ),
              Tab(
                text:
                    'Bed Changes (${pendingBedChangeRequests.length} pending)',
                icon: const Icon(Icons.bed, size: 16),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Booking requests list
                ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  itemCount: bookingRequests.length,
                  itemBuilder: (context, index) {
                    final request = bookingRequests[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingS),
                      child:
                          _buildBookingRequestCard(context, request, viewModel),
                    );
                  },
                ),
                // Bed change requests list
                BedChangeRequestWidget(
                  requests: bedChangeRequests,
                  viewModel: viewModel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the complaints tab content
  Widget _buildComplaintsTab(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final complaints = viewModel.filteredComplaints;

    if (complaints.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_problem_outlined, size: 64, color: Colors.grey),
            SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(text: 'No Complaints'),
            SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: 'Complaints from guests will appear here',
              align: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final c = complaints[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.report_problem,
                        color: c.isResolved ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      Expanded(
                        child: HeadingSmall(
                            text: c.title.isEmpty ? 'Complaint' : c.title),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingS, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.15),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.borderRadiusS),
                        ),
                        child: CaptionText(text: c.statusDisplay),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: c.description,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      CaptionText(
                          text: c.guestName.isEmpty ? 'Guest' : c.guestName),
                      const SizedBox(width: AppSpacing.paddingM),
                      Icon(Icons.schedule, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      CaptionText(text: _formatShortDate(c.createdAt)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  Row(
                    children: [
                      SecondaryButton(
                        label: 'Reply',
                        onPressed: () => _showComplaintReplyDialog(
                            context, viewModel, c.complaintId),
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      if (!c.isResolved)
                        PrimaryButton(
                          label: 'Resolve',
                          onPressed: () => _resolveComplaint(
                              context, viewModel, c.complaintId),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showComplaintReplyDialog(
      BuildContext context, OwnerGuestViewModel viewModel, String complaintId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Reply to Complaint'),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Reply',
            hintText: 'Type your reply...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Send',
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              Navigator.of(context).pop();
              final ok =
                  await viewModel.addComplaintReply(complaintId, text, 'Owner');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: BodyText(
                      text: ok ? 'Reply sent' : 'Failed to send reply',
                      color: Colors.white,
                    ),
                    backgroundColor: ok ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _resolveComplaint(
      BuildContext context, OwnerGuestViewModel viewModel, String complaintId) {
    final notes = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Resolve Complaint'),
        content: TextField(
          controller: notes,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Resolution Notes (optional)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Mark Resolved',
            onPressed: () async {
              Navigator.of(context).pop();
              final ok = await viewModel.updateComplaintStatus(
                complaintId,
                'resolved',
                resolutionNotes:
                    notes.text.trim().isEmpty ? null : notes.text.trim(),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: BodyText(
                      text: ok ? 'Complaint resolved' : 'Failed to resolve',
                      color: Colors.white,
                    ),
                    backgroundColor: ok ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Initializes the ViewModel when screen loads
  Future<void> _initializeViewModel() async {
    // final authProvider = context.read<AuthProvider>();
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
    if (_lastLoadedPgId != currentPgId &&
        currentPgId != null &&
        currentPgId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.initialize([currentPgId]);
      });
    }

    // Return complete screen with individual app bar and drawer
    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Left: Drawer button
        showDrawer: true,

        // Right: Add PG + Refresh
        actions: [
          const AddPgActionButton(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: viewModel.refreshData,
            tooltip: 'Refresh Guest Data',
          ),
        ],

        // Bottom: Guest tab bar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Guests', icon: Icon(Icons.people, size: 16)),
              Tab(text: 'Bookings', icon: Icon(Icons.book_online, size: 16)),
              Tab(text: 'Payments', icon: Icon(Icons.payment, size: 16)),
              Tab(
                  text: 'Complaints',
                  icon: Icon(Icons.report_problem, size: 16)),
              Tab(text: 'Requests', icon: Icon(Icons.request_page, size: 16)),
              Tab(text: 'Bed Map', icon: Icon(Icons.bed, size: 16)),
            ],
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
              _buildPaymentsTab(context, viewModel),
              _buildComplaintsTab(context, viewModel),
              _buildBookingRequestsTab(context, viewModel),
              InteractiveBedMapWidget(bookings: viewModel.bookings),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds bulk action bar when guests are selected
  Widget _buildBulkActionBar(
      BuildContext context, OwnerGuestViewModel viewModel) {
    // final theme = Theme.of(context);
    // final true = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
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
              color: Colors.white.withValues(alpha: 0.2),
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

  Future<void> _showBulkStatusDialog(
      BuildContext context, OwnerGuestViewModel viewModel) async {
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

    if (newStatus == null || !mounted) return;
    final success = await viewModel.bulkUpdateGuestStatus(newStatus);
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Check mounted immediately before using context after async operations
    // Changed from: Using context with mounted check in compound condition after async gap
    // Changed to: Check mounted immediately before context usage
    // Note: ScaffoldMessenger is safe to use after async when mounted check is performed, analyzer flags as false positive
    if (!success || !this.mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated ${viewModel.selectedCount} guests to $newStatus'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _confirmBulkDelete(
      BuildContext context, OwnerGuestViewModel viewModel) async {
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

    if (confirmed != true || !mounted) return;
    final success = await viewModel.bulkDeleteGuests();
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Check mounted immediately before using context after async operations
    // Changed from: Using context with mounted check in compound condition after async gap
    // Changed to: Check mounted immediately before context usage
    // Note: ScaffoldMessenger is safe to use after async when mounted check is performed, analyzer flags as false positive
    if (!success || !this.mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Guests deleted successfully'),
        backgroundColor: AppColors.success,
      ),
    );
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
    // final theme = Theme.of(context);
    // final true = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.darkInputFill,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: AppColors.darkDivider,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: TextField(
              onChanged: viewModel.setSearchQuery,
              style: TextStyle(
                color: AppColors.textOnPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search by name, phone, or vehicle...',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (viewModel.searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: AppColors.textTertiary,
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
    final filters = ['All', 'Active', 'Pending', 'Inactive', 'Vehicles'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
          child: Row(
            children: [
              // Equally expanded filter chips taking full width
              ...filters.asMap().entries.map((entry) {
                final index = entry.key;
                final filter = entry.value;
                final isSelected = viewModel.selectedFilter == filter;

                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right:
                          index < filters.length - 1 ? AppSpacing.paddingXS : 0,
                    ),
                    child: CustomFilterChip(
                      label: filter,
                      selected: isSelected,
                      onSelected: (selected) {
                        viewModel.setFilter(filter);
                      },
                    ),
                  ),
                );
              }),
              // Results count
              if (viewModel.searchQuery.isNotEmpty ||
                  viewModel.selectedFilter != 'All')
                Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.paddingS),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM,
                      vertical: AppSpacing.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                      border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            size: 16, color: AppColors.info),
                        const SizedBox(width: 4),
                        BodyText(
                          text: '${viewModel.filteredGuests.length} found',
                          color: AppColors.info,
                          medium: true,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the payments tab content
  Widget _buildPaymentsTab(
      BuildContext context, OwnerGuestViewModel viewModel) {
    return Column(
      children: [
        // Payment stats card
        _buildPaymentStatsCard(context, viewModel),
        // Payments list
        Expanded(
          child: PaymentListWidget(
            payments: viewModel.payments,
            viewModel: viewModel,
            guests: viewModel.guests,
            bookings: viewModel.bookings,
          ),
        ),
        // Floating action button to record new payment
        Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: PrimaryButton(
            label: 'Record Payment',
            icon: Icons.add,
            onPressed: () => _showRecordPaymentDialog(context, viewModel),
          ),
        ),
      ],
    );
  }

  /// Builds payment statistics card
  Widget _buildPaymentStatsCard(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final pendingPayments = viewModel.pendingPayments;
    final collectedPayments = viewModel.collectedPayments;
    final totalPending =
        pendingPayments.fold(0.0, (sum, p) => sum + p.amountPaid);
    final totalCollected =
        collectedPayments.fold(0.0, (sum, p) => sum + p.amountPaid);

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const HeadingMedium(
            text: 'Payment Summary',
            color: AppColors.textOnPrimary,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPaymentStatItem('Pending', pendingPayments.length,
                  totalPending, Colors.orange),
              _buildPaymentStatItem('Collected', collectedPayments.length,
                  totalCollected, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual payment stat item
  Widget _buildPaymentStatItem(
      String label, int count, double amount, Color color) {
    final formattedAmount = '₹${NumberFormat('#,##0').format(amount)}';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                formattedAmount,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        CaptionText(
          text: label,
          color: AppColors.textOnPrimary.withValues(alpha: 0.9),
        ),
      ],
    );
  }

  /// Shows dialog to record a new payment
  void _showRecordPaymentDialog(
      BuildContext context, OwnerGuestViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => RecordPaymentDialog(
        guests: viewModel.guests,
        bookings: viewModel.bookings,
      ),
    );
  }

  /// Builds individual booking request card
  Widget _buildBookingRequestCard(BuildContext context,
      OwnerBookingRequestModel request, OwnerGuestViewModel viewModel) {
    return AdaptiveCard(
      onTap: () => _showBookingRequestDetails(context, request, viewModel),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with guest name and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HeadingSmall(text: request.guestDisplayName),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: _getRequestStatusColor(request.status)
                        .withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: request.statusDisplay,
                    color: _getRequestStatusColor(request.status),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            // PG name
            Row(
              children: [
                Icon(Icons.apartment, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: BodyText(
                    text: request.pgName,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Contact info
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text: request.guestPhone,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Request date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                BodyText(
                  text: request.formattedCreatedAt,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
            if (request.message != null && request.message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: request.requestSummary,
                color: Colors.grey.shade700,
              ),
            ],
            // Action buttons for pending requests
            if (request.isPending) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Reject',
                      onPressed: () =>
                          _showRejectDialog(context, request, viewModel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Approve',
                      onPressed: () =>
                          _showApproveDialog(context, request, viewModel),
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

  /// Shows booking request details dialog
  void _showBookingRequestDetails(BuildContext context,
      OwnerBookingRequestModel request, OwnerGuestViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingSmall(text: 'Booking Request Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Guest Name', request.guestDisplayName),
              _buildDetailRow('Phone', request.guestPhone),
              _buildDetailRow('Email', request.guestEmail),
              _buildDetailRow('PG Name', request.pgName),
              _buildDetailRow('Request Date', request.formattedCreatedAt),
              _buildDetailRow('Status', request.statusDisplay),
              if (request.message != null && request.message!.isNotEmpty)
                _buildDetailRow('Message', request.message!),
              if (request.responseMessage != null &&
                  request.responseMessage!.isNotEmpty)
                _buildDetailRow('Response', request.responseMessage!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (request.isPending) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showRejectDialog(context, request, viewModel);
              },
              child: const Text('Reject'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showApproveDialog(context, request, viewModel);
              },
              child: const Text('Approve'),
            ),
          ],
        ],
      ),
    );
  }

  /// Shows approve dialog
  void _showApproveDialog(BuildContext context,
      OwnerBookingRequestModel request, OwnerGuestViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => BookingRequestActionDialog(
        request: request,
        isApproval: true,
      ),
    );
  }

  /// Shows reject dialog
  void _showRejectDialog(BuildContext context, OwnerBookingRequestModel request,
      OwnerGuestViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => BookingRequestActionDialog(
        request: request,
        isApproval: false,
      ),
    );
  }

  /// Builds a detail row for the dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: BodyText(
              text: '$label:',
              medium: true,
            ),
          ),
          Expanded(
            child: BodyText(text: value),
          ),
        ],
      ),
    );
  }

  /// Gets color for request status
  Color _getRequestStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Drawer actions centralized in OwnerDrawer
}
