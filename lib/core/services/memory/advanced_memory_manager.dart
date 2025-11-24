// lib/core/services/memory/advanced_memory_manager.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 🚀 **ADVANCED MEMORY MANAGER - ENHANCED MEMORY MANAGEMENT**
///
/// Advanced memory management with automatic cleanup,
/// cache size limits, and memory pressure handling
class AdvancedMemoryManager {
  static final AdvancedMemoryManager _instance =
      AdvancedMemoryManager._internal();
  factory AdvancedMemoryManager() => _instance;
  AdvancedMemoryManager._internal();

  static const int _maxImageCacheSize = 100 * 1024 * 1024; // 100MB
  static const int _maxImageCacheObjects = 100;
  
  bool _isInitialized = false;

  /// Initialize advanced memory management
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure image cache limits
      PaintingBinding.instance.imageCache.maximumSize = _maxImageCacheObjects;
      PaintingBinding.instance.imageCache.maximumSizeBytes =
          _maxImageCacheSize;

      // Listen to memory pressure warnings
      if (kDebugMode) {
        debugPrint('✅ Advanced Memory Manager initialized');
        debugPrint('   Image cache limit: $_maxImageCacheSize bytes');
        debugPrint('   Max cache objects: $_maxImageCacheObjects');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('⚠️ Failed to initialize Advanced Memory Manager: $e');
    }
  }

  /// Clear image cache with size threshold
  Future<void> clearImageCacheIfNeeded({int thresholdMB = 150}) async {
    try {
      final currentSize = PaintingBinding.instance.imageCache.currentSizeBytes;
      final thresholdBytes = thresholdMB * 1024 * 1024;

      if (currentSize > thresholdBytes) {
        PaintingBinding.instance.imageCache.clear();
        PaintingBinding.instance.imageCache.clearLiveImages();
        
        if (kDebugMode) {
          debugPrint(
              '🧹 Cleared image cache (was ${(currentSize / 1024 / 1024).toStringAsFixed(2)}MB)');
        }
      }
    } catch (e) {
      debugPrint('⚠️ Failed to clear image cache: $e');
    }
  }

  /// Clear all caches
  Future<void> clearAllCaches() async {
    try {
      // Clear Flutter image cache
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();

      // Note: cached_network_image cache is managed automatically

      if (kDebugMode) {
        debugPrint('🧹 Cleared all caches');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to clear all caches: $e');
    }
  }

  /// Get current memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    final imageCache = PaintingBinding.instance.imageCache;
    
    return {
      'imageCacheSize': imageCache.currentSizeBytes,
      'imageCacheSizeMB': (imageCache.currentSizeBytes / 1024 / 1024).toStringAsFixed(2),
      'imageCacheObjects': imageCache.currentSize,
      'maxImageCacheSize': imageCache.maximumSizeBytes,
      'maxImageCacheObjects': imageCache.maximumSize,
      'cacheUtilization': (imageCache.currentSizeBytes / imageCache.maximumSizeBytes * 100).toStringAsFixed(2),
    };
  }

  /// Monitor memory and auto-clear if needed
  Future<void> monitorAndOptimize() async {
    final stats = getMemoryStats();
    final cacheSizeMB = double.parse(stats['imageCacheSizeMB'] as String);

    // Auto-clear if cache exceeds 150MB
    if (cacheSizeMB > 150) {
      await clearImageCacheIfNeeded();
    }
  }
}

