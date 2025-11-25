import 'package:flutter/material.dart';

import '../../mypg/presentation/screens/new_pg_setup_screen.dart';
import '../../../../common/utils/extensions/context_extensions.dart';

/// Reusable app bar action to add a new PG
class AddPgActionButton extends StatelessWidget {
  final Color? color;
  final String tooltip;

  const AddPgActionButton({
    super.key,
    this.color,
    this.tooltip = 'Add New PG',
  });

  @override
  Widget build(BuildContext context) {
    // Use provided color or theme-aware color based on app bar background
    final iconColor = color ?? context.colors.onSurface;

    return IconButton(
      icon: Icon(Icons.add_business, color: iconColor),
      tooltip: tooltip,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const NewPgSetupScreen(),
          ),
        );
      },
    );
  }
}
