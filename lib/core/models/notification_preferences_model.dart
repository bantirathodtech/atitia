// lib/core/models/notification_preferences_model.dart

/// Model for user notification preferences
/// Controls how and when users receive notifications (push, email, SMS)
class NotificationPreferencesModel {
  final String userId;
  
  // Push notification preferences
  final bool pushEnabled;
  final bool pushNewBooking;
  final bool pushPaymentReceived;
  final bool pushComplaint;
  final bool pushMaintenance;
  final bool pushGuestActivity;
  
  // Email preferences
  final bool emailEnabled;
  final bool emailDailySummary;
  final bool emailWeeklyReport;
  final bool emailPaymentReminders;
  final bool emailMaintenanceAlerts;
  
  // SMS preferences
  final bool smsEnabled;
  final bool smsUrgentOnly;
  final bool smsPaymentConfirmation;
  
  // Quiet hours
  final bool quietHoursEnabled;
  final int quietHoursStart; // Hour (0-23)
  final int quietHoursEnd; // Hour (0-23)
  
  final DateTime lastUpdated;

  NotificationPreferencesModel({
    required this.userId,
    this.pushEnabled = true,
    this.pushNewBooking = true,
    this.pushPaymentReceived = true,
    this.pushComplaint = true,
    this.pushMaintenance = true,
    this.pushGuestActivity = false,
    this.emailEnabled = true,
    this.emailDailySummary = true,
    this.emailWeeklyReport = true,
    this.emailPaymentReminders = true,
    this.emailMaintenanceAlerts = true,
    this.smsEnabled = false,
    this.smsUrgentOnly = true,
    this.smsPaymentConfirmation = false,
    this.quietHoursEnabled = false,
    this.quietHoursStart = 22, // 10 PM
    this.quietHoursEnd = 8, // 8 AM
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory NotificationPreferencesModel.fromMap(Map<String, dynamic> map) {
    return NotificationPreferencesModel(
      userId: map['userId'] as String,
      pushEnabled: map['pushEnabled'] as bool? ?? true,
      pushNewBooking: map['pushNewBooking'] as bool? ?? true,
      pushPaymentReceived: map['pushPaymentReceived'] as bool? ?? true,
      pushComplaint: map['pushComplaint'] as bool? ?? true,
      pushMaintenance: map['pushMaintenance'] as bool? ?? true,
      pushGuestActivity: map['pushGuestActivity'] as bool? ?? false,
      emailEnabled: map['emailEnabled'] as bool? ?? true,
      emailDailySummary: map['emailDailySummary'] as bool? ?? true,
      emailWeeklyReport: map['emailWeeklyReport'] as bool? ?? true,
      emailPaymentReminders: map['emailPaymentReminders'] as bool? ?? true,
      emailMaintenanceAlerts: map['emailMaintenanceAlerts'] as bool? ?? true,
      smsEnabled: map['smsEnabled'] as bool? ?? false,
      smsUrgentOnly: map['smsUrgentOnly'] as bool? ?? true,
      smsPaymentConfirmation: map['smsPaymentConfirmation'] as bool? ?? false,
      quietHoursEnabled: map['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: map['quietHoursStart'] as int? ?? 22,
      quietHoursEnd: map['quietHoursEnd'] as int? ?? 8,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pushEnabled': pushEnabled,
      'pushNewBooking': pushNewBooking,
      'pushPaymentReceived': pushPaymentReceived,
      'pushComplaint': pushComplaint,
      'pushMaintenance': pushMaintenance,
      'pushGuestActivity': pushGuestActivity,
      'emailEnabled': emailEnabled,
      'emailDailySummary': emailDailySummary,
      'emailWeeklyReport': emailWeeklyReport,
      'emailPaymentReminders': emailPaymentReminders,
      'emailMaintenanceAlerts': emailMaintenanceAlerts,
      'smsEnabled': smsEnabled,
      'smsUrgentOnly': smsUrgentOnly,
      'smsPaymentConfirmation': smsPaymentConfirmation,
      'quietHoursEnabled': quietHoursEnabled,
      'quietHoursStart': quietHoursStart,
      'quietHoursEnd': quietHoursEnd,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  NotificationPreferencesModel copyWith({
    String? userId,
    bool? pushEnabled,
    bool? pushNewBooking,
    bool? pushPaymentReceived,
    bool? pushComplaint,
    bool? pushMaintenance,
    bool? pushGuestActivity,
    bool? emailEnabled,
    bool? emailDailySummary,
    bool? emailWeeklyReport,
    bool? emailPaymentReminders,
    bool? emailMaintenanceAlerts,
    bool? smsEnabled,
    bool? smsUrgentOnly,
    bool? smsPaymentConfirmation,
    bool? quietHoursEnabled,
    int? quietHoursStart,
    int? quietHoursEnd,
    DateTime? lastUpdated,
  }) {
    return NotificationPreferencesModel(
      userId: userId ?? this.userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      pushNewBooking: pushNewBooking ?? this.pushNewBooking,
      pushPaymentReceived: pushPaymentReceived ?? this.pushPaymentReceived,
      pushComplaint: pushComplaint ?? this.pushComplaint,
      pushMaintenance: pushMaintenance ?? this.pushMaintenance,
      pushGuestActivity: pushGuestActivity ?? this.pushGuestActivity,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      emailDailySummary: emailDailySummary ?? this.emailDailySummary,
      emailWeeklyReport: emailWeeklyReport ?? this.emailWeeklyReport,
      emailPaymentReminders: emailPaymentReminders ?? this.emailPaymentReminders,
      emailMaintenanceAlerts: emailMaintenanceAlerts ?? this.emailMaintenanceAlerts,
      smsEnabled: smsEnabled ?? this.smsEnabled,
      smsUrgentOnly: smsUrgentOnly ?? this.smsUrgentOnly,
      smsPaymentConfirmation: smsPaymentConfirmation ?? this.smsPaymentConfirmation,
      quietHoursEnabled: quietHoursEnabled ?? this.quietHoursEnabled,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Getters
  bool get hasAnyPushEnabled =>
      pushEnabled &&
      (pushNewBooking ||
          pushPaymentReceived ||
          pushComplaint ||
          pushMaintenance ||
          pushGuestActivity);

  bool get hasAnyEmailEnabled =>
      emailEnabled &&
      (emailDailySummary ||
          emailWeeklyReport ||
          emailPaymentReminders ||
          emailMaintenanceAlerts);

  String get quietHoursDisplay =>
      '$quietHoursStart:00 - $quietHoursEnd:00';
}

