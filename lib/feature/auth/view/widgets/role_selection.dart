import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/styles/spacing.dart';
import '../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../common/widgets/text/body_text.dart';
import '../../../../common/widgets/text/heading_medium.dart';
import '../../logic/auth_provider.dart';

/// Role selection widget for choosing between Guest and Owner roles
/// Used in registration flow
/// Enhanced with common widgets
class RoleSelectionWidget extends StatelessWidget {
  const RoleSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final selectedRole = authProvider.user?.role;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HeadingMedium(
          text: 'Select Your Role',
          align: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        const BodyText(
          text: 'Choose how you want to use the app',
          align: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        
        // Guest Role Card
        _buildRoleCard(
          context: context,
          title: 'Guest',
          description: 'Find and book PG accommodations',
          icon: Icons.person,
          color: Colors.blue,
          isSelected: selectedRole == 'guest',
          onTap: () => authProvider.setRole('guest'),
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Owner Role Card
        _buildRoleCard(
          context: context,
          title: 'Owner',
          description: 'Manage your PG properties and guests',
          icon: Icons.business,
          color: Colors.green,
          isSelected: selectedRole == 'owner',
          onTap: () => authProvider.setRole('owner'),
        ),
      ],
    );
  }

  /// Builds role selection card
  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return AdaptiveCard(
      onTap: onTap,
      elevation: isSelected ? 8 : 2,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: color, width: 2)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(
                    text: title,
                    color: color,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  BodyText(
                    text: description,
                    color: Colors.grey.shade700,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: color,
                size: 28,
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
