import 'package:cloud_firestore/cloud_firestore.dart';

import '../date_manager.dart';

void example() {
  // Current time in different formats

  // Conversions between formats
  final displayDate = '15/08/1990';

  // Display → Firestore
  final firestoreTimestamp = DateManager.displayToFirestore(displayDate);

  // Firestore → Display
  final backToDisplay = DateManager.firestoreToDisplay(firestoreTimestamp);

  // Display → Service
  final serviceFormat = DateManager.displayToService(displayDate);

  // Service → Display
  final backFromService = DateManager.serviceToDisplay(serviceFormat);

  // Service → Firestore
  final serviceToFirestore = DateManager.serviceToFirestore(serviceFormat);

  // Firestore → Service
  final firestoreToService = DateManager.firestoreToService(firestoreTimestamp);

  // Age calculation
  final age = DateManager.calculateAge(displayDate);

  // Validation
  final validResult = DateManager.validateDisplay('15/08/1990');
  final invalidResult = DateManager.validateDisplay('32/13/2020');

  // Using extensions directly
  final today = DateTime.now();

  // Using Timestamp extensions
  final timestamp = Timestamp.now();

  // Business logic
  final isAdult = DateManager.meetsMinimumAge('15/08/2000');

  final isChild = DateManager.meetsMinimumAge('15/08/2020');

  // Relative time examples

  // Form validation
  final formError =
      DateManager.validateFormDate('15/08/2020', minAge: 18, maxAge: 100);
}
