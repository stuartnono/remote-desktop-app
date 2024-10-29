import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  // Sample data to represent favorite devices
  final List<Map<String, String>> favoriteDevices = [
    {"name": "Office PC", "ip": "192.168.1.10"},
    {"name": "Home Server", "ip": "192.168.1.15"},
    {"name": "Workstation", "ip": "10.0.0.5"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Favorites", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteDevices.length,
              itemBuilder: (context, index) {
                final device = favoriteDevices[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.computer, color: Colors.blue),
                    title: Text(device["name"] ?? "Unnamed Device"),
                    subtitle: Text(device["ip"] ?? "Unknown IP"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            // Handle edit action
                            _editDevice(context, device);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete action
                            _deleteDevice(context, index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Handle connect action
                      _connectToDevice(device);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _connectToDevice(Map<String, String> device) {
    // Logic to connect to the selected device
    print("Connecting to ${device["name"]} at ${device["ip"]}");
  }

  void _editDevice(BuildContext context, Map<String, String> device) {
    // Logic to edit the selected device (e.g., show a dialog to edit name and IP)
    print("Editing device: ${device["name"]}");
  }

  void _deleteDevice(BuildContext context, int index) {
    // Logic to delete the selected device
    print("Deleting device at index $index");
  }
}
