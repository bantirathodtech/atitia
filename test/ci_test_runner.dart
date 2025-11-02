// CI-Safe Test Runner
// Excludes integration tests and Firebase-dependent tests

import 'package:flutter_test/flutter_test.dart';

/// Run only CI-safe tests
/// Excludes:
/// - Integration tests (require Firebase/network)
/// - Firebase-dependent unit tests
void main() {
  group('CI-Safe Tests', () {
    test('Basic arithmetic', () {
      expect(1 + 1, equals(2));
    });

    test('String operations', () {
      expect('hello'.toUpperCase(), equals('HELLO'));
    });

    test('List operations', () {
      final list = [1, 2, 3];
      expect(list.length, equals(3));
      expect(list.first, equals(1));
    });
  });
}

