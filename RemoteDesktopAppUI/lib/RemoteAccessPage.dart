import 'package:flutter/material.dart';

class RemoteAccessPage extends StatefulWidget {
  @override
  _RemoteAccessPageState createState() => _RemoteAccessPageState();
}

class _RemoteAccessPageState extends State<RemoteAccessPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoggedIn = false;

  void _login() {
    if (_usernameController.text == 'user' && _passwordController.text == 'pass') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful")),
      );
      setState(() {
        _isLoggedIn = true;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Login Failed"),
          content: Text("Invalid username or password."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
          ],
        ),
      );
    }
  }

  void _logout() {
    setState(() {
      _isLoggedIn = false;
      _usernameController.clear();
      _passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: _isLoggedIn ? _buildDeviceInfo() : _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.desktop_windows, color: Colors.blue, size: 60),
        SizedBox(height: 15),
        Text(
          "Remote Access",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Text(
          "Access your computer remotely, wherever you are.",
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: "Username",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 15),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: _login,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text("Login", style: TextStyle(fontSize: 16)),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Connected Device", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Row(
          children: [
            Icon(Icons.computer, color: Colors.blue, size: 40),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("PC Name: Office PC", style: TextStyle(fontSize: 18)),
                Text("IP Address: 192.168.1.10", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ],
            ),
          ],
        ),
        SizedBox(height: 20),
        Text("Recently Connected Device", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Device: Home Server\nIP: 192.168.1.15", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
        SizedBox(height: 30),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _logout,
            child: Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
