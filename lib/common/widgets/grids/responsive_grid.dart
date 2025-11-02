import 'package:flutter/material.dart';

/// ResponsiveGrid: lays out children in a fluid grid that fills width
/// by computing an adaptive column count from the available space.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double targetTileWidth;
  final double horizontalGap;
  final double verticalGap;
  final double? childAspectRatio; // width / height

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.targetTileWidth = 140,
    this.horizontalGap = 8,
    this.verticalGap = 8,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        if (maxWidth <= 0) {
          return const SizedBox.shrink();
        }

        int columns = (maxWidth / (targetTileWidth)).floor();
        columns = columns.clamp(1, 1000);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: children.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: horizontalGap,
            mainAxisSpacing: verticalGap,
            childAspectRatio: childAspectRatio ?? 1.2,
          ),
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}
