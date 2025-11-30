// lib/features/owner_dashboard/myguest/data/repository/owner_booking_request_repository.dart

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../core/repositories/notification_repository.dart';
import '../../../../../core/services/firebase/database/firestore_transaction_service.dart';
import '../../../../../core/interfaces/transaction/transaction_service_interface.dart';
import '../../../../../core/services/booking/booking_lifecycle_service.dart';
import '../../../../../core/telemetry/cross_role_telemetry_service.dart';
import '../models/owner_booking_request_model.dart';

/// Repository for managing owner booking request operations
/// Handles loading, approving, and rejecting booking requests from guests
/// Uses interface-based services for dependency injection (swappable backends)
class OwnerBookingRequestRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;
  final NotificationRepository _notificationRepository;
  final ITransactionService _transactionService;
  final BookingLifecycleService _bookingLifecycleService;
  final _telemetry = CrossRoleTelemetryService();

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerBookingRequestRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
    NotificationRepository? notificationRepository,
    ITransactionService? transactionService,
    BookingLifecycleService? bookingLifecycleService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics,
        _notificationRepository =
            notificationRepository ?? NotificationRepository(),
        _transactionService =
            transactionService ?? FirestoreTransactionService(),
        _bookingLifecycleService =
            bookingLifecycleService ?? BookingLifecycleService();

  /// Streams all booking requests for a specific owner
  /// Filters by ownerId to show only requests for owner's PGs
  Stream<List<OwnerBookingRequestModel>> streamBookingRequests(String ownerId) {
    // COST OPTIMIZATION: Limit to 30 requests per stream
    return _databaseService
        .getCollectionStreamWithFilter(
            'owner_booking_requests', 'ownerId', ownerId,
            limit: 30)
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => OwnerBookingRequestModel.fromFirestore(doc))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_booking_requests_streamed',
        parameters: {
          'owner_id': ownerId,
          'requests_count': requests.length,
          'pending_count': requests.where((r) => r.isPending).length,
        },
      );

      return requests;
    });
  }

  /// Streams booking requests for a specific guest
  /// Filters by guestId to show all booking requests sent by the guest
  Stream<List<OwnerBookingRequestModel>> streamGuestBookingRequests(
      String guestId) {
    // COST OPTIMIZATION: Limit to 20 requests per stream
    return _databaseService
        .getCollectionStreamWithFilter(
            'owner_booking_requests', 'guestId', guestId,
            limit: 20)
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => OwnerBookingRequestModel.fromFirestore(doc))
          .toList();

      _analyticsService.logEvent(
        name: 'guest_booking_requests_streamed',
        parameters: {
          'guest_id': guestId,
          'requests_count': requests.length,
          'pending_count': requests.where((r) => r.isPending).length,
        },
      );

      return requests;
    });
  }

  /// Streams booking requests for specific PG IDs
  /// Useful when owner wants to see requests for specific properties
  Stream<List<OwnerBookingRequestModel>> streamBookingRequestsForPGs(
      List<String> pgIds) {
    if (pgIds.isEmpty) {
      return Stream.value([]);
    }

    // COST OPTIMIZATION: Limit to 50 requests per stream (prevents loading entire collection)
    return _databaseService
        .getCollectionStream('owner_booking_requests', limit: 50)
        .map((snapshot) {
      final requests = snapshot.docs
          .map((doc) => OwnerBookingRequestModel.fromFirestore(doc))
          .where((request) => pgIds.contains(request.pgId))
          .toList();

      _analyticsService.logEvent(
        name: 'owner_booking_requests_for_pgs_streamed',
        parameters: {
          'pg_ids': pgIds,
          'requests_count': requests.length,
          'pending_count': requests.where((r) => r.isPending).length,
        },
      );

      return requests;
    });
  }

  /// Gets a specific booking request by ID
  Future<OwnerBookingRequestModel?> getBookingRequestById(
      String requestId) async {
    try {
      final doc = await _databaseService.getDocument(
        'owner_booking_requests',
        requestId,
      );

      if (!doc.exists) return null;

      final request = OwnerBookingRequestModel.fromFirestore(doc);

      await _analyticsService.logEvent(
        name: 'owner_booking_request_viewed',
        parameters: {
          'request_id': requestId,
          'guest_name': request.guestName,
          'pg_name': request.pgName,
          'status': request.status,
        },
      );

      return request;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_fetch_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch booking request: $e');
    }
  }

  /// Approves a booking request
  /// Updates the request status and creates a corresponding booking
  /// Uses transaction to ensure atomic operation
  Future<void> approveBookingRequest(
    String requestId, {
    String? responseMessage,
    String? roomNumber,
    String? bedNumber,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Get the booking request first to extract guest and PG info
    final requestDoc = await _databaseService.getDocument(
      'owner_booking_requests',
      requestId,
    );

    if (!requestDoc.exists) {
      throw Exception('Booking request not found');
    }

    final requestData = requestDoc.data() as Map<String, dynamic>;
    final guestId = requestData['guestId'] as String?;
    final requestOwnerId = requestData['ownerId'] as String?;
    final currentStatus = requestData['status'] as String?;

    // Check if already processed (race condition prevention)
    if (currentStatus != 'pending' && currentStatus != null) {
      throw Exception(
          'Booking request already processed (status: $currentStatus)');
    }

    try {
      final now = DateTime.now();
      final updateData = {
        'status': 'approved',
        'respondedAt': now,
        'responseMessage': responseMessage,
        'roomNumber': roomNumber,
        'bedNumber': bedNumber,
        'startDate': startDate?.millisecondsSinceEpoch,
        'endDate': endDate?.millisecondsSinceEpoch,
        'updatedAt': now,
      };

      // Use transaction to update both collections atomically
      await _transactionService.runTransaction<void>((transaction) async {
        final firestore = _transactionService.firestore;
        final ownerRequestRef =
            firestore.collection('owner_booking_requests').doc(requestId);

        // Get and verify booking request status
        final ownerRequestSnapshot = await transaction.get(ownerRequestRef);

        if (!ownerRequestSnapshot.exists) {
          throw Exception('Booking request not found');
        }

        final requestSnapshotData = ownerRequestSnapshot.data();
        if (requestSnapshotData?['status'] != 'pending') {
          throw Exception('Booking request already processed');
        }

        // Update owner_booking_requests
        transaction.update(ownerRequestRef, updateData);

        // Update guest_booking_requests
        transaction.update(
          firestore.collection('guest_booking_requests').doc(requestId),
          updateData,
        );

        // Update guest's room/bed assignment if provided
        // Status will be 'payment_pending' until payment is received
        if (guestId != null && roomNumber != null && bedNumber != null) {
          transaction.update(
            firestore.collection('users').doc(guestId),
            {
              'roomNumber': roomNumber,
              'bedNumber': bedNumber,
              'pgId': requestData['pgId'],
              'status': 'payment_pending', // Payment pending until guest pays
              'updatedAt': now,
            },
          );
        }
      });

      // Create booking record after transaction succeeds
      final bookingOwnerId = requestOwnerId ?? '';
      if (guestId != null &&
          roomNumber != null &&
          bedNumber != null &&
          startDate != null &&
          bookingOwnerId.isNotEmpty) {
        try {
          final bookingId =
              await _bookingLifecycleService.createBookingFromRequest(
            requestId: requestId,
            guestId: guestId,
            ownerId: bookingOwnerId,
            pgId: requestData['pgId'] ?? '',
            pgName: requestData['pgName'] ?? '',
            roomNumber: roomNumber,
            bedNumber: bedNumber,
            startDate: startDate,
            endDate: endDate,
            rentAmount: null, // Will be fetched from PG config
            depositAmount: null, // Will be fetched from PG config
          );

          // Update bed assignment in PG floor structure
          await _bookingLifecycleService.updateBedAssignment(
            pgId: requestData['pgId'] ?? '',
            roomNumber: roomNumber,
            bedNumber: bedNumber,
            guestId: guestId,
            isOccupied: true,
          );

          await _analyticsService.logEvent(
            name: 'booking_created_during_approval',
            parameters: {
              'booking_id': bookingId,
              'request_id': requestId,
            },
          );
        } catch (e) {
          // Log error but don't fail approval - booking can be created manually
          await _analyticsService.logEvent(
            name: 'booking_creation_during_approval_failed',
            parameters: {
              'request_id': requestId,
              'error': e.toString(),
            },
          );
        }
      }

      // Notify guest about approval (after transaction succeeds)
      if (guestId != null) {
        try {
          await _notificationRepository.sendUserNotification(
            userId: guestId,
            type: 'booking_request_approved',
            title: 'Booking Approved',
            body:
                'Your booking request for ${requestData['pgName'] ?? 'PG'} has been approved.',
            data: {
              'requestId': requestId,
              'pgId': requestData['pgId'],
              'roomNumber': roomNumber,
              'bedNumber': bedNumber,
            },
          );
        } catch (e) {
          // Log but don't fail the approval if notification fails
          await _analyticsService.logEvent(
            name: 'booking_approval_notification_failed',
            parameters: {
              'request_id': requestId,
              'error': e.toString(),
            },
          );
        }
      }

      await _analyticsService.logEvent(
        name: 'owner_booking_request_approved',
        parameters: {
          'request_id': requestId,
          'response_message': responseMessage ?? 'none',
          'room_number': roomNumber ?? 'none',
        },
      );

      // Track cross-role telemetry
      final ownerId = requestData['ownerId'] as String?;
      if (ownerId != null && guestId != null) {
        await _telemetry.trackBookingRequestAction(
          action: 'approved',
          actorRole: 'owner',
          requestId: requestId,
          guestId: guestId,
          ownerId: ownerId,
          pgId: requestData['pgId'] as String?,
          metadata: {
            'room_number': roomNumber,
            'bed_number': bedNumber,
            'has_message': responseMessage != null,
          },
          success: true,
        );
      }
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_approve_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      // Track failed action
      try {
        if (requestOwnerId != null && guestId != null) {
          await _telemetry.trackBookingRequestAction(
            action: 'approved',
            actorRole: 'owner',
            requestId: requestId,
            guestId: guestId,
            ownerId: requestOwnerId,
            success: false,
            metadata: {'error': e.toString()},
          );
        }
      } catch (_) {}
      throw Exception('Failed to approve booking request: $e');
    }
  }

  /// Rejects a booking request
  /// Updates the request status with optional rejection reason
  Future<void> rejectBookingRequest(
    String requestId, {
    String? responseMessage,
  }) async {
    // Get the booking request first to extract guest and owner info
    final requestDoc = await _databaseService.getDocument(
      'owner_booking_requests',
      requestId,
    );
    final requestData = requestDoc.data() as Map<String, dynamic>;
    final guestId = requestData['guestId'] as String?;
    final ownerId = requestData['ownerId'] as String?;

    try {
      final now = DateTime.now();

      // Update the booking request status
      await _databaseService.updateDocument(
        'owner_booking_requests',
        requestId,
        {
          'status': 'rejected',
          'respondedAt': now,
          'responseMessage': responseMessage,
          'updatedAt': now,
        },
      );

      // Also update the guest_booking_requests collection
      await _databaseService.updateDocument(
        'guest_booking_requests',
        requestId,
        {
          'status': 'rejected',
          'respondedAt': now,
          'responseMessage': responseMessage,
          'updatedAt': now,
        },
      );

      // Notify guest about rejection
      if (guestId != null) {
        await _notificationRepository.sendUserNotification(
          userId: guestId,
          type: 'booking_request_rejected',
          title: 'Booking Rejected',
          body:
              'Your booking request for ${requestData['pgName'] ?? 'PG'} was rejected.',
          data: {
            'requestId': requestId,
            'pgId': requestData['pgId'],
          },
        );
      }

      await _analyticsService.logEvent(
        name: 'owner_booking_request_rejected',
        parameters: {
          'request_id': requestId,
          'response_message': responseMessage ?? 'none',
        },
      );

      // Track cross-role telemetry
      final ownerId = requestData['ownerId'] as String?;
      if (ownerId != null && guestId != null) {
        await _telemetry.trackBookingRequestAction(
          action: 'rejected',
          actorRole: 'owner',
          requestId: requestId,
          guestId: guestId,
          ownerId: ownerId,
          pgId: requestData['pgId'] as String?,
          metadata: {
            'has_message': responseMessage != null,
          },
          success: true,
        );
      }
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_reject_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      // Track failed action
      try {
        if (ownerId != null && guestId != null) {
          await _telemetry.trackBookingRequestAction(
            action: 'rejected',
            actorRole: 'owner',
            requestId: requestId,
            guestId: guestId,
            ownerId: ownerId,
            success: false,
            metadata: {'error': e.toString()},
          );
        }
      } catch (_) {}
      throw Exception('Failed to reject booking request: $e');
    }
  }

  /// Gets booking request statistics for owner dashboard
  Future<Map<String, dynamic>> getBookingRequestStats(String ownerId) async {
    try {
      final requestsSnapshot = await _databaseService
          .getCollectionStreamWithFilter(
              'owner_booking_requests', 'ownerId', ownerId)
          .first;

      final requests = requestsSnapshot.docs
          .map((doc) => OwnerBookingRequestModel.fromFirestore(doc))
          .toList();

      final pendingRequests = requests.where((r) => r.isPending).length;
      final approvedRequests = requests.where((r) => r.isApproved).length;
      final rejectedRequests = requests.where((r) => r.isRejected).length;

      final stats = {
        'totalRequests': requests.length,
        'pendingRequests': pendingRequests,
        'approvedRequests': approvedRequests,
        'rejectedRequests': rejectedRequests,
        'responseRate': requests.isNotEmpty
            ? ((approvedRequests + rejectedRequests) / requests.length * 100)
                .round()
            : 0,
      };

      await _analyticsService.logEvent(
        name: 'owner_booking_request_stats_generated',
        parameters: stats,
      );

      return stats;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_stats_error',
        parameters: {'error': e.toString()},
      );
      throw Exception('Failed to fetch booking request stats: $e');
    }
  }

  /// Deletes a booking request (for cleanup purposes)
  Future<void> deleteBookingRequest(String requestId) async {
    try {
      // Delete from both collections
      await _databaseService.deleteDocument(
          'owner_booking_requests', requestId);
      await _databaseService.deleteDocument(
          'guest_booking_requests', requestId);

      await _analyticsService.logEvent(
        name: 'owner_booking_request_deleted',
        parameters: {'request_id': requestId},
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_delete_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to delete booking request: $e');
    }
  }
}
