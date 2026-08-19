import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'scanner_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _screens = const [
    ScannerScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // The scanner is a full-bleed camera canvas; the nav bar sits below it
    // rather than floating over it, so the capture controls stay reachable.
    final isScanner = _currentIndex == 0;

    return Scaffold(
      backgroundColor: isScanner ? Colors.black : null,
      body: IndexedStack(
        index: _currentIndex,
        sizing: StackFit.expand,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: AppBottomNav.defaultItems,
      ),
    );
  }
}
