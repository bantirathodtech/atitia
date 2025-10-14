// lib/core/models/review_model.dart

/// ⭐ **REVIEW MODEL - PRODUCTION READY**
///
/// **Represents a PG review and rating by a guest**
///
/// **Fields:**
/// - Review details (rating, comment, photos)
/// - Guest and PG information
/// - Review metadata (helpful votes, responses)
/// - Timestamps
class ReviewModel {
  final String reviewId;
  final String guestId;
  final String guestName;
  final String? guestPhotoUrl;
  final String pgId;
  final String pgName;
  final String ownerId;
  
  final double rating; // 1.0 to 5.0
  final String comment;
  final List<String> photos;
  
  // Review aspects
  final double cleanlinessRating;
  final double amenitiesRating;
  final double locationRating;
  final double foodRating;
  final double staffRating;
  
  final int helpfulVotes;
  final int totalVotes;
  final bool isVerified; // Verified guest
  final bool isOwnerResponse; // Is this an owner response
  
  final DateTime reviewDate;
  final DateTime? lastUpdated;
  final String status; // pending, approved, rejected, hidden
  
  // Owner response
  final String? ownerResponse;
  final DateTime? ownerResponseDate;

  ReviewModel({
    required this.reviewId,
    required this.guestId,
    required this.guestName,
    this.guestPhotoUrl,
    required this.pgId,
    required this.pgName,
    required this.ownerId,
    required this.rating,
    required this.comment,
    this.photos = const [],
    required this.cleanlinessRating,
    required this.amenitiesRating,
    required this.locationRating,
    required this.foodRating,
    required this.staffRating,
    this.helpfulVotes = 0,
    this.totalVotes = 0,
    this.isVerified = false,
    this.isOwnerResponse = false,
    required this.reviewDate,
    this.lastUpdated,
    this.status = 'pending',
    this.ownerResponse,
    this.ownerResponseDate,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      reviewId: map['reviewId'] ?? '',
      guestId: map['guestId'] ?? '',
      guestName: map['guestName'] ?? '',
      guestPhotoUrl: map['guestPhotoUrl'],
      pgId: map['pgId'] ?? '',
      pgName: map['pgName'] ?? '',
      ownerId: map['ownerId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      photos: List<String>.from(map['photos'] ?? []),
      cleanlinessRating: (map['cleanlinessRating'] ?? 0.0).toDouble(),
      amenitiesRating: (map['amenitiesRating'] ?? 0.0).toDouble(),
      locationRating: (map['locationRating'] ?? 0.0).toDouble(),
      foodRating: (map['foodRating'] ?? 0.0).toDouble(),
      staffRating: (map['staffRating'] ?? 0.0).toDouble(),
      helpfulVotes: map['helpfulVotes'] ?? 0,
      totalVotes: map['totalVotes'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      isOwnerResponse: map['isOwnerResponse'] ?? false,
      reviewDate: DateTime.parse(map['reviewDate']),
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : null,
      status: map['status'] ?? 'pending',
      ownerResponse: map['ownerResponse'],
      ownerResponseDate: map['ownerResponseDate'] != null 
          ? DateTime.parse(map['ownerResponseDate']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reviewId': reviewId,
      'guestId': guestId,
      'guestName': guestName,
      'guestPhotoUrl': guestPhotoUrl,
      'pgId': pgId,
      'pgName': pgName,
      'ownerId': ownerId,
      'rating': rating,
      'comment': comment,
      'photos': photos,
      'cleanlinessRating': cleanlinessRating,
      'amenitiesRating': amenitiesRating,
      'locationRating': locationRating,
      'foodRating': foodRating,
      'staffRating': staffRating,
      'helpfulVotes': helpfulVotes,
      'totalVotes': totalVotes,
      'isVerified': isVerified,
      'isOwnerResponse': isOwnerResponse,
      'reviewDate': reviewDate.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'status': status,
      'ownerResponse': ownerResponse,
      'ownerResponseDate': ownerResponseDate?.toIso8601String(),
    };
  }

  ReviewModel copyWith({
    String? reviewId,
    String? guestId,
    String? guestName,
    String? guestPhotoUrl,
    String? pgId,
    String? pgName,
    String? ownerId,
    double? rating,
    String? comment,
    List<String>? photos,
    double? cleanlinessRating,
    double? amenitiesRating,
    double? locationRating,
    double? foodRating,
    double? staffRating,
    int? helpfulVotes,
    int? totalVotes,
    bool? isVerified,
    bool? isOwnerResponse,
    DateTime? reviewDate,
    DateTime? lastUpdated,
    String? status,
    String? ownerResponse,
    DateTime? ownerResponseDate,
  }) {
    return ReviewModel(
      reviewId: reviewId ?? this.reviewId,
      guestId: guestId ?? this.guestId,
      guestName: guestName ?? this.guestName,
      guestPhotoUrl: guestPhotoUrl ?? this.guestPhotoUrl,
      pgId: pgId ?? this.pgId,
      pgName: pgName ?? this.pgName,
      ownerId: ownerId ?? this.ownerId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      cleanlinessRating: cleanlinessRating ?? this.cleanlinessRating,
      amenitiesRating: amenitiesRating ?? this.amenitiesRating,
      locationRating: locationRating ?? this.locationRating,
      foodRating: foodRating ?? this.foodRating,
      staffRating: staffRating ?? this.staffRating,
      helpfulVotes: helpfulVotes ?? this.helpfulVotes,
      totalVotes: totalVotes ?? this.totalVotes,
      isVerified: isVerified ?? this.isVerified,
      isOwnerResponse: isOwnerResponse ?? this.isOwnerResponse,
      reviewDate: reviewDate ?? this.reviewDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      ownerResponse: ownerResponse ?? this.ownerResponse,
      ownerResponseDate: ownerResponseDate ?? this.ownerResponseDate,
    );
  }
}
