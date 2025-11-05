// lib/features/guest_dashboard/complaints/view/screens/guest_complaint_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
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
  String _selectedFilter = 'All';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              getIt<NavigationService>()
                  .goToRoute(AppRoutes.guestComplaintAdd());
            },
            tooltip: 'Add Complaint',
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
            tooltip: 'Refresh',
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: theme.scaffoldBackgroundColor,
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
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        children: [
          // User Location Display
          const Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: UserLocationDisplay(),
          ),
          _buildFilterChips(context, complaintVM),
          const SizedBox(height: AppSpacing.paddingM),
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
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
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
          text: 'My Complaints',
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
          tooltip: 'Refresh',
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
        _buildStatBadge(context, '$total', 'Total', Icons.list_alt,
            AppColors.info, isDarkMode),
        _buildStatBadge(context, '$pending', 'Pending', Icons.pending,
            AppColors.warning, isDarkMode),
        _buildStatBadge(context, '$resolved', 'Resolved', Icons.check_circle,
            AppColors.success, isDarkMode),
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
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['All', 'Pending', 'In Progress', 'Resolved'].map((filter) {
            final isSelected = _selectedFilter == filter;
            return Container(
              margin: const EdgeInsets.only(right: AppSpacing.paddingS),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                },
                backgroundColor: isDarkMode
                    ? AppColors.darkInputFill
                    : AppColors.surfaceVariant,
                selectedColor: theme.primaryColor.withValues(alpha: 0.2),
                checkmarkColor: theme.primaryColor,
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
      return SliverToBoxAdapter(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: EmptyState(
            title:
                'No ${_selectedFilter == 'All' ? '' : _selectedFilter} Complaints',
            message: 'No complaints found with the selected filter',
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
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'Error Loading Complaints',
        message: complaintVM.errorMessage ?? 'Unable to load complaints',
        icon: Icons.error_outline,
        actionLabel: 'Retry',
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Zero-state stats section
          _buildComplaintZeroStateStats(context, isDarkMode),

          // Placeholder complaint structure
          _buildPlaceholderComplaintStructure(context, isDarkMode),

          // Call to action
          _buildComplaintEmptyStateAction(context),
        ],
      ),
    );
  }

  /// 📊 Complaint zero-state stats section
  Widget _buildComplaintZeroStateStats(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Complaint Statistics',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'Total Complaints',
                  '0',
                  Icons.report_problem,
                  Colors.blue,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'Pending',
                  '0',
                  Icons.pending,
                  Colors.orange,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'In Progress',
                  '0',
                  Icons.hourglass_empty,
                  Colors.amber,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'Resolved',
                  '0',
                  Icons.check_circle,
                  Colors.green,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'High Priority',
                  '0',
                  Icons.priority_high,
                  Colors.red,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildComplaintStatCard(
                  context,
                  'This Month',
                  '0',
                  Icons.calendar_month,
                  Colors.purple,
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
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
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 📝 Placeholder complaint structure
  Widget _buildPlaceholderComplaintStructure(
      BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Recent Complaints Preview',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Placeholder complaint cards
          ...List.generate(3,
              (index) => _buildPlaceholderComplaintCard(context, isDarkMode)),
        ],
      ),
    );
  }

  /// 📝 Placeholder complaint card
  Widget _buildPlaceholderComplaintCard(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Icon(
                  Icons.report_problem,
                  color: Colors.grey.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 80,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Center(
                  child: Container(
                    height: 8,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Complaint description placeholder
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
          ),

          const SizedBox(height: AppSpacing.paddingM),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
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
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
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
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 16,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.3),
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

  /// 🔄 Complaint empty state action section
  Widget _buildComplaintEmptyStateAction(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.report_problem_outlined,
            size: 48,
            color: isDarkMode ? Colors.white54 : Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(
            text: 'No Complaints Yet',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            'You haven\'t submitted any complaints yet. Your complaints and their status will appear here once you submit them.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Complaint categories preview
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Common Complaint Categories:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingM),
                _buildPlaceholderComplaintCategory(
                    context, 'Maintenance Issues', isDarkMode),
                const SizedBox(height: AppSpacing.paddingS),
                _buildPlaceholderComplaintCategory(
                    context, 'Cleanliness', isDarkMode),
                const SizedBox(height: AppSpacing.paddingS),
                _buildPlaceholderComplaintCategory(
                    context, 'Food Quality', isDarkMode),
                const SizedBox(height: AppSpacing.paddingS),
                _buildPlaceholderComplaintCategory(
                    context, 'Noise Complaints', isDarkMode),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                getIt<NavigationService>()
                    .goToRoute(AppRoutes.guestComplaintAdd());
              },
              icon: const Icon(Icons.add),
              label: const Text('Submit First Complaint'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 📝 Placeholder complaint category
  Widget _buildPlaceholderComplaintCategory(
      BuildContext context, String category, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingS),
        Text(
          category,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
//
