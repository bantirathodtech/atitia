// lib/core/models/kyc_verification_model.dart

import 'package:flutter/material.dart';

import '../../common/styles/colors.dart';
import '../../common/utils/date/converter/date_service_converter.dart';

/// Model for KYC (Know Your Customer) verification status
/// Tracks document verification progress for compliance
class KycVerificationModel {
  final String ownerId;
  final String
      verificationStatus; // 'not_started', 'pending', 'under_review', 'approved', 'rejected'

  // Document statuses
  final bool aadhaarVerified;
  final String? aadhaarUrl;
  final bool panVerified;
  final String? panUrl;
  final String? panNumber;
  final bool addressProofVerified;
  final String? addressProofUrl;
  final bool businessLicenseVerified;
  final String? businessLicenseUrl;

  // Verification details
  final DateTime? submittedAt;
  final DateTime? verifiedAt;
  final String? verifiedBy;
  final String? rejectionReason;
  final List<String>? missingDocuments;

  // Progress tracking
  final int documentsSubmitted;
  final int documentsVerified;
  final int totalDocumentsRequired;

  final DateTime lastUpdated;

  KycVerificationModel({
    required this.ownerId,
    this.verificationStatus = 'not_started',
    this.aadhaarVerified = false,
    this.aadhaarUrl,
    this.panVerified = false,
    this.panUrl,
    this.panNumber,
    this.addressProofVerified = false,
    this.addressProofUrl,
    this.businessLicenseVerified = false,
    this.businessLicenseUrl,
    this.submittedAt,
    this.verifiedAt,
    this.verifiedBy,
    this.rejectionReason,
    this.missingDocuments,
    this.documentsSubmitted = 0,
    this.documentsVerified = 0,
    this.totalDocumentsRequired = 4,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory KycVerificationModel.fromMap(Map<String, dynamic> map) {
    return KycVerificationModel(
      ownerId: map['ownerId'] as String,
      verificationStatus: map['verificationStatus'] as String? ?? 'not_started',
      aadhaarVerified: map['aadhaarVerified'] as bool? ?? false,
      aadhaarUrl: map['aadhaarUrl'] as String?,
      panVerified: map['panVerified'] as bool? ?? false,
      panUrl: map['panUrl'] as String?,
      panNumber: map['panNumber'] as String?,
      addressProofVerified: map['addressProofVerified'] as bool? ?? false,
      addressProofUrl: map['addressProofUrl'] as String?,
      businessLicenseVerified: map['businessLicenseVerified'] as bool? ?? false,
      businessLicenseUrl: map['businessLicenseUrl'] as String?,
      submittedAt: map['submittedAt'] != null
          ? DateServiceConverter.fromService(map['submittedAt'] as String)
          : null,
      verifiedAt: map['verifiedAt'] != null
          ? DateServiceConverter.fromService(map['verifiedAt'] as String)
          : null,
      verifiedBy: map['verifiedBy'] as String?,
      rejectionReason: map['rejectionReason'] as String?,
      missingDocuments:
          (map['missingDocuments'] as List<dynamic>?)?.cast<String>(),
      documentsSubmitted: map['documentsSubmitted'] as int? ?? 0,
      documentsVerified: map['documentsVerified'] as int? ?? 0,
      totalDocumentsRequired: map['totalDocumentsRequired'] as int? ?? 4,
      lastUpdated:
          DateServiceConverter.fromService(map['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'verificationStatus': verificationStatus,
      'aadhaarVerified': aadhaarVerified,
      'aadhaarUrl': aadhaarUrl,
      'panVerified': panVerified,
      'panUrl': panUrl,
      'panNumber': panNumber,
      'addressProofVerified': addressProofVerified,
      'addressProofUrl': addressProofUrl,
      'businessLicenseVerified': businessLicenseVerified,
      'businessLicenseUrl': businessLicenseUrl,
      'submittedAt': submittedAt != null
          ? DateServiceConverter.toService(submittedAt!)
          : null,
      'verifiedAt': verifiedAt != null
          ? DateServiceConverter.toService(verifiedAt!)
          : null,
      'verifiedBy': verifiedBy,
      'rejectionReason': rejectionReason,
      'missingDocuments': missingDocuments,
      'documentsSubmitted': documentsSubmitted,
      'documentsVerified': documentsVerified,
      'totalDocumentsRequired': totalDocumentsRequired,
      'lastUpdated': DateServiceConverter.toService(lastUpdated),
    };
  }

  KycVerificationModel copyWith({
    String? ownerId,
    String? verificationStatus,
    bool? aadhaarVerified,
    String? aadhaarUrl,
    bool? panVerified,
    String? panUrl,
    String? panNumber,
    bool? addressProofVerified,
    String? addressProofUrl,
    bool? businessLicenseVerified,
    String? businessLicenseUrl,
    DateTime? submittedAt,
    DateTime? verifiedAt,
    String? verifiedBy,
    String? rejectionReason,
    List<String>? missingDocuments,
    int? documentsSubmitted,
    int? documentsVerified,
    int? totalDocumentsRequired,
    DateTime? lastUpdated,
  }) {
    return KycVerificationModel(
      ownerId: ownerId ?? this.ownerId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      aadhaarVerified: aadhaarVerified ?? this.aadhaarVerified,
      aadhaarUrl: aadhaarUrl ?? this.aadhaarUrl,
      panVerified: panVerified ?? this.panVerified,
      panUrl: panUrl ?? this.panUrl,
      panNumber: panNumber ?? this.panNumber,
      addressProofVerified: addressProofVerified ?? this.addressProofVerified,
      addressProofUrl: addressProofUrl ?? this.addressProofUrl,
      businessLicenseVerified:
          businessLicenseVerified ?? this.businessLicenseVerified,
      businessLicenseUrl: businessLicenseUrl ?? this.businessLicenseUrl,
      submittedAt: submittedAt ?? this.submittedAt,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      missingDocuments: missingDocuments ?? this.missingDocuments,
      documentsSubmitted: documentsSubmitted ?? this.documentsSubmitted,
      documentsVerified: documentsVerified ?? this.documentsVerified,
      totalDocumentsRequired:
          totalDocumentsRequired ?? this.totalDocumentsRequired,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Getters
  bool get isNotStarted => verificationStatus == 'not_started';
  bool get isPending => verificationStatus == 'pending';
  bool get isUnderReview => verificationStatus == 'under_review';
  bool get isApproved => verificationStatus == 'approved';
  bool get isRejected => verificationStatus == 'rejected';

  double get completionPercentage => totalDocumentsRequired > 0
      ? (documentsVerified / totalDocumentsRequired) * 100
      : 0.0;

  bool get isFullyVerified =>
      aadhaarVerified &&
      panVerified &&
      addressProofVerified &&
      businessLicenseVerified;

  String get statusDisplay {
    switch (verificationStatus) {
      case 'not_started':
        return 'Not Started';
      case 'pending':
        return 'Pending Submission';
      case 'under_review':
        return 'Under Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return verificationStatus;
    }
  }

  Color get statusColor {
    switch (verificationStatus) {
      case 'not_started':
        return AppColors.textSecondary;
      case 'pending':
        return AppColors.warning;
      case 'under_review':
        return AppColors.info;
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get statusIcon {
    switch (verificationStatus) {
      case 'not_started':
        return Icons.hourglass_empty;
      case 'pending':
        return Icons.pending;
      case 'under_review':
        return Icons.search;
      case 'approved':
        return Icons.verified;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}
