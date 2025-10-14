// lib/core/models/maintenance_task_model.dart

import 'dart:ui';

import '../../common/styles/colors.dart';

/// Model for PG maintenance tasks and schedules
/// Tracks recurring and one-time maintenance activities
class MaintenanceTaskModel {
  final String taskId;
  final String pgId;
  final String ownerId;
  final String title;
  final String? description;
  final String
      category; // 'cleaning', 'repairs', 'inspection', 'pest_control', 'other'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final String status; // 'pending', 'in_progress', 'completed', 'cancelled'
  final DateTime scheduledDate;
  final DateTime? completedDate;
  final String? assignedTo;
  final double? estimatedCost;
  final double? actualCost;
  final String? notes;
  final bool isRecurring;
  final int? recurringDays; // null if not recurring
  final List<String>? affectedAreas; // ['Floor 1', 'Room 101', etc.]
  final DateTime createdAt;
  final DateTime updatedAt;

  MaintenanceTaskModel({
    required this.taskId,
    required this.pgId,
    required this.ownerId,
    required this.title,
    this.description,
    required this.category,
    this.priority = 'medium',
    this.status = 'pending',
    required this.scheduledDate,
    this.completedDate,
    this.assignedTo,
    this.estimatedCost,
    this.actualCost,
    this.notes,
    this.isRecurring = false,
    this.recurringDays,
    this.affectedAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory MaintenanceTaskModel.fromMap(Map<String, dynamic> map) {
    return MaintenanceTaskModel(
      taskId: map['taskId'] as String,
      pgId: map['pgId'] as String,
      ownerId: map['ownerId'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      category: map['category'] as String,
      priority: map['priority'] as String? ?? 'medium',
      status: map['status'] as String? ?? 'pending',
      scheduledDate: DateTime.parse(map['scheduledDate'] as String),
      completedDate: map['completedDate'] != null
          ? DateTime.parse(map['completedDate'] as String)
          : null,
      assignedTo: map['assignedTo'] as String?,
      estimatedCost: (map['estimatedCost'] as num?)?.toDouble(),
      actualCost: (map['actualCost'] as num?)?.toDouble(),
      notes: map['notes'] as String?,
      isRecurring: map['isRecurring'] as bool? ?? false,
      recurringDays: map['recurringDays'] as int?,
      affectedAreas: (map['affectedAreas'] as List<dynamic>?)?.cast<String>(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'pgId': pgId,
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'scheduledDate': scheduledDate.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'assignedTo': assignedTo,
      'estimatedCost': estimatedCost,
      'actualCost': actualCost,
      'notes': notes,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'affectedAreas': affectedAreas,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  MaintenanceTaskModel copyWith({
    String? taskId,
    String? pgId,
    String? ownerId,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    DateTime? scheduledDate,
    DateTime? completedDate,
    String? assignedTo,
    double? estimatedCost,
    double? actualCost,
    String? notes,
    bool? isRecurring,
    int? recurringDays,
    List<String>? affectedAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaintenanceTaskModel(
      taskId: taskId ?? this.taskId,
      pgId: pgId ?? this.pgId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      assignedTo: assignedTo ?? this.assignedTo,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      actualCost: actualCost ?? this.actualCost,
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
      affectedAreas: affectedAreas ?? this.affectedAreas,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Getters
  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isOverdue => !isCompleted && DateTime.now().isAfter(scheduledDate);
  bool get isHighPriority => priority == 'high' || priority == 'urgent';

  String get categoryDisplay {
    switch (category) {
      case 'cleaning':
        return 'Cleaning';
      case 'repairs':
        return 'Repairs';
      case 'inspection':
        return 'Inspection';
      case 'pest_control':
        return 'Pest Control';
      default:
        return 'Other';
    }
  }

  String get priorityDisplay {
    switch (priority) {
      case 'low':
        return 'Low';
      case 'medium':
        return 'Medium';
      case 'high':
        return 'High';
      case 'urgent':
        return 'Urgent';
      default:
        return priority;
    }
  }

  String get statusDisplay {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'low':
        return AppColors.info;
      case 'medium':
        return AppColors.warning;
      case 'high':
        return AppColors.error;
      case 'urgent':
        return const Color(0xFFD32F2F); // Dark red
      default:
        return AppColors.textSecondary;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String get formattedScheduledDate =>
      '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}';
  String get formattedEstimatedCost =>
      estimatedCost != null ? '₹${estimatedCost!.toStringAsFixed(0)}' : 'N/A';
  String get formattedActualCost =>
      actualCost != null ? '₹${actualCost!.toStringAsFixed(0)}' : 'N/A';
}
