// lib/features/guest_dashboard/pgs/view/widgets/booking_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../core/models/booking_model.dart';
import '../../../../../core/repositories/booking_repository.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

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
              text: loc?.bookBed ?? _text('bookBed', 'Book a Bed'),
              color: theme.primaryColor,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.pg.hasFlexibleStructure) ...[
                      _buildFloorSelector(context, isDarkMode, loc),
                      if (_selectedFloor != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildRoomSelector(context, isDarkMode, loc),
                      ],
                      if (_selectedRoom != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildBedSelector(context, isDarkMode, loc),
                      ],
                      if (_selectedBed != null) ...[
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildStartDatePicker(context, isDarkMode, loc),
                        const SizedBox(height: AppSpacing.paddingM),
                        _buildBookingSummary(context, isDarkMode, loc),
                      ],
                    ] else
                      _buildLegacyBookingMessage(context, isDarkMode, loc),
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
                  child: Text(loc?.cancel ?? _text('cancel', 'Cancel')),
                ),
                const SizedBox(width: AppSpacing.paddingS),
                PrimaryButton(
                  onPressed:
                      _selectedBed != null && _startDate != null && !_booking
                          ? _confirmBooking
                          : null,
                  label: loc?.confirmBooking ??
                      _text('confirmBooking', 'Confirm Booking'),
                  isLoading: _booking,
                  enabled:
                      _selectedBed != null && _startDate != null && !_booking,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloorSelector(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: loc?.selectFloor ?? _text('selectFloor', 'Select Floor'),
          color: AppColors.textSecondary,
        ),
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

  Widget _buildRoomSelector(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: loc?.selectRoom ?? _text('selectRoom', 'Select Room'),
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          children: _selectedFloor!.rooms.map((room) {
            final isSelected = _selectedRoom?.roomId == room.roomId;
            final availableBeds =
                room.beds.where((b) => b.status == 'vacant').length;

            return FilterChip(
              label: Text(loc?.roomOptionLabel(
                    room.roomNumber,
                    room.sharingType,
                    availableBeds,
                  ) ??
                  _text(
                    'roomOptionLabel',
                    '{roomNumber} ({sharingType}-sharing) - {availableBeds} available',
                    parameters: {
                      'roomNumber': room.roomNumber,
                      'sharingType': room.sharingType,
                      'availableBeds': availableBeds.toString(),
                    },
                  )),
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

  Widget _buildBedSelector(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    final vacantBeds =
        _selectedRoom!.beds.where((b) => b.status == 'vacant').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: loc?.selectBed ?? _text('selectBed', 'Select Bed'),
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Wrap(
          spacing: AppSpacing.paddingS,
          children: vacantBeds.map((bed) {
            final isSelected = _selectedBed?.bedId == bed.bedId;
            final label = loc?.bedLabel(bed.bedNumber) ??
                _text('bedLabel', 'Bed {bedNumber}',
                    parameters: {'bedNumber': bed.bedNumber.toString()});
            return ChoiceChip(
              label: Text(label),
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

  Widget _buildStartDatePicker(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: loc?.startDate ?? _text('startDate', 'Start Date'),
          color: AppColors.textSecondary,
        ),
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
              color: isDarkMode
                  ? AppColors.darkInputFill
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                Text(
                  _startDate != null
                      ? DateFormat('MMM dd, yyyy', loc?.localeName)
                          .format(_startDate!)
                      : loc?.selectStartDate ??
                          _text('selectStartDate', 'Select start date'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSummary(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.bookingSummary ??
                _text('bookingSummary', 'Booking Summary'),
            color: AppColors.success,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          _buildSummaryRow(
            loc?.room ?? _text('room', 'Room'),
            _selectedRoom!.roomNumber,
          ),
          _buildSummaryRow(
            loc?.bed ?? _text('bed', 'Bed'),
            loc?.bedLabel(_selectedBed!.bedNumber) ??
                _text('bedLabel', 'Bed {bedNumber}', parameters: {
                  'bedNumber': _selectedBed!.bedNumber.toString(),
                }),
          ),
          _buildSummaryRow(
            loc?.sharing ?? _text('sharing', 'Sharing'),
            '${_selectedRoom!.sharingType}-sharing',
          ),
          _buildSummaryRow(
            loc?.rent ?? _text('rent', 'Rent'),
            _text('monthlyRentDisplay', '₹{amount}/month',
                parameters: {'amount': _selectedRoom!.pricePerBed.toString()}),
          ),
          _buildSummaryRow(
            loc?.startDate ?? _text('startDate', 'Start Date'),
            _startDate != null
                ? DateFormat('MMM dd, yyyy', loc?.localeName)
                    .format(_startDate!)
                : loc?.notSelected ?? _text('notSelected', 'Not selected'),
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

  Widget _buildLegacyBookingMessage(
      BuildContext context, bool isDarkMode, AppLocalizations? loc) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: BodyText(
        text: loc?.legacyBookingMessage ??
            _text('legacyBookingMessage',
                'Please contact the owner directly to book this PG.'),
        align: TextAlign.center,
      ),
    );
  }

  Future<void> _confirmBooking() async {
    setState(() => _booking = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final guestId = authProvider.user!.userId;
      final loc = AppLocalizations.of(context);

      final booking = BookingModel(
        bookingId:
            '${guestId}_${widget.pg.pgId}_${DateTime.now().millisecondsSinceEpoch}',
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
        securityDeposit:
            _selectedRoom!.pricePerBed.toDouble(), // 1 month deposit
        bookingDate: DateTime.now(),
        startDate: _startDate!,
      );

      await _bookingRepo.createBooking(booking);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc?.bookingRequestSuccess ??
                  _text('bookingRequestSuccess',
                      'Booking request sent! Owner will confirm shortly.'),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc?.bookingRequestFailed(e.toString()) ??
                  _text('bookingRequestFailed', 'Failed to book: {error}',
                      parameters: {'error': e.toString()}),
            ),
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

  // void _sharePG(BuildContext context, pg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Share feature coming soon!')),
  //   );
  // }
}
