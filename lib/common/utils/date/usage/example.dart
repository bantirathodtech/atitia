import 'package:cloud_firestore/cloud_firestore.dart';

import '../date_manager.dart';

void example() {
  // Current time in different formats

  // Conversions between formats
  final displayDate = '15/08/1990';

  // Display → Firestore
  final firestoreTimestamp = DateManager.displayToFirestore(displayDate);

  // Firestore → Display
  DateManager.firestoreToDisplay(firestoreTimestamp); // Example usage

  // Display → Service
  final serviceFormat = DateManager.displayToService(displayDate);

  // Service → Display
  DateManager.serviceToDisplay(serviceFormat); // Example usage

  // Service → Firestore
  DateManager.serviceToFirestore(serviceFormat); // Example usage

  // Firestore → Service
  DateManager.firestoreToService(firestoreTimestamp); // Example usage

  // Age calculation
  DateManager.calculateAge(displayDate); // Example usage

  // Validation
  DateManager.validateDisplay('15/08/1990'); // Example usage
  DateManager.validateDisplay('32/13/2020'); // Example usage

  // Using extensions directly
  DateTime.now(); // Example usage

  // Using Timestamp extensions
  Timestamp.now(); // Example usage

  // Business logic
  DateManager.meetsMinimumAge('15/08/2000'); // Example usage

  DateManager.meetsMinimumAge('15/08/2020'); // Example usage

  // Relative time examples

  // Form validation
  DateManager.validateFormDate('15/08/2020',
      minAge: 18, maxAge: 100); // Example usage
}
