// ============================================================================
// Owner Profile Screen - My Profile
// ============================================================================
// Complete profile viewing and editing screen for owner users.
//
// FEATURES:
// - View complete profile information
// - Edit personal details (name, phone, email, etc.)
// - Upload/update profile photo
// - Upload/update Aadhaar photo
// - Manage business details
// - Theme toggle for comfortable viewing in any lighting
//
// THEME TOGGLE:
// - Automatic theme toggle in app bar (Light/Dark/System)
// - User can switch themes while viewing/editing profile
// - Makes profile editing comfortable in different lighting conditions
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
// import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/text/caption_text.dart';
// import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
// import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
// import '../../../../../core/navigation/navigation_service.dart';
// import '../../../../../core/utils/constants/indian_states_cities.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../../auth/data/model/user_model.dart';
import '../../data/models/owner_profile_model.dart';
import '../../viewmodel/owner_profile_viewmodel.dart';

/// Screen for owners to view and edit their complete profile information
/// Uses OwnerProfileViewModel for profile management and file uploads
/// Provides comprehensive profile editing with photo upload capabilities
class OwnerProfileScreen extends StatefulWidget {
  const OwnerProfileScreen({super.key});

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _pgAddressController;
  late TextEditingController _pincodeController;
  late TextEditingController _businessNameController;
  late TextEditingController _businessTypeController;
  late TextEditingController _panNumberController;
  late TextEditingController _gstNumberController;

