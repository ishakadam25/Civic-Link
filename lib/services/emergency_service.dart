import '../models/emergency_model.dart';

/// Service for finding nearby emergency services using Google Places API
class EmergencyServiceAPI {
  // API Configuration - Replace with actual API key from environment
  final String googlePlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
  final String baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  /// Find nearby services of a specific type
  /// API Docs: https://developers.google.com/maps/documentation/places/web-service/nearby-search
  Future<List<EmergencyService>> findNearbyServices(
    double latitude,
    double longitude,
    EmergencyServiceType type,
    double radiusInMeters,
  ) async {
    try {
      final query = _getSearchQuery(type);
      
      // API endpoint (unused while using mock data; uncomment API call below for production)
      // ignore: unused_local_variable
      final url = Uri.parse(
        '$baseUrl?location=$latitude,$longitude&radius=${radiusInMeters.toInt()}&keyword=$query&key=$googlePlacesApiKey',
      );

      // For demonstration, using mock data
      // In production, uncomment the actual API call below:
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   return (data['results'] as List)
      //       .map((item) => EmergencyService.fromJson(item, type))
      //       .toList();
      // }

      // Mock data for testing
      return _getMockServices(type);
    } catch (e) {
      throw Exception('Failed to find nearby services: $e');
    }
  }

  /// Get police stations nearby
  Future<List<EmergencyService>> getNearbyPoliceStations(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    return findNearbyServices(
      latitude,
      longitude,
      EmergencyServiceType.police,
      radiusInMeters,
    );
  }

  /// Get hospitals nearby
  Future<List<EmergencyService>> getNearbyHospitals(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    return findNearbyServices(
      latitude,
      longitude,
      EmergencyServiceType.hospital,
      radiusInMeters,
    );
  }

  /// Get ambulance services nearby
  Future<List<EmergencyService>> getNearbyAmbulances(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    return findNearbyServices(
      latitude,
      longitude,
      EmergencyServiceType.ambulance,
      radiusInMeters,
    );
  }

  /// Get fire stations nearby
  Future<List<EmergencyService>> getNearbyFireStations(
    double latitude,
    double longitude,
    double radiusInMeters,
  ) async {
    return findNearbyServices(
      latitude,
      longitude,
      EmergencyServiceType.fireStation,
      radiusInMeters,
    );
  }

  /// Get search query for each service type
  String _getSearchQuery(EmergencyServiceType type) {
    switch (type) {
      case EmergencyServiceType.police:
        return 'police station';
      case EmergencyServiceType.hospital:
        return 'hospital';
      case EmergencyServiceType.ambulance:
        return 'ambulance';
      case EmergencyServiceType.fireStation:
        return 'fire station';
      case EmergencyServiceType.disasterManagement:
        return 'disaster management';
    }
  }

  /// Mock emergency services for testing
  List<EmergencyService> _getMockServices(EmergencyServiceType type) {
    switch (type) {
      case EmergencyServiceType.police:
        return _getMockPoliceStations();
      case EmergencyServiceType.hospital:
        return _getMockHospitals();
      case EmergencyServiceType.ambulance:
        return _getMockAmbulances();
      case EmergencyServiceType.fireStation:
        return _getMockFireStations();
      default:
        return [];
    }
  }

  List<EmergencyService> _getMockPoliceStations() {
    return [
      EmergencyService(
        id: 'police_001',
        name: 'Mumbai Central Police Station',
        type: EmergencyServiceType.police,
        address: 'Fort, Mumbai',
        latitude: 18.9520,
        longitude: 72.8347,
        phoneNumber: '100',
        rating: 4.5,
        isOpen: true,
        distanceInKm: 1.2,
      ),
      EmergencyService(
        id: 'police_002',
        name: 'Bandra Police Station',
        type: EmergencyServiceType.police,
        address: 'Bandra, Mumbai',
        latitude: 19.0596,
        longitude: 72.8295,
        phoneNumber: '100',
        rating: 4.2,
        isOpen: true,
        distanceInKm: 2.5,
      ),
      EmergencyService(
        id: 'police_003',
        name: 'Andheri Police Station',
        type: EmergencyServiceType.police,
        address: 'Andheri, Mumbai',
        latitude: 19.1136,
        longitude: 72.8697,
        phoneNumber: '100',
        rating: 4.0,
        isOpen: true,
        distanceInKm: 3.8,
      ),
    ];
  }

  List<EmergencyService> _getMockHospitals() {
    return [
      EmergencyService(
        id: 'hospital_001',
        name: 'Fortis Hospital',
        type: EmergencyServiceType.hospital,
        address: 'Mulund, Mumbai',
        latitude: 19.1724,
        longitude: 72.9424,
        phoneNumber: '022-1234-5678',
        rating: 4.7,
        website: 'https://www.fortishealthcare.com',
        isOpen: true,
        distanceInKm: 1.5,
      ),
      EmergencyService(
        id: 'hospital_002',
        name: 'Apollo Hospitals',
        type: EmergencyServiceType.hospital,
        address: 'Thane, Mumbai',
        latitude: 19.2183,
        longitude: 72.9781,
        phoneNumber: '022-2345-6789',
        rating: 4.6,
        website: 'https://www.apollohospitals.com',
        isOpen: true,
        distanceInKm: 4.2,
      ),
      EmergencyService(
        id: 'hospital_003',
        name: 'Kokilaben Hospital',
        type: EmergencyServiceType.hospital,
        address: 'Mahim, Mumbai',
        latitude: 19.0398,
        longitude: 72.8228,
        phoneNumber: '022-3456-7890',
        rating: 4.8,
        isOpen: true,
        distanceInKm: 2.0,
      ),
    ];
  }

  List<EmergencyService> _getMockAmbulances() {
    return [
      EmergencyService(
        id: 'ambulance_001',
        name: 'Emergency Ambulance Service',
        type: EmergencyServiceType.ambulance,
        address: 'Near CST, Mumbai',
        latitude: 18.9398,
        longitude: 72.8324,
        phoneNumber: '102',
        rating: 4.3,
        isOpen: true,
        distanceInKm: 0.8,
      ),
      EmergencyService(
        id: 'ambulance_002',
        name: 'Rapid Response Ambulance',
        type: EmergencyServiceType.ambulance,
        address: 'Worli, Mumbai',
        latitude: 19.0176,
        longitude: 72.8194,
        phoneNumber: '102',
        rating: 4.4,
        isOpen: true,
        distanceInKm: 1.9,
      ),
    ];
  }

  List<EmergencyService> _getMockFireStations() {
    return [
      EmergencyService(
        id: 'fire_001',
        name: 'Mumbai Fire Brigade - Fort',
        type: EmergencyServiceType.fireStation,
        address: 'Fort, Mumbai',
        latitude: 18.9567,
        longitude: 72.8326,
        phoneNumber: '101',
        rating: 4.5,
        isOpen: true,
        distanceInKm: 1.1,
      ),
      EmergencyService(
        id: 'fire_002',
        name: 'Mumbai Fire Brigade - Bandra',
        type: EmergencyServiceType.fireStation,
        address: 'Bandra, Mumbai',
        latitude: 19.0620,
        longitude: 72.8296,
        phoneNumber: '101',
        rating: 4.4,
        isOpen: true,
        distanceInKm: 2.3,
      ),
    ];
  }
}
