import 'package:flutter/material.dart';
import '../screens/home_shell.dart';
import '../screens/onboarding_screen.dart';
import '../screens/result_screen.dart';
import '../screens/manual_entry_screen.dart';
import '../models/scan_result.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String result = '/result';
  static const String manualEntry = '/manual-entry';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(onComplete: () {}),
        );
      case home:
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case result:
        final scanResult = settings.arguments as ScanResult;
        return MaterialPageRoute(
          builder: (_) => ResultScreen(result: scanResult),
        );
      case manualEntry:
        return MaterialPageRoute(builder: (_) => const ManualEntryScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeShell());
    }
  }
}
