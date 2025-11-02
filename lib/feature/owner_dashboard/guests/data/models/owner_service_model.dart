// lib/feature/owner_dashboard/guests/data/models/owner_service_model.dart

import 'package:equatable/equatable.dart';

/// Model representing a service request in the owner's PG management system
/// Contains service request information, type, status, and conversation history
class OwnerServiceModel extends Equatable {
  final String serviceId;
  final String guestId;
  final String guestName;
  final String pgId;
  final String ownerId;
  final String roomNumber;
  final String serviceType; // maintenance, housekeeping, vehicle, other
  final String title;
  final String description;
  final String status; // new, in_progress, completed, cancelled
  final String priority; // low, medium, high, urgent
  final DateTime requestedAt;
  final DateTime? assignedAt;
  final DateTime? completedAt;
  final String? assignedTo;
  final String? assignedToName;
  final String? completionNotes;
  final List<ServiceMessage> messages;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const OwnerServiceModel({
    required this.serviceId,
    required this.guestId,
    required this.guestName,
    required this.pgId,
    required this.ownerId,
    required this.roomNumber,
    required this.serviceType,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.requestedAt,
    this.assignedAt,
    this.completedAt,
    this.assignedTo,
    this.assignedToName,
    this.completionNotes,
    required this.messages,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  /// Create OwnerServiceModel from Firestore document
  factory OwnerServiceModel.fromMap(Map<String, dynamic> data) {
    return OwnerServiceModel(
      serviceId: data['serviceId'] ?? '',
      guestId: data['guestId'] ?? '',
      guestName: data['guestName'] ?? '',
      pgId: data['pgId'] ?? '',
      ownerId: data['ownerId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      serviceType: data['serviceType'] ?? 'other',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'new',
      priority: data['priority'] ?? 'medium',
      requestedAt: data['requestedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['requestedAt'])
          : DateTime.now(),
      assignedAt: data['assignedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['assignedAt'])
          : null,
      completedAt: data['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['completedAt'])
          : null,
      assignedTo: data['assignedTo'],
      assignedToName: data['assignedToName'],
      completionNotes: data['completionNotes'],
      messages: (data['messages'] as List<dynamic>?)
              ?.map((msg) => ServiceMessage.fromMap(msg))
              .toList() ??
          [],
      photoUrl: data['photoUrl'],
      createdAt: data['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['createdAt'])
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['updatedAt'])
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert OwnerServiceModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'serviceId': serviceId,
      'guestId': guestId,
      'guestName': guestName,
      'pgId': pgId,
      'ownerId': ownerId,
      'roomNumber': roomNumber,
      'serviceType': serviceType,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'requestedAt': requestedAt.millisecondsSinceEpoch,
      'assignedAt': assignedAt?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
      'completionNotes': completionNotes,
      'messages': messages.map((msg) => msg.toMap()).toList(),
      'photoUrl': photoUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  /// Create a copy with updated fields
  OwnerServiceModel copyWith({
    String? serviceId,
    String? guestId,
    String? guestName,
    String? pgId,
    String? ownerId,
    String? roomNumber,
    String? serviceType,
    String? title,
    String? description,
    String? status,
    String? priority,
    DateTime? requestedAt,
    DateTime? assignedAt,
    DateTime? completedAt,
    String? assignedTo,
    String? assignedToName,
    String? completionNotes,
    List<ServiceMessage>? messages,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return OwnerServiceModel(
      serviceId: serviceId ?? this.serviceId,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      roomNumber: roomNumber ?? this.roomNumber,
      serviceType: serviceType ?? this.serviceType,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      requestedAt: requestedAt ?? this.requestedAt,
      assignedAt: assignedAt ?? this.assignedAt,
      completedAt: completedAt ?? this.completedAt,
      assignedTo: assignedTo ?? this.assignedTo,
      assignedToName: assignedToName ?? this.assignedToName,
      completionNotes: completionNotes ?? this.completionNotes,
      messages: messages ?? this.messages,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        serviceId,
        guestId,
        guestName,
        pgId,
        ownerId,
        roomNumber,
        serviceType,
        title,
        description,
        status,
        priority,
        requestedAt,
        assignedAt,
        completedAt,
        assignedTo,
        assignedToName,
        completionNotes,
        messages,
        photoUrl,
        createdAt,
        updatedAt,
        isActive,
      ];

  /// Get service type display
  String get serviceTypeDisplay {
    switch (serviceType.toLowerCase()) {
      case 'maintenance':
        return 'Maintenance';
      case 'housekeeping':
        return 'Housekeeping';
      case 'vehicle':
        return 'Vehicle';
      case 'other':
        return 'Other';
      default:
        return 'Other';
    }
  }

  /// Get status display
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'new':
        return 'New';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
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

  /// Check if service is new
  bool get isNew => status.toLowerCase() == 'new';

  /// Check if service is completed
  bool get isCompleted => status.toLowerCase() == 'completed';

  /// Check if service is in progress
  bool get isInProgress => status.toLowerCase() == 'in_progress';

  /// Get latest message
  ServiceMessage? get latestMessage {
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

  /// Get service duration
  Duration? get serviceDuration {
    if (assignedAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(assignedAt!);
  }

  /// Get formatted service duration
  String get formattedServiceDuration {
    final duration = serviceDuration;
    if (duration == null) return 'Not assigned';

    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}

/// Model representing a message in a service request conversation
class ServiceMessage extends Equatable {
  final String messageId;
  final String senderId;
  final String senderName;
  final String senderType; // guest, owner, staff
  final String message;
  final DateTime timestamp;
  final bool isReadByGuest;
  final bool isReadByOwner;
  final String? attachmentUrl;

  const ServiceMessage({
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

  /// Create ServiceMessage from Firestore document
  factory ServiceMessage.fromMap(Map<String, dynamic> data) {
    return ServiceMessage(
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

  /// Convert ServiceMessage to Firestore document
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

  /// Check if message is from staff
  bool get isFromStaff => senderType.toLowerCase() == 'staff';

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
