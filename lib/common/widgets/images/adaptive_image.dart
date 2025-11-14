import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';

class AdaptiveImage extends AdaptiveStatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AdaptiveImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = AppSpacing.borderRadiusM,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final finalUrl = _normalizeUrl(imageUrl);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: finalUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            placeholder ?? _buildDefaultPlaceholder(context),
        errorWidget: (context, url, error) {
          // Log error for debugging but show graceful fallback
          debugPrint('Image load failed for URL: $url');
          debugPrint('Error: $error');
          return errorWidget ?? _buildDefaultErrorWidget(context);
        },
        // Performance optimizations
        memCacheWidth: width?.isFinite == true ? width!.toInt() : null,
        memCacheHeight: height?.isFinite == true ? height!.toInt() : null,
        maxWidthDiskCache: 800,
        maxHeightDiskCache: 600,
        // Cache settings for better performance
        cacheManager: null, // Use default cache manager
      ),
    );
  }

  /// Adds CORS-friendly download param for Supabase public URLs on web
  String _normalizeUrl(String url) {
    // If it's a Supabase storage public URL and no query is present, append ?download=1
    // This sometimes avoids opaque response issues on certain browsers/CDNs
    if (url.contains('/storage/v1/object/public/') && !url.contains('?')) {
      return '$url?download=1';
    }
    return url;
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.image,
          color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.5) ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.broken_image,
          color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.5) ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
    );
  }
}
