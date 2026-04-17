/// Emergency service types available
enum EmergencyServiceType {
  police,
  hospital,
  ambulance,
  fireStation,
  disasterManagement
}

/// Emergency service model for nearby services
class EmergencyService {
  final String id;
  final String name;
  final EmergencyServiceType type;
  final String address;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final double? rating;
  final String? website;
  final String? openingHours;
  final bool isOpen;
  final double distanceInKm;

  EmergencyService({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    this.rating,
    this.website,
    this.openingHours,
    required this.isOpen,
    required this.distanceInKm,
  });

  /// Create EmergencyService from JSON (from Google Places API)
  factory EmergencyService.fromJson(Map<String, dynamic> json, EmergencyServiceType type) {
    return EmergencyService(
      id: json['place_id'] ?? 'unknown',
      name: json['name'] ?? 'Unknown Service',
      type: type,
      address: json['vicinity'] ?? 'Address not available',
      latitude: json['geometry']?['location']?['lat'] ?? 0.0,
      longitude: json['geometry']?['location']?['lng'] ?? 0.0,
      phoneNumber: json['formatted_phone_number'] ?? 'Not available',
      rating: json['rating']?.toDouble(),
      website: json['website'],
      openingHours: json['opening_hours']?['weekday_text']?.join('\n'),
      isOpen: json['opening_hours']?['open_now'] ?? false,
      distanceInKm: 0.0, // Calculate distance using location service
    );
  }

  /// Get the icon based on service type
  String getIcon() {
    switch (type) {
      case EmergencyServiceType.police:
        return '🚓';
      case EmergencyServiceType.hospital:
        return '🏥';
      case EmergencyServiceType.ambulance:
        return '🚑';
      case EmergencyServiceType.fireStation:
        return '🚒';
      case EmergencyServiceType.disasterManagement:
        return '⚠️';
    }
  }

  /// Get display name for service type
  String getTypeName() {
    switch (type) {
      case EmergencyServiceType.police:
        return 'Police Station';
      case EmergencyServiceType.hospital:
        return 'Hospital';
      case EmergencyServiceType.ambulance:
        return 'Ambulance Service';
      case EmergencyServiceType.fireStation:
        return 'Fire Station';
      case EmergencyServiceType.disasterManagement:
        return 'Disaster Management';
    }
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'rating': rating,
      'website': website,
      'openingHours': openingHours,
      'isOpen': isOpen,
      'distanceInKm': distanceInKm,
    };
  }
}

/// Quick emergency contacts
class QuickContact {
  final String name;
  final String phoneNumber;
  final String category;

  const QuickContact({
    required this.name,
    required this.phoneNumber,
    required this.category,
  });
}

/// Default emergency numbers for Mumbai
class MumbaiEmergencyNumbers {
  static const List<QuickContact> contacts = [
    QuickContact(name: 'Police', phoneNumber: '100', category: 'Emergency'),
    QuickContact(name: 'Ambulance', phoneNumber: '102', category: 'Emergency'),
    QuickContact(name: 'Fire', phoneNumber: '101', category: 'Emergency'),
    QuickContact(name: 'Women Helpline', phoneNumber: '1091', category: 'Women Safety'),
    QuickContact(name: 'Child Helpline', phoneNumber: '1098', category: 'Child Safety'),
    QuickContact(name: 'Anti Harassment', phoneNumber: '112', category: 'Harassment'),
    QuickContact(name: 'Disaster Management', phoneNumber: '1077', category: 'Disaster'),
  ];
}
