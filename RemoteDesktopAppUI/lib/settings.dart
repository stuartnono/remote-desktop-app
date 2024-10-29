import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.blue),
            title: Text("Enable Notifications"),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dark_mode, color: Colors.blue),
            title: Text("Enable Dark Mode"),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (bool value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.lock, color: Colors.blue),
            title: Text("Change Password"),
            onTap: () {
              // Navigate to Change Password screen
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangePasswordPage(),
              ));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text("About App"),
            onTap: () {
              // Show About dialog or navigate to an About page
              showAboutDialog(
                context: context,
                applicationName: "Remote Desktop App",
                applicationVersion: "1.0.0",
                applicationIcon: Icon(Icons.desktop_windows),
                children: [
                  Text("This app allows you to control remote devices securely and efficiently."),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Sample Change Password Page for demonstration
class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: Center(
        child: Text("Change Password Page"),
      ),
    );
  }
}
