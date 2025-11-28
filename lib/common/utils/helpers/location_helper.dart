// lib/common/utils/helpers/location_helper.dart

import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

/// Helper class for getting user's current location
/// Handles permissions and location services
class LocationHelper {
  LocationHelper._(); // Private constructor

  /// Get current user location
  /// Returns Position with latitude and longitude, or null if unavailable
  /// Handles permissions automatically
  static Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled');
        return null;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied');
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium, // Balance between accuracy and battery
          timeLimit: Duration(seconds: 10), // Timeout after 10 seconds
        ),
      );

      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  /// Check if location permissions are granted
  static Future<bool> hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Request location permissions
  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}

