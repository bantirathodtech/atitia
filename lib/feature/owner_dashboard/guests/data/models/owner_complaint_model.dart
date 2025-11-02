// lib/feature/owner_dashboard/guests/data/models/owner_complaint_model.dart

import 'package:equatable/equatable.dart';

/// Model representing a complaint in the owner's PG management system
/// Contains complaint information, status tracking, and conversation history
class OwnerComplaintModel extends Equatable {
  final String complaintId;
  final String guestId;
  final String guestName;
  final String pgId;
  final String ownerId;
  final String roomNumber;
  final String complaintType;
  final String title;
  final String description;
  final String status; // new, in_progress, resolved, closed
  final String priority; // low, medium, high, urgent
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ComplaintMessage> messages;
  final String? assignedTo;
  final DateTime? resolvedAt;
  final String? resolutionNotes;
  final bool isActive;

  const OwnerComplaintModel({
    required this.complaintId,
    required this.guestId,
    required this.guestName,
    required this.pgId,
    required this.ownerId,
    required this.roomNumber,
    required this.complaintType,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    this.assignedTo,
    this.resolvedAt,
    this.resolutionNotes,
    required this.isActive,
  });

  /// Create OwnerComplaintModel from Firestore document
  factory OwnerComplaintModel.fromMap(Map<String, dynamic> data) {
    return OwnerComplaintModel(
      complaintId: data['complaintId'] ?? '',
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      pgId: data['pgId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      complaintType: data['complaintType'] ?? 'general',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'new',
      priority: data['priority'] ?? 'medium',
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : DateTime.now(),
      messages: (data['messages'] as List<dynamic>?)
              ?.map((msg) => ComplaintMessage.fromMap(msg))
              .toList() ??
          [],
      assignedTo: data['assignedTo'],
      resolvedAt: data['resolvedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['resolvedAt'])
          : null,
      resolutionNotes: data['resolutionNotes'],
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert OwnerComplaintModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'guestId': guestId,
      'guestName': guestName,
      'pgId': pgId,
      'ownerId': ownerId,
      'roomNumber': roomNumber,
      'complaintType': complaintType,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'assignedTo': assignedTo,
      'resolvedAt': resolvedAt?.millisecondsSinceEpoch,
      'resolutionNotes': resolutionNotes,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  OwnerComplaintModel copyWith({
    String? complaintId,
    String? guestId,
    String? guestName,
    String? pgId,
    String? ownerId,
    String? roomNumber,
    String? complaintType,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ComplaintMessage>? messages,
    String? assignedTo,
    DateTime? resolvedAt,
    String? resolutionNotes,
    bool? isActive,
  }) {
    return OwnerComplaintModel(
      complaintId: complaintId ?? this.complaintId,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      roomNumber: roomNumber ?? this.roomNumber,
      complaintType: complaintType ?? this.complaintType,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
      assignedTo: assignedTo ?? this.assignedTo,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        complaintId,
        guestId,
        guestName,
        pgId,
        ownerId,
        roomNumber,
        complaintType,
        title,
        description,
        status,
        priority,
        createdAt,
        updatedAt,
        messages,
        assignedTo,
        resolvedAt,
        resolutionNotes,
        isActive,
      ];

  /// Get status display
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'new':
        return 'New';
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      default:
        return 'Unknown';
    }
  }

  /// Get priority display
  String get priorityDisplay {
    switch (priority.toLowerCase()) {
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Medium';
    }
  }

  /// Check if complaint is new
  bool get isNew => status.toLowerCase() == 'new';

  /// Check if complaint is resolved
  bool get isResolved => status.toLowerCase() == 'resolved';

  /// Get latest message
  ComplaintMessage? get latestMessage {
    if (messages.isEmpty) return null;
    messages.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return messages.first;
  }

  /// Get unread message count for owner
  int get unreadOwnerMessages {
    return messages
        .where((msg) => !msg.isReadByOwner && msg.senderType == 'guest')
        .length;
  }
}

/// Model representing a message in a complaint conversation
class ComplaintMessage extends Equatable {
  final String messageId;
  final String senderId;
  final String senderName;
  final String senderType; // guest, owner, staff
  final String message;
  final DateTime timestamp;
  final bool isReadByGuest;
  final bool isReadByOwner;
  final String? attachmentUrl;

  const ComplaintMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.timestamp,
    required this.isReadByGuest,
    required this.isReadByOwner,
    this.attachmentUrl,
  });

  /// Create ComplaintMessage from Firestore document
  factory ComplaintMessage.fromMap(Map<String, dynamic> data) {
    return ComplaintMessage(
      messageId: data['messageId'] ?? '',
      senderId: data['senderId'] ?? '',
      senderName: data['senderName'] ?? '',
      senderType: data['senderType'] ?? 'guest',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['timestamp'])
          : DateTime.now(),
      isReadByGuest: data['isReadByGuest'] ?? false,
      isReadByOwner: data['isReadByOwner'] ?? false,
      attachmentUrl: data['attachmentUrl'],
    );
  }

  /// Convert ComplaintMessage to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'senderName': senderName,
      'senderType': senderType,
      'message': message,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isReadByGuest': isReadByGuest,
      'isReadByOwner': isReadByOwner,
      'attachmentUrl': attachmentUrl,
    };
  }

  @override
  List<Object?> get props => [
        messageId,
        senderId,
        senderName,
        senderType,
        message,
        timestamp,
        isReadByGuest,
        isReadByOwner,
        attachmentUrl,
      ];

  /// Check if message is from guest
  bool get isFromGuest => senderType.toLowerCase() == 'guest';

  /// Check if message is from owner
  bool get isFromOwner => senderType.toLowerCase() == 'owner';

  /// Get formatted timestamp
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
