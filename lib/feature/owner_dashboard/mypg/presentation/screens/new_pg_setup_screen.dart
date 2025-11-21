// ============================================================================
// New PG Setup Screen - Premium Responsive Form with MVVM Architecture
// ============================================================================
// Fully responsive and adaptive design with zero-state UI
// Supports all screen sizes: mobile, tablet, desktop, large desktop

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/widgets/containers/section_container.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../data/models/owner_pg_management_model.dart';
import '../../domain/entities/owner_pg_entity.dart';
import '../viewmodels/owner_pg_management_viewmodel.dart';
import '../widgets/forms/pg_basic_info_form_widget.dart';
import '../widgets/forms/pg_floor_structure_form_widget.dart';
import '../widgets/forms/pg_rent_config_form_widget.dart';
import '../widgets/forms/pg_amenities_form_widget.dart';
import '../widgets/forms/pg_photos_form_widget.dart';
import '../widgets/forms/pg_rules_policies_form_widget.dart';
import '../widgets/forms/pg_additional_info_form_widget.dart';
import '../widgets/forms/pg_summary_widget.dart';

/// Premium Responsive PG Setup Screen with MVVM Architecture
/// Handles both CREATE and EDIT modes with adaptive layouts
class NewPgSetupScreen extends StatefulWidget {
  final String? pgId; // null for create, non-null for edit

  const NewPgSetupScreen({
    super.key,
    this.pgId,
  });

  @override
  State<NewPgSetupScreen> createState() => _NewPgSetupScreenState();
}

