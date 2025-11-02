// lib/common/widgets/offline/offline_indicator.dart

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import '../../../core/services/offline/offline_service.dart';

/// 📱 **OFFLINE INDICATOR - PRODUCTION READY**
///
/// **Features:**
/// - Network status display
/// - Sync queue status
/// - Manual sync option
/// - Theme-aware styling
class OfflineIndicator extends StatefulWidget {
  const OfflineIndicator({super.key});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  final _offlineService = offlineService;
  bool _isOnline = true;
  int _pendingActions = 0;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _initializeConnectivity() {
    _isOnline = _offlineService.isOnline;
    _pendingActions = _offlineService.pendingActions.length;

    _connectivitySubscription =
        _offlineService.connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
          _pendingActions = _offlineService.pendingActions.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);

    // Don't show indicator when online and no pending actions
    if (_isOnline && _pendingActions == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      decoration: BoxDecoration(
        color: _isOnline
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: _isOnline
              ? AppColors.warning.withValues(alpha: 0.3)
              : AppColors.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isOnline ? Icons.sync : Icons.wifi_off,
            color: _isOnline ? AppColors.warning : AppColors.error,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Text(
              _isOnline
                  ? 'Syncing $_pendingActions action${_pendingActions != 1 ? 's' : ''}...'
                  : 'You\'re offline',
              style: AppTypography.bodySmall.copyWith(
                color: _isOnline ? AppColors.warning : AppColors.error,
              ),
            ),
          ),
          if (_isOnline && _pendingActions > 0)
            GestureDetector(
              onTap: () async {
                await _offlineService.processSyncQueue();
              },
              child: Text(
                'Tap to sync',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 🔄 **SYNC QUEUE DIALOG - PRODUCTION READY**
class SyncQueueDialog extends StatefulWidget {
  const SyncQueueDialog({super.key});

  @override
  State<SyncQueueDialog> createState() => _SyncQueueDialogState();
}

class _SyncQueueDialogState extends State<SyncQueueDialog> {
  final _offlineService = offlineService;
  List<OfflineAction> _pendingActions = [];
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _loadPendingActions();
  }

  void _loadPendingActions() {
    _pendingActions = List.from(_offlineService.pendingActions);
  }

  Future<void> _syncAll() async {
    setState(() => _syncing = true);
    try {
      await _offlineService.processSyncQueue();
      _loadPendingActions();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _syncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(
        'Sync Queue',
        style: AppTypography.headingSmall.copyWith(
          color: AppColors.primary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_pendingActions.isEmpty)
            Text(
              'No pending actions to sync',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else ...[
            Text(
              '${_pendingActions.length} action${_pendingActions.length != 1 ? 's' : ''} pending sync:',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _pendingActions.length,
                itemBuilder: (context, index) {
                  final action = _pendingActions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.5),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getActionIcon(action.type),
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.paddingS),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.type,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                DateFormat('MMM dd, HH:mm')
                                    .format(action.timestamp),
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Close',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (_pendingActions.isNotEmpty)
          ElevatedButton(
            onPressed: _syncing ? null : _syncAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: _syncing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textOnPrimary),
                    ),
                  )
                : Text(
                    'Sync All',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
      ],
    );
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType.toLowerCase()) {
      case 'create':
      case 'add':
        return Icons.add;
      case 'update':
      case 'edit':
        return Icons.edit;
      case 'delete':
      case 'remove':
        return Icons.delete;
      default:
        return Icons.sync;
    }
  }
}

/// 🔄 **SYNC STATUS BANNER - PRODUCTION READY**
class SyncStatusBanner extends StatefulWidget {
  const SyncStatusBanner({super.key});

  @override
  State<SyncStatusBanner> createState() => _SyncStatusBannerState();
}

class _SyncStatusBannerState extends State<SyncStatusBanner> {
  final _offlineService = offlineService;
  bool _isOnline = true;
  int _pendingActions = 0;
  StreamSubscription<bool>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  void _initializeConnectivity() {
    _isOnline = _offlineService.isOnline;
    _pendingActions = _offlineService.pendingActions.length;

    _connectivitySubscription =
        _offlineService.connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
          _pendingActions = _offlineService.pendingActions.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final isDarkMode = theme.brightness == Brightness.dark;

    // Don't show banner when online and no pending actions
    if (_isOnline && _pendingActions == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingL,
        vertical: AppSpacing.paddingM,
      ),
      decoration: BoxDecoration(
        color: _isOnline
            ? AppColors.warning.withValues(alpha: 0.1)
            : AppColors.error.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: _isOnline
                ? AppColors.warning.withValues(alpha: 0.3)
                : AppColors.error.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isOnline ? Icons.sync : Icons.wifi_off,
            color: _isOnline ? AppColors.warning : AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Text(
              _isOnline
                  ? 'Syncing $_pendingActions action${_pendingActions != 1 ? 's' : ''}...'
                  : 'Offline',
              style: AppTypography.bodyMedium.copyWith(
                color: _isOnline ? AppColors.warning : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_isOnline && _pendingActions > 0)
            TextButton(
              onPressed: () async {
                await _offlineService.processSyncQueue();
              },
              child: Text(
                'Sync Now',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
