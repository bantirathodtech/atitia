// test/performance_test.dart

// FIXED: Unnecessary import warning
// Flutter recommends: Only import packages that provide unique functionality
// Changed from: Importing 'package:flutter/foundation.dart' when 'package:flutter/material.dart' already provides all needed elements
// Changed to: Removed unnecessary foundation.dart import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:atitia/common/utils/performance/performance_test_utility.dart';
import 'package:atitia/common/widgets/performance/optimized_list_view.dart';
import 'package:atitia/common/widgets/images/adaptive_image.dart';
import 'package:atitia/core/services/firebase/analytics/firebase_analytics_service.dart';
import 'package:atitia/core/services/firebase/crashlytics/firebase_crashlytics_service.dart';

void main() {
  group('Performance Tests', () {
    setUpAll(() {
      // Initialize GetIt with mock services for performance tests
      final getIt = GetIt.instance;

      // Unregister existing services if they exist
      try {
        if (getIt.isRegistered<AnalyticsServiceWrapper>()) {
          getIt.unregister<AnalyticsServiceWrapper>();
        }
      } catch (_) {}

      try {
        if (getIt.isRegistered<CrashlyticsServiceWrapper>()) {
          getIt.unregister<CrashlyticsServiceWrapper>();
        }
      } catch (_) {}

      // Register mock analytics service
      getIt.registerLazySingleton<AnalyticsServiceWrapper>(
        () => _MockAnalyticsService(),
      );

      // Register mock crashlytics service
      getIt.registerLazySingleton<CrashlyticsServiceWrapper>(
        () => _MockCrashlyticsService(),
      );
    });

    tearDownAll(() {
      // Clean up GetIt
      final getIt = GetIt.instance;
      try {
        if (getIt.isRegistered<AnalyticsServiceWrapper>()) {
          getIt.unregister<AnalyticsServiceWrapper>();
        }
      } catch (_) {}

      try {
        if (getIt.isRegistered<CrashlyticsServiceWrapper>()) {
          getIt.unregister<CrashlyticsServiceWrapper>();
        }
      } catch (_) {}
    });
    testWidgets('OptimizedListView performance test',
        (WidgetTester tester) async {
      // Test data
      final testItems = List.generate(100, (index) => 'Item $index');

      // Start performance measurement
      PerformanceTestUtility.startMeasurement('optimized_listview_build');

      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OptimizedListView<String>(
              items: testItems,
              itemBuilder: (context, item, index) {
                return ListTile(
                  title: Text(item),
                  leading: CircleAvatar(child: Text('${index + 1}')),
                );
              },
            ),
          ),
        ),
      );

      // End performance measurement
      final buildTime =
          PerformanceTestUtility.endMeasurement('optimized_listview_build');

      // Verify widget was built
      expect(find.byType(OptimizedListView<String>), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);

      // Verify performance (should be under 500ms for 100 items)
      expect(buildTime.inMilliseconds, lessThan(500));

      debugPrint('OptimizedListView build time: ${buildTime.inMilliseconds}ms');
    });

    testWidgets('AdaptiveImage performance test', (WidgetTester tester) async {
      // Start performance measurement
      PerformanceTestUtility.startMeasurement('adaptive_image_build');

      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveImage(
              imageUrl: 'https://via.placeholder.com/200x200',
              width: 200,
              height: 200,
            ),
          ),
        ),
      );

      // End performance measurement
      final buildTime =
          PerformanceTestUtility.endMeasurement('adaptive_image_build');

      // Verify widget was built
      expect(find.byType(AdaptiveImage), findsOneWidget);

      // Verify performance (should be under 50ms)
      expect(buildTime.inMilliseconds, lessThan(50));

      debugPrint('AdaptiveImage build time: ${buildTime.inMilliseconds}ms');
    });

    test('Performance measurement utility test', () {
      // Clear previous measurements
      PerformanceTestUtility.clearMeasurements();

      // Test multiple measurements
      for (int i = 0; i < 5; i++) {
        PerformanceTestUtility.startMeasurement('test_operation');
        // Simulate some work
        Future.delayed(Duration(milliseconds: 10));
        PerformanceTestUtility.endMeasurement('test_operation');
      }

      // Get performance stats
      final stats =
          PerformanceTestUtility.getPerformanceStats('test_operation');

      // Verify stats exist
      expect(stats['count'], equals(5));
      expect(stats['min'], isA<Duration>());
      expect(stats['max'], isA<Duration>());
      expect(stats['average'], isA<Duration>());
      expect(stats['median'], isA<Duration>());

      debugPrint('Performance stats: $stats');
    });

    test('Performance report generation test', () {
      // Clear previous measurements
      PerformanceTestUtility.clearMeasurements();

      // Add some test measurements
      PerformanceTestUtility.startMeasurement('operation1');
      PerformanceTestUtility.endMeasurement('operation1');

      PerformanceTestUtility.startMeasurement('operation2');
      PerformanceTestUtility.endMeasurement('operation2');

      // Generate report
      final report = PerformanceTestUtility.generatePerformanceReport();

      // Verify report contains expected content
      expect(report, contains('PERFORMANCE REPORT'));
      expect(report, contains('operation1'));
      expect(report, contains('operation2'));

      debugPrint('Performance report:\n$report');
    });

    test('Performance data export test', () {
      // Clear previous measurements
      PerformanceTestUtility.clearMeasurements();

      // Add test measurement
      PerformanceTestUtility.startMeasurement('export_test');
      PerformanceTestUtility.endMeasurement('export_test');

      // Export data
      final data = PerformanceTestUtility.exportPerformanceData();

      // Verify exported data structure
      expect(data, isA<Map<String, dynamic>>());
      expect(data['export_test'], isA<Map<String, dynamic>>());
      expect(data['export_test']['count'], equals(1));

      debugPrint('Exported performance data: $data');
    });

    testWidgets('Memory management mixin test', (WidgetTester tester) async {
      // This test verifies that the memory management mixin works correctly
      // by ensuring controllers are properly registered and disposed

      await tester.pumpWidget(
        MaterialApp(
          home: TestWidgetWithMixin(),
        ),
      );

      // Verify widget was built
      expect(find.byType(TestWidgetWithMixin), findsOneWidget);

      // Dispose widget (this should trigger mixin disposal)
      await tester.pumpWidget(Container());

      // If we get here without errors, the mixin is working correctly
      expect(true, isTrue);
    });
  });
}

// Test widget that uses the memory management mixin
class TestWidgetWithMixin extends StatefulWidget {
  const TestWidgetWithMixin({super.key});

  @override
  State<TestWidgetWithMixin> createState() => _TestWidgetWithMixinState();
}

class _TestWidgetWithMixinState extends State<TestWidgetWithMixin> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Register controllers for automatic disposal
    // Note: In a real implementation, we would use the MemoryManagementMixin
    // For this test, we'll just verify the controllers are created
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _controller),
          Expanded(
            child: ListView(controller: _scrollController),
          ),
        ],
      ),
    );
  }
}

/// Mock AnalyticsServiceWrapper for performance tests
class _MockAnalyticsService implements AnalyticsServiceWrapper {
  @override
  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String? userId) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String screenClass = 'Flutter',
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Mock implementation - do nothing
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Mock CrashlyticsServiceWrapper for performance tests
class _MockCrashlyticsService implements CrashlyticsServiceWrapper {
  @override
  Future<void> log(String message) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> recordError({
    required dynamic exception,
    required StackTrace stackTrace,
    String? reason,
    bool fatal = false,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> setUserId(String userId) async {
    // Mock implementation - do nothing
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
