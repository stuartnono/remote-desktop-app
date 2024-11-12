import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    _loadLoginStatus(); // Load login status on start
  }

  // Load login status from SharedPreferences
  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  // Function to handle login success
  Future<void> _onLoginSuccess() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Save login status
    setState(() {
      _isLoggedIn = true;
      _currentIndex = 0; // Display RemoteAccessPage
    });
  }

  // Function to handle logout
  Future<void> _onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Clear login status
    setState(() {
      _isLoggedIn = false;
      _currentIndex = 0; // Reset to the login page
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      RemoteAccessPage(onLoginSuccess: _onLoginSuccess, onLogout: _onLogout),
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
          // Show sidebar only if logged in
          if (_isLoggedIn)
            Sidebar(
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              currentIndex: _currentIndex,
            ),
          // Display the selected page in the main content area
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
