// lib/common/widgets/performance/performance_monitor_widget.dart

import 'package:flutter/material.dart';
import 'dart:async';

import '../../../common/styles/spacing.dart';
import '../../../common/styles/colors.dart';
import '../../utils/performance/memory_manager.dart';
// NetworkOptimizer temporarily disabled
// import '../../utils/performance/network_optimizer.dart';

/// Performance monitoring widget for development and debugging
/// Shows real-time performance metrics and memory usage
class PerformanceMonitorWidget extends StatefulWidget {
  final bool showInRelease;
  final Duration updateInterval;
  final Widget child;

  const PerformanceMonitorWidget({
    super.key,
    this.showInRelease = false,
    this.updateInterval = const Duration(seconds: 1),
    required this.child,
  });

  @override
  State<PerformanceMonitorWidget> createState() =>
      _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  Timer? _timer;
  Map<String, int> _memoryStats = {};
  int _cacheSize = 0;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    if (!widget.showInRelease &&
        const bool.fromEnvironment('dart.vm.product')) {
      return;
    }

    _startMonitoring();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    _timer = Timer.periodic(widget.updateInterval, (_) {
      if (mounted) {
        setState(() {
          _memoryStats = MemoryManager.getMemoryStats();
          _updateCacheSize();
        });
      }
    });
  }

  Future<void> _updateCacheSize() async {
    // NetworkOptimizer temporarily disabled
    // _cacheSize = await NetworkOptimizer.getCacheSize();
    _cacheSize = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showInRelease &&
        const bool.fromEnvironment('dart.vm.product')) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (_isVisible) _buildPerformanceOverlay(),
        _buildToggleButton(),
      ],
    );
  }

  Widget _buildToggleButton() {
    return Positioned(
      top: 50,
      right: 16,
      child: FloatingActionButton.small(
        onPressed: () {
          setState(() {
            _isVisible = !_isVisible;
          });
        },
        backgroundColor: _isVisible ? AppColors.error : AppColors.info,
        child: Icon(
          _isVisible ? Icons.close : Icons.speed,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildPerformanceOverlay() {
    return Positioned(
      top: 120,
      right: 16,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(AppSpacing.paddingS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Performance Monitor',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            _buildMetricRow('Controllers', _memoryStats['controllers'] ?? 0),
            _buildMetricRow(
                'Scroll Controllers', _memoryStats['scrollControllers'] ?? 0),
            _buildMetricRow('Animation Controllers',
                _memoryStats['animationControllers'] ?? 0),
            _buildMetricRow('Focus Nodes', _memoryStats['focusNodes'] ?? 0),
            _buildMetricRow(
                'Subscriptions', _memoryStats['subscriptions'] ?? 0),
            Divider(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary
                    .withValues(alpha: 0.3)),
            _buildMetricRow('Cache Size', _cacheSize, isBytes: true),
            const SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      MemoryManager.clearMemory();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    child: Text(
                      'Clear Memory',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // NetworkOptimizer temporarily disabled
                      // await NetworkOptimizer.clearCache();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                    ),
                    child: Text(
                      'Clear Cache',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, int value, {bool isBytes = false}) {
    String displayValue = value.toString();
    if (isBytes) {
      displayValue = _formatBytes(value);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimary
                  .withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          Text(
            displayValue,
            style: TextStyle(
              color: _getValueColor(value, isBytes),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getValueColor(int value, bool isBytes) {
    if (isBytes) {
      if (value > 50 * 1024 * 1024) return AppColors.error; // > 50MB
      if (value > 20 * 1024 * 1024) return AppColors.warning; // > 20MB
      return AppColors.success;
    }

    if (value > 20) return AppColors.error;
    if (value > 10) return AppColors.warning;
    return AppColors.success;
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Performance overlay for development builds
class PerformanceOverlay extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const PerformanceOverlay({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled || const bool.fromEnvironment('dart.vm.product')) {
      return child;
    }

    return PerformanceMonitorWidget(
      child: child,
    );
  }
}
