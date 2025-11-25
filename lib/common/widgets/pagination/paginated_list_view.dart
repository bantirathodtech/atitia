// lib/common/widgets/pagination/paginated_list_view.dart

import 'package:flutter/material.dart';
import 'pagination_controller.dart';
import '../../styles/spacing.dart';

/// Reusable paginated list view with lazy loading for Firestore queries
/// Automatically loads more data when user scrolls near the bottom
class PaginatedListView<T> extends StatefulWidget {
  final PaginationController<T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final Widget? loadingMoreWidget;
  final Widget? errorWidget;
  final EdgeInsetsGeometry? padding;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final double triggerDistance;
  final bool shrinkWrap;
  final bool addRepaintBoundaries;
  final bool addAutomaticKeepAlives;
  final Key? listKey;

  const PaginatedListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.emptyWidget,
    this.loadingWidget,
    this.loadingMoreWidget,
    this.errorWidget,
    this.padding,
    this.scrollController,
    this.physics,
    this.triggerDistance = 200.0,
    this.shrinkWrap = false,
    this.addRepaintBoundaries = true,
    this.addAutomaticKeepAlives = true,
    this.listKey,
  });

  @override
  State<PaginatedListView<T>> createState() => _PaginatedListViewState<T>();
}

class _PaginatedListViewState<T> extends State<PaginatedListView<T>> {
  late ScrollController _scrollController;
  bool _isControllerOwned = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = widget.scrollController ?? ScrollController();
    _isControllerOwned = widget.scrollController == null;
    
    _scrollController.addListener(_onScroll);
    
    // Load initial data
    if (widget.controller.itemCount == 0 && !widget.controller.isLoading) {
      widget.controller.loadInitial();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    if (_isControllerOwned) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - widget.triggerDistance) {
      if (widget.controller.hasMore &&
          !widget.controller.isLoadingMore &&
          !widget.controller.isLoading) {
        widget.controller.loadMore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        // Show error state
        if (widget.controller.error != null && !widget.controller.hasItems) {
          return widget.errorWidget ?? _buildDefaultErrorWidget();
        }

        // Show loading state (initial load)
        if (widget.controller.isLoading && widget.controller.itemCount == 0) {
          return widget.loadingWidget ?? _buildDefaultLoadingWidget();
        }

        // Show empty state
        if (!widget.controller.isLoading &&
            widget.controller.itemCount == 0) {
          return widget.emptyWidget ?? _buildDefaultEmptyWidget(context);
        }

        // Show list with items
        return ListView.builder(
          key: widget.listKey,
          controller: _scrollController,
          padding: widget.padding ?? EdgeInsets.zero,
          physics: widget.physics,
          shrinkWrap: widget.shrinkWrap,
          addRepaintBoundaries: widget.addRepaintBoundaries,
          addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
          itemCount: widget.controller.itemCount +
              (widget.controller.hasMore ? 1 : 0) +
              (widget.controller.error != null && widget.controller.hasItems ? 1 : 0),
          itemBuilder: (context, index) {
            // Show error banner if error occurred after items loaded
            if (widget.controller.error != null &&
                widget.controller.hasItems &&
                index == widget.controller.itemCount) {
              return widget.errorWidget ?? _buildErrorBanner();
            }

            // Show loading more indicator
            if (index == widget.controller.itemCount) {
              return widget.loadingMoreWidget ?? _buildDefaultLoadingMoreWidget();
            }

            // Show item
            final item = widget.controller.items[index];
            final itemWidget = widget.itemBuilder(context, item, index);
            
            if (widget.addRepaintBoundaries) {
              return RepaintBoundary(child: itemWidget);
            }
            
            return itemWidget;
          },
        );
      },
    );
  }

  Widget _buildDefaultLoadingWidget() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.paddingXL),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildDefaultLoadingMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Center(
        child: widget.controller.isLoadingMore
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildDefaultEmptyWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Text(
              'No items found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Text(
              'Error loading data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            Text(
              widget.controller.error ?? 'Unknown error',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            ElevatedButton.icon(
              onPressed: () => widget.controller.loadInitial(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Text(
              widget.controller.error ?? 'Error loading more items',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => widget.controller.loadMore(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

