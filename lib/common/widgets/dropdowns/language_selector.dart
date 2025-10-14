import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app/localization/locale_provider.dart';

/// Language selection dropdown for switching app locale.
///
/// Responsibility:
/// - Display language options in dropdown
/// - Handle locale change events
/// - Show current selected language
///
/// Usage: Include in AppBar, Settings screen, or profile section
class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return DropdownButton<Locale>(
      value: localeProvider.locale,
      underline: const SizedBox(), // Remove default underline
      items: [
        DropdownMenuItem(
          value: const Locale('en'),
          child: Text(
            'English',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        DropdownMenuItem(
          value: const Locale('te'),
          child: Text(
            'తెలుగు',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
      onChanged: (newLocale) {
        if (newLocale != null) {
          localeProvider.setLocale(newLocale);
        }
      },
    );
  }
}
