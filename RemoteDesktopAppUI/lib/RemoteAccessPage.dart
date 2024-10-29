import 'package:flutter/material.dart';

class RemoteAccessPage extends StatelessWidget {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon or Image at the top
                  Icon(
                    Icons.desktop_windows,
                    color: Colors.blue,
                    size: 60,
                  ),
                  SizedBox(height: 15),

                  // Title
                  Text(
                    "Remote Access",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 15),

                  // Description
                  Text(
                    "Access your computer remotely, wherever you are.",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 40),

                  // Access Button
                  ElevatedButton(
                    onPressed: () {
                      // Add your access logic here
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                      child: Text("Access now", style: TextStyle(fontSize: 16)),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
