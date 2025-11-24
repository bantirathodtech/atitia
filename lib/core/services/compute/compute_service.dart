// lib/core/services/compute/compute_service.dart

import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

/// 🚀 **COMPUTE SERVICE - HEAVY COMPUTATION WITH ISOLATES**
///
/// Offloads heavy computations to isolates to keep UI responsive
/// Use for: image processing, data aggregation, large transformations
class ComputeService {
  static final ComputeService _instance = ComputeService._internal();
  factory ComputeService() => _instance;
  ComputeService._internal();

  /// Run heavy computation in isolate
  static Future<R> compute<T, R>(
    ComputeCallback<T, R> callback,
    T message, {
    String? debugLabel,
  }) async {
    return await Isolate.run(() => callback(message));
  }

  /// Process image in isolate (prevents UI blocking)
  Future<Uint8List> processImageInIsolate({
    required Uint8List imageBytes,
    int? maxWidth,
    int? maxHeight,
    int quality = 85,
  }) async {
    return await compute(_processImageInIsolate, {
      'imageBytes': imageBytes,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
      'quality': quality,
    });
  }

  /// Aggregate data in isolate (for large datasets)
  Future<Map<String, dynamic>> aggregateDataInIsolate({
    required List<Map<String, dynamic>> data,
    required String aggregationType,
    Map<String, dynamic>? parameters,
  }) async {
    return await compute(_aggregateDataInIsolate, {
      'data': data,
      'aggregationType': aggregationType,
      'parameters': parameters,
    });
  }

  /// Batch process images in isolate
  Future<List<Uint8List>> batchProcessImagesInIsolate({
    required List<Uint8List> imageBytesList,
    int? maxWidth,
    int? maxHeight,
    int quality = 85,
  }) async {
    return await compute(_batchProcessImagesInIsolate, {
      'imageBytesList': imageBytesList,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
      'quality': quality,
    });
  }
}

/// Isolate functions (must be top-level or static)
Future<Uint8List> _processImageInIsolate(Map<String, dynamic> params) async {
  final imageBytes = params['imageBytes'] as Uint8List;
  final maxWidth = params['maxWidth'] as int?;
  final maxHeight = params['maxHeight'] as int?;
  final quality = params['quality'] as int? ?? 85;

  try {
    final originalImage = img.decodeImage(imageBytes);
    if (originalImage == null) {
      return imageBytes;
    }

    int? targetWidth = maxWidth;
    int? targetHeight = maxHeight;

    if (targetWidth != null || targetHeight != null) {
      final aspectRatio = originalImage.width / originalImage.height;
      targetWidth ??= ((targetHeight ?? 0) * aspectRatio).round();
      targetHeight ??= (targetWidth / aspectRatio).round();

      final resizedImage = img.copyResize(
        originalImage,
        width: targetWidth,
        height: targetHeight,
        interpolation: img.Interpolation.cubic,
      );
      return Uint8List.fromList(img.encodeJpg(resizedImage, quality: quality));
    }

    return Uint8List.fromList(img.encodeJpg(originalImage, quality: quality));
  } catch (e) {
    return imageBytes; // Return original on error
  }
}

Future<List<Uint8List>> _batchProcessImagesInIsolate(
    Map<String, dynamic> params) async {
  final imageBytesList = params['imageBytesList'] as List<Uint8List>;
  final maxWidth = params['maxWidth'] as int?;
  final maxHeight = params['maxHeight'] as int?;
  final quality = params['quality'] as int? ?? 85;

  final results = <Uint8List>[];
  for (final bytes in imageBytesList) {
    final processed = await _processImageInIsolate({
      'imageBytes': bytes,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
      'quality': quality,
    });
    results.add(processed);
  }
  return results;
}

Future<Map<String, dynamic>> _aggregateDataInIsolate(
    Map<String, dynamic> params) async {
  final data = params['data'] as List<Map<String, dynamic>>;
  final aggregationType = params['aggregationType'] as String;
  final parameters = params['parameters'] as Map<String, dynamic>? ?? {};

  switch (aggregationType) {
    case 'sum':
      final field = parameters['field'] as String? ?? 'amount';
      final total = data.fold<double>(
        0.0,
        (sum, item) => sum + ((item[field] as num?)?.toDouble() ?? 0.0),
      );
      return {'total': total, 'count': data.length};

    case 'average':
      final field = parameters['field'] as String? ?? 'amount';
      final sum = data.fold<double>(
        0.0,
        (sum, item) => sum + ((item[field] as num?)?.toDouble() ?? 0.0),
      );
      return {
        'average': data.isEmpty ? 0.0 : sum / data.length,
        'count': data.length
      };

    case 'groupBy':
      final groupField = parameters['groupField'] as String? ?? 'category';
      final valueField = parameters['valueField'] as String? ?? 'amount';
      final grouped = <String, double>{};
      for (final item in data) {
        final key = (item[groupField] as String?) ?? 'unknown';
        final value = (item[valueField] as num?)?.toDouble() ?? 0.0;
        grouped[key] = (grouped[key] ?? 0.0) + value;
      }
      return {'grouped': grouped, 'count': data.length};

    default:
      return {'count': data.length};
  }
}

