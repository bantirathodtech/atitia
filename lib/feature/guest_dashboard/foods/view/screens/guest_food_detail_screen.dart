// ============================================================================
// Guest Food Detail Screen
// ============================================================================
// Shows detailed information about a specific food item with theme toggle.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/text/index.dart';
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
        showThemeToggle: true,  // Theme toggle for comfortable reading
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null || _food == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyText(text: 'Failed to load food details', medium: true),
            const SizedBox(height: 8),
            BodyText(text: _error ?? 'Unknown error', color: Colors.grey),
            const SizedBox(height: 16),
            PrimaryButton(onPressed: _load, label: 'Retry'),
          ],
        ),
      );
    }

    final food = _food!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          BodyText(text: food.name, medium: true),
          const SizedBox(height: 8),
          // Image
          if (food.firstImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                food.firstImageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),
          // Description
          BodyText(text: food.description),
          const SizedBox(height: 12),
          // Price
          BodyText(text: 'Price: ${food.formattedPrice}', medium: true),
          const SizedBox(height: 12),
          // Availability
          BodyText(
            text: food.isCurrentlyAvailable ? 'Available' : 'Out of Stock',
            color: food.isCurrentlyAvailable ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
