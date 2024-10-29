import 'package:flutter/material.dart';
import 'settings.dart';
import 'ConnectPage.dart';
import 'FavoritesPage.dart';
import 'RemoteAccessPage.dart';
import 'sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  // Toggle dark mode setting
  void toggleDarkMode(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainPage(onDarkModeToggle: toggleDarkMode),
    );
  }
}

class MainPage extends StatefulWidget {
  final Function(bool) onDarkModeToggle;

  const MainPage({super.key, required this.onDarkModeToggle});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Navigate back to the login screen
  void _navigateToLogin() {
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      RemoteAccessPage(),
      ConnectPage(),
      FavoritesPage(),
      SettingsPage(onDarkModeToggle: widget.onDarkModeToggle),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Desktop App"),
      ),
      body: Row(
        children: [
          // Sidebar for navigation
          Sidebar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
          ),
          // Display the selected page in main content area
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
