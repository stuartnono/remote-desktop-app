import 'package:flutter/material.dart';
import 'settings.dart';
import 'ConnectPage.dart';
import 'FavoritesPage.dart';
import 'RemoteAccessPage.dart';
import 'sidebar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    RemoteAccessPage(),
    ConnectPage(),
    FavoritesPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Desktop App"),
      ),
      body: Row(
        children: [
          // Sidebar
          Sidebar(
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          // Main content area
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
    );
  }
}
