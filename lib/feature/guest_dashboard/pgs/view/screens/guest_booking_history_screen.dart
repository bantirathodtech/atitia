// lib/feature/guest_dashboard/pgs/view/screens/guest_booking_history_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/chips/status_chip.dart';
import '../../../../../core/models/booking_model.dart';
import '../../../../../core/repositories/booking_repository.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';

/// 🎨 **GUEST BOOKING HISTORY SCREEN - PRODUCTION READY**
///
/// Shows all bookings (confirmed, active, completed, cancelled) for the guest
class GuestBookingHistoryScreen extends StatefulWidget {
  const GuestBookingHistoryScreen({super.key});

  @override
  State<GuestBookingHistoryScreen> createState() =>
      _GuestBookingHistoryScreenState();
}

class _GuestBookingHistoryScreenState
    extends State<GuestBookingHistoryScreen> {
  final BookingRepository _repository = BookingRepository();
  List<BookingModel> _bookings = [];
  bool _loading = true;
  String? _error;
  String _selectedFilter = 'All'; // All, Active, Completed, Cancelled

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  void _loadBookings() {
    final firebaseAuthUser = firebase_auth.FirebaseAuth.instance.currentUser;
    final guestId = firebaseAuthUser?.uid;

    if (guestId == null || guestId.isEmpty) {
      setState(() {
        _error = _text('userNotAuthenticated',
            'User not authenticated. Please sign in again.');
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    _repository.streamGuestBookings(guestId).listen(
      (bookings) {
        if (mounted) {
          setState(() {
            _bookings = bookings;
            _loading = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.toString();
            _loading = false;
          });
        }
      },
    );
  }

  List<BookingModel> get _filteredBookings {
    if (_selectedFilter == 'All') return _bookings;

    return _bookings.where((booking) {
      switch (_selectedFilter) {
        case 'Active':
          return booking.status == 'active' || booking.status == 'confirmed';
        case 'Completed':
          return booking.status == 'completed' || booking.status == 'expired';
        case 'Cancelled':
          return booking.status == 'cancelled';
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: _text('bookingHistory', 'Booking History'),
        showBackButton: true,
        showDrawer: true,
      ),
      drawer: const GuestDrawer(),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(context, loc),
          // Bookings List
          Expanded(
            child: _buildBody(context, loc, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, AppLocalizations? loc) {
    final filters = ['All', 'Active', 'Completed', 'Cancelled'];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.paddingS),
              child: FilterChip(
                label: Text(
                  _getFilterLabel(filter, loc),
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                ),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedFilter = filter;
                    });
                  }
                },
                selectedColor: Theme.of(context).colorScheme.primary,
                checkmarkColor: Theme.of(context).colorScheme.onPrimary,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getFilterLabel(String filter, AppLocalizations? loc) {
    switch (filter) {
      case 'All':
        return loc?.all ?? _text('all', 'All');
      case 'Active':
        return loc?.active ?? _text('active', 'Active');
      case 'Completed':
        return loc?.completed ?? _text('completed', 'Completed');
      case 'Cancelled':
        return _text('cancelled', 'Cancelled');
      default:
        return filter;
    }
  }

  Widget _buildBody(
      BuildContext context, AppLocalizations? loc, ThemeData theme) {
    if (_loading && _bookings.isEmpty) {
      return const EnhancedLoadingState(type: LoadingType.centered);
    }

    if (_error != null) {
      return EmptyStates.error(
        context: context,
        message: _error,
        onRetry: _loadBookings,
      );
    }

    if (_filteredBookings.isEmpty) {
      return EnhancedEmptyState(
        title: _text('noBookingsFound', 'No Bookings'),
        message: _selectedFilter == 'All'
            ? _text('noBookingsFoundDescription',
                'You haven\'t made any bookings yet.')
            : _text('noBookingsFoundForFilter',
                'No bookings found for this filter.'),
        icon: Icons.book_outlined,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: _filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = _filteredBookings[index];
        return _buildBookingCard(context, booking, loc, theme);
      },
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking,
      AppLocalizations? loc, ThemeData theme) {
    return AdaptiveCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with PG Name and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HeadingSmall(
                    text: booking.pgName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StatusChip(
                  color: AppColors.getStatusColor(booking.status),
                  label: _getStatusLabel(booking.status, loc),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),

            // Room and Bed Info
            Row(
              children: [
                Icon(Icons.hotel, size: 16, color: theme.iconTheme.color),
                const SizedBox(width: AppSpacing.paddingXS),
                CaptionText(
                  text: _text('roomBedInfo',
                      'Room {room}, Bed {bed}',
                      parameters: {
                        'room': booking.roomNumber,
                        'bed': booking.bedNumber,
                      }),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Icon(Icons.people, size: 16, color: theme.iconTheme.color),
                const SizedBox(width: AppSpacing.paddingXS),
                CaptionText(
                  text: _text('sharingType',
                      '{type} Sharing',
                      parameters: {'type': booking.sharingType.toString()}),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),

            // Dates
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 16, color: theme.iconTheme.color),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: CaptionText(
                    text: _text('bookingDates',
                        'From {start} to {end}',
                        parameters: {
                          'start': DateFormat('MMM dd, yyyy')
                              .format(booking.startDate),
                          'end': booking.endDate != null
                              ? DateFormat('MMM dd, yyyy')
                                  .format(booking.endDate!)
                              : _text('ongoing', 'Ongoing'),
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),

            // Financial Info
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingS),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CaptionText(
                        text: _text('rentPerMonth', 'Rent/Month'),
                      ),
                      BodyText(
                        text: '₹${NumberFormat('#,##0').format(booking.rentPerMonth)}',
                        medium: true,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CaptionText(
                        text: _text('securityDeposit', 'Security Deposit'),
                      ),
                      BodyText(
                        text: '₹${NumberFormat('#,##0').format(booking.securityDeposit)}',
                        medium: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pending Dues (if any)
            if (booking.pendingDues != null && booking.pendingDues! > 0) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.statusOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  border: Border.all(
                    color: AppColors.statusOrange.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: AppColors.statusOrange, size: 20),
                    const SizedBox(width: AppSpacing.paddingXS),
                    Expanded(
                      child: BodyText(
                        text: _text('pendingDues',
                            'Pending Dues: ₹{amount}',
                            parameters: {
                              'amount': NumberFormat('#,##0')
                                  .format(booking.pendingDues),
                            }),
                        color: AppColors.statusOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Cancellation Info (if cancelled)
            if (booking.status == 'cancelled' &&
                booking.cancellationReason != null) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: _text('cancellationReason', 'Cancellation Reason'),
                      small: true,
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    CaptionText(
                      text: booking.cancellationReason ?? '',
                    ),
                    if (booking.cancellationDate != null) ...[
                      const SizedBox(height: AppSpacing.paddingXS),
                      CaptionText(
                        text: _text('cancelledOn',
                            'Cancelled on {date}',
                            parameters: {
                              'date': DateFormat('MMM dd, yyyy')
                                  .format(booking.cancellationDate!),
                            }),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getStatusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'active':
        return loc?.active ?? _text('active', 'Active');
      case 'confirmed':
        return _text('confirmed', 'Confirmed');
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      case 'completed':
        return loc?.completed ?? _text('completed', 'Completed');
      case 'expired':
        return _text('expired', 'Expired');
      case 'cancelled':
        return _text('cancelled', 'Cancelled');
      default:
        return status;
    }
  }
}

