// ============================================================================
// Booking Request Dialog - Dialog for Guests to Request Joining a PG
// ============================================================================
// Provides a comprehensive dialog for guests to send booking requests to PG owners
// Includes form validation, contact information, and optional message
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/guest_pg_model.dart';
import '../../../shared/viewmodel/guest_pg_selection_provider.dart';

/// Dialog for guests to send booking requests to PG owners
class BookingRequestDialog extends StatefulWidget {
  final GuestPgModel pg;

  const BookingRequestDialog({
    super.key,
    required this.pg,
  });

  @override
  State<BookingRequestDialog> createState() => _BookingRequestDialogState();
}

class _BookingRequestDialogState extends State<BookingRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  bool _isSubmitting = false;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Loads current user data into the form
  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _nameController.text = user.fullName ?? '';
      _phoneController.text = user.phoneNumber;
      _emailController.text = user.email ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isDark),
            const SizedBox(height: AppSpacing.paddingL),
            _buildPgInfo(context, isDark, loc),
            const SizedBox(height: AppSpacing.paddingL),
            _buildForm(context, isDark, loc),
            const SizedBox(height: AppSpacing.paddingL),
            _buildActions(context, loc),
          ],
        ),
      ),
    );
  }

  /// Builds the dialog header
  Widget _buildHeader(BuildContext context, bool isDark) {
    final loc = AppLocalizations.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Icon(
            Icons.home_work,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(
                text: loc?.requestToJoinPg ??
                    _text('requestToJoinPg', 'Request to Join PG'),
              ),
              CaptionText(
                text: loc?.sendBookingRequestToOwner ??
                    _text('sendBookingRequestToOwner',
                        'Send a booking request to the owner'),
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds PG information section
  Widget _buildPgInfo(
    BuildContext context,
    bool isDark,
    AppLocalizations? loc,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.apartment,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: HeadingSmall(
                  text: widget.pg.pgName,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[600],
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: BodyText(
                  text: widget.pg.fullAddress,
                  color: isDark ? Colors.white70 : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              BodyText(
                text: _buildMonthlyRentText(loc),
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildMonthlyRentText(AppLocalizations? loc) {
    final monthly = widget.pg.pricing?['monthly'];
    if (monthly == null) {
      return loc?.notAvailable ?? _text('notAvailable', 'N/A');
    }
    final amountString = monthly.toString();
    return loc?.monthlyRentDisplay(amountString) ??
        _text('monthlyRentDisplay', '₹{amount}/month',
            parameters: {'amount': amountString});
  }

  /// Builds the booking request form
  Widget _buildForm(
    BuildContext context,
    bool isDark,
    AppLocalizations? loc,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.contactInformation ??
                _text('contactInformation', 'Contact Information'),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: loc?.fullName ?? _text('fullName', 'Full Name'),
              hintText: loc?.enterYourCompleteName ??
                  _text('enterYourCompleteName', 'Enter your full name'),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc?.pleaseEnterYourName ??
                    _text('pleaseEnterYourName', 'Please enter your name');
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText:
                  loc?.phoneNumber ?? _text('phoneNumber', 'Phone Number'),
              hintText: loc?.enterYourPhoneNumber ??
                  _text('enterYourPhoneNumber', 'Enter your phone number'),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc?.pleaseEnterYourPhoneNumber ??
                    _text('pleaseEnterYourPhoneNumber',
                        'Please enter your phone number');
              }
              if (value.length < 10) {
                return loc?.pleaseEnterValidPhoneNumber ??
                    _text('pleaseEnterValidPhoneNumber',
                        'Please enter a valid phone number');
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: loc?.email ?? _text('email', 'Email'),
              hintText: loc?.enterYourEmailAddress ??
                  _text('enterYourEmailAddress', 'Enter your email address'),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return loc?.pleaseEnterYourEmailAddress ??
                    _text('pleaseEnterYourEmailAddress',
                        'Please enter your email address');
              }
              if (!value.contains('@')) {
                return loc?.pleaseEnterValidEmailAddress ??
                    _text('pleaseEnterValidEmailAddress',
                        'Please enter a valid email address');
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextFormField(
            controller: _messageController,
            decoration: InputDecoration(
              labelText: loc?.messageOptional ??
                  _text('messageOptional', 'Message (Optional)'),
              hintText: loc?.messageOptionalHint ??
                  _text('messageOptionalHint',
                      'Any additional information for the owner...'),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Builds the dialog action buttons
  Widget _buildActions(BuildContext context, AppLocalizations? loc) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: loc?.cancel ?? _text('cancel', 'Cancel'),
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            label: _isSubmitting
                ? loc?.sending ?? _text('sending', 'Sending...')
                : loc?.sendRequest ?? _text('sendRequest', 'Send Request'),
            onPressed: _isSubmitting ? null : _submitBookingRequest,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  /// Submits the booking request
  Future<void> _submitBookingRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final loc = AppLocalizations.of(context);
      final guestPgProvider =
          Provider.of<GuestPgSelectionProvider>(context, listen: false);

      await guestPgProvider.sendBookingRequest(
        widget.pg,
        guestName: _nameController.text.trim(),
        guestPhone: _phoneController.text.trim(),
        guestEmail: _emailController.text.trim(),
        message: _messageController.text.trim().isEmpty
            ? null
            : _messageController.text.trim(),
      );

      if (!mounted) return;

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc?.bookingRequestSuccess ??
                _text(
                  'bookingRequestSuccess',
                  'Booking request sent! Owner will confirm shortly.',
                ),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            loc?.bookingRequestFailed(e.toString()) ??
                _text(
                  'bookingRequestFailed',
                  'Failed to book: {error}',
                  parameters: {'error': e.toString()},
                ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
