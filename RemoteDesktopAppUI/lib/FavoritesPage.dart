import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'globals.dart' as globals;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:web_socket_channel/io.dart';
import 'dart:typed_data';

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
  String? jwtToken;

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
          title: Text("Edit Device", style: TextStyle(fontWeight: FontWeight.bold)),
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
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  device["name"] = nameController.text;
                  device["ip"] = ipController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save", style: TextStyle(color: Colors.blue)),
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
              child: Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  favoriteDevices.removeAt(index);
                  filteredDevices = List.from(favoriteDevices);
                });
                Navigator.of(context).pop();
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
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
        title: Text("Favorites", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 0,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredDevices.length,
                itemBuilder: (context, index) {
                  final device = filteredDevices[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.computer, color: Colors.blue),
                      title: Text(device["name"] ?? "Unnamed Device", style: TextStyle(fontWeight: FontWeight.bold)),
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
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
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

// class RemoteControlPage extends StatefulWidget {
//   final String deviceName;
//   final String deviceIp;
//
//   const RemoteControlPage({required this.deviceName, required this.deviceIp});
//
//   @override
//   _RemoteControlPageState createState() => _RemoteControlPageState();
// }
//
// class _RemoteControlPageState extends State<RemoteControlPage> {
//   late WebSocketChannel _channel;
//   bool isFullScreen = false;
//   final String? jwtToken = globals.jwtToken;
//   Uint8List? _imageData;
//
//   @override
//   void initState() {
//     super.initState();
//     _connectWebSocket();
//   }
//
//   void toggleFullScreen() {
//     setState(() {
//       isFullScreen = !isFullScreen;
//     });
//   }
//
//   // Prompt dialog for confirmation before shutting down or restarting
//   Future<void> _confirmAction(String action) async {
//     bool confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm $action"),
//           content: Text("Are you sure you want to $action?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // User cancels
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // User confirms
//               },
//               child: Text("Yes"),
//             ),
//           ],
//         );
//       },
//     ) ?? false;
//
//     if (confirmed) {
//       _sendRequest(action);
//     }
//   }
//
//   // void _connectWebSocket() {
//   //   try {
//   //     HttpClient client = HttpClient();
//   //     client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//   //     final ioClient = IOWebSocketChannel.connect(
//   //       Uri.parse('wss://localhost:5000?token=$jwtToken'),
//   //       customClient: client,
//   //     );
//   //
//   //     _channel = ioClient;
//   //
//   //     _channel.stream.listen(
//   //           (data) {
//   //         setState(() {
//   //           _imageData = data as Uint8List;
//   //         });
//   //       },
//   //       onError: (error) {
//   //         print('WebSocket error: $error');
//   //       },
//   //       onDone: () {
//   //         print('WebSocket connection closed');
//   //       },
//   //     );
//   //   } catch (e) {
//   //     print('Error connecting to WebSocket: $e');
//   //   }
//   // }
//   void _connectWebSocket() {
//     try {
//       HttpClient client = HttpClient();
//       client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//       final ioClient = IOWebSocketChannel.connect(
//         Uri.parse('wss://localhost:5000?token=$jwtToken'),
//         customClient: client,
//       );
//
//       _channel = ioClient;
//
//       _channel.stream.listen(
//             (data) {
//           setState(() {
//             _imageData = data as Uint8List;
//           });
//         },
//         onError: (error) {
//           print('WebSocket error: $error');
//         },
//         onDone: () {
//           print('WebSocket connection closed');
//         },
//       );
//     } catch (e) {
//       print('Error connecting to WebSocket: $e');
//     }
//   }
//
//
//   void _sendMouseMove(int x, int y) {
//     _channel.sink.add({'action': 'mouseMove', 'x': x, 'y': y});
//   }
//
//   void _sendKeyPress(String key) {
//     _channel.sink.add({'action': 'keyPress', 'key': key});
//   }
//
//   @override
//   void dispose() {
//     _channel.sink.close();
//     super.dispose();
//   }
//
//   Future<void> _sendRequest(String action) async {
//     HttpClient client = HttpClient();
//     client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//     final ioClient = IOClient(client);
//
//     print("Token in _sendRequest: $jwtToken");
//
//     final url = Uri.parse('https://localhost:5000/api/$action');
//
//     if (jwtToken == null) {
//       print("Token not found. Unable to perform $action.");
//       return;
//     }
//
//     final response = await ioClient.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $jwtToken',
//       },
//     );
//
//     if (response.statusCode == 200) {
//       print("$action initiated.");
//     } else {
//       print("Error performing $action. Status code: ${response.statusCode}");
//       print("Response: ${response.body}");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: isFullScreen
//           ? null
//           : AppBar(
//         title: Text("Remote Control - ${widget.deviceName}"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GestureDetector(
//               onPanUpdate: (details) {
//                 _sendMouseMove(details.localPosition.dx.toInt(), details.localPosition.dy.toInt());
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Container(
//                     color: Colors.black,
//                     child: _imageData == null
//                         ? Center(child: CircularProgressIndicator())
//                         : Image.memory(_imageData!),
//                   ),
//                   Positioned(
//                     bottom: 16,
//                     right: 16,
//                     child: IconButton(
//                       icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
//                       onPressed: toggleFullScreen,
//                       iconSize: 28,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (!isFullScreen) ...[
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildActionButton("Shutdown", Colors.red, () => _confirmAction('shutdown')),
//                   _buildActionButton("Restart", Colors.orange, () => _confirmAction('restart')),
//                   _buildActionButton("Refresh", Colors.blue, () {
//                     print("Refresh ${widget.deviceName} screen");
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       child: Text(label),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: color,
//         foregroundColor: Colors.white,
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//     );
//   }
// }
class RemoteControlPage extends StatefulWidget {
  final String deviceName;
  final String deviceIp;

  RemoteControlPage({required this.deviceName, required this.deviceIp});

  @override
  _RemoteControlPageState createState() => _RemoteControlPageState();
}

class _RemoteControlPageState extends State<RemoteControlPage> {
  late WebSocketChannel _channel;
  bool isFullScreen = false;
  final String? jwtToken = globals.jwtToken; // Assuming token is stored in globals
  Uint8List? _imageData;
  WebSocket? _webSocket;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _connectWebSocket();
  }

  void toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  // Prompt dialog for confirmation before shutting down or restarting
  Future<void> _confirmAction(String action) async {
    bool confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm $action"),
          content: Text("Are you sure you want to $action?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User cancels
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    ) ?? false;

    if (confirmed) {
      _sendRequest(action);
    }
  }


  void _connectWebSocket() async {

    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    WebSocket.connect('wss://localhost:5000/socket.io/?token=$jwtToken', customClient: client)
        .then((webSocket) {
      _webSocket = webSocket;
      _webSocket!.listen((message) {
        print('Received data: $message');
      }, onError: (error) {
        print('WebSocket error: $error');
      }, onDone: () {
        print('WebSocket connection closed');
      });
    }).catchError((e) {
      print('Error connecting to WebSocket: $e');
    });

  }

  void _sendMouseMove(int x, int y) {
    _channel.sink.add({'action': 'mouseMove', 'x': x, 'y': y});
  }

  void _sendKeyPress(String key) {
    _channel.sink.add({'action': 'keyPress', 'key': key});
  }

  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  Future<void> _sendRequest(String action) async {

    HttpClient client = HttpClient();
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(client);

    print("Token in _sendRequest: $jwtToken");

    if (jwtToken == null) {
      print("Token not found. Unable to perform $action.");
      return;
    }

    final url = Uri.parse('https://localhost:5000/api/$action');

    final response = await ioClient.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      print("$action initiated.");
    } else {
      print("Error performing $action. Status code: ${response.statusCode}");
      print("Response: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isFullScreen
          ? null
          : AppBar(
        title: Text("Remote Control - ${widget.deviceName}"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                _sendMouseMove(details.localPosition.dx.toInt(), details.localPosition.dy.toInt());
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.black,
                    child: _imageData == null
                        ? Center(child: CircularProgressIndicator())
                        : Image.memory(_imageData!),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: IconButton(
                      icon: Icon(isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                      onPressed: toggleFullScreen,
                      iconSize: 28,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isFullScreen) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton("Shutdown", Colors.red, () => _confirmAction('shutdown')),
                  _buildActionButton("Restart", Colors.orange, () => _confirmAction('restart')),
                  _buildActionButton("Refresh", Colors.blue, () {
                    print("Refresh ${widget.deviceName} screen");
                  }),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}




