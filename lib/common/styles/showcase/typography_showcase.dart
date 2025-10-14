import 'package:flutter/material.dart';

import '../../../common/widgets/index.dart';

class TypographyShowcase extends StatelessWidget {
  const TypographyShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Typography Showcase')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            HeadingLarge(text: 'Heading Large - Roboto Bold 24pt'),
            SizedBox(height: 8),
            HeadingMedium(text: 'Heading Medium - Roboto Medium 20pt'),
            SizedBox(height: 8),
            HeadingSmall(text: 'Heading Small - Roboto Medium 18pt'),
            SizedBox(height: 16),

            // Body Text
            BodyText(text: 'Body Large - Roboto Regular 16pt'),
            SizedBox(height: 8),
            BodyText(text: 'Body Medium - Roboto Regular 14pt', medium: true),
            SizedBox(height: 8),
            BodyText(text: 'Body Small - Roboto Regular 12pt', small: true),
            SizedBox(height: 16),

            // OpenSans Font Family
            OpenSansText(text: 'OpenSans Regular'),
            SizedBox(height: 8),
            OpenSansText(text: 'OpenSans Bold', bold: true),
            SizedBox(height: 8),
            OpenSansText(text: 'OpenSans Medium', medium: true),
            SizedBox(height: 8),
            OpenSansText(text: 'OpenSans Italic', italic: true),
            SizedBox(height: 16),

            // Lato Font Family
            LatoText(text: 'Lato Regular'),
            SizedBox(height: 8),
            LatoText(text: 'Lato Bold', bold: true),
            SizedBox(height: 8),
            LatoText(text: 'Lato Light', light: true),
            SizedBox(height: 8),
            LatoText(text: 'Lato Italic', italic: true),
            SizedBox(height: 16),

            // Special Text Styles
            CaptionText(text: 'Caption - Lato Light 12pt'),
            SizedBox(height: 8),
            OverlineText(text: 'Overline - Lato Light 10pt'),
            SizedBox(height: 8),
            ButtonText(text: 'Button Text - Roboto Medium 16pt'),
            SizedBox(height: 8),
            ButtonText(text: 'Button Bold Text - Roboto Bold 16pt', bold: true),
          ],
        ),
      ),
    );
  }
}
