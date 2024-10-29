import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex; // Track the selected page index

  const Sidebar({required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for sidebar
      color: Colors.grey[200],
      child: Column(
        children: [
          _buildSidebarItem(
            context,
            index: 0,
            title: "Remote Access",
            icon: Icons.screen_share,
          ),
          _buildSidebarItem(
            context,
            index: 1,
            title: "Connect",
            icon: Icons.connect_without_contact,
          ),
          _buildSidebarItem(
            context,
            index: 2,
            title: "Favorites",
            icon: Icons.star,
          ),
          Spacer(),
          _buildSidebarItem(
            context,
            index: 3,
            title: "Settings",
            icon: Icons.settings,
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context,
      {required int index, required String title, required IconData icon}) {
    final bool isSelected = index == currentIndex;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blueAccent : Colors.blue),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.blueAccent : Colors.black,
        ),
      ),
      onTap: () => onTap(index),
      tileColor: isSelected ? Colors.blue[50] : Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
      trailing: isSelected
          ? Container(
        width: 4,
        height: 20,
        color: Colors.blueAccent,
      )
          : null,
    );
  }
}
