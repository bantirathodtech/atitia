// ============================================================================
// New PG Setup Screen - Smart PG Creation/Edit with MVVM Architecture
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../data/models/owner_pg_management_model.dart';
import '../../domain/entities/owner_pg_entity.dart';
import '../viewmodels/owner_pg_management_viewmodel.dart';
import '../widgets/forms/pg_basic_info_form_widget.dart';
import '../widgets/forms/pg_floor_structure_form_widget.dart';
import '../widgets/forms/pg_rent_config_form_widget.dart';
import '../widgets/forms/pg_amenities_form_widget.dart';
import '../widgets/forms/pg_photos_form_widget.dart';
import '../widgets/forms/pg_summary_widget.dart';

/// Smart PG Setup Screen with MVVM Architecture
/// Handles both CREATE and EDIT modes using existing models and repository
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
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

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

  String? _selectedState;
  String? _selectedCity;
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
  String _maintenanceType = 'one-time';
  final _maintenanceAmountController = TextEditingController();

  // Mode detection
  bool get isEditMode => widget.pgId != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    if (isEditMode) {
      _loadPgForEdit();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _pgNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _mapLinkController.dispose();
    _depositController.dispose();
    _maintenanceAmountController.dispose();
    _rentControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
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

    _pgNameController.text = _pgEntity!.name;
    _addressController.text = _pgEntity!.address;
    _contactController.text = _pgEntity!.contactNumber;
    _descriptionController.text = _pgEntity!.pgType;
    _selectedState = _pgEntity!.state;
    _selectedCity = _pgEntity!.city;
    _selectedAmenities = List.from(_pgEntity!.amenities);
    _uploadedPhotos = List.from(_pgEntity!.photos);

    // Parse floor structure
    _parseFloorStructure(_pgEntity!.floorStructure);

    setState(() {});
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
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: isEditMode ? 'Edit PG' : 'New PG Setup',
        showThemeToggle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
            tooltip: isEditMode ? 'Update PG' : 'Create PG',
          ),
        ],
      ),
      body: Consumer<OwnerPgManagementViewModel>(
        builder: (context, vm, child) {
          if (vm.loading && isEditMode) {
            return const Center(child: AdaptiveLoader());
          }

          return Column(
            children: [
              // Tab Bar
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'Basic Info', icon: Icon(Icons.info_outline)),
                    Tab(text: 'Rent Config', icon: Icon(Icons.attach_money)),
                    Tab(
                        text: 'Floor Structure',
                        icon: Icon(Icons.home_work_outlined)),
                    Tab(text: 'Amenities', icon: Icon(Icons.room_service)),
                    Tab(text: 'Photos', icon: Icon(Icons.photo_library)),
                    Tab(text: 'Summary', icon: Icon(Icons.preview)),
                  ],
                ),
              ),

              // Tab Content
              Expanded(
                child: Form(
                  key: _formKey,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBasicInfoTab(),
                      _buildRentConfigTab(),
                      _buildFloorStructureTab(),
                      _buildAmenitiesTab(),
                      _buildPhotosTab(),
                      _buildSummaryTab(),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              _buildBottomActionBar(vm),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgBasicInfoFormWidget(
        pgNameController: _pgNameController,
        addressController: _addressController,
        contactController: _contactController,
        descriptionController: _descriptionController,
        mapLinkController: _mapLinkController,
        selectedState: _selectedState,
        selectedCity: _selectedCity,
        onStateChanged: (state) => setState(() => _selectedState = state),
        onCityChanged: (city) => setState(() => _selectedCity = city),
      ),
    );
  }

  Widget _buildFloorStructureTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgFloorStructureFormWidget(
        floors: _floors,
        rooms: _rooms,
        beds: _beds,
        onFloorsChanged: (floors) => setState(() => _floors = floors),
        onRoomsChanged: (rooms) => setState(() => _rooms = rooms),
        onBedsChanged: (beds) => setState(() => _beds = beds),
      ),
    );
  }

  Widget _buildRentConfigTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgRentConfigFormWidget(
        rentControllers: _rentControllers,
        depositController: _depositController,
        maintenanceType: _maintenanceType,
        maintenanceAmountController: _maintenanceAmountController,
        onMaintenanceTypeChanged: (type) =>
            setState(() => _maintenanceType = type),
      ),
    );
  }

  Widget _buildAmenitiesTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgAmenitiesFormWidget(
        selectedAmenities: _selectedAmenities,
        onAmenitiesChanged: (amenities) =>
            setState(() => _selectedAmenities = amenities),
      ),
    );
  }

  Widget _buildPhotosTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgPhotosFormWidget(
        uploadedPhotos: _uploadedPhotos,
        onPhotosChanged: (photos) => setState(() => _uploadedPhotos = photos),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: PgSummaryWidget(
        pgName: _pgNameController.text,
        address: _addressController.text,
        city: _selectedCity ?? '',
        state: _selectedState ?? '',
        floors: _floors,
        rooms: _rooms,
        beds: _beds,
        amenities: _selectedAmenities,
        photos: _uploadedPhotos,
        rentControllers: _rentControllers,
        depositAmount: double.tryParse(_depositController.text) ?? 0.0,
        maintenanceType: _maintenanceType,
        maintenanceAmount:
            double.tryParse(_maintenanceAmountController.text) ?? 0.0,
      ),
    );
  }

  Widget _buildBottomActionBar(OwnerPgManagementViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              onPressed: vm.loading ? null : _submitForm,
              label: vm.loading
                  ? (isEditMode ? 'Updating...' : 'Creating...')
                  : (isEditMode ? 'Update PG' : 'Create PG'),
              icon: isEditMode ? Icons.save : Icons.add_business,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
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
        const SnackBar(content: Text('User not authenticated')),
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

    final pgData = {
      'pgName': _pgNameController.text.trim(),
      'address': _addressController.text.trim(),
      'mapLink': _mapLinkController.text.trim(),
      'contactNumber': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'city': _selectedCity ?? '',
      'state': _selectedState ?? '',
      'amenities': _selectedAmenities,
      'photos': _uploadedPhotos,
      'floorStructure': floorStructure,
      'rentConfiguration': {
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
      'deposit': double.tryParse(_depositController.text) ?? 0.0,
      'maintenanceType': _maintenanceType,
      'maintenanceAmount':
          double.tryParse(_maintenanceAmountController.text) ?? 0.0,
      'ownerUid': ownerId,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    bool success;
    if (isEditMode) {
      success = await vm.updatePGDetails(widget.pgId!, pgData);
    } else {
      success = await vm.createOrUpdatePG(pgData);
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditMode
              ? 'PG updated successfully!'
              : 'PG created successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage ??
              (isEditMode ? 'Failed to update PG' : 'Failed to create PG')),
        ),
      );
    }
  }
}
