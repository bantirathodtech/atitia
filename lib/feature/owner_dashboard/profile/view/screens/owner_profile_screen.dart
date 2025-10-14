// ============================================================================
// Owner Profile Screen - Manage Owner Profile & Business Info
// ============================================================================
// Complete profile management with theme support for day/night modes.
//
// FEATURES:
// - Personal information editing
// - Business details management
// - State and city selection dropdowns
// - Document uploads (profile, Aadhaar, UPI QR)
// - Theme toggle for comfortable viewing
// - Tab-based organization (Personal, Business, Documents)
//
// THEME SUPPORT:
// - All colors adapt to light/dark mode
// - Dropdowns have theme-aware backgrounds
// - Cards use theme surface colors
// - Text colors adjust for readability
// ============================================================================


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/data/indian_states_cities.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/navigation/app_drawer.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../data/models/owner_profile_model.dart';
import '../../viewmodel/owner_profile_viewmodel.dart';
import '../widgets/owner_payment_details_widget.dart';

/// Production-ready Owner Profile Screen with enhanced UI/UX
/// 
/// Features:
/// - App drawer with about, logout, switch account
/// - Enhanced personal info with state/city dropdowns
/// - Phone number display (read-only)
/// - PG address with state, city, pincode
/// - Business information management
/// - Document uploads with preview
/// - Real-time validation and error feedback
/// - Modern card-based layout
class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Personal Info Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController; // Read-only
  late TextEditingController _pgAddressController;
  late TextEditingController _pincodeController;

  // Business Info Controllers
  late TextEditingController _businessNameController;
  late TextEditingController _businessTypeController;
  late TextEditingController _panNumberController;
  late TextEditingController _gstNumberController;

  // Dropdown values
  String? _selectedState;
  String? _selectedCity;
  List<String> _availableCities = [];

  // Upload tracking
  String? _uploadedProfilePhotoUrl;
  String? _uploadedAadhaarPhotoUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Updated to 4 tabs
    _initializeControllers();
    
    // Load profile data after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOwnerProfile();
    });
  }

  /// Initializes all text controllers
  void _initializeControllers() {
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _pgAddressController = TextEditingController();
    _pincodeController = TextEditingController();
    _businessNameController = TextEditingController();
    _businessTypeController = TextEditingController();
    _panNumberController = TextEditingController();
    _gstNumberController = TextEditingController();
  }

  /// Loads owner profile data
  Future<void> _loadOwnerProfile() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    if (user != null) {
      _populateFormFields(user);
    }

    // Also load from OwnerProfileViewModel if available
    final viewModel = context.read<OwnerProfileViewModel>();
    await viewModel.loadProfile();

    if (viewModel.profile != null && mounted) {
      _populateFromOwnerProfile(viewModel.profile!);
    }
  }

  /// Populates form fields from UserModel
  void _populateFormFields(dynamic user) {
    _fullNameController.text = user.fullName ?? '';
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phoneNumber;
    _pgAddressController.text = user.pgAddress ?? '';
    _pincodeController.text = user.pincode ?? '';

    if (user.state != null) {
      _selectedState = user.state;
      _availableCities = IndianStatesCities.getCitiesForState(user.state!);
    }

    if (user.city != null) {
      _selectedCity = user.city;
    }

    _uploadedProfilePhotoUrl = user.profilePhotoUrl;
    _uploadedAadhaarPhotoUrl = user.aadhaarPhotoUrl;

    setState(() {});
  }

  /// Populates additional fields from OwnerProfile
  void _populateFromOwnerProfile(OwnerProfile profile) {
    _businessNameController.text = profile.businessName ?? '';
    _businessTypeController.text = profile.businessType ?? '';
    _panNumberController.text = profile.panNumber ?? '';
    _gstNumberController.text = profile.gstNumber ?? '';

    setState(() {});
  }

  /// Handles state selection
  void _onStateChanged(String? newState) {
    if (newState == null) return;

    setState(() {
      _selectedState = newState;
      _selectedCity = null; // Reset city when state changes
      _availableCities = IndianStatesCities.getCitiesForState(newState);
    });
  }

  /// Handles city selection
  void _onCityChanged(String? newCity) {
    setState(() {
      _selectedCity = newCity;
    });
  }

  /// Picks image from gallery (web and mobile compatible)
  /// Returns XFile on web, File on mobile
  Future<dynamic> _pickImage() async {
    try {
      final pickedFile = await ImagePickerHelper.pickImageFromGallery(
        imageQuality: 80,
      );
      return pickedFile;
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error picking image: $e', isError: true);
      }
      return null;
    }
  }

  /// Handles profile photo upload
  Future<void> _onProfilePhotoSelected() async {
    final file = await _pickImage();
    if (file != null && mounted) {
      try {
        final authProvider = context.read<AuthProvider>();
        await authProvider.uploadProfilePhoto(file);
        
        if (mounted) {
          setState(() {
            _uploadedProfilePhotoUrl = authProvider.profilePhotoUrl;
          });
          _showSnackBar('Profile photo uploaded successfully');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to upload profile photo: $e', isError: true);
        }
      }
    }
  }

  /// Handles Aadhaar photo upload
  Future<void> _onAadhaarPhotoSelected() async {
    final file = await _pickImage();
    if (file != null && mounted) {
      try {
        final authProvider = context.read<AuthProvider>();
        await authProvider.uploadAadhaarDocument(file);

        if (mounted) {
          setState(() {
            _uploadedAadhaarPhotoUrl = authProvider.aadhaarUrl;
          });
          _showSnackBar('Aadhaar document uploaded successfully');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to upload Aadhaar document: $e', isError: true);
        }
      }
    }
  }

  /// Saves profile data
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fix all errors', isError: true);
      return;
    }

    if (_selectedState == null || _selectedCity == null) {
      _showSnackBar('Please select state and city', isError: true);
      return;
    }

    try {
      final authProvider = context.read<AuthProvider>();

      // Update user profile with address fields
      await authProvider.updateUserProfile(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
      );

      // Update owner-specific fields
      final viewModel = context.read<OwnerProfileViewModel>();
      final updatedData = <String, dynamic>{
        'fullName': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'pgAddress': _pgAddressController.text.trim(),
        'state': _selectedState,
        'city': _selectedCity,
        'pincode': _pincodeController.text.trim(),
        'businessName': _businessNameController.text.trim(),
        'businessType': _businessTypeController.text.trim(),
        'panNumber': _panNumberController.text.trim(),
        'gstNumber': _gstNumberController.text.trim(),
      };

      if (_uploadedProfilePhotoUrl != null) {
        updatedData['profilePhoto'] = _uploadedProfilePhotoUrl!;
      }
      if (_uploadedAadhaarPhotoUrl != null) {
        updatedData['aadhaarPhoto'] = _uploadedAadhaarPhotoUrl!;
      }

      await viewModel.updateProfile(updatedData);

      if (mounted) {
        _showSnackBar('Profile updated successfully');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to update profile: $e', isError: true);
      }
    }
  }

  /// Shows snackbar message with theme-aware colors
  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BodyText(
          text: message, 
          color: AppColors.textOnPrimary,  // White text on colored background
        ),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _pgAddressController.dispose();
    _pincodeController.dispose();
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _panNumberController.dispose();
    _gstNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerProfileViewModel>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'My Profile',
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadOwnerProfile,
            tooltip: 'Refresh Profile',
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _buildBody(context, viewModel, authProvider),
    );
  }

  /// Builds main body content
  Widget _buildBody(
    BuildContext context,
    OwnerProfileViewModel viewModel,
    AuthProvider authProvider,
  ) {
    if (viewModel.loading && viewModel.profile == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            SizedBox(height: AppSpacing.md),
            BodyText(text: 'Loading your profile...'),
          ],
        ),
      );
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: 'Error Loading Profile',
          message: viewModel.errorMessage!,
          actionLabel: 'Try Again',
          onAction: _loadOwnerProfile,
        ),
      );
    }

    final user = authProvider.user;
    if (user == null) {
      return const Center(
        child: EmptyState(
          icon: Icons.person_outline,
          title: 'No Profile Found',
          message: 'Please complete your profile setup',
        ),
      );
    }

    return Column(
      children: [
        // Profile header moved to App Drawer - Access via menu icon
        const SizedBox(height: 16),
        _buildTabBar(),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalInfoTab(),
              _buildBusinessInfoTab(),
              _buildDocumentsTab(),
              const OwnerPaymentDetailsWidget(), // Payment Details Tab
            ],
          ),
        ),
      ],
    );
  }

  /// Builds premium profile header with gradient and shadows
  Widget _buildProfileHeader(dynamic user) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.1),
            primaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : primaryColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.3) : primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // Premium Profile Photo with gradient border
            GestureDetector(
              onTap: _onProfilePhotoSelected,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [primaryColor, primaryColor.withOpacity(0.7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: theme.colorScheme.surface,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: primaryColor,
                        child: _uploadedProfilePhotoUrl != null
                            ? ClipOval(
                                child: AdaptiveImage(
                                  imageUrl: _uploadedProfilePhotoUrl!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : HeadingLarge(
                                text: user.initials,
                                color: AppColors.textOnPrimary,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, primaryColor.withOpacity(0.8)],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.surface,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Enhanced User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name with premium styling
                  HeadingMedium(
                    text: user.displayName,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 8),
                  
                  // Phone with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.phone,
                          size: 14,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(width: 6),
                      BodyText(text: user.phoneNumber, medium: true),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Email with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.email,
                          size: 14,
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: BodyText(
                          text: user.email ?? 'No email',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  
                  // Premium verification badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: user.isVerified
                            ? [AppColors.success.withOpacity(0.2), AppColors.success.withOpacity(0.1)]
                            : [AppColors.warning.withOpacity(0.2), AppColors.warning.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: user.isVerified
                            ? AppColors.success.withOpacity(0.3)
                            : AppColors.warning.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          user.isVerified ? Icons.verified_rounded : Icons.pending_rounded,
                          size: 16,
                          color: user.isVerified ? AppColors.success : AppColors.warning,
                        ),
                        const SizedBox(width: 6),
                        CaptionText(
                          text: user.verificationDisplay,
                          color: user.isVerified ? AppColors.success : AppColors.warning,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds premium tab bar with enhanced styling
  Widget _buildTabBar() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    final surfaceColor = isDarkMode ? AppColors.darkCard : AppColors.surface;
    final textSecondary = isDarkMode ? AppColors.textTertiary : AppColors.textSecondary;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: textSecondary,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(
            text: 'Personal',
            icon: Icon(Icons.person_rounded, size: 20),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Business',
            icon: Icon(Icons.business_rounded, size: 20),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Documents',
            icon: Icon(Icons.file_copy_rounded, size: 20),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
          Tab(
            text: 'Payments',
            icon: Icon(Icons.account_balance_wallet_rounded, size: 20),
            iconMargin: EdgeInsets.only(bottom: 4),
          ),
        ],
      ),
    );
  }

  /// Builds personal info tab with enhanced fields
  Widget _buildPersonalInfoTab() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.primaryColor;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Premium section header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkDivider : primaryColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, primaryColor.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingMedium(
                        text: 'Personal Information',
                        color: primaryColor,
                      ),
                      const SizedBox(height: 2),
                      BodyText(
                        text: 'Manage your personal details',
                        color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Full Name
            _buildTextFormField(
              label: 'Full Name *',
              controller: _fullNameController,
              prefixIcon: Icons.person,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Full name is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Email
            _buildTextFormField(
              label: 'Email Address *',
              controller: _emailController,
              prefixIcon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value!)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Phone Number (Read-only)
            _buildTextFormField(
              label: 'Phone Number',
              controller: _phoneController,
              prefixIcon: Icons.phone,
              enabled: false,
              hint: 'Verified phone number',
            ),
            const SizedBox(height: AppSpacing.xl),

            // PG Address Section Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.info.withOpacity(0.1), AppColors.info.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkDivider : AppColors.info.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.info, AppColors.info.withOpacity(0.8)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.info.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingMedium(
                        text: 'PG Address',
                        color: AppColors.info,
                      ),
                      const SizedBox(height: 2),
                      BodyText(
                        text: 'Your PG location details',
                        color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // PG Address
            _buildTextFormField(
              label: 'PG Address *',
              controller: _pgAddressController,
              prefixIcon: Icons.location_on,
              maxLines: 2,
              hint: 'Enter your PG full address',
              validator: (value) =>
                  value?.isEmpty ?? true ? 'PG address is required' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // State Dropdown
            _buildStateDropdown(),
            const SizedBox(height: AppSpacing.md),

            // City Dropdown
            _buildCityDropdown(),
            const SizedBox(height: AppSpacing.md),

            // Pincode
            _buildTextFormField(
              label: 'Pincode *',
              controller: _pincodeController,
              prefixIcon: Icons.pin_drop,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Pincode is required';
                if (value!.length != 6) return 'Pincode must be 6 digits';
                if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                  return 'Please enter valid pincode';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Save Button
            Consumer<OwnerProfileViewModel>(
              builder: (context, viewModel, child) {
                return PrimaryButton(
                  label: 'Save Personal Info',
                  onPressed: viewModel.loading ? null : _saveProfile,
                  isLoading: viewModel.loading,
                  icon: Icons.save,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds state dropdown with theme-aware colors
  Widget _buildStateDropdown() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;
    
    return DropdownButtonFormField<String>(
      initialValue: _selectedState,
      decoration: InputDecoration(
        labelText: 'State *',
        prefixIcon: const Icon(Icons.map),
        border: const OutlineInputBorder(),
        filled: true,
        // Theme-aware fill and dropdown colors
        fillColor: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
      ),
      dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
      hint: Text('Select State', style: TextStyle(color: textColor.withOpacity(0.6))),
      items: IndianStatesCities.states.map((state) {
        return DropdownMenuItem(
          value: state,
          child: Text(state, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: _onStateChanged,
      validator: (value) => value == null ? 'Please select a state' : null,
    );
  }

  /// Builds city dropdown with theme-aware colors
  Widget _buildCityDropdown() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;
    
    return DropdownButtonFormField<String>(
      initialValue: _selectedCity,
      decoration: InputDecoration(
        labelText: 'City *',
        prefixIcon: const Icon(Icons.location_city),
        border: const OutlineInputBorder(),
        filled: true,
        // Theme-aware fill and dropdown colors
        fillColor: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
      ),
      dropdownColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
      hint: Text(
        _selectedState == null ? 'Select state first' : 'Select City',
        style: TextStyle(color: textColor.withOpacity(0.6)),
      ),
      items: _availableCities.map((city) {
        return DropdownMenuItem(
          value: city,
          child: Text(city, style: TextStyle(color: textColor)),
        );
      }).toList(),
      onChanged: _selectedState == null ? null : _onCityChanged,
      validator: (value) => value == null ? 'Please select a city' : null,
    );
  }

  /// Builds text form field with theme-aware colors
  Widget _buildTextFormField({
    required String label,
    required TextEditingController controller,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? hint,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
        filled: true,
        // Theme-aware fill color based on enabled state
        fillColor: enabled 
            ? (isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant)
            : (isDarkMode ? AppColors.darkCard.withOpacity(0.5) : AppColors.outline.withOpacity(0.1)),
        counterText: maxLength != null ? null : '',
      ),
      validator: validator,
    );
  }

  /// Builds business info tab
  Widget _buildBusinessInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeadingMedium(text: 'Business Information'),
          const SizedBox(height: AppSpacing.md),

          _buildTextFormField(
            label: 'Business Name',
            controller: _businessNameController,
            prefixIcon: Icons.business,
            hint: 'Enter your PG business name',
          ),
          const SizedBox(height: AppSpacing.md),

          _buildTextFormField(
            label: 'Business Type',
            controller: _businessTypeController,
            prefixIcon: Icons.category,
            hint: 'e.g., PG, Hostel, Guest House',
          ),
          const SizedBox(height: AppSpacing.md),

          _buildTextFormField(
            label: 'PAN Number',
            controller: _panNumberController,
            prefixIcon: Icons.credit_card,
            hint: 'ABCDE1234F',
          ),
          const SizedBox(height: AppSpacing.md),

          _buildTextFormField(
            label: 'GST Number',
            controller: _gstNumberController,
            prefixIcon: Icons.receipt,
            hint: '22AAAAA0000A1Z5',
          ),
          const SizedBox(height: AppSpacing.lg),

          Consumer<OwnerProfileViewModel>(
            builder: (context, viewModel, child) {
              return PrimaryButton(
                label: 'Save Business Info',
                onPressed: viewModel.loading ? null : _saveProfile,
                isLoading: viewModel.loading,
                icon: Icons.save,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds documents tab
  Widget _buildDocumentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HeadingMedium(text: 'Documents & Verification'),
          const SizedBox(height: AppSpacing.md),

          Consumer<OwnerProfileViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isUploading) {
                return const Center(
                  child: Column(
                    children: [
                      AdaptiveLoader(),
                      SizedBox(height: AppSpacing.sm),
                      BodyText(text: 'Uploading document...'),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  _buildDocumentCard(
                    'Profile Photo',
                    'Upload your profile picture',
                    _uploadedProfilePhotoUrl,
                    Icons.person,
                    _onProfilePhotoSelected,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildDocumentCard(
                    'Aadhaar Document',
                    'Upload your Aadhaar card for verification',
                    _uploadedAadhaarPhotoUrl,
                    Icons.badge,
                    _onAadhaarPhotoSelected,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds document upload card
  Widget _buildDocumentCard(
    String title,
    String description,
    String? imageUrl,
    IconData icon,
    VoidCallback onUpload,
  ) {
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingSmall(text: title),
                    const SizedBox(height: AppSpacing.xs),
                    CaptionText(text: description),
                  ],
                ),
              ),
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AdaptiveImage(
                imageUrl: imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: hasImage ? 'Change Document' : 'Upload Document',
            onPressed: onUpload,
            icon: hasImage ? Icons.edit : Icons.upload,
          ),
        ],
      ),
    );
  }
}

