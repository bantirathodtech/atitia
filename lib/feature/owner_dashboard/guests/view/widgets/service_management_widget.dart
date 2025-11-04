// lib/feature/owner_dashboard/guests/view/widgets/service_management_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                  label: 'Search Services',
                  hint: 'Search by title, guest, room, or type...',
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
                tooltip: 'Advanced Search',
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
                _buildFilterChip('All', 'all', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip('New', 'new', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip('In Progress', 'in_progress',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip('Completed', 'completed', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                _buildFilterChip('Urgent', 'urgent', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingM),
                _buildTypeFilterChip('Maintenance', 'maintenance',
                    guestVM.typeFilter, guestVM.setTypeFilter),
                _buildTypeFilterChip('Housekeeping', 'housekeeping',
                    guestVM.typeFilter, guestVM.setTypeFilter),
                _buildTypeFilterChip('Vehicle', 'vehicle', guestVM.typeFilter,
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

    // Collapsed state - show compact button
    if (!_isFormExpanded) {
      return Container(
        margin: EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        child: PrimaryButton(
          label: 'Create New Service Request',
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
              const Expanded(
                child: HeadingSmall(text: 'Create Service Request'),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _toggleFormExpansion,
                tooltip: 'Collapse',
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
                labelText: 'Service Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                prefixIcon: const Icon(Icons.category_outlined),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingM,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'maintenance',
                  child: Text('Maintenance'),
                ),
                DropdownMenuItem(
                  value: 'housekeeping',
                  child: Text('Housekeeping'),
                ),
                DropdownMenuItem(
                  value: 'vehicle',
                  child: Text('Vehicle'),
                ),
                DropdownMenuItem(
                  value: 'other',
                  child: Text('Other'),
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
              label: 'Service Description',
              hint: 'Describe the service needed...',
              maxLines: 3,
              prefixIcon: const Icon(Icons.description_outlined),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'Submit Request',
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
                      labelText: 'Service Type',
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
                    items: const [
                      DropdownMenuItem(
                        value: 'maintenance',
                        child: Text('Maintenance'),
                      ),
                      DropdownMenuItem(
                        value: 'housekeeping',
                        child: Text('Housekeeping'),
                      ),
                      DropdownMenuItem(
                        value: 'vehicle',
                        child: Text('Vehicle'),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text('Other'),
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
                    label: 'Service Description',
                    hint: 'Describe the service needed...',
                    maxLines: 1,
                    prefixIcon: const Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                PrimaryButton(
                  label: 'Submit',
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
    final inProgressServices = services.where((s) => s.isInProgress).toList();
    final otherServices = services.where((s) => !s.isInProgress).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      children: [
        // In Progress Services Section
        if (inProgressServices.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            'In Progress (${inProgressServices.length})',
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
              'Other Services (${otherServices.length})',
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
    if (guestVM.loading && services.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    final isMobile = context.isMobile;

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM),
        SizedBox(height: isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
        // Service list or structured empty state
        Expanded(
          child: services.isEmpty
              ? _buildStructuredEmptyState(context, guestVM)
              : _buildServiceListWithGrouping(context, guestVM, services),
        ),
      ],
    );
  }

  /// Builds stats header
  Widget _buildStatsHeader(BuildContext context, OwnerGuestViewModel guestVM) {
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
                    'Total',
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
                    'Pending',
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
                    'Completed',
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
                    'Total',
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
                    'Pending',
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
                    'Completed',
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
      BuildContext context, OwnerGuestViewModel guestVM) {
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
                const BodyText(text: 'Service Requests'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: const BodyText(text: '0 requests'),
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
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.build_outlined, size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                const HeadingMedium(text: 'No Service Requests Yet'),
                const SizedBox(height: AppSpacing.paddingS),
                const BodyText(
                  text:
                      'Guest service requests will appear here when submitted',
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
        color: Colors.grey.withOpacity(0.05),
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
                            '${service.guestName} - Room ${service.roomNumber}',
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
                        label: 'Type',
                        value: service.serviceTypeDisplay,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.priority_high,
                        label: 'Priority',
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
                        label: 'Requested',
                        value: _formatDate(service.requestedAt),
                      ),
                    ),
                    if (service.assignedToName != null)
                      Expanded(
                        child: _buildDetailItem(
                          icon: Icons.person,
                          label: 'Assigned To',
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
                      '${service.unreadOwnerMessages} unread messages',
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
                            label: const Text('Start'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange,
                              side: const BorderSide(color: Colors.orange),
                            ),
                          ),
                        )
                      else if (service.isInProgress)
                        Expanded(
                          child: PrimaryButton(
                            label: 'Complete',
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
                            label: const Text('Resume'),
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
                        label: const Text('Details'),
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
    if (_serviceTypeController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
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
      title: 'Service Request',
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
      const SnackBar(content: Text('Service request submitted')),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Guest', service.guestName),
              _buildDetailRow('Room', service.roomNumber),
              _buildDetailRow('Type', service.serviceTypeDisplay),
              _buildDetailRow('Priority', service.priorityDisplay),
              _buildDetailRow('Status', service.statusDisplay),
              _buildDetailRow('Requested', _formatDate(service.requestedAt)),
              if (service.assignedToName != null)
                _buildDetailRow('Assigned To', service.assignedToName!),
              if (service.completedAt != null)
                _buildDetailRow('Completed', _formatDate(service.completedAt!)),
              const SizedBox(height: AppSpacing.paddingM),
              const Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(service.description),
              const SizedBox(height: AppSpacing.paddingM),
              const Text('Messages:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              _buildMessagesList(service.messages),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!service.isCompleted) ...[
            PrimaryButton(
              label: 'Reply',
              onPressed: () {
                Navigator.of(context).pop();
                _showReplyDialog(context, guestVM, service);
              },
            ),
            PrimaryButton(
              label: 'Complete',
              onPressed: () => _completeService(context, guestVM, service),
            ),
          ],
        ],
      ),
    );
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
      return const Text('No messages yet');
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
        title: const Text('Reply to Service Request'),
        content: TextInput(
          controller: replyController,
          label: 'Reply',
          hint: 'Type your reply...',
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Send Reply',
            onPressed: () async {
              if (replyController.text.isNotEmpty) {
                final success = await guestVM.addServiceReply(
                  service.serviceId,
                  replyController.text,
                  'Owner',
                );

                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply sent successfully')),
                  );
                }
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
    try {
      final success = await guestVM.updateServiceStatus(
        service.serviceId,
        newStatus,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus == 'in_progress'
                  ? 'Service started'
                  : 'Service status updated',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update status: $e'),
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

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Service'),
        content: TextInput(
          controller: notesController,
          label: 'Completion Notes',
          hint: 'Completion notes (optional)...',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Mark as Completed',
            onPressed: () async {
              final success = await guestVM.updateServiceStatus(
                service.serviceId,
                'completed',
                completionNotes: notesController.text.isNotEmpty
                    ? notesController.text
                    : null,
              );

              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Service completed successfully')),
                );
              }
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
        title: const HeadingMedium(text: 'Advanced Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: 'Service Title',
              hint: 'Service title',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Guest Name',
              hint: 'Guest name',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Room',
              hint: 'Room number',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Service Type',
              hint: 'Service type',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const BodyText(text: 'Cancel'),
          ),
          PrimaryButton(
            label: 'Search',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement advanced search
            },
          ),
        ],
      ),
    );
  }
}
