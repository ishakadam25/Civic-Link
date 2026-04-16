/// Application-wide constants
class AppConstants {
  // API Configuration
  static const String openWeatherMapApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  static const String googlePlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY';

  // Emergency service configurations
  static const double defaultSearchRadius = 5000; // meters
  static const int defaultTimeoutSeconds = 30;

  // Location settings
  static const int distanceFilterMeters = 10;

  // API Endpoints
  static const String weatherApiBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  static const String googlePlacesApiUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  // Emergency numbers (Mumbai specific)
  static const String policeEmergency = '100';
  static const String ambulanceEmergency = '102';
  static const String fireEmergency = '101';
  static const String womenHelpline = '1091';
  static const String childHelpline = '1098';
  static const String antiHarassment = '112';
  static const String disasterManagement = '1077';
}

/// Screen route names for navigation
class ScreenRoutes {
  static const String govServices = '/gov-services';
  static const String weather = '/gov-services/weather';
  static const String emergency = '/gov-services/emergency';
}

/// Error messages
class ErrorMessages {
  static const String locationPermissionDenied =
      'Location permission is required to use this feature';
  static const String locationServiceDisabled =
      'Location services are disabled';
  static const String weatherFetchFailed =
      'Failed to fetch weather data. Please try again.';
  static const String emergencyServicesFetchFailed =
      'Failed to fetch emergency services. Please try again.';
  static const String networkError = 'Network error. Please check your connection.';
  static const String unknownError = 'An unknown error occurred.';
}

/// Success messages
class SuccessMessages {
  static const String locationEnabled = 'Location enabled successfully';
  static const String weatherRefreshed = 'Weather data refreshed';
  static const String servicesRefreshed = 'Emergency services refreshed';
}
