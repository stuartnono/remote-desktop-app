import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onTap;

  const Sidebar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for sidebar
      color: Colors.grey[200],
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.screen_share, color: Colors.blue),
            title: Text("Remote Access"),
            onTap: () => onTap(0),
          ),
          ListTile(
            leading: Icon(Icons.connect_without_contact, color: Colors.blue),
            title: Text("Connect"),
            onTap: () => onTap(1),
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.blue),
            title: Text("Favorites"),
            onTap: () => onTap(2),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue),
            title: Text("Settings"),
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}
