import 'package:flutter/material.dart';
import 'screens/input_screen.dart';
import 'screens/history_screen.dart';
import 'screens/about_screen.dart';
import 'models/affordability_result.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const RentWiseApp());
}

class RentWiseApp extends StatelessWidget {
  const RentWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RentWise',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2196F3),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}

/// Main navigation shell with bottom nav bar.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // Shared history list across screens
  List<AffordabilityResult> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// Load saved history from shared_preferences.
  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = prefs.getStringList('history') ?? [];
    setState(() {
      _history = historyStrings
          .map((json) => AffordabilityResult.fromJson(json))
          .toList();
    });
  }

  /// Save the current history list to shared_preferences.
  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyStrings = _history.map((r) => r.toJson()).toList();
    await prefs.setStringList('history', historyStrings);
  }

  /// Called when a new calculation is completed on the Input screen.
  void _addToHistory(AffordabilityResult result) {
    setState(() {
      _history.insert(0, result);
    });
    _saveHistory();
  }

  /// Clear all history.
  void _clearHistory() {
    setState(() {
      _history.clear();
    });
    _saveHistory();
  }

  @override
  Widget build(BuildContext context) {
    // Build screens, passing callbacks as needed
    final List<Widget> screens = [
      InputScreen(onCalculate: _addToHistory),
      HistoryScreen(history: _history, onClear: _clearHistory),
      const AboutScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.edit_note),
            selectedIcon: Icon(Icons.edit_note, color: Color(0xFF2196F3)),
            label: 'Input',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.history, color: Color(0xFF2196F3)),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info, color: Color(0xFF2196F3)),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
