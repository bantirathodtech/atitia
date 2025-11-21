import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../lifecycle/stateful/adaptive_stateful_widget.dart';
import '../../styles/spacing.dart';
import '../../styles/theme_colors.dart';
import '../../utils/extensions/context_extensions.dart';

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
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hint ??
            AppLocalizations.of(context)?.searchHint ??
            'Search...',
        hintStyle: TextStyle(color: ThemeColors.getTextTertiary(context)),
        prefixIcon: Icon(
          Icons.search,
          color: ThemeColors.getTextTertiary(context),
        ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: ThemeColors.getTextTertiary(context),
                ),
                onPressed: clear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          borderSide: BorderSide.none,
        ),
        enabledBorder: context.theme.inputDecorationTheme.enabledBorder,
        focusedBorder: context.theme.inputDecorationTheme.focusedBorder,
        filled: true,
        fillColor: context.theme.inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
        ),
      ),
    );
  }
}
