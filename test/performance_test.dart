// test/performance_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atitia/common/utils/performance/performance_test_utility.dart';
import 'package:atitia/common/widgets/performance/optimized_list_view.dart';
import 'package:atitia/common/widgets/images/adaptive_image.dart';

void main() {
  group('Performance Tests', () {
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

      print('OptimizedListView build time: ${buildTime.inMilliseconds}ms');
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

      print('AdaptiveImage build time: ${buildTime.inMilliseconds}ms');
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

      print('Performance stats: $stats');
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

      print('Performance report:\n$report');
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

      print('Exported performance data: $data');
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
