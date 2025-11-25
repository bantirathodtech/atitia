# Web URLs Usage Guide

## Overview

All Atitia public web page URLs are centralized in `lib/common/utils/constants/web_urls.dart` for easy access and maintenance.

## Available URLs

### Legal & Compliance Pages

- **Privacy Policy**: `WebUrls.privacyPolicy`
- **Terms of Service**: `WebUrls.termsOfService`
- **Refund Policy**: `WebUrls.refundPolicy`
- **Account Deletion**: `WebUrls.accountDeletion`

### Business & Information Pages

- **Home**: `WebUrls.home`
- **About Us**: `WebUrls.aboutUs`
- **Contact Us**: `WebUrls.contactUs`
- **Pricing**: `WebUrls.pricing`

## Usage Examples

### Basic URL Access

```dart
import 'package:atitia/common/utils/constants/web_urls.dart';

// Get a URL
final privacyUrl = WebUrls.privacyPolicy;
final pricingUrl = WebUrls.pricing;
```

### Opening URLs in Browser

```dart
import 'package:atitia/common/utils/web_url_launcher.dart';
import 'package:atitia/common/utils/constants/web_urls.dart';

// Simple open (no error handling)
await WebUrlLauncher.openUrl(WebUrls.privacyPolicy);

// With error handling
await WebUrlLauncher.openPrivacyPolicy(
  showError: true,
  context: context,
);

// Convenience methods for each URL
await WebUrlLauncher.openPrivacyPolicy();
await WebUrlLauncher.openTermsOfService();
await WebUrlLauncher.openRefundPolicy();
await WebUrlLauncher.openContactUs();
await WebUrlLauncher.openAboutUs();
await WebUrlLauncher.openPricing();
await WebUrlLauncher.openAccountDeletion();
await WebUrlLauncher.openHome();
```

### In Widget Build Methods

```dart
import 'package:flutter/material.dart';
import 'package:atitia/common/utils/web_url_launcher.dart';
import 'package:atitia/common/utils/constants/web_urls.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Privacy Policy'),
      trailing: Icon(Icons.open_in_new),
      onTap: () => WebUrlLauncher.openPrivacyPolicy(
        showError: true,
        context: context,
      ),
    );
  }
}
```

### Getting All URLs

```dart
// Get all legal URLs
final legalUrls = WebUrls.legalUrls;

// Get all business URLs
final businessUrls = WebUrls.businessUrls;

// Get all URLs
final allUrls = WebUrls.allUrls;

// Iterate over URLs
WebUrls.allUrls.forEach((key, url) {
  print('$key: $url');
});
```

### Validating URLs

```dart
// Check if URL is a valid Atitia URL
final isValid = WebUrls.isValidAtitiaUrl(url);
```

## Migration from Old Code

### Before (Deprecated)

```dart
import 'package:atitia/common/utils/constants/app.dart';

final url = AppConstants.privacyPolicyUrl;
```

### After (Recommended)

```dart
import 'package:atitia/common/utils/constants/web_urls.dart';

final url = WebUrls.privacyPolicy;
```

## All URLs List

| Page | Constant | URL |
|------|----------|-----|
| Home | `WebUrls.home` | https://sites.google.com/view/atitia/home |
| Privacy Policy | `WebUrls.privacyPolicy` | https://sites.google.com/view/atitia/privacy-policy |
| Terms of Service | `WebUrls.termsOfService` | https://sites.google.com/view/atitia/terms-of-service |
| Contact Us | `WebUrls.contactUs` | https://sites.google.com/view/atitia/contact-us |
| Account Deletion | `WebUrls.accountDeletion` | https://sites.google.com/view/atitia/account-deletion |
| Pricing | `WebUrls.pricing` | https://sites.google.com/view/atitia/pricing |
| Cancellation/Refund | `WebUrls.refundPolicy` | https://sites.google.com/view/atitia/cancellationrefund |
| About Us | `WebUrls.aboutUs` | https://sites.google.com/view/atitia/about-us |

## Razorpay KYC Requirements

All required pages for Razorpay KYC verification are available:

- ✅ Privacy Policy
- ✅ Terms of Service
- ✅ Contact Us
- ✅ About Us
- ✅ Pricing
- ✅ Cancellation/Refund Policy

## Notes

- All URLs are publicly accessible on Google Sites
- URLs should only be updated in `web_urls.dart` to maintain consistency
- Use `WebUrlLauncher` for opening URLs with proper error handling
- Old `AppConstants.privacyPolicyUrl` is deprecated but still works (points to new URL)

