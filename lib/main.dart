/// Example of how to integrate Government Services into Civic-Link main.dart
///
/// This file shows the recommended way to set up providers and routes
/// for the Government Services feature.
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin/admin_home_screen.dart';

// Import all providers
import 'providers/weather_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/location_provider.dart';

// Import all services
import 'services/weather_service.dart';
import 'services/emergency_service.dart';
import 'services/location_service.dart';

// Import screens
import 'screens/government_services/government_services_screen.dart';
import 'screens/citizen/home_screen.dart';
import 'screens/profile/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CivicLinkApp());
}

class CivicLinkApp extends StatelessWidget {
  const CivicLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Location Service & Provider
        // Initialize LocationService first as it's a dependency
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) =>
              LocationProvider(context.read<LocationService>()),
        ),

        // Weather Service & Provider
        Provider<WeatherService>(create: (_) => WeatherService()),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(context.read<WeatherService>()),
        ),

        // Emergency Services API & Provider
        Provider<EmergencyServiceAPI>(create: (_) => EmergencyServiceAPI()),
        ChangeNotifierProvider<EmergencyProvider>(
          create: (context) =>
              EmergencyProvider(context.read<EmergencyServiceAPI>()),
        ),
      ],
      child: MaterialApp(
        title: 'Civic Link',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const LoginScreen(),
        routes: {
          '/gov-services': (context) => const GovernmentServicesScreen(),
        },
      ),
    );
  }
}

/// Example home screen showing how to access government services
class CivicLinkHome extends StatefulWidget {
  final String role;

  const CivicLinkHome({super.key, required this.role});

  @override
  State<CivicLinkHome> createState() => _CivicLinkHomeState();
}

class _CivicLinkHomeState extends State<CivicLinkHome> {
  int _selectedIndex = 0;

  // Pages for bottom navigation tabs
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      HomeScreen(role: widget.role),
      const GovernmentServicesScreen(),
      const ProfileScreen(),
      if (widget.role == 'admin') const AdminHomeScreen(), // only for admin
    ];
  }

  List<NavigationDestination> get _destinations {
    if (widget.role == 'admin') {
      return const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.public), label: 'Services'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
      ];
    } else {
      return const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.public), label: 'Services'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _destinations,
      ),
    );
  }
}

/* 
  INTEGRATION CHECKLIST:
  
  1. Copy this file to your project or merge with existing main.dart
  
  2. Update MultiProvider with your existing providers:
     - If you already have LocationProvider, merge the configuration
     - Ensure service instances are created only once (use Provider)
     - ChangeNotifierProviders should be created after their dependencies
  
  3. Add routes to your existing MaterialApp:
     - '/gov-services': const GovernmentServicesScreen(),
  
  4. Update BottomNavigationBar or Drawer:
     - Add navigation item for Government Services
     - Call Navigator.of(context).pushNamed('/gov-services')
  
  5. Set up API Keys:
     - Update lib/config/constants.dart with real API keys
     - Or use environment variables
  
  6. Configure Android/iOS Permissions:
     - Add location permissions to AndroidManifest.xml
     - Add location privacy strings to Info.plist
  
  7. Test the integration:
     - Run flutter pub get
     - Run the app and navigate to Government Services
     - Test weather and emergency features
     
  8. For production:
     - Replace mock data with real API calls
     - Implement error logging and analytics
     - Add caching for offline support
*/
