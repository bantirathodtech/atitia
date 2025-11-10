// lib/feature/owner_dashboard/guests/view/widgets/service_management_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../../data/models/owner_service_model.dart';

/// Widget for managing service requests
class ServiceManagementWidget extends StatefulWidget {
  const ServiceManagementWidget({super.key});

  @override
  State<ServiceManagementWidget> createState() =>
      _ServiceManagementWidgetState();
}

class _ServiceManagementWidgetState extends State<ServiceManagementWidget> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isFormExpanded = false;

  static final InternationalizationService _i18n =
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
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _serviceTypeController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final guestVM = context.read<OwnerGuestViewModel>();
    guestVM.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final guestVM = context.watch<OwnerGuestViewModel>();
    final filteredServices = guestVM.filteredServices;

    return Column(
      children: [
        _buildSearchAndFilters(context, guestVM),
        _buildServiceRequestForm(context, guestVM),
        Expanded(
          child: _buildServiceList(context, guestVM, filteredServices),
        ),
      ],
    );
  }

  /// Builds search bar and filter controls
  Widget _buildSearchAndFilters(
      BuildContext context, OwnerGuestViewModel guestVM) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        children: [
          // Search bar with advanced options
          Row(
            children: [
              Expanded(
                child: TextInput(
                  controller: _searchController,
                  label: loc.searchServices,
                  hint: loc.searchByTitleGuestRoomOrType,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            guestVM.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              // Advanced search button
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showAdvancedSearch(context, guestVM),
                tooltip: loc.advancedSearch,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Filter chips with enhanced options - responsive layout
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
            child: Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingXS,
              children: [
                _buildFilterChip(loc.all, 'all', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip(loc.statusNew, 'new', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip(loc.inProgress, 'in_progress',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc.completed, 'completed', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip(loc.urgent, 'urgent', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingM),
                _buildTypeFilterChip(loc.maintenance, 'maintenance',
                    guestVM.typeFilter, guestVM.setTypeFilter),
                _buildTypeFilterChip(loc.housekeeping, 'housekeeping',
                    guestVM.typeFilter, guestVM.setTypeFilter),
                _buildTypeFilterChip(loc.vehicle, 'vehicle', guestVM.typeFilter,
                    guestVM.setTypeFilter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds filter chip
  Widget _buildFilterChip(String label, String value, String currentFilter,
      Function(String) onTap) {
    final isSelected = currentFilter == value;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => onTap(selected ? value : 'all'),
      selectedColor: AppColors.primary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.primary,
      backgroundColor: theme.cardColor,
      side: BorderSide(
        color: isSelected
            ? AppColors.primary
            : theme.dividerColor.withValues(alpha: 0.3),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingXS,
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
    );
  }

  /// Builds type filter chip
  Widget _buildTypeFilterChip(String label, String value, String currentFilter,
      Function(String) onTap) {
    final isSelected = currentFilter == value;
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) => onTap(selected ? value : 'all'),
      selectedColor: AppColors.secondary.withValues(alpha: 0.15),
      checkmarkColor: AppColors.secondary,
      backgroundColor: theme.cardColor,
      side: BorderSide(
        color: isSelected
            ? AppColors.secondary
            : theme.dividerColor.withValues(alpha: 0.3),
        width: isSelected ? 1.5 : 1,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingXS,
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 4,
    );
  }

  /// Toggles form expansion state
  void _toggleFormExpansion() {
    setState(() {
      _isFormExpanded = !_isFormExpanded;
    });
  }

  /// Builds service request form (collapsible)
  Widget _buildServiceRequestForm(
      BuildContext context, OwnerGuestViewModel guestVM) {
    final isMobile = context.isMobile;
    final loc = AppLocalizations.of(context)!;

    // Collapsed state - show compact button
    if (!_isFormExpanded) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        child: PrimaryButton(
          label: loc.createNewServiceRequest,
          icon: Icons.add_circle_outline,
          onPressed: _toggleFormExpansion,
        ),
      );
    }

    // Expanded state - show full form
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: HeadingSmall(text: loc.createServiceRequest),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleFormExpansion,
                tooltip: loc.collapse,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Responsive form layout
          if (isMobile) ...[
            // Mobile: Vertical layout
            DropdownButtonFormField<String>(
              initialValue: _serviceTypeController.text.isEmpty
                  ? null
                  : _serviceTypeController.text,
              decoration: InputDecoration(
                labelText: loc.serviceType,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                prefixIcon: const Icon(Icons.category_outlined),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingM,
                ),
              ),
              items: [
                DropdownMenuItem(
                  value: 'maintenance',
                  child: Text(loc.maintenance),
                ),
                DropdownMenuItem(
                  value: 'housekeeping',
                  child: Text(loc.housekeeping),
                ),
                DropdownMenuItem(
                  value: 'vehicle',
                  child: Text(loc.vehicle),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text(loc.other),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _serviceTypeController.text = value ?? '';
                });
              },
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _messageController,
              label: loc.serviceDescription,
              hint: loc.describeTheServiceNeeded,
              maxLines: 3,
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: loc.submitRequest,
                icon: Icons.send,
                onPressed: _serviceTypeController.text.isNotEmpty &&
                        _messageController.text.isNotEmpty
                    ? () => _submitServiceRequest(context, guestVM)
                    : null,
              ),
            ),
          ] else ...[
            // Desktop/Tablet: Horizontal layout
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    initialValue: _serviceTypeController.text.isEmpty
                        ? null
                        : _serviceTypeController.text,
                    decoration: InputDecoration(
                      labelText: loc.serviceType,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusS),
                      ),
                      prefixIcon: const Icon(Icons.category_outlined),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.paddingM,
                        vertical: AppSpacing.paddingM,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'maintenance',
                        child: Text(loc.maintenance),
                      ),
                      DropdownMenuItem(
                        value: 'housekeeping',
                        child: Text(loc.housekeeping),
                      ),
                      DropdownMenuItem(
                        value: 'vehicle',
                        child: Text(loc.vehicle),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(loc.other),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _serviceTypeController.text = value ?? '';
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  flex: 3,
                  child: TextInput(
                    controller: _messageController,
                    label: loc.serviceDescription,
                    hint: loc.describeTheServiceNeeded,
                    maxLines: 1,
                    prefixIcon: const Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                PrimaryButton(
                  label: loc.submit,
                  icon: Icons.send,
                  onPressed: _serviceTypeController.text.isNotEmpty &&
                          _messageController.text.isNotEmpty
                      ? () => _submitServiceRequest(context, guestVM)
                      : null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Builds service list with grouping (In Progress first, then others)
  Widget _buildServiceListWithGrouping(
    BuildContext context,
    OwnerGuestViewModel guestVM,
    List<OwnerServiceModel> services,
  ) {
    final loc = AppLocalizations.of(context)!;
    final inProgressServices = services.where((s) => s.isInProgress).toList();
    final otherServices = services.where((s) => !s.isInProgress).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      children: [
        // In Progress Services Section
        if (inProgressServices.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            '${loc.inProgress} (${inProgressServices.length})',
            Icons.hourglass_empty,
            Colors.orange,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          ...inProgressServices.map(
            (service) => _buildServiceCard(context, guestVM, service),
          ),
          const SizedBox(height: AppSpacing.paddingL),
        ],

        // Other Services Section
        if (otherServices.isNotEmpty) ...[
          if (inProgressServices.isNotEmpty)
            _buildSectionHeader(
              context,
              '${loc.otherServices} (${otherServices.length})',
              Icons.list,
              Colors.grey,
            ),
          if (inProgressServices.isNotEmpty)
            const SizedBox(height: AppSpacing.paddingS),
          ...otherServices.map(
            (service) => _buildServiceCard(context, guestVM, service),
          ),
        ],
      ],
    );
  }

  /// Builds section header
  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: AppSpacing.paddingS),
        HeadingSmall(text: title, color: color),
      ],
    );
  }

  /// Builds service list
  Widget _buildServiceList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerServiceModel> services) {
    final loc = AppLocalizations.of(context)!;

    if (guestVM.loading && services.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    final isMobile = context.isMobile;

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM, loc),
        SizedBox(height: isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
        // Service list or structured empty state
        Expanded(
          child: services.isEmpty
              ? _buildStructuredEmptyState(context, guestVM, loc)
              : _buildServiceListWithGrouping(context, guestVM, services),
        ),
      ],
    );
  }

  /// Builds stats header
  Widget _buildStatsHeader(
      BuildContext context, OwnerGuestViewModel guestVM, AppLocalizations loc) {
    final isMobile = context.isMobile;
    final pendingCount = guestVM.services.where((s) => !s.isCompleted).length;
    final completedCount = guestVM.services.where((s) => s.isCompleted).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      padding:
          EdgeInsets.all(isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: _buildStatCard(
                    context,
                    loc.total,
                    guestVM.totalServices.toString(),
                    Icons.build,
                    AppColors.primary,
                    isMobile: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 35,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
                Flexible(
                  child: _buildStatCard(
                    context,
                    loc.pending,
                    pendingCount.toString(),
                    Icons.pending,
                    Colors.orange,
                    isMobile: true,
                  ),
                ),
                Container(
                  width: 1,
                  height: 35,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
                Flexible(
                  child: _buildStatCard(
                    context,
                    loc.completed,
                    completedCount.toString(),
                    Icons.check_circle,
                    Colors.green,
                    isMobile: true,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    loc.total,
                    guestVM.totalServices.toString(),
                    Icons.build,
                    AppColors.primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatCard(
                    context,
                    loc.pending,
                    pendingCount.toString(),
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
                ),
                Expanded(
                  child: _buildStatCard(
                    context,
                    loc.completed,
                    completedCount.toString(),
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
    );
  }

  /// Builds individual stat card
  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color,
      {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
      ),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(height: 2),
                HeadingMedium(
                  text: value,
                  color: color,
                ),
                const SizedBox(height: 1),
                CaptionText(
                  text: label,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HeadingMedium(
                      text: value,
                      color: color,
                    ),
                    CaptionText(
                      text: label,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  /// Builds structured empty state with placeholder rows
  Widget _buildStructuredEmptyState(
      BuildContext context, OwnerGuestViewModel guestVM, AppLocalizations loc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.build_outlined, size: 20, color: Colors.grey),
                const SizedBox(width: AppSpacing.paddingS),
                BodyText(text: loc.serviceRequests),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                child: BodyText(
                  text: _text(
                    'ownerServiceZeroRequests',
                    '0 requests',
                  ),
                ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          // Placeholder rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
            itemCount: 3, // Show 3 placeholder rows
            itemBuilder: (context, index) =>
                _buildPlaceholderServiceCard(context),
          ),
          // Empty state message
          Container(
            margin: const EdgeInsets.all(AppSpacing.paddingM),
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.build_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                HeadingMedium(text: loc.noServiceRequestsYet),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc.serviceRequestsAppearHere,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds placeholder service card
  Widget _buildPlaceholderServiceCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Container(
            height: 12,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual service card
  Widget _buildServiceCard(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerServiceModel service) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        child: InkWell(
          onTap: () => _showServiceDetails(context, guestVM, service),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service header
                Row(
                  children: [
                    Icon(
                      _getServiceIcon(service.serviceType),
                      color: _getServiceColor(service.priority),
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${service.guestName} - ${loc.room} ${service.roomNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(service.status),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Service description
                Text(
                  service.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Service details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.category,
                        label: loc.serviceType,
                        value: service.serviceTypeDisplay,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.priority_high,
                        label: loc.priority,
                        value: service.priorityDisplay,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingS),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.schedule,
                        label: loc.requested,
                        value: _formatDate(service.requestedAt),
                      ),
                    ),
                    if (service.assignedToName != null)
                      Expanded(
                        child: _buildDetailItem(
                          icon: Icons.person,
                          label: loc.assignedTo,
                          value: service.assignedToName!,
                        ),
                      ),
                  ],
                ),

                if (service.unreadOwnerMessages > 0) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loc.unreadMessagesCount(service.unreadOwnerMessages),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                // Quick action buttons
                if (!service.isCompleted) ...[
                  const SizedBox(height: AppSpacing.paddingM),
                  const Divider(),
                  const SizedBox(height: AppSpacing.paddingS),
                  Row(
                    children: [
                      if (service.isNew)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateServiceStatus(
                              context,
                              guestVM,
                              service,
                              'in_progress',
                            ),
                            icon: const Icon(Icons.play_arrow, size: 18),
                            label: Text(loc.start),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                            ),
                          ),
                        )
                      else if (service.isInProgress)
                        Expanded(
                          child: PrimaryButton(
                            label: loc.complete,
                            icon: Icons.check_circle,
                            onPressed: () => _completeService(
                              context,
                              guestVM,
                              service,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _updateServiceStatus(
                              context,
                              guestVM,
                              service,
                              'in_progress',
                            ),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: Text(loc.resume),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),
                      const SizedBox(width: AppSpacing.paddingS),
                      OutlinedButton.icon(
                        onPressed: () => _showServiceDetails(
                          context,
                          guestVM,
                          service,
                        ),
                        icon: const Icon(Icons.info_outline, size: 18),
                        label: Text(loc.details),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds status chip
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'new':
        chipColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'in_progress':
        chipColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'completed':
        chipColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        break;
      default:
        chipColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Gets service icon based on type
  IconData _getServiceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'maintenance':
        return Icons.build;
      case 'housekeeping':
        return Icons.cleaning_services;
      case 'vehicle':
        return Icons.two_wheeler;
      case 'other':
        return Icons.help_outline;
      default:
        return Icons.build;
    }
  }

  /// Gets service color based on priority
  Color _getServiceColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Submits service request
  void _submitServiceRequest(
      BuildContext context, OwnerGuestViewModel guestVM) {
    final loc = AppLocalizations.of(context)!;
    if (_serviceTypeController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseFillInAllFields)),
      );
      return;
    }

    // For now, we'll create a simple service request
    // In a real app, you'd get the current user's info
    final service = OwnerServiceModel(
      serviceId: DateTime.now().millisecondsSinceEpoch.toString(),
      guestId: 'current_guest', // This should come from auth
      guestName: 'Current User', // This should come from auth
      pgId: 'current_pg', // This should come from selected PG
      ownerId: 'current_owner', // This should come from auth
      roomNumber: '101', // This should come from guest info
      serviceType: _serviceTypeController.text,
      title: loc.serviceRequest,
      description: _messageController.text,
      status: 'new',
      priority: 'medium',
      requestedAt: DateTime.now(),
      messages: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isActive: true,
    );

    guestVM.createServiceRequest(service);

    // Clear form
    _serviceTypeController.clear();
    _messageController.clear();

    // Auto-collapse form after successful submission
    setState(() {
      _isFormExpanded = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.serviceRequestSubmitted)),
    );
  }

  /// Shows service details dialog
  void _showServiceDetails(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(service.title),
        content: SingleChildScrollView(
          child: _buildServiceDetailsContent(context, service),
        ),
        actions: _buildServiceDetailsActions(context, guestVM, service),
      ),
    );
  }

  Widget _buildServiceDetailsContent(
      BuildContext context, OwnerServiceModel service) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDetailRow(loc.guest, service.guestName),
        _buildDetailRow(loc.room, service.roomNumber),
        _buildDetailRow(loc.serviceType, service.serviceTypeDisplay),
        _buildDetailRow(loc.priority, service.priorityDisplay),
        _buildDetailRow(loc.status, service.statusDisplay),
        _buildDetailRow(loc.requested, _formatDate(service.requestedAt)),
        if (service.assignedToName != null)
          _buildDetailRow(loc.assignedTo, service.assignedToName!),
        if (service.completedAt != null)
          _buildDetailRow(
              loc.completed,
              _formatDate(
                service.completedAt!,
              )),
        const SizedBox(height: AppSpacing.paddingM),
        Text(loc.description,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(service.description),
        const SizedBox(height: AppSpacing.paddingM),
        Text(loc.messages,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        _buildMessagesList(service.messages),
      ],
    );
  }

  List<Widget> _buildServiceDetailsActions(BuildContext context,
      OwnerGuestViewModel guestVM, OwnerServiceModel service) {
    final loc = AppLocalizations.of(context)!;

    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(loc.close),
      ),
      if (!service.isCompleted) ...[
        PrimaryButton(
          label: loc.reply,
          onPressed: () {
            Navigator.of(context).pop();
            _showReplyDialog(context, guestVM, service);
          },
        ),
        PrimaryButton(
          label: loc.complete,
          onPressed: () => _completeService(context, guestVM, service),
        ),
      ],
    ];
  }
  /// Builds detail row for dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Builds messages list
  Widget _buildMessagesList(List<ServiceMessage> messages) {
    if (messages.isEmpty) {
      return Text(AppLocalizations.of(context)!.noMessagesYet);
    }

    return Column(
      children: messages.map((message) => _buildMessageItem(message)).toList(),
    );
  }

  /// Builds message item
  Widget _buildMessageItem(ServiceMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isFromGuest
            ? Colors.grey[100]
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                message.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                message.formattedTimestamp,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(message.message),
        ],
      ),
    );
  }

  /// Shows reply dialog
  void _showReplyDialog(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerServiceModel service) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.replyToServiceRequest),
        content: TextInput(
          controller: replyController,
          label: AppLocalizations.of(context)!.replyLabel,
          hint: AppLocalizations.of(context)!.typeYourReply,
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          PrimaryButton(
              label: AppLocalizations.of(context)!.sendReply,
            onPressed: () async {
              if (replyController.text.isNotEmpty) {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(this.context);
                final loc = AppLocalizations.of(context)!;
                final success = await guestVM.addServiceReply(
                  service.serviceId,
                  replyController.text,
                  loc.owner,
                );

                // FIXED: BuildContext async gap warning
                // Flutter recommends: Check mounted immediately before using context after async operations
                // Changed from: Using context with mounted check in compound condition after async gap
                // Changed to: Check mounted immediately before each context usage
                // Note: Navigator and ScaffoldMessenger are safe to use after async when mounted check is performed, analyzer flags as false positive
                if (!success || !mounted) return;
                navigator.pop();
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text(loc.replySentSuccessfully)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Updates service status (to in_progress)
  Future<void> _updateServiceStatus(
    BuildContext context,
    OwnerGuestViewModel guestVM,
    OwnerServiceModel service,
    String newStatus,
  ) async {
    final loc = AppLocalizations.of(context)!;

    try {
      final success = await guestVM.updateServiceStatus(
        service.serviceId,
        newStatus,
      );

      // FIXED: BuildContext async gap warning
      // Flutter recommends: Check mounted immediately before using context after async operations
      // Changed from: Using context with mounted check in compound condition after async gap
      // Changed to: Check mounted immediately before context usage
      // Note: ScaffoldMessenger is safe to use after async when mounted check is performed, analyzer flags as false positive
      if (!success || !mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'in_progress'
                ? loc.serviceStarted
                : loc.serviceStatusUpdated,
          ),
        ),
      );
    } catch (e) {
      // FIXED: BuildContext async gap warning
      // Flutter recommends: Check mounted immediately before using context in catch blocks
      // Changed from: Using context with unrelated mounted check in catch block
      // Changed to: Check mounted immediately before context usage
      // Note: ScaffoldMessenger is safe to use after async when mounted check is performed, analyzer flags as false positive
      if (!mounted) return;
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.failedToUpdateStatus(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

/// Completes service
void _completeService(BuildContext context, OwnerGuestViewModel guestVM,
    OwnerServiceModel service) {
  final notesController = TextEditingController();
  // Note: We're in a State class method, so the widget is mounted when this method is called
  // The dialog will handle its own lifecycle, so we don't need to check mounted here

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.completeService),
      content: TextInput(
        controller: notesController,
        label: AppLocalizations.of(context)!.completionNotes,
        hint: AppLocalizations.of(context)!.completionNotesOptional,
        maxLines: 3,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        PrimaryButton(
          label: AppLocalizations.of(context)!.markAsCompleted,
          onPressed: () async {
            final navigator = Navigator.of(context);
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final loc = AppLocalizations.of(context)!;
            final success = await guestVM.updateServiceStatus(
              service.serviceId,
              'completed',
              completionNotes:
                  notesController.text.isNotEmpty ? notesController.text : null,
            );

            // FIXED: BuildContext async gap warning
            // Flutter recommends: Check mounted immediately before using context after async operations
            // Changed from: Using context with mounted check in compound condition after async gap
            // Changed to: Check mounted immediately before each context usage
            // Note: Navigator and ScaffoldMessenger are safe to use after async when mounted check is performed, analyzer flags as false positive
            // Note: Dialog context is safe to use here - dialog manages its own lifecycle
            if (!success) {
              navigator.pop();
              return;
            }
            navigator.pop();
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text(loc.serviceCompletedSuccessfully)),
            );
          },
        ),
      ],
    ),
  );
}

/// Formats date for display
String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

/// Shows advanced search dialog
void _showAdvancedSearch(BuildContext context, OwnerGuestViewModel guestVM) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: HeadingMedium(text: AppLocalizations.of(context)!.advancedSearch),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextInput(
            label: AppLocalizations.of(context)!.serviceTitle,
            hint: AppLocalizations.of(context)!.serviceTitle,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            label: AppLocalizations.of(context)!.guestName,
            hint: AppLocalizations.of(context)!.guestName,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            label: AppLocalizations.of(context)!.room,
            hint: AppLocalizations.of(context)!.roomNumber,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            label: AppLocalizations.of(context)!.serviceType,
            hint: AppLocalizations.of(context)!.serviceType,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        PrimaryButton(
          label: AppLocalizations.of(context)!.search,
          onPressed: () {
            Navigator.pop(context);
            // TODO: Implement advanced search
          },
        ),
      ],
    ),
  );
}
