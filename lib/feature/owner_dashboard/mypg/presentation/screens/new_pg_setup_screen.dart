// lib/feature/owner_dashboard/mypg/presentation/screens/new_pg_setup_screen.dart

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
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../viewmodels/owner_pg_management_viewmodel.dart';

/// 🏠 **NEW PG SETUP SCREEN - SMART AUTOMATION**
///
/// Features:
/// - Complete PG information with automation
/// - Auto-generate floors, rooms, beds based on sharing type
/// - Smart rent calculation and deposit logic
/// - Comprehensive amenities selection
/// - Validation and preview before creation
class NewPgSetupScreen extends StatefulWidget {
  const NewPgSetupScreen({super.key});

  @override
  State<NewPgSetupScreen> createState() => _NewPgSetupScreenState();
}

class _NewPgSetupScreenState extends State<NewPgSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // PG Details Controllers
  final _pgNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _mapLinkController = TextEditingController();
  final _contactController = TextEditingController();
  final _ownerNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Location
  String? _selectedState;
  String? _selectedCity;
  List<String> _availableCities = [];

  // Amenities
  final List<String> _availableAmenities = [
    'WiFi', 'Parking', 'Security', 'CCTV', 'Laundry', 'Kitchen', 'AC', 'Geyser',
    'TV', 'Refrigerator', 'Power Backup', 'Gym', 'Curtains', 'Bucket', 'Water Cooler',
    'Washing Machine', 'Microwave', 'Lift', 'Housekeeping', 'Attached Bathroom', 'RO Water',
    '24x7 Water Supply', 'Bed with Mattress', 'Wardrobe', 'Study Table', 'Chair', 'Fan',
    'Lighting', 'Balcony', 'Common Area', 'Dining Area', 'Induction Stove', 'Cooking Allowed',
    'Fire Extinguisher', 'First Aid Kit', 'Smoke Detector', 'Visitor Parking', 'Intercom', 'Maintenance Staff'
  ];
  final List<String> _selectedAmenities = [];

  // Photos
  final List<String> _uploadedPhotos = [];

  // Rent Configuration
  final _oneShareRentController = TextEditingController();
  final _twoShareRentController = TextEditingController();
  final _threeShareRentController = TextEditingController();
  final _fourShareRentController = TextEditingController();
  final _fiveShareRentController = TextEditingController();
  final _depositController = TextEditingController();

  // Maintenance
  String _maintenanceType = 'one-time'; // 'one-time' or 'monthly'
  final _maintenanceAmountController = TextEditingController();

  // Floor & Room Configuration
  int _totalFloors = 1;
  int _roomsPerFloor = 1;
  String _sharingType = '3-share'; // Default sharing type

  // Generated Structure
  List<FloorData> _generatedFloors = [];
  double _totalRent = 0.0;
  double _totalDeposit = 0.0;
  double _totalMaintenance = 0.0;

  @override
  void initState() {
    super.initState();
    _generateStructure();
  }

  @override
  void dispose() {
    _pgNameController.dispose();
    _addressController.dispose();
    _mapLinkController.dispose();
    _contactController.dispose();
    _ownerNumberController.dispose();
    _descriptionController.dispose();
    _oneShareRentController.dispose();
    _twoShareRentController.dispose();
    _threeShareRentController.dispose();
    _fourShareRentController.dispose();
    _fiveShareRentController.dispose();
    _depositController.dispose();
    _maintenanceAmountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _generateStructure() {
    _generatedFloors.clear();
    
    for (int floor = 0; floor < _totalFloors; floor++) {
      final floorName = floor == 0 ? 'Ground Floor' : 'Floor $floor';
      final floorPrefix = floor == 0 ? 'G' : floor.toString();
      
      final rooms = <RoomData>[];
      for (int room = 1; room <= _roomsPerFloor; room++) {
        final roomNumber = '${floorPrefix}${room.toString().padLeft(2, '0')}';
        final sharingCount = int.parse(_sharingType.split('-')[0]);
        
        final beds = <BedData>[];
        for (int bed = 1; bed <= sharingCount; bed++) {
          beds.add(BedData(
            bedNumber: bed,
            bedId: '${roomNumber}_bed_$bed',
            status: 'vacant',
          ));
        }
        
        final rentPerBed = _getRentForSharingType(sharingCount);
        rooms.add(RoomData(
          roomNumber: roomNumber,
          sharingType: _sharingType,
          beds: beds,
          rentPerBed: rentPerBed,
          totalRent: rentPerBed * sharingCount,
        ));
      }
      
      _generatedFloors.add(FloorData(
        floorNumber: floor,
        floorName: floorName,
        rooms: rooms,
      ));
    }
    
    _calculateTotals();
    setState(() {});
  }

  double _getRentForSharingType(int sharingCount) {
    switch (sharingCount) {
      case 1: return double.tryParse(_oneShareRentController.text) ?? 0.0;
      case 2: return double.tryParse(_twoShareRentController.text) ?? 0.0;
      case 3: return double.tryParse(_threeShareRentController.text) ?? 0.0;
      case 4: return double.tryParse(_fourShareRentController.text) ?? 0.0;
      case 5: return double.tryParse(_fiveShareRentController.text) ?? 0.0;
      default: return 0.0;
    }
  }

  void _calculateTotals() {
    _totalRent = 0.0;
    _totalDeposit = 0.0;
    _totalMaintenance = 0.0;
    
    for (final floor in _generatedFloors) {
      for (final room in floor.rooms) {
        _totalRent += room.totalRent;
      }
    }
    
    _totalDeposit = double.tryParse(_depositController.text) ?? 0.0;
    _totalMaintenance = double.tryParse(_maintenanceAmountController.text) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'New PG Setup',
        showThemeToggle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          children: [
            _buildPgDetailsSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildRentConfigurationSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildFloorRoomConfigurationSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildAmenitiesSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildPhotosSection(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildGeneratedStructurePreview(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildFinancialSummary(),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSubmitButton(),
            const SizedBox(height: AppSpacing.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildPgDetailsSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '🏠 PG Details'),
            const SizedBox(height: AppSpacing.paddingM),
            
            TextInput(
              controller: _pgNameController,
              label: 'PG Name',
              hint: 'e.g., Green Meadows PG',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            TextInput(
              controller: _addressController,
              label: 'Complete Address',
              hint: 'Full address with landmark',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            TextInput(
              controller: _mapLinkController,
              label: 'Google Map Link',
              hint: 'Paste Google Maps share link',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    controller: _contactController,
                    label: 'PG Contact Number',
                    hint: '+91 9876543210',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: TextInput(
                    controller: _ownerNumberController,
                    label: 'Owner Number',
                    hint: '+91 9876543210',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            // State Dropdown
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: const InputDecoration(
                labelText: 'State',
                border: OutlineInputBorder(),
              ),
              items: IndianStatesCities.states.map((state) {
                return DropdownMenuItem(value: state, child: Text(state));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                  _selectedCity = null;
                  _availableCities = IndianStatesCities.getCitiesForState(value ?? '');
                });
              },
              validator: (value) => value == null ? 'State is required' : null,
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
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value;
                });
              },
              validator: (value) => value == null ? 'City is required' : null,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            TextInput(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Describe your PG facilities and features',
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentConfigurationSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '💰 Rent Configuration'),
            const SizedBox(height: AppSpacing.paddingM),
            
            // Sharing Type Selection
            HeadingSmall(text: 'Sharing Type'),
            const SizedBox(height: AppSpacing.paddingS),
            Wrap(
              spacing: 8,
              children: ['1-share', '2-share', '3-share', '4-share', '5-share'].map((type) {
                return ChoiceChip(
                  label: Text(type),
                  selected: _sharingType == type,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _sharingType = type;
                        _generateStructure();
                      });
                    }
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            // Rent per sharing type
            HeadingSmall(text: 'Rent per Bed (₹)'),
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    controller: _oneShareRentController,
                    label: '1-Share',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateStructure(),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: TextInput(
                    controller: _twoShareRentController,
                    label: '2-Share',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateStructure(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    controller: _threeShareRentController,
                    label: '3-Share',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateStructure(),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: TextInput(
                    controller: _fourShareRentController,
                    label: '4-Share',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateStructure(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Expanded(
                  child: TextInput(
                    controller: _fiveShareRentController,
                    label: '5-Share',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _generateStructure(),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: TextInput(
                    controller: _depositController,
                    label: 'Security Deposit',
                    hint: '0',
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _calculateTotals(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            // Maintenance Type
            HeadingSmall(text: 'Maintenance Charges'),
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('One-time (Non-refundable)'),
                    value: 'one-time',
                    groupValue: _maintenanceType,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceType = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Monthly (Add-on)'),
                    value: 'monthly',
                    groupValue: _maintenanceType,
                    onChanged: (value) {
                      setState(() {
                        _maintenanceType = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            TextInput(
              controller: _maintenanceAmountController,
              label: 'Maintenance Amount (₹)',
              hint: '0',
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculateTotals(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorRoomConfigurationSection() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '🏢 Floor & Room Configuration'),
            const SizedBox(height: AppSpacing.paddingM),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(text: 'Total Floors'),
                      const SizedBox(height: AppSpacing.paddingS),
                      DropdownButtonFormField<int>(
                        value: _totalFloors,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(10, (index) => index + 1).map((floor) {
                          return DropdownMenuItem(
                            value: floor,
                            child: Text('$floor Floor${floor > 1 ? 's' : ''}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _totalFloors = value!;
                            _generateStructure();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(text: 'Rooms per Floor'),
                      const SizedBox(height: AppSpacing.paddingS),
                      DropdownButtonFormField<int>(
                        value: _roomsPerFloor,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: List.generate(20, (index) => index + 1).map((room) {
                          return DropdownMenuItem(
                            value: room,
                            child: Text('$room Room${room > 1 ? 's' : ''}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _roomsPerFloor = value!;
                            _generateStructure();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSmall(text: 'Auto-Generation Preview'),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: 'Floors: ${_totalFloors} | Rooms per floor: $_roomsPerFloor | Sharing: $_sharingType',
                    color: AppColors.info,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: 'Total Rooms: ${_totalFloors * _roomsPerFloor} | Total Beds: ${_totalFloors * _roomsPerFloor * int.parse(_sharingType.split('-')[0])}',
                    color: AppColors.info,
                  ),
                ],
              ),
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
            HeadingMedium(text: '🧰 Amenities'),
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
            HeadingMedium(text: '📸 Photos'),
            const SizedBox(height: AppSpacing.paddingM),
            if (_uploadedPhotos.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _uploadedPhotos.map((photoUrl) {
                  return Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
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

  Widget _buildGeneratedStructurePreview() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '🏗️ Generated Structure'),
            const SizedBox(height: AppSpacing.paddingM),
            ..._generatedFloors.map((floor) {
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
                    HeadingSmall(text: floor.floorName),
                    const SizedBox(height: AppSpacing.paddingS),
                    ...floor.rooms.map((room) {
                      return Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.paddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyText(
                              text: 'Room ${room.roomNumber} (${room.sharingType}) - ₹${room.totalRent.toStringAsFixed(0)}/month',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: AppSpacing.paddingM),
                              child: BodyText(
                                text: 'Beds: ${room.beds.map((b) => 'Bed ${b.bedNumber}').join(', ')}',
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: '💰 Financial Summary'),
            const SizedBox(height: AppSpacing.paddingM),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodyText(text: 'Total Monthly Rent:'),
                BodyText(
                  text: '₹${_totalRent.toStringAsFixed(0)}',
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BodyText(text: 'Security Deposit:'),
                BodyText(
                  text: '₹${_totalDeposit.toStringAsFixed(0)}',
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyText(text: 'Maintenance (${_maintenanceType}):'),
                BodyText(
                  text: '₹${_totalMaintenance.toStringAsFixed(0)}',
                  color: AppColors.info,
                ),
              ],
            ),
            const Divider(),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingSmall(text: 'Total Setup Value:'),
                HeadingSmall(
                  text: '₹${(_totalRent + _totalDeposit + _totalMaintenance).toStringAsFixed(0)}',
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSmall(text: 'Deposit Refund Policy'),
                  const SizedBox(height: AppSpacing.paddingS),
                  const BodyText(text: '• Full refund if notice ≥ 30 days'),
                  const BodyText(text: '• 50% refund if notice ≥ 15 days'),
                  const BodyText(text: '• No refund if notice < 15 days'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<OwnerPgManagementViewModel>(
      builder: (context, vm, _) {
        return PrimaryButton(
          onPressed: vm.loading ? null : _submitForm,
          label: vm.loading ? 'Creating PG...' : 'Create PG',
          icon: Icons.add_business,
        );
      },
    );
  }

  Future<void> _addPhoto() async {
    try {
      // TODO: Implement image picker and upload
      final imageUrl = 'https://via.placeholder.com/300x200?text=PG+Photo+${_uploadedPhotos.length + 1}';
      setState(() {
        _uploadedPhotos.add(imageUrl);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add photo: $e')),
      );
    }
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

    // Convert generated structure to floorStructure format
    final floorStructure = _generatedFloors.map((floor) {
      return {
        'floorNumber': floor.floorNumber,
        'floorName': floor.floorName,
        'floorId': 'floor_${floor.floorNumber}',
        'rooms': floor.rooms.map((room) {
          return {
            'roomNumber': room.roomNumber,
            'roomId': '${floor.floorNumber}_${room.roomNumber}',
            'sharingType': room.sharingType,
            'bedsCount': room.beds.length,
            'pricePerBed': room.rentPerBed,
            'totalRent': room.totalRent,
            'beds': room.beds.map((bed) {
              return {
                'bedId': bed.bedId,
                'bedNumber': bed.bedNumber,
                'status': bed.status,
              };
            }).toList(),
          };
        }).toList(),
      };
    }).toList();

    final pgData = {
      'pgName': _pgNameController.text.trim(),
      'address': _addressController.text.trim(),
      'mapLink': _mapLinkController.text.trim(),
      'contactNumber': _contactController.text.trim(),
      'ownerNumber': _ownerNumberController.text.trim(),
      'city': _selectedCity ?? '',
      'state': _selectedState ?? '',
      'description': _descriptionController.text.trim(),
      'amenities': _selectedAmenities,
      'photos': _uploadedPhotos,
      'floorStructure': floorStructure,
      'rentConfiguration': {
        'oneShare': double.tryParse(_oneShareRentController.text) ?? 0.0,
        'twoShare': double.tryParse(_twoShareRentController.text) ?? 0.0,
        'threeShare': double.tryParse(_threeShareRentController.text) ?? 0.0,
        'fourShare': double.tryParse(_fourShareRentController.text) ?? 0.0,
        'fiveShare': double.tryParse(_fiveShareRentController.text) ?? 0.0,
      },
      'deposit': _totalDeposit,
      'maintenanceType': _maintenanceType,
      'maintenanceAmount': _totalMaintenance,
      'totalRent': _totalRent,
      'totalBeds': _generatedFloors.fold(0, (sum, floor) => sum + floor.rooms.fold(0, (roomSum, room) => roomSum + room.beds.length)),
      'totalRooms': _generatedFloors.fold(0, (sum, floor) => sum + floor.rooms.length),
      'ownerUid': ownerId,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    final success = await vm.createOrUpdatePG(pgData);

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PG created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Failed to create PG')),
      );
    }
  }
}

// Data Models
class FloorData {
  final int floorNumber;
  final String floorName;
  final List<RoomData> rooms;

  FloorData({
    required this.floorNumber,
    required this.floorName,
    required this.rooms,
  });
}

class RoomData {
  final String roomNumber;
  final String sharingType;
  final List<BedData> beds;
  final double rentPerBed;
  final double totalRent;

  RoomData({
    required this.roomNumber,
    required this.sharingType,
    required this.beds,
    required this.rentPerBed,
    required this.totalRent,
  });
}

class BedData {
  final int bedNumber;
  final String bedId;
  final String status;

  BedData({
    required this.bedNumber,
    required this.bedId,
    required this.status,
  });
}
