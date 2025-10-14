// lib/features/auth/view/screen/phone_auth_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/validation.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../logic/auth_provider.dart';

/// Phone authentication screen handling OTP sending and verification
/// Uses AuthProvider for business logic and state management
/// Enhanced with common widgets and improved UX
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _phoneError;
  String? _otpError;

  bool _otpSent = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  /// Validates phone number
  String? _validatePhone(String value) {
    if (value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(ValidationConstants.phoneRegex).hasMatch(value.trim())) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  /// Validates OTP
  String? _validateOTP(String value) {
    if (value.trim().isEmpty) {
      return 'OTP is required';
    }
    if (value.trim().length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  /// Sends OTP to provided phone number
  Future<void> _sendOTP() async {
    // Validate phone number
    final phoneErr = _validatePhone(_phoneController.text.trim());
    if (phoneErr != null) {
      setState(() => _phoneError = phoneErr);
      return;
    }

    setState(() {
      _loading = true;
      _phoneError = null;
    });

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.sendOTP(
        _phoneController.text.trim(),
        (verificationId, resendToken) {
          // OTP sent successfully
          if (mounted) {
            setState(() {
              _otpSent = true;
              _loading = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: BodyText(text: 'OTP sent successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        (error) {
          // OTP sending failed
          if (mounted) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: BodyText(text: 'Failed to send OTP: ${error.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Google Sign-In for macOS and other platforms
  Future<void> _signInWithGoogle() async {
    setState(() => _loading = true);

    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Google Sign-In failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Verifies OTP and navigates to appropriate screen
  Future<void> _verifyOTP() async {
    // Validate OTP
    final otpErr = _validateOTP(_otpController.text.trim());
    if (otpErr != null) {
      setState(() => _otpError = otpErr);
      return;
    }

    setState(() {
      _loading = true;
      _otpError = null;
    });

    final authProvider = context.read<AuthProvider>();

    try {
      final isExistingUser =
          await authProvider.verifyOTP(_otpController.text.trim());

      if (!mounted) return;

      final navigation = getIt<NavigationService>();
      
      if (!isExistingUser) {
        // New user - navigate to registration
        navigation.goToRegistration();
        return;
      }

      // Existing user - check role and navigate accordingly
      final user = authProvider.user;
      if (user == null) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: BodyText(text: 'User data not found'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ========================================================================
      // CRITICAL: Check if profile is complete, NOT if they have a PG
      // ========================================================================
      // - Registration screen is for USER PROFILE, not PG setup
      // - If profile incomplete → Registration
      // - If profile complete → Dashboard (regardless of PG status)
      // ========================================================================
      if (!user.isProfileComplete) {
        // Profile not complete - go to registration
        navigation.goToRegistration();
        return;
      }

      // Profile is complete - navigate to dashboard based on role
      if (user.role == 'owner') {
        navigation.goToOwnerHome();
      } else {
        navigation.goToGuestHome();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Handles Google sign-in
  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    
    try {
      await context.read<AuthProvider>().signInWithGoogle();
      
      if (!mounted) return;
      
      // Navigation is handled in AuthProvider.signInWithGoogle()
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Google sign-in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.user?.role;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: role != null ? 'Login as ${role.toUpperCase()}' : 'Login',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => getIt<NavigationService>().goToRoleSelection(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.xl),
              
              // Header icon
              Icon(
                Icons.phone_android,
                size: 96,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Title
              HeadingLarge(
                text: role != null ? 'Login as ${role.toUpperCase()}' : 'Login',
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              
              // Subtitle
              const CaptionText(
                text: 'Enter your phone number to receive OTP',
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              
              // Phone input field - Disabled on macOS
              if (!Platform.isMacOS) ...[
                TextInput(
                  controller: _phoneController,
                  label: loc.phoneNumber,
                  hint: '10-digit mobile number',
                  prefixIcon: const Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                  enabled: !_otpSent && !_loading,
                  error: _phoneError,
                  maxLength: 10,
                  onChanged: (v) {
                    setState(() {
                      _phoneError = _validatePhone(v);
                    });
                  },
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade50,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.phone_disabled, color: Colors.grey.shade500),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Authentication',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Not available on macOS. Please use Google Sign-In below.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // OTP input field (shown after OTP is sent) - Not available on macOS
              if (_otpSent && !Platform.isMacOS) ...[
                const SizedBox(height: AppSpacing.lg),
                TextInput(
                  controller: _otpController,
                  label: loc.enterOTP,
                  hint: '6-digit code',
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  error: _otpError,
                  prefixIcon: const Icon(Icons.security),
                  onChanged: (v) {
                    setState(() {
                      _otpError = _validateOTP(v);
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                const CaptionText(
                  text: 'Please enter the 6-digit code sent to your phone',
                  align: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: AppSpacing.xl),
              
              // Action button (Send OTP / Verify) - Not available on macOS
              if (!Platform.isMacOS) ...[
                PrimaryButton(
                  onPressed: _loading
                      ? null
                      : _otpSent
                          ? _verifyOTP
                          : _sendOTP,
                  label: _otpSent ? loc.verify : loc.sendOTP,
                  isLoading: _loading,
                ),
              ],
              
              // Change number option - Not available on macOS
              if (_otpSent && !Platform.isMacOS) ...[
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  onPressed: _loading
                      ? null
                      : () {
                          setState(() {
                            _otpSent = false;
                            _otpController.clear();
                            _otpError = null;
                          });
                        },
                  label: 'Change Number',
                  icon: Icons.edit,
                ),
              ],
              
              const SizedBox(height: AppSpacing.lg),
              
              // Divider - Only show when both methods are available
              if (!Platform.isMacOS) ...[
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: CaptionText(
                        text: 'OR',
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              
              // Google sign-in - Prominent for macOS
              if (Platform.isMacOS) ...[
                const SizedBox(height: AppSpacing.md),
                const CaptionText(
                  text: 'Phone OTP is not available on macOS. Please use Google Sign-In:',
                  align: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              PrimaryButton(
                onPressed: _loading ? null : _signInWithGoogle,
                label: Platform.isMacOS ? 'Sign in with Google (Recommended)' : 'Continue with Google',
                icon: Icons.g_mobiledata,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
