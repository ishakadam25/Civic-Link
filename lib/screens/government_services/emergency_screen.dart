import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/emergency_provider.dart';
import '../../providers/location_provider.dart';
import '../../models/emergency_model.dart';
import '../../widgets/emergency_service_card.dart';

/// Screen to display emergency services
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeEmergencyServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Initialize emergency services on screen load
  void _initializeEmergencyServices() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locationProvider = context.read<LocationProvider>();
      
      if (!locationProvider.locationPermissionGranted) {
        await locationProvider.requestLocationPermission();
      }
      
      if (locationProvider.currentLocation != null) {
        final emergencyProvider = context.read<EmergencyProvider>();
        emergencyProvider.fetchNearbyServices(
          locationProvider.currentLocation!.latitude,
          locationProvider.currentLocation!.longitude,
          radiusInMeters: 50000, // Increased to 50km to capture all mock data across Mumbai
        );
      }
    });
  }

  /// Make a phone call
  Future<void> _makeCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri(scheme: 'tel', path: cleanNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Handle SOS button press
  void _handleSOS() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency SOS'),
        content: const Text('Are you sure you want to call the emergency services?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
              final provider = context.read<EmergencyProvider>();
              if (provider.policeStations.isNotEmpty) {
                // Stations are already distance sorted, so first is nearest
                _makeCall(provider.policeStations.first.phoneNumber);
              } else {
                _makeCall('100');
              }
            },
            child: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Services'),
        elevation: 0,
        backgroundColor: Colors.red.shade600,
      ),
      body: Consumer2<LocationProvider, EmergencyProvider>(
        builder: (context, locationProvider, emergencyProvider, _) {
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
                      'Please enable location permission to find nearby emergency services',
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

          return Column(
            children: [
              // SOS Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    onPressed: _handleSOS,
                    icon: const Icon(Icons.warning_amber_rounded, size: 32),
                    label: const Text(
                      'SOS EMERGENCY',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              // Quick emergency contacts
              Container(
                color: Colors.red.shade50,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Emergency Contacts',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          QuickEmergencyButton(
                            contact: const QuickContact(
                              name: 'Police',
                              phoneNumber: '100',
                              category: 'Emergency',
                            ),
                            onPressed: () => _makeCall('100'),
                          ),
                          const SizedBox(width: 12),
                          QuickEmergencyButton(
                            contact: const QuickContact(
                              name: 'Ambulance',
                              phoneNumber: '102',
                              category: 'Emergency',
                            ),
                            onPressed: () => _makeCall('102'),
                          ),
                          const SizedBox(width: 12),
                          QuickEmergencyButton(
                            contact: const QuickContact(
                              name: 'Fire',
                              phoneNumber: '101',
                              category: 'Emergency',
                            ),
                            onPressed: () => _makeCall('101'),
                          ),
                          const SizedBox(width: 12),
                          QuickEmergencyButton(
                            contact: const QuickContact(
                              name: 'Women Helpline',
                              phoneNumber: '1091',
                              category: 'Women Safety',
                            ),
                            onPressed: () => _makeCall('1091'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Tabs for different service types
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Police'),
                  Tab(text: 'Hospitals'),
                  Tab(text: 'Ambulance'),
                  Tab(text: 'Fire'),
                ],
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
              ),
              const SizedBox(height: 12),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Police stations
                    _buildServicesList(
                      emergencyProvider.policeStations,
                      emergencyProvider.isLoading,
                      emergencyProvider.error,
                      onRetry: () {
                        if (locationProvider.currentLocation != null) {
                          emergencyProvider.fetchNearbyServices(
                            locationProvider.currentLocation!.latitude,
                            locationProvider.currentLocation!.longitude,
                          );
                        }
                      },
                    ),
                    // Hospitals
                    _buildServicesList(
                      emergencyProvider.hospitals,
                      emergencyProvider.isLoading,
                      emergencyProvider.error,
                      onRetry: () {
                        if (locationProvider.currentLocation != null) {
                          emergencyProvider.fetchNearbyServices(
                            locationProvider.currentLocation!.latitude,
                            locationProvider.currentLocation!.longitude,
                          );
                        }
                      },
                    ),
                    // Ambulances
                    _buildServicesList(
                      emergencyProvider.ambulances,
                      emergencyProvider.isLoading,
                      emergencyProvider.error,
                      onRetry: () {
                        if (locationProvider.currentLocation != null) {
                          emergencyProvider.fetchNearbyServices(
                            locationProvider.currentLocation!.latitude,
                            locationProvider.currentLocation!.longitude,
                          );
                        }
                      },
                    ),
                    // Fire stations
                    _buildServicesList(
                      emergencyProvider.fireStations,
                      emergencyProvider.isLoading,
                      emergencyProvider.error,
                      onRetry: () {
                        if (locationProvider.currentLocation != null) {
                          emergencyProvider.fetchNearbyServices(
                            locationProvider.currentLocation!.latitude,
                            locationProvider.currentLocation!.longitude,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Build services list widget
  Widget _buildServicesList(
    List<EmergencyService> services,
    bool isLoading,
    String? error, {
    VoidCallback? onRetry,
  }) {
    if (isLoading && services.isEmpty) {
      return const LoadingStateWidget(message: 'Finding nearby services...');
    }

    if (error != null && services.isEmpty) {
      return ErrorStateWidget(
        message: error,
        onRetry: onRetry,
      );
    }

    if (services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_off,
                size: 48,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text('No services found nearby'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    EmergencyService? recommendedService;
    if (services.isNotEmpty) {
      recommendedService = services.reduce((curr, next) {
        final scoreCurr = (curr.rating ?? 0) / (curr.distanceInKm > 0 ? curr.distanceInKm : 0.1);
        final scoreNext = (next.rating ?? 0) / (next.distanceInKm > 0 ? next.distanceInKm : 0.1);
        return scoreCurr > scoreNext ? curr : next;
      });
    }

    return RefreshIndicator(
      onRefresh: () async {
        onRetry?.call();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return EmergencyServiceCard(
            service: service,
            isRecommended: service == recommendedService,
            onCall: () => _makeCall(service.phoneNumber),
            onNavigate: () {
              // Navigate to location using Google Maps directions
              final mapsUrl =
                  'https://www.google.com/maps/dir/?api=1&destination=${service.latitude},${service.longitude}';
              launchUrl(Uri.parse(mapsUrl), mode: LaunchMode.externalApplication);
            },
          );
        },
      ),
    );
  }
}
