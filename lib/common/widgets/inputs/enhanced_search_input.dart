// lib/common/widgets/inputs/enhanced_search_input.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/theme_colors.dart';
import '../../utils/extensions/context_extensions.dart';
import '../text/body_text.dart';

/// 🎨 **ENHANCED SEARCH INPUT - AUTOCOMPLETE & HINTS**
///
/// Advanced search input with autocomplete suggestions, search hints, and smart filtering
/// Provides premium search UX with helpful guidance
class EnhancedSearchInput extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? hint;
  final List<String>? suggestions;
  final List<String>? popularSearches;
  final ValueChanged<String>? onSuggestionSelected;
  final VoidCallback? onClear;
  final bool showHints;
  final bool showPopularSearches;
  final String? helperText;

  const EnhancedSearchInput({
    super.key,
    this.controller,
    required this.onChanged,
    this.onSubmitted,
    this.hint,
    this.suggestions,
    this.popularSearches,
    this.onSuggestionSelected,
    this.onClear,
    this.showHints = true,
    this.showPopularSearches = true,
    this.helperText,
  });

  @override
  State<EnhancedSearchInput> createState() => _EnhancedSearchInputState();
}

class _EnhancedSearchInputState extends State<EnhancedSearchInput> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
    _filteredSuggestions = widget.suggestions ?? [];
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final query = _controller.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = widget.suggestions ?? [];
        _showSuggestions = widget.suggestions != null && widget.suggestions!.isNotEmpty;
      });
    } else {
      final filtered = (widget.suggestions ?? [])
          .where((suggestion) =>
              suggestion.toLowerCase().contains(query) &&
              suggestion.toLowerCase() != query)
          .toList();
      setState(() {
        _filteredSuggestions = filtered;
        _showSuggestions = filtered.isNotEmpty;
      });
    }
    widget.onChanged(_controller.text);
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus &&
          ((_controller.text.isEmpty && widget.suggestions != null) ||
              _filteredSuggestions.isNotEmpty);
    });
  }

  void _selectSuggestion(String suggestion) {
    _controller.text = suggestion;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );
    setState(() {
      _showSuggestions = false;
    });
    widget.onSuggestionSelected?.call(suggestion);
    widget.onChanged(suggestion);
    _focusNode.unfocus();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    widget.onClear?.call();
    setState(() {
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) {}, // Handled by listener
              onSubmitted: widget.onSubmitted,
              style: context.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hint ?? 'Search...',
                hintStyle: TextStyle(
                  color: ThemeColors.getTextTertiary(context),
                ),
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
                        onPressed: _clear,
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: theme.inputDecorationTheme.enabledBorder,
                focusedBorder: theme.inputDecorationTheme.focusedBorder,
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingM,
                ),
              ),
            ),
            if (_showSuggestions && _filteredSuggestions.isNotEmpty)
              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredSuggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _filteredSuggestions[index];
                        return ListTile(
                          leading: const Icon(Icons.search, size: 20),
                          title: BodyText(text: suggestion),
                          onTap: () => _selectSuggestion(suggestion),
                        );
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (widget.helperText != null && widget.showHints) ...[
          const SizedBox(height: AppSpacing.paddingS),
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.paddingM),
            child: BodyText(
              text: widget.helperText!,
              small: true,
              color: ThemeColors.getTextTertiary(context),
            ),
          ),
        ],
        if (widget.showPopularSearches &&
            widget.popularSearches != null &&
            widget.popularSearches!.isNotEmpty &&
            _controller.text.isEmpty &&
            !_focusNode.hasFocus) ...[
          const SizedBox(height: AppSpacing.paddingM),
          Wrap(
            spacing: AppSpacing.paddingS,
            runSpacing: AppSpacing.paddingS,
            children: [
              BodyText(
                text: 'Popular: ',
                small: true,
                color: ThemeColors.getTextTertiary(context),
              ),
              ...widget.popularSearches!.take(5).map((search) => _buildChip(context, search)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildChip(BuildContext context, String text) {
    final theme = Theme.of(context);
    return ActionChip(
      label: BodyText(text: text, small: true),
      onPressed: () => _selectSuggestion(text),
      backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(color: theme.primaryColor),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: AppSpacing.paddingXS,
      ),
    );
  }
}

