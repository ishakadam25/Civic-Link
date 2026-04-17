import 'package:flutter/material.dart';
import '../models/emergency_model.dart';
import '../services/emergency_service.dart';

/// Provider for managing emergency services state
class EmergencyProvider extends ChangeNotifier {
  final EmergencyServiceAPI _emergencyService;

  List<EmergencyService> _policeStations = [];
  List<EmergencyService> _hospitals = [];
  List<EmergencyService> _ambulances = [];
  List<EmergencyService> _fireStations = [];
  List<EmergencyService> _allServices = [];

  bool _isLoading = false;
  String? _error;

  EmergencyProvider(this._emergencyService);

  // Getters
  List<EmergencyService> get policeStations => _policeStations;
  List<EmergencyService> get hospitals => _hospitals;
  List<EmergencyService> get ambulances => _ambulances;
  List<EmergencyService> get fireStations => _fireStations;
  List<EmergencyService> get allServices => _allServices;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch nearby emergency services based on location
  Future<void> fetchNearbyServices(
    double latitude,
    double longitude, {
    double radiusInMeters = 5000,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Fetch different types of services
      final police = await _emergencyService.findNearbyServices(
        latitude,
        longitude,
        EmergencyServiceType.police,
        radiusInMeters,
      );
      _policeStations = police;

      final hospitals = await _emergencyService.findNearbyServices(
        latitude,
        longitude,
        EmergencyServiceType.hospital,
        radiusInMeters,
      );
      _hospitals = hospitals;

      final ambulances = await _emergencyService.findNearbyServices(
        latitude,
        longitude,
        EmergencyServiceType.ambulance,
        radiusInMeters,
      );
      _ambulances = ambulances;

      final fires = await _emergencyService.findNearbyServices(
        latitude,
        longitude,
        EmergencyServiceType.fireStation,
        radiusInMeters,
      );
      _fireStations = fires;

      // Combine all services
      _allServices = [
        ..._policeStations,
        ..._hospitals,
        ..._ambulances,
        ..._fireStations,
      ];

      _error = null;
    } catch (e) {
      _error = 'Failed to fetch services: ${e.toString()}';
      _policeStations = [];
      _hospitals = [];
      _ambulances = [];
      _fireStations = [];
      _allServices = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get services of a specific type
  List<EmergencyService> getServicesByType(EmergencyServiceType type) {
    switch (type) {
      case EmergencyServiceType.police:
        return _policeStations;
      case EmergencyServiceType.hospital:
        return _hospitals;
      case EmergencyServiceType.ambulance:
        return _ambulances;
      case EmergencyServiceType.fireStation:
        return _fireStations;
      default:
        return _allServices;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh emergency services data
  Future<void> refreshServices(double latitude, double longitude) async {
    await fetchNearbyServices(latitude, longitude);
  }
}
