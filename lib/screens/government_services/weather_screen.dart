import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/emergency_service_card.dart';

/// Screen to display weather information
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  /// Initialize weather data on screen load
  void _initializeWeather() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      if (locationProvider.currentLocation != null) {
        final weatherProvider = context.read<WeatherProvider>();
        weatherProvider.fetchWeather(
          locationProvider.currentLocation!.latitude,
          locationProvider.currentLocation!.longitude,
        );
        weatherProvider.fetchForecast(
          locationProvider.currentLocation!.latitude,
          locationProvider.currentLocation!.longitude,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
      ),
      body: Consumer2<LocationProvider, WeatherProvider>(
        builder: (context, locationProvider, weatherProvider, _) {
          // Check if location permission is granted
          if (!locationProvider.locationPermissionGranted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Location Permission Required',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please enable location permission to see weather for your area',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        await locationProvider.requestLocationPermission();
                      },
                      child: const Text('Enable Location'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Show loading state
          if (weatherProvider.isLoading && weatherProvider.currentWeather == null) {
            return const LoadingStateWidget(message: 'Fetching weather...');
          }

          // Show error state
          if (weatherProvider.error != null && weatherProvider.currentWeather == null) {
            return ErrorStateWidget(
              message: weatherProvider.error ?? 'Failed to load weather',
              onRetry: () {
                if (locationProvider.currentLocation != null) {
                  weatherProvider.fetchWeather(
                    locationProvider.currentLocation!.latitude,
                    locationProvider.currentLocation!.longitude,
                  );
                }
              },
            );
          }

          // Show weather data
          return RefreshIndicator(
            onRefresh: () async {
              if (locationProvider.currentLocation != null) {
                await weatherProvider.fetchWeather(
                  locationProvider.currentLocation!.latitude,
                  locationProvider.currentLocation!.longitude,
                );
                await weatherProvider.fetchForecast(
                  locationProvider.currentLocation!.latitude,
                  locationProvider.currentLocation!.longitude,
                );
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Current weather card
                if (weatherProvider.currentWeather != null)
                  WeatherCard(
                    weather: weatherProvider.currentWeather!,
                    onRefresh: () {
                      if (locationProvider.currentLocation != null) {
                        weatherProvider.fetchWeather(
                          locationProvider.currentLocation!.latitude,
                          locationProvider.currentLocation!.longitude,
                        );
                      }
                    },
                  ),
                const SizedBox(height: 24),
                
                // Forecast section
                if (weatherProvider.forecast.isNotEmpty) ...[
                  const Text(
                    '5-Day Forecast',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: weatherProvider.forecast.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: SizedBox(
                            width: 100,
                            child: WeatherForecastCard(
                              forecast: weatherProvider.forecast[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Additional information
                const Text(
                  'Weather Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          'Visibility',
                          '${(weatherProvider.currentWeather!.visibility / 1000).toStringAsFixed(1)} km',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Cloudiness',
                          '${weatherProvider.currentWeather!.cloudiness.toStringAsFixed(0)}%',
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Sunrise',
                          _formatTime(weatherProvider.currentWeather!.sunrise),
                        ),
                        const Divider(),
                        _buildInfoRow(
                          'Sunset',
                          _formatTime(weatherProvider.currentWeather!.sunset),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Build information row widget
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  /// Format time for display
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
