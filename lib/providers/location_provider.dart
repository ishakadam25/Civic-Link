import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

/// Provider for managing user location state
class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationData? _currentLocation;
  bool _isLoading = false;
  String? _error;
  bool _locationPermissionGranted = false;

  LocationProvider(this._locationService);

  // Getters
  LocationData? get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get locationPermissionGranted => _locationPermissionGranted;

  /// Request location permission and get current location
  Future<bool> requestLocationPermission() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final hasPermission = await _locationService.requestLocationPermission();
      _locationPermissionGranted = hasPermission;

      if (hasPermission) {
        await getCurrentLocation();
      }

      return hasPermission;
    } catch (e) {
      _error = 'Permission request failed: ${e.toString()}';
      _locationPermissionGranted = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get current user location
  Future<void> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final location = await _locationService.getCurrentLocation();
      _currentLocation = location;
      _error = null;
    } catch (e) {
      _error = 'Failed to get location: ${e.toString()}';
      _currentLocation = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Watch location changes (returns a stream)
  Stream<LocationData> watchLocation() {
    return _locationService.watchLocation();
  }

  /// Clear current location
  void clearLocation() {
    _currentLocation = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
