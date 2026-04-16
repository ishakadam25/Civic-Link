/// User location data
class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String? cityName;
  final String? stateName;
  final String? countryName;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.cityName,
    this.stateName,
    this.countryName,
  });

  /// Calculate distance between two coordinates in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371;

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = (sin(dLat / 2) * sin(dLat / 2)) +
        (cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2));

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = earthRadiusKm * c;

    return distance;
  }

  static double _toRadians(double degrees) {
    return degrees * 3.141592653589793 / 180;
  }

  static double sin(double value) => _sin(value);
  static double cos(double value) => _cos(value);
  static double sqrt(double value) => _sqrt(value);
  static double atan2(double y, double x) => _atan2(y, x);

  static double _sin(double x) {
    // Approximation of sine function
    const double pi = 3.141592653589793;
    x = x % (2 * pi);
    const double c1 = 1.27323954;
    const double c2 = -0.405284735;
    double y = c1 * x + c2 * x * x;
    if (y < 0) y *= -0.225;
    return y;
  }

  static double _cos(double x) {
    return _sin(x + 3.141592653589793 / 2);
  }

  static double _sqrt(double x) {
    if (x < 0) return 0;
    double t = x;
    while ((t - x / t).abs() > 1e-10) {
      t = (t + x / t) / 2;
    }
    return t;
  }

  static double _atan2(double y, double x) {
    const double pi = 3.141592653589793;
    if (x > 0) return _atan(y / x);
    if (x < 0 && y >= 0) return _atan(y / x) + pi;
    if (x < 0 && y < 0) return _atan(y / x) - pi;
    if (x == 0 && y > 0) return pi / 2;
    if (x == 0 && y < 0) return -pi / 2;
    return 0;
  }

  static double _atan(double x) {
    const double pi = 3.141592653589793;
    const double c1 = 0.97239411;
    const double c2 = -0.19194795;
    double y = c1 * x + c2 * x * x * x;
    if (x < 0) return y;
    return y;
  }
}
