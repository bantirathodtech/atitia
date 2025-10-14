// lib/feature/owner_dashboard/mypg/presentation/screens/owner_pg_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../viewmodels/owner_pg_management_viewmodel.dart';

/// Unified PG Form Screen for both creating and editing PGs
///
/// Features:
/// - Complete PG information form
/// - Amenities selection
/// - Photo uploads
/// - Floor/room structure configuration
/// - Pricing setup
/// - State/city dropdowns
class OwnerPgFormScreen extends StatefulWidget {
  final String? pgId; // null for create, non-null for edit
  final bool isEditMode;

  const OwnerPgFormScreen({
    super.key,
    this.pgId,
  }) : isEditMode = pgId != null;

  @override
  State<OwnerPgFormScreen> createState() => _OwnerPgFormScreenState();
}

class _OwnerPgFormScreenState extends State<OwnerPgFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Basic Information Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Dropdown values
  String? _selectedState;
  String? _selectedCity;
  List<String> _availableCities = [];

  // Amenities
  final List<String> _availableAmenities = [
    'WiFi',
    'Parking',
    'AC',
    'Non-AC',
    'Laundry',
    'Cleaning',
    'Security',
    'Power Backup',
    'Water Supply',
    'Kitchen',
    'Gym',
    'Garden',
    'Balcony',
    'Lift',
    'CCTV'
  ];
  final List<String> _selectedAmenities = [];

  // Photos
  final List<String> _uploadedPhotos = [];

  // Floor Structure
  final List<Map<String, dynamic>> _floors = [];

  // Pricing
  final _rentController = TextEditingController();
  final _depositController = TextEditingController();
  final _maintenanceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    if (widget.isEditMode) {
      // Pre-fill form with existing PG data
      final vm = context.read<OwnerPgManagementViewModel>();
      _nameController.text = vm.pgName;
      _addressController.text = vm.pgAddress;
      _contactController.text = vm.pgContactNumber;
      _selectedState = vm.pgState;
      _selectedCity = vm.pgCity;
      _selectedAmenities.addAll(vm.pgAmenities.cast<String>());
      _uploadedPhotos.addAll(vm.pgPhotos.cast<String>());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _pincodeController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _rentController.dispose();
    _depositController.dispose();
    _maintenanceController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: widget.isEditMode ? 'Edit PG' : 'List Your PG',
        showThemeToggle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          children: [
            _buildBasicInfoSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildLocationSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildAmenitiesSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildPhotosSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildPricingSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildFloorStructureSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSubmitButton(),
            const SizedBox(height: AppSpacing.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: 'Basic Information'),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _nameController,
              label: 'PG Name',
              hint: 'Enter your PG name',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _addressController,
              label: 'Address',
              hint: 'Complete address',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _contactController,
              label: 'Contact Number',
              hint: 'Your contact number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe your PG',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: 'Location'),
            const SizedBox(height: AppSpacing.paddingM),

            // State Dropdown
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: IndianStatesCities.states.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedCity = null;
                  _availableCities =
                      IndianStatesCities.getCitiesForState(value ?? '');
                });
              },
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // City Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: _availableCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
            ),
            const SizedBox(height: AppSpacing.paddingM),

            TextInput(
              controller: _pincodeController,
              label: 'Pincode',
              hint: 'Enter pincode',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenitiesSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: 'Amenities'),
            const SizedBox(height: AppSpacing.paddingM),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableAmenities.map((amenity) {
                final isSelected = _selectedAmenities.contains(amenity);
                return FilterChip(
                  label: Text(amenity),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedAmenities.add(amenity);
                      } else {
                        _selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: 'Photos'),
            const SizedBox(height: AppSpacing.paddingM),
            if (_uploadedPhotos.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _uploadedPhotos.map((photoUrl) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(photoUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _uploadedPhotos.remove(photoUrl);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],
            SecondaryButton(
              onPressed: _addPhoto,
              label: 'Add Photos',
              icon: Icons.add_photo_alternate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: 'Pricing'),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _rentController,
              label: 'Monthly Rent (₹)',
              hint: 'Enter monthly rent',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _depositController,
              label: 'Security Deposit (₹)',
              hint: 'Enter security deposit',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _maintenanceController,
              label: 'Maintenance Charges (₹)',
              hint: 'Enter maintenance charges',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorStructureSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingSmall(text: 'Floor Structure'),
                SecondaryButton(
                  onPressed: _addFloor,
                  label: 'Add Floor',
                  icon: Icons.add,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            if (_floors.isEmpty)
              const BodyText(
                text: 'No floors added yet. Click "Add Floor" to start.',
                color: Colors.grey,
              )
            else
              ..._floors.asMap().entries.map((entry) {
                final index = entry.key;
                final floor = entry.value;
                return _buildFloorCard(index, floor);
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorCard(int index, Map<String, dynamic> floor) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingSmall(text: 'Floor ${index + 1}'),
              IconButton(
                onPressed: () => _removeFloor(index),
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          TextInput(
            controller: TextEditingController(text: floor['name'] ?? ''),
            label: 'Floor Name',
            hint: 'e.g., Ground Floor, First Floor',
            onChanged: (value) {
              floor['name'] = value;
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          TextInput(
            controller:
                TextEditingController(text: floor['rooms']?.toString() ?? ''),
            label: 'Number of Rooms',
            hint: 'Enter number of rooms',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              floor['rooms'] = int.tryParse(value) ?? 0;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<OwnerPgManagementViewModel>(
      builder: (context, vm, _) {
        return PrimaryButton(
          onPressed: vm.loading ? null : _submitForm,
          label: vm.loading
              ? (widget.isEditMode ? 'Updating...' : 'Creating...')
              : (widget.isEditMode ? 'Update PG' : 'Create PG'),
          icon: widget.isEditMode ? Icons.save : Icons.add_business,
        );
      },
    );
  }

  Future<void> _addPhoto() async {
    try {
      // TODO: Implement image picker and upload
      // For now, just add a placeholder URL
      final imageUrl = 'https://via.placeholder.com/300x200?text=PG+Photo';
      setState(() {
        _uploadedPhotos.add(imageUrl);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add photo: $e')),
      );
    }
  }

  void _addFloor() {
    setState(() {
      _floors.add({
        'name': '',
        'rooms': 0,
        'beds': [],
      });
    });
  }

  void _removeFloor(int index) {
    setState(() {
      _floors.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final ownerId = authProvider.user?.userId ?? '';

    if (ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
      );
      return;
    }

    final vm = context.read<OwnerPgManagementViewModel>();

    final pgData = {
      'pgName': _nameController.text.trim(),
      'address': _addressController.text.trim(),
      'city': _selectedCity ?? '',
      'state': _selectedState ?? '',
      'pincode': _pincodeController.text.trim(),
      'contactNumber': _contactController.text.trim(),
      'description': _descriptionController.text.trim(),
      'amenities': _selectedAmenities,
      'photos': _uploadedPhotos,
      'floorStructure': _floors,
      'rent': double.tryParse(_rentController.text) ?? 0.0,
      'deposit': double.tryParse(_depositController.text) ?? 0.0,
      'maintenance': double.tryParse(_maintenanceController.text) ?? 0.0,
      'ownerUid': ownerId,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    bool success;
    if (widget.isEditMode) {
      success = await vm.updatePGDetails(widget.pgId!, pgData);
    } else {
      success = await vm.createOrUpdatePG(pgData);
    }

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isEditMode
              ? 'PG updated successfully!'
              : 'PG created successfully!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save PG')),
      );
    }
  }
}
