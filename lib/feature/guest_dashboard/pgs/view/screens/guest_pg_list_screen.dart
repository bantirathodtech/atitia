// lib/features/guest_dashboard/pgs/view/screens/guest_pg_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/performance/memory_manager.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/performance/optimized_list_view.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/guest_pg_selector_dropdown.dart';
import '../../../shared/widgets/user_location_display.dart';
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

class _GuestPgListScreenState extends State<GuestPgListScreen>
    with MemoryManagementMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFilterPanel = false;
  bool _showSearchBar = false;
  final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  void initState() {
    super.initState();

    // Register controllers for automatic disposal
    registerController(_searchController);
    registerScrollController(_scrollController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pgVM = Provider.of<GuestPgViewModel>(context, listen: false);
      if (!pgVM.loading && pgVM.pgList.isEmpty) {
        pgVM.loadPGs(context);
      }
    });
  }

  // Dispose is handled by MemoryManagementMixin

  /// Toggle filter panel visibility
  void _toggleFilterPanel() {
    setState(() {
      _showFilterPanel = !_showFilterPanel;
    });
  }

  /// Toggle search bar visibility
  void _toggleSearchBar() {
    setState(() {
      _showSearchBar = !_showSearchBar;
      // Clear search when hiding search bar
      if (!_showSearchBar) {
        _searchController.clear();
        final pgVM = Provider.of<GuestPgViewModel>(context, listen: false);
        pgVM.setSearchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pgVM = Provider.of<GuestPgViewModel>(context);
    final loc = AppLocalizations.of(context);

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
            icon: Icon(
              _showSearchBar ? Icons.search_off : Icons.search,
            ),
            onPressed: () => _toggleSearchBar(),
            tooltip: _showSearchBar
                ? _text('hideSearch', 'Hide Search')
                : _text('showSearch', 'Show Search'),
          ),
          IconButton(
            icon: Icon(
              _showFilterPanel ? Icons.filter_list_off : Icons.filter_list,
            ),
            onPressed: () => _toggleFilterPanel(),
            tooltip: _showFilterPanel
                ? (loc?.hideFilters ?? _text('hideFilters', 'Hide Filters'))
                : (loc?.showFilters ?? _text('showFilters', 'Show Filters')),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => pgVM.refreshPGs(context),
            tooltip: loc?.refresh ?? _text('refresh', 'Refresh'),
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => pgVM.refreshPGs(context),
        child: _buildBody(context, pgVM),
      ),
    );
  }

  /// 🎨 Premium Sliver App Bar with gradient and stats
  // Keep for future use when premium UI features are enabled
  // ignore: unused_element
  Widget _buildPremiumSliverAppBar(
      BuildContext context, GuestPgViewModel pgVM) {
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;
    // final primaryColor = AppColors.primary;

    return SliverAppBar(
      expandedHeight: 240,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor:
          AppColors.darkCard, // Fixed: using dark mode for consistency
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: Builder(
          builder: (context) {
            final loc = AppLocalizations.of(context);
            return HeadingMedium(
              text: loc?.findYourPg ?? _text('findYourPg', 'Find Your PG'),
              color: AppColors.textOnPrimary,
            );
          },
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.darkCard,
                AppColors.darkCard.withValues(alpha: 0.9),
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
            child:
                _buildStatsRow(context, pgVM, true), // Fixed: using dark mode
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
          tooltip: () {
            final loc = AppLocalizations.of(context);
            return _showFilterPanel
                ? (loc?.hideFilters ?? _text('hideFilters', 'Hide Filters'))
                : (loc?.showFilters ?? _text('showFilters', 'Show Filters'));
          }(),
        ),
        // Refresh
        Builder(
          builder: (context) {
            final loc = AppLocalizations.of(context);
            return IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
              onPressed: () => pgVM.refreshPGs(context),
              tooltip: loc?.refresh ?? _text('refresh', 'Refresh'),
            );
          },
        ),
      ],
    );
  }

  /// 📊 Stats Row with premium styling
  Widget _buildStatsRow(
      BuildContext context, GuestPgViewModel pgVM, bool isDarkMode) {
    final stats = pgVM.pgStats;
    final loc = AppLocalizations.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatBadge(
          context,
          '${stats['totalPGs'] ?? 0}',
          loc?.pgsAvailable ?? _text('pgsAvailable', 'PGs Available'),
          Icons.apartment,
          AppColors.success,
          true,
        ),
        _buildStatBadge(
          context,
          '${stats['totalCities'] ?? 0}',
          loc?.cities ?? _text('cities', 'Cities'),
          Icons.location_city,
          AppColors.info,
          true,
        ),
        _buildStatBadge(
          context,
          '${stats['totalAmenities'] ?? 0}',
          loc?.amenities ?? _text('amenities', 'Amenities'),
          Icons.room_service,
          AppColors.warning,
          true,
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
        color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingXS),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
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
                  color: AppColors.textOnPrimary.withValues(alpha: 0.9),
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

    return SingleChildScrollView(
      child: Column(
        children: [
          // User Location Display
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.paddingM,
              AppSpacing.paddingM,
              AppSpacing.paddingM,
              _showSearchBar ? AppSpacing.paddingS : 0,
            ),
            child: const UserLocationDisplay(),
          ),
          if (_showSearchBar) _buildSearchBar(context, pgVM),
          if (_showFilterPanel) _buildAdvancedFilters(context, pgVM),
          if (pgVM.searchQuery.isNotEmpty ||
              pgVM.selectedCity != null ||
              pgVM.selectedAmenities.isNotEmpty)
            _buildActiveFiltersChips(context, pgVM),
          _buildPGsList(context, pgVM),
        ],
      ),
    );
  }

  /// 🔍 Premium search bar
  Widget _buildSearchBar(BuildContext context, GuestPgViewModel pgVM) {
    final loc = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.paddingM,
        0,
        AppSpacing.paddingM,
        AppSpacing.paddingS,
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => pgVM.setSearchQuery(value),
        style: context.textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: loc?.searchByNameCityArea ??
              _text(
                'searchByNameCityArea',
                'Search by name, city, area...',
              ),
          hintStyle: TextStyle(color: ThemeColors.getTextTertiary(context)),
          prefixIcon: Icon(
            Icons.search,
            color: ThemeColors.getTextTertiary(context),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: ThemeColors.getTextTertiary(context),
                  ),
                  onPressed: () {
                    _searchController.clear();
                    pgVM.setSearchQuery('');
                  },
                )
              : null,
          filled: true,
          fillColor: context.theme.inputDecorationTheme.fillColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            borderSide: BorderSide.none,
          ),
          enabledBorder: context.theme.inputDecorationTheme.enabledBorder,
          focusedBorder: context.theme.inputDecorationTheme.focusedBorder,
        ),
      ),
    );
  }

  /// 🎛️ Advanced filters panel
  Widget _buildAdvancedFilters(BuildContext context, GuestPgViewModel pgVM) {
    final loc = AppLocalizations.of(context);
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: AppColors.darkDivider,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
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
                text: loc?.filters ?? _text('filters', 'Filters'),
                color: AppColors.primary,
              ),
              TextButton(
                onPressed: () => pgVM.clearAllFilters(),
                child: Text(
                  loc?.clearAll ?? _text('clearAll', 'Clear All'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // City filter
          if (pgVM.getAvailableCities().isNotEmpty) ...[
            BodyText(
                text: loc?.city ?? _text('city', 'City'),
                color: AppColors.textSecondary),
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
                  backgroundColor: AppColors.darkInputFill,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],

          // Amenities filter
          if (pgVM.getAvailableAmenities().isNotEmpty) ...[
            BodyText(
                text: loc?.amenities ?? _text('amenities', 'Amenities'),
                color: AppColors.textSecondary),
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
                    final newAmenities =
                        List<String>.from(pgVM.selectedAmenities);
                    if (selected) {
                      newAmenities.add(amenity);
                    } else {
                      newAmenities.remove(amenity);
                    }
                    pgVM.setSelectedAmenities(newAmenities);
                  },
                  backgroundColor: AppColors.darkInputFill,
                  selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  checkmarkColor: AppColors.primary,
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
    final loc = AppLocalizations.of(context);
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CaptionText(
                text:
                    '${loc?.activeFilters ?? _text('activeFilters', 'Active Filters')}:',
                color: AppColors.textSecondary,
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
                          '${loc?.search ?? _text('search', 'Search')}: ${pgVM.searchQuery}',
                          () {
                            _searchController.clear();
                            pgVM.setSearchQuery('');
                          },
                          true,
                        ),
                      if (pgVM.selectedCity != null)
                        _buildActiveFilterChip(
                          context,
                          '${loc?.city ?? _text('city', 'City')}: ${pgVM.selectedCity}',
                          () => pgVM.setSelectedCity(null),
                          true,
                        ),
                      ...pgVM.selectedAmenities
                          .map((amenity) => _buildActiveFilterChip(
                                context,
                                amenity,
                                () {
                                  final newAmenities =
                                      List<String>.from(pgVM.selectedAmenities);
                                  newAmenities.remove(amenity);
                                  pgVM.setSelectedAmenities(newAmenities);
                                },
                                true,
                              )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: loc?.pgCountSummary(
                  pgVM.filteredPGCount,
                  pgVM.totalPGCount,
                ) ??
                _text(
                  'pgCountSummary',
                  '{filtered} of {total} PGs',
                  parameters: {
                    'filtered': pgVM.filteredPGCount.toString(),
                    'total': pgVM.totalPGCount.toString(),
                  },
                ),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  /// 🏷️ Active filter chip
  Widget _buildActiveFilterChip(BuildContext context, String label,
      VoidCallback onRemove, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.paddingS),
      child: Chip(
        label: Text(label),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: AppColors.darkInputFill,
        labelStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  /// 📋 PGs list with premium cards
  Widget _buildPGsList(BuildContext context, GuestPgViewModel pgVM) {
    final pgs = pgVM.filteredPGs;
    final loc = AppLocalizations.of(context);

    if (pgs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: EmptyState(
          title: loc?.noPgsFound ?? _text('noPgsFound', 'No PGs Found'),
          message: loc?.noPgsFoundDescription ??
              _text(
                'noPgsFoundDescription',
                'Try adjusting your search or filters to find more options.',
              ),
          icon: Icons.search_off,
          actionLabel: loc?.clearAll ?? _text('clearAll', 'Clear All'),
          onAction: () {
            _searchController.clear();
            pgVM.clearAllFilters();
          },
        ),
      );
    }

    return OptimizedListView<dynamic>(
      items: pgs,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.paddingM,
        AppSpacing.paddingS,
        AppSpacing.paddingM,
        AppSpacing.paddingM,
      ),
      itemBuilder: (context, pg, index) {
        return GuestPgCard(
          pg: pg,
          userLatitude: null, // TODO: Get from location service if needed
          userLongitude: null, // TODO: Get from location service if needed
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
    final shimmerItems = List.generate(5, (index) => index);

    return OptimizedListView<int>(
      items: shimmerItems,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemBuilder: (context, index, _) {
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
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: 'Error loading PG listings',
      hint:
          'An error occurred while loading PG properties. Use the retry button to try again.',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error icon',
              excludeSemantics: true,
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.paddingL),
            Semantics(
              header: true,
              child: HeadingMedium(
                text: loc?.errorLoadingPgs ??
                    _text('errorLoadingPgs', 'Error loading PGs'),
                align: TextAlign.center,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: pgVM.errorMessage ??
                  (loc?.unknownErrorOccurred ??
                      _text('unknownErrorOccurred', 'Unknown error occurred')),
              align: TextAlign.center,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () {
                // pgVM.clearError();
                pgVM.loadPGs(context);
              },
              label: loc?.tryAgain ?? _text('tryAgain', 'Try Again'),
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }

  /// 📭 Empty state
  Widget _buildEmptyState(BuildContext context, GuestPgViewModel pgVM) {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title:
            loc?.noPgsAvailable ?? _text('noPgsAvailable', 'No PGs Available'),
        message: loc?.pgListingsWillAppear ??
            _text('pgListingsWillAppear',
                'PG listings will appear here once they are added to the platform.'),
        icon: Icons.apartment,
        actionLabel: loc?.refresh ?? _text('refresh', 'Refresh'),
        onAction: () => pgVM.refreshPGs(context),
      ),
    );
  }
}
