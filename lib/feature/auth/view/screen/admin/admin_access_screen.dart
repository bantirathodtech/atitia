// lib/feature/auth/view/screen/admin/admin_access_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../logic/auth_provider.dart';

/// Admin Access Screen
/// Allows admin to authenticate and access admin dashboard
/// Admin is separate from user roles (guest/owner) - it's for app management
class AdminAccessScreen extends StatefulWidget {
  const AdminAccessScreen({super.key});

  @override
  State<AdminAccessScreen> createState() => _AdminAccessScreenState();
}

class _AdminAccessScreenState extends State<AdminAccessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Admin Access',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Admin Info Card
              AdaptiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 48,
                        color: AppColors.warning,
                      ),
                      const SizedBox(height: AppSpacing.paddingM),
                      HeadingMedium(text: 'Admin Access'),
                      const SizedBox(height: AppSpacing.paddingS),
                      BodyText(
                        text:
                            'Admin access is for app management only. You must be authenticated as an admin user to access this area.',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingL),

              // Phone Number Field
              AdaptiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingMedium(text: 'Enter Admin Phone Number'),
                      const SizedBox(height: AppSpacing.paddingM),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: '+91 9876543210',
                          prefixIcon: const Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.borderRadiusM),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.trim().length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingL),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(color: AppColors.error),
                  ),
                  child: BodyText(
                    text: _errorMessage!,
                    color: AppColors.error,
                  ),
                ),
              const SizedBox(height: AppSpacing.paddingM),

              // Access Button
              PrimaryButton(
                onPressed: _isLoading ? null : _handleAdminAccess,
                label:
                    _isLoading ? 'Authenticating...' : 'Access Admin Dashboard',
              ),
              const SizedBox(height: AppSpacing.paddingM),

              // Note
              Center(
                child: BodyText(
                  text:
                      'Note: You must be pre-configured as an admin user in the system. Contact system administrator if you need admin access.',
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAdminAccess() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = context.read<AuthProvider>();

      // Set admin role before authentication
      // Note: Admin users must be pre-configured in Firestore with role='admin'
      authProvider.setRole('admin');

      // Navigate to phone auth with admin role set
      // After successful auth, the system will check if user has admin role in Firestore
      // If user is admin, they'll be navigated to admin dashboard
      getIt<NavigationService>().goToPhoneAuth();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to proceed: $e';
        _isLoading = false;
      });
    }
  }
}
