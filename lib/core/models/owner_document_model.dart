// lib/core/models/owner_document_model.dart

import 'package:flutter/material.dart';
import '../../common/utils/date/converter/date_service_converter.dart';

import '../../common/styles/colors.dart';

/// Model for owner documents (licenses, certificates, agreements, etc.)
/// Supports multiple document types with categorization
class OwnerDocumentModel {
  final String documentId;
  final String ownerId;
  final String
      documentType; // 'license', 'certificate', 'agreement', 'tax', 'insurance', 'other'
  final String title;
  final String? description;
  final String documentUrl;
  final String? thumbnailUrl;
  final String fileType; // 'pdf', 'image', 'doc'
  final int fileSize; // in bytes
  final DateTime expiryDate;
  final DateTime uploadedAt;
  final String? notes;
  final bool isVerified;
  final DateTime? verifiedAt;
  final String? verifiedBy;

  OwnerDocumentModel({
    required this.documentId,
    required this.ownerId,
    required this.documentType,
    required this.title,
    this.description,
    required this.documentUrl,
    this.thumbnailUrl,
    required this.fileType,
    required this.fileSize,
    required this.expiryDate,
    DateTime? uploadedAt,
    this.notes,
    this.isVerified = false,
    this.verifiedAt,
    this.verifiedBy,
  }) : uploadedAt = uploadedAt ?? DateTime.now();

  factory OwnerDocumentModel.fromMap(Map<String, dynamic> map) {
    return OwnerDocumentModel(
      documentId: map['documentId'] as String,
      ownerId: map['ownerId'] as String,
      documentType: map['documentType'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      documentUrl: map['documentUrl'] as String,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      fileType: map['fileType'] as String,
      fileSize: map['fileSize'] as int,
      expiryDate: DateServiceConverter.fromService(map['expiryDate'] as String),
      uploadedAt: DateServiceConverter.fromService(map['uploadedAt'] as String),
      notes: map['notes'] as String?,
      isVerified: map['isVerified'] as bool? ?? false,
      verifiedAt: map['verifiedAt'] != null
          ? DateServiceConverter.fromService(map['verifiedAt'] as String)
          : null,
      verifiedBy: map['verifiedBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'documentId': documentId,
      'ownerId': ownerId,
      'documentType': documentType,
      'title': title,
      'description': description,
      'documentUrl': documentUrl,
      'thumbnailUrl': thumbnailUrl,
      'fileType': fileType,
      'fileSize': fileSize,
      'expiryDate': DateServiceConverter.toService(expiryDate),
      'uploadedAt': DateServiceConverter.toService(uploadedAt),
      'notes': notes,
      'isVerified': isVerified,
      'verifiedAt': verifiedAt != null
          ? DateServiceConverter.toService(verifiedAt!)
          : null,
      'verifiedBy': verifiedBy,
    };
  }

  OwnerDocumentModel copyWith({
    String? documentId,
    String? ownerId,
    String? documentType,
    String? title,
    String? description,
    String? documentUrl,
    String? thumbnailUrl,
    String? fileType,
    int? fileSize,
    DateTime? expiryDate,
    DateTime? uploadedAt,
    String? notes,
    bool? isVerified,
    DateTime? verifiedAt,
    String? verifiedBy,
  }) {
    return OwnerDocumentModel(
      documentId: documentId ?? this.documentId,
      ownerId: ownerId ?? this.ownerId,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      description: description ?? this.description,
      documentUrl: documentUrl ?? this.documentUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      expiryDate: expiryDate ?? this.expiryDate,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      notes: notes ?? this.notes,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      verifiedBy: verifiedBy ?? this.verifiedBy,
    );
  }

  // Getters
  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 30;
  }

  String get documentTypeDisplay {
    switch (documentType) {
      case 'license':
        return 'Business License';
      case 'certificate':
        return 'Certificate';
      case 'agreement':
        return 'Agreement';
      case 'tax':
        return 'Tax Document';
      case 'insurance':
        return 'Insurance';
      default:
        return 'Document';
    }
  }

  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get formattedExpiryDate =>
      '${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
  String get formattedUploadedDate =>
      '${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}';

  IconData get documentIcon {
    switch (fileType) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'image':
        return Icons.image;
      case 'doc':
        return Icons.description;
      default:
        return Icons.file_present;
    }
  }

  Color get statusColor {
    if (isExpired) return AppColors.error;
    if (isExpiringSoon) return AppColors.warning;
    if (isVerified) return AppColors.success;
    return AppColors.info;
  }

  String get statusText {
    if (isExpired) return 'Expired';
    if (isExpiringSoon) return 'Expiring Soon';
    if (isVerified) return 'Verified';
    return 'Active';
  }
}
