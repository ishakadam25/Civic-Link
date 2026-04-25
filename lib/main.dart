import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'providers/locale_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'l10n/app_localizations.dart';

// Import all providers
import 'providers/weather_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/location_provider.dart';

// Import all services
import 'services/weather_service.dart';
import 'services/emergency_service.dart';
import 'services/location_service.dart';

// Import screens
import 'screens/chat/chatbot_screen.dart';
import 'screens/government_services/government_services_screen.dart';
import 'screens/citizen/home_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CivicLinkApp());
}

class CivicLinkApp extends StatefulWidget {
  const CivicLinkApp({super.key});

  @override
  State<CivicLinkApp> createState() => _CivicLinkAppState();
}

class _CivicLinkAppState extends State<CivicLinkApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocationService>(create: (_) => LocationService()),
        ChangeNotifierProvider<LocationProvider>(
          create: (context) => LocationProvider(context.read<LocationService>()),
        ),
        Provider<WeatherService>(create: (_) => WeatherService()),
        ChangeNotifierProvider<WeatherProvider>(
          create: (context) => WeatherProvider(context.read<WeatherService>()),
        ),
        Provider<EmergencyServiceAPI>(create: (_) => EmergencyServiceAPI()),
        ChangeNotifierProvider<EmergencyProvider>(
          create: (context) => EmergencyProvider(context.read<EmergencyServiceAPI>()),
        ),
        ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Civic Link',
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
              Locale('mr'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return supportedLocales.first;
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/gov-services': (context) => const GovernmentServicesScreen(),
              '/chatbot': (context) => const ChatBotScreen(),
            },
          );
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
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeScreen(role: widget.role),
      const GovernmentServicesScreen(),
      const ProfileScreen(),
      if (widget.role == 'admin') const AdminHomeScreen(),
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
    }

    return const [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.public), label: 'Services'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex >= _pages.length) {
      _selectedIndex = 0;
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const ChatBotScreen()),
          );
        },
        icon: const Icon(Icons.chat_bubble_outline),
        label: const Text('Ask Bot'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
