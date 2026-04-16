import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

/// Provider for managing weather state and operations
class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;

  WeatherData? _currentWeather;
  List<WeatherForecast> _forecast = [];
  bool _isLoading = false;
  String? _error;

  WeatherProvider(this._weatherService);

  // Getters
  WeatherData? get currentWeather => _currentWeather;
  List<WeatherForecast> get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Fetch weather for a specific location
  Future<void> fetchWeather(double latitude, double longitude) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final weather = await _weatherService.getCurrentWeather(latitude, longitude);
      _currentWeather = weather;
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch weather: ${e.toString()}';
      _currentWeather = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch weather forecast for a specific location
  Future<void> fetchForecast(double latitude, double longitude) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final forecast = await _weatherService.getWeatherForecast(latitude, longitude);
      _forecast = forecast;
      _error = null;
    } catch (e) {
      _error = 'Failed to fetch forecast: ${e.toString()}';
      _forecast = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeather(_currentWeather!.latitude, _currentWeather!.longitude);
    }
  }
}
