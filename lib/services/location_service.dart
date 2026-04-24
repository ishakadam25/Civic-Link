import 'package:geolocator/geolocator.dart';
import '../models/location_model.dart';

/// Service for managing user location and permissions
class LocationService {
  /// Request location permission from the user
  Future<bool> requestLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final result = await Geolocator.requestPermission();
        return result == LocationPermission.whileInUse ||
            result == LocationPermission.always;
      } else if (permission == LocationPermission.deniedForever) {
        // Permission is denied forever, user must enable it manually
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      throw Exception('Failed to request location permission: $e');
    }
  }

  /// Check if location permission is granted
  Future<bool> hasLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      throw Exception('Failed to check location permission: $e');
    }
  }

  /// Get current location coordinates
  Future<LocationData> getCurrentLocation() async {
    try {
      final hasPermission = await hasLocationPermission();

      if (!hasPermission) {
        throw Exception('Location permission not granted');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print("LAT: ${position.latitude}");
      print("LON: ${position.longitude}");

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      throw Exception('Failed to get current location: $e');
    }
  }

  /// Watch location changes and return a stream
  /// Emits location updates whenever user moves
  Stream<LocationData> watchLocation({
    int distanceFilter =
        10, // Minimum distance change in meters to trigger update
  }) {
    final locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) {
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
        );
      },
    );
  }

  /// Calculate distance between two coordinates
  double calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng) /
        1000; // Convert meters to kilometers
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Get last known location
  Future<LocationData?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get last known location: $e');
    }
  }
}
