// lib/feature/guest_dashboard/shared/widgets/user_location_display.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/data/model/user_model.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../../../common/styles/colors.dart';
import '../../../../common/styles/spacing.dart';
import '../../../../common/widgets/text/body_text.dart';
import '../../../../common/widgets/text/caption_text.dart';

/// Simple, reusable widget to display user location
/// Format: State, District, Taluka/Mandal, Area, Society
/// Example: State: Telangana, District: Hyderabad, Taluka/Mandal: Hyderabad, Area: Gachibowli, Society: Siddique Nagar
class UserLocationDisplay extends StatelessWidget {
  final bool compact; // Compact mode for smaller spaces
  final TextStyle? textStyle;
  final Color? iconColor;

  const UserLocationDisplay({
    super.key,
    this.compact = false,
    this.textStyle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final locationParts = _getLocationParts(user);

    // If no location data available, show nothing
    if (locationParts.isEmpty) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return _buildCompactLocation(context, locationParts);
    }

    return _buildFullLocation(context, locationParts);
  }

  /// Builds full location display with all parts
  Widget _buildFullLocation(BuildContext context, Map<String, String> parts) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColorFinal = iconColor ?? (isDark ? AppColors.textTertiary : AppColors.textSecondary);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: 20,
            color: iconColorFinal,
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (parts['state'] != null)
                  _buildLocationRow('State', parts['state']!, context),
                if (parts['district'] != null)
                  _buildLocationRow('District', parts['district']!, context),
                if (parts['taluka'] != null)
                  _buildLocationRow('Taluka/Mandal', parts['taluka']!, context),
                if (parts['area'] != null)
                  _buildLocationRow('Area', parts['area']!, context),
                if (parts['society'] != null)
                  _buildLocationRow('Society', parts['society']!, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds compact location display (single line)
  Widget _buildCompactLocation(BuildContext context, Map<String, String> parts) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColorFinal = iconColor ?? (isDark ? AppColors.textTertiary : AppColors.textSecondary);

    final locationText = _buildCompactLocationText(parts);

    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: iconColorFinal,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: CaptionText(
            text: locationText,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  /// Builds a single location row (Label: Value)
  Widget _buildLocationRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaptionText(
            text: '$label: ',
            color: AppColors.textSecondary,
          ),
          Expanded(
            child: BodyText(
              text: value,
              small: true,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds compact location text (State, District, Area format)
  String _buildCompactLocationText(Map<String, String> parts) {
    final List<String> items = [];
    
    if (parts['state'] != null) items.add(parts['state']!);
    if (parts['district'] != null) items.add(parts['district']!);
    if (parts['area'] != null) items.add(parts['area']!);
    if (parts['society'] != null && items.length < 3) items.add(parts['society']!);

    return items.join(', ');
  }

  /// Extracts location parts from UserModel
  Map<String, String> _getLocationParts(UserModel user) {
    final parts = <String, String>{};

    // State
    if (user.state != null && user.state!.isNotEmpty) {
      parts['state'] = user.state!;
    }

    // District (from city field)
    if (user.city != null && user.city!.isNotEmpty) {
      parts['district'] = user.city!;
    }

    // Taluka/Mandal, Area, Society from metadata
    if (user.metadata != null) {
      final metadata = user.metadata!;
      
      // Taluka or Mandal
      final taluka = metadata['taluka'] as String? ?? metadata['mandal'] as String?;
      if (taluka != null && taluka.isNotEmpty) {
        parts['taluka'] = taluka;
      }

      // Area
      final area = metadata['area'] as String?;
      if (area != null && area.isNotEmpty) {
        parts['area'] = area;
      }

      // Society
      final society = metadata['society'] as String?;
      if (society != null && society.isNotEmpty) {
        parts['society'] = society;
      }
    }

    // If pgAddress exists and no area/society from metadata, try to extract from address
    if (user.pgAddress != null && user.pgAddress!.isNotEmpty) {
      if (parts['area'] == null || parts['society'] == null) {
        // Try to parse address for area/society (simple approach)
        final addressParts = user.pgAddress!.split(',');
        if (addressParts.length >= 2) {
          // Last part might be society, second last might be area
          if (parts['society'] == null && addressParts.isNotEmpty) {
            parts['society'] = addressParts.last.trim();
          }
          if (parts['area'] == null && addressParts.length >= 2) {
            parts['area'] = addressParts[addressParts.length - 2].trim();
          }
        }
      }
    }

    return parts;
  }
}

