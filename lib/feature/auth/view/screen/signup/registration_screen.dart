// ============================================================================
// Registration Screen - Complete Your Profile
// ============================================================================
// Multi-step registration form with beautiful UI/UX and theme toggle support.
//
// FEATURES:
// - 3-step registration: Personal Info → Documents → Emergency Contact
// - Visual progress indicator with step labels
// - Image upload for profile photo and Aadhaar
// - Comprehensive validation with inline error messages
// - Smooth animations between steps
// - Theme toggle in app bar for user convenience
//
// THEME TOGGLE:
// - User can switch between Light/Dark/System modes during registration
// - Theme toggle automatically added via AdaptiveAppBar
// - Makes registration more comfortable for users in different lighting
//
// VALIDATION:
// - Real-time validation as user types
// - Clear error messages for all fields
// - Age calculation from date of birth
// - Phone number format validation
// - Aadhaar number format validation
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/animations/fade_in.dart';
import '../../../../../common/animations/slide_in.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/validation.dart';
import '../../../../../common/utils/date/date_manager.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/upload_card.dart';
import '../../../../../common/widgets/indicators/step_indicator.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../data/model/user_model.dart';
import '../../../logic/auth_provider.dart';

/// World-class registration screen with stunning UI/UX
/// Multi-step form with progress tracking and smooth animations
/// Production-ready with comprehensive validation and user feedback
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // final _formKey = GlobalKey<FormState>();
  // ImagePicker no longer needed - using ImagePickerHelper instead

  // Current step for progress indicator
  int _currentStep = 0;

  // Text controllers
  final _phoneController =
      TextEditingController(); // For displaying verified phone
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _emailController = TextEditingController();
  final _aadhaarNumberController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();
  final _emergencyAddressController = TextEditingController();

  // Field errors
  String? _nameError;
  String? _dobError;
  String? _emailError;
  String? _aadhaarError;
  String? _emergencyNameError;
  String? _emergencyPhoneError;

  String _selectedGender = 'Male';
  bool _phoneNumberInitialized = false; // Flag to initialize phone once

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentStep = _tabController.index;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize phone number from auth provider (only once)
    if (!_phoneNumberInitialized) {
      final authProvider = context.watch<AuthProvider>();
      final phoneNumber = authProvider.user?.phoneNumber;

      // Debug log

      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        _phoneController.text = phoneNumber;
        _phoneNumberInitialized = true;
      } else {}
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _aadhaarNumberController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
    _emergencyAddressController.dispose();
    super.dispose();
  }

  /// Opens date picker
  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _dobController.text = DateManager.formatDisplay(pickedDate);
        _dobError = DateManager.validateDisplay(_dobController.text);
      });
    }
  }

  // ==========================================================================
  // Pick Image from Gallery - Cross-Platform
  // ==========================================================================
  // Uses ImagePickerHelper for proper web compatibility
  // Returns File on mobile, XFile on web (both work with upload methods)
  // ==========================================================================
  Future<dynamic> _pickImage() async {
    try {
      // Use ImagePickerHelper for cross-platform compatibility
      // Returns File on mobile, XFile on web
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
      final authProvider = context.read<AuthProvider>();
      try {
        await authProvider.uploadProfilePhoto(file);
        if (mounted) {
          _showSnackBar('Profile photo uploaded successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Upload failed: $e', isError: true);
        }
      }
    }
  }

  /// Handles Aadhaar upload
  Future<void> _onAadhaarSelected() async {
    final file = await _pickImage();
    if (file != null && mounted) {
      final authProvider = context.read<AuthProvider>();
      try {
        await authProvider.uploadAadhaarDocument(file);
        if (mounted) {
          final loc = AppLocalizations.of(context);
          _showSnackBar(loc?.aadhaarDocumentUploadedSuccessfully ?? 'Aadhaar document uploaded successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Upload failed: $e', isError: true);
        }
      }
    }
  }

  /// Validates all fields
  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0: // Personal Info
        return _validatePersonalInfo();
      case 1: // Documents
        return _validateDocuments();
      case 2: // Emergency Contact
        return _validateEmergencyContact();
      default:
        return false;
    }
  }

  bool _validatePersonalInfo() {
    setState(() {
      _nameError = _nameController.text.trim().isEmpty
          ? 'Full name is required'
          : _nameController.text.trim().length < 3
              ? 'Name must be at least 3 characters'
              : null;

      _dobError = DateManager.validateDisplay(_dobController.text);

      if (_emailController.text.trim().isNotEmpty) {
        _emailError = !RegExp(ValidationConstants.emailRegex)
                .hasMatch(_emailController.text.trim())
            ? 'Please enter a valid email address'
            : null;
      } else {
        _emailError = null;
      }
    });

    return _nameError == null && _dobError == null && _emailError == null;
  }

  bool _validateDocuments() {
    setState(() {
      _aadhaarError = _aadhaarNumberController.text.trim().isEmpty
          ? 'Aadhaar number is required'
          : _aadhaarNumberController.text.trim().length != 12
              ? 'Aadhaar must be 12 digits'
              : !RegExp(r'^\d{12}$')
                      .hasMatch(_aadhaarNumberController.text.trim())
                  ? 'Aadhaar must contain only digits'
                  : null;
    });

    return _aadhaarError == null;
  }

  bool _validateEmergencyContact() {
    setState(() {
      _emergencyNameError = _emergencyNameController.text.trim().isEmpty
          ? 'Contact name is required'
          : null;

      _emergencyPhoneError = _emergencyPhoneController.text.trim().isEmpty
          ? 'Contact phone is required'
          : !RegExp(ValidationConstants.phoneRegex)
                  .hasMatch(_emergencyPhoneController.text.trim())
              ? 'Please enter a valid 10-digit phone number'
              : null;
    });

    return _emergencyNameError == null &&
        _emergencyPhoneError == null &&
        _emergencyRelationController.text.isNotEmpty;
  }

  /// Moves to next step or submits
  Future<void> _handleNext() async {
    if (!_validateCurrentStep()) {
      _showSnackBar('Please fix all errors before continuing', isError: true);
      return;
    }

    if (_currentStep < 2) {
      _tabController.animateTo(_currentStep + 1);
    } else {
      await _onSubmit();
    }
  }

  /// Handles form submission
  Future<void> _onSubmit() async {
    if (!_validatePersonalInfo() ||
        !_validateDocuments() ||
        !_validateEmergencyContact()) {
      _showSnackBar('Please complete all required fields', isError: true);
      return;
    }

    final authProvider = context.read<AuthProvider>();

    if (authProvider.uploadingProfile || authProvider.uploadingAadhaar) {
      _showSnackBar('Please wait for uploads to complete', isError: true);
      return;
    }

    try {
      final currentUser = authProvider.user;
      if (currentUser == null) throw Exception('User not authenticated');

      final emergencyContact = {
        'name': _emergencyNameController.text.trim(),
        'phone': _emergencyPhoneController.text.trim(),
        'relationship': _emergencyRelationController.text.trim(),
        'address': _emergencyAddressController.text.trim(),
      };

      final age = _dobController.text.isEmpty
          ? null
          : DateManager.calculateAge(_dobController.text);

      // CRITICAL: Use the role from currentUser (which should already have the selected role from verifyOTP)
      // currentUser.role is non-nullable and should already have the role set by verifyOTP using _selectedRole
      final newUser = UserModel(
        userId: currentUser.userId,
        phoneNumber: currentUser.phoneNumber,
        role: currentUser
            .role, // Should already have _selectedRole from verifyOTP
        fullName: _nameController.text.trim(),
        dateOfBirth: _dobController.text.isEmpty
            ? null
            : DateManager.parseDisplay(_dobController.text),
        age: age,
        gender: _selectedGender,
        email: _emailController.text.trim().isEmpty
            ? null
            : _emailController.text.trim(),
        aadhaarNumber: _aadhaarNumberController.text.trim(),
        aadhaarPhotoUrl: authProvider.aadhaarUrl,
        profilePhotoUrl: authProvider.profilePhotoUrl,
        emergencyContact: emergencyContact,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await authProvider.saveUser(newUser);

      if (!mounted) return;

      _showSnackBar('🎉 Registration completed successfully!');

      // STRICT: Navigate to dashboard based on role - NO FALLBACK
      await Future.delayed(const Duration(milliseconds: 500));
      final navigationService = getIt<NavigationService>();
      final userRole = newUser.role.toLowerCase().trim();

      // STRICT ROLE CHECK: Only navigate if role is explicitly 'guest' or 'owner'
      if (userRole == 'guest') {
        debugPrint(
            '✅ Registration: Role is guest - navigating to guest dashboard');
        navigationService.goToGuestHome();
      } else if (userRole == 'owner') {
        debugPrint(
            '✅ Registration: Role is owner - navigating to owner dashboard');
        navigationService.goToOwnerHome();
      } else {
        // Invalid role - redirect to role selection
        debugPrint(
            '⚠️ Registration: Invalid role "$userRole" - redirecting to role selection');
        if (mounted) {
          _showSnackBar('Please select a valid role (Guest or Owner)',
              isError: true);
          navigationService.goToRoleSelection();
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Error: $e', isError: true);
      }
    }
  }

  /// Shows styled snackbar
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BodyText(
          text: message,
          color: Colors.white,
        ),
        backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(AppSpacing.md),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context);

    // ==========================================================================
    // THEME-AWARE COLORS
    // ==========================================================================
    // Get colors that adapt to current theme (light or dark mode)
    // This ensures proper visibility in both day and night modes
    // ==========================================================================
    final isDarkMode = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final primaryColor = theme.colorScheme.primary;
    // final AppColors.textPrimary =
    //     theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    return Scaffold(
      // Use theme background color for proper day/night visibility
      backgroundColor: scaffoldBg,
      // =======================================================================
      // App Bar with Automatic Theme Toggle
      // =======================================================================
      // AdaptiveAppBar automatically adds theme toggle button as last action
      // User can switch between Light/Dark/System modes during registration
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: loc?.completeYourProfile ?? 'Complete Your Profile',
        centerTitle: true,
        elevation: 0,
        showThemeToggle: true, // Theme toggle enabled for user comfort
      ),
      body: Column(
        children: [
          // Beautiful step indicator with theme-aware background
          Container(
            color:
                surfaceColor, // Adapts to theme (white in light, dark in dark mode)
            child: Builder(
              builder: (context) {
                final loc = AppLocalizations.of(context);
                if (loc == null) {
                  return StepIndicator(
                    currentStep: _currentStep,
                    totalSteps: 3,
                    stepLabels: const ['Personal', 'Documents', 'Emergency'],
                  );
                }
                return StepIndicator(
                  currentStep: _currentStep,
                  totalSteps: 3,
                  stepLabels: [loc.personal, loc.documents, loc.emergency],
                );
              },
            ),
          ),

          // Progress bar with theme-aware colors
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: isDarkMode
                ? AppColors.darkDivider // Dark mode: darker background
                : AppColors.outline, // Light mode: light grey
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildPersonalInfoTab(authProvider),
                _buildDocumentsTab(authProvider),
                _buildEmergencyContactTab(authProvider),
              ],
            ),
          ),

          // Bottom navigation bar
          _buildBottomNavigation(authProvider, loc),
        ],
      ),
    );
  }

  /// Personal Info Tab with theme-aware colors
  Widget _buildPersonalInfoTab(AuthProvider authProvider) {
    // ==========================================================================
    // Get theme-aware colors for this tab
    // ==========================================================================
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final loc = AppLocalizations.of(context);
    // final AppColors.textPrimary =
    //     theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    return FadeInAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),

            // Section header
            HeadingMedium(text: loc?.personalInformation ?? 'Personal Information'),
            const SizedBox(height: AppSpacing.xs),
            CaptionText(text: loc?.pleaseProvideYourDetailsAsPerOfficialDocuments ?? 'Please provide your details as per your official documents'),
            const SizedBox(height: AppSpacing.lg),

            // Phone Number (Read-only) - Shows the number used during login
            SlideInAnimation(
              delay: const Duration(milliseconds: 50),
              child: TextFormField(
                controller:
                    _phoneController, // Use controller to show phone number
                readOnly: true,
                enabled: false,
                style: TextStyle(
                  color: AppColors.textPrimary, // Make sure text is visible
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: loc?.phoneNumber ?? 'Phone Number',
                  hintText: loc?.yourRegisteredPhoneNumber ?? 'Your registered phone number',
                  prefixIcon: const Icon(Icons.phone),
                  suffixIcon:
                      Icon(Icons.verified, color: AppColors.success, size: 20),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: isDarkMode
                      ? AppColors.darkCard.withValues(alpha: 0.5)
                      : AppColors.surfaceVariant.withValues(alpha: 0.5),
                  helperText: loc?.verifiedDuringLogin ?? '✓ Verified during login',
                  helperStyle: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                  // Ensure disabled text is visible
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.success.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Name field
            SlideInAnimation(
              delay: const Duration(milliseconds: 100),
              child: TextInput(
                controller: _nameController,
                label: loc?.fullName ?? 'Full Name',
                hint: loc?.enterYourCompleteName ?? 'Enter your complete name',
                prefixIcon: const Icon(Icons.person),
                error: _nameError,
                onChanged: (v) {
                  setState(() {
                    _nameError = v.trim().isEmpty
                        ? (loc?.fullNameIsRequired ?? 'Full name is required')
                        : v.trim().length < 3
                            ? (loc?.nameMustBeAtLeast3Characters ?? 'Name must be at least 3 characters')
                            : null;
                  });
                },
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Date of Birth with theme-aware styling
            SlideInAnimation(
              delay: const Duration(milliseconds: 200),
              child: TextFormField(
                controller: _dobController,
                readOnly: true,
                onTap: _selectDate,
                decoration: InputDecoration(
                  labelText: loc?.dateOfBirth ?? 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  prefixIcon: const Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_month, color: primaryColor),
                    onPressed: _selectDate,
                  ),
                  border: const OutlineInputBorder(),
                  filled: true,
                  // Theme-aware fill color
                  fillColor: isDarkMode
                      ? AppColors.darkInputFill
                      : AppColors.surfaceVariant,
                  errorText: _dobError,
                ),
              ),
            ),

            // Age display
            if (_dobController.text.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Builder(
                builder: (context) {
                  try {
                    final age = DateManager.calculateAge(_dobController.text);
                    // Theme-aware success/warning colors
                    final ageColor = age >= 18
                        ? AppColors.success // Green for valid age
                        : AppColors.warning; // Orange for under 18

                    return AdaptiveCard(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            Icon(
                              age >= 18 ? Icons.check_circle : Icons.warning,
                              color: ageColor,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            BodyText(
                              text: '${loc?.age ?? 'Age'}: $age ${loc?.years ?? 'years'}',
                              color: ageColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (e) {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],

            const SizedBox(height: AppSpacing.md),

            // Gender dropdown with theme-aware styling
            SlideInAnimation(
              delay: const Duration(milliseconds: 300),
              child: DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: InputDecoration(
                  labelText: loc?.gender ?? 'Gender',
                  prefixIcon: const Icon(Icons.people),
                  border: const OutlineInputBorder(),
                  filled: true,
                  // Theme-aware fill color
                  fillColor: isDarkMode
                      ? AppColors.darkInputFill
                      : AppColors.surfaceVariant,
                ),
                dropdownColor:
                    isDarkMode ? AppColors.darkCard : AppColors.surface,
                items: [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Row(
                      children: [
                        Icon(Icons.male, color: AppColors.info),
                        const SizedBox(width: 8),
                        Text(loc?.male ?? 'Male',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Row(
                      children: [
                        Icon(Icons.female, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text(loc?.female ?? 'Female',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Row(
                      children: [
                        Icon(Icons.transgender, color: AppColors.purple),
                        const SizedBox(width: 8),
                        Text(loc?.other ?? 'Other',
                            style: TextStyle(color: AppColors.textPrimary)),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedGender = value);
                  }
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Email field
            SlideInAnimation(
              delay: const Duration(milliseconds: 400),
              child: TextInput(
                controller: _emailController,
                label: loc?.emailAddressOptional ?? 'Email Address (Optional)',
                hint: loc?.yourEmailExampleCom ?? 'your.email@example.com',
                prefixIcon: const Icon(Icons.email),
                keyboardType: TextInputType.emailAddress,
                error: _emailError,
                onChanged: (v) {
                  setState(() {
                    if (v.trim().isEmpty) {
                      _emailError = null;
                    } else if (!RegExp(ValidationConstants.emailRegex)
                        .hasMatch(v.trim())) {
                      _emailError = loc?.pleaseEnterValidEmail ?? 'Please enter a valid email';
                    } else {
                      _emailError = null;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Documents Tab
  Widget _buildDocumentsTab(AuthProvider authProvider) {
    final loc = AppLocalizations.of(context);
    
    return FadeInAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),

            HeadingMedium(text: loc?.uploadDocuments ?? 'Upload Documents'),
            const SizedBox(height: AppSpacing.xs),
            CaptionText(
              text: loc?.uploadClearPhotosOfYourDocuments ?? 'Upload clear photos of your documents for verification',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Profile Photo Upload
            SlideInAnimation(
              delay: const Duration(milliseconds: 100),
              child: UploadCard(
                title: loc?.profilePhoto ?? 'Profile Photo',
                description: loc?.uploadClearPhotoOfYourself ?? 'Upload a clear photo of yourself',
                icon: Icons.person,
                imageUrl: authProvider.profilePhotoUrl,
                imageFile: authProvider.profilePhotoFile,
                isUploading: authProvider.uploadingProfile,
                isRequired: true,
                onUpload: _onProfilePhotoSelected,
                accentColor: Colors.blue,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Aadhaar Document Upload
            SlideInAnimation(
              delay: const Duration(milliseconds: 200),
              child: UploadCard(
                title: loc?.aadhaarDocument ?? 'Aadhaar Document',
                description: loc?.uploadYourAadhaarCard ?? 'Upload your Aadhaar card (front or back)',
                icon: Icons.badge,
                imageUrl: authProvider.aadhaarUrl,
                imageFile: authProvider.aadhaarFile,
                isUploading: authProvider.uploadingAadhaar,
                isRequired: true,
                onUpload: _onAadhaarSelected,
                accentColor: Colors.orange,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Aadhaar Number
            SlideInAnimation(
              delay: const Duration(milliseconds: 300),
              child: TextInput(
                controller: _aadhaarNumberController,
                label: loc?.aadhaarNumber ?? 'Aadhaar Number',
                hint: loc?.enter12DigitAadhaarNumber ?? 'Enter 12-digit Aadhaar number',
                prefixIcon: const Icon(Icons.credit_card),
                keyboardType: TextInputType.number,
                maxLength: 12,
                error: _aadhaarError,
                onChanged: (v) {
                  setState(() {
                    if (v.trim().isEmpty) {
                      _aadhaarError = loc?.aadhaarNumberIsRequired ?? 'Aadhaar number is required';
                    } else if (v.length != 12) {
                      _aadhaarError = loc?.aadhaarMustBe12Digits ?? 'Aadhaar must be 12 digits';
                    } else if (!RegExp(r'^\d{12}$').hasMatch(v)) {
                      _aadhaarError = loc?.aadhaarMustContainOnlyDigits ?? 'Aadhaar must contain only digits';
                    } else {
                      _aadhaarError = null;
                    }
                  });
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Info card
            AdaptiveCard(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.blue.shade700, size: 24),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: CaptionText(
                        text: loc?.yourDocumentsAreSecurelyStored ?? 'Your documents are securely stored and used only for verification purposes',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Emergency Contact Tab with theme-aware colors
  Widget _buildEmergencyContactTab(AuthProvider authProvider) {
    // ==========================================================================
    // Get theme-aware colors for this tab
    // ==========================================================================
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);
    // final AppColors.textPrimary =
    //     theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    return FadeInAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),

            HeadingMedium(text: loc?.emergencyContact ?? 'Emergency Contact'),
            const SizedBox(height: AppSpacing.xs),
            CaptionText(
              text: loc?.provideDetailsOfSomeoneWeCanContact ?? 'Provide details of someone we can contact in case of emergency',
            ),
            const SizedBox(height: AppSpacing.lg),

            // Contact Name
            SlideInAnimation(
              delay: const Duration(milliseconds: 100),
              child: TextInput(
                controller: _emergencyNameController,
                label: loc?.contactName ?? 'Contact Name',
                hint: loc?.fullNameOfEmergencyContact ?? 'Full name of emergency contact',
                prefixIcon: const Icon(Icons.contact_emergency),
                error: _emergencyNameError,
                onChanged: (v) {
                  setState(() {
                    _emergencyNameError =
                        v.trim().isEmpty ? (loc?.contactNameIsRequired ?? 'Contact name is required') : null;
                  });
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Contact Phone
            SlideInAnimation(
              delay: const Duration(milliseconds: 200),
              child: TextInput(
                controller: _emergencyPhoneController,
                label: 'Contact Phone',
                hint: '10-digit phone number',
                prefixIcon: const Icon(Icons.phone),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                error: _emergencyPhoneError,
                onChanged: (v) {
                  setState(() {
                    _emergencyPhoneError = v.trim().isEmpty
                        ? 'Contact phone is required'
                        : !RegExp(ValidationConstants.phoneRegex)
                                .hasMatch(v.trim())
                            ? 'Enter valid 10-digit number'
                            : null;
                  });
                },
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Relationship dropdown with theme-aware styling
            SlideInAnimation(
              delay: const Duration(milliseconds: 300),
              child: DropdownButtonFormField<String>(
                initialValue: _emergencyRelationController.text.isEmpty
                    ? null
                    : _emergencyRelationController.text,
                decoration: InputDecoration(
                  labelText: loc?.contactRelation ?? 'Relation',
                  prefixIcon: const Icon(Icons.family_restroom),
                  border: const OutlineInputBorder(),
                  filled: true,
                  // Theme-aware fill color
                  fillColor: isDarkMode
                      ? AppColors.darkInputFill
                      : AppColors.surfaceVariant,
                ),
                // Theme-aware dropdown background
                dropdownColor:
                    isDarkMode ? AppColors.darkCard : AppColors.surface,
                items: [
                  DropdownMenuItem(
                    value: 'Father',
                    child: Text(loc?.father ?? 'Father',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Mother',
                    child: Text(loc?.mother ?? 'Mother',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Brother',
                    child: Text(loc?.brother ?? 'Brother',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Sister',
                    child: Text(loc?.sister ?? 'Sister',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Spouse',
                    child: Text(loc?.spouse ?? 'Spouse',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Friend',
                    child: Text(loc?.friend ?? 'Friend',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text(loc?.other ?? 'Other',
                        style: TextStyle(color: AppColors.textPrimary)),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _emergencyRelationController.text = value);
                  }
                },
                validator: (value) => value == null || value.isEmpty
                    ? (loc?.pleaseSelectRelationship ?? 'Please select relationship')
                    : null,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            // Address
            SlideInAnimation(
              delay: const Duration(milliseconds: 400),
              child: TextInput(
                controller: _emergencyAddressController,
                label: loc?.contactAddressOptional ?? 'Contact Address (Optional)',
                hint: loc?.fullAddressOfEmergencyContact ?? 'Full address of emergency contact',
                prefixIcon: const Icon(Icons.location_on),
                maxLines: 3,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Success message with theme-aware colors
            if (_validateEmergencyContact())
              AdaptiveCard(
                elevation: 2,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    // Theme-aware success gradient
                    color: isDarkMode
                        ? AppColors.successContainer.withValues(alpha: 0.2)
                        : AppColors.successContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: AppColors.success, size: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: BodyText(
                          text: loc?.allRequiredFieldsCompletedReadyToSubmit ?? 'All required fields completed! Ready to submit.',
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Bottom navigation bar with theme-aware styling
  Widget _buildBottomNavigation(AuthProvider authProvider, AppLocalizations? loc) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final canProceed = _validateCurrentStep();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        // Theme-aware surface color
        color: surfaceColor,
        boxShadow: [
          BoxShadow(
            // Theme-aware shadow
            color: isDarkMode
                ? Colors.black
                    .withValues(alpha: 0.3) // Darker shadow in dark mode
                : Colors.black.withValues(alpha: 0.05), // Light shadow in light mode
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (_currentStep > 0)
              Expanded(
                child: SecondaryButton(
                  onPressed: authProvider.loading
                      ? null
                      : () => _tabController.animateTo(_currentStep - 1),
                  label: loc?.back ?? 'Back',
                  icon: Icons.arrow_back,
                ),
              ),

            if (_currentStep > 0) const SizedBox(width: AppSpacing.md),

            // Next/Submit button
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: PrimaryButton(
                onPressed:
                    authProvider.loading || !canProceed ? null : _handleNext,
                label: _currentStep == 2 ? (loc?.finish ?? 'Finish') : (loc?.continueButton ?? 'Continue'),
                icon: _currentStep == 2 ? Icons.check : Icons.arrow_forward,
                isLoading: authProvider.loading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
