import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';
import '../../styles/typography.dart';

class SearchInput extends AdaptiveStatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final String? hint;
  final VoidCallback? onClear;

  const SearchInput({
    super.key,
    this.controller,
    required this.onChanged,
    this.hint,
    this.onClear,
  });

  @override
  SearchInputState createState() => SearchInputState();
}

class SearchInputState extends AdaptiveStatefulWidgetState<SearchInput> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void onDispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.onDispose();
  }

  void clear() {
    _controller.clear();
    widget.onChanged('');
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      style: AppTypography.input,
      decoration: InputDecoration(
        hintText: widget.hint ??
            AppLocalizations.of(context)?.searchHint ??
            'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: clear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkInputFill : AppColors.lightInputFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
        ),
      ),
    );
  }
}
