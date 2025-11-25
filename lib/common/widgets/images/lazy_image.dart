// lib/common/widgets/images/lazy_image.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../styles/spacing.dart';

/// Lazy-loading image widget optimized for list views
/// Loads images only when they become visible in the viewport
/// Supports thumbnail fallback for faster initial loading
class LazyImage extends StatefulWidget {
  final String imageUrl;
  final String? thumbnailUrl; // Optional thumbnail for faster loading
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool useThumbnail; // Whether to show thumbnail first, then full image

  const LazyImage({
    super.key,
    required this.imageUrl,
    this.thumbnailUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppSpacing.borderRadiusM,
    this.placeholder,
    this.errorWidget,
    this.useThumbnail = false,
  });

  @override
  State<LazyImage> createState() => _LazyImageState();
}

class _LazyImageState extends State<LazyImage> {
  bool _isVisible = false;
  final _visibilityKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Use VisibilityDetector or IntersectionObserver-like approach
    // For now, load immediately (can be enhanced with visibility detection)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    // Check if widget is in viewport
    final RenderObject? renderObject = _visibilityKey.currentContext?.findRenderObject();
    if (renderObject != null && renderObject is RenderBox) {
      final box = renderObject;
      if (box.hasSize && box.size.width > 0 && box.size.height > 0) {
        if (mounted && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: _visibilityKey,
      width: widget.width,
      height: widget.height,
      child: _isVisible
          ? _buildImage()
          : (widget.placeholder ?? _buildDefaultPlaceholder(context)),
    );
  }

  Widget _buildImage() {
    // If thumbnail is provided and enabled, show thumbnail first
    if (widget.useThumbnail && widget.thumbnailUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          // Thumbnail (blurred/loading)
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: CachedNetworkImage(
              imageUrl: widget.thumbnailUrl!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              filterQuality: FilterQuality.low,
              memCacheWidth: widget.width?.toInt(),
              memCacheHeight: widget.height?.toInt(),
            ),
          ),
          // Full image (fade in)
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: FadeInImage.memoryNetwork(
              placeholder: _getPlaceholderBytes(),
              image: _normalizeUrl(widget.imageUrl),
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              imageErrorBuilder: (context, error, stackTrace) {
                return widget.errorWidget ?? _buildDefaultErrorWidget(context);
              },
            ),
          ),
        ],
      );
    }

    // Standard lazy-loaded image
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: CachedNetworkImage(
        imageUrl: _normalizeUrl(widget.imageUrl),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        placeholder: (context, url) =>
            widget.placeholder ?? _buildDefaultPlaceholder(context),
        errorWidget: (context, url, error) {
          debugPrint('Image load failed for URL: $url');
          return widget.errorWidget ?? _buildDefaultErrorWidget(context);
        },
        // Performance optimizations for list views
        memCacheWidth: widget.width?.isFinite == true ? widget.width!.toInt() : 300,
        memCacheHeight: widget.height?.isFinite == true ? widget.height!.toInt() : 300,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 600,
        // Lazy loading: only load when widget is visible
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
      ),
    );
  }

  Uint8List _getPlaceholderBytes() {
    // Transparent 1x1 pixel PNG
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
      0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
      0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
      0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
      0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
      0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      0x42, 0x60, 0x82,
    ]);
  }

  String _normalizeUrl(String url) {
    if (url.contains('/storage/v1/object/public/') && !url.contains('?')) {
      return '$url?download=1';
    }
    return url;
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Icon(
        Icons.image,
        color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.5) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: Icon(
        Icons.broken_image,
        color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.5) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }
}

