// lib/feature/owner_dashboard/guests/data/repository/owner_guest_repository.dart

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../models/owner_guest_model.dart';
import '../models/owner_complaint_model.dart';
import '../models/owner_bike_model.dart';
import '../models/owner_service_model.dart';

/// Repository for managing owner's guest-related data using interface-based services.
/// Handles guests, complaints, bikes, and services with multi-PG support.
/// Uses interface-based services for dependency injection (swappable backends)
class OwnerGuestRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerGuestRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  // Collection names for Firestore
  static const String guestsCollection = 'owner_guests';
  static const String complaintsCollection = 'owner_complaints';
  static const String bikesCollection = 'owner_bikes';
  static const String servicesCollection = 'owner_services';
  static const String bookingRequestsCollection = 'owner_booking_requests';

  // ==========================================================================
  // GUEST MANAGEMENT
  // ==========================================================================

  /// Fetches all guests for a specific owner and PG
  Future<List<OwnerGuestModel>> fetchGuests(String ownerId,
      {String? pgId}) async {
    try {
      // COST OPTIMIZATION: Limit to 100 guests for owner
      final snapshot = await _databaseService
          .getCollectionStream(guestsCollection, limit: 100)
          .first;

      final guests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerGuestModel.fromMap(data);
      }).where((guest) {
        // Filter by owner
        if (guest.ownerId != ownerId || !guest.isActive) return false;

        // Multi-PG filtering
        if (pgId != null) {
          return guest.pgId == pgId;
        }

        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: 'owner_guests_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'guests_count': guests.length,
        },
      );

      return guests;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guests_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch guests: $e');
    }
  }

  /// Streams guests for real-time updates
  Stream<List<OwnerGuestModel>> getGuestsStream(String ownerId,
      {String? pgId}) {
    // COST OPTIMIZATION: Limit to 100 guests per stream
    return _databaseService
        .getCollectionStream(guestsCollection, limit: 100)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerGuestModel.fromMap(data);
      }).where((guest) {
        if (guest.ownerId != ownerId || !guest.isActive) return false;
        if (pgId != null) {
          return guest.pgId == pgId;
        }
        return true;
      }).toList();
    });
  }

  /// Updates guest information
  Future<void> updateGuest(OwnerGuestModel guest) async {
    try {
      final updatedGuest = guest.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        guestsCollection,
        guest.guestId,
        updatedGuest.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_guest_updated',
        parameters: {
          'guest_id': guest.guestId,
          'owner_id': guest.ownerId,
          'pg_id': guest.pgId,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_update_error',
        parameters: {
          'guest_id': guest.guestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update guest: $e');
    }
  }

  // ==========================================================================
  // COMPLAINT MANAGEMENT
  // ==========================================================================

  /// Fetches all complaints for a specific owner and PG
  Future<List<OwnerComplaintModel>> fetchComplaints(String ownerId,
      {String? pgId}) async {
    try {
      // COST OPTIMIZATION: Limit to 50 complaints per owner
      final snapshot = await _databaseService
          .getCollectionStream(complaintsCollection, limit: 50)
          .first;

      final complaints = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerComplaintModel.fromMap(data);
      }).where((complaint) {
        if (complaint.ownerId != ownerId || !complaint.isActive) return false;
        if (pgId != null) {
          return complaint.pgId == pgId;
        }
        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: 'owner_complaints_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'complaints_count': complaints.length,
        },
      );

      return complaints;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_complaints_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch complaints: $e');
    }
  }

  /// Streams complaints for real-time updates
  Stream<List<OwnerComplaintModel>> getComplaintsStream(String ownerId,
      {String? pgId}) {
    // COST OPTIMIZATION: Limit to 50 complaints per stream
    return _databaseService
        .getCollectionStream(complaintsCollection, limit: 50)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerComplaintModel.fromMap(data);
      }).where((complaint) {
        if (complaint.ownerId != ownerId || !complaint.isActive) return false;
        if (pgId != null) {
          return complaint.pgId == pgId;
        }
        return true;
      }).toList();
    });
  }

  /// Adds a reply to a complaint
  Future<void> addComplaintReply(
      String complaintId, ComplaintMessage message) async {
    try {
      // Get current complaint
      final complaintDoc = await _databaseService.getDocument(
        complaintsCollection,
        complaintId,
      );

      if (!complaintDoc.exists) {
        throw Exception('Complaint not found');
      }

      final complaint = OwnerComplaintModel.fromMap(
        complaintDoc.data() as Map<String, dynamic>,
      );

      // Add message to complaint
      final updatedMessages = List<ComplaintMessage>.from(complaint.messages)
        ..add(message);

      final updatedComplaint = complaint.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      await _databaseService.setDocument(
        complaintsCollection,
        complaintId,
        updatedComplaint.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_complaint_reply_added',
        parameters: {
          'complaint_id': complaintId,
          'sender_type': message.senderType,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_complaint_reply_error',
        parameters: {
          'complaint_id': complaintId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to add complaint reply: $e');
    }
  }

  /// Updates complaint status
  Future<void> updateComplaintStatus(String complaintId, String status,
      {String? resolutionNotes}) async {
    try {
      final complaintDoc = await _databaseService.getDocument(
        complaintsCollection,
        complaintId,
      );

      if (!complaintDoc.exists) {
        throw Exception('Complaint not found');
      }

      final complaint = OwnerComplaintModel.fromMap(
        complaintDoc.data() as Map<String, dynamic>,
      );

      final updatedComplaint = complaint.copyWith(
        status: status,
        resolutionNotes: resolutionNotes,
        resolvedAt: status.toLowerCase() == 'resolved' ? DateTime.now() : null,
        updatedAt: DateTime.now(),
      );

      await _databaseService.setDocument(
        complaintsCollection,
        complaintId,
        updatedComplaint.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_complaint_status_updated',
        parameters: {
          'complaint_id': complaintId,
          'status': status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_complaint_status_update_error',
        parameters: {
          'complaint_id': complaintId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update complaint status: $e');
    }
  }

  // ==========================================================================
  // BIKE MANAGEMENT
  // ==========================================================================

  /// Fetches all bikes for a specific owner and PG
  Future<List<OwnerBikeModel>> fetchBikes(String ownerId,
      {String? pgId}) async {
    try {
      // COST OPTIMIZATION: Limit to 50 bikes per owner
      final snapshot = await _databaseService
          .getCollectionStream(bikesCollection, limit: 50)
          .first;

      final bikes = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerBikeModel.fromMap(data);
      }).where((bike) {
        if (bike.ownerId != ownerId || !bike.isActive) return false;
        if (pgId != null) {
          return bike.pgId == pgId;
        }
        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: 'owner_bikes_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'bikes_count': bikes.length,
        },
      );

      return bikes;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_bikes_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch bikes: $e');
    }
  }

  /// Streams bikes for real-time updates
  Stream<List<OwnerBikeModel>> getBikesStream(String ownerId, {String? pgId}) {
    // COST OPTIMIZATION: Limit to 50 bikes per stream
    return _databaseService
        .getCollectionStream(bikesCollection, limit: 50)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerBikeModel.fromMap(data);
      }).where((bike) {
        if (bike.ownerId != ownerId || !bike.isActive) return false;
        if (pgId != null) {
          return bike.pgId == pgId;
        }
        return true;
      }).toList();
    });
  }

  /// Updates bike information
  Future<void> updateBike(OwnerBikeModel bike) async {
    try {
      final updatedBike = bike.copyWith(updatedAt: DateTime.now());
      await _databaseService.setDocument(
        bikesCollection,
        bike.bikeId,
        updatedBike.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_bike_updated',
        parameters: {
          'bike_id': bike.bikeId,
          'owner_id': bike.ownerId,
          'pg_id': bike.pgId,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_bike_update_error',
        parameters: {
          'bike_id': bike.bikeId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update bike: $e');
    }
  }

  /// Creates a bike movement request
  Future<void> createBikeMovementRequest(BikeMovementRequest request) async {
    try {
      await _databaseService.setDocument(
        'bike_movement_requests',
        request.requestId,
        request.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_bike_movement_request_created',
        parameters: {
          'request_id': request.requestId,
          'bike_id': request.bikeId,
          'request_type': request.requestType,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_bike_movement_request_error',
        parameters: {
          'request_id': request.requestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to create bike movement request: $e');
    }
  }

  // ==========================================================================
  // SERVICE MANAGEMENT
  // ==========================================================================

  /// Fetches all service requests for a specific owner and PG
  Future<List<OwnerServiceModel>> fetchServices(String ownerId,
      {String? pgId}) async {
    try {
      // COST OPTIMIZATION: Limit to 50 service requests per owner
      final snapshot = await _databaseService
          .getCollectionStream(servicesCollection, limit: 50)
          .first;

      final services = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerServiceModel.fromMap(data);
      }).where((service) {
        if (service.ownerId != ownerId || !service.isActive) return false;
        if (pgId != null) {
          return service.pgId == pgId;
        }
        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: 'owner_services_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'services_count': services.length,
        },
      );

      return services;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_services_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch services: $e');
    }
  }

  /// Streams service requests for real-time updates
  Stream<List<OwnerServiceModel>> getServicesStream(String ownerId,
      {String? pgId}) {
    return _databaseService
        .getCollectionStream(servicesCollection, limit: 50)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OwnerServiceModel.fromMap(data);
      }).where((service) {
        if (service.ownerId != ownerId || !service.isActive) return false;
        if (pgId != null) {
          return service.pgId == pgId;
        }
        return true;
      }).toList();
    });
  }

  /// Creates a new service request
  Future<void> createServiceRequest(OwnerServiceModel service) async {
    try {
      await _databaseService.setDocument(
        servicesCollection,
        service.serviceId,
        service.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_service_request_created',
        parameters: {
          'service_id': service.serviceId,
          'service_type': service.serviceType,
          'owner_id': service.ownerId,
          'pg_id': service.pgId,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_service_request_create_error',
        parameters: {
          'service_id': service.serviceId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to create service request: $e');
    }
  }

  /// Adds a reply to a service request
  Future<void> addServiceReply(String serviceId, ServiceMessage message) async {
    try {
      final serviceDoc = await _databaseService.getDocument(
        servicesCollection,
        serviceId,
      );

      if (!serviceDoc.exists) {
        throw Exception('Service request not found');
      }

      final service = OwnerServiceModel.fromMap(
        serviceDoc.data() as Map<String, dynamic>,
      );

      final updatedMessages = List<ServiceMessage>.from(service.messages)
        ..add(message);

      final updatedService = service.copyWith(
        messages: updatedMessages,
        updatedAt: DateTime.now(),
      );

      await _databaseService.setDocument(
        servicesCollection,
        serviceId,
        updatedService.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_service_reply_added',
        parameters: {
          'service_id': serviceId,
          'sender_type': message.senderType,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_service_reply_error',
        parameters: {
          'service_id': serviceId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to add service reply: $e');
    }
  }

  /// Updates service request status
  Future<void> updateServiceStatus(String serviceId, String status,
      {String? assignedTo, String? completionNotes}) async {
    try {
      final serviceDoc = await _databaseService.getDocument(
        servicesCollection,
        serviceId,
      );

      if (!serviceDoc.exists) {
        throw Exception('Service request not found');
      }

      final service = OwnerServiceModel.fromMap(
        serviceDoc.data() as Map<String, dynamic>,
      );

      final updatedService = service.copyWith(
        status: status,
        assignedTo: assignedTo,
        completionNotes: completionNotes,
        assignedAt: status.toLowerCase() == 'in_progress' && assignedTo != null
            ? DateTime.now()
            : service.assignedAt,
        completedAt: status.toLowerCase() == 'completed'
            ? DateTime.now()
            : service.completedAt,
        updatedAt: DateTime.now(),
      );

      await _databaseService.setDocument(
        servicesCollection,
        serviceId,
        updatedService.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'owner_service_status_updated',
        parameters: {
          'service_id': serviceId,
          'status': status,
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_service_status_update_error',
        parameters: {
          'service_id': serviceId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update service status: $e');
    }
  }

  // ==========================================================================
  // BOOKING REQUESTS
  // ==========================================================================

  /// Fetches all booking requests for a specific owner and PG
  Future<List<Map<String, dynamic>>> fetchBookingRequests(String ownerId,
      {String? pgId}) async {
    try {
      final snapshot = await _databaseService
          .getCollectionStream(bookingRequestsCollection)
          .first;

      final requests = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      }).where((request) {
        // Filter by owner
        if (request['ownerId'] != ownerId) return false;

        // Multi-PG filtering
        if (pgId != null) {
          return request['pgId'] == pgId;
        }

        return true;
      }).toList();

      await _analyticsService.logEvent(
        name: 'owner_booking_requests_fetched',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'requests_count': requests.length,
        },
      );

      return requests;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_requests_fetch_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to fetch booking requests: $e');
    }
  }

  /// Streams booking requests for real-time updates
  Stream<List<Map<String, dynamic>>> getBookingRequestsStream(String ownerId,
      {String? pgId}) {
    // COST OPTIMIZATION: Limit to 50 booking requests per stream
    return _databaseService
        .getCollectionStream(bookingRequestsCollection, limit: 50)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return data;
      }).where((request) {
        if (request['ownerId'] != ownerId) return false;
        if (pgId != null) {
          return request['pgId'] == pgId;
        }
        return true;
      }).toList();
    });
  }

  /// Updates booking request status
  Future<void> updateBookingRequestStatus(
    String requestId,
    String status, {
    String? responseMessage,
  }) async {
    try {
      final updateData = {
        'status': status,
        'updatedAt': DateTime.now(),
        'respondedAt': DateTime.now(),
        'responseMessage': responseMessage,
      };

      await _databaseService.updateDocument(
        bookingRequestsCollection,
        requestId,
        updateData,
      );

      await _analyticsService.logEvent(
        name: 'owner_booking_request_updated',
        parameters: {
          'request_id': requestId,
          'status': status,
          'response_message': responseMessage ?? 'none',
        },
      );
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_booking_request_update_error',
        parameters: {
          'request_id': requestId,
          'error': e.toString(),
        },
      );
      throw Exception('Failed to update booking request: $e');
    }
  }

  // ==========================================================================
  // ANALYTICS & STATISTICS
  // ==========================================================================

  /// Gets guest statistics for owner dashboard
  Future<Map<String, dynamic>> getGuestStats(String ownerId,
      {String? pgId}) async {
    try {
      final guests = await fetchGuests(ownerId, pgId: pgId);
      final complaints = await fetchComplaints(ownerId, pgId: pgId);
      final bikes = await fetchBikes(ownerId, pgId: pgId);
      final services = await fetchServices(ownerId, pgId: pgId);

      final stats = {
        'totalGuests': guests.length,
        'activeGuests': guests.where((g) => g.isCurrentlyActive).length,
        'totalComplaints': complaints.length,
        'newComplaints': complaints.where((c) => c.isNew).length,
        'resolvedComplaints': complaints.where((c) => c.isResolved).length,
        'totalBikes': bikes.length,
        'activeBikes': bikes.where((b) => b.isCurrentlyActive).length,
        'bikeViolations': bikes.where((b) => b.hasViolation).length,
        'totalServices': services.length,
        'newServices': services.where((s) => s.isNew).length,
        'completedServices': services.where((s) => s.isCompleted).length,
        'pgId': pgId ?? 'all',
      };

      await _analyticsService.logEvent(
        name: 'owner_guest_stats_generated',
        parameters: stats,
      );

      return stats;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'owner_guest_stats_error',
        parameters: {
          'owner_id': ownerId,
          'pg_id': pgId ?? 'all',
          'error': e.toString(),
        },
      );
      throw Exception('Failed to get guest stats: $e');
    }
  }
}
