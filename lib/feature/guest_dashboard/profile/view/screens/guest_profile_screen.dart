// ============================================================================
// Guest Profile Screen - My Profile
// ============================================================================
// Complete profile viewing and editing screen for guest users.
//
// FEATURES:
// - View complete profile information
// - Edit personal details (name, DOB, gender, etc.)
// - Upload/update profile photo
// - Upload/update Aadhaar photo
// - Manage guardian details
// - Theme toggle for comfortable viewing in any lighting
//
// THEME TOGGLE:
// - Automatic theme toggle in app bar (Light/Dark/System)
// - User can switch themes while viewing/editing profile
// - Makes profile editing comfortable in different lighting conditions
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../auth/data/model/user_model.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/user_location_display.dart';
import '../../data/models/guest_profile_model.dart';
import '../../viewmodel/guest_profile_viewmodel.dart';

/// Screen for guests to view and edit their complete profile information
/// Uses GuestProfileViewModel for profile management and file uploads
/// Provides comprehensive profile editing with photo upload capabilities
class GuestProfileScreen extends StatefulWidget {
  const GuestProfileScreen({super.key});

  @override
  State<GuestProfileScreen> createState() => _GuestProfileScreenState();
}

class _GuestProfileScreenState extends State<GuestProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _addressController;
  late TextEditingController _guardianNameController;
  late TextEditingController _guardianPhoneController;

  String _selectedGender = 'Male';
  String _selectedFoodPreference = 'Vegetarian';
  String _selectedMaritalStatus = 'Single';

  File? _selectedProfilePhoto;
  File? _selectedAadhaarPhoto;

  String? _uploadedProfilePhotoUrl;
  String? _uploadedAadhaarPhotoUrl;

  bool _uploadingImage = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Load profile data after frame is built to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGuestProfile();
    });
  }

  /// Initializes text controllers with empty values
  void _initializeControllers() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _dobController = TextEditingController();
    _addressController = TextEditingController();
    _guardianNameController = TextEditingController();
    _guardianPhoneController = TextEditingController();
  }

  /// Loads guest profile data when screen initializes
  /// Uses AuthProvider to get current user ID automatically
  /// Falls back to UserModel data if GuestProfileModel doesn't exist
  Future<void> _loadGuestProfile() async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.userId ?? '';

    if (userId.isEmpty) return;

    final viewModel = context.read<GuestProfileViewModel>();
    await viewModel.loadGuestProfile(userId);

    final guest = viewModel.guest;
    if (guest != null && mounted) {
      // GuestProfileModel exists - populate with full data
      _populateFormFields(guest);
    } else if (authProvider.user != null && mounted) {
      // GuestProfileModel doesn't exist - fallback to UserModel data
      _populateFormFieldsFromUserModel(authProvider.user!);
    }
  }

  /// Populates form fields with existing guest profile data
  void _populateFormFields(GuestProfileModel guest) {
    _fullNameController.text = guest.fullName ?? '';
    _emailController.text = guest.email ?? '';
    _dobController.text = _formatTimestamp(guest.dateOfBirth);
    _addressController.text = guest.address ?? '';
    _guardianNameController.text = guest.guardianName ?? '';
    _guardianPhoneController.text = guest.guardianPhone ?? '';

    _selectedGender = guest.gender ?? 'Male';
    _selectedFoodPreference = guest.foodPreference ?? 'Vegetarian';
    _selectedMaritalStatus = guest.maritalStatus ?? 'Single';

    _uploadedProfilePhotoUrl = guest.profilePhotoUrl;
    _uploadedAadhaarPhotoUrl = guest.aadhaarPhotoUrl;
  }

  /// Populates form fields with basic UserModel data when GuestProfileModel doesn't exist
  /// This ensures the form shows available data even for new users
  void _populateFormFieldsFromUserModel(UserModel user) {
    _fullNameController.text = user.fullName ?? '';
    _emailController.text = user.email ?? '';
    _dobController.text = _formatTimestamp(user.dateOfBirth);

    // Use address from UserModel if available, otherwise empty
    _addressController.text = user.pgAddress ?? '';

    // Set default values for fields not available in UserModel
    _guardianNameController.text = '';
    _guardianPhoneController.text = '';

    _selectedGender = user.gender ?? 'Male';
    _selectedFoodPreference = 'Vegetarian'; // Default value
    _selectedMaritalStatus = 'Single'; // Default value

    _uploadedProfilePhotoUrl = user.profilePhotoUrl;
    _uploadedAadhaarPhotoUrl = user.aadhaarPhotoUrl;
  }

  /// Formats timestamp to readable date string (DD/MM/YYYY)
  String _formatTimestamp(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Parses date string (DD/MM/YYYY) to DateTime
  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      final parts = dateStr.split('/');
      if (parts.length != 3) return null;
      return DateTime(
        int.parse(parts[2]), // year
        int.parse(parts[1]), // month
        int.parse(parts[0]), // day
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculates age from date of birth
  int? _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) return null;
    final today = DateTime.now();
    int age = today.year - dateOfBirth.year;
    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month && today.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Opens date picker for date of birth selection
  Future<void> _selectDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 6570)), // ~18 years
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _dobController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}';
      });
    }
  }

  /// Picks image from gallery for upload
  Future<File?> _pickImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
      return null;
    }
  }

  /// Handles profile photo selection and upload
  Future<void> _onProfilePhotoSelected() async {
    final file = await _pickImage();
    if (file != null && mounted) {
      setState(() => _uploadingImage = true);

      try {
        final authProvider = context.read<AuthProvider>();
        final userId = authProvider.user?.userId ?? '';

        if (userId.isNotEmpty) {
          final viewModel = context.read<GuestProfileViewModel>();
          final fileName =
              'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

          _uploadedProfilePhotoUrl = await viewModel.uploadProfilePhoto(
            userId,
            fileName,
            file,
          );

          _selectedProfilePhoto = file;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile photo: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _uploadingImage = false);
        }
      }
    }
  }

  /// Handles Aadhaar photo selection and upload
  Future<void> _onAadhaarPhotoSelected() async {
    final file = await _pickImage();
    if (file != null && mounted) {
      setState(() => _uploadingImage = true);

      try {
        final authProvider = context.read<AuthProvider>();
        final userId = authProvider.user?.userId ?? '';

        if (userId.isNotEmpty) {
          final viewModel = context.read<GuestProfileViewModel>();
          final fileName =
              'aadhaar_${DateTime.now().millisecondsSinceEpoch}.jpg';

          _uploadedAadhaarPhotoUrl = await viewModel.uploadAadhaarPhoto(
            userId,
            fileName,
            file,
          );

          _selectedAadhaarPhoto = file;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload Aadhaar photo: $e')),
        );
      } finally {
        if (mounted) {
          setState(() => _uploadingImage = false);
        }
      }
    }
  }

  /// Validates form and saves profile data to Firestore
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = context.read<GuestProfileViewModel>();
    final currentGuest = viewModel.guest;

    if (currentGuest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No profile data found')),
      );
      return;
    }

    // Create updated guest profile with form data
    final updatedGuest = GuestProfileModel(
      userId: currentGuest.userId,
      phoneNumber: currentGuest.phoneNumber,
      role: currentGuest.role,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      dateOfBirth:
          _dobController.text.isEmpty ? null : _parseDate(_dobController.text),
      age: _dobController.text.isEmpty
          ? null
          : _calculateAge(_parseDate(_dobController.text)),
      gender: _selectedGender,
      aadhaarNumber: currentGuest.aadhaarNumber,
      aadhaarPhotoUrl: _uploadedAadhaarPhotoUrl ?? currentGuest.aadhaarPhotoUrl,
      profilePhotoUrl: _uploadedProfilePhotoUrl ?? currentGuest.profilePhotoUrl,
      emergencyContact: currentGuest.emergencyContact,
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      guardianName: _guardianNameController.text.trim().isEmpty
          ? null
          : _guardianNameController.text.trim(),
      guardianPhone: _guardianPhoneController.text.trim().isEmpty
          ? null
          : _guardianPhoneController.text.trim(),
      foodPreference: _selectedFoodPreference,
      maritalStatus: _selectedMaritalStatus,
      education: currentGuest.education,
      occupation: currentGuest.occupation,
      organizationName: currentGuest.organizationName,
      organizationAddress: currentGuest.organizationAddress,
      vehicleNo: currentGuest.vehicleNo,
      vehicleName: currentGuest.vehicleName,
      joiningDate: currentGuest.joiningDate,
      deposit: currentGuest.deposit,
      rent: currentGuest.rent,
    );

    final success = await viewModel.updateGuestProfile(updatedGuest);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );

        // Navigate back using GetIt NavigationService
        final navigationService = getIt<NavigationService>();
        navigationService.goBack();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GuestProfileViewModel>();

    return Scaffold(
      // =======================================================================
      // App Bar with Automatic Theme Toggle
      // =======================================================================
      // AdaptiveAppBar provides theme toggle for comfortable profile viewing
      // User can switch Light/Dark/System modes while editing profile
      // =======================================================================
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: false, // No drawer on profile screen
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveProfile(),
            tooltip: 'Save Profile',
          ),
        ],
        showBackButton: true, // Back button to go back
        showThemeToggle: true, // Enable theme toggle
      ),

      body: _buildBody(context, viewModel),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, GuestProfileViewModel viewModel) {
    if (viewModel.loading && viewModel.guest == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading your profile...'),
          ],
        ),
      );
    }

    if (viewModel.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error Loading Profile',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              viewModel.errorMessage ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGuestProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // User Location Display
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: UserLocationDisplay(),
            ),
            // Profile Photos Section
            _buildPhotosSection(context),
            const SizedBox(height: 24),
            // Personal Information Section
            _buildPersonalInfoSection(context),
            const SizedBox(height: 24),
            // Contact & Guardian Section
            _buildContactSection(context),
            const SizedBox(height: 24),
            // Preferences Section
            _buildPreferencesSection(context),
            const SizedBox(height: 32),
            // Save Button
            _buildSaveButton(context, viewModel),
          ],
        ),
      ),
    );
  }

  /// Builds profile and Aadhaar photo upload section
  Widget _buildPhotosSection(BuildContext context) {
    return Column(
      children: [
        Text(
          'Profile Photos',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildPhotoUpload(
              context,
              'Profile Photo',
              _uploadedProfilePhotoUrl,
              _selectedProfilePhoto,
              _onProfilePhotoSelected,
            ),
            _buildPhotoUpload(
              context,
              'Aadhaar Photo',
              _uploadedAadhaarPhotoUrl,
              _selectedAadhaarPhoto,
              _onAadhaarPhotoSelected,
            ),
          ],
        ),
      ],
    );
  }

  /// Builds individual photo upload widget
  Widget _buildPhotoUpload(
    BuildContext context,
    String label,
    String? imageUrl,
    File? selectedFile,
    VoidCallback onTap,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl) as ImageProvider
                  : selectedFile != null
                      ? FileImage(selectedFile)
                      : null,
              child: imageUrl == null && selectedFile == null
                  ? const Icon(Icons.person, size: 40, color: Colors.white)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: _uploadingImage
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.camera_alt),
                onPressed: _uploadingImage ? null : onTap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// Builds personal information form section
  Widget _buildPersonalInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
            hintText: 'Enter your full name',
          ),
          validator: (value) => value == null || value.trim().isEmpty
              ? 'Full name is required'
              : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(),
            hintText: 'your.email@example.com',
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _dobController,
          readOnly: true,
          onTap: _selectDateOfBirth,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            border: const OutlineInputBorder(),
            hintText: 'DD/MM/YYYY',
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDateOfBirth,
            ),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedGender,
          decoration: const InputDecoration(
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedGender = value);
            }
          },
        ),
      ],
    );
  }

  /// Builds contact and guardian information section
  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact & Guardian Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'Current Address',
            border: OutlineInputBorder(),
            hintText: 'Your current residential address',
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _guardianNameController,
          decoration: const InputDecoration(
            labelText: 'Guardian Name',
            border: OutlineInputBorder(),
            hintText: 'Name of your parent or guardian',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _guardianPhoneController,
          decoration: const InputDecoration(
            labelText: 'Guardian Phone',
            border: OutlineInputBorder(),
            hintText: '10-digit phone number',
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null && value.isNotEmpty && value.length != 10) {
              return 'Enter valid 10-digit phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// Builds preferences section
  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedFoodPreference,
          decoration: const InputDecoration(
            labelText: 'Food Preference',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Vegetarian', child: Text('Vegetarian')),
            DropdownMenuItem(
                value: 'Non-Vegetarian', child: Text('Non-Vegetarian')),
            DropdownMenuItem(value: 'Eggetarian', child: Text('Eggetarian')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedFoodPreference = value);
            }
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: _selectedMaritalStatus,
          decoration: const InputDecoration(
            labelText: 'Marital Status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'Single', child: Text('Single')),
            DropdownMenuItem(value: 'Married', child: Text('Married')),
            DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedMaritalStatus = value);
            }
          },
        ),
      ],
    );
  }

  /// Builds save button with loading state
  Widget _buildSaveButton(
      BuildContext context, GuestProfileViewModel viewModel) {
    return ElevatedButton(
      onPressed: viewModel.loading ? null : _saveProfile,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: viewModel.loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text(
              'Save Profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}
