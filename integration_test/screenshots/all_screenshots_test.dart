// integration_test/screenshots/all_screenshots_test.dart
//
// Complete screenshot capture test for both Guest and Owner flows
// Captures all recommended screenshots in a single run

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:atitia/main.dart' as app;

import '../config/screenshot_config.dart';
import '../services/screenshot_service.dart';
import '../helpers/mock_auth_helper.dart';
import '../helpers/navigation_helper.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Complete Screenshot Capture (Guest + Owner)', () {
    late ScreenshotService screenshotService;
    late MockAuthHelper authHelper;
    late NavigationHelper navigationHelper;

    setUp(() {
      screenshotService = ScreenshotService();
    });

    testWidgets('Capture all screenshots for both flows', (WidgetTester tester) async {
      authHelper = MockAuthHelper(tester);
      navigationHelper = NavigationHelper(tester);

      print('🚀 Starting Complete Screenshot Capture');
      print('==========================================');
      print('This will capture screenshots for both Guest and Owner flows');
      print('');

      // Start the app
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      // ============================================================
      // PART 1: GUEST FLOW
      // ============================================================
      print('\n👤 PART 1: Guest Flow Screenshots');
      print('-----------------------------------');

      // Login as guest
      print('\n📱 Authenticating as Guest...');
      await authHelper.loginAsGuest();
      await navigationHelper.waitForScreenLoad();
      
      // Set system theme mode
      print('\n🎨 Setting System Theme Mode...');
      await authHelper.setSystemThemeMode();
      await navigationHelper.waitForScreenLoad();

      // Capture guest screenshots
      final guestScreenshots = ScreenshotConfig.getScreenshotsByRole('guest');
      print('📸 Capturing ${guestScreenshots.length} guest screenshots...');

      for (final screenshotDef in guestScreenshots) {
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

      print('\n✅ Guest flow complete!');

      // ============================================================
      // PART 2: OWNER FLOW
      // ============================================================
      print('\n\n👔 PART 2: Owner Flow Screenshots');
      print('-----------------------------------');

      // Logout guest and login as owner
      print('\n📱 Logging out and authenticating as Owner...');
      await authHelper.logout();
      await Future.delayed(const Duration(seconds: 3)); // Wait longer for logout
      await tester.pumpAndSettle();
      await authHelper.loginAsOwner();
      await navigationHelper.waitForScreenLoad();
      
      // Ensure system theme mode is still set
      await authHelper.setSystemThemeMode();
      await navigationHelper.waitForScreenLoad();

      // Capture owner screenshots
      final ownerScreenshots = ScreenshotConfig.getScreenshotsByRole('owner');
      print('📸 Capturing ${ownerScreenshots.length} owner screenshots...');

      for (final screenshotDef in ownerScreenshots) {
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

      print('\n✅ Owner flow complete!');

      // ============================================================
      // PART 3: GENERATE REPORTS
      // ============================================================
      print('\n\n📄 PART 3: Generating Reports');
      print('-----------------------------------');

      final reportPath = '${ScreenshotConfig.outputDirectory}/complete_report.md';
      await screenshotService.saveReport(reportPath);

      print('\n✅ Complete Screenshot Capture Finished!');
      print('==========================================');
      print('📊 Total Screenshots: ${screenshotService.capturedScreenshots.length}');
      print('📁 Output Directory: ${ScreenshotConfig.outputDirectory}');
      print('📄 Report: $reportPath');
      print('');
      print('Next steps:');
      print('1. Review screenshots in: ${ScreenshotConfig.outputDirectory}');
      print('2. Resize to 1080x1920 if needed');
      print('3. Upload to Google Play Console');
    });
  });
}

