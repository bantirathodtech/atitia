// ============================================================================
// Owner Reports Screen
// ============================================================================
// Reports screen for owner users - placeholder for future implementation
// ============================================================================

import 'package:flutter/material.dart';

import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';

/// Reports screen for owners - placeholder
class OwnerReportsScreen extends StatelessWidget {
  const OwnerReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Reports',
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
      body: const EmptyState(
        icon: Icons.assessment,
        title: 'Reports Coming Soon',
        message:
            'Detailed reports and analytics will be available here soon.',
      ),
    );
  }
}

