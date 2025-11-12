import 'package:flutter/material.dart';

import '../../../common/widgets/index.dart';
import '../../../common/styles/spacing.dart';

class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Typography Showcase')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            HeadingLarge(text: 'Heading Large - Roboto Bold 24pt'),
            SizedBox(height: AppSpacing.paddingS),
            HeadingMedium(text: 'Heading Medium - Roboto Medium 20pt'),
            SizedBox(height: AppSpacing.paddingS),
            HeadingSmall(text: 'Heading Small - Roboto Medium 18pt'),
            SizedBox(height: AppSpacing.paddingM),

            // Body Text
            BodyText(text: 'Body Large - Roboto Regular 16pt'),
            SizedBox(height: AppSpacing.paddingS),
            BodyText(text: 'Body Medium - Roboto Regular 14pt', medium: true),
            SizedBox(height: AppSpacing.paddingS),
            BodyText(text: 'Body Small - Roboto Regular 12pt', small: true),
            SizedBox(height: AppSpacing.paddingM),

            // OpenSans Font Family
            OpenSansText(text: 'OpenSans Regular'),
            SizedBox(height: AppSpacing.paddingS),
            OpenSansText(text: 'OpenSans Bold', bold: true),
            SizedBox(height: AppSpacing.paddingS),
            OpenSansText(text: 'OpenSans Medium', medium: true),
            SizedBox(height: AppSpacing.paddingS),
            OpenSansText(text: 'OpenSans Italic', italic: true),
            SizedBox(height: AppSpacing.paddingM),

            // Lato Font Family
            LatoText(text: 'Lato Regular'),
            SizedBox(height: AppSpacing.paddingS),
            LatoText(text: 'Lato Bold', bold: true),
            SizedBox(height: AppSpacing.paddingS),
            LatoText(text: 'Lato Light', light: true),
            SizedBox(height: AppSpacing.paddingS),
            LatoText(text: 'Lato Italic', italic: true),
            SizedBox(height: AppSpacing.paddingM),

            // Special Text Styles
            CaptionText(text: 'Caption - Lato Light 12pt'),
            SizedBox(height: AppSpacing.paddingS),
            OverlineText(text: 'Overline - Lato Light 10pt'),
            SizedBox(height: AppSpacing.paddingS),
            ButtonText(text: 'Button Text - Roboto Medium 16pt'),
            SizedBox(height: AppSpacing.paddingS),
            ButtonText(text: 'Button Bold Text - Roboto Bold 16pt', bold: true),
          ],
        ),
      ),
    );
  }
}
