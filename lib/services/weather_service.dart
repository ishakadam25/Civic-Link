import '../models/weather_model.dart';

/// Service for fetching weather data from OpenWeatherMap API
class WeatherService {
  // API Configuration - Replace with actual API key from environment
  final String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetch current weather for given coordinates
  /// API Docs: https://openweathermap.org/current
  Future<WeatherData> getCurrentWeather(double latitude, double longitude) async {
    try {
      // API endpoint with mock data fallback
      final url = Uri.parse(
        '$baseUrl/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
      );

      // For demonstration, using mock data
      // In production, uncomment the actual API call below:
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   return WeatherData.fromJson(jsonDecode(response.body));
      // }

      // Mock data for testing
      return _getMockWeatherData(latitude, longitude);
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Fetch weather forecast for given coordinates (5-day forecast)
  /// API Docs: https://openweathermap.org/forecast5
  Future<List<WeatherForecast>> getWeatherForecast(
    double latitude,
    double longitude,
  ) async {
    try {
      // API endpoint
      final url = Uri.parse(
        '$baseUrl/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
      );

      // For demonstration, using mock data
      // In production, uncomment the actual API call below:
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final forecasts = (data['list'] as List)
      //       .map((item) => WeatherForecast.fromJson(item))
      //       .toList();
      //   return forecasts;
      // }

      // Mock data for testing
      return _getMockForecastData();
    } catch (e) {
      throw Exception('Failed to fetch forecast: $e');
    }
  }

  /// Get weather by city name
  /// API Docs: https://openweathermap.org/current
  Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      final url = Uri.parse(
        '$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric',
      );

      // For demonstration, using mock data
      // In production, uncomment the actual API call below:
      // final response = await http.get(url);
      // if (response.statusCode == 200) {
      //   return WeatherData.fromJson(jsonDecode(response.body));
      // }

      return _getMockWeatherDataByCity(cityName);
    } catch (e) {
      throw Exception('Failed to fetch weather for city: $e');
    }
  }

  /// Mock weather data for Mumbai
  WeatherData _getMockWeatherData(double latitude, double longitude) {
    final now = DateTime.now();
    return WeatherData(
      city: 'Mumbai',
      country: 'IN',
      temperature: 32.5,
      feelsLike: 35.2,
      humidity: 75,
      pressure: 1013,
      windSpeed: 12.5,
      description: 'Partly cloudy',
      main: 'Clouds',
      cloudiness: 45,
      visibility: 8000,
      sunrise: now.subtract(const Duration(hours: 6)),
      sunset: now.add(const Duration(hours: 6)),
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Mock forecast data
  List<WeatherForecast> _getMockForecastData() {
    final List<WeatherForecast> forecasts = [];
    for (int i = 0; i < 5; i++) {
      final date = DateTime.now().add(Duration(days: i));
      forecasts.add(
        WeatherForecast(
          dateTime: date,
          temperature: 30.0 + i,
          tempMin: 25.0 + i,
          tempMax: 35.0 + i,
          humidity: 70 - i * 5,
          description: 'Partly cloudy',
          main: 'Clouds',
          windSpeed: 10.0 + i,
          rainProbability: 0.3 + i * 0.1,
        ),
      );
    }
    return forecasts;
  }

  /// Mock weather data for a specific city
  WeatherData _getMockWeatherDataByCity(String cityName) {
    final now = DateTime.now();
    return WeatherData(
      city: cityName,
      country: 'IN',
      temperature: 28.0,
      feelsLike: 30.0,
      humidity: 70,
      pressure: 1013,
      windSpeed: 10.0,
      description: 'Partly cloudy',
      main: 'Clouds',
      cloudiness: 40,
      visibility: 8000,
      sunrise: now.subtract(const Duration(hours: 6)),
      sunset: now.add(const Duration(hours: 6)),
      latitude: 19.0760,
      longitude: 72.8777,
    );
  }
}
