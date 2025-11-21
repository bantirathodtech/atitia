// lib/features/guest_dashboard/complaints/view/screens/guest_complaint_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
import '../../../../../common/widgets/containers/section_container.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/guest_pg_selector_dropdown.dart';
import '../../../shared/widgets/user_location_display.dart';
import '../../viewmodel/guest_complaint_viewmodel.dart';
import '../widgets/guest_complaint_card.dart';

/// 📝 **GUEST COMPLAINTS SCREEN - PRODUCTION READY**
///
/// **Features:**
/// - View all complaints with status
/// - Filter by category and status
/// - Add new complaints with photos
/// - Track complaint resolution
/// - Premium theme-aware UI
class GuestComplaintsListScreen extends StatefulWidget {
  const GuestComplaintsListScreen({super.key});

  @override
  State<GuestComplaintsListScreen> createState() =>
      _GuestComplaintsListScreenState();
}

class _GuestComplaintsListScreenState extends State<GuestComplaintsListScreen> {
  String _selectedFilter = 'All'; // Internal key, localized via map

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final complaintVM =
          Provider.of<GuestComplaintViewModel>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final guestId = authProvider.user?.userId;
      if (!complaintVM.loading &&
          complaintVM.complaints.isEmpty &&
          guestId != null) {
        complaintVM.loadComplaints(guestId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final complaintVM = Provider.of<GuestComplaintViewModel>(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        leadingActions: [
          const GuestPgSelectorDropdown(compact: true),
        ],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              getIt<NavigationService>()
                  .goToRoute(AppRoutes.guestComplaintAdd());
            },
            tooltip:
                AppLocalizations.of(context)?.addComplaint ?? 'Add Complaint',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              final guestId = authProvider.user?.userId;
              if (guestId != null) {
                complaintVM.loadComplaints(guestId);
              }
            },
            tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final guestId = authProvider.user?.userId;
          if (guestId != null) {
            complaintVM.loadComplaints(guestId);
          }
        },
        child: _buildBody(context, complaintVM),
      ),
    );
  }

  /// Builds the main body content
  Widget _buildBody(BuildContext context, GuestComplaintViewModel complaintVM) {
    if (complaintVM.loading && complaintVM.complaints.isEmpty) {
      return _buildLoadingState(context);
    }

    if (complaintVM.error) {
      return _buildErrorState(context, complaintVM);
    }

    if (complaintVM.complaints.isEmpty) {
      return _buildEmptyState(context);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(context.responsivePadding.top),
      child: Column(
        children: [
          // User Location Display
          Padding(
            padding: EdgeInsets.only(bottom: context.responsivePadding.top),
            child: const UserLocationDisplay(),
          ),
          _buildFilterChips(context, complaintVM),
          SizedBox(height: context.responsivePadding.top),
          _buildComplaintsList(context, complaintVM),
        ],
      ),
    );
  }

  /// Builds the complaints list
  Widget _buildComplaintsList(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    final filteredComplaints = _getFilteredComplaints(complaintVM.complaints);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredComplaints.length,
      itemBuilder: (context, index) {
        final complaint = filteredComplaints[index];
        return Padding(
          padding: EdgeInsets.only(bottom: context.responsivePadding.top),
          child: GuestComplaintCard(complaint: complaint),
        );
      },
    );
  }

  /// Gets filtered complaints based on selected filter
  List<dynamic> _getFilteredComplaints(List<dynamic> complaints) {
    if (_selectedFilter == 'All') {
      return complaints;
    }
    return complaints
        .where((complaint) =>
            complaint.status?.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  /// 🎨 Premium Sliver App Bar
  // Keep for future use when premium UI features are enabled
  // ignore: unused_element
  Widget _buildPremiumSliverAppBar(BuildContext context, bool isDarkMode) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final complaintVM = Provider.of<GuestComplaintViewModel>(context);

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: isDarkMode ? AppColors.darkCard : primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: HeadingMedium(
          text: AppLocalizations.of(context)?.myComplaints ?? 'My Complaints',
          color: AppColors.textOnPrimary,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [
                      AppColors.darkCard,
                      AppColors.darkCard.withValues(alpha: 0.9)
                    ]
                  : [primaryColor, primaryColor.withValues(alpha: 0.8)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                top: 100, left: 16, right: 16, bottom: 60),
            child: _buildStatsRow(context, complaintVM, isDarkMode),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          onPressed: () {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final guestId = authProvider.user?.userId;
            if (guestId != null) {
              complaintVM.loadComplaints(guestId);
            }
          },
          tooltip: AppLocalizations.of(context)?.refresh ?? 'Refresh',
        ),
      ],
    );
  }

  /// 📊 Stats Row
  Widget _buildStatsRow(BuildContext context,
      GuestComplaintViewModel complaintVM, bool isDarkMode) {
    final pending = complaintVM.complaints
        .where((c) => c.status.toLowerCase() == 'pending')
        .length;
    final resolved = complaintVM.complaints
        .where((c) => c.status.toLowerCase() == 'resolved')
        .length;
    final total = complaintVM.complaints.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatBadge(
            context,
            '$total',
            AppLocalizations.of(context)?.total ?? 'Total',
            Icons.list_alt,
            AppColors.info,
            isDarkMode),
        _buildStatBadge(
            context,
            '$pending',
            AppLocalizations.of(context)?.pending ?? 'Pending',
            Icons.pending,
            AppColors.warning,
            isDarkMode),
        _buildStatBadge(
            context,
            '$resolved',
            AppLocalizations.of(context)?.resolved ?? 'Resolved',
            Icons.check_circle,
            AppColors.success,
            isDarkMode),
      ],
    );
  }

  /// 🏷️ Stat Badge
  Widget _buildStatBadge(BuildContext context, String value, String label,
      IconData icon, Color color, bool isDarkMode) {
    return Container(
      height: 60, // Fixed height to prevent overflow
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1)
            : Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
            color:
                Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 12),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnPrimary,
                    fontSize: 11,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textOnPrimary.withValues(alpha: 0.9),
                    fontSize: 7,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// 📱 Sliver Body
  // Keep for future use when sliver-based layout is needed
  // ignore: unused_element
  List<Widget> _buildSliverBody(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    if (complaintVM.loading && complaintVM.complaints.isEmpty) {
      return [
        SliverToBoxAdapter(child: _buildLoadingState(context)),
      ];
    }

    if (complaintVM.error) {
      return [
        SliverToBoxAdapter(child: _buildErrorState(context, complaintVM)),
      ];
    }

    if (complaintVM.complaints.isEmpty) {
      return [
        SliverToBoxAdapter(child: _buildEmptyState(context)),
      ];
    }

    return [
      SliverToBoxAdapter(child: _buildFilterChips(context, complaintVM)),
      _buildComplaintsSliverList(context, complaintVM),
    ];
  }

  /// 📱 Body (kept for compatibility - unused method)
  // Widget _buildBody(BuildContext context, GuestComplaintViewModel complaintVM) {
  //   if (complaintVM.loading && complaintVM.complaints.isEmpty) {
  //     return _buildLoadingState(context);
  //   }

  //   if (complaintVM.error) {
  //     return _buildErrorState(context, complaintVM);
  //   }

  //   if (complaintVM.complaints.isEmpty) {
  //     return _buildEmptyState(context);
  //   }

  //   return Column(
  //     children: [
  //       _buildFilterChips(context, complaintVM),
  //       _buildComplaintsList(context, complaintVM),
  //     ],
  //   );
  // }

  /// 🎛️ Filter Chips
  Widget _buildFilterChips(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    final loc = AppLocalizations.of(context);

    // Map English filter values to localized display strings
    final filterMap = {
      'All': loc?.all ?? 'All',
      'Pending': loc?.pending ?? 'Pending',
      'In Progress': loc?.inProgress ?? 'In Progress',
      'Resolved': loc?.resolved ?? 'Resolved',
    };

    final filterKeys = ['All', 'Pending', 'In Progress', 'Resolved'];

    return Padding(
      padding: EdgeInsets.all(context.responsivePadding.top),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filterKeys.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: EdgeInsets.only(right: context.responsivePadding.left),
              child: CustomFilterChip(
                label: filterMap[filter] ?? filter,
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 📋 Complaints Sliver List
  Widget _buildComplaintsSliverList(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    var complaints = complaintVM.complaints;

    // Apply filter
    if (_selectedFilter != 'All') {
      complaints = complaints
          .where((c) => c.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    if (complaints.isEmpty) {
      final loc = AppLocalizations.of(context);
      final filterMap = {
        'All': '',
        'Pending': loc?.pending ?? 'Pending',
        'In Progress': loc?.inProgress ?? 'In Progress',
        'Resolved': loc?.resolved ?? 'Resolved',
      };
      final filterLabel = filterMap[_selectedFilter] ?? '';
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: EmptyState(
            title: filterLabel.isEmpty
                ? (loc?.noComplaintsFound ?? 'No Complaints Found')
                : '${loc?.noComplaintsFound ?? 'No Complaints Found'} - $filterLabel',
            message: loc?.noComplaintsFoundWithSelectedFilter ??
                'No complaints found with the selected filter',
            icon: Icons.filter_list_off,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.paddingM,
              vertical: AppSpacing.paddingS,
            ),
            child: GuestComplaintCard(
              complaint: complaints[index],
              onTap: () {
                getIt<NavigationService>()
                    .goToGuestComplaintDetails(complaints[index].complaintId);
              },
            ),
          );
        },
        childCount: complaints.length,
      ),
    );
  }

  /// 📋 Complaints List (kept for compatibility)
  // Widget _buildComplaintsList(
  //     BuildContext context, GuestComplaintViewModel complaintVM) {
  //   var complaints = complaintVM.complaints;

  //   // Apply filter
  //   if (_selectedFilter != 'All') {
  //     complaints = complaints
  //         .where((c) => c.status.toLowerCase() == _selectedFilter.toLowerCase())
  //         .toList();
  //   }

  //   if (complaints.isEmpty) {
  //     return Container(
  //       padding: const EdgeInsets.all(AppSpacing.paddingL),
  //       child: EmptyState(
  //         title:
  //             'No ${_selectedFilter == 'All' ? '' : _selectedFilter} Complaints',
  //         message: 'No complaints found with the selected filter',
  //         icon: Icons.filter_list_off,
  //       ),
  //     );
  //   }

  //   return Expanded(
  //     child: ListView.builder(
  //       padding: const EdgeInsets.all(AppSpacing.paddingM),
  //       itemCount: complaints.length,
  //       itemBuilder: (context, index) {
  //         return GuestComplaintCard(
  //           complaint: complaints[index],
  //           onTap: () {
  //             getIt<NavigationService>()
  //                 .goToGuestComplaintDetails(complaints[index].complaintId);
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }

  /// ⏳ Loading State
  Widget _buildLoadingState(BuildContext context) {
    return SizedBox(
      height: 400, // Fixed height to prevent unbounded constraints
      child: ListView.builder(
        padding: EdgeInsets.all(context.responsivePadding.top),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: context.responsivePadding.top),
            child: ShimmerLoader(
              width: double.infinity,
              height: 120,
              borderRadius: AppSpacing.borderRadiusL,
            ),
          );
        },
      ),
    );
  }

  /// ❌ Error State
  Widget _buildErrorState(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: loc?.errorLoadingComplaints ?? 'Error Loading Complaints',
        message: complaintVM.errorMessage ??
            (loc?.unableToLoadComplaints ?? 'Unable to load complaints'),
        icon: Icons.error_outline,
        actionLabel: loc?.retry ?? 'Retry',
        onAction: () {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          final guestId = authProvider.user?.userId;
          if (guestId != null) {
            complaintVM.loadComplaints(guestId);
          }
        },
      ),
    );
  }

  /// 📝 Structured empty state with zero-state stats and placeholder complaint data structure
  Widget _buildEmptyState(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Zero-state stats section
          _buildComplaintZeroStateStats(context, false),

          // Small gap between stats and placeholder
          SizedBox(height: context.responsivePadding.top * 0.5),

          // Placeholder complaint structure
          _buildPlaceholderComplaintStructure(context, false),
        ],
      ),
    );
  }

  /// 📊 Complaint zero-state stats section
  Widget _buildComplaintZeroStateStats(BuildContext context, bool isDarkMode) {
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: context.responsiveMargin,
      child: SectionContainer(
        title: loc?.complaintStatistics ?? 'Complaint Statistics',
        icon: Icons.report_problem,
        child: Column(
          children: [
            // Stats grid
            Row(
              children: [
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.totalComplaints ?? 'Total Complaints',
                    '0',
                    Icons.report_problem,
                    AppColors.info,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.pending ?? 'Pending',
                    '0',
                    Icons.pending,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsivePadding.top),
            Row(
              children: [
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.inProgress ?? 'In Progress',
                    '0',
                    Icons.hourglass_empty,
                    AppColors.warning,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.resolved ?? 'Resolved',
                    '0',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.responsivePadding.top),
            Row(
              children: [
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.highPriority ?? 'High Priority',
                    '0',
                    Icons.priority_high,
                    AppColors.error,
                  ),
                ),
                SizedBox(width: context.responsivePadding.left),
                Expanded(
                  child: _buildComplaintStatCard(
                    context,
                    loc?.thisMonth ?? 'This Month',
                    '0',
                    Icons.calendar_month,
                    AppColors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 📊 Individual complaint stat card
  Widget _buildComplaintStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile
          ? context.responsivePadding.top * 0.5
          : context.responsivePadding.top),
      backgroundColor: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      hasShadow: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: context.isMobile ? 18 : 24,
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          // Row 2: Text below
          Text(
            label,
            style: TextStyle(
              fontSize: context.isMobile ? 10 : 12,
              color: (context.textTheme.bodySmall?.color ??
                      context.colors.onSurface)
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 📝 Placeholder complaint structure
  Widget _buildPlaceholderComplaintStructure(
      BuildContext context, bool isDarkMode) {
    final loc = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 0,
        left: context.responsiveMargin.left,
        right: context.responsiveMargin.right,
        bottom: context.responsiveMargin.bottom,
      ),
      child: SectionContainer(
        title: loc?.recentComplaintsPreview ?? 'Recent Complaints Preview',
        icon: Icons.report_problem,
        child: Column(
          children: [
            // Placeholder complaint cards
            ...List.generate(
                3, (index) => _buildPlaceholderComplaintCard(context, false)),
          ],
        ),
      ),
    );
  }

  /// 📝 Placeholder complaint card
  Widget _buildPlaceholderComplaintCard(BuildContext context, bool isDarkMode) {
    return AdaptiveCard(
      margin: EdgeInsets.only(bottom: context.responsivePadding.top),
      padding: EdgeInsets.all(context.isMobile
          ? context.responsivePadding.top * 0.5
          : context.responsivePadding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.report_problem,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: context.isMobile ? 10 : 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 6 : 8,
                      width: context.isMobile ? 100 : 120,
                      decoration: BoxDecoration(
                        color: ThemeColors.getDivider(context),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: context.isMobile ? 60 : 80,
                height: context.isMobile ? 20 : 24,
                decoration: BoxDecoration(
                  color: ThemeColors.getDivider(context),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Center(
                  child: Container(
                    height: context.isMobile ? 6 : 8,
                    width: context.isMobile ? 40 : 60,
                    decoration: BoxDecoration(
                      color: ThemeColors.getTextTertiary(context)
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsivePadding.top),

          // Complaint description placeholder
          Container(
            height: context.isMobile ? 30 : 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ThemeColors.getDivider(context),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
          ),

          SizedBox(height: context.responsivePadding.top),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 60 : 80,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 50 : 60,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        fontSize: context.isMobile ? 10 : 12,
                        color: ThemeColors.getTextTertiary(context),
                      ),
                    ),
                    SizedBox(
                        height: context.isMobile ? 4 : AppSpacing.paddingXS),
                    Container(
                      height: context.isMobile ? 12 : 16,
                      width: context.isMobile ? 60 : 70,
                      decoration: BoxDecoration(
                        color: ThemeColors.getTextTertiary(context)
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
//
