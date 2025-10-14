// lib/feature/owner_dashboard/mypg/presentation/screens/owner_pg_create_screen.dart

import 'package:flutter/material.dart';

import 'owner_pg_form_screen.dart';

/// Owner PG Create Screen - Redirects to unified form
///
/// This screen redirects to the unified PG form for creating new PGs
class OwnerPgCreateScreen extends StatelessWidget {
  const OwnerPgCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OwnerPgFormScreen();
  }
}
