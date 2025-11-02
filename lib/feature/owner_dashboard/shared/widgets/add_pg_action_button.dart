import 'package:flutter/material.dart';

import '../../mypg/presentation/screens/new_pg_setup_screen.dart';

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
    return IconButton(
      icon: Icon(Icons.add_business, color: color),
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
