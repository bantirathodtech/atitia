// Basic widget tests for Atitia PG Management App
//
// This test file contains basic widget tests for core UI components
// to ensure proper rendering and basic functionality.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Atitia Basic Widget Tests', () {
    testWidgets('Material App widget renders correctly',
        (WidgetTester tester) async {
      // Build a simple MaterialApp widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Hello World'),
            ),
          ),
        ),
      );

      // Verify that the app builds successfully
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Text widget renders correctly', (WidgetTester tester) async {
      // Build a simple text widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Test Text'),
            ),
          ),
        ),
      );

      // Verify text is displayed
      expect(find.text('Test Text'), findsOneWidget);
    });

    testWidgets('Button widget renders correctly', (WidgetTester tester) async {
      // Build a simple button widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: null,
                child: Text('Test Button'),
              ),
            ),
          ),
        ),
      );

      // Verify button is displayed
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('TextField widget renders correctly',
        (WidgetTester tester) async {
      // Build a simple text field widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter text',
                ),
              ),
            ),
          ),
        ),
      );

      // Verify text field is displayed
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter text'), findsOneWidget);
    });

    testWidgets('Icon widget renders correctly', (WidgetTester tester) async {
      // Build a simple icon widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Icon(Icons.home),
            ),
          ),
        ),
      );

      // Verify icon is displayed
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('Container widget renders correctly',
        (WidgetTester tester) async {
      // Build a simple container widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
                child: const Text('Container'),
              ),
            ),
          ),
        ),
      );

      // Verify container is displayed
      expect(find.byType(Container), findsOneWidget);
      expect(find.text('Container'), findsOneWidget);
    });

    testWidgets('Column widget renders correctly', (WidgetTester tester) async {
      // Build a simple column widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Text('First'),
                  Text('Second'),
                  Text('Third'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify column is displayed
      expect(find.byType(Column), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Third'), findsOneWidget);
    });

    testWidgets('Row widget renders correctly', (WidgetTester tester) async {
      // Build a simple row widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Row(
                children: [
                  Text('Left'),
                  Text('Right'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify row is displayed
      expect(find.byType(Row), findsOneWidget);
      expect(find.text('Left'), findsOneWidget);
      expect(find.text('Right'), findsOneWidget);
    });

    testWidgets('ListView widget renders correctly',
        (WidgetTester tester) async {
      // Build a simple list view widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView(
              children: const [
                ListTile(title: Text('Item 1')),
                ListTile(title: Text('Item 2')),
                ListTile(title: Text('Item 3')),
              ],
            ),
          ),
        ),
      );

      // Verify list view is displayed
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('Card widget renders correctly', (WidgetTester tester) async {
      // Build a simple card widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Card Content'),
                ),
              ),
            ),
          ),
        ),
      );

      // Verify card is displayed
      expect(find.byType(Card), findsOneWidget);
      expect(find.text('Card Content'), findsOneWidget);
    });
  });
}
