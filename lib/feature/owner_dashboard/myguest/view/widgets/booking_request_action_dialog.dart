// lib/features/owner_dashboard/myguest/view/widgets/booking_request_action_dialog.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/owner_booking_request_model.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';

/// Dialog for approving or rejecting booking requests
class BookingRequestActionDialog extends StatefulWidget {
  final OwnerBookingRequestModel request;
  final bool isApproval;

  const BookingRequestActionDialog({
    required this.request,
    required this.isApproval,
    super.key,
  });

  @override
  State<BookingRequestActionDialog> createState() =>
      _BookingRequestActionDialogState();
}

class _BookingRequestActionDialogState
    extends State<BookingRequestActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _responseController = TextEditingController();
  final _roomNumberController = TextEditingController();
  final _bedNumberController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Set default dates for approval
    if (widget.isApproval) {
      _startDate = DateTime.now();
      _endDate = DateTime.now().add(const Duration(days: 30));
    }
  }

  @override
  void dispose() {
    _responseController.dispose();
    _roomNumberController.dispose();
    _bedNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, loc),
            const SizedBox(height: AppSpacing.paddingL),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRequestInfo(context, loc),
                    const SizedBox(height: AppSpacing.paddingL),
                    _buildForm(context, loc),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildActions(context, loc),
          ],
        ),
      ),
    );
  }

  /// Builds the dialog header
  Widget _buildHeader(BuildContext context, AppLocalizations? loc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: widget.isApproval
                ? AppColors.success.withValues(alpha: 0.1)
                : context.decorativeRed.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Icon(
            widget.isApproval ? Icons.check_circle : Icons.cancel,
            color:
                widget.isApproval ? AppColors.success : context.decorativeRed,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(
                text: widget.isApproval
                    ? (loc?.approveBookingRequestTitle ??
                        'Approve Booking Request')
                    : (loc?.rejectBookingRequestTitle ??
                        'Reject Booking Request'),
                color: Theme.of(context).textTheme.titleLarge?.color ??
                    Theme.of(context).colorScheme.onSurface,
              ),
              CaptionText(
                text: widget.isApproval
                    ? (loc?.approveBookingRequestSubtitle ??
                        'Approve this guest\'s request to join your PG')
                    : (loc?.rejectBookingRequestSubtitle ??
                        'Reject this guest\'s request to join your PG'),
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds request information section
  Widget _buildRequestInfo(BuildContext context, AppLocalizations? loc) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: HeadingSmall(
                  text: widget.request.guestDisplayName,
                  color: Theme.of(context).textTheme.titleLarge?.color ??
                      Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              BodyText(
                text:
                    '${loc?.contactNumberLabel ?? 'Contact Number'}: ${widget.request.guestPhone}',
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Row(
            children: [
              Icon(
                Icons.email,
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              BodyText(
                text:
                    '${loc?.emailLabel ?? 'Email'}: ${widget.request.guestEmail}',
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.apartment,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: BodyText(
                  text: '${loc?.pgLabel ?? 'PG'}: ${widget.request.pgName}',
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the form for response and additional details
  Widget _buildForm(BuildContext context, AppLocalizations? loc) {
    final dateFormat = DateFormat.yMMMd(loc?.localeName);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: widget.isApproval
                ? (loc?.approvalDetails ?? 'Approval Details')
                : (loc?.rejectionDetails ?? 'Rejection Details'),
            color: Theme.of(context).textTheme.titleLarge?.color ??
                Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Response message
          TextInput(
            controller: _responseController,
            label: widget.isApproval
                ? (loc?.welcomeMessageOptional ?? 'Welcome Message (Optional)')
                : (loc?.rejectionReasonOptional ??
                    'Reason for Rejection (Optional)'),
            hint: widget.isApproval
                ? (loc?.welcomeMessageHint ??
                    'Add a welcome message for the guest...')
                : (loc?.rejectionReasonHintDetailed ??
                    'Explain why the request is being rejected...'),
            maxLines: 3,
          ),

          // Additional fields for approval
          if (widget.isApproval) ...[
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _roomNumberController,
              label: loc?.roomNumberLabel ?? 'Room Number *',
              hint: loc?.enterRoomNumberHint ?? 'Enter room number...',
              prefixIcon: const Icon(Icons.door_front_door),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: _bedNumberController,
              label: loc?.bedNumberLabel ?? 'Bed Number *',
              hint: loc?.enterBedNumberHint ?? 'Enter bed number...',
              prefixIcon: const Icon(Icons.bed),
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Date selection
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaptionText(
                        text: loc?.startDateLabel ?? 'Start Date',
                      ),
                      const SizedBox(height: AppSpacing.paddingXS),
                      InkWell(
                        onTap: _selectStartDate,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.paddingM),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.borderRadiusS),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: AppSpacing.paddingS),
                              Expanded(
                                child: BodyText(
                                  text: _startDate != null
                                      ? dateFormat.format(_startDate!)
                                      : (loc?.selectStartDate ??
                                          'Select start date'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaptionText(
                        text: loc?.endDateLabel ?? 'End Date',
                      ),
                      const SizedBox(height: AppSpacing.paddingXS),
                      InkWell(
                        onTap: _selectEndDate,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.paddingM),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.borderRadiusS),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              const SizedBox(width: AppSpacing.paddingS),
                              Expanded(
                                child: BodyText(
                                  text: _endDate != null
                                      ? dateFormat.format(_endDate!)
                                      : (loc?.selectEndDate ??
                                          'Select end date'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Builds the action buttons
  Widget _buildActions(BuildContext context, AppLocalizations? loc) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: loc?.cancel ?? 'Cancel',
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            label: _isSubmitting
                ? (widget.isApproval
                    ? (loc?.approving ?? 'Approving...')
                    : (loc?.rejecting ?? 'Rejecting...'))
                : (widget.isApproval
                    ? (loc?.approveRequest ?? 'Approve Request')
                    : (loc?.rejectRequest ?? 'Reject Request')),
            onPressed: _isSubmitting ? null : _submitAction,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  /// Selects start date
  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        // Auto-adjust end date if it's before start date
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = date.add(const Duration(days: 30));
        }
      });
    }
  }

  /// Selects end date
  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ??
          (_startDate ?? DateTime.now()).add(const Duration(days: 30)),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  /// Submits the approval or rejection
  Future<void> _submitAction() async {
    final loc = AppLocalizations.of(context);

    // Validate form (will pass if no validators are set)
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final viewModel =
          Provider.of<OwnerGuestViewModel>(context, listen: false);

      if (widget.isApproval) {
        // Validate room and bed numbers for approval
        if (_roomNumberController.text.trim().isEmpty ||
            _bedNumberController.text.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc?.roomBedNumbersRequired ??
                  'Room and bed numbers are required for approval'),
              backgroundColor: AppColors.warning,
            ),
          );
          setState(() => _isSubmitting = false);
          return;
        }

        await viewModel.approveBookingRequest(
          widget.request.requestId,
          responseMessage: _responseController.text.trim().isEmpty
              ? null
              : _responseController.text.trim(),
          roomNumber: _roomNumberController.text.trim(),
          bedNumber: _bedNumberController.text.trim(),
          startDate: _startDate,
          endDate: _endDate,
        );
      } else {
        await viewModel.rejectBookingRequest(
          widget.request.requestId,
          responseMessage: _responseController.text.trim().isEmpty
              ? null
              : _responseController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: widget.isApproval
                  ? (loc?.bookingRequestApprovedSuccess ??
                      'Booking request approved successfully!')
                  : (loc?.bookingRequestRejectedSuccess ??
                      'Booking request rejected successfully!'),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor:
                widget.isApproval ? AppColors.success : context.decorativeRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final actionLabel = widget.isApproval
            ? (loc?.approveAction ?? 'approve')
            : (loc?.rejectAction ?? 'reject');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: loc?.bookingRequestActionFailed(
                      actionLabel, e.toString()) ??
                  'Failed to ${widget.isApproval ? 'approve' : 'reject'} request: $e',
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
