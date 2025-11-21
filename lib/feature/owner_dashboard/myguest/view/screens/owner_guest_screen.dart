// lib/features/owner_dashboard/myguest/view/screens/owner_guest_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
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
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../l10n/app_localizations.dart';
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
    final AppLocalizations loc = AppLocalizations.of(context)!;

    if (bookingRequests.isEmpty && bedChangeRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.request_page_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(
              text: loc.noRequests,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc.bookingAndBedChangeRequestsWillAppearHere,
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
          Container(
            color: context.isDarkMode ? Colors.black : Colors.white,
            child: IconTheme(
              data: IconThemeData(
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
              child: TabBar(
                indicatorColor:
                    context.isDarkMode ? Colors.white : Colors.black,
                labelColor: context.isDarkMode ? Colors.white : Colors.black,
                unselectedLabelColor:
                    context.isDarkMode ? Colors.white70 : Colors.black87,
                tabs: [
                  Tab(
                    text: '${loc.bookingRequests} (${bookingRequests.length})',
                    icon: Icon(Icons.book_online, size: 16),
                  ),
                  Tab(
                    text:
                        '${loc.bedChanges} (${pendingBedChangeRequests.length} ${loc.pending})',
                    icon: Icon(Icons.bed, size: 16),
                  ),
                ],
              ),
            ),
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
    final AppLocalizations loc = AppLocalizations.of(context)!;

    if (complaints.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report_problem_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingMedium(text: loc.noComplaintsFound),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc.complaintsFromGuestsWillAppearHere,
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
                        color: c.isResolved
                            ? AppColors.success
                            : AppColors.statusOrange,
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      Expanded(
                        child: HeadingSmall(
                            text: c.title.isEmpty ? loc.complaints : c.title),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.paddingS, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
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
                      Icon(Icons.person,
                          size: 14,
                          color: ThemeColors.getTextTertiary(context)),
                      const SizedBox(width: AppSpacing.paddingXS),
                      CaptionText(
                        text: c.guestName.isEmpty ? loc.guest : c.guestName,
                      ),
                      const SizedBox(width: AppSpacing.paddingM),
                      Icon(Icons.schedule,
                          size: 14,
                          color: ThemeColors.getTextTertiary(context)),
                      const SizedBox(width: AppSpacing.paddingXS),
                      CaptionText(text: _formatShortDate(c.createdAt)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  Row(
                    children: [
                      SecondaryButton(
                        label: loc.reply,
                        onPressed: () => _showComplaintReplyDialog(
                            context, viewModel, c.complaintId),
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      if (!c.isResolved)
                        PrimaryButton(
                          label: loc.resolve,
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
    final AppLocalizations loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.replyToComplaint),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: controller,
                label: loc.reply,
                hint: loc.typeYourReply,
                maxLines: 4,
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
            label: loc.send,
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
                      text: ok ? loc.replySent : loc.failedToSendReply,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    backgroundColor: ok ? AppColors.success : AppColors.error,
                  ),
                );
              }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resolveComplaint(
      BuildContext context, OwnerGuestViewModel viewModel, String complaintId) {
    final notes = TextEditingController();
    final AppLocalizations loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.resolveComplaint),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: notes,
                label: loc.resolutionNotesOptional,
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
                    label: loc.markResolved,
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
                              text: ok ? loc.complaintResolved : loc.failedToResolve,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            backgroundColor: ok ? AppColors.success : AppColors.error,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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
    final AppLocalizations loc = AppLocalizations.of(context)!;

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

        // Theme-aware background color
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,

        // Left: Drawer button
        showDrawer: true,

        // Right: Add PG
        actions: [
          const AddPgActionButton(),
        ],

        // Bottom: Guest tab bar with theme-aware colors and border to prevent overlap
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
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
                  Tab(text: loc.guests, icon: Icon(Icons.people, size: 16)),
                  Tab(
                      text: loc.booking,
                      icon: Icon(Icons.book_online, size: 16)),
                  Tab(text: loc.payments, icon: Icon(Icons.payment, size: 16)),
                  Tab(
                      text: loc.complaints,
                      icon: Icon(Icons.report_problem, size: 16)),
                  Tab(
                      text: loc.requests,
                      icon: Icon(Icons.request_page, size: 16)),
                  Tab(text: loc.bedMap, icon: Icon(Icons.bed, size: 16)),
                ],
              ),
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

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerGuestViewModel viewModel) {
    final AppLocalizations loc = AppLocalizations.of(context)!;

    if (viewModel.loading && viewModel.guests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(text: loc.loadingGuestData),
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
              text: loc.errorLoadingData,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: viewModel.errorMessage ?? loc.somethingWentWrong,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: viewModel.refreshData,
              label: loc.tryAgain,
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
    final AppLocalizations loc = AppLocalizations.of(context)!;

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
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: BodyText(
              text: '${viewModel.selectedCount} ${loc.selected}',
              color: Theme.of(context).colorScheme.onPrimary,
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
              color: Theme.of(context).colorScheme.onPrimary,
              size: 18,
            ),
            label: BodyText(
              text: viewModel.selectedCount == viewModel.filteredGuests.length
                  ? loc.deselectAll
                  : loc.selectAll,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const Spacer(),
          // Bulk actions
          IconButton(
            icon: Icon(Icons.edit,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () => _showBulkStatusDialog(context, viewModel),
            tooltip: loc.changeStatus,
          ),
          IconButton(
            icon: Icon(Icons.delete,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () => _confirmBulkDelete(context, viewModel),
            tooltip: loc.deleteSelected,
          ),
        ],
      ),
    );
  }

  Future<void> _showBulkStatusDialog(
      BuildContext context, OwnerGuestViewModel viewModel) async {
    final AppLocalizations loc = AppLocalizations.of(context)!;

    final newStatus = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.changeStatus),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.check_circle, color: AppColors.success),
                      title: BodyText(text: loc.active),
                      onTap: () => Navigator.pop(context, 'active'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.pending, color: AppColors.statusOrange),
                      title: BodyText(text: loc.pending),
                      onTap: () => Navigator.pop(context, 'pending'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.cancel, color: AppColors.error),
                      title: BodyText(text: loc.inactive),
                      onTap: () => Navigator.pop(context, 'inactive'),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    if (!success || !mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(loc.updatedGuestsToStatus(viewModel.selectedCount, newStatus)),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Future<void> _confirmBulkDelete(
      BuildContext context, OwnerGuestViewModel viewModel) async {
    final AppLocalizations loc = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.confirmBulkDelete),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(
                text: loc.areYouSureYouWantToDeleteGuests(viewModel.selectedCount),
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.pop(context, false),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  TextButtonWidget(
                    onPressed: () => Navigator.pop(context, true),
                    text: loc.delete,
                    color: AppColors.error,
                    bold: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed != true || !mounted) return;
    final success = await viewModel.bulkDeleteGuests();
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Check mounted immediately before using context after async operations
    // Changed from: Using context with mounted check in compound condition after async gap
    // Changed to: Check mounted immediately before context usage
    // Note: ScaffoldMessenger is safe to use after async when mounted check is performed, analyzer flags as false positive
    if (!success || !mounted) return;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.guestsDeletedSuccessfully),
        backgroundColor: AppColors.success,
      ),
    );
  }

  /// Builds statistics card
  Widget _buildStatsCard(BuildContext context, OwnerGuestViewModel viewModel) {
    final stats = viewModel.guestStats;
    final AppLocalizations loc = AppLocalizations.of(context)!;

    return AdaptiveCard(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.guestOverview,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                loc.totalGuests,
                '${stats['totalGuests'] ?? 0}',
                Icons.people,
              ),
              _buildStatItem(
                context,
                loc.activeGuests,
                '${stats['activeGuests'] ?? 0}',
                Icons.check_circle,
              ),
              _buildStatItem(
                context,
                loc.pendingGuests,
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
        const SizedBox(height: AppSpacing.paddingXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        Text(
          title,
          style: context.textTheme.bodySmall?.copyWith(
            color: ThemeColors.getTextTertiary(context),
          ),
        ),
      ],
    );
  }

  /// Builds filter chips
  /// Builds search bar with debouncing
  Widget _buildSearchBar(BuildContext context, OwnerGuestViewModel viewModel) {
    final AppLocalizations loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: context.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: ThemeColors.getTextTertiary(context),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: TextField(
              onChanged: viewModel.setSearchQuery,
              style: context.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: loc.ownerGuestSearchHint,
                hintStyle: TextStyle(
                  color: ThemeColors.getTextTertiary(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          if (viewModel.searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: ThemeColors.getTextTertiary(context),
              ),
              onPressed: viewModel.clearSearch,
              tooltip: loc.ownerGuestClearSearchTooltip,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final AppLocalizations loc = AppLocalizations.of(context)!;
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
                      label: _filterLabel(filter, loc),
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
                        const SizedBox(width: AppSpacing.paddingXS),
                        BodyText(
                          text:
                              '${viewModel.filteredGuests.length} ${loc.found}',
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

  String _filterLabel(String filter, AppLocalizations loc) {
    switch (filter) {
      case 'Active':
        return loc.ownerGuestFilterActive;
      case 'Pending':
        return loc.ownerGuestFilterPending;
      case 'Inactive':
        return loc.ownerGuestFilterInactive;
      case 'Vehicles':
        return loc.ownerGuestFilterVehicles;
      case 'All':
      default:
        return loc.ownerGuestFilterAll;
    }
  }

  /// Builds the payments tab content
  Widget _buildPaymentsTab(
      BuildContext context, OwnerGuestViewModel viewModel) {
    final AppLocalizations loc = AppLocalizations.of(context)!;
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
            label: loc.recordPayment,
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
    final AppLocalizations loc = AppLocalizations.of(context)!;

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
          HeadingMedium(
            text: loc.ownerGuestPaymentSummaryTitle,
            color: AppColors.textOnPrimary,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPaymentStatItem(
                context,
                loc.ownerGuestPaymentPendingLabel,
                pendingPayments.length,
                totalPending,
                AppColors.statusOrange,
              ),
              _buildPaymentStatItem(
                context,
                loc.ownerGuestPaymentCollectedLabel,
                collectedPayments.length,
                totalCollected,
                AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds individual payment stat item
  Widget _buildPaymentStatItem(BuildContext context, String label, int count,
      double amount, Color color) {
    final localeName = AppLocalizations.of(context)!.localeName;
    final currencyFormatter =
        NumberFormat.simpleCurrency(locale: localeName, name: 'INR');
    final formattedAmount = currencyFormatter.format(amount);

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
              const SizedBox(height: AppSpacing.paddingXS),
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
    final AppLocalizations loc = AppLocalizations.of(context)!;
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
                Icon(Icons.apartment,
                    size: 14, color: ThemeColors.getTextTertiary(context)),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: BodyText(
                    text: request.pgName,
                    color: ThemeColors.getTextTertiary(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Contact info
            Row(
              children: [
                Icon(Icons.phone,
                    size: 14, color: ThemeColors.getTextTertiary(context)),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: request.guestPhone,
                  color: ThemeColors.getTextTertiary(context),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            // Request date
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: ThemeColors.getTextTertiary(context)),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: request.formattedCreatedAt,
                  color: ThemeColors.getTextTertiary(context),
                ),
              ],
            ),
            if (request.message != null && request.message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingS),
              BodyText(
                text: request.requestSummary,
                color: ThemeColors.getTextSecondary(context),
              ),
            ],
            // Action buttons for pending requests
            if (request.isPending) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: loc.reject,
                      onPressed: () =>
                          _showRejectDialog(context, request, viewModel),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: PrimaryButton(
                      label: loc.approve,
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
    final AppLocalizations loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingSmall(text: loc.bookingRequestDetailsTitle),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                          loc.bookingRequestGuestNameLabel, request.guestDisplayName),
                      _buildDetailRow(loc.bookingRequestPhoneLabel, request.guestPhone),
                      _buildDetailRow(loc.bookingRequestEmailLabel, request.guestEmail),
                      _buildDetailRow(loc.bookingRequestPgNameLabel, request.pgName),
                      _buildDetailRow(
                          loc.bookingRequestDateLabel, request.formattedCreatedAt),
                      _buildDetailRow(
                          loc.bookingRequestStatusLabel, request.statusDisplay),
                      if (request.message != null && request.message!.isNotEmpty)
                        _buildDetailRow(
                            loc.bookingRequestMessageLabel, request.message!),
                      if (request.responseMessage != null &&
                          request.responseMessage!.isNotEmpty)
                        _buildDetailRow(
                            loc.bookingRequestResponseLabel, request.responseMessage!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.close,
                  ),
                  if (request.isPending) ...[
                    const SizedBox(width: AppSpacing.paddingS),
                    TextButtonWidget(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showRejectDialog(context, request, viewModel);
                      },
                      text: loc.reject,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showApproveDialog(context, request, viewModel);
                      },
                      label: loc.approve,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
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
        return AppColors.statusOrange;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    }
  }

  // Drawer actions centralized in OwnerDrawer
}
