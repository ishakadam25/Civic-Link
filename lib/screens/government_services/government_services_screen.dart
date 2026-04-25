import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';
import 'weather_screen.dart';
import 'emergency_screen.dart';
import 'package:url_launcher/url_launcher.dart';

/// Main government services screen with navigation to features

void openMIndicator() async {
  final url = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.mobond.mindicator',
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class GovernmentServicesScreen extends StatefulWidget {
  const GovernmentServicesScreen({super.key});

  @override
  State<GovernmentServicesScreen> createState() =>
      _GovernmentServicesScreenState();
}

class _GovernmentServicesScreenState extends State<GovernmentServicesScreen> {
  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Government Services Help'),
          content: const Text(
            'Use this section to access local services, emergency contacts, travel tools, '
            'and quick help guidance. Tap any card to open the service or learn more.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _requestLocationPermission() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = context.read<LocationProvider>();
      if (!locationProvider.locationPermissionGranted) {
        locationProvider.requestLocationPermission();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Services'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B5CE8), Color(0xFF6F8AE4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Government Services',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Access weather, emergency support, and city resources in one place.',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  Consumer<LocationProvider>(
                    builder: (context, locationProvider, _) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              locationProvider.locationPermissionGranted
                                  ? Icons.location_on
                                  : Icons.location_off,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                locationProvider.locationPermissionGranted
                                    ? 'Location enabled for local services'
                                    : 'Enable location for better recommendations',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (!locationProvider.locationPermissionGranted)
                              TextButton(
                                onPressed: () {
                                  locationProvider.requestLocationPermission();
                                },
                                child: const Text(
                                  'Enable',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Quick access',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      _buildServiceCard(
                        context,
                        title: 'Weather',
                        icon: '🌤',
                        description: 'Check local forecasts',
                        color: Colors.blue,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const WeatherScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        title: 'Emergency',
                        icon: '🚨',
                        description: 'Nearby support services',
                        color: Colors.red,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const EmergencyScreen(),
                            ),
                          );
                        },
                      ),
                      _buildServiceCard(
                        context,
                        title: 'Travel',
                        icon: '🚆',
                        description: 'Open transit options',
                        color: Colors.deepPurple,
                        onTap: openMIndicator,
                      ),
                      _buildServiceCard(
                        context,
                        title: 'Help',
                        icon: '💡',
                        description: 'City guidance, support and FAQs',
                        color: Colors.teal,
                        onTap: _showHelpDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Why this matters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoItem(
                            'Weather Updates',
                            'Real-time forecasts and alert notifications for your area.',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            'Emergency Services',
                            'Direct access to nearby police, hospitals, and ambulances.',
                          ),
                          const SizedBox(height: 12),
                          _buildInfoItem(
                            'Quick Contacts',
                            'Save time with easy access to local helpline numbers.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required String title,
    required String icon,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(icon, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const Spacer(),
            Text(
              description,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }
}
