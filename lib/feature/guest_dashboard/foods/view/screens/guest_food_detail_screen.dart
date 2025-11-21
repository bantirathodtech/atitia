// ============================================================================
// Guest Food Detail Screen
// ============================================================================
// Shows detailed information about a specific food item with theme toggle.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/text/index.dart';
import '../../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../common/utils/extensions/context_extensions.dart';
import '../../data/models/guest_food_model.dart';
import '../../viewmodel/guest_food_viewmodel.dart';

/// Minimal food details screen. Expects routing to pass [foodId] in the path.
/// This screen fetches details via GuestFoodViewmodel and shows basic info.
class GuestFoodDetailScreen extends StatefulWidget {
  final String foodId;
  const GuestFoodDetailScreen({super.key, required this.foodId});

  @override
  State<GuestFoodDetailScreen> createState() => _GuestFoodDetailScreenState();
}

class _GuestFoodDetailScreenState extends State<GuestFoodDetailScreen> {
  GuestFoodModel? _food;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final vm = context.read<GuestFoodViewmodel>();
      final food = await vm.getFoodById(widget.foodId);
      if (!mounted) return;
      setState(() {
        _food = food;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =======================================================================
      // App Bar with Theme Toggle - Food Details
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: 'Food Details',
        showThemeToggle: true, // Theme toggle for comfortable reading
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: AdaptiveLoader());
    }
    if (_error != null || _food == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyText(text: 'Failed to load food details', medium: true),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
                text: _error ?? 'Unknown error',
                color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7) ??
                    Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7)),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(onPressed: _load, label: 'Retry'),
          ],
        ),
      );
    }

    final food = _food!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          BodyText(text: food.name, medium: true),
          const SizedBox(height: AppSpacing.paddingS),
          // Image
          if (food.firstImageUrl != null)
            AdaptiveImage(
              imageUrl: food.firstImageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: 12,
            ),
          const SizedBox(height: AppSpacing.paddingS),
          // Description
          BodyText(text: food.description),
          const SizedBox(height: AppSpacing.paddingS),
          // Price
          BodyText(text: 'Price: ${food.formattedPrice}', medium: true),
          const SizedBox(height: AppSpacing.paddingS),
          // Availability
          BodyText(
            text: food.isCurrentlyAvailable ? 'Available' : 'Out of Stock',
            color: food.isCurrentlyAvailable
                ? AppColors.success
                : context.decorativeRed,
          ),
        ],
      ),
    );
  }
}
