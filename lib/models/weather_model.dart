/// Weather data model for current weather conditions
class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String description;
  final String main;
  final double cloudiness;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;
  final double latitude;
  final double longitude;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.main,
    required this.cloudiness,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.latitude,
    required this.longitude,
  });

  /// Create WeatherData from JSON response from OpenWeatherMap API
  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? 'Unknown',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      pressure: json['main']?['pressure'] ?? 0,
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      description: json['weather']?[0]?['description'] ?? 'Unknown',
      main: json['weather']?[0]?['main'] ?? 'Clear',
      cloudiness: (json['clouds']?['all'] ?? 0).toDouble(),
      visibility: json['visibility'] ?? 0,
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']?['sunrise'] ?? 0) * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(
        (json['sys']?['sunset'] ?? 0) * 1000,
      ),
      latitude: (json['coord']?['lat'] ?? 0).toDouble(),
      longitude: (json['coord']?['lon'] ?? 0).toDouble(),
    );
  }

  /// Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'temperature': temperature,
      'feelsLike': feelsLike,
      'humidity': humidity,
      'pressure': pressure,
      'windSpeed': windSpeed,
      'description': description,
      'main': main,
      'cloudiness': cloudiness,
      'visibility': visibility,
      'sunrise': sunrise.toIso8601String(),
      'sunset': sunset.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

/// Weather forecast model for multi-day forecasts
class WeatherForecast {
  final DateTime dateTime;
  final double temperature;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final String description;
  final String main;
  final double windSpeed;
  final double rainProbability;

  WeatherForecast({
    required this.dateTime,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.description,
    required this.main,
    required this.windSpeed,
    required this.rainProbability,
  });

  /// Create WeatherForecast from JSON response from OpenWeatherMap Forecast API
  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      dateTime: DateTime.parse(json['dt_txt'] ?? DateTime.now().toString()),
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      tempMin: (json['main']?['temp_min'] ?? 0).toDouble(),
      tempMax: (json['main']?['temp_max'] ?? 0).toDouble(),
      humidity: json['main']?['humidity'] ?? 0,
      description: json['weather']?[0]?['description'] ?? 'Unknown',
      main: json['weather']?[0]?['main'] ?? 'Clear',
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      rainProbability: (json['pop'] ?? 0).toDouble(),
    );
  }
}