  String? _selectedState;
  String? _selectedCity;
  final List<String> _availableCities = [];
  String? _uploadedProfilePhotoUrl;
  String? _uploadedAadhaarPhotoUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeControllers();
    _loadOwnerProfile();
  }

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

  void _loadOwnerProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final viewModel = context.read<OwnerProfileViewModel>();
      final authProvider = context.read<AuthProvider>();

      // Load profile from backend
      if (authProvider.user?.userId != null) {
        await viewModel.loadProfile(ownerId: authProvider.user!.userId);
      }

      // Populate form with loaded data
      if (viewModel.profile != null) {
        _populateFromOwnerProfile(viewModel.profile!);
      } else if (authProvider.user != null) {
        _populateFromUserModel(authProvider.user!);
      }
    });
  }

  void _populateFromUserModel(UserModel user) {
    _fullNameController.text = user.fullName ?? '';
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phoneNumber;
    _pgAddressController.text = user.pgAddress ?? '';
    _pincodeController.text = user.pincode ?? '';
    _selectedState = user.state;
    _selectedCity = user.city;

    if (_selectedState != null) {
      // _availableCities = IndianStatesCities.getCitiesForState(_selectedState!);
    }

    _uploadedProfilePhotoUrl = user.profilePhotoUrl;
    _uploadedAadhaarPhotoUrl = user.aadhaarPhotoUrl;

    setState(() {});
  }

  void _populateFromOwnerProfile(OwnerProfile profile) {
    _businessNameController.text = profile.businessName ?? '';
    _businessTypeController.text = profile.businessType ?? '';
    _panNumberController.text = profile.panNumber ?? '';
    _gstNumberController.text = profile.gstNumber ?? '';

    setState(() {});
  }

  // void _onStateChanged(String? newState) {
  //   setState(() {
  //     _selectedState = newState;
  //     _selectedCity = null;
  //     // _availableCities = IndianStatesCities.getCitiesForState(newState ?? '');
  //   });
  // }

  // void _onCityChanged(String? newCity) {
  //   setState(() {
  //     _selectedCity = newCity;
  //   });
  // }

  // ignore: unused_element
  Future<File?> _pickImage() async {
    try {
      final imageFile = await ImagePickerHelper.pickImageFromGallery();
      return imageFile;
    } catch (e) {
      if (!mounted) return null;
      final loc = AppLocalizations.of(context)!;
      _showSnackBar(loc.ownerProfilePickImageFailed(e.toString()));
      return null;
    }
  }

  // Future<void> _onProfilePhotoSelected() async {
  //   try {
  //     final imageFile = await _pickImage();
  //     if (imageFile != null) {
  //       final viewModel = context.read<OwnerProfileViewModel>();
  //       final url = await viewModel.uploadProfilePhoto(imageFile);
  //       if (url != null) {
  //         setState(() {
  //           _uploadedProfilePhotoUrl = url;
  //         });
  //         _showSnackBar('Profile photo updated successfully');
  //       }
  //     }
  //   } catch (e) {
  //     _showSnackBar('Failed to upload profile photo: ${e.toString()}');
  //   }
  // }

  // Future<void> _onAadhaarPhotoSelected() async {
  //   try {
  //     final imageFile = await _pickImage();
  //     if (imageFile != null) {
  //       final viewModel = context.read<OwnerProfileViewModel>();
  //       final url = await viewModel.uploadAadhaarPhoto(imageFile);
  //       if (url != null) {
  //         setState(() {
  //           _uploadedAadhaarPhotoUrl = url;
  //         });
  //         _showSnackBar('Aadhaar photo updated successfully');
  //       }
  //     }
  //   } catch (e) {
  //     _showSnackBar('Failed to upload Aadhaar photo: ${e.toString()}');
  //   }
  // }

  Future<void> _saveProfile() async {
    // if (!// _formKey.currentState!.validate()) return;

    try {
      final viewModel = context.read<OwnerProfileViewModel>();
      // final // authProvider = context.read<AuthProvider>();

      final profileData = {
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'pgAddress': _pgAddressController.text,
        'pincode': _pincodeController.text,
        'state': _selectedState,
        'city': _selectedCity,
        'profilePhotoUrl': _uploadedProfilePhotoUrl,
        'aadhaarPhotoUrl': _uploadedAadhaarPhotoUrl,
        'businessName': _businessNameController.text,
        'businessType': _businessTypeController.text,
        'panNumber': _panNumberController.text,
        'gstNumber': _gstNumberController.text,
      };

      await viewModel.updateProfile(profileData);

      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        _showSnackBar(loc.ownerProfileUpdateSuccess);
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context)!;
        _showSnackBar(loc.ownerProfileUpdateFailure(e.toString()));
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BodyText(text: message),
        backgroundColor: AppColors.primary,
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
    final loc = AppLocalizations.of(context)!;
    // final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.ownerProfileTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded),
            onPressed: viewModel.loading ? null : _saveProfile,
            tooltip: loc.ownerProfileSaveTooltip,
          ),
        ],
      ),
      body: _buildBody(context, viewModel, loc),
    );
  }

  Widget _buildBody(
      BuildContext context, OwnerProfileViewModel viewModel, AppLocalizations loc) {
    return Column(
      children: [
        _buildTabBar(loc),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPersonalInfoTab(loc),
              _buildBusinessInfoTab(loc),
              _buildDocumentsTab(loc),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations loc) {
    // final theme = Theme.of(context);
    final primaryColor = AppColors.primary;
    final surfaceColor = AppColors.darkCard;
    final textSecondary = AppColors.textTertiary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkDivider,
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: AppColors.textOnPrimary,
        unselectedLabelColor: textSecondary,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(text: loc.ownerProfileTabPersonalInfo),
          Tab(text: loc.ownerProfileTabBusinessInfo),
          Tab(text: loc.ownerProfileTabDocuments),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab(AppLocalizations loc) {
    // final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        // key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextFormField(
              controller: _fullNameController,
              label: loc.ownerProfileFullNameLabel,
              hint: loc.ownerProfileFullNameHint,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildTextFormField(
              controller: _emailController,
              label: loc.ownerProfileEmailLabel,
              hint: loc.ownerProfileEmailHint,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildTextFormField(
              controller: _phoneController,
              label: loc.ownerProfilePhoneLabel,
              hint: loc.ownerProfilePhoneHint,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildTextFormField(
              controller: _pgAddressController,
              label: loc.ownerProfileAddressLabel,
              hint: loc.ownerProfileAddressHint,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildStateDropdown(loc),
            const SizedBox(height: AppSpacing.paddingM),
            _buildCityDropdown(loc),
            const SizedBox(height: AppSpacing.paddingM),
            _buildTextFormField(
              controller: _pincodeController,
              label: loc.ownerProfilePincodeLabel,
              hint: loc.ownerProfilePincodeHint,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: _saveProfile,
              label: loc.ownerProfileSavePersonal,
              icon: Icons.save_rounded,
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  /// Safe state changed handler with null safety and error handling
  void _onStateChanged(String? value) {
    try {
      setState(() {
        _selectedState = value;
        _selectedCity = null; // Reset city when state changes
        // _availableCities = IndianStatesCities.getCitiesForState(value ?? '');
      });
    } catch (e) {
      debugPrint(
        _text(
          'ownerStateUpdateFailedLog',
          'Error updating selected state: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  Widget _buildStateDropdown(AppLocalizations loc) {
    // final theme = Theme.of(context);

    return AdaptiveDropdown<String>(
      label: loc.ownerProfileStateLabel,
      value: _selectedState,
      hint: loc.ownerProfileStateHint,
      items: [
        DropdownMenuItem<String>(
          value: 'Telangana',
          child: BodyText(text: loc.ownerStateTelangana),
        ),
        DropdownMenuItem<String>(
          value: 'Andhra Pradesh',
          child: BodyText(text: loc.ownerStateAndhraPradesh),
        ),
      ],
      onChanged: _onStateChanged,
    );
  }

  /// Safe city changed handler with null safety and error handling
  void _onCityChanged(String? value) {
    try {
      setState(() {
        _selectedCity = value;
      });
    } catch (e) {
      debugPrint(
        _text(
          'ownerCityUpdateFailedLog',
          'Error updating selected city: {error}',
          parameters: {'error': e.toString()},
        ),
      );
    }
  }

  Widget _buildCityDropdown(AppLocalizations loc) {
    // final theme = Theme.of(context);

    return AdaptiveDropdown<String>(
      label: loc.ownerProfileCityLabel,
      value: _selectedCity,
      hint: _selectedState == null
          ? loc.ownerProfileCityHintSelectState
          : loc.ownerProfileCityHint,
      items: _availableCities.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: BodyText(text: city),
        );
      }).toList(),
      onChanged: _selectedState != null ? _onCityChanged : null,
      enabled: _selectedState != null,
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    String? hint,
  }) {
    // final theme = Theme.of(context);

    return TextInput(
      controller: controller,
      label: label,
      hint: hint,
    );
  }

  Widget _buildBusinessInfoTab(AppLocalizations loc) {
    // final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextFormField(
            controller: _businessNameController,
            label: loc.ownerProfileBusinessNameLabel,
            hint: loc.ownerProfileBusinessNameHint,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTextFormField(
            controller: _businessTypeController,
            label: loc.ownerProfileBusinessTypeLabel,
            hint: loc.ownerProfileBusinessTypeHint,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTextFormField(
            controller: _panNumberController,
            label: loc.ownerProfilePanLabel,
            hint: loc.ownerProfilePanHint,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTextFormField(
            controller: _gstNumberController,
            label: loc.ownerProfileGstLabel,
            hint: loc.ownerProfileGstHint,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PrimaryButton(
            onPressed: _saveProfile,
            label: loc.ownerProfileSaveBusiness,
            icon: Icons.save_rounded,
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(AppLocalizations loc) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDocumentUploadCard(
            title: loc.ownerProfileDocumentProfileTitle,
            description: loc.ownerProfileDocumentProfileDescription,
            icon: Icons.person_rounded,
            imageUrl: _uploadedProfilePhotoUrl,
            loc: loc,
            onTap: () {
              // TODO: Implement profile photo selection
            },
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildDocumentUploadCard(
            title: loc.ownerProfileDocumentAadhaarTitle,
            description: loc.ownerProfileDocumentAadhaarDescription,
            icon: Icons.credit_card_rounded,
            imageUrl: _uploadedAadhaarPhotoUrl,
            loc: loc,
            onTap: () {
              // TODO: Implement Aadhaar photo selection
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadCard({
    required String title,
    required String description,
    required IconData icon,
    String? imageUrl,
    required AppLocalizations loc,
    required VoidCallback onTap,
  }) {
    // final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkDivider,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingMedium(text: title),
                    CaptionText(text: description),
                  ],
                ),
              ),
              if (imageUrl != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            onPressed: onTap,
            label: imageUrl != null
                ? loc.ownerProfileDocumentUpdate
                : loc.ownerProfileDocumentUpload,
            icon: imageUrl != null ? Icons.edit_rounded : Icons.upload_rounded,
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
