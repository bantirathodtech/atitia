// integration_test/screenshots/owner_flow_screenshots_test.dart
//
// Comprehensive screenshot capture test for Owner flow
// Captures all recommended owner screenshots automatically

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:atitia/main.dart' as app;

import '../config/screenshot_config.dart';
import '../services/screenshot_service.dart';
import '../helpers/mock_auth_helper.dart';
import '../helpers/navigation_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Owner Flow Screenshot Capture', () {
    late ScreenshotService screenshotService;
    late MockAuthHelper authHelper;
    late NavigationHelper navigationHelper;

    setUp(() {
      screenshotService = ScreenshotService();
    });

    testWidgets('Capture all owner flow screenshots',
        (WidgetTester tester) async {
      authHelper = MockAuthHelper(tester);
      navigationHelper = NavigationHelper(tester);

      print('🚀 Starting Owner Flow Screenshot Capture');
      print('==========================================');

      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      // Step 1: Login as owner
      print('\n📱 Step 1: Authenticating as Owner...');
      final loginSuccess = await authHelper.loginAsOwner();
      if (!loginSuccess) {
        print('⚠️  Could not login automatically. Please ensure:');
        print('   1. App is in test mode');
        print('   2. Mock authentication is enabled');
        print('   3. Or manually login before running test');
      } else {
        print('✅ Owner authentication successful');
      }

      await navigationHelper.waitForScreenLoad();

      // Step 1.5: Ensure system theme mode is set
      print('\n🎨 Step 1.5: Setting System Theme Mode...');
      await authHelper.setSystemThemeMode();
      await navigationHelper.waitForScreenLoad();

      // Step 2: Get owner screenshots to capture
      final screenshots = ScreenshotConfig.getScreenshotsByRole('owner');
      print(
          '\n📸 Step 2: Capturing ${screenshots.length} owner screenshots...');

      // Step 3: Capture each screenshot
      for (final screenshotDef in screenshots) {
        print('\n📸 Capturing: ${screenshotDef.name}');
        print('   Route: ${screenshotDef.route}');
        print('   Description: ${screenshotDef.description}');

        try {
          // Navigate to the route
          if (screenshotDef.route.isNotEmpty) {
            final navSuccess = await navigationHelper.navigateToRoute(
              screenshotDef.route,
            );
            if (!navSuccess) {
              print('⚠️  Navigation to ${screenshotDef.route} failed');
            }
          }

          // Execute any additional navigation steps
          if (screenshotDef.navigationSteps != null) {
            await navigationHelper.executeNavigationSteps(
              screenshotDef.navigationSteps,
            );
          }

          // Wait for screen to stabilize
          await navigationHelper.waitForScreenLoad();

          // Capture screenshot
          final filepath = await screenshotService.captureScreenshot(
            tester,
            screenshotDef,
            metadata: {
              'role': 'owner',
              'route': screenshotDef.route,
              'priority': screenshotDef.priority,
            },
          );

          if (filepath != null) {
            print('✅ Screenshot captured: $filepath');
          } else {
            print('❌ Failed to capture screenshot');
          }
        } catch (e) {
          print('❌ Error capturing ${screenshotDef.name}: $e');
        }

        // Small delay between screenshots
        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Step 4: Generate report
      print('\n📄 Step 3: Generating report...');
      final reportPath =
          '${ScreenshotConfig.outputDirectory}/owner_flow_report.md';
      await screenshotService.saveReport(reportPath);

      print('\n✅ Owner Flow Screenshot Capture Complete!');
      print('==========================================');
      print(
          '📊 Total Screenshots: ${screenshotService.capturedScreenshots.length}');
      print('📁 Output Directory: ${ScreenshotConfig.outputDirectory}');
      print('📄 Report: $reportPath');
    });

    testWidgets('Capture required owner screenshots only',
        (WidgetTester tester) async {
      authHelper = MockAuthHelper(tester);
      navigationHelper = NavigationHelper(tester);

      print('🚀 Starting Required Owner Screenshots Only');
      print('==========================================');

      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      // Login
      await authHelper.loginAsOwner();
      await navigationHelper.waitForScreenLoad();

      // Get only required screenshots
      final requiredScreenshots =
          ScreenshotConfig.getRequiredScreenshots('owner');
      print(
          '\n📸 Capturing ${requiredScreenshots.length} required screenshots...');

      for (final screenshotDef in requiredScreenshots) {
        print('\n📸 ${screenshotDef.name}');

        if (screenshotDef.route.isNotEmpty) {
          await navigationHelper.navigateToRoute(screenshotDef.route);
        }

        if (screenshotDef.navigationSteps != null) {
          await navigationHelper.executeNavigationSteps(
            screenshotDef.navigationSteps,
          );
        }

        await navigationHelper.waitForScreenLoad();
        await screenshotService.captureScreenshot(tester, screenshotDef);
        await Future.delayed(const Duration(milliseconds: 500));
      }

      print('\n✅ Required Owner Screenshots Complete!');
    });
  });
}
