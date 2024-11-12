import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class RemoteAccessPage extends StatefulWidget {
  final Function onLoginSuccess;
  final Function onLogout;

  RemoteAccessPage({required this.onLoginSuccess, required this.onLogout});

  @override
  _RemoteAccessPageState createState() => _RemoteAccessPageState();
}

class _RemoteAccessPageState extends State<RemoteAccessPage> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables
  bool _isLoggedIn = false;
  String? _jwtToken;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if a valid JWT token exists in SharedPreferences to persist login state
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwtToken');
    if (token != null && token.isNotEmpty) {
      setState(() {
        globals.jwtToken = token;
        globals.isLoggedIn = true;  // Make sure this is updated here as well
        _isLoggedIn = true;  // Update the local state variable
      });
    } else {
      setState(() {
        _isLoggedIn = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isLoggedIn ? _buildDeviceInfo() : _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  // Save token function
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', token);
    globals.jwtToken = token;
    globals.isLoggedIn = true;
    print("Token saved: $token");
  }

  // Build login form
  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.blue,
          ),
          SizedBox(height: 20),
          Text(
            "Login",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            ),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _login,
            child: Text("Login"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: _showCreateAccountDialog,
            child: Text("Don't have an account? Register here"),
          ),
        ],
      ),
    );
  }

  // Build device info section after login
  Widget _buildDeviceInfo() {
    return Column(
      children: [
        Icon(
          Icons.devices,
          size: 100,
          color: Colors.blue,
        ),
        SizedBox(height: 20),
        Text(
          "Device Information",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          "Welcome! You are logged in.",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: _logout,
          child: Text("Logout"),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Account creation logic
  Future<void> _createAccount(String username, String password, String email) async {
    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final ioClient = IOClient(client);

      final response = await ioClient.post(
        Uri.parse('https://localhost:5000/api/register'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Account created successfully!")));
      } else {
        _showErrorDialog("Registration Failed", "Unable to create account.");
      }
    } catch (e) {
      _showErrorDialog("Error", "Failed to connect to server: $e");
    }
  }

// Login logic
  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorDialog("Validation Error", "Username and password are required.");
      return;
    }

    if (_passwordController.text.length < 6) {
      _showErrorDialog("Validation Error", "Password must be at least 6 characters.");
      return;
    }

    try {
      HttpClient client = HttpClient();
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final ioClient = IOClient(client);

      final response = await ioClient.post(
        Uri.parse('https://localhost:5000/api/login'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token']);  // Save token globally and in SharedPreferences
        setState(() {
          globals.isLoggedIn = true;
          _isLoggedIn = true;  // Update local state when login is successful
        });
        widget.onLoginSuccess();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
      } else {
        _showErrorDialog("Login Failed", "Invalid username or password.");
      }
    } catch (e) {
      _showErrorDialog("Error", "Failed to connect to server: $e");
    }
  }

  // Logout logic
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwtToken');
    setState(() {
      globals.isLoggedIn = false;
      globals.jwtToken = null;
      _isLoggedIn = false;  // Update local state when logged out
      _usernameController.clear();
      _passwordController.clear();
    });
    widget.onLogout();
  }

  // Show create account dialog with validation
  void _showCreateAccountDialog() {
    final TextEditingController _newUsernameController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    final TextEditingController _newEmailController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) {
      return AlertDialog(
          title: Text("Create Account"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _newUsernameController,
                  decoration: InputDecoration(labelText: "Username"),
                ),
                TextField(
                  controller: _newEmailController,
                  decoration: InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
          TextButton(
          onPressed: () => Navigator.pop(context),
    child: Text("Cancel"),
    ),
    TextButton(
    onPressed: () {
    if (_validateAccountFields(
      _newUsernameController.text,
      _newPasswordController.text,
      _confirmPasswordController.text,
      _newEmailController.text,
    )) {
      _createAccount(
        _newUsernameController.text,
        _newPasswordController.text,
        _newEmailController.text,
      );
    }
    },
      child: Text("Create Account"),
    ),
          ],
      );
        },
    );
  }

  // Validate account creation fields
  bool _validateAccountFields(String username, String password, String confirmPassword, String email) {
    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty || email.isEmpty) {
      _showErrorDialog("Validation Error", "All fields are required.");
      return false;
    }
    if (password != confirmPassword) {
      _showErrorDialog("Validation Error", "Passwords do not match.");
      return false;
    }
    if (password.length < 6) {
      _showErrorDialog("Validation Error", "Password must be at least 6 characters.");
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showErrorDialog("Validation Error", "Invalid email format.");
      return false;
    }
    return true;
  }

  // Show an error dialog with a title and message
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
}