class _NewPgSetupScreenState extends State<NewPgSetupScreen>
    with SingleTickerProviderStateMixin, ResponsiveSystemMixin {
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

  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  // Separate scroll controllers for each tab to avoid conflicts
  final _basicInfoScrollController = ScrollController();
  final _rentConfigScrollController = ScrollController();
  final _floorStructureScrollController = ScrollController();
  final _amenitiesScrollController = ScrollController();
  final _photosScrollController = ScrollController();
  final _rulesPoliciesScrollController = ScrollController();
  final _additionalInfoScrollController = ScrollController();
  final _summaryScrollController = ScrollController();

  // Form data using existing models
  OwnerPgEntity? _pgEntity;
  List<OwnerFloor> _floors = [];
  List<OwnerRoom> _rooms = [];
  List<OwnerBed> _beds = [];

  // Form controllers
  final _pgNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mapLinkController = TextEditingController();
  final _areaController = TextEditingController();
  final _mealTimingsController = TextEditingController();
  final _foodQualityController = TextEditingController();

  // Rules & Policies controllers
  final _entryTimingsController = TextEditingController();
  final _exitTimingsController = TextEditingController();
  final _guestPolicyController = TextEditingController();
  final _refundPolicyController = TextEditingController();
  final _noticePeriodController = TextEditingController();
  String? _selectedSmokingPolicy;
  String? _selectedAlcoholPolicy;

  // Additional Info controllers
  final _parkingDetailsController = TextEditingController();
  final _securityMeasuresController = TextEditingController();
  final _paymentInstructionsController = TextEditingController();
  final List<String> _nearbyPlaces = [];

  String? _selectedState;
  String? _selectedCity;
  String? _selectedPgType;
  String? _selectedMealType;
  List<String> _selectedAmenities = [];
  List<String> _uploadedPhotos = [];

  // Rent configuration
  final Map<String, TextEditingController> _rentControllers = {
    '1-share': TextEditingController(),
    '2-share': TextEditingController(),
    '3-share': TextEditingController(),
    '4-share': TextEditingController(),
    '5-share': TextEditingController(),
  };
  final _depositController = TextEditingController();
  String _maintenanceType = 'one_time';
  final _maintenanceAmountController = TextEditingController();

  // Mode detection
  bool get isEditMode => widget.pgId != null;

  // Form completion stats
  Map<String, bool> get _completionStats => {
        'basic_info': _pgNameController.text.isNotEmpty &&
            _addressController.text.isNotEmpty &&
            _selectedState != null &&
            _selectedCity != null,
        'rent_config': _rentControllers.values
            .any((c) => c.text.isNotEmpty && double.tryParse(c.text) != null),
        'floor_structure': _floors.isNotEmpty,
        'amenities': _selectedAmenities.isNotEmpty,
        'photos': _uploadedPhotos.isNotEmpty,
      };

  int get _completedSections => _completionStats.values.where((v) => v).length;
  int get _totalSections => _completionStats.length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _tabController.addListener(_onTabChanged);
    if (isEditMode) {
      _loadPgForEdit();
    } else {
      _loadLatestDraftIfAny();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _basicInfoScrollController.dispose();
    _rentConfigScrollController.dispose();
    _floorStructureScrollController.dispose();
    _amenitiesScrollController.dispose();
    _photosScrollController.dispose();
    _rulesPoliciesScrollController.dispose();
    _additionalInfoScrollController.dispose();
    _summaryScrollController.dispose();
    _pgNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _mapLinkController.dispose();
    _depositController.dispose();
    _maintenanceAmountController.dispose();
    _rentControllers.forEach((key, controller) => controller.dispose());
    _mealTimingsController.dispose();
    _foodQualityController.dispose();
    _entryTimingsController.dispose();
    _exitTimingsController.dispose();
    _guestPolicyController.dispose();
    _refundPolicyController.dispose();
    _noticePeriodController.dispose();
    _parkingDetailsController.dispose();
    _securityMeasuresController.dispose();
    _paymentInstructionsController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {}); // Refresh to update completion indicators
    }
  }

  Future<void> _loadPgForEdit() async {
    if (widget.pgId == null) return;

    final vm = context.read<OwnerPgManagementViewModel>();
    await vm.initialize(widget.pgId!);

    if (vm.pgDetails != null) {
      _pgEntity = OwnerPgEntity.fromMap(vm.pgDetails!);
      _populateFormFromEntity();
    }
  }

  void _populateFormFromEntity() {
    if (_pgEntity == null) return;

    // Basic Info
    _pgNameController.text = _pgEntity!.name;
    _addressController.text = _pgEntity!.address;
    _contactController.text = _pgEntity!.contactNumber;
    _descriptionController.text =
        ''; // Description field - keeping empty as it's not in entity
    _mapLinkController.text = _pgEntity!.googleMapLink ?? '';
    _areaController.text = _pgEntity!.area ?? '';

    // PG Type and Meal Type
    _selectedPgType = _pgEntity!.pgType.isNotEmpty ? _pgEntity!.pgType : null;
    _selectedMealType = _pgEntity!.mealType;

    // State and City - ensure values exist in available options
    _selectedState = _pgEntity!.state.isNotEmpty &&
            IndianStatesCities.states.contains(_pgEntity!.state)
        ? _pgEntity!.state
        : null;

    if (_selectedState != null && _pgEntity!.city.isNotEmpty) {
      final availableCities =
          IndianStatesCities.getCitiesForState(_selectedState!);
      _selectedCity =
          availableCities.contains(_pgEntity!.city) ? _pgEntity!.city : null;
    } else {
      _selectedCity = null;
    }
    _selectedAmenities = List.from(_pgEntity!.amenities);

    // Load photos - ensure it's a list and filter out empty values
    final photosFromEntity = _pgEntity!.photos;
    _uploadedPhotos = photosFromEntity
        .where((photo) => photo.trim().isNotEmpty)
        .map((photo) => photo.trim())
        .toList();

    debugPrint(
        '[POPULATE_FORM] Loaded ${_uploadedPhotos.length} photos from entity');
    if (_uploadedPhotos.isNotEmpty) {
      debugPrint('[POPULATE_FORM] First photo: ${_uploadedPhotos.first}');
    }

    // Rent Configuration
    final rentConfig = _pgEntity!.rentConfig;
    if (rentConfig.isNotEmpty) {
      final oneShare = (rentConfig['oneShare'] ?? 0.0).toDouble();
      final twoShare = (rentConfig['twoShare'] ?? 0.0).toDouble();
      final threeShare = (rentConfig['threeShare'] ?? 0.0).toDouble();
      final fourShare = (rentConfig['fourShare'] ?? 0.0).toDouble();
      final fiveShare = (rentConfig['fiveShare'] ?? 0.0).toDouble();

      _rentControllers['1-share']?.text =
          oneShare > 0 ? oneShare.toStringAsFixed(0) : '';
      _rentControllers['2-share']?.text =
          twoShare > 0 ? twoShare.toStringAsFixed(0) : '';
      _rentControllers['3-share']?.text =
          threeShare > 0 ? threeShare.toStringAsFixed(0) : '';
      _rentControllers['4-share']?.text =
          fourShare > 0 ? fourShare.toStringAsFixed(0) : '';
      _rentControllers['5-share']?.text =
          fiveShare > 0 ? fiveShare.toStringAsFixed(0) : '';
    }
    _depositController.text = _pgEntity!.depositAmount > 0
        ? _pgEntity!.depositAmount.toStringAsFixed(0)
        : '';
    _maintenanceType = _pgEntity!.maintenanceType;
    _maintenanceAmountController.text = _pgEntity!.maintenanceAmount > 0
        ? _pgEntity!.maintenanceAmount.toStringAsFixed(0)
        : '';

    // Parse floor structure
    _parseFloorStructure(_pgEntity!.floorStructure);

    // Load new fields
    _mealTimingsController.text = _pgEntity!.mealTimings ?? '';
    _foodQualityController.text = _pgEntity!.foodQuality ?? '';

    // Load Rules & Policies
    if (_pgEntity!.rules != null) {
      _entryTimingsController.text =
          _pgEntity!.rules!['entryTimings']?.toString() ?? '';
      _exitTimingsController.text =
          _pgEntity!.rules!['exitTimings']?.toString() ?? '';
      _guestPolicyController.text =
          _pgEntity!.rules!['guestPolicy']?.toString() ?? '';
      _refundPolicyController.text =
          _pgEntity!.rules!['refundPolicy']?.toString() ?? '';
      _noticePeriodController.text =
          _pgEntity!.rules!['noticePeriod']?.toString() ?? '';
      _selectedSmokingPolicy = _pgEntity!.rules!['smokingPolicy']?.toString();
      _selectedAlcoholPolicy = _pgEntity!.rules!['alcoholPolicy']?.toString();
    }

    // Load Additional Info
    _parkingDetailsController.text = _pgEntity!.parkingDetails ?? '';
    _securityMeasuresController.text = _pgEntity!.securityMeasures ?? '';
    _paymentInstructionsController.text = _pgEntity!.paymentInstructions ?? '';
    if (_pgEntity!.nearbyPlaces != null) {
      _nearbyPlaces.clear();
      _nearbyPlaces.addAll(_pgEntity!.nearbyPlaces!);
    }

    setState(() {});
  }

  Future<void> _loadLatestDraftIfAny() async {
    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    if (ownerId.isEmpty) return;

    final vm = context.read<OwnerPgManagementViewModel>();
    final draft = await vm.fetchLatestDraftForOwner(ownerId);
    if (draft == null) return;

    // Normalize draft data: handle backward compatibility for old field names
    final normalizedDraft = Map<String, dynamic>.from(draft);

    // Debug: Log raw draft data
    debugPrint(
        '[DRAFT_RESTORE] Raw draft keys: ${normalizedDraft.keys.toList()}');
    debugPrint(
        '[DRAFT_RESTORE] Raw photos field type: ${normalizedDraft['photos'].runtimeType}');
    debugPrint(
        '[DRAFT_RESTORE] Raw photos value: ${normalizedDraft['photos']}');

    // Handle old field name: rentConfiguration -> rentConfig
    if (normalizedDraft.containsKey('rentConfiguration') &&
        !normalizedDraft.containsKey('rentConfig')) {
      normalizedDraft['rentConfig'] = normalizedDraft['rentConfiguration'];
    }

    // Handle old field name: deposit -> depositAmount
    if (normalizedDraft.containsKey('deposit') &&
        !normalizedDraft.containsKey('depositAmount')) {
      normalizedDraft['depositAmount'] = normalizedDraft['deposit'];
    }

    // Ensure photos field exists and is a list
    if (!normalizedDraft.containsKey('photos') ||
        normalizedDraft['photos'] == null) {
      debugPrint(
          '[DRAFT_RESTORE] Photos field missing or null, initializing as empty list');
      normalizedDraft['photos'] = <String>[];
    } else if (normalizedDraft['photos'] is! List) {
      // Convert to List if it's not already
      debugPrint('[DRAFT_RESTORE] Photos field is not a List, converting');
      normalizedDraft['photos'] = <String>[];
    } else {
      // Ensure photos list contains only strings
      final photosList = normalizedDraft['photos'] as List;
      debugPrint(
          '[DRAFT_RESTORE] Photos list length before cleaning: ${photosList.length}');
      normalizedDraft['photos'] = photosList
          .where((p) => p != null && p.toString().trim().isNotEmpty)
          .map((p) => p.toString().trim())
          .toList();
      debugPrint(
          '[DRAFT_RESTORE] Photos list length after cleaning: ${normalizedDraft['photos'].length}');
    }

    // Map to entity-like fields used by form
    try {
      // Debug before creating entity
      debugPrint(
          '[DRAFT_RESTORE] Creating entity from draft, photos in normalizedDraft: ${normalizedDraft['photos']}');
      debugPrint(
          '[DRAFT_RESTORE] Photos type: ${normalizedDraft['photos'].runtimeType}');
      debugPrint(
          '[DRAFT_RESTORE] Photos length: ${(normalizedDraft['photos'] as List).length}');

      _pgEntity = OwnerPgEntity.fromMap(normalizedDraft);

      // Debug after creating entity
      if (_pgEntity != null) {
        debugPrint(
            '[DRAFT_RESTORE] Entity created, entity.photos length: ${_pgEntity!.photos.length}');
        debugPrint('[DRAFT_RESTORE] Entity.photos: ${_pgEntity!.photos}');
      }

      _populateFormFromEntity();

      // Debug: Log photos restoration
      debugPrint(
          '[DRAFT_RESTORE] Restored photos: ${_uploadedPhotos.length} photos');
      if (_uploadedPhotos.isNotEmpty) {
        debugPrint('[DRAFT_RESTORE] First photo URL: ${_uploadedPhotos.first}');
      }

      // If draft has pgId, set widget.pgId? No: stay in create mode but allow updates via createOrUpdatePG using map
      setState(() {});
      debugPrint(
          '[DRAFT_RESTORE] Restored latest draft ${normalizedDraft['pgId'] ?? normalizedDraft['id']}');
    } catch (e, stackTrace) {
      debugPrint('[DRAFT_RESTORE][ERROR] $e');
      debugPrint('[DRAFT_RESTORE][ERROR] Stack trace: $stackTrace');
      debugPrint(
          '[DRAFT_RESTORE][ERROR] Draft data keys: ${normalizedDraft.keys.toList()}');
      debugPrint(
          '[DRAFT_RESTORE][ERROR] Photos in draft: ${normalizedDraft['photos']}');
      debugPrint(
          '[DRAFT_RESTORE][ERROR] Photos type: ${normalizedDraft['photos']?.runtimeType}');
    }
  }

  void _parseFloorStructure(List<dynamic> floorStructure) {
    _floors.clear();
    _rooms.clear();
    _beds.clear();

    for (final floorData in floorStructure) {
      final floor = OwnerFloor(
        id: floorData['floorId'] ?? '',
        floorName: floorData['floorName'] ?? '',
        floorNumber: floorData['floorNumber'] ?? 0,
        totalRooms: (floorData['rooms'] as List).length,
      );
      _floors.add(floor);

      for (final roomData in floorData['rooms'] ?? []) {
        final room = OwnerRoom(
          id: roomData['roomId'] ?? '',
          floorId: floor.id,
          roomNumber: roomData['roomNumber'] ?? '',
          capacity: roomData['bedsCount'] ?? 1,
          rentPerBed: (roomData['pricePerBed'] ?? 0).toDouble(),
        );
        _rooms.add(room);

        for (final bedData in roomData['beds'] ?? []) {
          final bed = OwnerBed(
            id: bedData['bedId'] ?? '',
            roomId: room.id,
            floorId: floor.id,
            bedNumber: bedData['bedNumber'] ?? '',
            status: bedData['status'] ?? 'vacant',
          );
          _beds.add(bed);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: isEditMode
            ? (AppLocalizations.of(context)?.editPg ?? 'Edit PG')
            : (AppLocalizations.of(context)?.newPgSetup ?? 'New PG Setup'),
        showThemeToggle: true,
        actions: [
          // Progress indicator
          if (!responsive.isMobile)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
              child: Center(
                child: _buildProgressIndicator(context),
              ),
            ),
          IconButton(
            icon: Icon(
              isEditMode ? Icons.save : Icons.add_business,
            ),
            onPressed: _submitForm,
            tooltip: isEditMode
                ? (AppLocalizations.of(context)?.updatePg ??
                    _text('updatePg', 'Update PG'))
                : (AppLocalizations.of(context)?.createPg ??
                    _text('createPg', 'Create PG')),
          ),
        ],
      ),
      body: Consumer<OwnerPgManagementViewModel>(
        builder: (context, vm, child) {
          if (vm.loading && isEditMode && _pgEntity == null) {
            return _buildLoadingState(context, responsive);
          }

          return Column(
            children: [
              // Responsive Tab Bar
              _buildResponsiveTabBar(context, responsive),

              // Tab Content with responsive padding
              Expanded(
                child: Container(
                  constraints: responsive.isDesktop
                      ? BoxConstraints(maxWidth: responsive.maxWidth)
                      : null,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildBasicInfoTab(responsive),
                          _buildRentConfigTab(responsive),
                          _buildFloorStructureTab(responsive),
                          _buildAmenitiesTab(responsive),
                          _buildPhotosTab(responsive),
                          _buildRulesPoliciesTab(responsive),
                          _buildAdditionalInfoTab(responsive),
                          _buildSummaryTab(responsive),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Action Bar (responsive)
              _buildBottomActionBar(vm, responsive),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ResponsiveConfig responsive) {
    return Center(
      child: Container(
        constraints: responsive.isDesktop
            ? BoxConstraints(maxWidth: responsive.maxWidth)
            : null,
        padding: responsivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingL),
            BodyText(
              text: AppLocalizations.of(context)?.ownerPgLoadingDetails ??
                  _text('ownerPgLoadingDetails', 'Loading PG details...'),
              color: Theme.of(context).disabledColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final progress = _completedSections / _totalSections;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: theme.primaryColor,
        ),
        const SizedBox(width: AppSpacing.paddingS),
        CaptionText(
          text: '$_completedSections/$_totalSections',
          color: theme.primaryColor,
        ),
        const SizedBox(width: AppSpacing.paddingS),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.disabledColor.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveTabBar(
      BuildContext context, ResponsiveConfig responsive) {
    final tabs = [
      Tab(
        text: responsive.isMobile
            ? (AppLocalizations.of(context)?.basic ?? 'Basic')
            : (AppLocalizations.of(context)?.basicInfo ?? 'Basic Info'),
        icon: const Icon(Icons.info_outline, size: 18),
      ),
      Tab(
        text: responsive.isMobile
            ? (AppLocalizations.of(context)?.rent ?? 'Rent')
            : (AppLocalizations.of(context)?.rentConfig ?? 'Rent Config'),
        icon: const Icon(Icons.attach_money, size: 18),
      ),
      Tab(
        text: responsive.isMobile
            ? (AppLocalizations.of(context)?.structure ?? 'Structure')
            : (AppLocalizations.of(context)?.floorStructure ??
                'Floor Structure'),
        icon: const Icon(Icons.home_work_outlined, size: 18),
      ),
      Tab(
        text: AppLocalizations.of(context)?.amenities ?? 'Amenities',
        icon: const Icon(Icons.room_service, size: 18),
      ),
      Tab(
        text: AppLocalizations.of(context)?.photos ?? 'Photos',
        icon: const Icon(Icons.photo_library, size: 18),
      ),
      Tab(
        text: responsive.isMobile
            ? (AppLocalizations.of(context)?.rules ?? 'Rules')
            : (AppLocalizations.of(context)?.rulesPolicies ??
                'Rules & Policies'),
        icon: const Icon(Icons.rule, size: 18),
      ),
      Tab(
        text: responsive.isMobile
            ? (AppLocalizations.of(context)?.more ?? 'More')
            : (AppLocalizations.of(context)?.additionalInfo ??
                'Additional Info'),
        icon: const Icon(Icons.info, size: 18),
      ),
      Tab(
        text: AppLocalizations.of(context)?.summary ?? 'Summary',
        icon: const Icon(Icons.preview, size: 18),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: responsive.isMobile,
        tabs: tabs.map((tab) {
          final index = tabs.indexOf(tab);
          final isCompleted = _getTabCompletionStatus(index);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              tab,
              if (isCompleted)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 12,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
            ],
          );
        }).toList(),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).disabledColor,
      ),
    );
  }

  bool _getTabCompletionStatus(int index) {
    switch (index) {
      case 0:
        return _completionStats['basic_info'] ?? false;
      case 1:
        return _completionStats['rent_config'] ?? false;
      case 2:
        return _completionStats['floor_structure'] ?? false;
      case 3:
        return _completionStats['amenities'] ?? false;
      case 4:
        return _completionStats['photos'] ?? false;
      case 5:
        return _completedSections == _totalSections;
      default:
        return false;
    }
  }

  Widget _buildBasicInfoTab(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    final hasData = _pgNameController.text.isNotEmpty ||
        _addressController.text.isNotEmpty ||
        _selectedState != null;

    return SingleChildScrollView(
      controller: _basicInfoScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          // Show zero-state as hint if no data, otherwise show progress
          if (!hasData)
            _buildZeroStateHint(
              icon: Icons.info_outline,
              title: loc?.startBuildingYourPgProfile ??
                  _text('startBuildingYourPgProfile',
                      'Start Building Your PG Profile'),
              message: loc?.ownerPgBasicInfoZeroStateMessage ??
                  _text(
                    'ownerPgBasicInfoZeroStateMessage',
                    'Fill in the basic information about your PG to get started.',
                  ),
              stats: [
                _buildQuickStat(
                  loc?.progress ?? _text('progress', 'Progress'),
                  '$_completedSections/$_totalSections',
                  AppColors.info,
                ),
                _buildQuickStat(
                  loc?.ownerPgQuickStatRequired ??
                      _text('ownerPgQuickStatRequired', 'Required'),
                  '5',
                  AppColors.warning,
                ),
              ],
            )
          else
            _buildProgressHeader(responsive),

          const SizedBox(height: AppSpacing.paddingL),

          // Form always visible
          PgBasicInfoFormWidget(
            pgNameController: _pgNameController,
            addressController: _addressController,
            contactController: _contactController,
            descriptionController: _descriptionController,
            mapLinkController: _mapLinkController,
            areaController: _areaController,
            selectedState: _selectedState,
            selectedCity: _selectedCity,
            selectedPgType: _selectedPgType,
            selectedMealType: _selectedMealType,
            onStateChanged: (state) => setState(() => _selectedState = state),
            onCityChanged: (city) => setState(() => _selectedCity = city),
            onPgTypeChanged: (pgType) =>
                setState(() => _selectedPgType = pgType),
            onMealTypeChanged: (mealType) =>
                setState(() => _selectedMealType = mealType),
            mealTimingsController: _mealTimingsController,
            foodQualityController: _foodQualityController,
          ),
        ],
      ),
    );
  }

  Widget _buildFloorStructureTab(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    final hasData = _floors.isNotEmpty;

    return SingleChildScrollView(
      controller: _floorStructureScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          if (!hasData)
            _buildZeroStateHint(
              icon: Icons.home_work_outlined,
              title: loc?.defineYourPgStructure ??
                  _text('defineYourPgStructure', 'Define Your PG Structure'),
              message: loc?.ownerPgFloorStructureZeroStateMessage ??
                  _text(
                    'ownerPgFloorStructureZeroStateMessage',
                    'Set up the floor structure, rooms, and beds for your PG.',
                  ),
              stats: [
                _buildQuickStat(
                    loc?.ownerPgQuickStatFloors ??
                        _text('ownerPgQuickStatFloors', 'Floors'),
                    '${_floors.length}',
                    AppColors.purple),
                _buildQuickStat(
                    loc?.ownerPgQuickStatRooms ??
                        _text('ownerPgQuickStatRooms', 'Rooms'),
                    '${_rooms.length}',
                    AppColors.accent),
                _buildQuickStat(
                    loc?.ownerPgQuickStatBeds ??
                        _text('ownerPgQuickStatBeds', 'Beds'),
                    '${_beds.length}',
                    AppColors.primary),
              ],
            )
          else
            _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingM),
          // Bed numbering guide
          SectionContainer(
            title: loc?.bedNumberingGuide ??
                _text('bedNumberingGuide', 'Bed Numbering Guide'),
            description: loc?.ownerPgBedNumberingDescription ??
                _text(
                  'ownerPgBedNumberingDescription',
                  'Number beds consistently based on door position so everyone agrees.',
                ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: loc?.ownerPgBedNumberingRule ??
                      _text(
                        'ownerPgBedNumberingRule',
                        'Rule: Stand at the entrance facing inside → left-to-right, front-to-back (door wall to opposite wall).',
                      ),
                ),
                const SizedBox(height: AppSpacing.paddingS),
                HeadingSmall(
                  text: loc?.ownerPgBedLayoutTwoByTwo ??
                      _text('ownerPgBedLayoutTwoByTwo', '2x2 layout'),
                ),
                BodyText(
                  text: loc?.ownerPgBed1NearestLeft ??
                      _text(
                        'ownerPgBed1NearestLeft',
                        'Bed-1: nearest row, left side',
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBed2NearestRight ??
                      _text(
                        'ownerPgBed2NearestRight',
                        'Bed-2: nearest row, right side',
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBed3FarLeft ??
                      _text(
                        'ownerPgBed3FarLeft',
                        'Bed-3: far row, left side',
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBed4FarRight ??
                      _text(
                        'ownerPgBed4FarRight',
                        'Bed-4: far row, right side',
                      ),
                ),
                const SizedBox(height: AppSpacing.paddingS),
                HeadingSmall(
                  text: loc?.ownerPgBedLayoutOneByFour ??
                      _text(
                        'ownerPgBedLayoutOneByFour',
                        '1x4 along a wall (door → last wall)',
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBed1ClosestDoor ??
                      _text(
                        'ownerPgBed1ClosestDoor',
                        'Bed-1: closest to door',
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBedNext(2) ??
                      _text(
                        'ownerPgBedNext',
                        'Bed-{number}: next',
                        parameters: {'number': 2},
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBedNext(3) ??
                      _text(
                        'ownerPgBedNext',
                        'Bed-{number}: next',
                        parameters: {'number': 3},
                      ),
                ),
                BodyText(
                  text: loc?.ownerPgBed4Farthest ??
                      _text(
                        'ownerPgBed4Farthest',
                        'Bed-4: farthest from door',
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PgFloorStructureFormWidget(
            floors: _floors,
            rooms: _rooms,
            beds: _beds,
            onFloorsChanged: (floors) => setState(() => _floors = floors),
            onRoomsChanged: (rooms) => setState(() => _rooms = rooms),
            onBedsChanged: (beds) => setState(() => _beds = beds),
          ),
        ],
      ),
    );
  }

  Widget _buildRentConfigTab(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    final rentCount =
        _rentControllers.values.where((c) => c.text.isNotEmpty).length;
    final hasData = rentCount > 0 || _depositController.text.isNotEmpty;

    return SingleChildScrollView(
      controller: _rentConfigScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          if (!hasData)
            _buildZeroStateHint(
              icon: Icons.attach_money,
              title: loc?.configureRentalPricing ??
                  _text('configureRentalPricing', 'Configure Rental Pricing'),
              message: loc?.ownerPgRentConfigZeroStateMessage ??
                  _text(
                    'ownerPgRentConfigZeroStateMessage',
                    'Set up rent amounts for different sharing types and maintenance charges.',
                  ),
              stats: [
                _buildQuickStat(
                    loc?.ownerPgQuickStatRentTypes ??
                        _text('ownerPgQuickStatRentTypes', 'Rent Types'),
                    '$rentCount/5',
                    AppColors.success),
                _buildQuickStat(
                    loc?.ownerPgQuickStatDeposit ??
                        _text('ownerPgQuickStatDeposit', 'Deposit'),
                    _depositController.text.isEmpty
                        ? (loc?.ownerPgStatusNotSet ??
                            _text('ownerPgStatusNotSet', 'Not Set'))
                        : (loc?.ownerPgStatusSet ??
                            _text('ownerPgStatusSet', 'Set')),
                    AppColors.warning),
              ],
            )
          else
            _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingL),
          PgRentConfigFormWidget(
            rentControllers: _rentControllers,
            depositController: _depositController,
            maintenanceType: _maintenanceType,
            maintenanceAmountController: _maintenanceAmountController,
            onMaintenanceTypeChanged: (type) =>
                setState(() => _maintenanceType = type),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesTab(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    final hasData = _selectedAmenities.isNotEmpty;

    return SingleChildScrollView(
      controller: _amenitiesScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          if (!hasData)
            _buildZeroStateHint(
              icon: Icons.room_service,
              title: loc?.addPgAmenities ??
                  _text('addPgAmenities', 'Add PG Amenities'),
              message: loc?.ownerPgAmenitiesZeroStateMessage ??
                  _text(
                    'ownerPgAmenitiesZeroStateMessage',
                    'Select the amenities your PG offers to help guests find you.',
                  ),
              stats: [
                _buildQuickStat(
                    loc?.ownerPgQuickStatSelected ??
                        _text('ownerPgQuickStatSelected', 'Selected'),
                    '${_selectedAmenities.length}',
                    AppColors.accent),
              ],
            )
          else
            _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingL),
          PgAmenitiesFormWidget(
            selectedAmenities: _selectedAmenities,
            onAmenitiesChanged: (amenities) =>
                setState(() => _selectedAmenities = amenities),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosTab(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    final hasData = _uploadedPhotos.isNotEmpty;

    return SingleChildScrollView(
      controller: _photosScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          if (!hasData)
            _buildZeroStateHint(
              icon: Icons.photo_library_outlined,
              title: loc?.uploadPgPhotos ??
                  _text('uploadPgPhotos', 'Upload PG Photos'),
              message: loc?.ownerPgPhotosZeroStateMessage ??
                  _text(
                    'ownerPgPhotosZeroStateMessage',
                    'Add photos of your PG to showcase it to potential guests.',
                  ),
              stats: [
                _buildQuickStat(loc?.photos ?? _text('photos', 'Photos'),
                    '${_uploadedPhotos.length}', AppColors.secondary),
              ],
            )
          else
            _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingL),
          PgPhotosFormWidget(
            uploadedPhotos: _uploadedPhotos,
            onPhotosChanged: (photos) =>
                setState(() => _uploadedPhotos = photos),
            pgId: widget.pgId,
          ),
        ],
      ),
    );
  }

  Widget _buildRulesPoliciesTab(ResponsiveConfig responsive) {
    return SingleChildScrollView(
      controller: _rulesPoliciesScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingL),
          PgRulesPoliciesFormWidget(
            entryTimingsController: _entryTimingsController,
            exitTimingsController: _exitTimingsController,
            guestPolicyController: _guestPolicyController,
            refundPolicyController: _refundPolicyController,
            noticePeriodController: _noticePeriodController,
            selectedSmokingPolicy: _selectedSmokingPolicy,
            selectedAlcoholPolicy: _selectedAlcoholPolicy,
            onSmokingPolicyChanged: (policy) =>
                setState(() => _selectedSmokingPolicy = policy),
            onAlcoholPolicyChanged: (policy) =>
                setState(() => _selectedAlcoholPolicy = policy),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoTab(ResponsiveConfig responsive) {
    return SingleChildScrollView(
      controller: _additionalInfoScrollController,
      padding: responsivePadding,
      child: Column(
        children: [
          _buildProgressHeader(responsive),
          const SizedBox(height: AppSpacing.paddingL),
          PgAdditionalInfoFormWidget(
            parkingDetailsController: _parkingDetailsController,
            securityMeasuresController: _securityMeasuresController,
            paymentInstructionsController: _paymentInstructionsController,
            nearbyPlaces: _nearbyPlaces,
            onNearbyPlacesChanged: (places) {
              setState(() {
                _nearbyPlaces.clear();
                _nearbyPlaces.addAll(places);
              });
            },
            onAddNearbyPlace: (place) {
              if (!_nearbyPlaces.contains(place)) {
                setState(() => _nearbyPlaces.add(place));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTab(ResponsiveConfig responsive) {
    return SingleChildScrollView(
      controller: _summaryScrollController,
      padding: responsivePadding,
      child: PgSummaryWidget(
        pgName: _pgNameController.text,
        address: _addressController.text,
        city: _selectedCity ?? '',
        state: _selectedState ?? '',
        floors: _floors,
        rooms: _rooms,
        beds: _beds,
        rentControllers: _rentControllers,
        depositAmount: double.tryParse(_depositController.text) ?? 0.0,
        maintenanceType: _maintenanceType,
        maintenanceAmount:
            double.tryParse(_maintenanceAmountController.text) ?? 0.0,
        selectedAmenities: _selectedAmenities,
        uploadedPhotos: _uploadedPhotos,
      ),
    );
  }

  /// Build zero-state hint using reusable InfoCard component
  Widget _buildZeroStateHint({
    required IconData icon,
    required String title,
    required String message,
    required List<Widget> stats,
  }) {
    return Column(
      children: [
        InfoCard(
          title: title,
          description: message,
          icon: icon,
        ),
        if (stats.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.paddingM),
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            alignment: WrapAlignment.center,
            children: stats,
          ),
        ],
      ],
    );
  }

  /// Build quick stat card using reusable AdaptiveCard
  Widget _buildQuickStat(String label, String value, Color color) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingSmall(text: value),
            CaptionText(
                text: label,
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7)),
          ],
        ),
      ),
    );
  }

  /// Build progress header using reusable components
  Widget _buildProgressHeader(ResponsiveConfig responsive) {
    final loc = AppLocalizations.of(context);
    return SectionContainer(
      title: loc?.progress ?? _text('progress', 'Progress'),
      description: loc?.ownerPgProgressDescription(
            _completedSections,
            _totalSections,
          ) ??
          _text(
            'ownerPgProgressDescription',
            '{completed} of {total} sections completed',
            parameters: {
              'completed': _completedSections,
              'total': _totalSections,
            },
          ),
      child: _buildProgressIndicator(context),
    );
  }

  Widget _buildBottomActionBar(
      OwnerPgManagementViewModel vm, ResponsiveConfig responsive) {
    return Container(
      padding: responsivePadding,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Progress indicator for mobile
          if (responsive.isMobile)
            Expanded(
              child: _buildProgressIndicator(context),
            ),
          if (responsive.isMobile) const SizedBox(width: AppSpacing.paddingM),
          // Save Draft
          if (!vm.loading)
            TextButtonWidget(
              onPressed: () {
                _saveDraft();
              },
              text: AppLocalizations.of(context)?.saveDraft ?? 'Save Draft',
            ),
          const SizedBox(width: AppSpacing.paddingM),
          // Publish button visible when minimally valid
          PrimaryButton(
            onPressed: vm.loading ? null : _publishPG,
            label: AppLocalizations.of(context)?.publish ?? 'Publish',
            icon: Icons.publish,
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            flex: responsive.isMobile ? 2 : 1,
            child: PrimaryButton(
              onPressed: vm.loading ? null : _submitForm,
              label: vm.loading
                  ? (isEditMode
                      ? (AppLocalizations.of(context)?.updating ??
                          'Updating...')
                      : (AppLocalizations.of(context)?.creating ??
                          'Creating...'))
                  : (isEditMode
                      ? (AppLocalizations.of(context)?.updatePg ?? 'Update PG')
                      : (AppLocalizations.of(context)?.createPg ??
                          'Create PG')),
              icon: isEditMode ? Icons.save : Icons.add_business,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          TextButtonWidget(
            onPressed: () => Navigator.of(context).pop(),
            text: AppLocalizations.of(context)?.cancel ?? 'Cancel',
          ),
        ],
      ),
    );
  }

  Future<void> _publishPG() async {
    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    if (ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.userNotAuthenticated ??
                'User not authenticated')),
      );
      return;
    }

    // Require minimal publish fields
    if (_pgNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                    ?.pleaseEnterPgNameBeforePublishing ??
                'Please enter PG name before publishing')),
      );
      _tabController.animateTo(0);
      return;
    }

    final vm = context.read<OwnerPgManagementViewModel>();

    final pgData = {
      'name': _pgNameController.text.trim(),
      'pgName': _pgNameController.text.trim(),
      'ownerUid': ownerId,
      'isDraft': false,
      'status': 'published',
      'updatedAt': DateTime.now(),
    };

    bool success;
    if (isEditMode && widget.pgId != null) {
      success = await vm.updatePGDetails(widget.pgId!, pgData);
    } else {
      success = await vm.createOrUpdatePG(pgData);
    }

    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pgPublishedSuccessfully ??
                _text('ownerPgPublishedSuccessfully',
                    'PG published successfully'),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage ??
                _text('ownerPgPublishFailed', 'Failed to publish PG'),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Scroll to first tab if validation fails
      _tabController.animateTo(0);
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.userId ?? '';

    if (ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.userNotAuthenticated ??
                'User not authenticated')),
      );
      return;
    }

    final vm = context.read<OwnerPgManagementViewModel>();

    // Convert to floor structure format
    final floorStructure = _floors.map((floor) {
      final floorRooms =
          _rooms.where((room) => room.floorId == floor.id).toList();
      return {
        'floorId': floor.id,
        'floorNumber': floor.floorNumber,
        'floorName': floor.floorName,
        'rooms': floorRooms.map((room) {
          final roomBeds = _beds.where((bed) => bed.roomId == room.id).toList();
          return {
            'roomId': room.id,
            'roomNumber': room.roomNumber,
            'sharingType': '${room.capacity}-share',
            'bedsCount': room.capacity,
            'pricePerBed': room.rentPerBed ?? 0.0,
            'beds': roomBeds.map((bed) => bed.toMap()).toList(),
          };
        }).toList(),
      };
    }).toList();

    // Validate and clean photos array - ensure all are valid strings
    final cleanedPhotos = _uploadedPhotos
        .where((photo) => photo.trim().isNotEmpty)
        .map((photo) => photo.trim())
        .toList();

    final pgData = {
      'name': _pgNameController.text.trim(),
      'pgName': _pgNameController.text.trim(),
      'address': _addressController.text.trim(),
      'mapLink': _mapLinkController.text.trim(),
      'googleMapLink': _mapLinkController.text.trim(),
      'contactNumber': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'city': _selectedCity ?? '',
      'state': _selectedState ?? '',
      'area': _areaController.text.trim(),
      'pgType': _selectedPgType ?? '',
      'mealType': _selectedMealType,
      'amenities': _selectedAmenities,
      'photos': cleanedPhotos, // Use cleaned photos array
      'floorStructure': floorStructure,
      'rentConfig': {
        'oneShare':
            double.tryParse(_rentControllers['1-share']?.text ?? '0') ?? 0.0,
        'twoShare':
            double.tryParse(_rentControllers['2-share']?.text ?? '0') ?? 0.0,
        'threeShare':
            double.tryParse(_rentControllers['3-share']?.text ?? '0') ?? 0.0,
        'fourShare':
            double.tryParse(_rentControllers['4-share']?.text ?? '0') ?? 0.0,
        'fiveShare':
            double.tryParse(_rentControllers['5-share']?.text ?? '0') ?? 0.0,
      },
      'depositAmount': double.tryParse(_depositController.text) ?? 0.0,
      'maintenanceType': _maintenanceType,
      'maintenanceAmount':
          double.tryParse(_maintenanceAmountController.text) ?? 0.0,
      'ownerUid': ownerId,
      'mealTimings': _mealTimingsController.text.trim().isNotEmpty
          ? _mealTimingsController.text.trim()
          : null,
      'foodQuality': _foodQualityController.text.trim().isNotEmpty
          ? _foodQualityController.text.trim()
          : null,
      'rules': () {
        final rules = <String, dynamic>{};
        if (_entryTimingsController.text.trim().isNotEmpty) {
          rules['entryTimings'] = _entryTimingsController.text.trim();
        }
        if (_exitTimingsController.text.trim().isNotEmpty) {
          rules['exitTimings'] = _exitTimingsController.text.trim();
        }
        if (_guestPolicyController.text.trim().isNotEmpty) {
          rules['guestPolicy'] = _guestPolicyController.text.trim();
        }
        if (_selectedSmokingPolicy != null) {
          rules['smokingPolicy'] = _selectedSmokingPolicy;
        }
        if (_selectedAlcoholPolicy != null) {
          rules['alcoholPolicy'] = _selectedAlcoholPolicy;
        }
        if (_refundPolicyController.text.trim().isNotEmpty) {
          rules['refundPolicy'] = _refundPolicyController.text.trim();
        }
        if (_noticePeriodController.text.trim().isNotEmpty) {
          rules['noticePeriod'] = _noticePeriodController.text.trim();
        }
        return rules.isNotEmpty ? rules : null;
      }(),
      'parkingDetails': _parkingDetailsController.text.trim().isNotEmpty
          ? _parkingDetailsController.text.trim()
          : null,
      'securityMeasures': _securityMeasuresController.text.trim().isNotEmpty
          ? _securityMeasuresController.text.trim()
          : null,
      'paymentInstructions':
          _paymentInstructionsController.text.trim().isNotEmpty
              ? _paymentInstructionsController.text.trim()
              : null,
      'nearbyPlaces': _nearbyPlaces.isNotEmpty ? _nearbyPlaces : null,
      'isDraft': false, // Explicitly set isDraft to false for Create PG
      'status': 'active', // Set status for created PG
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    // Check if there's an existing draft with pgId that we should update instead of creating new
    String? existingDraftId;
    if (!isEditMode && _pgEntity != null && _pgEntity!.id.isNotEmpty) {
      existingDraftId = _pgEntity!.id;
      debugPrint(
          '[CREATE_PG] Found existing draft ID: $existingDraftId, will update instead of create');
    }

    bool success;
    try {
      if (isEditMode) {
        success = await vm.updatePGDetails(widget.pgId!, pgData);
      } else if (existingDraftId != null) {
        // Update existing draft instead of creating new
        debugPrint('[CREATE_PG] Updating existing draft: $existingDraftId');
        success = await vm.updatePGDetails(existingDraftId, pgData);
      } else {
        // Create new PG
        success = await vm.createOrUpdatePG(pgData);
      }
    } catch (e) {
      debugPrint('[CREATE_PG][ERROR] Exception: $e');
      success = false;
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode
              ? 'PG updated successfully!'
              : 'PG created successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      final errorMsg = vm.errorMessage ??
          (isEditMode ? 'Failed to update PG' : 'Failed to create PG');

      // Provide more helpful error message for permission issues
      String userFriendlyError = errorMsg;
      if (errorMsg.toLowerCase().contains('permission') ||
          errorMsg.toLowerCase().contains('insufficient')) {
        userFriendlyError = 'Permission denied. Please check:\n'
            '1. You are logged in with the correct account\n'
            '2. Firestore security rules allow PG creation\n'
            '3. All required fields are filled correctly';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(userFriendlyError),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _saveDraft() async {
    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.userId ?? '';

    debugPrint('[SAVE_DRAFT] Save draft clicked by ownerId=$ownerId');

    if (ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)?.userNotAuthenticated ??
                'User not authenticated')),
      );
      debugPrint('[SAVE_DRAFT][ERROR] User not authenticated');
      return;
    }

    final vm = context.read<OwnerPgManagementViewModel>();

    // Convert to floor structure format (partial allowed)
    final floorStructure = _floors.map((floor) {
      final floorRooms =
          _rooms.where((room) => room.floorId == floor.id).toList();
      return {
        'floorId': floor.id,
        'floorNumber': floor.floorNumber,
        'floorName': floor.floorName,
        'rooms': floorRooms.map((room) {
          final roomBeds = _beds.where((bed) => bed.roomId == room.id).toList();
          return {
            'roomId': room.id,
            'roomNumber': room.roomNumber,
            'sharingType': '${room.capacity}-share',
            'bedsCount': room.capacity,
            'pricePerBed': room.rentPerBed ?? 0.0,
            'beds': roomBeds.map((bed) => bed.toMap()).toList(),
          };
        }).toList(),
      };
    }).toList();

    final now = DateTime.now();

    // Debug: Log photos before saving draft
    debugPrint(
        '[SAVE_DRAFT] Photos before save: ${_uploadedPhotos.length} photos');
    if (_uploadedPhotos.isNotEmpty) {
      debugPrint('[SAVE_DRAFT] First photo URL: ${_uploadedPhotos.first}');
    }

    // Ensure photos is always a List<String> (not null)
    final photosToSave = _uploadedPhotos.isNotEmpty
        ? List<String>.from(_uploadedPhotos)
        : <String>[];

    final pgData = {
      'name': _pgNameController.text.trim(),
      'pgName': _pgNameController.text.trim(),
      'address': _addressController.text.trim(),
      'mapLink': _mapLinkController.text.trim(),
      'googleMapLink': _mapLinkController.text.trim(),
      'contactNumber': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'city': _selectedCity ?? '',
      'state': _selectedState ?? '',
      'area': _areaController.text.trim(),
      'pgType': _selectedPgType ?? '',
      'mealType': _selectedMealType,
      'amenities': _selectedAmenities,
      'photos': photosToSave, // Use explicit list, never null
      'floorStructure': floorStructure,
      'rentConfig': {
        'oneShare':
            double.tryParse(_rentControllers['1-share']?.text ?? '0') ?? 0.0,
        'twoShare':
            double.tryParse(_rentControllers['2-share']?.text ?? '0') ?? 0.0,
        'threeShare':
            double.tryParse(_rentControllers['3-share']?.text ?? '0') ?? 0.0,
        'fourShare':
            double.tryParse(_rentControllers['4-share']?.text ?? '0') ?? 0.0,
        'fiveShare':
            double.tryParse(_rentControllers['5-share']?.text ?? '0') ?? 0.0,
      },
      'depositAmount': double.tryParse(_depositController.text) ?? 0.0,
      'maintenanceType': _maintenanceType,
      'maintenanceAmount':
          double.tryParse(_maintenanceAmountController.text) ?? 0.0,
      'ownerUid': ownerId,
      'mealTimings': _mealTimingsController.text.trim().isNotEmpty
          ? _mealTimingsController.text.trim()
          : null,
      'foodQuality': _foodQualityController.text.trim().isNotEmpty
          ? _foodQualityController.text.trim()
          : null,
      'rules': () {
        final rules = <String, dynamic>{};
        if (_entryTimingsController.text.trim().isNotEmpty) {
          rules['entryTimings'] = _entryTimingsController.text.trim();
        }
        if (_exitTimingsController.text.trim().isNotEmpty) {
          rules['exitTimings'] = _exitTimingsController.text.trim();
        }
        if (_guestPolicyController.text.trim().isNotEmpty) {
          rules['guestPolicy'] = _guestPolicyController.text.trim();
        }
        if (_selectedSmokingPolicy != null) {
          rules['smokingPolicy'] = _selectedSmokingPolicy;
        }
        if (_selectedAlcoholPolicy != null) {
          rules['alcoholPolicy'] = _selectedAlcoholPolicy;
        }
        if (_refundPolicyController.text.trim().isNotEmpty) {
          rules['refundPolicy'] = _refundPolicyController.text.trim();
        }
        if (_noticePeriodController.text.trim().isNotEmpty) {
          rules['noticePeriod'] = _noticePeriodController.text.trim();
        }
        return rules.isNotEmpty ? rules : null;
      }(),
      'parkingDetails': _parkingDetailsController.text.trim().isNotEmpty
          ? _parkingDetailsController.text.trim()
          : null,
      'securityMeasures': _securityMeasuresController.text.trim().isNotEmpty
          ? _securityMeasuresController.text.trim()
          : null,
      'paymentInstructions':
          _paymentInstructionsController.text.trim().isNotEmpty
              ? _paymentInstructionsController.text.trim()
              : null,
      'nearbyPlaces': _nearbyPlaces.isNotEmpty ? _nearbyPlaces : null,
      'status': 'draft',
      'isDraft': true,
      'createdAt': now,
      'updatedAt': now,
    };

    debugPrint('[SAVE_DRAFT] Attempting to save draft: ${pgData.toString()}');

    bool success;
    try {
      if (isEditMode) {
        success = await vm.updatePGDetails(widget.pgId!, pgData);
        debugPrint('[SAVE_DRAFT] updatePGDetails returned $success');
      } else {
        success = await vm.createOrUpdatePG(pgData);
        debugPrint('[SAVE_DRAFT] createOrUpdatePG returned $success');
      }
    } catch (e) {
      debugPrint('[SAVE_DRAFT][ERROR] Exception: $e');
      success = false;
    }

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)?.draftSaved ?? 'Draft saved'),
          backgroundColor: AppColors.success,
        ),
      );
      debugPrint('[SAVE_DRAFT] Draft saved successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ?? 'Failed to save draft'),
          backgroundColor: AppColors.error,
        ),
      );
      debugPrint('[SAVE_DRAFT][ERROR] Save failed: ${vm.errorMessage}');
    }
  }
}
