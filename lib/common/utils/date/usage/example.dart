import 'package:atitia/common/utils/date/extensions/datetime_extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../date_manager.dart';

void example() {
  // Current time in different formats
  print('Now: ${DateManager.nowDisplay}'); // '25/12/2023'
  print('Service: ${DateManager.nowService}'); // ISO format
  print('Firestore: ${DateManager.nowFirestore}'); // Timestamp

  // Conversions between formats
  final displayDate = '15/08/1990';

  // Display → Firestore
  final firestoreTimestamp = DateManager.displayToFirestore(displayDate);
  print('Display to Firestore: $firestoreTimestamp');

  // Firestore → Display
  final backToDisplay = DateManager.firestoreToDisplay(firestoreTimestamp);
  print('Firestore to Display: $backToDisplay');

  // Display → Service
  final serviceFormat = DateManager.displayToService(displayDate);
  print('Display to Service: $serviceFormat');

  // Service → Display
  final backFromService = DateManager.serviceToDisplay(serviceFormat);
  print('Service to Display: $backFromService');

  // Service → Firestore
  final serviceToFirestore = DateManager.serviceToFirestore(serviceFormat);
  print('Service to Firestore: $serviceToFirestore');

  // Firestore → Service
  final firestoreToService = DateManager.firestoreToService(firestoreTimestamp);
  print('Firestore to Service: $firestoreToService');

  // Age calculation
  final age = DateManager.calculateAge(displayDate);
  print('Age from $displayDate: $age years');

  // Validation
  final validResult = DateManager.validateDisplay('15/08/1990');
  final invalidResult = DateManager.validateDisplay('32/13/2020');
  print('Valid date validation: $validResult'); // null
  print('Invalid date validation: $invalidResult'); // Error message

  // Using extensions directly
  final today = DateTime.now();
  print('Is today: ${today.isToday}');
  print('Display format: ${today.toDisplayFormat}');
  print('Service format: ${today.toServiceFormat}');
  print('Relative time: ${today.relativeTime}');

  // Using Timestamp extensions
  final timestamp = Timestamp.now();
  // print('Timestamp to display: ${timestamp.toDisplayFormat}');
  // print('Timestamp to service: ${timestamp.toServiceFormat}');
  // print('Timestamp relative: ${timestamp.relativeTime}');

  // Business logic
  final isAdult = DateManager.meetsMinimumAge('15/08/2000');
  print('Is 23-year-old an adult: $isAdult'); // true

  final isChild = DateManager.meetsMinimumAge('15/08/2020');
  print('Is 3-year-old an adult: $isChild'); // false

  // Relative time examples
  print('Now relative: ${DateManager.now.relativeTime}');
  print('Firestore relative: ${DateManager.firestoreRelativeTime(timestamp)}');
  print('Service relative: ${DateManager.serviceRelativeTime(serviceFormat)}');
  print('Display relative: ${DateManager.displayRelativeTime(displayDate)}');

  // Form validation
  final formError =
      DateManager.validateFormDate('15/08/2020', minAge: 18, maxAge: 100);
  print('Form validation: $formError'); // Must be at least 18 years old
}
