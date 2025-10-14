// lib/features/guest_dashboard/complaints/view/screens/guest_complaint_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../common/utils/constants/routes.dart';
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
      if (!complaintVM.loading && complaintVM.complaints.isEmpty) {
        complaintVM.loadComplaints(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final complaintVM = Provider.of<GuestComplaintViewModel>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => complaintVM.loadComplaints(context),
        child: CustomScrollView(
          slivers: [
            _buildPremiumSliverAppBar(context, isDarkMode),
            ..._buildSliverBody(context, complaintVM),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          getIt<NavigationService>().goToRoute(AppRoutes.guestComplaintAdd());
        },
        backgroundColor: theme.primaryColor,
        foregroundColor: AppColors.textOnPrimary,
        icon: const Icon(Icons.add),
        label: const Text('New Complaint'),
      ),
    );
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
                  ? [AppColors.darkCard, AppColors.darkCard.withOpacity(0.9)]
                  : [primaryColor, primaryColor.withOpacity(0.8)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 60),
            child: _buildStatsRow(context, complaintVM, isDarkMode),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          onPressed: () => complaintVM.loadComplaints(context),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  /// 📊 Stats Row
  Widget _buildStatsRow(
      BuildContext context, GuestComplaintViewModel complaintVM, bool isDarkMode) {
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
        _buildStatBadge(context, '$total', 'Total', Icons.list_alt, AppColors.info, isDarkMode),
        _buildStatBadge(context, '$pending', 'Pending', Icons.pending, AppColors.warning, isDarkMode),
        _buildStatBadge(context, '$resolved', 'Resolved', Icons.check_circle, AppColors.success, isDarkMode),
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
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
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
                    color: AppColors.textOnPrimary.withOpacity(0.9),
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
  List<Widget> _buildSliverBody(BuildContext context, GuestComplaintViewModel complaintVM) {
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

  /// 📱 Body (kept for compatibility)
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

    return Column(
      children: [
        _buildFilterChips(context, complaintVM),
        _buildComplaintsList(context, complaintVM),
      ],
    );
  }

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
                selectedColor: theme.primaryColor.withOpacity(0.2),
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
            title: 'No ${_selectedFilter == 'All' ? '' : _selectedFilter} Complaints',
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
  Widget _buildComplaintsList(
      BuildContext context, GuestComplaintViewModel complaintVM) {
    var complaints = complaintVM.complaints;

    // Apply filter
    if (_selectedFilter != 'All') {
      complaints = complaints
          .where((c) => c.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    if (complaints.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: EmptyState(
          title: 'No ${_selectedFilter == 'All' ? '' : _selectedFilter} Complaints',
          message: 'No complaints found with the selected filter',
          icon: Icons.filter_list_off,
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        itemCount: complaints.length,
        itemBuilder: (context, index) {
          return GuestComplaintCard(
            complaint: complaints[index],
            onTap: () {
              getIt<NavigationService>()
                  .goToGuestComplaintDetails(complaints[index].complaintId);
            },
          );
        },
      ),
    );
  }

  /// ⏳ Loading State
  Widget _buildLoadingState(BuildContext context) {
    return ListView.builder(
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
        onAction: () => complaintVM.loadComplaints(context),
      ),
    );
  }

  /// 📭 Empty State
  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'No Complaints Yet',
        message: 'Tap the + button below to submit your first complaint',
        icon: Icons.inbox_outlined,
      ),
    );
  }
}
