// lib/feature/owner_dashboard/mypg/presentation/screens/owner_pg_edit_screen.dart

import 'package:flutter/material.dart';

import 'owner_pg_form_screen.dart';

/// Owner PG Edit Screen - Redirects to unified form
///
/// This screen redirects to the unified PG form for editing existing PGs
class OwnerPgEditScreen extends StatelessWidget {
  final String pgId;

  const OwnerPgEditScreen({
    super.key,
    required this.pgId,
  });

  @override
  Widget build(BuildContext context) {
    return OwnerPgFormScreen(pgId: pgId);
  }
}
