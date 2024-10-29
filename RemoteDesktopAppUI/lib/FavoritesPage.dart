import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> favoriteDevices = [
    {"name": "Office PC", "ip": "192.168.1.10"},
    {"name": "Home Server", "ip": "192.168.1.15"},
    {"name": "Workstation", "ip": "10.0.0.5"},
  ];

  List<Map<String, String>> filteredDevices = [];

  @override
  void initState() {
    super.initState();
    filteredDevices = favoriteDevices;
    _searchController.addListener(_filterDevices);
  }

  void _filterDevices() {
    setState(() {
      filteredDevices = favoriteDevices
          .where((device) => device["name"]!
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _connectToDevice(Map<String, String> device) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemoteControlPage(deviceName: device["name"]!, deviceIp: device["ip"]!),
      ),
    );
  }

  void _editDevice(BuildContext context, Map<String, String> device) {
    TextEditingController nameController = TextEditingController(text: device["name"]);
    TextEditingController ipController = TextEditingController(text: device["ip"]);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Device"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Device Name"),
              ),
              TextField(
                controller: ipController,
                decoration: InputDecoration(labelText: "IP Address"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  device["name"] = nameController.text;
                  device["ip"] = ipController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteDevice(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Device"),
          content: Text("Are you sure you want to delete this device?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoriteDevices.removeAt(index);
                  filteredDevices = List.from(favoriteDevices);
                });
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search devices...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDevices.length,
                itemBuilder: (context, index) {
                  final device = filteredDevices[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
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
                              _editDevice(context, device);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteDevice(context, index);
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _connectToDevice(device);
                            },
                            child: Text("Connect"),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class RemoteControlPage extends StatefulWidget {
  final String deviceName;
  final String deviceIp;

  RemoteControlPage({required this.deviceName, required this.deviceIp});

  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  bool isFullScreen = false;

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Remote Control - ${widget.deviceName}"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Video display area with toggle button inside
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black12,
                  child: Center(
                    child: Text(
                      "Video Stream for ${widget.deviceName} (${widget.deviceIp})",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                // Full-screen toggle button at bottom right
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                    onPressed: toggleFullScreen,
                    iconSize: 28,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          // Controls
          if (!isFullScreen)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Shutdown ${widget.deviceName}");
                    },
                    child: Text("Shutdown"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Restart ${widget.deviceName}");
                    },
                    child: Text("Restart"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Refresh ${widget.deviceName} screen");
                    },
                    child: Text("Refresh"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
