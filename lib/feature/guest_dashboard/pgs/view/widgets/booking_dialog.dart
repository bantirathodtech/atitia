// lib/features/guest_dashboard/pgs/view/widgets/booking_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../core/models/booking_model.dart';
import '../../../../../core/repositories/booking_repository.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../data/models/guest_pg_model.dart';
import '../../../../../feature/owner_dashboard/mypg/data/models/pg_floor_model.dart';
import '../../../../../feature/owner_dashboard/mypg/data/models/pg_room_model.dart';
import '../../../../../feature/owner_dashboard/mypg/data/models/pg_bed_model.dart';

/// 🏠 **BOOKING DIALOG - PRODUCTION READY**
///
/// **Features:**
/// - Select floor, room, and bed
/// - Show pricing and availability
/// - Confirm booking
/// - Premium UI with theme support
class BookingDialog extends StatefulWidget {
  final GuestPgModel pg;

  const BookingDialog({required this.pg, super.key});

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _bookingRepo = BookingRepository();
  PgFloorModel? _selectedFloor;
  PgRoomModel? _selectedRoom;
  PgBedModel? _selectedBed;
  DateTime? _startDate;
  bool _booking = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingSmall(
              text: 'Book a Bed',
              color: theme.primaryColor,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.pg.hasFlexibleStructure) ...[
                      _buildFloorSelector(context, isDarkMode),
                      if (_selectedFloor != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildRoomSelector(context, isDarkMode),
                      ],
                      if (_selectedRoom != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildBedSelector(context, isDarkMode),
                      ],
                      if (_selectedBed != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildStartDatePicker(context, isDarkMode),
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildBookingSummary(context, isDarkMode),
                      ],
                    ] else
                      _buildLegacyBookingMessage(context, isDarkMode),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _booking ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                ElevatedButton(
                  onPressed: _selectedBed != null && _startDate != null && !_booking
                      ? _confirmBooking
                      : null,
                  child: _booking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm Booking'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorSelector(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: 'Select Floor', color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          children: widget.pg.floorStructure.map((floor) {
            final isSelected = _selectedFloor?.floorId == floor.floorId;
            return ChoiceChip(
              label: Text(floor.floorName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFloor = selected ? floor : null;
                  _selectedRoom = null;
                  _selectedBed = null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoomSelector(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: 'Select Room', color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          children: _selectedFloor!.rooms.map((room) {
            final isSelected = _selectedRoom?.roomId == room.roomId;
            final availableBeds =
                room.beds.where((b) => b.status == 'vacant').length;
            
            return FilterChip(
              label: Text('${room.roomNumber} (${room.sharingType}-sharing) - $availableBeds available'),
              selected: isSelected,
              onSelected: availableBeds > 0
                  ? (selected) {
                      setState(() {
                        _selectedRoom = selected ? room : null;
                        _selectedBed = null;
                      });
                    }
                  : null,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBedSelector(BuildContext context, bool isDarkMode) {
    final vacantBeds = _selectedRoom!.beds.where((b) => b.status == 'vacant').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: 'Select Bed', color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          children: vacantBeds.map((bed) {
            final isSelected = _selectedBed?.bedId == bed.bedId;
            return ChoiceChip(
              label: Text('Bed ${bed.bedNumber}'),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedBed = selected ? bed : null;
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStartDatePicker(BuildContext context, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(text: 'Start Date', color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.paddingS),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              setState(() => _startDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                Text(
                  _startDate != null
                      ? DateFormat('MMM dd, yyyy').format(_startDate!)
                      : 'Select start date',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSummary(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(text: 'Booking Summary', color: AppColors.success),
          const SizedBox(height: AppSpacing.paddingS),
          _buildSummaryRow('Room', _selectedRoom!.roomNumber),
          _buildSummaryRow('Bed', 'Bed ${_selectedBed!.bedNumber}'),
          _buildSummaryRow('Sharing', '${_selectedRoom!.sharingType}-sharing'),
          _buildSummaryRow('Rent', '₹${_selectedRoom!.pricePerBed}/month'),
          _buildSummaryRow(
            'Start Date',
            _startDate != null ? DateFormat('MMM dd, yyyy').format(_startDate!) : 'Not selected',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CaptionText(text: label, color: AppColors.textSecondary),
          BodyText(text: value),
        ],
      ),
    );
  }

  Widget _buildLegacyBookingMessage(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: const BodyText(
        text: 'Please contact the owner directly to book this PG.',
        align: TextAlign.center,
      ),
    );
  }

  Future<void> _confirmBooking() async {
    setState(() => _booking = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final guestId = authProvider.user!.userId;
      
      final booking = BookingModel(
        bookingId: '${guestId}_${widget.pg.pgId}_${DateTime.now().millisecondsSinceEpoch}',
        guestId: guestId,
        ownerId: widget.pg.ownerUid,
        pgId: widget.pg.pgId,
        floorId: _selectedFloor!.floorId,
        roomId: _selectedRoom!.roomId,
        bedId: _selectedBed!.bedId,
        pgName: widget.pg.pgName,
        roomNumber: _selectedRoom!.roomNumber,
        bedNumber: _selectedBed!.bedNumber.toString(),
        sharingType: int.parse(_selectedRoom!.sharingType),
        rentPerMonth: _selectedRoom!.pricePerBed.toDouble(),
        securityDeposit: _selectedRoom!.pricePerBed.toDouble(), // 1 month deposit
        bookingDate: DateTime.now(),
        startDate: _startDate!,
      );

      await _bookingRepo.createBooking(booking);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking request sent! Owner will confirm shortly.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to book: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _booking = false);
      }
    }
  }

  void _sharePG(BuildContext context, pg) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }
}

