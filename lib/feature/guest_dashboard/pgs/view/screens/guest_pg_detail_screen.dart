// lib/features/guest_dashboard/pgs/view/screens/guest_pg_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../viewmodel/guest_pg_viewmodel.dart';
import '../widgets/guest_amenities_list.dart';
import '../widgets/guest_photo_gallery.dart';

/// Screen displaying detailed information about a selected PG
/// Uses GuestPgViewModel for data management and state
/// Provides comprehensive PG details, amenities, photos, and bank information
class GuestPgDetailScreen extends StatefulWidget {
  final String pgId;

  const GuestPgDetailScreen({
    super.key,
    required this.pgId,
  });

  @override
  State<GuestPgDetailScreen> createState() => _GuestPgDetailScreenState();
}

class _GuestPgDetailScreenState extends State<GuestPgDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pgVM = Provider.of<GuestPgViewModel>(context, listen: false);
      if (pgVM.selectedPG == null || pgVM.selectedPG!.pgId != widget.pgId) {
        pgVM.getPGById(widget.pgId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pgVM = Provider.of<GuestPgViewModel>(context);
    final pg = pgVM.selectedPG;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: pg?.pgName ?? 'PG Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePG(context, pg),
          ),
        ],
      ),
      body: _buildBody(context, pgVM, pg),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, GuestPgViewModel pgVM, pg) {
    if (pgVM.loading && pg == null) {
      return Center(child: AdaptiveLoader());
    }

    if (pgVM.error && pg == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingMedium(
              text: 'Error loading PG details',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: pgVM.errorMessage ?? 'Unknown error occurred',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () {
                pgVM.clearError();
                pgVM.getPGById(widget.pgId);
              },
              label: 'Try Again',
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (pg == null) {
      return EmptyState(
        title: 'PG Not Found',
        message:
            'The requested PG could not be found or may have been removed.',
        icon: Icons.apartment,
        actionLabel: 'Go Back',
        onAction: () => getIt<NavigationService>().goBack(),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPGHeader(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildBasicInfoSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildSpecificationsSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildAmenitiesSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPhotosSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildBankDetailsSection(context, pg),
        ],
      ),
    );
  }

  /// Builds PG header with main information
  Widget _buildPGHeader(BuildContext context, pg) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingLarge(
            text: pg.pgName,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: BodyText(
                  text: pg.fullAddress,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(
                Icons.apartment,
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              BodyText(
                text: '${pg.totalRooms} rooms • ${pg.totalBeds} beds',
                color: Colors.grey.shade600,
              ),
            ],
          ),
          if (pg.hasPricing) ...[
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Icon(
                  Icons.attach_money,
                  size: 16,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 4),
                BodyText(
                  text: pg.formattedPricing,
                  color: Colors.green.shade600,
                  // bold: true,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Builds basic PG information section
  Widget _buildBasicInfoSection(BuildContext context, pg) {
    return _buildSection(
      context,
      'Basic Information',
      Icons.info_outline,
      [
        _buildInfoRow('Address', pg.address),
        _buildInfoRow('City', pg.city),
        _buildInfoRow('Area', pg.area),
        _buildInfoRow('State', pg.state),
        if (pg.description != null)
          _buildInfoRow('Description', pg.description!),
      ],
    );
  }

  /// Builds PG specifications section
  Widget _buildSpecificationsSection(BuildContext context, pg) {
    return _buildSection(
      context,
      'Specifications',
      Icons.architecture,
      [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSpecItem('Floors', '${pg.floors}', Icons.stairs),
              _buildSpecItem(
                  'Rooms/Floor', '${pg.roomsPerFloor}', Icons.door_front_door),
              _buildSpecItem('Beds/Room', '${pg.bedsPerRoom}', Icons.hotel),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),
        _buildInfoRow('Total Rooms', '${pg.totalRooms}'),
        _buildInfoRow('Total Beds', '${pg.totalBeds}'),
      ],
    );
  }

  /// Builds amenities section with interactive list
  Widget _buildAmenitiesSection(BuildContext context, pg) {
    return _buildSection(
      context,
      'Amenities',
      Icons.room_service,
      [
        if (pg.hasAmenities)
          GuestAmenitiesList(amenities: pg.amenities)
        else
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600),
                const SizedBox(width: AppSpacing.paddingS),
                BodyText(
                  text: 'No amenities listed for this PG',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Builds photos gallery section
  Widget _buildPhotosSection(BuildContext context, pg) {
    return _buildSection(
      context,
      'Photos',
      Icons.photo_library,
      [
        if (pg.hasPhotos)
          GuestPhotoGallery(photos: pg.photos)
        else
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.photo_library_outlined,
                    size: 48, color: Colors.grey.shade400),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: 'No photos available for this PG',
                  color: Colors.grey.shade600,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Builds bank details section with secure information display
  Widget _buildBankDetailsSection(BuildContext context, pg) {
    return _buildSection(
      context,
      'Payment Information',
      Icons.account_balance,
      [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildInfoRow('Account Holder',
                  pg.bankDetails['accountHolderName'] ?? 'N/A'),
              _buildInfoRow(
                  'Account Number', pg.bankDetails['accountNumber'] ?? 'N/A'),
              _buildInfoRow('IFSC Code', pg.bankDetails['IFSC'] ?? 'N/A'),
              _buildInfoRow('UPI ID', pg.bankDetails['UPI'] ?? 'N/A'),
            ],
          ),
        ),

        // QR Code Display
        if (pg.bankDetails['QRCodeUrl'] != null) ...[
          const SizedBox(height: AppSpacing.paddingM),
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                HeadingMedium(text: 'QR Code for Payments'),
                const SizedBox(height: AppSpacing.paddingS),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AdaptiveImage(
                      imageUrl: pg.bankDetails['QRCodeUrl']!,
                      height: 150,
                      width: 150,
                      placeholder: Column(
                        children: [
                          Icon(Icons.qr_code, size: 50, color: Colors.grey),
                          const SizedBox(height: 8),
                          CaptionText(text: 'Loading QR Code...'),
                        ],
                      ),
                      errorWidget: Column(
                        children: [
                          Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                          const SizedBox(height: 8),
                          CaptionText(text: 'QR Code not available'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// Builds a section with title and content
  Widget _buildSection(BuildContext context, String title, IconData icon,
      List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.paddingS),
            HeadingMedium(
              text: title,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingM),
        ...children,
      ],
    );
  }

  /// Builds information row with label and value
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS / 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: '$label:',
              color: Colors.grey.shade600,
            ),
          ),
          Expanded(
            child: BodyText(
              text: value,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds specification item with icon and value
  Widget _buildSpecItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        BodyText(
          text: label,
          color: Colors.grey.shade600,
        ),
      ],
    );
  }

  /// Shares PG information
  void _sharePG(BuildContext context, pg) {
    // Implement sharing functionality
    // This would typically use a sharing plugin
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing functionality coming soon!')),
    );
  }
}
