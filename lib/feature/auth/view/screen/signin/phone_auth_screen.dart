// lib/features/auth/view/screen/phone_auth_screen.dart
import 'package:flutter/foundation.dart';
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
  String? _validatePhone(String value, BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return null;
    
    if (value.trim().isEmpty) {
      return loc.phoneNumberIsRequired;
    }
    if (!RegExp(ValidationConstants.phoneRegex).hasMatch(value.trim())) {
      return loc.pleaseEnterValid10DigitPhoneNumber;
    }
    return null;
  }

  /// Validates OTP
  String? _validateOTP(String value, BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) return null;
    
    if (value.trim().isEmpty) {
      return loc.otpIsRequired;
    }
    if (value.trim().length != 6) {
      return loc.otpMustBe6Digits;
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value.trim())) {
      return loc.otpMustContainOnlyDigits;
    }
    return null;
  }

  /// Sends OTP to provided phone number
  Future<void> _sendOTP() async {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;
    
    // Validate phone number
    final phoneErr = _validatePhone(_phoneController.text.trim(), context);
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
              final loc = AppLocalizations.of(context);
              if (loc == null) return;
              
              setState(() {
                _otpSent = true;
                _loading = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: BodyText(
                      text: loc.otpSentSuccessfullyPleaseCheckYourPhone),
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
              final loc = AppLocalizations.of(context);
              if (loc == null) return;
              
              String errorMessage = loc.failedToSendOtpPleaseTryAgain;
              if (error.code == 'too-many-requests') {
                errorMessage = loc.tooManyRequestsPleaseWaitFewMinutes;
              } else if (error.code == 'invalid-phone-number') {
                errorMessage = loc.pleaseEnterValid10DigitPhoneNumber;
              } else if (error.code == 'quota-exceeded') {
                errorMessage = loc.smsServiceTemporarilyUnavailable;
              } else if (error.code == 'captcha-check-failed') {
                errorMessage = loc.securityVerificationFailedPleaseTryAgain;
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
              SnackBar(
                content: BodyText(text: loc.requestTimedOutPleaseTryAgain),
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
            content: BodyText(text: loc.error(e.toString())),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Verifies OTP and navigates to appropriate screen
  Future<void> _verifyOTP() async {
    final loc = AppLocalizations.of(context)!;
    
    // Validate OTP
    final otpErr = _validateOTP(_otpController.text.trim(), context);
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

      // If provider set an error (e.g., role mismatch), show it and return to role selection
      if (authProvider.error) {
        setState(() => _loading = false);
        final msg = authProvider.errorMessage ??
            loc.authenticationFailedPleaseSelectCorrectRole;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: msg),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        navigation.goToRoleSelection();
        return;
      }

      // Existing user - check role and navigate accordingly
      final user = authProvider.user;
      if (user == null) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: loc.userDataNotFound),
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
            SnackBar(
              content: BodyText(text: loc.invalidUserRolePleaseSelectRole),
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
            content: BodyText(text: loc.verificationFailed(e.toString())),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Handles Google sign-in
  Future<void> _handleGoogleSignIn() async {
    final loc = AppLocalizations.of(context);
    if (loc == null) return;
    
    setState(() => _loading = true);
    
    try {
      await context.read<AuthProvider>().signInWithGoogle();
      
      if (!mounted) return;
      
      // Navigation is handled in AuthProvider.signInWithGoogle()
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(text: loc.googleSignInFailedError(e.toString())),
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
        title: role != null ? loc.loginAs(role) : loc.login,
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
                text: role != null ? loc.loginAs(role) : loc.login,
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              
              // Subtitle
              CaptionText(
                text: loc.enterPhoneNumberToReceiveOTP,
                align: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // Phone input field - Available on web and mobile, disabled on macOS
              if (_isPhoneAuthAvailable) ...[
                TextInput(
                  controller: _phoneController,
                  label: loc.phoneNumber,
                  hint: loc.tenDigitMobileNumber,
                  prefixIcon: const Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                  enabled: !_otpSent && !_loading,
                  error: _phoneError,
                  maxLength: 10,
                  onChanged: (v) {
                    setState(() {
                      _phoneError = _validatePhone(v, context);
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
                              loc.phoneAuthentication,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              loc.notAvailableOnMacOS,
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
              if (_otpSent && _isPhoneAuthAvailable) ...[
                const SizedBox(height: AppSpacing.lg),
                TextInput(
                  controller: _otpController,
                  label: loc.enterOTP,
                  hint: loc.sixDigitCode,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  error: _otpError,
                  prefixIcon: const Icon(Icons.security),
                  onChanged: (v) {
                    setState(() {
                      _otpError = _validateOTP(v, context);
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                CaptionText(
                  text: loc.pleaseEnterSixDigitCode,
                  align: TextAlign.center,
                ),
              ],
              
              const SizedBox(height: AppSpacing.xl),
              
              // Action button (Send OTP / Verify) - Not available on macOS
              if (_isPhoneAuthAvailable) ...[
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
              if (_otpSent && _isPhoneAuthAvailable) ...[
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
                  label: loc.changeNumber,
                  icon: Icons.edit,
                ),
              ],
              
              const SizedBox(height: AppSpacing.lg),
              
              // Divider - Only show when both methods are available
              if (_isPhoneAuthAvailable) ...[
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: CaptionText(
                        text: loc.or,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              // Google sign-in - Available for all platforms
              if (_isMacOS) ...[
                const SizedBox(height: AppSpacing.md),
                CaptionText(
                  text: loc.notAvailableOnMacOS,
                  align: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
              PrimaryButton(
                onPressed: _loading ? null : _handleGoogleSignIn,
                label: loc.googleSignIn,
                icon: Icons.g_mobiledata,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
