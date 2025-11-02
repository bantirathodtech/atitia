// guest_complaint_model.dart

/// Model representing a complaint submitted by a guest.
library;

import '../../../../../common/utils/date/converter/date_service_converter.dart';

class GuestComplaintModel {
  final String complaintId;
  final String guestId;
  final String pgId;
  final String? ownerId;
  final String subject;
  final String description;
  final DateTime complaintDate;
  final String status; // e.g., Pending, Resolved, Closed
  final List<String> photos; // URLs of attached images

  GuestComplaintModel({
    required this.complaintId,
    required this.guestId,
    required this.pgId,
    this.ownerId,
    required this.subject,
    required this.description,
    required this.complaintDate,
    required this.status,
    required this.photos,
  });

  /// Creates a Complaint model instance from Firestore map data.
  factory GuestComplaintModel.fromMap(Map<String, dynamic> map) {
    return GuestComplaintModel(
      complaintId: map['complaintId'] ?? '',
      guestId: map['guestId'] ?? '',
      pgId: map['pgId'] ?? '',
      ownerId: map['ownerId'],
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      complaintDate: map['complaintDate'] != null
          ? DateServiceConverter.fromService(map['complaintDate'])
          : DateTime.now(),
      status: map['status'] ?? 'Pending',
      photos: List<String>.from(map['photos'] ?? []),
    );
  }

  /// Converts the complaint instance into a Map for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'guestId': guestId,
      'pgId': pgId,
      'ownerId': ownerId,
      'subject': subject,
      'description': description,
      'complaintDate': DateServiceConverter.toService(complaintDate),
      'status': status,
      'photos': photos,
    };
  }
}
