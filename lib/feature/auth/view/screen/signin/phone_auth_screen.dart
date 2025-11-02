// lib/features/auth/view/screen/phone_auth_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'platform_helper.dart';
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

/// Helper function to check if running on macOS (web-safe)
/// Returns false on web, true only on actual macOS desktop
/// Uses platform_helper.dart for safe Platform detection
bool get _isMacOS => isMacOSSafe;

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _phoneError;
  String? _otpError;

  bool _otpSent = false;
  bool _loading = false;

  /// Check if we're on macOS (safe for web)
  bool get _isMacOS {
    if (kIsWeb) return false;
    try {
      // Use foundation's platform detection which is web-safe
      return !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
    } catch (e) {
      return false;
    }
  }

  /// Check if phone authentication is available
  bool get _isPhoneAuthAvailable {
    return kIsWeb || !_isMacOS;
  }

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
      // Add timeout protection with longer timeout for web
      await Future.any([
        authProvider.sendOTP(
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
                  content: BodyText(
                      text: 'OTP sent successfully! Please check your phone.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          (error) {
            // OTP sending failed
            if (mounted) {
              setState(() => _loading = false);

              // Show user-friendly error message
              String errorMessage = 'Failed to send OTP. Please try again.';
              if (error.code == 'too-many-requests') {
                errorMessage =
                    'Too many requests. Please wait a few minutes before trying again.';
              } else if (error.code == 'invalid-phone-number') {
                errorMessage = 'Please enter a valid 10-digit phone number.';
              } else if (error.code == 'quota-exceeded') {
                errorMessage =
                    'SMS service temporarily unavailable. Please try again later.';
              } else if (error.code == 'captcha-check-failed') {
                errorMessage =
                    'Security verification failed. Please try again.';
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: BodyText(text: errorMessage),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
        ),
        Future.delayed(Duration(seconds: 30), () {
          if (mounted && _loading) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: BodyText(text: 'Request timed out. Please try again.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }),
      ]);
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
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
      // Web platform requires special handling
      if (kIsWeb) {
        // For web, we need to show a message that Google Sign-In requires the button widget
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: BodyText(
                text:
                    'Google Sign-In on web requires the sign-in button. Please use the Google Sign-In button above.',
              ),
              backgroundColor: Colors.blue,
              duration: Duration(seconds: 5),
            ),
          );
        }
        setState(() => _loading = false);
        return;
      }

      // Add timeout protection
      await Future.any([
        authProvider.signInWithGoogle(),
        Future.delayed(Duration(seconds: 30), () {
          if (mounted && _loading) {
            setState(() => _loading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: BodyText(
                    text: 'Google Sign-In timed out. Please try again.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }),
      ]);
      // Navigation is handled in AuthProvider
      if (mounted) {
        setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Google Sign-In failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
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
      await authProvider.verifyOTPAndSignIn(_otpController.text.trim());

      if (!mounted) return;

      final navigation = getIt<NavigationService>();
<<<<<<< HEAD
      
      if (!isExistingUser) {
        // New user - navigate to registration
        navigation.goToRegistration();
=======

      // If provider set an error (e.g., role mismatch), show it and return to role selection
      if (authProvider.error) {
        setState(() => _loading = false);
        final msg = authProvider.errorMessage ??
            'Authentication failed. Please select the correct role.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: msg),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        navigation.goToRoleSelection();
>>>>>>> temp-stash-apply
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

      // STRICT: Navigate to dashboard based on role - NO FALLBACK
      final userRole = user.role.toLowerCase().trim();

      if (userRole == 'owner') {
        debugPrint(
            '✅ Phone Auth: Role is owner - navigating to owner dashboard');
        navigation.goToOwnerHome();
      } else if (userRole == 'guest') {
        debugPrint(
            '✅ Phone Auth: Role is guest - navigating to guest dashboard');
        navigation.goToGuestHome();
      } else {
        // Invalid role - redirect to role selection
        debugPrint(
            '⚠️ Phone Auth: Invalid role "$userRole" - redirecting to role selection');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  BodyText(text: 'Invalid user role. Please select a role.'),
              backgroundColor: Colors.red,
            ),
          );
          navigation.goToRoleSelection();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: 'Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handles Google sign-in
<<<<<<< HEAD
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
=======
  // Future<void> _handleGoogleSignIn() async {
  //   setState(() => _loading = true);

  //   try {
  //     await context.read<AuthProvider>().signInWithGoogle();

  //     if (!mounted) return;

  //     // Navigation is handled in AuthProvider.signInWithGoogle()
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: BodyText(text: 'Google sign-in failed: ${e.toString()}'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() => _loading = false);
  //     }
  //   }
  // }
>>>>>>> temp-stash-apply

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
<<<<<<< HEAD
              
              // Phone input field - Disabled on macOS
              if (!_isMacOS) ...[
=======

              // Phone input field - Available on web and mobile, disabled on macOS
              if (_isPhoneAuthAvailable) ...[
>>>>>>> temp-stash-apply
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
              ] else if (_isMacOS) ...[
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
<<<<<<< HEAD
              if (_otpSent && !_isMacOS) ...[
=======
              if (_otpSent && _isPhoneAuthAvailable) ...[
>>>>>>> temp-stash-apply
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
<<<<<<< HEAD
              if (!_isMacOS) ...[
=======
              if (_isPhoneAuthAvailable) ...[
>>>>>>> temp-stash-apply
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
<<<<<<< HEAD
              if (_otpSent && !_isMacOS) ...[
=======
              if (_otpSent && _isPhoneAuthAvailable) ...[
>>>>>>> temp-stash-apply
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
<<<<<<< HEAD
              if (!_isMacOS) ...[
=======
              if (_isPhoneAuthAvailable) ...[
>>>>>>> temp-stash-apply
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
<<<<<<< HEAD
              
              // Google sign-in - Prominent for macOS
=======

              // Google sign-in - Available for all platforms
>>>>>>> temp-stash-apply
              if (_isMacOS) ...[
                const SizedBox(height: AppSpacing.md),
                const CaptionText(
                  text: 'Phone OTP is not available on macOS. Please use Google Sign-In:',
                  align: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
<<<<<<< HEAD
              PrimaryButton(
                onPressed: _loading ? null : _signInWithGoogle,
                label: _isMacOS ? 'Sign in with Google (Recommended)' : 'Continue with Google',
                icon: Icons.g_mobiledata,
              ),
=======
              // Google Sign-In - Platform specific implementation
              if (kIsWeb) ...[
                // Web platform requires the Google Sign-In button widget
                const SizedBox(height: AppSpacing.md),
                const CaptionText(
                  text: 'Sign in with Google using the button below:',
                  align: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                // Get the Google Sign-In button widget for web
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    final googleSignInButton =
                        authProvider.getGoogleSignInButton();
                    if (googleSignInButton != null) {
                      return googleSignInButton;
                    } else {
                      return const CaptionText(
                        text: 'Google Sign-In not available on this platform',
                        align: TextAlign.center,
                      );
                    }
                  },
                ),
              ] else ...[
                // Mobile/Desktop platforms use the regular button
                PrimaryButton(
                  onPressed: _loading ? null : _signInWithGoogle,
                  label: _isMacOS
                      ? 'Sign in with Google (Recommended)'
                      : 'Continue with Google',
                  icon: Icons.g_mobiledata,
                ),
              ],
>>>>>>> temp-stash-apply
            ],
          ),
        ),
      ),
    );
  }
}
