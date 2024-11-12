import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex; // Track the selected page index

  const Sidebar({required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220, // Slightly wider for better icon spacing
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Soft background color
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
      ),
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
      leading: Icon(
        icon,
        color: isSelected ? Colors.blueAccent : Colors.grey[700],
        size: 28, // Larger icon for better visibility
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? Colors.blueAccent : Colors.black87,
        ),
      ),
      onTap: () => onTap(index),
      tileColor: isSelected ? Colors.blue[50] : Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
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
