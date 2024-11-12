import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectPage extends StatefulWidget {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final TextEditingController _remotePinController = TextEditingController();
  String? _generatedCode;

  @override
  void initState() {
    super.initState();
    _loadGeneratedCode(); // Load code from SharedPreferences when the widget initializes
  }

  // Function to generate a random code with some hashes and store it in SharedPreferences
  Future<void> _generateCode() async {
    final random = Random();
    final code = 'PC-${random.nextInt(900000) + 100000}#${random.nextInt(900)}'; // Sample code with random digits and a hash

    // Save the code to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('generated_code', code);

    setState(() {
      _generatedCode = code;
    });
  }

  // Function to load the generated code from SharedPreferences
  Future<void> _loadGeneratedCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _generatedCode = prefs.getString('generated_code');
    });
  }

  // Validate the entered PIN
  void _validatePin() {
    if (_remotePinController.text == _generatedCode) {
      // Show error if the PIN matches the generated code
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("The entered PIN cannot be the generated code."),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Proceed with connection logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connecting to the remote device..."),
          backgroundColor: Colors.green,
        ),
      );
      // Add your connection logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connect"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: This Device
                Row(
                  children: [
                    Icon(Icons.computer, color: Colors.blue, size: 40),
                    SizedBox(width: 16),
                    Text(
                      "This Device",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Generate a session code to allow others to connect.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      // Display the generated code if available
                      if (_generatedCode != null)
                        Text(
                          'Code: $_generatedCode',
                          style: TextStyle(fontSize: 18, color: Colors.blue),
                        ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton.icon(
                          onPressed: _generateCode, // Generate a new code on button press
                          icon: Icon(Icons.code),
                          label: Text("Generate Code"),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.indigo,
                            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                Divider(
                  height: 40,
                  thickness: 1,
                  color: Colors.grey[300],
                ),
                // Section: Remote Device
                Row(
                  children: [
                    Icon(Icons.devices, color: Colors.blue, size: 40),
                    SizedBox(width: 16),
                    Text(
                      "Remote Device",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Connect to a remote device by entering the PIN provided.",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _remotePinController,
                  decoration: InputDecoration(
                    labelText: 'Enter PIN',
                    hintText: 'Enter the remote device PIN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      onPressed: _validatePin, // Validate PIN on button press
                      child: Text("Connect"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
