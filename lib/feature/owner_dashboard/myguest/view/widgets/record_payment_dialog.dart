// lib/features/owner_dashboard/myguest/view/widgets/record_payment_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../data/models/owner_guest_model.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';

/// Dialog for owners to record a new payment manually
class RecordPaymentDialog extends StatefulWidget {
  final OwnerGuestModel? guest;
  final OwnerBookingModel? booking;
  final List<OwnerGuestModel> guests;
  final List<OwnerBookingModel> bookings;

  const RecordPaymentDialog({
    this.guest,
    this.booking,
    required this.guests,
    required this.bookings,
    super.key,
  });

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();
  final _notesController = TextEditingController();

  OwnerGuestModel? _selectedGuest;
  OwnerBookingModel? _selectedBooking;
  String _selectedPaymentMethod = 'cash';
  DateTime _selectedDate = DateTime.now();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedGuest = widget.guest;
    _selectedBooking = widget.booking;
    if (widget.booking != null) {
      _selectedGuest = widget.guests.firstWhere(
        (g) => g.uid == widget.booking!.guestUid,
        orElse: () => _selectedGuest ?? widget.guests.first,
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isDark),
                const SizedBox(height: AppSpacing.paddingL),
                _buildGuestBookingSelection(context, isDark),
                const SizedBox(height: AppSpacing.paddingL),
                _buildPaymentDetailsForm(context, isDark),
                const SizedBox(height: AppSpacing.paddingL),
                _buildActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the dialog header
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Icon(
            Icons.payment,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingMedium(text: 'Record Payment'),
              CaptionText(
                text: 'Manually record a payment received from a guest',
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds guest and booking selection
  Widget _buildGuestBookingSelection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Guest & Booking'),
        const SizedBox(height: AppSpacing.paddingM),
        // Guest dropdown
        DropdownButtonFormField<OwnerGuestModel>(
          initialValue: _selectedGuest,
          decoration: const InputDecoration(
            labelText: 'Select Guest',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
          ),
          items: widget.guests.map((guest) {
            return DropdownMenuItem(
              value: guest,
              child: Text(guest.fullName),
            );
          }).toList(),
          onChanged: (guest) {
            setState(() {
              _selectedGuest = guest;
              _selectedBooking = null;
            });
          },
          validator: (value) {
            if (value == null) {
              return 'Please select a guest';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.paddingM),
        // Booking dropdown
        DropdownButtonFormField<OwnerBookingModel>(
          initialValue: _selectedBooking,
          decoration: const InputDecoration(
            labelText: 'Select Booking (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.book_online),
          ),
          items: widget.bookings
              .where((booking) => booking.guestUid == _selectedGuest?.uid)
              .map((booking) {
            return DropdownMenuItem(
              value: booking,
              child: Text(
                  '${booking.roomBedDisplay} - ${booking.formattedStartDate}'),
            );
          }).toList(),
          onChanged: _selectedGuest != null
              ? (booking) {
                  setState(() {
                    _selectedBooking = booking;
                  });
                }
              : null,
        ),
      ],
    );
  }

  /// Builds payment details form
  Widget _buildPaymentDetailsForm(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingSmall(text: 'Payment Details'),
        const SizedBox(height: AppSpacing.paddingM),
        // Amount
        TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            labelText: 'Payment Amount *',
            hintText: 'Enter amount in rupees',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.currency_rupee),
          ),
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter payment amount';
            }
            final amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
        const SizedBox(height: AppSpacing.paddingM),
        // Payment method
        DropdownButtonFormField<String>(
          initialValue: _selectedPaymentMethod,
          decoration: const InputDecoration(
            labelText: 'Payment Method *',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.payment),
          ),
          items: const [
            DropdownMenuItem(value: 'cash', child: Text('Cash')),
            DropdownMenuItem(value: 'upi', child: Text('UPI')),
            DropdownMenuItem(value: 'card', child: Text('Card')),
            DropdownMenuItem(
                value: 'bank_transfer', child: Text('Bank Transfer')),
          ],
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),
        const SizedBox(height: AppSpacing.paddingM),
        // Payment date
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              setState(() {
                _selectedDate = date;
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: BodyText(
                    text:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),
        // Transaction ID
        TextFormField(
          controller: _transactionIdController,
          decoration: const InputDecoration(
            labelText: 'Transaction ID (Optional)',
            hintText: 'Enter transaction ID or reference number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.receipt),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),
        // Notes
        TextFormField(
          controller: _notesController,
          decoration: const InputDecoration(
            labelText: 'Notes (Optional)',
            hintText: 'Any additional notes about this payment',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.note),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  /// Builds the action buttons
  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            label: 'Cancel',
            onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: PrimaryButton(
            label: _isSubmitting ? 'Recording...' : 'Record Payment',
            onPressed: _isSubmitting ? null : _submitPayment,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  /// Submits the payment record
  Future<void> _submitPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGuest == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a guest'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final viewModel =
          Provider.of<OwnerGuestViewModel>(context, listen: false);
      final ownerName = authProvider.user?.fullName ?? 'Owner';

      final amount = double.parse(_amountController.text.trim());
      final paymentId = DateTime.now().millisecondsSinceEpoch.toString();

      final payment = OwnerPaymentModel(
        id: paymentId,
        bookingId: _selectedBooking?.id ?? '',
        guestUid: _selectedGuest!.uid,
        pgId: _selectedBooking?.pgId ?? '',
        amountPaid: amount,
        status: 'collected',
        paymentMethod: _selectedPaymentMethod,
        date: _selectedDate,
        transactionId: _transactionIdController.text.trim().isEmpty
            ? null
            : _transactionIdController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        collectedBy: ownerName,
      );

      final success = await viewModel.createPayment(payment);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: success
                  ? 'Payment recorded successfully!'
                  : 'Failed to record payment',
              color: Colors.white,
            ),
            backgroundColor: success ? Colors.green : Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: 'Error recording payment: $e',
              color: Colors.white,
            ),
            backgroundColor: Colors.red,
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
