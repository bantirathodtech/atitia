// lib/features/guest_dashboard/pgs/view/screens/guest_pg_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../viewmodel/guest_pg_viewmodel.dart';
import '../widgets/guest_pg_card.dart';

/// 🏠 **GUEST PG LIST SCREEN - PRODUCTION READY**
///
/// **Features:**
/// - Real-time PG listings from Firestore
/// - Advanced search and filters
/// - Premium UI/UX with theme support
/// - Statistics overview
/// - Smooth animations and transitions
/// - Empty and error states
/// - Pull-to-refresh
class GuestPgListScreen extends StatefulWidget {
  const GuestPgListScreen({super.key});

  @override
  State<GuestPgListScreen> createState() => _GuestPgListScreenState();
}

class _GuestPgListScreenState extends State<GuestPgListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFilterPanel = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pgVM = Provider.of<GuestPgViewModel>(context, listen: false);
      if (!pgVM.loading && pgVM.pgList.isEmpty) {
        pgVM.loadPGs(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pgVM = Provider.of<GuestPgViewModel>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => pgVM.refreshPGs(context),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildPremiumSliverAppBar(context, pgVM),
            SliverToBoxAdapter(child: _buildBody(context, pgVM)),
          ],
        ),
      ),
    );
  }

  /// 🎨 Premium Sliver App Bar with gradient and stats
  Widget _buildPremiumSliverAppBar(
      BuildContext context, GuestPgViewModel pgVM) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;

    return SliverAppBar(
      expandedHeight: 240,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: isDarkMode ? AppColors.darkCard : primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: HeadingMedium(
          text: 'Find Your PG',
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
                      AppColors.darkCard.withOpacity(0.9),
                    ]
                  : [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 100,
              left: AppSpacing.paddingM,
              right: AppSpacing.paddingM,
              bottom: 60,
            ),
            child: _buildStatsRow(context, pgVM, isDarkMode),
          ),
        ),
      ),
      actions: [
        // Filter toggle
        IconButton(
          icon: Icon(
            _showFilterPanel ? Icons.filter_list_off : Icons.filter_list,
            color: AppColors.textOnPrimary,
          ),
          onPressed: () {
            setState(() {
              _showFilterPanel = !_showFilterPanel;
            });
          },
          tooltip: _showFilterPanel ? 'Hide Filters' : 'Show Filters',
        ),
        // Refresh
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          onPressed: () => pgVM.refreshPGs(context),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  /// 📊 Stats Row with premium styling
  Widget _buildStatsRow(
      BuildContext context, GuestPgViewModel pgVM, bool isDarkMode) {
    final stats = pgVM.pgStats;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatBadge(
          context,
          '${stats['totalPGs'] ?? 0}',
          'PGs Available',
          Icons.apartment,
          AppColors.success,
          isDarkMode,
        ),
        _buildStatBadge(
          context,
          '${stats['totalCities'] ?? 0}',
          'Cities',
          Icons.location_city,
          AppColors.info,
          isDarkMode,
        ),
        _buildStatBadge(
          context,
          '${stats['totalAmenities'] ?? 0}',
          'Amenities',
          Icons.room_service,
          AppColors.warning,
          isDarkMode,
        ),
      ],
    );
  }

  /// 🏷️ Premium stat badge
  Widget _buildStatBadge(BuildContext context, String value, String label,
      IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.9),
                  fontSize: 9,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 📱 Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, GuestPgViewModel pgVM) {
    if (pgVM.loading && pgVM.pgList.isEmpty) {
      return _buildLoadingState(context);
    }

    if (pgVM.error) {
      return _buildErrorState(context, pgVM);
    }

    if (pgVM.pgList.isEmpty) {
      return _buildEmptyState(context, pgVM);
    }

    return Column(
      children: [
        _buildSearchBar(context, pgVM),
        if (_showFilterPanel) _buildAdvancedFilters(context, pgVM),
        if (pgVM.searchQuery.isNotEmpty ||
            pgVM.selectedCity != null ||
            pgVM.selectedAmenities.isNotEmpty)
          _buildActiveFiltersChips(context, pgVM),
        _buildPGsList(context, pgVM),
      ],
    );
  }

  /// 🔍 Premium search bar
  Widget _buildSearchBar(BuildContext context, GuestPgViewModel pgVM) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => pgVM.setSearchQuery(value),
        decoration: InputDecoration(
          hintText: 'Search by name, city, area...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    pgVM.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: isDarkMode
              ? AppColors.darkInputFill
              : AppColors.surfaceVariant,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            borderSide: BorderSide(
              color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            borderSide: BorderSide(
              color: theme.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  /// 🎛️ Advanced filters panel
  Widget _buildAdvancedFilters(BuildContext context, GuestPgViewModel pgVM) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingSmall(
                text: 'Filters',
                color: theme.primaryColor,
              ),
              TextButton(
                onPressed: () => pgVM.clearAllFilters(),
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          // City filter
          if (pgVM.getAvailableCities().isNotEmpty) ...[
            BodyText(text: 'City', color: theme.textTheme.bodyMedium?.color),
            const SizedBox(height: AppSpacing.paddingS),
            Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingS,
              children: pgVM.getAvailableCities().map((city) {
                final isSelected = pgVM.selectedCity == city;
                return FilterChip(
                  label: Text(city),
                  selected: isSelected,
                  onSelected: (selected) {
                    pgVM.setSelectedCity(selected ? city : null);
                  },
                  backgroundColor: isDarkMode
                      ? AppColors.darkInputFill
                      : AppColors.surfaceVariant,
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  checkmarkColor: theme.primaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],

          // Amenities filter
          if (pgVM.getAvailableAmenities().isNotEmpty) ...[
            BodyText(text: 'Amenities', color: theme.textTheme.bodyMedium?.color),
            const SizedBox(height: AppSpacing.paddingS),
            Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingS,
              children: pgVM.getAvailableAmenities().map((amenity) {
                final isSelected = pgVM.selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    final newAmenities = List<String>.from(pgVM.selectedAmenities);
                    if (selected) {
                      newAmenities.add(amenity);
                    } else {
                      newAmenities.remove(amenity);
                    }
                    pgVM.setSelectedAmenities(newAmenities);
                  },
                  backgroundColor: isDarkMode
                      ? AppColors.darkInputFill
                      : AppColors.surfaceVariant,
                  selectedColor: theme.primaryColor.withOpacity(0.2),
                  checkmarkColor: theme.primaryColor,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// 🏷️ Active filters chips
  Widget _buildActiveFiltersChips(BuildContext context, GuestPgViewModel pgVM) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CaptionText(
                text: 'Active Filters:',
                color: theme.textTheme.bodySmall?.color,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (pgVM.searchQuery.isNotEmpty)
                        _buildActiveFilterChip(
                          context,
                          'Search: ${pgVM.searchQuery}',
                          () {
                            _searchController.clear();
                            pgVM.setSearchQuery('');
                          },
                          isDarkMode,
                        ),
                      if (pgVM.selectedCity != null)
                        _buildActiveFilterChip(
                          context,
                          'City: ${pgVM.selectedCity}',
                          () => pgVM.setSelectedCity(null),
                          isDarkMode,
                        ),
                      ...pgVM.selectedAmenities.map((amenity) =>
                          _buildActiveFilterChip(
                            context,
                            amenity,
                            () {
                              final newAmenities =
                                  List<String>.from(pgVM.selectedAmenities);
                              newAmenities.remove(amenity);
                              pgVM.setSelectedAmenities(newAmenities);
                            },
                            isDarkMode,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: '${pgVM.filteredPGCount} of ${pgVM.totalPGCount} PGs',
            color: theme.textTheme.bodySmall?.color,
          ),
        ],
      ),
    );
  }

  /// 🏷️ Active filter chip
  Widget _buildActiveFilterChip(
      BuildContext context, String label, VoidCallback onRemove, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.paddingS),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: isDarkMode
            ? AppColors.darkInputFill
            : AppColors.surfaceVariant,
        labelStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  /// 📋 PGs list with premium cards
  Widget _buildPGsList(BuildContext context, GuestPgViewModel pgVM) {
    final pgs = pgVM.filteredPGs;

    if (pgs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: EmptyState(
          title: 'No PGs Found',
          message: 'Try adjusting your search or filters',
          icon: Icons.search_off,
          actionLabel: 'Clear Filters',
          onAction: () {
            _searchController.clear();
            pgVM.clearAllFilters();
          },
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pgs.length,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemBuilder: (context, index) {
        final pg = pgs[index];
        return GuestPgCard(
          pg: pg,
          onTap: () {
            pgVM.setSelectedPG(pg);
            getIt<NavigationService>().goToGuestPGDetails(pg.pgId);
          },
        );
      },
    );
  }

  /// ⏳ Loading state with shimmer
  Widget _buildLoadingState(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
          child: ShimmerLoader(
            width: double.infinity,
            height: 280,
            borderRadius: AppSpacing.borderRadiusL,
          ),
        );
      },
    );
  }

  /// ❌ Error state
  Widget _buildErrorState(BuildContext context, GuestPgViewModel pgVM) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          HeadingMedium(
            text: 'Error loading PGs',
            align: TextAlign.center,
            color: theme.textTheme.headlineMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: pgVM.errorMessage ?? 'Unknown error occurred',
            align: TextAlign.center,
            color: theme.textTheme.bodyMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PrimaryButton(
            onPressed: () {
              pgVM.clearError();
              pgVM.loadPGs(context);
            },
            label: 'Try Again',
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  /// 📭 Empty state
  Widget _buildEmptyState(BuildContext context, GuestPgViewModel pgVM) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'No PGs Available',
        message:
            'PG listings will appear here once they are added to the platform.',
        icon: Icons.apartment,
        actionLabel: 'Refresh',
        onAction: () => pgVM.refreshPGs(context),
      ),
    );
  }
}
