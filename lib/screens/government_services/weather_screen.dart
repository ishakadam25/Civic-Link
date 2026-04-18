import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/location_provider.dart';
import '../../widgets/weather_card.dart';
import '../../widgets/emergency_service_card.dart';
import '../../models/weather_model.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = context.read<LocationProvider>();
      
      if (!locationProvider.locationPermissionGranted) {
        await locationProvider.requestLocationPermission();
      }
      
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
          if (weatherProvider.isLoading &&
              weatherProvider.currentWeather == null) {
            return const LoadingStateWidget(message: 'Fetching weather...');
          }

          // Show error state
          if (weatherProvider.error != null &&
              weatherProvider.currentWeather == null) {
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

          // If weather data is not yet available, show a loading placeholder
          if (weatherProvider.currentWeather == null) {
            return const LoadingStateWidget(message: 'Fetching weather...');
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

            child: SafeArea(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                // Current weather card
                if (weatherProvider.currentWeather != null) ...[
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
                  const SizedBox(height: 16),
                  _buildWeatherInsight(weatherProvider.currentWeather!),
                ],
                const SizedBox(height: 24),

                // Forecast section
                if (weatherProvider.forecast.isNotEmpty) ...[
                  const Text(
                    '5-Day Forecast',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                if (weatherProvider.currentWeather != null) ...[
                  const Text(
                    'Weather Information',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            _formatTime(
                              weatherProvider.currentWeather!.sunrise,
                            ),
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
              ],
            ),
            )
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
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Format time for display
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  /// Build dynamic weather insight message
  Widget _buildWeatherInsight(WeatherData weather) {
    String insightMessage = '';
    IconData insightIcon = Icons.info_outline;
    Color insightColor = Colors.blue;

    final condition = weather.main.toLowerCase();
    final description = weather.description.toLowerCase();

    if (weather.temperature > 35.0) {
      insightMessage = 'High temperature, stay hydrated';
      insightIcon = Icons.local_drink;
      insightColor = Colors.orange;
    } else if (condition.contains('rain') || description.contains('rain') || condition.contains('drizzle')) {
      insightMessage = 'Carry an umbrella';
      insightIcon = Icons.umbrella;
      insightColor = Colors.blueGrey;
    } else if (weather.temperature < 15.0) {
      insightMessage = 'It is getting cold, wear a jacket';
      insightIcon = Icons.ac_unit;
      insightColor = Colors.cyan;
    } else {
      insightMessage = 'Pleasant weather, enjoy your day!';
      insightIcon = Icons.wb_sunny;
      insightColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: insightColor.withOpacity(0.1),
        border: Border.all(color: insightColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(insightIcon, color: insightColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              insightMessage,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
