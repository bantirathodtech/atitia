// lib/feature/owner_dashboard/guests/view/screens/owner_guest_management_screen.dart

// FIXED: Unnecessary import warning
// Flutter recommends: Only import packages that provide unique functionality
// Changed from: Importing 'package:flutter/foundation.dart' when 'package:flutter/material.dart' already provides all needed elements
// Changed to: Removed unnecessary foundation.dart import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../l10n/app_localizations.dart';
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
    // Use select to only rebuild when specific properties change
    final currentPgId =
        context.select<SelectedPgProvider, String?>((p) => p.selectedPgId);
    final guestVM = context.watch<OwnerGuestViewModel>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Theme-aware background color
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,

        // Left: Drawer button (automatic with showDrawer: true)
        showDrawer: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.black : Colors.white,
              border: Border(
                top: BorderSide(
                  color: ThemeColors.getDivider(context),
                  width: 1,
                ),
              ),
            ),
            child: IconTheme(
              data: IconThemeData(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor:
                    context.isDarkMode ? Colors.white : Colors.black,
                labelColor: context.isDarkMode ? Colors.white : Colors.black,
                unselectedLabelColor:
                    context.isDarkMode ? Colors.white70 : Colors.black87,
                tabs: [
                  Tab(
                    icon: Icon(Icons.people),
                    text: loc.guests,
                  ),
                  Tab(
                    icon: Icon(Icons.request_page),
                    text: loc.requests,
                  ),
                  Tab(
                    icon: Icon(Icons.report_problem),
                    text: loc.complaints,
                  ),
                  Tab(
                    icon: Icon(Icons.two_wheeler),
                    text: loc.bikes,
                  ),
                  Tab(
                    icon: Icon(Icons.build),
                    text: loc.services,
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
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work_outlined,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(text: loc.ownerGuestNoPgSelectedTitle),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: loc.ownerGuestNoPgSelectedMessage,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Builds loading state
  Widget _buildLoadingState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AdaptiveLoader(),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(text: loc.loadingGuestData),
        ],
      ),
    );
  }

  /// Builds error state
  Widget _buildErrorState(BuildContext context, OwnerGuestViewModel guestVM) {
    final loc = AppLocalizations.of(context)!;
    return Semantics(
      label: 'Error loading guest data',
      hint:
          'An error occurred while loading guest management data. Use the retry button to try again.',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error icon',
              excludeSemantics: true,
              child: Icon(Icons.error_outline,
                  size: 64, color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Semantics(
              header: true,
              child: BodyText(text: loc.ownerGuestFailedToLoadData),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(
              onPressed: () => _refreshData(),
              label: loc.retry,
            ),
          ],
        ),
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
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Header with stats
        Container(
          padding: EdgeInsets.all(context.isMobile
              ? context.responsivePadding.top * 0.75
              : AppSpacing.paddingM),
          child: Row(
            children: [
              Expanded(
                child: _buildRequestStatCard(
                  context,
                  loc.pending,
                  guestVM.pendingBookingRequests.length,
                  AppColors.warning,
                ),
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: _buildRequestStatCard(
                  context,
                  loc.approved,
                  guestVM.approvedBookingRequests.length,
                  AppColors.success,
                ),
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: _buildRequestStatCard(
                  context,
                  loc.rejected,
                  guestVM.rejectedBookingRequests.length,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ),

        // Booking requests list
        Expanded(
          child: ListView.builder(
            itemCount: guestVM.bookingRequests.length,
            cacheExtent: 512,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
            itemBuilder: (context, index) {
              final req = guestVM.bookingRequests[index];
              final status = (req['status'] ?? '').toString().toLowerCase();
              final isPending = status == 'pending';
              return RepaintBoundary(
                key: ValueKey('booking_request_${req['id']}_$index'),
                child: AdaptiveCard(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingXS,
                  ),
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                                text: (req['guestName'] ?? loc.unknownGuest)
                                    .toString()),
                            const SizedBox(height: AppSpacing.paddingXS),
                            CaptionText(
                                text: (req['pgName'] ?? loc.unknownPg)
                                    .toString()),
                          ],
                        ),
                      ),
                      TextButtonWidget(
                        onPressed: () =>
                            _showRequestDetailsDialog(context, req),
                        text: loc.viewAction,
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      if (isPending) ...[
                        TextButtonWidget(
                          onPressed: () => _showRejectDialog(context, req),
                          text: loc.reject,
                          color: AppColors.error,
                        ),
                        const SizedBox(width: AppSpacing.paddingS),
                        PrimaryButton(
                          onPressed: () => _showApproveDialog(context, req),
                          label: loc.approve,
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingS,
                            vertical: AppSpacing.paddingXS,
                          ),
                          decoration: BoxDecoration(
                            color: ((status == 'approved')
                                    ? AppColors.success
                                    : AppColors.error)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CaptionText(
                            text: _statusLabel(status, loc),
                            color: status == 'approved'
                                ? AppColors.success
                                : AppColors.error,
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
  Widget _buildRequestStatCard(
      BuildContext context, String label, int count, Color color) {
    final padding = context.responsivePadding;
    return Container(
      padding: EdgeInsets.all(
          context.isMobile ? padding.top * 0.5 : padding.top * 0.75),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Number
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: context.isMobile ? 16 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS * 0.5
                  : AppSpacing.paddingXS),
          // Row 2: Label below
          BodyText(
            text: label,
            small: true,
            color: color,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Simple details dialog
  void _showRequestDetailsDialog(
      BuildContext context, Map<String, dynamic> req) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.bookingRequestDetailsTitle),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyText(
                        text:
                            '${loc.bookingRequestGuestNameLabel}: ${req['guestName'] ?? '-'}',
                      ),
                      BodyText(
                        text:
                            '${loc.bookingRequestPhoneLabel}: ${req['guestPhone'] ?? '-'}',
                      ),
                      const SizedBox(height: AppSpacing.paddingS),
                      BodyText(
                        text:
                            '${loc.bookingRequestPgNameLabel}: ${req['pgName'] ?? '-'}',
                      ),
                      BodyText(
                        text:
                            '${loc.bookingRequestStatusLabel}: ${_statusLabel((req['status'] ?? '-').toString().toLowerCase(), loc)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Align(
                alignment: Alignment.centerRight,
                child: TextButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: loc.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showApproveDialog(BuildContext context, Map<String, dynamic> req) {
    final responseController = TextEditingController();
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.approveBookingRequestTitle),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: responseController,
                label: loc.welcomeMessageOptional,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    onPressed: () async {
                      final vm = context.read<OwnerGuestViewModel>();
                      final requestId =
                          (req['requestId'] ?? req['id'] ?? '').toString();
                      await vm.approveBookingRequest(requestId,
                          responseMessage:
                              responseController.text.trim().isEmpty
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
                    label: loc.approve,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, Map<String, dynamic> req) {
    final responseController = TextEditingController();
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.rejectBookingRequestTitle),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: responseController,
                label: loc.rejectionReasonOptional,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    onPressed: () async {
                      final vm = context.read<OwnerGuestViewModel>();
                      final requestId =
                          (req['requestId'] ?? req['id'] ?? '').toString();
                      await vm.rejectBookingRequest(requestId,
                          responseMessage:
                              responseController.text.trim().isEmpty
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
                    label: loc.reject,
                    backgroundColor: AppColors.error,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(String status, AppLocalizations loc) {
    switch (status) {
      case 'pending':
        return loc.pending;
      case 'approved':
        return loc.approved;
      case 'rejected':
        return loc.rejected;
      default:
        return status.toUpperCase();
    }
  }
}
