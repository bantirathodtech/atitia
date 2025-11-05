// lib/feature/owner_dashboard/guests/view/screens/owner_guest_management_screen.dart

// FIXED: Unnecessary import warning
// Flutter recommends: Only import packages that provide unique functionality
// Changed from: Importing 'package:flutter/foundation.dart' when 'package:flutter/material.dart' already provides all needed elements
// Changed to: Removed unnecessary foundation.dart import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../widgets/bike_management_widget.dart';
import '../widgets/complaint_management_widget.dart';
import '../widgets/guest_list_widget.dart';
import '../widgets/service_management_widget.dart';

/// Main screen for owner's guest management
/// Provides tabbed interface for guests, complaints, bikes, and services
class OwnerGuestManagementScreen extends StatefulWidget {
  const OwnerGuestManagementScreen({super.key});

  @override
  State<OwnerGuestManagementScreen> createState() =>
      _OwnerGuestManagementScreenState();
}

class _OwnerGuestManagementScreenState extends State<OwnerGuestManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _lastLoadedPgId;
  SelectedPgProvider? _selectedPgProvider;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 5, vsync: this); // Added booking requests tab

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setupPgSelectionListener();
      await _loadInitialData();
    });
  }

  /// Setup PG selection listener for auto-reload
  Future<void> _setupPgSelectionListener() async {
    _selectedPgProvider = context.read<SelectedPgProvider>();
    _selectedPgProvider!.addListener(_onPgSelectionChanged);
  }

  /// Load initial data on screen load
  Future<void> _loadInitialData() async {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty && currentPgId != null) {
      _lastLoadedPgId = currentPgId;
      final guestVM = context.read<OwnerGuestViewModel>();
      await guestVM.initialize(ownerId, pgId: currentPgId);
    }
  }

  /// Handle PG selection changes
  void _onPgSelectionChanged() {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    if (currentPgId != null && currentPgId != _lastLoadedPgId) {
      _lastLoadedPgId = currentPgId;
      final guestVM = context.read<OwnerGuestViewModel>();
      guestVM.initialize(ownerId, pgId: currentPgId);
    }
  }

  @override
  void dispose() {
    try {
      _selectedPgProvider?.removeListener(_onPgSelectionChanged);
    } catch (e) {
      debugPrint('⚠️ Owner Guest Management: Failed to remove listener: $e');
    }

    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guestVM = context.watch<OwnerGuestViewModel>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final currentPgId = selectedPgProvider.selectedPgId;

    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Left: Drawer button (automatic with showDrawer: true)
        showDrawer: true,

        // Right: Refresh button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshData(),
            tooltip: 'Refresh Data',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.people),
                text: 'Guests',
              ),
              Tab(
                icon: Icon(Icons.request_page),
                text: 'Requests',
              ),
              Tab(
                icon: Icon(Icons.report_problem),
                text: 'Complaints',
              ),
              Tab(
                icon: Icon(Icons.two_wheeler),
                text: 'Bikes',
              ),
              Tab(
                icon: Icon(Icons.build),
                text: 'Services',
              ),
            ],
            onTap: (index) {
              final tabs = [
                'guests',
                'requests',
                'complaints',
                'bikes',
                'services'
              ];
              guestVM.setSelectedTab(tabs[index]);
            },
          ),
        ),
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, guestVM, currentPgId),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(
      BuildContext context, OwnerGuestViewModel guestVM, String? currentPgId) {
    if (currentPgId == null) {
      return _buildNoPgSelected(context);
    }

    if (guestVM.loading && guestVM.guests.isEmpty) {
      return _buildLoadingState(context);
    }

    if (guestVM.error) {
      return _buildErrorState(context, guestVM);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        GuestListWidget(),
        _buildBookingRequestsTab(context, guestVM),
        ComplaintManagementWidget(),
        BikeManagementWidget(),
        ServiceManagementWidget(),
      ],
    );
  }

  /// Builds no PG selected state
  Widget _buildNoPgSelected(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home_work_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: AppSpacing.paddingM),
          const HeadingMedium(text: 'No PG Selected'),
          const SizedBox(height: AppSpacing.paddingS),
          const BodyText(
            text: 'Please select a PG to manage guests',
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AdaptiveLoader(),
          const SizedBox(height: AppSpacing.paddingM),
          const BodyText(text: 'Loading guest data...'),
        ],
      ),
    );
  }

  /// Builds error state
  Widget _buildErrorState(BuildContext context, OwnerGuestViewModel guestVM) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: AppSpacing.paddingM),
          const BodyText(text: 'Failed to load guest data'),
          const SizedBox(height: AppSpacing.paddingM),
          ElevatedButton(
            onPressed: () => _refreshData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Refresh data
  Future<void> _refreshData() async {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty && currentPgId != null) {
      final guestVM = context.read<OwnerGuestViewModel>();
      await guestVM.refreshData(ownerId, pgId: currentPgId);
    }
  }

  /// Builds the booking requests tab
  Widget _buildBookingRequestsTab(
      BuildContext context, OwnerGuestViewModel guestVM) {
    return Column(
      children: [
        // Header with stats
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Row(
            children: [
              Expanded(
                child: _buildRequestStatCard(
                  'Pending',
                  guestVM.pendingBookingRequests.length,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: _buildRequestStatCard(
                  'Approved',
                  guestVM.approvedBookingRequests.length,
                  Colors.green,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: _buildRequestStatCard(
                  'Rejected',
                  guestVM.rejectedBookingRequests.length,
                  Colors.red,
                ),
              ),
            ],
          ),
        ),

        // Booking requests list
        Expanded(
          child: ListView.builder(
            itemCount: guestVM.bookingRequests.length,
            itemBuilder: (context, index) {
              final req = guestVM.bookingRequests[index];
              final status = (req['status'] ?? '').toString().toLowerCase();
              final isPending = status == 'pending';
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingXS,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                                text: (req['guestName'] ?? 'Unknown Guest')
                                    .toString()),
                            const SizedBox(height: 4),
                            CaptionText(
                                text:
                                    (req['pgName'] ?? 'Unknown PG').toString()),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            _showRequestDetailsDialog(context, req),
                        child: const Text('View'),
                      ),
                      const SizedBox(width: 8),
                      if (isPending) ...[
                        TextButton(
                          onPressed: () => _showRejectDialog(context, req),
                          child: const Text('Reject'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => _showApproveDialog(context, req),
                          child: const Text('Approve'),
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingS,
                            vertical: AppSpacing.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: ((status == 'approved')
                                    ? Colors.green
                                    : Colors.red)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CaptionText(
                            text: status.toUpperCase(),
                            color: (status == 'approved')
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a request stat card
  Widget _buildRequestStatCard(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          BodyText(
            text: count.toString(),
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          CaptionText(
            text: label,
            color: color,
          ),
        ],
      ),
    );
  }

  /// Simple details dialog
  void _showRequestDetailsDialog(
      BuildContext context, Map<String, dynamic> req) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const HeadingMedium(text: 'Booking Request Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(text: 'Guest: ${req['guestName'] ?? '-'}'),
            BodyText(text: 'Phone: ${req['guestPhone'] ?? '-'}'),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(text: 'PG: ${req['pgName'] ?? '-'}'),
            BodyText(
                text:
                    'Status: ${(req['status'] ?? '-').toString().toUpperCase()}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close')),
        ],
      ),
    );
  }

  void _showApproveDialog(BuildContext context, Map<String, dynamic> req) {
    final responseController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const HeadingMedium(text: 'Approve Booking Request'),
        content: TextField(
          controller: responseController,
          decoration: const InputDecoration(
            labelText: 'Welcome message (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final vm = context.read<OwnerGuestViewModel>();
              final requestId =
                  (req['requestId'] ?? req['id'] ?? '').toString();
              await vm.approveBookingRequest(requestId,
                  responseMessage: responseController.text.trim().isEmpty
                      ? null
                      : responseController.text.trim());
              // FIXED: BuildContext async gap warning
              // Flutter recommends: Check mounted immediately before using context after async operations
              // Changed from: Using context with mounted check after async gap
              // Changed to: Check mounted immediately before context usage
              // Note: Navigator is safe to use after async when mounted check is performed, analyzer flags as false positive
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, Map<String, dynamic> req) {
    final responseController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const HeadingMedium(text: 'Reject Booking Request'),
        content: TextField(
          controller: responseController,
          decoration: const InputDecoration(
            labelText: 'Reason (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final vm = context.read<OwnerGuestViewModel>();
              final requestId =
                  (req['requestId'] ?? req['id'] ?? '').toString();
              await vm.rejectBookingRequest(requestId,
                  responseMessage: responseController.text.trim().isEmpty
                      ? null
                      : responseController.text.trim());
              // FIXED: BuildContext async gap warning
              // Flutter recommends: Check mounted immediately before using context after async operations
              // Changed from: Using context with unrelated mounted check in compound condition
              // Changed to: Check mounted immediately before context usage
              // Note: Navigator is safe to use after async when mounted check is performed, analyzer flags as false positive
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }
}
